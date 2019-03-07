library(shiny)
library(tidyverse)
library(jsonlite)

# Module UI function
sitesByProductTableUI <- function(id) {
  ns  <- NS(id)
  tagList(
          selectInput(ns("productName"),
                      label = "Data Product Name", 
                      choices = pr$productName),
          DT::dataTableOutput(ns("siteTable"))
  )
}

# Module server function
sitesByProductTable <- function(input, output, session){
  getProducts <- function(){
    pr <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/products")
    pr <- pr[["data"]]
  }
  pr <- getProducts()
  
  getSites <- function(){
    sites <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/sites")
    sites <- sites[["data"]]
  }
  sites <- getSites()
  
  makeSiteTable <- reactive({
    d <- as.data.frame(pr$siteCodes[pr$productName == input$productName]) 
    d <- d[, 1:2]
    s <- sites[, -match("dataProducts", names(sites))]
    d <- merge(d, s, by = "siteCode", all.x = T, all.y = F)
    DT::datatable(d, filter="top")
  })
  
  output$siteTable <- DT::renderDataTable(makeSiteTable())
}

#### In a shiny app ####
# source("sites_by_product_table.R")

# ui <- fluidPage(
#   h2("Sites"),
#   sitesByProductTableUI("mysites")
# )
# 
# server <- function(input, output, session){
#   callModule(sitesByProductTable, "mysites")
# }
# 
# shinyApp(ui, server)
