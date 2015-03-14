data = read.csv('data/database_Antonella.csv', sep = ';')

data$EST_GB = as.numeric(as.character(data$EST_GB))
data$NORD.GB = as.numeric(as.character(data$NORD.GB))

vars = c("EST_GB", "NORD.GB", "Bicarbonati_mg.L_", "Calcio_mg.L_", "Cloruri_mg.L_", 
         "Magnesio_mg.L_", "Potassio_mg.L_", "Sodio_mg.L_", "Solfati_mg.L_", 
         "Sum.Cat", "Sum.An",
         "X.dev", "Ca..", "Mg..", "Na.K..", 
         "X.cat", "Y.cat", "SO4..", "HCO3..", "Cl.",
         "X.anioni", "Y.anioni", "LL_Na.K", "LL_HCO3.SO4", "LL_HCO3", "HCO3.meq",
         "Facies", "TDS")
more.vars = c("pH", "Conducibilità_uS_cm_20C_")
sel = complete.cases(data[,vars])
data = data[sel,c(vars,more.vars)]
names(data)[1:2] = c('x', 'y')

## Gauss-Boaga projection
library(rgdal)

coordinates(data) <- c('x', 'y')
proj4string(data) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=0.9996 +x_0=1500000 +y_0=0 +ellps=intl +units=m +no_defs")

CRS.new <- CRS("+init=epsg:4326")
data <- data.frame(spTransform(data, CRS.new))

library(ggmap)
bbox <- make_bbox(x, y, data, f = 0.5)
map = get_map(location = bbox, source="google", maptype='terrain', color='bw')

save(map, data, file = 'data/data_with_selected_variables_and_map.RData')


