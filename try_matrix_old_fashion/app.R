#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library("shiny")
library("shinyMatrix")
library("DT")
library(janitor)

df <- data.frame(matrix(c("0","0"), 1, 2))

render_dt = function(data, editable = 'cell', server = TRUE, ...) {
    renderDT(data, selection = 'none', server = server, editable = editable, ...)
}


ui <- fluidPage(
    titlePanel("bactcountr Shiny App"),
    sidebarPanel(width = 6, 
                 tags$h4("Metadata"),
                 textInput("exp_name", label = "Experiment Name", value = ""),
                 
                 numericInput("timepoint", label = "Timepoint in Days", value = "0"),
                 
                 dateInput("plating_date", label = "Date Plated", value = Sys.Date()),
                 
                 dateInput("counting_date", label = "Date Counted", value = Sys.Date()),
                 
                 selectInput("organ", label = "Organ", choices = c("Lung", "Spleen", "BoneMarrow", "BAL")),
                 
                 numericInput("dilution_factor", label = "Dilution Factor", value = ""),
                 
                 numericInput("resuspend_volume", label = "Resuspend Volume in mL", value = ""),
                 
                 numericInput("volume_plated", label = "Volume Plated in uL", value = ""),
                 
                 numericInput("percent_organ", label = "Percent of Organ as decimal", value = ""),
                 
                 sliderInput("dilutions_plated", label = "Dilutions Plated", min = 0, max = 10, value =c(0, 7)),
                 ),

    
    sidebarPanel(
        width = 6,
        tags$h4("CFU Data Input"),
        sidebarPanel(DTOutput('x4')),
    ),
    
    
    mainPanel(
        width = 6,
        plotOutput("scatter")
    )
)

server <- function(input, output, session) {
    
    output$scatter <- renderPlot({
        
        plot(input$cfu_data, col = "red", main = "Scatterplot")
    })
    
    column_names <- reactive({
        c("Group", "Replicate", paste("dilution", c(input$dilutions_plated[1]:input$dilutions_plated[2]), sep = "_"))
    })
    
    data_for_CFUs <- reactive({
        #column_names <- renderText(c("Group", "Replicate", paste("dilution", c(input$dilutions_plated[1]:input$dilutions_plated[2]), sep = "_")))
        #ncolumns <- length(c(input$dilutions_plated[1]:input$dilutions_plated[2])) + 2
        
        all_dilutions <- c(input$dilutions_plated[1]:input$dilutions_plated[2])
        dilution_colnames <- paste("dilution", all_dilutions, sep = "_")
        
        group = NA # have to do this so that the data frame can be made with empty rows
        mouse = NA
        
        z= c("group", "mouse", dilution_colnames)

        data.frame(matrix(vector(), 50, length(z),
                                dimnames=list(c(), z)),
                         stringsAsFactors=F)

    })
    
    
    output$x4 <- render_dt(data_for_CFUs(), 'all', FALSE)
    #observe(str(input$x4_cell_edit))

}

shinyApp(ui, server)
