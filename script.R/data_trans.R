library(dplyr)
library(stringr)
library(mixpack)
if(!exists('ROOT')) ROOT = getwd()
load(sprintf('%s/data/clean_data.RData', ROOT))

##############
### Preparing data
df1.coda = data %>% 
  mutate(
    'Facie' = factor(sapply(str_split(data$Facies, '-'), function(v) v[1]), levels=c('Ca', 'Mg', 'Na'))
  ) %>%
  select(x, y, Facie, Ca, Mg, Na)

df2.coda <- data %>%
  mutate(
    'Facie' = factor(sapply(str_split(data$Facies, '-'), function(v) v[2]), levels=c('SO4', 'HCO3', 'Cl'))
  ) %>% 
  select(x, y, Facie, SO4, HCO3, Cl)

df1.clr = df1.coda %>% 
  mutate(
    'clrCa' = log(Ca/(Ca*Mg*Na)^(1/3)),
    'clrMg' = log(Mg/(Ca*Mg*Na)^(1/3)),
    'clrNa' = log(Na/(Ca*Mg*Na)^(1/3))
  ) %>% 
  select(x, y, Facie, clrCa, clrMg, clrNa)
df2.clr = df2.coda %>% 
  mutate(
    'clrSO4'  = log(SO4/(SO4*HCO3*Cl)^(1/3)),
    'clrHCO3' = log(HCO3/(SO4*HCO3*Cl)^(1/3)),
    'clrCl'   = log(Cl/(SO4*HCO3*Cl)^(1/3))
  ) %>% 
  select(x, y, Facie, clrSO4, clrHCO3, clrCl)

df1.ilr = ilr_coordinates(df1.coda %>% select(Ca, Mg, Na) )  %>% cbind(df1.coda %>% select(Facie))
df2.ilr = ilr_coordinates(df2.coda %>% select(SO4, HCO3, Cl))  %>% cbind(df2.coda %>% select(Facie))

save(df1.coda, df2.coda, df1.clr, df2.clr, df1.ilr, df2.ilr, file=sprintf('%s/data/data-trans.RData', ROOT))
