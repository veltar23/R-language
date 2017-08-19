
######################################################################################
#### TEXT MINING-PREPROCESSING FROM https://rpubs.com/chrisbail/nlp_and_topic_models
######################################################################################

## 1)INSTALL PACKAGES
# install.packages("tm")
# install.packages("tmcn")
# install.packages("jiebaR")
# install.packages("wordcloud2")
library(tm)
library(tmcn)
library(jiebaR)
library(wordcloud2)

## 2)SET WD, or corpora: HK_NPC_jb <-  Corpus( DirSource() ,list(language = NA)))
getwd()
setwd("C:/Users/ASUS/Downloads")

## 3)READ DATA
test<-read.csv(file.choose(), stringsAsFactors = F)
str(test$id)
test$id = as.character(test$id)
colnames(test)
test$message[1:10]

## 4)REMOVE...
test_corpus_1 <- Corpus(VectorSource(test$message))
inspect(test_corpus_1[1:10])
test_corpus_2 <- tm_map(test_corpus_1,removePunctuation)
inspect(test_corpus_2[1:10])
test_corpus_3 <- tm_map(test_corpus_2,stripWhitespace)
inspect(test_corpus_3[1:10])
test_corpus_4 <- tm_map(test_corpus_3,function( word ){ gsub( "[A-Za-z0-9]", "", word)}) 
inspect(test_corpus_4[1:10])
length(test_corpus_4)

## 5)CHANGE TO...
test_corpus_5 <- tm_map( test_corpus_4, PlainTextDocument ) # to plain text doc
inspect(test_corpus_5)[[2]]
length(test_corpus_5)
test_corpus_6 <- paste0(test_corpus_5[[1]]$content,collapse = "") # to string
length(test_corpus_6)

## 6)SEGMENTATION (or filter_segment()) and WORDCLOUD
seg <- worker(stop_word = "./stopwords_tranditional chinese.txt") # set segmentation worker
HK_NPC_seg_1 <- seg[test_corpus_6] # segmentation
HK_NPC_seg_2 <- HK_NPC_seg_1[nchar(HK_NPC_seg_1)>1]
HK_NPC_seg_3 <- table(HK_NPC_seg_2)
HK_NPC_seg_4 <- sort(HK_NPC_seg_3,decreasing = T)[1:100]
HK_NPC_seg_5 <- as.data.frame(HK_NPC_seg_4,stringsAsFactors = F)
wordcloud2(HK_NPC_seg_5,size = 0.8, minSize = 0, gridSize =  0,
           fontFamily = 'Segoe UI', fontWeight = 'bold',
           color = 'random-dark', backgroundColor = "white",
           minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE,
           rotateRatio = 0.4, shape = 'circle', ellipticity = 0.65,
           widgetsize = NULL, figPath = NULL, hoverFunction = NULL)

## 7)KEYWORDS
HK_NPC_keywords <- worker("keywords", topn=30) # set keywords worker
HK_NPC_keywords[test_corpus_6] 
HK_NPC_keywords <- worker("keywords", stop_word = "./stopwords_tranditional chinese.txt", topn=30) # set customized keywords worker
HK_NPC_keywords[test_corpus_6] 







library(tm)
library(tmcn)
library(jiebaR)

test<-read.csv(file.choose(), stringsAsFactors=FALSE)
colnames(test)
test$message[1:10]

getwd()
setwd("C:/Users/ntuba1105.awo/Desktop/R_TM")
#seg_cut <- worker(stop_word = "./stopwords_tranditional chinese.txt")
seg_cut <- worker()
test_seg <- lapply(test$message, function(e) segment(code=e, jiebar=seg_cut))

gg=list()
for(i in 1:length(test$message)){
  name = sprintf('%s', test$id[i])
  gg[name] = list(segment(test$message[i], jiebar=seg_cut))
  print(i / length(test$message))
}

test_doc_1 <- VCorpus(VectorSource(test_seg))
library(text2vec)

it_train = itoken(gg, 
                  progressbar = T)
library(magrittr)
vocab = create_vocabulary(it_train)
tail(vocab)

# create dtm-----
vectorizer = vocab_vectorizer(vocab)
dtm_train = create_dtm(it_train, vectorizer) %>% as.matrix() %>% data.frame()
dtm_train$id = row.names(dtm_train)
gg=merge(dtm_train, test, by  = 'id')

# test_doc_2 <- unlist(tm_map(test_doc_1, jieba_tokenizer),recursive=F)
# test_doc_3 <- lapply(test_doc_2, function(d)paste(d,collapse=' '))
# control.list <- list(wordLengths=c(2,Inf),tokenize=space_tokenizer)
# test_dtm <- DocumentTermMatrix(Corpus(VectorSource(test_doc_1)),control=control.list)
# dim(test_dtm)
# findFreqTerms(test_dtm,200,300)