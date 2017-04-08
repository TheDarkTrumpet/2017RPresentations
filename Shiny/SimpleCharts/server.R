#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RODBC)
library(ggplot2)
library(dplyr)

connectionString <- "driver=freetds;DSN=SqlServer;Database=WorldWideImporters;UID=sa;Pwd=pAssw04d"
options(scipen=999)

getAllStatePopulations <- function() {
  dbhandle <- odbcDriverConnect(connectionString)
  allData <- sqlQuery(dbhandle, 'select s.StateProvinceCode, s.StateProvinceName, 
    s.LatestRecordedPopulation as StatePopulation from Application.StateProvinces s')
  close(dbhandle)
  allData
}

getAllCityPopulations <- function() {
  dbhandle <- odbcDriverConnect(connectionString)
  allData <- sqlQuery(dbhandle, 'select c.CityName, c.LatestRecordedPopulation as CityPopulation,
  s.StateProvinceCode, s.StateProvinceName, s.LatestRecordedPopulation as StatePopulation
  from Application.Cities c left join Application.StateProvinces s ON c.StateProvinceId = s.StateProvinceID')
  close(dbhandle)
  allData
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$generalStateInformation <- reactivePlot(function() {
    if(length(input$states) > 0)
    {
      statePopulations <- getAllStatePopulations()
      stateSubset <- statePopulations %>%
        filter(StateProvinceName %in% input$states)
      stateSubsetGraph <- ggplot(data = stateSubset, aes(x=reorder(StateProvinceName, -StatePopulation), y=StatePopulation)) + 
        geom_bar(stat = 'identity') + 
        coord_flip() + 
        theme_bw() + 
        xlab("State") + 
        ylab("Population")
      print(stateSubsetGraph)
    }
  })
  
  output$top5CitiesPerState <- reactivePlot(function() {
    if(length(input$states) > 0)
    {
      cityPopulations <- getAllCityPopulations()
      cityPopulationSubset <- cityPopulations %>%
        filter(StateProvinceName %in% input$states) %>%
        group_by(StateProvinceName) %>%
        top_n(n = 5, CityPopulation) %>%
        select(StateProvinceName, CityName, CityPopulation, everything()) %>%
        arrange(StateProvinceName, -CityPopulation) %>%
        mutate(top = TRUE)
      cityPlot <- ggplot(cityPopulationSubset, aes(x = CityName, y = CityPopulation)) + 
        geom_bar(stat = 'identity') + 
        facet_grid(StateProvinceName ~ ., scales = 'free', space = 'free') + 
        coord_flip() + 
        theme_bw() + 
        xlab("City Name") + 
        ylab("Population")
      print(cityPlot)
    }
  })
  
  output$lowest5CitiesPerState <- reactivePlot(function() {
    if(length(input$states) > 0)
    {
      cityPopulations <- getAllCityPopulations()
      cityPopulationSubset <- cityPopulations %>%
        filter(StateProvinceName %in% input$states) %>%
        group_by(StateProvinceName) %>%
        top_n(n = -5, CityPopulation) %>%
        select(StateProvinceName, CityName, CityPopulation, everything()) %>%
        arrange(StateProvinceName, -CityPopulation) %>%
        mutate(top = TRUE)
      cityPlot <- ggplot(cityPopulationSubset, aes(x = CityName, y = CityPopulation)) + 
        geom_bar(stat = 'identity') + 
        facet_grid(StateProvinceName ~ ., scales = 'free', space = 'free') + 
        coord_flip() + 
        theme_bw() + 
        xlab("City Name") + 
        ylab("Population")
      print(cityPlot)
    }
  })
})
