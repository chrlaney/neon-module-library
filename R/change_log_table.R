# change_log_table.R

library(shiny)
library(tidyverse)
library(jsonlite)

getChangeLogs <- function(){
  pr <- jsonlite::fromJSON(txt = "http://data.neonscience.org/api/v0/products")
  pr <- pr[["data"]]
  logs <- dplyr::bind_rows(pr$changeLogs, .id = "column_label")
  logs$productCode <- pr$productCode[as.numeric(logs$column_label)]
  logs <- logs[, -match("column_label", names(logs))]
  logs <- logs[ ,c(ncol(logs), 2:(ncol(logs)-1))]
  return(logs)
}

# Module ui function
changeLogTableUI <- function(id) {
  ns  <- NS(id)
  fluidRow(column(12, dataTableOutput(ns("changeLog"))))
}

# Module server function
changeLogTable <- function(input, output, session){
  logs <- DT::datatable(getChangeLogs(), filter = 'top')
  output$changeLog <- DT::renderDT(logs)
}


#### In a shiny app ####

# source("change_log_table.R")
# 
# ui <- fluidPage(
#   h2("Change Logs"),
#   changeLogTableUI("mylogs")
# )
# 
# server <- function(input, output, session){
#   callModule(changeLogTable, "mylogs")
# }

# shinyApp(ui, server)
