#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
source("app_component.R")
library(shiny)
library(shiny.fluent)

navigation <- Nav(
  groups = link_groups,
  selectedKey = "key1",
  styles = navigation_styles
)

mainLayer = Dropdown.shinyInput(
    inputId = "cancer",
    value = "CRC",
    Width = 6,
    dropdownWidth = 3,
    options = list(
      list(key = "CRC", text = "CRC"),
      list(key = "PRAD", text = "PRAD"),
      list(key = "Melanoma", text = "Melanoma")
    )
  )

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("STPLOT"),
  sidebarLayout(
    sidebarPanel(navigation),
    mainPanel(mainLayer)
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$checkboxValue <- renderText({
    sprintf("Value: %s", input$checkbox)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
