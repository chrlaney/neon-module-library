library(markdown)
shinyUI(navbarPage("Toolbar",
                   tags$head(
                     tags$link(rel = "stylesheet", type = "text/css", href = "list.css")
                   ),
                   tabPanel("Overview",
                            titlePanel("Some Text"),
                            sidebarLayout(
                              sidebarPanel(
                                h2("Purpose of this web application"),
                                p("Text to go here"),
                                br(),
                                br()
                              ),
                              mainPanel(
                                includeHTML("methods.html")
                              )
                            )
                   ), # end tabpanel
                   tabPanel("Do Stuff Tab 1",
                            sidebarLayout(
                              sidebarPanel( 
                                fileInput('Rfile1', 'Read in File 1', accept=c('.RData', '.Rda')),
                                fileInput('Rfile2', 'Read in File 2', accept=c('.RData', '.Rda'))
                              ), # end sidebar
                              mainPanel(
                                h1('Some Report')
                              )
                            )
                   ) # end tabpanel 
)) # end program