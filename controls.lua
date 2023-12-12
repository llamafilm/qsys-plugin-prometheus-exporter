table.insert (ctrls, {
  Name = 'Status Component',
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

-- debug mode
-- table.insert(ctrls,{Name = 'code',ControlType = 'Text',UserPin = false,PinStyle = 'Input',Count = 1})
