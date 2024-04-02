-- helper function for debugging
function Dump(o, indent)
  if indent == nil then indent = 0 end
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '\n' .. string.rep(' ', indent)  .. '['..k..'] = ' .. Dump(v, indent+2) .. ', '
    end
    return s .. ' }'
  else
    return tostring(o)
  end
end -- end Dump

function RemoveSocketFromTable(sock)
  for k,v in pairs(Sockets) do
    if v == sock then
      table.remove(Sockets, k)
      return
    end
  end
end

function CreateMetrics()
  local design = Design.GetStatus()

  local body = '# HELP qsys_chassis_temperature The current temperature, in Celsius, of the Core chassis.\n'
  body = body .. '# TYPE qsys_chassis_temperature gauge\n'
  body = body .. 'qsys_chassis_temperature ' .. Status['system.temperature'].Value .. '\n'

  body = body .. '# HELP qsys_core_status Number from 0 to 5. O=OK, 1=compromised, 2=fault, 3=not present, 4=missing, 5=initializing\n'
  body = body .. '# TYPE qsys_core_status gauge\n'
  body = body .. 'qsys_core_status ' .. math.floor(Status['status'].Value) .. '\n'

  body = body .. '# HELP qsys_core_info A metric with a constant \'1\' value with labels for textual data. Grandmaster is either Core name or the PTP Clock GUID\n'
  body = body .. '# TYPE qsys_core_info gauge\n'
  body = body .. 'qsys_core_info{ptp_grandmaster="' .. Status['grandmaster.name'].String .. '",ptp_parent_port="' .. Status['parent.port.name'].String .. '",version="' .. System.Version .. '",platform="' .. design.Platform .. '",design_code="' .. design.DesignCode .. '",design_name="' .. design.DesignName .. '"} 1' .. '\n'

  body = body .. '# HELP qsys_chassis_fan The current speed of the chassis fan in RPM.\n'
  body = body .. '# TYPE qsys_chassis_fan gauge\n'
  body = body .. 'qsys_chassis_fan ' ..  math.floor(Status['system.fan.1.speed'].Value) .. '\n'

  body = body .. '# HELP qsys_ptp_master boolean indicating if the Core is the Master Clock for the Q-SYS system or not. The Core can be the Master Clock even if the clock is synchronized to an external clock.\n'
  body = body .. '# TYPE qsys_ptp_master gauge\n'
  body = body .. 'qsys_ptp_master ' ..  math.floor(Status['clock.master'].Value) .. '\n'

  local clock_offset = tonumber(string.sub(Status['clock.offset'].String, 1, -3))
  if clock_offset then -- this doesn't exist in emulation mode
    body = body .. '# HELP qsys_ptp_clock_offset how much of an offset exists, in microseconds, between this Core and the Master Clock. If this Core is the Master Clock, the offset is zero\n'
    body = body .. '# TYPE qsys_ptp_clock_offset gauge\n'
    body = body .. 'qsys_ptp_clock_offset ' .. clock_offset  .. '\n'
  end

  body = body .. '# HELP qsys_processor_temperature The current temperature, in Celsius, of the Core processor.\n'
  body = body .. '# TYPE qsys_processor_temperature gauge\n'
  body = body .. 'qsys_processor_temperature ' ..  Status['processor.temperature'].Value .. '\n'

  if VerboseEnabled == 'True' and (not System.IsEmulating) then
    body = body .. '# HELP qsys_memory_usage The percentage of memory used.\n'
    body = body .. '# TYPE qsys_memory_usage gauge\n'
    body = body .. 'qsys_memory_usage ' ..  Status['memory.usage'].Value .. '\n'

    body = body .. '# HELP qsys_compute_control The percentage of non-DSP, control-only CPU usage\n'
    body = body .. '# TYPE qsys_compute_control gauge\n'
    body = body .. 'qsys_compute_control ' ..  Status['control.compute.usage'].Value .. '\n'

    body = body .. '# HELP qsys_compute_lua The percentage of CPU usage for script processing\n'
    body = body .. '# TYPE qsys_compute_lua gauge\n'
    body = body .. 'qsys_compute_lua ' ..  Status['lua.compute.usage'].Value .. '\n'

    body = body .. '# HELP qsys_compute_process The percentage of CPU usage for DSP, both Category 1 and Category 2 processing\n'
    body = body .. '# TYPE qsys_compute_process gauge\n'
    body = body .. 'qsys_compute_process ' ..  Status['process.compute.usage'].Value .. '\n'

    -- each core has either block or block512, not both
    local cpu_stats = {
      'cpu.status.audio.#.statistics',
      'cpu.status.block.#.512.statistics',
      'cpu.status.block.#.statistics',
      'cpu.status.param.#.statistics'
    }

    -- build list of available controls so we can skip any that don't exist (i.e. DSP 2)
    local controls = {}
    for _,v in ipairs(Component.GetControls(Status)) do
      controls[v.Name] = true
    end

    for _,stat in ipairs(cpu_stats) do
      -- iterate through DSP blocks 0,1,2
      for i = 0,2,1 do
        local full_stat = stat:gsub('#', i, 1)
        if controls[full_stat] ~= nil then
          local label = stat:gsub('cpu', 'dsp', 1):gsub('%.', '_', 2):gsub('%.#', '', 1):gsub('%.statistics', ''):gsub('_status_', '_'):gsub('%.512', '')
          for line in Status[full_stat].String:gmatch("[^\r\n]+") do
            for k,v in line:gmatch("(.*): (.*)") do
              if k:find('average') then
                -- skip
              elseif k:find('current') or k:find('spread') then
                body = body .. '# TYPE qsys_' .. label .. '_' .. k .. ' gauge\n'
                body = body .. 'qsys_' .. label ..'_' .. k .. '{' .. 'dsp_core="' .. i .. '"} ' .. v .. '\n'
              else
                body = body .. '# TYPE qsys_' .. label .. '_' .. k .. ' counter\n'
                body = body .. 'qsys_' .. label ..'_' .. k ..  '{' .. 'dsp_core="' .. i .. '"} ' .. v .. '\n'
              end
            end
          end
        end
      end
    end
  end

  -- provides same info as SNMP invDeviceStatusValue
  for k,v in pairs(Design.GetInventory()) do
    body = body .. 'qsys_peripheral_status{model="' .. v.Model .. '",name="' .. v.Name .. '",type="' .. v.Type .. '",location="' .. v.Location .. '"} ' .. math.floor(v.Status.Code) .. '\n'
  end

  return body
end

function SocketHandler(sock, event) -- the arguments for this EventHandler are documented in the EventHandler definition of TcpSocket Properties
  if event == TcpSocket.Events.Data then
    local request = sock:ReadLine(TcpSocket.EOL.Custom, '\r\n\r\n')
    local url, protocol = request:match('^[^ ]+ ([^ \r\n]+) (HTTP[0-9/.]+)')
    url = url:lower()
    if DebugRx then print('# Received ' .. protocol .. ' request ' .. url) end
    if(url == '/metrics') then
      local body = CreateMetrics()
      local payload = protocol .. ' 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\nDate: ' .. os.date() ..  '\r\nContent-Length: ' .. string.len(body) .. '\r\n\r\n' .. body
      sock:Write(payload)
    elseif(url == '/') then
      local body = '<html><head><title>Qsys Exporter</title><style>body {font-family:sans-serif; margin: 0;} header {  background-color: #e6522c;  color: #fff;  font-size: 1rem;  padding: 1rem;} main {padding: 1rem;} label {  display: inline-block;  width: 0.5em;}</style></head><body><header><h1>Qsys Core Exporter</h1></header><main><h2>Prometheus Exporter for Qsys Core</h2><div><ul><li><a href="/metrics">Metrics</a></li></ul></div></main></body></html>'
      local payload = protocol .. ' 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nDate: ' .. os.date() ..  '\r\nContent-Length: ' .. string.len(body) .. '\r\n\r\n' .. body
      sock:Write(payload)
    else
      local payload = protocol .. ' 404 Not Found\r\nDate: ' .. os.date() .. '\r\nContent-Length: 0\r\n\r\n'
      sock:Write(payload)
    end
  elseif event == TcpSocket.Events.Closed or
         event == TcpSocket.Events.Error or
         event == TcpSocket.Events.Timeout then
    -- remove reference of socket from table so it's available for garbage collection
    if DebugRx then print( "TCP Socket Event: "..event ) end
    RemoveSocketFromTable(sock)
  else
    print('something else:', event)
  end
end

function Initialize()
  if DebugFunction then print('Using component named:', Controls['Status Component Name'].String) end
  Status = Component.New(Controls['Status Component Name'].String)

  -- Find out if chosen status component is verbose enabled
  Components = Component.GetComponents()
  for _,v1 in ipairs(Components) do
    if v1.Name == Controls['Status Component Name'].String then
      for _,v2 in ipairs(v1.Properties) do
        if v2.Name == 'verbose' then
          VerboseEnabled = v2.Value
        end
      end
    end
  end
end

-- table to store connected client sockets
-- this is required so the sockets don't get garbage collected since there aren't any other references to them in the script
Sockets = {}
Server = TcpSocketServer.New()
Controls['Status'].Value = 5
Controls['Status Component Name'].EventHandler = Initialize

Server.EventHandler = function(SocketInstance) -- the properties of this socket instance are those of the TcpSocket library
  SocketInstance.ReadTimeout = 2
  if tonumber(System.MajorVersion) >= 9 and tonumber(System.MinorVersion) >= 8 then
    if DebugRx then print( "Got connection from", SocketInstance.PeerAddress ) end
  else
    if DebugRx then print( "Got connection") end
  end
  table.insert(Sockets, SocketInstance)
  SocketInstance.EventHandler = SocketHandler
end

--Debug level
DebugTx, DebugRx, DebugFunction = false, false, false
DebugPrint = Properties['Debug Print'].Value
if DebugPrint == 'Tx/Rx' then
  DebugTx, DebugRx = true, true
elseif DebugPrint == 'Tx' then
  DebugTx = true
elseif DebugPrint == 'Rx' then
  DebugRx = true
elseif DebugPrint == 'Function Calls' then
  DebugFunction = true
elseif DebugPrint == 'All' then
  DebugTx, DebugRx, DebugFunction = true, true, true
end

-- populate ComboBox with core_status type components (should be only 1 option)
StatusComponents={}
Components=Component.GetComponents()

for _,v in pairs(Components) do
  if v.Type == 'core_status' then
    table.insert(StatusComponents,v.Name)
  end
end
if DebugFunction then print('Status Components:', Dump(StatusComponents)) end
if #StatusComponents > 0 then
  Controls['Status Component Name'].Choices = StatusComponents
  Controls['Status Component Name'].String = StatusComponents[1]
  if System.IsEmulating then
    Controls['Status'].Value = 1
    Controls['Status'].String = 'Not functional in Emulation mode'
  else
    Controls['Status'].Value = 0
  end
else
  if DebugFunction then print("No Named Components in Design!") end
  Controls['Status'].Value = 2
  Controls['Status'].String = 'Status component not found.  Did you enable script access?'
end

if Controls['Status'].Value == 0 then
  if DebugFunction then print(string.format('Listening on HTTP port %d', Controls.Port.Value)) end
  Server:Listen(Controls.Port.Value) -- This listen port is opened on all network interfaces
  Initialize()
end
