library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(maps)
library(ggplot2)
library(gdxrrw)

variablemap <- read.table("commodity_aglu.map",sep="\t",header=T) 

#--- data load
colnames <- c("Basin","RISO","Year","Value","L")
colnames2 <- c("Variable","Basin","RISO","Year","Value")

data1 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLFrs_load')
data1$L <- "FRS"
data2 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLGra_load')
data2$L <- "GL"
data3 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLAfr_load')
data3$L <- "AFR"
data4 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLCro_load')
data4$L <- "CL"
data5 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLPas_load')
data5$L <- "PAS"
data6 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLUrb_load')
data6$L <- "SL"
data7 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLOth_load')
data7$L <- "OL"
data8 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QL2_load')
names(data8) <- colnames2
data9 <- rgdx.param('SSP2_BaU_NoCC_World.gdx','QLCrofal_load')
data9$L <- "CROP_FLW"

data8.1 <-data8 %>% 
  inner_join(variablemap,by="Variable") %>%
  group_by(Basin,RISO,Year,L) %>%
  mutate(Value_sum = sum(Value)) %>% 
  select(-Variable,-Value)%>% 
  rename(Value = Value_sum) %>%
  select("Basin","RISO","Year","Value","L")

names(data1) <- colnames
names(data2) <- colnames
names(data3) <- colnames
names(data4) <- colnames
names(data5) <- colnames
names(data6) <- colnames
names(data7) <- colnames
names(data9) <- colnames

data <- rbind(data1,data2,data3,data4,data5,data6,data7,data8.1,data9) %>% 
        mutate(RISOBasin = str_c(RISO, Basin, sep = "_")) %>%
#        select(-RISO) %>%
        select(-Basin) %>%
        select(RISO,RISOBasin, L, Year,Value) %>%
        filter(Year %in% c(2015,2020,2025,2030,2040,2050,2060,2070,2080,2090,2100))

row_2015 <- data[data$Year == 2015,]
row_2015$Year <- 2005
data <- rbind(data,row_2015)
row_2015$Year <- 2010
data <- rbind(data,row_2015)


data0 <- data %>% select(-RISO)

symDim <- 5
attr(data, "symName") <- "AgLULandusedata"
lst <- wgdx.reshape(data, symDim)
wgdx.lst(gdxName = "agludata_iso.gdx",lst)

symDim <- 4
attr(data0, "symName") <- "AgLULandusedata"
lst <- wgdx.reshape(data0, symDim)
wgdx.lst(gdxName = "agludata.gdx",lst)




