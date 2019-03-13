
 
 
 
 
  
#### sites by product table ####

 library(shiny)
 
 source("R/sites_by_product_table.R")
 
 ui <- fluidPage(
  h2("Sites"),
    sitesByProductTableUI("mysites")
  )
  
  server <- function(input, output, session){
    callModule(sitesByProductTable, "mysites")
  }
  
  shinyApp(ui, server)