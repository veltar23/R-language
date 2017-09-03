


library(tm)
library(tmcn)
library(jiebaR)

test<-read.csv("HK_NPC_post7.csv", stringsAsFactors=FALSE)

getwd()
setwd("C:/Users/user/Documents/GitHub/R/Patient behavior/TM/TM5")

seg_cut <- worker(user="user.dict.utf8")
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