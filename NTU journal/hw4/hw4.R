library(ggplot2)
library(plotly)
require(stats)

rdata=read.csv("Number of Workers.csv",header = TRUE)


LastyearId = length(rdata$End.of.Year)
FirstYear = rdata$End.of.Year[1]
LastYear = rdata$End.of.Year[LastyearId]
n = LastYear - FirstYear + 1
AllType = names(rdata)
rownames(rdata) <- 1:nrow(rdata)

TypeId = c(2:7)
NewTable = data.frame()
for( Nid in c(1:n) )
{
  Year = as.matrix(rep(rdata$End.of.Year[Nid], length(rdata[Nid,TypeId])))
  People = as.matrix(as.numeric(rdata[Nid,TypeId]))
  Type = as.matrix(as.character(AllType[TypeId]))
  Temp = cbind(Year, log(People), Type)
  NewTable = rbind(NewTable, Temp)
}
names(NewTable) = c('year', 'people', 'pos')
NewTable = NewTable[with(NewTable, order(pos)),]
rownames(NewTable) <- 1:nrow(NewTable)

P <- plot_ly(NewTable, x = ~Year,
             y = ~People, color = ~pos) %>%
  add_lines( yaxis = list(range = c(0,10)))

P
htmlwidgets::saveWidget(P, "1.html")

ggplot2(NewTable)