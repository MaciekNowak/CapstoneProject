library(shiny)


unigrm <<- read.csv("unigram.csv")
bigrm <<- read.csv("bigram.csv")
trigrm <<- read.csv("trigram.csv")

shinyServer(
    function(input, output, clientData, session)
    {
        observe({
            theWords <- strsplit(input$ourInput, "\\s+")
            wordCount <<- length(theWords[[ 1 ]])
            res <- input$ourInput
            
            if(wordCount == 1)
            {
                w1 <- theWords[[ 1 ]][ wordCount ]
                nws <- unigrm[ unigrm$FirstWord == w1, ]
                if(nrow(nws) > 0)
                {
                    x <- nws[ order(nws$Occurrences, decreasing = TRUE), ]
                    nw <- as.character(x[ nrow(nws), 3 ])
                    res <- paste(input$ourInput, nw)
                }
            }
            else if(wordCount == 2)
            {
                w1 <- theWords[[ 1 ]][ 1 ]
                w2 <- theWords[[ 1 ]][ wordCount ]
                nws <- bigrm[ bigrm$FirstWord == w1 & bigrm$SecondWord == w2, ]
                if(nrow(nws) > 0)
                {
                    x <- nws[ order(nws$Occurrences, decreasing = TRUE), ]
                    nw <- as.character(x[ nrow(nws), 4 ])
                    res <- paste(input$ourInput, nw)
                }
            }
            else if(wordCount > 2)
            {
                w1 <- theWords[[ 1 ]][ wordCount - 2 ]
                w2 <- theWords[[ 1 ]][ wordCount - 1 ]
                w3 <- theWords[[ 1 ]][ wordCount ]
                nws <- trigrm[ trigrm$FirstWord == w1 & trigrm$SecondWord == w2 & trigrm$ThirdWord == w3, ]
                if(nrow(nws) > 0)
                {
                    x <- nws[ order(nws$Occurrences, decreasing = TRUE), ]
                    nw <- as.character(x[ nrow(nws), 5 ])
                    res <- paste(input$ourInput, nw)
                }
            }
            
            output$textLabel <- renderText({"Output Text"})
            output$ourOutput <- renderText({res})
            
            output$doc1 <- renderText({
                paste("The purpose of this application is to present the next word hinter",
                      "solution that could be potentially used in cell phones and tablets",
                      "keyboards.")
            })
            
            output$help1 <- renderText({
                paste("Please use the input field labeled 'Input Text' to enter words.",
                      "Once the 'Submit' buttom is clicked the app will try to hint",
                      "the next word.",
                      "The whole text is displayed under 'Output Text'.")
            })
        })
    }
)