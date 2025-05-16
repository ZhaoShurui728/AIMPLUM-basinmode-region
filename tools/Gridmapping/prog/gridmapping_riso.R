library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(maps)
library(ggplot2)
library(furrr)
library(gdxrrw)

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
    mutate(lon=floor(lon005*2)/2,lat=floor(lat005*2)/2) %>% 
    group_split(lon) %>% 
    future_map(.f=function(df_in){
        df_in %>% mutate(Country=map.where(x=lon005,y=lat005)) %>% 
            filter(!is.na(Country)) %>% 
            separate(col=Country,into=c('Country','Subregion'),sep=':') %>% 
            select(-Subregion)
        }) %>% 
    bind_rows() %>% arrange(lon005,lat005)

df$landshare <- df$grid005 %>% 
    mutate(landarea_share=(regmap_resol/0.5)**2) %>% 
    group_by(lon,lat,Country) %>% summarise(landarea_share=sum(landarea_share),.groups='drop') %>% 
    group_by(lon,lat) %>% mutate(landarea_share=landarea_share/sum(landarea_share)) %>% ungroup()

df$landshare_AIM <- df$landshare %>% 
    inner_join(df$risomap,by='Country') %>% 
    group_by(lon,lat,RISO) %>% summarise(landarea_share=sum(landarea_share),.groups='drop')

write_csv(df$landshare_AIM,file=str_c(output_dir,'/landshare_iso.csv'))

df$landshare_AIM %>% 
    pivot_wider(names_from=RISO,values_from=landarea_share,values_fill=0) %>% 
    wgdx.reshape(symName='landshare',3,tName='RISO',str_c(output_dir,'/landshare_iso.gdx'))

