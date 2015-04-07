data = read.csv('data/database_Antonella.csv', sep = ';')

library(dplyr)

data = data %>% mutate(
  x = as.numeric(as.character(EST_GB)),
  y = as.numeric(as.character(data$NORD.GB)),
  conduct = as.numeric(as.character(Conducibilità_uS_cm_20C_)),
  Ca = Ca..,
  Mg = Mg..,
  Na = Na.K.., ##En els facies només surt per Na
  SO4 = SO4..,
  HCO3 = HCO3..,
  Cl = Cl.)

vars = c("x", "y", "Bicarbonati_mg.L_", "Calcio_mg.L_", "Cloruri_mg.L_", 
         "Magnesio_mg.L_", "Potassio_mg.L_", "Sodio_mg.L_", "Solfati_mg.L_", 
         "Sum.Cat", "Sum.An",
         "X.dev", "Ca", "Mg", "Na", 
         "X.cat", "Y.cat", "SO4", "HCO3", "Cl",
         "X.anioni", "Y.anioni", "LL_Na.K", "LL_HCO3.SO4", "LL_HCO3", "HCO3.meq",
         "Facies", "TDS")
more.vars = c("pH", "conduct")

selection = complete.cases(data[,vars])
data = data %>% subset(selection) %>% select(one_of(c(vars, more.vars)))

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


