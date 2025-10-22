# This code is for generating country-basin map for 0.5 degree
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(maps)
library(ggplot2)
library(furrr)
library(gdxrrw)
library(sf)
sf_use_s2(FALSE)


output_dir <- '../output'

# ベクタデータ
Basin_Boundary <- st_read("../data/Basin_Boundary_full/Basin_Boundary_full.shp")

# 並列処理の準備
plan(multisession)  # or sequential if not using parallel
options(future.seed = TRUE)

regmap_resol <- .05  # grid resolution for region mapping

#---
df <- list()

df$grid005 <- expand.grid(lon005 = seq(-180, 180, by = regmap_resol),
                          lat005 = seq(-90, 90, by = regmap_resol)) %>%
  mutate(lon=floor(lon005*2)/2,lat=floor(lat005*2)/2) %>% 
  st_as_sf(coords = c("lon005", "lat005"), crs = 4326, remove = FALSE) %>%
  st_join(Basin_Boundary, join = st_intersects, left = TRUE) %>%
  filter(!is.na(Basin)) %>%
  rename(RISO = ISO_A3) %>%
  select(-MAJ_BAS) %>%
  st_drop_geometry() %>%
  arrange(lon005,lat005)

df$landshare <- df$grid005 %>% 
  mutate(landarea_share=(regmap_resol/0.5)**2) %>% 
  mutate(RISOBasin = str_c(RISO, Basin, sep = "_")) %>% 
  group_by(lon,lat,RISOBasin) %>% summarise(landarea_share=sum(landarea_share),.groups='drop') %>% 
  group_by(lon,lat) %>% mutate(landarea_share=landarea_share/sum(landarea_share)) %>% ungroup()

df$landshare_AIM <- df$landshare %>% 
  pivot_wider(names_from=RISOBasin,values_from=landarea_share,values_fill=0) %>% 
  wgdx.reshape(symName='landshare',3,tName='RISOBasin',str_c(output_dir,'/landshare_basiniso_full.gdx'))



