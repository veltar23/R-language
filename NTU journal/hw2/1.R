rm(list=ls(all.names=TRUE))
library(XML)
library(RCurl)
library(httr)

urlPath <- "https://www.ptt.cc/bbs/Bio-Job/index.html"
temp    <- getURL(urlPath, encoding = "UTF-8")
xmldoc  <- htmlParse(temp)
title   <- xpathSApply(xmldoc, "//div[@class=\"title\"]", xmlValue)
title   <- gsub("\n", "", title)
title   <- gsub("\t", "", title)
author  <- xpathSApply(xmldoc, "//div[@class='author']", xmlValue)
date    <- xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
response<- xpathSApply(xmldoc, "//div[@class='nrec']", xmlValue)

alldata <- data.frame(title, author, date, response)

write.table(alldata,"biojob.csv") #你會在此Script資料夾下得到一個.csv
