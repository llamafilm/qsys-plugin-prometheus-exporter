-- Prometheus Exporter plugin
-- by Elliott Balsley

-- Information block for the plugin
--[[ #include "info.lua" ]]

-- Define the color of the plugin object in the design
function GetColor(props)
  return { 212, 236, 235 }
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
  return PluginInfo.Name
end

PageNames = { "Control" }  --List the pages within the plugin

-- Define User configurable Properties of the plugin
function GetProperties()
  local props = {}
  --[[ #include "properties.lua" ]]
  return props
end

-- Optional function to update available properties when properties are altered by the user
function RectifyProperties(props)
  --[[ #include "rectify_properties.lua" ]]
  return props
end

-- Defines the Controls used within the plugin
function GetControls(props)
  local ctrls = {}
  --[[ #include "controls.lua" ]]

  -- uncomment for debug mode
  -- table.insert(ctrls,{Name = 'code',ControlType = 'Text',UserPin = false,PinStyle = 'Input',Count = 1})

  return ctrls
end

--Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
  local layout = {}
  local graphics = {}
  --[[ #include "layout.lua" ]]

  -- uncomment for debug mode
  -- layout['code']={PrettyName='code',Style='None'}

  return layout, graphics
end

--Start event based logic
if Controls then
  --[[ #include "runtime.lua" ]]
end
