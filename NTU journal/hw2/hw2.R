rm(list=ls(all.names=TRUE))
library(XML)
library(RCurl)
library(httr)

urlPath <- "https://www.ptt.cc/bbs/elderly/index33.html"
temp    <- getURL(urlPath, encoding = "big5")
xmldoc  <- htmlParse(temp)
title   <- xpathSApply(xmldoc, "//div[@class=\"title\"]", xmlValue)
author  <- xpathSApply(xmldoc, "//div[@class='author']", xmlValue)
date    <- xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
response<- xpathSApply(xmldoc, "//div[@class='nrec']", xmlValue)

alldata <- data.frame(title, author, date, response)

write.table(alldata,"pttelderly.csv") #你會在此Script資料夾下得到一個.csv

library(knitr)
data=read.table("pttelderly.csv")
kable(data)