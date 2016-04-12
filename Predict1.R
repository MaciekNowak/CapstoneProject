rm(list = ls()) # clear the environment so the results are reproducible

dataDir <- "Coursera-SwiftKey/final/en_US"
flist <- dir(path = dataDir, 
             pattern = "^en_US\\..*\\.txt$",
             ignore.case = TRUE, include.dirs = TRUE)

sampleSize <- 3 # percentage of all records to be taken for the further analysis
sampleFile <- file("allsample.txt", "wt")

for(f in flist)
{
    # read, clean the data and get the basic statistics
    #
    fullF <- paste(dataDir, f, sep = "/")
    fileLines <- readLines(con = fullF, n = -1, encoding = "UTF-8", skipNul = TRUE)
    
    # get sample sampleSize% lines and write them to the sample file
    #
    sampleLines <- sample(length(fileLines), as.integer((sampleSize * length(fileLines)) / 100))
    for(lineNumber in sampleLines)
    {
        cleanLine <- iconv(fileLines[ lineNumber ], "UTF-8", "ASCII", sub = " ")
        cleanLine <- gsub("[[:punct:]]", " ", cleanLine)
        cleanLine <- gsub("\\d+", " ", cleanLine) # remove numbers
        cleanLine <- gsub("\\s+\\w\\s+", " ", cleanLine) # remove single letters
        writeLines(tolower(cleanLine), con = sampleFile)
    }
}

close(sampleFile)

library(tm)
library("RWeka")

dirSource <- DirSource(pattern = "^allsample.txt$", ignore.case = TRUE)

ourTxt <- Corpus(dirSource,
                 readerControl = list(reader = readPlain,
                                      language = "en",
                                      load = TRUE))
#ourTxt <- tm_map(ourTxt, removeWords, stopwords("english"))
bigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm <- TermDocumentMatrix(ourTxt, control = list(tokenize = bigramTokenizer))

rowCount <- nrow(tdm)
colCount <- ncol(tdm)

x <- inspect(tdm[ 1:rowCount, 1:colCount ]) # get the ngram matrix
w <- rownames(x) # the word sequences
y <- strsplit(w, "\\s+")
w1 <- sapply(y, FUN = function(a) a[ 1 ]) # w1 - the first word vector
w2 <- sapply(y, FUN = function(a) a[ 2 ]) # w2 - the next word vector

d <- data.frame(FirstWord = w1, SecondWord = w2, Occurrences = x[ , 1 ])
write.csv(d, "caprojshinyapp/unigram.csv")


