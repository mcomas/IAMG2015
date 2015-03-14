if(!exists('ROOT')) ROOT = getwd()
load(sprintf('%s/data/data_with_selected_variables_and_map.RData', ROOT))

library(stringr)
data$Facies[str_sub(data$Facies, 1, 6) == 'Ca-HCO'] = 'Ca-HCO3'
data$Facies = as.character(data$Facies)

table(data$Facies)

facie.cat = apply(data[,c("Ca..", "Mg..", "Na.K..")], 1, function(r) c('Ca', 'Mg', 'Na')[which.max(r)]) 
facie.an = apply(data[,c("SO4..", "HCO3..", "Cl.")], 1, function(r) c('SO4', 'HCO3', 'Cl')[which.max(r)])
data$Facies2 = sprintf("%s-%s", facie.cat, facie.an)

## There are facies which are not as they are supposed to be 
## very few, maybe a manual error?
## maybe the source from where Facies2 was calculated was not correct, and Facie is the correct one.
## Last options, we can remove this observations.
mean(data$Facies != data$Facies2)  # 0.6% of available data
## They are distributed as follows
table(data$Facies, data$Facies2)

save(map, data, file=sprintf('%s/data/data_with_selected_variables_and_map.RData', ROOT))
