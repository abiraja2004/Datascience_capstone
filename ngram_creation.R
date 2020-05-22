##Creating ngrams
library(tm)
library(plyr)
library(dplyr)

## Download the file

fileUrl <-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
if (!file.exists("Coursera-SwiftKey.zip")){
  download.file(fileUrl, destfile = "Coursera-SwiftKey.zip", method="curl")
}
unzip("Coursera-SwiftKey.zip")

##set working directory and read file

setwd("~/R/datascience_coursera_main/Capstone/Datascience_capstone")
file1 <- file("final/en_US/en_US.blogs.txt", "rb")
blogs <- readLines(file1, encoding = "UTF-8",skipNul = TRUE)
close(file1)

file2 <- file("final/en_US/en_US.news.txt", "rb")
news <- readLines(file2, encoding = "UTF-8",skipNul = TRUE)
close(file2)

file3 <- file("final/en_US/en_US.twitter.txt", "rb")
twitter <- readLines(file3, encoding = "UTF-8",skipNul = TRUE)
close(file3)

##Creating a sample/training set from the bigger files

set.seed(5000)

sample_size = 1000

sample_blog <- blogs[sample(1:length(blogs),sample_size)]
sample_news <- news[sample(1:length(news),sample_size)]
sample_twitter <- twitter[sample(1:length(twitter),sample_size)]
data.sample <- c(sample_blog,sample_news,sample_twitter)
writeLines(data.sample, "./sample_lines/SampleAll.txt")

# creating a corpus and cleaniing it
cleansing <- function (textcp) {
  textcp <- tm_map(textcp, content_transformer(tolower))
  textcp <- tm_map(textcp, stripWhitespace)
  textcp <- tm_map(textcp, removePunctuation)
  textcp <- tm_map(textcp, removeNumbers)
  textcp
}

SampleAll <- VCorpus(DirSource("./sample_lines", encoding = "UTF-8"))
unicorpus <- cleansing(SampleAll)

## create a function to make ngrams and put them in a dataframe

tdm_Ngram <- function (textcp, n) {
  NgramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n, max = n))}
  tdm_ngram <- TermDocumentMatrix(textcp, control = list(tokenizer = NgramTokenizer))
  tdm_ngram_m <- as.matrix(tdm_ngram)
  tdm_ngram_df <- as.data.frame(tdm_ngram_m)
  colnames(tdm_ngram_df) <- "Count"
  tdm_ngram_df <- tdm_ngram_df[order(-tdm_ngram_df$Count), , drop = FALSE]
  tdm_ngram_df
}

unigram_df <- tdm_Ngram (unicorpus, 1)
bigram_df <- tdm_Ngram (unicorpus, 2)
trigram_df <- tdm_Ngram (unicorpus, 3)
quadgram_df <- tdm_Ngram (unicorpus, 4)


quadgram <- data.frame(rows=rownames(quadgram_df),count=quadgram_df$Count)
quadgram_split <- strsplit(as.character(quadgram$rows),split=" ")
quadgram <- transform(quadgram,
                      one = sapply(quadgram_split,"[[",1),
                      two = sapply(quadgram_split,"[[",2),
                      three = sapply(quadgram_split,"[[",3), 
                      four = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = quadgram$one,
                       bigram = quadgram$two, 
                       trigram = quadgram$three, 
                       quadgram = quadgram$four, 
                       freq = quadgram$count,stringsAsFactors=FALSE)
write.csv(quadgram[quadgram$freq > 1,],"./Text_predictor/quadgram.csv",row.names=F)
quadgram <- read.csv("./Text_predictor/quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"./Text_predictor/quadgram.RData")

trigram <- data.frame(rows=rownames(trigram_df),count=trigram_df$Count)
trigram$rows <- as.character(trigram$rows)
trigram_split <- strsplit(as.character(trigram$rows),split=" ")
trigram <- transform(trigram,one = sapply(trigram_split,"[[",1),
                      two = sapply(trigram_split,"[[",2),
                      three = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = trigram$one,
                       bigram = trigram$two, 
                       trigram = trigram$three, 
                       freq = trigram$count,stringsAsFactors=FALSE)
write.csv(trigram[trigram$freq > 1,],"./Text_predictor/trigram.csv",row.names=F)
trigram <- read.csv("./Text_predictor/trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"./Text_predictor/trigram.RData")

bigram <- data.frame(rows=rownames(bigram_df),count=bigram_df$Count)
bigram_split <- strsplit(as.character(bigram$rows),split=" ")
bigram <- transform(bigram,one = sapply(bigram_split,"[[",1),
                     two = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = bigram$one,
                      bigram = bigram$two, 
                      freq = bigram$count,stringsAsFactors=FALSE)
write.csv(bigram[bigram$freq > 1,],"./Text_predictor/bigram.csv",row.names=F)
bigram <- read.csv("./Text_predictor/bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"./Text_predictor/bigram.RData")
