
library(dplyr)
library(lubridate)
library(plyr)

## read data
test<-read.csv("post.csv", stringsAsFactors=FALSE)

## 分析發文次數
post = as.data.frame(table(test$author,dnn = "author"))
sort(post[,2])
count_table=as.data.frame(table(table(test$author,dnn = "author")))

##畫圖
hist(post$Freq,
     breaks = c(1:max(post_table[,2])),
     main = "Histogram of post",
     xlab = "Frequency in about 5 month")


##資料加入po文頻率
test1 = left_join(test, post, by ="author")
##原資料剔除只po一次
test2=subset(test1, test1$Freq>=2)

#挑出要分析的欄
test3<-test2[ ,c(2,6) ]


#轉換時間格式
test3$update_time<-as.Date(as.POSIXlt(test3$update_time))



#求各作者po文時間差
test4<-as.data.frame(tapply(test3$update_time,
        test3$author,
       diff.difftime,unit="days"))

test4<-as.data.frame(tapply(test3$update_time,
                            test3$author,
                            diff.Date,unit="days"))



test5<-unlist(test4$`tapply(test3$update_time, test3$author, diff.Date, unit = "days")`)
mean(test5)





test4<-group_by(test3,author) %>% 
difftime( test3$update_time[1:length(test3$author)-1],
          test3$update_time[2:length(test3$author)])
                                         
test5<-test4$`tapply(test3$update_time, test3$author, diff.Date)`/C(86400)

  