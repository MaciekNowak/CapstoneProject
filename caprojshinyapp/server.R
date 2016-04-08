library(shiny)

nextWord <<- read.csv("test.csv")
wordFound <<- FALSE
wordCount <<- 0

shinyServer(
    function(input, output, clientData, session)
    {
        observe({
            wordEnd <- grep("[^\\s]+\\s+$", input$ourInput)
            if(length(wordEnd) > 0)
            {
                if(wordFound == FALSE)
                {
                    theWords <- strsplit(input$ourInput, "\\s+")
                    if(wordCount <= length(theWords[[ 1 ]]))
                    {
                        theLastWord <- theWords[[ 1 ]][ length(theWords[[ 1 ]]) ]
                        nw <- as.character(nextWord[ nextWord$FirstWord == theLastWord, 3 ])
                        updateTextInput(session, "ourInput", value = paste(input$ourInput, nw, " "))
                        wordFound <<- TRUE
                        wordCount <<- length(theWords[[ 1 ]]) + 1
                    }
                }
            }
            else
            {
                wordFound <<- FALSE
            }
            
            output$textLabel <- renderText({"Output Text"})
            output$ourOutput <- renderText({input$ourInput})
            
            output$doc1 <- renderText({
                paste("The purpose of this application is to present the next word hinter",
                      "solution that could be potentially used in cell phones and tablets",
                      "keyboards.")
            })
            
            output$help1 <- renderText({
                paste("Please use the input field labeled 'Input Text' to enter words.",
                      "Once a space that ends a word is entered the app will try to hint",
                      "the next word. If the word is not the right one 'backspace' would be",
                      "used to delete it.",
                      "The whole text is displayed under 'Output Text'.")
            })
        })
    }
)