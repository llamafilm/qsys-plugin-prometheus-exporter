-- debug mode
-- layout['code']={PrettyName='code',Style='None'}

local CurrentPage = PageNames[props['page_index'].Value]
if CurrentPage == 'Control' then
  -- header box
  table.insert(graphics, {
    Type = 'GroupBox',
    Size = { 400, 40 },
    Position = { 0, 0},
    Fill = { 230, 82, 44 },
    StrokeWidth = 0
  })

  -- header text
  table.insert(graphics, {
    Type = 'Label',
    Text = 'Prometheus Exporter',
    Position = { 50, 0 },
    Size = { 300, 40 },
    Color = { 255, 255, 255 },
    StrokeWidth = 0,
    FontSize = 24
  })

  -- header text version 
  table.insert(graphics, {
    Type = 'Label',
    Text = PluginInfo.BuildVersion,
    Position = { 360, 20 },
    Size = { 40, 20 },
    Color = { 255, 255, 255 },
    StrokeWidth = 0,
    FontSize = 10
  })

  -- background box
  table.insert(graphics, {
    Type = 'GroupBox',
    Size = { 400, 200 },
    Position = { 0, 40},
    Fill = { 220, 220, 220 },
    StrokeWidth = 0
  })

  -- host text entry
  table.insert(graphics, {
    Type = 'Label',
    HTextAlign = 'Right',
    Text = 'Status Component Name',
    Position = { 0, 50 },
    Size = { 180, 30 },
    Margin = 5,
    StrokeWidth = 0,
    FontSize = 12
  })
  layout['Status Component'] = {
    Style = 'ComboBox',
    Position = { 180, 50 },
    Size = { 180,30 },
    Margin = 5,
    CornerRadius = 4,
    FontSize = 12
  }

  layout['Port'] = {
    PrettyName='code',
    Style='None'
  }

end
