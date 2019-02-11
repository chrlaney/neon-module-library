library(shiny)
library(tidyverse)
library(jsonlite)

# Module UI function
sitesByProductMapUI <- function(id) {
  ns  <- NS(id)
  tagList(
  selectInput(ns("productName"),
                label = "Data Product Name", 
                choices = pr$productName, width = "60%"),
   leafletOutput(ns("map"), width="60%", height=600)
  )
}

# For some strange reason, they have severely limited the choice of marker colors. See ?awesomeIcons
getColor <- function(d) {
  d$type <- d$"Site.Type"
  sapply(d$type, USE.NAMES = FALSE, function(type) {
    if(type == "Core Terrestrial") {
      "green"
    } else if (type == "Core Aquatic") {
      "blue"
    } else if(type == "Relocatable Terrestrial") {
      "lightgreen"
    } else {"lightblue"}
  })
}

# Module server function
sitesByProductMap <- function(input, output, session){
  getProducts <- function(){
    pr <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/products")
    pr <- pr[["data"]]
  }
  pr <- getProducts()
  pr <- pr[pr$productStatus=="ACTIVE", ]
  
  getSites <- function(){
    sites <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/sites")
    sites <- sites[["data"]]
  }
  sites <- getSites()
  
  makeSiteMap <- reactive({
    d <- as.data.frame(pr$siteCodes[pr$productName == input$productName]) 
    d <- d[, 1:2]
    s <- sites[, -match("dataProducts", names(sites))]
    d <- merge(d, s, by = "siteCode", all.x = T, all.y = F)
    d.ns <- read.csv("data/field-sites.csv", header = T, stringsAsFactors = F)
    d <- merge(d, d.ns, by.x = "siteCode", by.y = "Site.ID", all.x = T, all.y = F)
    
# For some strange reason, they have severely limited the choice of marker colors. See ?awesomeIcons
    icons <- awesomeIcons(
      icon = 'ios-information',
      iconColor = 'white',
      library = 'ion',
      markerColor = getColor(d)
    )
    
    m <- leaflet(data = d, width = "60%") %>%
           fitBounds(lng1 = -130, lng2 = -90, lat1 = 20, lat2 = 70) %>% #Fit this bounding box in the browser window
           addTiles() %>% # Add default OpenStreetMap map tiles
           addAwesomeMarkers(lng = ~siteLongitude, lat = ~siteLatitude, icon = icons, popup = ~siteName, label = ~siteCode)
    m
  
  })
  
  output$map <- renderLeaflet(makeSiteMap())
}

#### In a shiny app ####
# source("sites_by_product_map.R")

# ui <- fluidPage(
#   h2("Sites"),
#   sitesByProductMapUI("mysites")
# )
# 
# server <- function(input, output, session){
#   callModule(sitesByProductMap, "mysites")
# }
# 
# shinyApp(ui, server)
