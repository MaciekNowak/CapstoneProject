library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("The next word hinter"),
    
    sidebarPanel(textInput(inputId = "ourInput", label = "Input Text"),
                 submitButton("Submit"),
                 h4("Please be patient")),
    
    mainPanel(
        tabsetPanel(
            tabPanel("Text", br(),
                     strong(textOutput("textLabel")),
                     textOutput("ourOutput")),
            tabPanel("Help/Usage", br(),
                     textOutput("help1")),
            tabPanel("Documentation", br(),
                     textOutput("doc1"))
        )
    )
))