#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
load("interdata.rda")
source("app_component.R")
source("app_interfunction.R")
library(shiny)
library(shiny.fluent)
library(DT)
library(bootstrap)
options(shiny.maxRequestSize=-1)

#Define UI for application that draws a histogram
ui <- fluentPage(
    suppressDependencies("bootstrap"),
    tags$style(".card { padding: 28px; margin-bottom: 28px; }"),
    summarize,
    uiOutput("SpatialData")
  )

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$slidePicker <- renderUI(makeDropout(input$cancerType, "slideID", names(spatial_info[[input$cancerType]]), "Slide"))
  output$labelPicker <- renderUI({
      makeDropout(input$slideID, "labelName",
                  colnames(spatial_info[[input$cancerType]][[input$slideID]])[c(-1,-2)],
                  "Label")
  })
  slide <- reactive({
    if(!is.null(input$slideID)){
      r <- spatial_info[[input$cancerType]][[input$slideID]]
      if(!is.null(input$labelName)){
        r$Type <- typeSubtype(r[[input$labelName]])
      }
    }
    else{r <- NULL}
    return(r)
  })
  output$pieChart <- renderPlot(if(!is.null(input$labelName)){
    if(input$subtype){
      if(input$cellType == "All"){
        pieData <- slide()[[input$labelName]]
      }
      else{
        allData <- slide()
        pieData <- allData[which(allData$Type == input$cellType), ][[input$labelName]]
      }
    }
    else{
      pieData <- slide()[["Type"]]
    }
    makePieChart(pieData, percentage = input$percentage, logFreq = input$logFreq)
  })
  output$spatialPlot <- renderPlot({
    if(!is.null(input$labelName)){
      if(input$spatialSubtype){
        spatialData <- slide()[,c("x","y",input$labelName)]
        row_index <- which(!spatialData[[input$labelName]]%in%input$choosedSubtype)
        spatialData[row_index, input$labelName] <- "Others"
      }
      else{spatialData = slide()[,c("x","y","Type")]}
      makeSpatialPlot(spatialData, spot_size = input$spotSize)
    }
    else{NULL}
  })
  output$subtypeSelecter <- renderUI({
    if(is.null(input$spatialSubtype)){NULL}
    else{
      if(input$spatialSubtype){
        if(!is.null(input$labelName)){
          checkboxGroupInput("choosedSubtype","Choose the cell sub type:", inline = T, choices = unique(slide()[[input$labelName]]))
        }
        else{NULL}
      }
      else{NULL}
    }
  })
  output$SpatialData <- renderUI(spatialData)
}


# Run the application 
shinyApp(ui = ui, server = server)
