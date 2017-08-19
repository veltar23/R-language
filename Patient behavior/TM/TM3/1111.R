# 1.install packages
install.packages("tm")
install.packages("tmcn")
install.packages("jiebaR")
library(tm)
library(tmcn)
library(jiebaR)

# 2.set wd, set corpora
getwd()
setwd("C:/Users/ntuba1105.awo/Desktop/R_TM/doc")
HK_NPC_jb <-  Corpus( DirSource() ,list(language = NA))

# 3.remove...
HK_NPC_jb <- tm_map( HK_NPC_jb, stripWhitespace ) # white space™½
HK_NPC_jb <- tm_map( HK_NPC_jb, removePunctuation ) # punctuation
HK_NPC_jb <- tm_map( HK_NPC_jb, removeNumbers ) # numbers
HK_NPC_jb <- tm_map( HK_NPC_jb,function( word ){ gsub( "[A-Za-z0-9]", "", word)}) # English & numbers
StopWords <- toTrad(stopwordsCN()) # set stopword
HK_NPC_jb <- tm_map( HK_NPC_jb, removeWords, StopWords ) # remove stopwords™¤

# 4. change...
HK_NPC_jb <- tm_map( HK_NPC_jb, PlainTextDocument ) # to plain text doc
length(HK_NPC_jb)
HK_NPC_jb <- paste0(HK_NPC_jb[[1]]$content,collapse = "") # to string
length(HK_NPC_jb)

# 5.Chinese text segmentation
cut <- worker() # set segmentation worker
cut_HK_NPC_jb <- cut[HK_NPC_jb] # segmentation
cut_HK_NPC_jb_tab = table( cut_HK_NPC_jb )
write.table(cut_HK_NPC_jb_tab)


# 6.keywords
cut_keywords <- worker("keywords",topn=30) # set keywords worker
cut_keywords[HK_NPC_jb] 