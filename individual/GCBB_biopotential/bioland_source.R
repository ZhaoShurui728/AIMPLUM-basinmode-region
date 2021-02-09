library(gdxrrw)
library(data.table)
library(reshape2)
library(dplyr)

reg <- factor(c("BRA","XLM", "XAF", "OECD", "XSE",
                "IND", "CHN", "XME", "XSA",
                "CIS","XNF"))
reg_all <- c(c("BRA","XLM", "XAF", 'USA','CAN','JPN','XE25','XOC', 'TUR', 'XER', "XSE",
               "IND", "CHN", "XME", "XSA",
               "CIS","XNF"))

reg_lab <- c('Brazil', 'Rest of South America', 'Rest of Africa','OECD',
                   'Southeast Asia', 'India', 'China', 'Middle East', 'Rest of Asia',
                   'Former Soviet Union', 'North Africa')



land_base <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_base_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))

land_soil1 <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_soil1_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))

land_soil2 <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_soil2_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))

land_biod1 <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_biod1_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))
land_biod2 <- land_biod1

land_all <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_all_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))

land_demand <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_soci_dem_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))

land_supply <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_soci_sup_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))
land_supdem <- rgdx.param("../../..\\output\\gdx\\analysis\\SSP2_soci_supdem_BaU_NoCC.gdx", symName = 'Area') %>%
  mutate(R=as.character(R), Y=as.numeric(as.character(Y)), L=as.character(L)) %>%
  filter(L %in% c('CL', 'FRS', 'GL', 'PAS', 'OL', 'SL', 'CROP_FLW', 'AFR')) %>%
  filter(R %in% reg_all) %>%
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(R,Y,L) %>%
  summarise(amount = sum(Area))


    
    
land_cb <- bind_rows(base = land_base, soil1=land_soil1, soil2 = land_soil2, biod1= land_biod1, biod2= land_biod2,
                     all= land_all,
                     demand=land_demand, supply=land_supply, supdem=land_supdem, .id = 'Scenario') %>%
  dcast(Scenario+Y+R~L) 


land_merg <- merge(land_cb, SSP_ARE_R_OECD %>% dplyr::select(-perc),
                   by.x=c('Scenario', 'Y','R'), by.y=c('Scenario', 'Y', 'RG'),all.x=T) %>%
  mutate(are_r = are_r/1000) %>% # change into million ha
  rename(BIOLD=are_r) %>%
  mutate(CL=ifelse(is.na(CL), 0, CL)) %>%
  mutate(FRS=ifelse(is.na(FRS), 0, FRS)) %>%
  mutate(GL=ifelse(is.na(GL), 0, GL)) %>%
  mutate(PAS=ifelse(is.na(PAS), 0, PAS)) %>%
  mutate(OL=ifelse(is.na(OL), 0, OL)) %>%
  mutate(SL=ifelse(is.na(SL), 0, SL)) %>%
  mutate(CROP_FLW=ifelse(is.na(CROP_FLW), 0, CROP_FLW)) %>%
  mutate(AFR=ifelse(is.na(AFR), 0, AFR)) %>%
  mutate(BIOLD=ifelse(is.na(BIOLD), 0, BIOLD)) %>%
  mutate(FRS_net=FRS-FRS/(FRS+GL)*BIOLD) %>%
  mutate(GL_net=GL-GL/(FRS+GL)*BIOLD) %>%
  dplyr::select(-FRS,-GL, -SL,-OL) %>%
  dplyr::rename(FRS=FRS_net, GL=GL_net) %>%
  melt(id.vars = c('Scenario', 'Y', 'R')) %>%
  group_by(Scenario, Y, R) %>%
  mutate(reg_tot_land = sum(value),
         frac_land = value/reg_tot_land) %>%
  ungroup()

  
  
  

landsource <- ggplot(land_merg %>%
         filter(Y %in% c(2010, 2050)) %>%
         mutate(variable=factor(variable, levels = c('CL', 'PAS', 'CROP_FLW', 'AFR','FRS', 'GL', 'BIOLD')))%>%
         mutate(Scenario=factor(Scenario, levels = rev(c('base','soil1','soil2','biod1','biod2','all', 'demand', 'supply', 'supdem')))) %>%
         mutate(Y=as.character(Y)), aes(x=Scenario, y=frac_land, fill=variable)) +
  geom_bar(stat = 'identity', position = 'stack')+
  facet_grid(R~Y)+
  scale_fill_manual(breaks = c('CL', 'PAS', 'CROP_FLW', 'AFR','FRS', 'GL', 'BIOLD'),
                    name='Land use type',
                    values = brewer.pal(7,"Dark2"),
                    labels = c('Cropland', 'Pasture', 'Fallow land', 'Afforestation','Forest', 'Glassland', 'Bioland'))+
  scale_x_discrete(breaks = c('base','soil1','soil2','biod1','biod2','all', 'demand', 'supply', 'supdem'),
                   labels = c("No policy", 
                              "Moderate soil protection",
                              "Enhanced soil protection",
                              "Moderate biodiversity protection", 
                              "Enhanced biodiversity protection",
                              "Full environmental policy",
                              "Demand-side policy", 
                              "Supply-side policy", 
                              "Demand- and supply-side policy"))+
  ylab('Fraction') + 
  coord_flip()+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=0, hjust = 1),
        legend.position = 'bottom')+
  guides(fill = guide_legend(nrow=1))


ggsave("../../../anal_output_r/Figure S4. landsource2010_2050.jpeg", landsource,device = 'jpeg', width = 10,height = 13, dpi = 600)
