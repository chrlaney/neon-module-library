# sites_by_product_map_app.R

ui <- fluidPage(
  h2("Sites"),
  sitesByProductMapUI("mysites")
)

server <- function(input, output, session){
  callModule(sitesByProductMap, "mysites")
}

shinyApp(ui, server)
