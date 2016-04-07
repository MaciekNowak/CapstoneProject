library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("The next word hinter"),
    
    sidebarPanel(textInput(inputId = "ourInput", label = "Input Text")),
    
    mainPanel(
        tabsetPanel(
            tabPanel("Text", br(), textOutput("ourOutput")),
            tabPanel("Help/Documentation", br())
        )
    )
))