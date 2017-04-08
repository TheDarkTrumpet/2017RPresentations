library(shiny)
library(RODBC)
library(dplyr)

getStateList <- function() {
  connectionString <- "driver=freetds;DSN=SqlServer;Database=WorldWideImporters;UID=sa;Pwd=pAssw04d"
  dbhandle <- odbcDriverConnect(connectionString)
  allData <- sqlQuery(dbhandle, 'select StateProvinceCode, StateProvinceName from Application.StateProvinces')
  close(dbhandle)
  # as.list(setNames(as.character(allData$StateProvinceCode), allData$StateProvinceName))
  structure(as.character(allData$StateProvinceName), names = as.character(allData$StateProvinceName))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Population by State"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("states", 
                         label = h3("States to Report on"), 
                         choices = getStateList(),
                         selected = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       h3(textOutput("General State Information")),
       plotOutput("generalStateInformation"),
       h3(textOutput("Top 5 Cities for each state")),
       plotOutput("top5CitiesPerState"),
       h3(textOutput("Bottom 5 Cities for each state")),
       plotOutput("lowest5CitiesPerState")
    )
  )
))