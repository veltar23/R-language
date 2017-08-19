

##### text mining and word cloud using tm, tmcn, jiebaR #####

### 1. install packages (you can skip if you already have packages installed)

rm(list=ls(all.names = TRUE))

### 2. load the library and source the modified .R file
###    modifiedTermDocumentMatrix.R 解決tm 套件中處理中文編碼遇到的問題
library(jiebaR)
library( tm ) # Text Mining Package
library( Rwordseg ) #中文斷詞
library( tmcn ) #處理中文字的輔助套件
library( wordcloud ) # Word Clouds
library( colorspace ) # Color Space Manipulation

source("C:/Users/user/Dropbox/R/R/data mining/HK_NPC_post1") # 讀入修改的檔案, ...為存放該檔案的路徑


### 3. 用tm,tmcn 斷詞


#   3.1 讀取ptt資料夾下的所有文章
#       (如果ptt資料夾沒有放在工作目錄下,則DirSource裡面需放絕對路徑 ex: "C:/Users/.../ptt")
HK_NPC_jb <-  Corpus( DirSource() ,list(language = NA))

#   3.2 前處理
HK_NPC_jb <-  tm_map(HK_NPC_jb, stripWhitespace ) # 去掉空白
HK_NPC_jb <-  tm_map( HK_NPC_jb, removePunctuation ) # 去掉標點
HK_NPC_jb <-  tm_map( HK_NPC_jb, removeNumbers ) # 去掉數字
HK_NPC_jb <-  tm_map( HK_NPC_jb,function( word ){ gsub( "[A-Za-z0-9]", "", word)}) # 去掉英文跟數字

#   3.3 從停用詞詞庫把一些不想要、無意義的冗詞去掉
HK_NPC_jb <- toTrad(stopwordsCN()) # stopwordCN()是簡體字，用toTrad()轉成繁體
HK_NPC_jb2 <-  tm_map( HK_NPC_jb, removeWords, StopWords ) # 從pttData中含有StopWords的文字移除

# StopWords <-  c(StopWords, "朝聖") # 更新停用詞詞庫
# pttData2 <-  tm_map( pttData, removeWords, StopWords ) 更新完後要重新執行移除


#   3.4 斷詞結果
pttData_sep <- tm_map( pttData2, segmentCN , nature = TRUE,returnType='tm') 

#   3.5 用修改過的TermDocumentMatrixCN()來建立詞頻矩陣
tdm <- TermDocumentMatrixCN(pttData_sep, control=list(wordLengths = c(2,Inf)))
inspect(tdm) # 檢查結果
findFreqTerms(tdm, 30) # 把超過30次的字列出來

#   3.6 斷詞後取出名詞
pttData_cloud = tm_map( pttData2, PlainTextDocument ) # 把20篇文章放在一個陣列裡
pttData_cloud= segmentCN( pttData_cloud[[1]]$content, nature = TRUE) # 斷詞
pttData_cloud = unlist( pttData_cloud ) # 把所有斷好的詞取出來
noun = pttData_cloud[ names ( pttData_cloud ) == "n" ] # 取出名詞
tab = table( noun )
Data = as.data.frame( tab[ tab >= 1 ] ) # 名詞的頻率出現矩陣

#   3.7 做文字雲
wordcloud(
    words = Data$noun, freq = Data$Freq,
    min.freq =8,
    random.order = F, ordered.colors = T, 
    scale=c(8,.3),
    #scale=c(9,.8),
    colors = rainbow_hcl( nrow( Data ) )
)


### 4 jiebaR 作法

#   4.1 前處理: 流程跟上面相同
pttData_jb <-  Corpus( DirSource( "ptt") ,list(language = NA))
pttData_jb <-  tm_map( pttData_jb, stripWhitespace ) # 去掉空白
pttData_jb <-  tm_map( pttData_jb, removePunctuation ) # 去掉標點
pttData_jb <-  tm_map( pttData_jb, removeNumbers ) # 去掉數字
pttData_jb <-  tm_map( pttData_jb,function( word ){ gsub( "[A-Za-z0-9]", "", word)}) # 去掉英文跟數字
pttData_jb <-  tm_map( pttData_jb, PlainTextDocument ) # 把20篇文章放在一個陣列裡
pttData_jb <- paste0(pttData_jb[[1]]$content,collapse = "") # 把陣列中的內容(20篇文章)全部連在一起

cut <- worker() # 普通的結巴斷詞環境
cut_ptt <- cut[pttData_jb] # 把整理好的文章放到cut中做斷詞
tab = table( cut_ptt )
Data_jb = as.data.frame( tab[ tab >= 1 ] ) # 結巴的斷詞結果

#   4.2 後續也可以針對 Data_jb 做文字雲,參考3.7

#   4.3 補充: jiebaR keywords
cut_key <- worker("keywords",topn=20) # 設定參數為keywords, 並計算前20個重要的關鍵字
cut_key[pttData_jb] # 找出關鍵字


