library(shiny)
library(NLP)
library(tm)
library(RWeka)
source("~/R/datascience_coursera_main/Capstone/Datascience_capstone/method.R")


shinyServer(
    function(input, output) {
        output$inputValue <- renderPrint({input$Tcir})
        output$prediction <- renderPrint({wordproc(input$Tcir)})
        
        
        
    }
)