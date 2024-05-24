local custom_metrics_count = props['Custom Metrics'].Value

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
    Size = { 400, 110 + 22 * custom_metrics_count },
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
  layout['Status Component Name'] = {
    Style = 'ComboBox',
    Position = { 180, 50 },
    Size = { 180,30 },
    Margin = 5,
    CornerRadius = 4,
    FontSize = 12
  }

  -- status display
  table.insert(graphics, {
    Type = 'Label',
    HTextAlign = 'Right',
    Text = 'Status',
    Position = { 0, 80 },
    Size = { 180, 30 },
    Margin = 5,
    StrokeWidth = 0,
    FontSize = 12
  })
  layout['Status'] = {
    Position = { 180, 80 },
    Size = { 180, 30 },
    Margin = 5,
    CornerRadius = 4
  }

  -- add some number of Custom Metrics (defaults to 0)
  if custom_metrics_count > 0 then
    table.insert(graphics,
    {
      Type = "Header",
      Text = "Custom Metrics Labels",
      HTextAlign = "Center",
      Color = {0, 0, 0},
      FontSize = 12,
      Position = {10, 120},
      Size = {380, 20},
    })

    -- if there is only 1 Control then the  name is different
    if custom_metrics_count == 1 then
      table.insert(graphics, {
        Type = 'Label',
        HTextAlign = 'Right',
        Text = 'Metric 1',
        Position = { 0, 120 + 22 },
        Size = { 100,22 },
        Margin = 1,
        FontSize = 12
      })
      layout['Metric Type'] = {
        Style = 'Button',
        Legend = '%',
        Position = { 360, 120 + 22 },
        Size = { 22,22 },
        CornerRadius = 4,
        FontSize = 12
      }
      layout['Metric Label'] = {
        Style = 'Text',
        Position = { 105, 120 + 22 },
        Size = { 250,22 },
        Margin = 1,
        CornerRadius = 4,
        FontSize = 12
      }
      layout['Metric'] = {Style = 'None'}
    else
      for i=1,custom_metrics_count do
        table.insert(graphics, {
          Type = 'Label',
          HTextAlign = 'Right',
          Text = 'Metric ' .. i,
          Position = { 0, 120 + 22 * i },
          Size = { 100,22 },
          Margin = 1,
          FontSize = 12
        })
        layout['Metric Type ' .. i] = {
          Style = 'Button',
          Legend = '%',
          Position = { 360, 120 + 22 * i },
          Size = { 24,22 },
          CornerRadius = 4,
          FontSize = 12
        }
        layout['Metric Label ' .. i] = {
          Style = 'Text',
          Position = { 105, 120 + 22 * i },
          Size = { 250,22 },
          Margin = 1,
          CornerRadius = 4,
          FontSize = 12
        }
        layout['Metric ' .. i] = {Style = 'None'}
      end
    end
  end
end
