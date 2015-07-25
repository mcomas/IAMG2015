clean_zeros = function(.data) .data  %>% subset(apply(.data %>% select(HCO3, Ca, Cl, Mg, K, Na, SO4), 1, prod) != 0)
clean_non_located = function(.data) .data  %>% subset(complete.cases(.data %>% select(est, nord)))
compo = function(.data) .data %>% select(HCO3, Ca, Cl, Mg, K, Na, SO4) %>% subset(apply(., 1, prod) != 0)
mgL_to_mmol = function(.data) .data %>% mutate(
  HCO3=HCO3/61.02,
  Ca=Ca/40.078,
  Cl=Cl/35.4527,
  Mg=Mg/24.305,
  K=K/39.0983,
  Na=Na/22.989,
  SO4=SO4/96.06 )
mmol_to_meq = function(.data) .data %>% mutate(
  HCO3=HCO3,
  Ca=2*Ca,
  Cl=Cl,
  Mg=2*Mg,
  K=K,
  Na=Na,
  SO4=2*SO4
)
tern_ca = function(.data) .data %>% 
  mutate(Ca = Ca, Mg = Mg, Na.K = Na + K) %>% 
  select(Ca, Mg, Na.K)
tern_an = function(.data) .data %>% 
  select(Cl, SO4, HCO3)
closure = function(.data, k = 100) (k*.data/apply(.data, 1, sum)) %>% round(4) %>% tbl_df
gmean = function(...){
  .data = data.frame(list(...))
  apply(.data, 1, prod)^(1/NCOL(.data))
}
balance = function(.data) .data %>% select(HCO3, Ca, Cl, Mg, K, Na, SO4) %>%
  mutate(
    b1 = sqrt(4*3/(4+3)) * log(gmean(Ca, Mg, Na, K) / gmean(HCO3, SO4, Cl)),
    b2 = sqrt(2*2/(2+2)) * log(gmean(Ca, Mg) / gmean(Na, K)),
    b3 = sqrt(1*1/(1+1)) * log(Ca/Mg),
    b4 = sqrt(1*1/(1+1)) * log(Na/K),
    b5 = sqrt(1*2/(1+2)) * log(gmean(HCO3)/gmean(SO4, Cl)),
    b6 = sqrt(1*1/(1+1)) * log(SO4/Cl) ) %>% select(b1,b2,b3,b4,b5,b6)