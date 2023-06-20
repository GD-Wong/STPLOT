library(shiny.fluent)
library(shiny)
library(DT)
source("app_interfunction.R")
load("interdata.rda")
cancerType = names(spatial_info)
cellType = c("All","T", "B", "Myeloid", "Epithelial", "Fibroblast", "Endothelial")
selecter <- tagList(
  Dropdown.shinyInput(inputId = "cancerType",options = make_list(cancerType, cancerType), label = "Cancer", value = "PRAD"),
  uiOutput("slidePicker"),
  uiOutput("labelPicker"),
  Checkbox.shinyInput(inputId = "subtype",value = FALSE, label = "Subtype"),
  Dropdown.shinyInput(inputId = "cellType",options = make_list(cellType, cellType),  value = "All")
)
piePlot <- Stack(
  tokens = list(childrenGap = 10),horizontal = TRUE,
  plotOutput("pieChart", width = "600px", height = "450px"),
  Stack(
    tokens = list(childrenGap = 5),
    Checkbox.shinyInput("percentage", value = FALSE, label = "Percentage"),
    Checkbox.shinyInput("logFreq", value = FALSE, label = "Log Freq")
  )
)

spatialPlot <- Stack(
  tokens = list(childrenGap = 5),
  Slider.shinyInput("spotSize", value = 0.1, min = 0.1, max =1, step = 0.01, label = "Spot Size"),
  plotOutput("spatialPlot", width = "600px", height = "600px")
)

cellTypeSelecter <- tagList(
  Checkbox.shinyInput("spatialSubtype", value = FALSE, label = "Subtype"),
  uiOutput("subtypeSelecter")
)

spatialData <- Stack(
  tokens = list(childrenGap = 10), horizontal = TRUE,
  makeCard("Spatial Plot", spatialPlot, size = 8, style = "max-height: 800px"),
  makeCard("Cell Type", cellTypeSelecter, size = 4, style = "max-height: 800px")
)


 summarize <- Stack(
   tokens = list(childrenGap = 10), horizontal = TRUE,
   makeCard("STPLOT", selecter, size = 4, style = "max-height: 450px"),
   makeCard("Summarize", piePlot, size = 8, style = "max-height: 450px")
)


