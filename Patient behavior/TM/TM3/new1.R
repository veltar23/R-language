rm(list=ls(all.names = TRUE))

#1
library(tm)
library(tmcn)


#2
getwd()
setwd("C:/Users/user/Dropbox/R/R/data mining")
d.corpus <- Corpus(DirSource(), list(language = NA))


#3
d.corpus <- tm_map(d.corpus, removePunctuation)
d.corpus <- tm_map(d.corpus, removeNumbers)
d.corpus <- tm_map(d.corpus, function(word) {
  gsub("[A-Za-z0-9]", "", word)
})


# 4. change...
d.corpus <- tm_map( d.corpus, PlainTextDocument ) # to plain text doc
length(d.corpus)
d.corpus <- paste0(d.corpus[[1]]$content,collapse = "") # to string
length(d.corpus)

# 5.Chinese text segmentation
cut <- worker() # set segmentation worker
cut_d.corpus <- cut[d.corpus] # segmentation

cut_d.corpus_tab = table( cut_d.corpus )
write.table(cut_d.corpus_tab)
write.table(cut_d.corpus_tab, file="C:/Users/user/Dropbox/R/R/data mining/datac1")

#6
StopWords <- toTrad(stopwordsCN())
StopWords <- cut[StopWords] # segmentation
myStopWords <- c(StopWords)

a<- list()
for (i in seq_along(StopWords)) {
  a[i] <- gettext(StopWords[[i]][[1]]) #Do not use $content here!
}

df$text <- unlist(a) 
StopWords <- StopWords(VectorSource(df$text)) #This action restores the corpus.



d.corpus <- tm_map(d.corpus, removeWords, myStopWords)
