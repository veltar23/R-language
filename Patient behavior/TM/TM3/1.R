rm(list=ls(all.names = TRUE))
Sys.setlocale(category = "LC_ALL", locale = "cht")


# 1.install packages
library(tm)
library(tmcn)
library(jiebaR)
library(rvest)
library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)

# 2.set wd, set corpora
getwd()
setwd("C:/Users/user/Dropbox/R/R/data mining")
HK_NPC_jb <-  Corpus( DirSource() ,list(language = NA))

# 3.remove...
HK_NPC_jb <- tm_map( HK_NPC_jb, stripWhitespace ) # white space??
HK_NPC_jb <- tm_map( HK_NPC_jb, removePunctuation ) # punctuation
HK_NPC_jb <- tm_map( HK_NPC_jb, removeNumbers ) # numbers
HK_NPC_jb <- tm_map( HK_NPC_jb,function( word ){ gsub( "[A-Za-z0-9]", "", word)}) # English & numbers



f<-readLines('stop.txt')###讀取停止詞
stopwords<-c(NULL)
for(i in 1:length(f))
{
  stopwords[i]<-f[i]
}


HK_NPC_jb2<-filter_segment(HK_NPC_jb,stopwords)#去除中文停止詞

HK_NPC_jb3 <- as.VCorpus(HK_NPC_jb2)

# 4. change...
HK_NPC_jb3 <- tm_map( HK_NPC_jb3, PlainTextDocument ) # to plain text doc
length(HK_NPC_jb)
HK_NPC_jb3 <- paste0(HK_NPC_jb3[[1]]$content,collapse = "") # to string
length(HK_NPC_jb)

# 5.Chinese text segmentation
cut <- worker() # set segmentation worker
cut_HK_NPC_jb <- cut[HK_NPC_jb3] # segmentation





cut_HK_NPC_jb_tab = table( cut_HK_NPC_jb )

write.table(cut_HK_NPC_jb_tab, file="C:/Users/user/Dropbox/R/R/data mining/data3")



# 6.keywords
cut_keywords <- worker("keywords",topn=30) # set keywords worker
cut_keywords[HK_NPC_jb] 