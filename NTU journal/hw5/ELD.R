rm(list=ls(all.names = TRUE))
library(tmcn)
library(rvest)
URL = "https://www.ptt.cc/bbs/elderly/index.html"
html = read_html(URL)
title = html_nodes(html,"a")
href = html_attr(title,"href")
data = data.frame(title = toUTF8(html_text(title)),href = href)

#去掉不需要的資訊
data = data[-c(1:10),]

getContent <- function(href){
  subURL = paste0("https://www.ptt.cc",href)
  subhtml = read_html(subURL)
  content = html_nodes(subhtml,"div#main-content.bbs-screen.bbs-content")
  return(toUTF8(html_text(content)))
}

allText = sapply(data$href,getContent)
allText
write.table(allText,"mydata.txt") # 儲存成 .txt 檔 
