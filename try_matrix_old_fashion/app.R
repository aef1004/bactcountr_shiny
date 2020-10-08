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
                 
                 sliderInput("dilutions_plated", label = "Dilutions Plated", min = 0, max = 10, value =c(0, 8)),
                 ),
    
    textOutput("dilution_names"),

    sidebarPanel(
        width = 6,
        tags$h4("CFU Data Input"),
        matrixInput(
            "cfu_data",
            value = matrix(runif(12), 6, 2, dimnames = list(NULL, c("Group", "Replicate"))),
            rows = list( 
                extend = TRUE
            ),
            cols = list(
                names = TRUE
            )
        )
    ),
    mainPanel(
        width = 6,
        plotOutput("scatter")
    )
)

server <- function(input, output, session) {
    output$dilution_names <- renderText(paste("dilution", c(input$dilutions_plated[1]:input$dilutions_plated[2]), sep = "_"))
    
    output$scatter <- renderPlot({
        
        plot(input$cfu_data, col = "red", main = "Scatterplot")
    })
}

shinyApp(ui, server)
