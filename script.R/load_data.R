library(rgdal)
library(ggplot2)
library(ggmap)
library(spgrass6)

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


X = na.omit(coord)
coordinates(X) <- c('x','y')
proj4string(X) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=0.9996 +x_0=1500000 +y_0=0 +ellps=intl +units=m +no_defs")

CRS.new <- CRS("+init=epsg:4326")
d.new <- spTransform(X, CRS.new)

ggplot(data.frame(d.new), aes(x=x, y=y)) + geom_point() + theme_bw()

D = data.frame(d.new)
bbox <- ggmap::make_bbox(x, y, D, f = 0.5)
map = get_map(location = bbox, source="google", maptype='terrain', color='bw')

ggmap(map) + geom_point(data=data.frame(d.new), aes(x = x, y = y), color='red', size=1,  alpha = .75)

