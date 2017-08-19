library(ggplot2)
library(plotly)
require(stats)

rawdata = read.csv('1.csv',
                   header = TRUE)

rho = cor(rawdata)
rhoall = rho[1,]

barplot(rhoall,
        ylim=c(0.9,1))



