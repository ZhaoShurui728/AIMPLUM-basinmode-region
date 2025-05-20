# This code is for generating country code map for 0.25 degree
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(maps)
library(ggplot2)
library(furrr)
library(gdxrrw)
library(sf)
install.packages("rnaturalearthdata")
library(rnaturalearth)
sf_use_s2(FALSE)
worldmap = map_data('world')

#knitr::kable(head(worldmap, 20))


regmap_resol <- .05  # grid resolution for region mapping

df <- list()
output_dir <- '../output'

args <- commandArgs(trailingOnly=T)
gams_sys_dir <- as.character(args[1])
igdx(gams_sys_dir)

plan(multisession)

df$risomap <- read_csv(file='../define/Rmaps_region_iso.csv') %>% select(-group) %>% 
    rename(Country='region')

df$grid005 <- expand.grid(lon005=seq(-180,180,regmap_resol),
                          lat005=seq(-90,90,regmap_resol)) %>% 
  mutate(lon=floor(lon005*4)/4,lat=floor(lat005*4)/4) %>% 
  st_as_sf(coords = c("lon005", "lat005"), crs = 4326) %>%
  st_join(
    rnaturalearth::ne_countries(scale = "large", returnclass = "sf")[, c("iso_a3","name")]
  ) %>%
  filter(!is.na(iso_a3)| name == "Norway"| name == "France"| name == "Somaliland"| name == "Kosovo") %>%
  rename(RISO = iso_a3) %>%
  mutate(
    RISO = ifelse(name == "Norway", "NOR", RISO),
    RISO = ifelse(name == "France", "FRA", RISO),
    RISO = ifelse(name == "Somaliland", "SOM", RISO),
    RISO = ifelse(name == "Kosovo", "XKX", RISO),
    lon005 = sf::st_coordinates(.)[, 1],
    lat005 = sf::st_coordinates(.)[, 2]
  ) %>%
  select(-name) %>%
  st_drop_geometry() %>%
  arrange(lon005,lat005)


df$landshare <- df$grid005 %>% 
    mutate(landarea_share=(regmap_resol/0.25)**2) %>% 
    group_by(lon,lat,RISO) %>% summarise(landarea_share=sum(landarea_share),.groups='drop') %>% 
    group_by(lon,lat) %>% mutate(landarea_share=landarea_share/sum(landarea_share)) %>% ungroup()

df$landshare_AIM <- df$landshare %>% 
#    inner_join(df$risomap,by='Country') %>% 
    group_by(lon,lat,RISO) %>% summarise(landarea_share=sum(landarea_share),.groups='drop')

#write_csv(df$landshare_AIM,file=str_c(output_dir,'/landshare_iso.csv'))

df$landshare_AIM %>% 
    pivot_wider(names_from=RISO,values_from=landarea_share,values_fill=0) %>% 
    wgdx.reshape(symName='landshare',3,tName='RISO',str_c(output_dir,'/landshare_iso_quarter.gdx'))


