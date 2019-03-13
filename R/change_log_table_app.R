# change_log_table_app.R

ui <- fluidPage(
    h2("Change Logs"),
    changeLogTableUI("mylogs")
)
 
server <- function(input, output, session){
  callModule(changeLogTable, "mylogs")
}

shinyApp(ui, server)
