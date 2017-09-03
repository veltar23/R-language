##########
###???###
##########

## install packages
install.packages("dplyr")
install.packages('lubridate')
library(dplyr)
library(lubridate)

## read data
test<-read.csv(file.choose(), stringsAsFactors=FALSE)
str(test)
test$message[1:10]

# time data transformation
test$trans_time = as.POSIXct(test$update_time, tz="Asia/Taipei", format = "%Y-%m-%dT%H:%M:%S")
test$trans_time_year = year(test$trans_time)
test$trans_time_month = month(test$trans_time)
test$trans_time_weekday = wday(test$trans_time)
max(test$trans_time)
min(test$trans_time)

## hist of post frequency
length(test$author)
length(unique(test$author))
post_table = as.data.frame(table(test$author,dnn = "author"))
sort(post_table[,2])

hist(post_table$Freq,
     breaks = c(1:max(post_table[,2])),
     main = "Histogram of post",
     xlab = "Frequency in about 5 month")

## subset by post frequency
#one_post = duplicated(test$author)
#test_duration = which(post_table[,2]>=2)
join_freq_table = left_join(test, post_table, by ="author")
str(join_freq_table)
#merge(test, post_table, by = "author")
one_post_table = subset(join_freq_table, join_freq_table$Freq==1)
two_or_more_posts_table = subset(join_freq_table, join_freq_table$Freq>=2)
summary(join_freq_table)
summary(one_post_table)
summary(two_or_more_posts_table)

## barplot of post and time
join_year_table = table(join_freq_table$trans_time_year)
join_month_table = table(join_freq_table$trans_time_month)
join_weekday_table = table(join_freq_table$trans_time_weekday)
one_year_table = table(one_post_table$trans_time_year)
one_month_table = table(one_post_table$trans_time_month)
one_weekday_table = table(one_post_table$trans_time_weekday)
two_or_more_year_table = table(two_or_more_posts_table$trans_time_year)
two_or_more_month_table = table(two_or_more_posts_table$trans_time_month)
two_or_more_weekday_table = table(two_or_more_posts_table$trans_time_weekday)

par(mfcol = c(3,3),mar=c(2,2,2,2))
barplot(join_year_table, col = "yellow", border = "grey", main = "all_year")
barplot(join_month_table, col = "yellow", border = "grey", main = "all_month")
barplot(join_weekday_table, col = "yellow", border = "grey", main = "all_weekday")
barplot(one_year_table, col = "lightblue", border = "grey", main = "one_year")
barplot(one_month_table, col = "lightblue", border = "grey", main = "one_month")
barplot(one_weekday_table, col = "lightblue", border = "grey", main = "one_weekday")
barplot(two_or_more_year_table, col = "pink", border = "grey", main = "more_year")
barplot(two_or_more_month_table, col = "pink", border = "grey", main = "more_month")
barplot(two_or_more_weekday_table, col = "pink", border = "grey", main = "more_weekday")

## distribution and proportion of LIKES
par(mfcol = c(3,1),mar=c(2,2,2,2))
hist(test$likes, col = "yellow", border = "grey", main = "all_likes")
hist(one_post_table$likes, col = "lightblue", border = "grey", main = "one_likes")
hist(two_or_more_posts_table$likes, col = "pink", border = "grey", main = "more_likes")

join_p_likes_table = table(join_freq_table$likes)/sum(join_freq_table$likes)
one_p_likes_table = table(one_post_table$likes)/sum(one_post_table$likes)
two_or_more_p_likes_table = table(two_or_more_posts_table$likes)/sum(two_or_more_posts_table$likes)
par(mfcol = c(3,1),mar=c(0.5,0.5,0.5,0.5))
pie(join_p_likes_table, col = "yellow", border = "black", main = "all_p_likes")
pie(one_p_likes_table, col = "lightblue", border = "black", main = "one_p_likes")
pie(two_or_more_p_likes_table, col = "pink", border = "black",main = "more_p_likes")
as.data.frame(join_p_likes_table)
as.data.frame(one_p_likes_table)
as.data.frame(two_or_more_p_likes_table)

## subset by time
year2014_table = subset(join_freq_table, join_freq_table$trans_time_year==2014)
year2015_table = subset(join_freq_table, join_freq_table$trans_time_year==2015)
year2016_table = subset(join_freq_table, join_freq_table$trans_time_year==2016)
year2017_table = subset(join_freq_table, join_freq_table$trans_time_year==2017)

## duration between posts

