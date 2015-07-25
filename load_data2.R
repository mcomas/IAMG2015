library(dplyr)
library(readr)

nms = c('EST_GB' = 'est',
        'NORD-GB' = 'nord',
        'pH' = 'ph',
        'Conducibilità_uS_cm_20C_' = 'conduct',
        'Bicarbonati_mg/L_' = 'HCO3',
        'Calcio_mg/L_' = 'Ca',
        'Cloruri_mg/L_'= 'Cl',
        'Magnesio_mg/L_' = 'Mg',
        'Potassio_mg/L_' = 'K',
        'Sodio_mg/L_' = 'Na',
        'Solfati_mg/L_' = 'SO4')
suppressWarnings(data <- read_csv2('data/database_Antonella.csv') %>% select(one_of(names(nms))) %>% 
  setNames(nms) %>%
  mutate(
    est = ifelse(est == 1, NA, est),
    nord = ifelse(nord == 1, NA, nord),
    conduct = as.numeric(conduct),
    id = seq_along(conduct)
    ) %>%
  tbl_df) %>% print

library(rgdal)
data.map = data %>% subset(!is.na(est) & !is.na(nord)) %>% select(id, est, nord) %>% data.frame
coordinates(data.map) = c('est', 'nord')
proj4string(data.map) = CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=0.9996 +x_0=1500000 +y_0=0 +ellps=intl +units=m +no_defs")

data.map = spTransform(data.map, CRS("+init=epsg:4326")) %>% data.frame %>% tbl_df
names(data.map)[which(names(data.map) == 'est')] = 'lon'
names(data.map)[which(names(data.map) == 'nord')] = 'lat'

(data <- left_join(data, data.map, by='id') )

library(ggmap)
bbox <- make_bbox(lon = lon, lat = lat, data = data, f = 0.5)
map = get_map(location = bbox, source="google", maptype='terrain', color='bw')
ggmap(map, extend = TRUE)

save(data, file='data/iamg_data.RData')
save(map, file='data/iamg_map.RData')
