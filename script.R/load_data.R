library(rgdal)
library(ggplot2)
library(ggmap)

data = read.csv('data/database_Antonella.csv', sep = ';')
names(data)

vars = c("Bicarbonati_mg.L_", "Calcio_mg.L_", "Cloruri_mg.L_", 
          "Magnesio_mg.L_", "Potassio_mg.L_", "Sodio_mg.L_", "Solfati_mg.L_")
X = data[,vars]

## Gauss-Boaga projection
coord = data[,c("EST_GB", "NORD.GB")]
names(coord) = c('x', 'y')
coord$x = as.numeric(as.character(coord$x))
coord$y = as.numeric(as.character(coord$y))

d = with(data, cbind(coord, X, Facies))
d = d[complete.cases(d),]

coordinates(d) <- c('x','y')
proj4string(d) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=0.9996 +x_0=1500000 +y_0=0 +ellps=intl +units=m +no_defs")

CRS.new <- CRS("+init=epsg:4326")
d <- data.frame(spTransform(d, CRS.new))

ggplot(data.frame(d), aes(x=x, y=y)) + geom_point() + theme_bw()

bbox <- ggmap::make_bbox(x, y, d, f = 0.5)
map = get_map(location = bbox, source="google", maptype='terrain', color='bw')

library(grid)
ggmap(map) + geom_point(data=d, aes(x = x, y = y, color=substr(Facies, 1, 2)), size=4,  alpha = .75) +
  xlab(NULL) + ylab(NULL)
  
