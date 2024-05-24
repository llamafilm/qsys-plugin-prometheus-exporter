table.insert(props, {
  Name = 'Debug Print',
  Type = 'enum',
  Choices = {'None', 'Tx/Rx', 'Tx', 'Rx', 'Function Calls', 'All'},
  Value = 'None'
})

table.insert(props, {
  Name = 'Custom Metrics',
  Type = 'integer',
  Min = 0,
  Max = 20,
  Value = 0
})
