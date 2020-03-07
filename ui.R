library(shiny)

fluidPage(
    
    
    mainPanel(
        h5("This application predicts the next world"),
        textInput("Tcir",label=h3("Type your sentence here:")),
        submitButton('Submit'),
        h4('string you entered : '),
        verbatimTextOutput("inputValue"),
        h4('next word :'),
        verbatimTextOutput("prediction")
        
    )
)