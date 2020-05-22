#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Capstone: Course Project",
                   tabPanel("Predict the Next Word",
                            HTML("<strong>Author: Preethi </strong>"),
                            br(),
                            HTML("<strong>Date: 22/05/2020</strong>"),
                            br(),
                            # Sidebar
                            sidebarLayout(
                                sidebarPanel(
                                    helpText("Enter a partially complete sentence to begin the next word prediction"),
                                    textInput("inputString", "Enter a partial sentence here",value = ""),
                                    br(),
                                    br(),
                                    br(),
                                    br()
                                ),
                                mainPanel(
                                    h2("Predicted Next Word"),
                                    verbatimTextOutput("prediction"),
                                    strong("Sentence Input:"),
                                     
                                    textOutput('text1'),
                                    br(),
                                    strong("Note:"),
                                    
                                    textOutput('text2')
                                )
                            )
                            
                   ),
                   tabPanel("Explaining the back-off method",
                            mainPanel("The model used is the Stupid-Back Model: This checks 
                                      if the largest-order ngram is observed if not it moves down
                                      progressively. Since my training set has a relatively small size 
                                      (because of laptops computing capacity),
                                      model mostly drops down to a bi-gram model. but it works"
                            )
                   )
)
)