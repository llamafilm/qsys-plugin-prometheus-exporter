if not Properties then
  -- debug mode
  print('Exiting because we are not a plugin')
  return
end

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

function GetStreamDetails(rx_name)
  if DebugFunction then print("# Getting metrics from " .. rx_name) end
  local rx = Component.New(rx_name)
  local stream_details = rx['stream.details'].String

  local output = ''
  for line in stream_details:gmatch("[^\r\n]+") do
    for k,v in line:gmatch("(.*): (.*)") do
      -- use the right type: gauge vs counter
      if k == 'Enabled' or k == 'Connected' or k == 'DSCP' then
        output = output .. 'qsys_aes67_' .. k .. '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Count' then
        output = output .. 'qsys_aes67_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Accept Count' then
        output = output .. 'qsys_aes67_accept_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Drop Count' then
        output = output .. 'qsys_aes67_drop_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Missing Count' then
        output = output .. 'qsys_aes67_missing_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Duplicate Count' then
        output = output .. 'qsys_aes67_duplicate_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'On Time' then
        output = output .. 'qsys_aes67_ontime_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Too Late' then
        output = output .. 'qsys_aes67_late_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'PT Mismatch' then
        output = output .. 'qsys_aes67_pt_mismatch_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      elseif k == 'Size Mismatch' then
        output = output .. 'qsys_aes67_size_mismatch_count' ..  '{' .. 'block="' .. rx_name .. '"} ' .. v .. '\n'
      end
    end
  end

  return output
end -- end GetStreamDetails

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
              else
                local metric_name = 'qsys_' .. label .. '_' .. k
                -- only include TYPE once
                if not body:find(metric_name) then
                  -- use the right type: gauge vs counter
                  if k:find('current') or k:find('spread') then
                    body = body .. '# TYPE qsys_' .. label .. '_' .. k .. ' gauge\n'
                  else
                    body = body .. '# TYPE qsys_' .. label .. '_' .. k .. ' counter\n'
                  end
                end
                body = body .. 'qsys_' .. label ..'_' .. k ..  '{' .. 'dsp_core="' .. i .. '"} ' .. v .. '\n'
              end
            end
          end
        end
      end
    end

    -- ethernet interface details added in 9.12
    if (System.MajorVersion == '9' and tonumber(System.MinorVersion) >= 12) or tonumber(System.MajorVersion) > 9 then
      body = body .. '# HELP qsys_lan_speed The ethernet link speed in Mbps.\n'
      body = body .. '# TYPE qsys_lan_speed gauge\n'
      body = body .. '# HELP qsys_ptpv2_leader_state Boolean indicating the PTPv2 clock leader status for each interface.\n'
      body = body .. '# TYPE qsys_ptpv2_leader_state gauge\n'
      body = body .. '# HELP qsys_ptpv1_leader_state Boolean indicating the PTPv1 clock leader status for the Core.\n'
      body = body .. '# TYPE qsys_ptpv1_leader_state gauge\n'
      local v1_leader_state = 1
      if Status['ptpv1.dante'].String == 'Master' then
        v1_leader_state = 1
      end
      body = body .. 'qsys_ptpv1_leader_state ' .. v1_leader_state .. '\n'

      for _,iface in pairs({'a', 'b', 'aux'}) do
        local v2_leader_state = 0
        if Status['lan.' .. iface .. '.speed'] ~= nil then -- if interface physically exists
          if Status['lan.' .. iface .. '.state'].String == 'Master' then
            v2_leader_state = 1
          end
          body = body .. 'qsys_lan_speed{interface="lan_' .. iface .. '"} ' ..  tonumber(Status['lan.' .. iface .. '.speed'].String) .. '\n'
          body = body .. 'qsys_ptpv2_leader_state{interface="lan_' .. iface .. '"} ' .. v2_leader_state .. '\n'  
        end
      end
    end
  end

  -- provides same info as SNMP invDeviceStatusValue
  body = body .. '# HELP qsys_peripheral_status Status value 0-5 for each inventory peripheral\n'
  body = body .. '# TYPE qsys_peripheral_status gauge\n'
  for k,v in pairs(Design.GetInventory()) do
    body = body .. 'qsys_peripheral_status{invDeviceModel="' .. v.Model .. '",invDeviceName="' .. v.Name .. '",invDeviceType="' .. v.Type .. '",invLocation="' .. v.Location .. '"} ' .. math.floor(v.Status.Code) .. '\n'
  end

  -- include AES67 metrics for each Rx component in the design
  if #RxComponents > 0 then
    -- only include TYPE once even if there are many Rx components
    body = body .. '# TYPE qsys_aes67_Enabled gauge\n'
    body = body .. '# TYPE qsys_aes67_Connected_count gauge\n'
    body = body .. '# TYPE qsys_aes67_DSCP gauge\n'
    body = body .. '# TYPE qsys_aes67_count counter\n'
    body = body .. '# TYPE qsys_aes67_accept_count counter\n'
    body = body .. '# TYPE qsys_aes67_drop_count counter\n'
    body = body .. '# TYPE qsys_aes67_missing_count counter\n'
    body = body .. '# TYPE qsys_aes67_duplicate_count counter\n'
    body = body .. '# TYPE qsys_aes67_ontime_count counter\n'
    body = body .. '# TYPE qsys_aes67_late_count counter\n'
    body = body .. '# TYPE qsys_aes67_pt_mismatch_count counter\n'
    body = body .. '# TYPE qsys_aes67_size_mismatch_count counter\n'

    for _,rx_name in ipairs(RxComponents) do
      local aes67_metrics = GetStreamDetails(rx_name)
      body = body .. aes67_metrics
    end
  end

  -- include custom metrics if enabled in Properties
  local custom_metrics_count = Properties['Custom Metrics'].Value
  if DebugFunction then print("# We have " .. custom_metrics_count .. " custom metrics.") end
  for i=1,custom_metrics_count do
    local metric_name, metric_value
    -- Control names are different if there's only 1
    if custom_metrics_count == 1 then
      metric_name  = Controls['Metric Label'].String
      -- Percent type controls are measured as relative numbers
      if Controls['Metric Type'].Boolean then
        metric_value = Controls['Metric'].Position
      else
        metric_value = Controls['Metric'].Value
      end
    else
      metric_name  = Controls['Metric Label'][i].String
      if Controls['Metric Type'][i].Boolean then
        metric_value = Controls['Metric'][i].Position
      else
        metric_value = Controls['Metric'][i].Value
      end
    end
    if metric_name == '' then
      if DebugFunction then print('Skipping metric ' .. i .. ' because its name is blank.') end
    else
      -- Prometheus metric names may contain ASCII letters, digits, underscores, and colons.
      local cleaned_name = metric_name:gsub('[^a-zA-Z0-9_:]', '_')

      -- make sure we don't duplicate another metric name
      if body:match(cleaned_name) then
        Controls['Status'].Value = 2
        Controls['Status'].String = 'duplicate name: ' .. cleaned_name
        return "Error! duplicate metric: " .. cleaned_name
      else
        body = body .. 'qsys_' .. cleaned_name .. ' ' .. metric_value .. '\n'
      end
    end
  end
  Controls['Status'].Value = 0
  return body
end

function SocketHandler(sock, event) -- the arguments for this EventHandler are documented in the EventHandler definition of TcpSocket Properties
  if event == TcpSocket.Events.Data then
    local request = sock:ReadLine(TcpSocket.EOL.Custom, '\r\n\r\n')

    if not request then
      print('Error parsing request, did you use HTTPS by mistake?')
      Controls['Status'].Value = 2
      Controls['Status'].String = "Invalid HTTP request"
      return
    end

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

    Controls['Status'].Value = 0

  elseif event == TcpSocket.Events.Closed or
         event == TcpSocket.Events.Error or
         event == TcpSocket.Events.Timeout then
    -- remove reference of socket from table so it's available for garbage collection
    if DebugRx then print( "# TCP Socket Event: "..event ) end
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
  -- PeerAddress property was added in 9.8
  if (System.MajorVersion == '9' and tonumber(System.MinorVersion) >= 8) or tonumber(System.MajorVersion) > 9 then
    if DebugRx then print( "# Got connection from", SocketInstance.PeerAddress ) end
  else
    if DebugRx then print( "# Got connection") end
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

-- find all AES67 receivers in the design
RxComponents={}
for _,v in pairs(Components) do
  if v.Type == 'input_box' then
    table.insert(RxComponents,v.Name)
  end
end
if DebugFunction then print('AES67 Receivers:', Dump(RxComponents)) end

if Controls['Status'].Value == 0 then
  if DebugFunction then print(string.format('Listening on HTTP port %d', Controls.Port.Value)) end
  Server:Listen(Controls.Port.Value) -- This listen port is opened on all network interfaces
  Initialize()
end
