library(shiny)

nextWord <<- read.csv("test.csv")
wordFound <<- FALSE

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
                    theLastWord <- theWords[[ 1 ]][ length(theWords[[ 1 ]]) ]
                    nw <- as.character(nextWord[ nextWord$FirstWord == theLastWord, 3 ])
                    updateTextInput(session, "ourInput", value = paste(input$ourInput, nw, " "))
                    wordFound <<- TRUE
                }
            }
            else
            {
                wordFound <<- FALSE
            }
            
            output$ourOutput <- renderText({input$ourInput})
        })
    }
)