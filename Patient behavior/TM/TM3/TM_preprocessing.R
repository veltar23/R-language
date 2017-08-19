rm(list=ls(all.names = TRUE))

# 1.install packages
library(tm)
library(tmcn)
library(jiebaR)

# 2.set wd, set corpora
getwd()
setwd("C:/Users/user/Dropbox/R/R/data mining")
HK_NPC_jb <-  Corpus( DirSource() ,list(language = NA))


# 3.remove...
HK_NPC_jb <- tm_map( HK_NPC_jb, stripWhitespace ) # white space??
HK_NPC_jb <- tm_map( HK_NPC_jb, removePunctuation ) # punctuation
HK_NPC_jb <- tm_map( HK_NPC_jb, removeNumbers ) # numbers
HK_NPC_jb <- tm_map( HK_NPC_jb,function( word ){ gsub( "[A-Za-z0-9]", "", word)}) # English & numbers




# 4. change...
HK_NPC_jb <- tm_map( HK_NPC_jb, PlainTextDocument ) # to plain text doc
length(HK_NPC_jb)
HK_NPC_jb <- paste0(HK_NPC_jb[[1]]$content,collapse = "") # to string
length(HK_NPC_jb)

# 5.Chinese text segmentation
cut <- worker() # set segmentation worker
cut_HK_NPC_jb <- cut[HK_NPC_jb] # segmentation

data_stw=read.table(file="stop.txt")

stopwords_CN=c(NULL)
for(i in 1:dim(data_stw)[1]){
  stopwords_CN=c(stopwords_CN,data_stw[i,1])
}
stopwords[i]=paste(unlist(stopwords[i]),collapse =", ")

HK_NPC_jb=tm_map(HK_NPC_jb,removeWords,stopwords_CN) # 删除停用词

cut_HK_NPC_jb_tab = table( cut_HK_NPC_jb )


write.table(cut_HK_NPC_jb_tab, file="C:/Users/user/Dropbox/R/R/data mining/data7")



# 6.keywords
cut_keywords <- worker("keywords",topn=30) # set keywords worker
cut_keywords[HK_NPC_jb] 