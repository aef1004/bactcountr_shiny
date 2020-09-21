#could help with making it into an excel file with 2 sheets https://www.r-bloggers.com/2019/08/creating-excel-workbooks-with-multiple-sheets-in-r/
  
  metadata <- reactive({ 
    data.frame(exp_name = input$exp_name, 
               timepoint = input$timepoint,
               plating_date = input$plating_date,
               counting_date = input$counting_date,
               organ = input$organ,
               dilution_factor = input$dilution_factor,
               resuspend_volume = input$resuspend_volume,
               volume_plated = input$volume_plated,
               percent_organ = input$percent_organ,
               min_dilution_plated = input$dilutions_plated[1],
               max_dilution_plated = input$dilutions_plated[2])
  })
  
  
  
  # try to create the other data table to input the data
  DT::renderDataTable({
    metadata <- data.frame(group,
                           mouse_number,
                           min_dilution_plated = input$dilutions_plated[1],
                           max_dilution_plated = input$dilutions_plated[2])
    DT::datatable(metadata, options = list(
      bPaginate = FALSE
    ))
  })