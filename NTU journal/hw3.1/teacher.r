library(ggplot2)
library(plotly)
require(stats)

rawdata = read.csv('teacher.csv',
                   header = TRUE)
delId = which(is.na(rawdata$Year) == TRUE)
rawdata = rawdata[-delId,]
rawdata[is.na(rawdata)] = 0
lastyearId = length(rawdata$Year)
firstYear = rawdata$Year[1]
lastYear = rawdata$Year[lastyearId]
n = lastYear - firstYear + 1
allType = names(rawdata)
rownames(rawdata) <- 1:nrow(rawdata)

# NerTbale is as follows:
# year, people, type
# 1950, 100, prof.
# ...
# 2010, 50, lecture
typeId = c(2:9)
newTable = data.frame()
for( nid in c(48:n) )
{
  year = as.matrix(rep(rawdata$Year[nid], length(rawdata[nid,typeId])))
  people = as.matrix(as.numeric(rawdata[nid,typeId]))
  type = as.matrix(as.character(allType[typeId]))
  temp = cbind(year, log(people), type)
  newTable = rbind(newTable, temp)
}
names(newTable) = c('year', 'people', 'pos')
newTable = newTable[with(newTable, order(pos)),]
rownames(newTable) <- 1:nrow(newTable)

p <- plot_ly(data = newTable, x = ~year, 
             y = ~people, color = ~pos, mode='lines') %>%
     add_lines( yaxis = list(range = c(0,10)))
p
htmlwidgets::saveWidget(p, "index.html")