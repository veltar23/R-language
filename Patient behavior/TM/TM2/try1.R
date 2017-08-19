rm(list=ls(all.names = TRUE))

#1.library
library(tm)
library(tmcn)
library(Rwordseg)
library(jiebaR)
library(rJava)
library(SnowballC) # 似乎是上面某個套件的輔助
library(slam)  # 似乎是上面某個套件的輔助


#2.get data
m<-"C:/Users/user/Dropbox/R/R/thesis/TM1" #檔案路徑  
 mycorpus <- Corpus(DirSource(m),list(language = NA)) #讀取路徑下所有txt

mycorpus <- tm_map(mycorpus, removePunctuation)
mycorpus <- tm_map(mycorpus, stripWhitespace)
mycorpus <- tm_map(mycorpus, removeNumbers)
mycorpus <- tm_map(mycorpus, function(word) {
  gsub("[A-Za-z0-9]", "", word)
})

#3.斷詞



mycorpus1 <- tm_map(mycorpus, segmentCN, nature = TRUE) 
#主要是這邊會出現error
#Error in get("Analyzer", envir = .RwordsegEnv) : object '.RwordsegEnv' not found
#好像打開後第一次切不會error 後來每一次都會
mycorpus2 <- Corpus(VectorSource(mycorpus1)) 


 c<-data.frame(text = sapply(mycorpus2, as.character), stringsAsFactors = FALSE)
 write.table(c,file="data2") #匯出檔案方便確認結果

#4.停止詞
myStopWords <- c(toTrad(stopwordsCN()),"一下")
mycorpus3 <- tm_map(mycorpus2, removeWords, myStopWords)

c<-data.frame(text = sapply(mycorpus3, as.character), stringsAsFactors = FALSE)
write.table(c,file="data2X")

library(wordcloud)
tdm <- TermDocumentMatrix(mycorpus3, control = list(wordLengths = c(2, Inf)))

m1 <- as.matrix(tdm)
v <- sort(rowSums(m1), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
wordcloud(d$word, d$freq, min.freq = 10, random.order = F, ordered.colors = F, 
          colors = rainbow(length(row.names(m1))))

