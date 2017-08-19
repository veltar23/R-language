library(ggplot2)
library(ggmap)
library(mapproj)

data<-read.csv("4.csv",encoding = "big-5")

data$lon <- data$WGS84Lon
data$lat <- data$WGS84Lat


map <- get_map(location = 'Taiwan', zoom = 8)
ggmap(map) + 
  geom_point(aes(x = lon, y = lat, colour = factor(sd), size = ratio),
             data = data)+
  scale_size(range = c(3, 8))


ggmap(map) + 
  geom_point(aes(x = lon, y = lat, colour = factor(照服員照護人數), size = ratio),
             data = data)+
  scale_size(range = c(3, 8))