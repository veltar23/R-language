install.packages("tm")
install.packages("tmcn")
install.packages("jiebaR")
install.packages("text2vec")

library(tm)
library(tmcn)
library(jiebaR)
library(text2vec)

getwd()
setwd("C:/Users/ntuba1105.awo/Desktop/R_TM")

test<-read.csv(file.choose(), stringsAsFactors=FALSE)
str(test)
colnames(test)
test$message[1:10]


seg <- worker(stop_word = "./stopwords_tranditional chinese.txt")
test_jb_1 <- lapply(test$message, function(e) segment(code=e, jiebar=seg))


# define preprocessing function and tokenization function
test_ito <- itoken(test_jb_1, 
              ids = test$id, 
              progressbar = T)
test_vocab <- create_vocabulary(test_ito)
tail(test_vocab)
test_dtm = create_dtm(test_ito, test_vectorizer)
dim(test_dtm)
identical(rownames(test_dtm),test$id)


# create dtm with new pruned vocabulary vectorizer
test_pruned_vocab = prune_vocabulary(test_vocab, 
                                term_count_min = 10, 
                                doc_proportion_max = 0.5,
                                doc_proportion_min = 0.001)
test_pruned_vocab_vectorizer = vocab_vectorizer(test_pruned_vocab)
test_pruned_vocab_dtm = create_dtm(test_ito, test_pruned_vocab_vectorizer)
dim(test_pruned_vocab_dtm)

# create topic model 

test_LDA_ito = itoken(test_jb_1, ids = test$id, progressbar = T)
test_LDA_vocab = create_vocabulary(test_LDA_ito) %>%
  prune_vocabulary(term_count_min = 5)
test_LDA_vectorizer = vocab_vectorizer(test_LDA_vocab)
test_LDA_dtm = create_dtm(test_LDA_ito, test_LDA_vectorizer)
test_LDA_model = LDA$new(n_topics=6, doc_topic_prior = 0.1, topic_word_prior = 0.01)
test_doc_topic_distr = test_LDA_model$fit_transform(x = test_LDA_dtm, n_iter = 1000, 
                                                     convergence_tol = 0.001, 
                                                    n_check_convergence = 25, 
                                                     progressbar = T)

barplot(test_doc_topic_distr[1, ], xlab = "topic", 
        ylab = "proportion", ylim = c(0, 1), 
        names.arg = 1:ncol(test_doc_topic_distr))

test_LDA_model$get_top_words(n = 6, topic_number =c(1L, 2L, 3L, 4L, 5L, 6L), lambda = 1)
