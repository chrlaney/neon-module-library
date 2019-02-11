shinyServer(function(input, output, session) {
  File <- reactive({
    infile <- input$school
    if (is.null(infile)) return(NULL)      
    read.csv(infile$datapath, header=input$headerForPE, sep=input$sepForPE, quote=input$quoteForPE, 
             stringsAsFactors = FALSE)
  })
}) # end Program