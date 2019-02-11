# availability_map.R

library(shiny)
library(tidyverse)
library(jsonlite)

getProducts <- function(){
  pr <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/products")
  pr <- pr[["data"]]
}

productDropdownUI <- function(id) {
  ns  <- NS(id)
  fluidPage(
    fluidRow(column=6,
      selectInput(inputId = "productName",
                  label = "Data Product Name", 
                  choices = pr$productName)),
    fluidRow(column(12, DT::dataTableOutput(ns("siteTable"))))
  )
}



# Module server function
siteTable <- function(input, output, session){
  pr <- getProducts()
  output$siteTable <- DT::renderDataTable(getSites())
}


ui <- fluidPage(
#  productDropdownUI("myproduct")
  fluidRow(column=6,
           selectInput(inputId = "productName",
                       label = "Data Product Name", 
                       choices = pr$productName)),
  fluidRow(column(12, DT::dataTableOutput("siteTable")))
)


server <- function(input, output, session){
  getProducts <- function(){
    pr <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/products")
    pr <- pr[["data"]]
  }
  
  pr <- getProducts()
  
  getSites <- reactive({
    DT::datatable(as.data.frame(pr$siteCodes[pr$productName == input$productName], filter="top"))
  })
  
  output$siteTable <- DT::renderDataTable(getSites())
  
  #callModule(siteTable, "myproduct")
}

shinyApp(ui, server)


# library(leaflet)

# Set value for the minZoom and maxZoom settings.
# leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))

# getProductSites <- reactive({
# 
# })


# makeProductAvailabilityMap <- function(){
#   pr <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/products")
#   pr <- pr[["data"]]
#   
#   sites <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/sites")
#   sites <- sites[["data"]]
#   
#   m <- leaflet() %>%
#     fitBounds(lng1 = -120, lng2 = -80, lat1 = 20, lat2 = 70) %>%
#     addTiles()  # Add default OpenStreetMap map tiles
#   m  # Print the map
# }
