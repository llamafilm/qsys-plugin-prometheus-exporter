local custom_metrics_count = props['Custom Metrics'].Value

table.insert (ctrls, {
  Name = 'Status Component Name',
  ControlType = 'Text'
})

table.insert (ctrls, {
  Name = 'Port',
  ControlType = 'Knob',
  DefaultValue = 10006,
  ControlUnit = 'Integer',
  Min = 1,
  Max = 65535
})

table.insert (ctrls, {
  Name = 'Status',
  ControlType = 'Indicator',
  IndicatorType = 'Status',
  Count = 1,
  UserPin = true,
  PinStyle = 'Output',
})

table.insert (ctrls, {
  Name = "Metric",
  ControlType = "Knob",
  ControlUnit = "Float",
  Min = -1000000000,
  Max = 1000000000,
  Count = custom_metrics_count,
  PinStyle = "Input",
})

table.insert (ctrls, {
  Name = "Metric Label",
  ControlType = "Text",
  Count = custom_metrics_count,
  PinStyle = "None",
})

table.insert (ctrls, {
  Name = "Metric Type",
  ControlType = "Button",
  ButtonType = "Toggle",
  DefaultValue = false,
  Count = custom_metrics_count,
  PinStyle = "None",
})
