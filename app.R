#### sites by product map ####
library(shiny)

source("sites_by_product_map.R")

ui <- fluidPage(
      h2("Sites"),
   sitesByProductMapUI("mysites")
 )

 server <- function(input, output, session){
   callModule(sitesByProductMap, "mysites")
 }

 shinyApp(ui, server)

 
 
 
 
  
#### sites by product table ####

 library(shiny)
 
 source("sites_by_product_table.R")
 
 ui <- fluidPage(
  h2("Sites"),
    sitesByProductTableUI("mysites")
  )
  
  server <- function(input, output, session){
    callModule(sitesByProductTable, "mysites")
  }
  
  shinyApp(ui, server)