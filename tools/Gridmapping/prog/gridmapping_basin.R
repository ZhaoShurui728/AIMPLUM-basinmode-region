#library(ncdf4)
#library(exactextractr)
#library(raster)
#library(rmapshaper)
#library(tidyverse)
#library(gdxrrw)

library(readxl)
library(openxlsx)
library(sf)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(maps)
library(ggplot2)
library(furrr)
library(future)
sf_use_s2(FALSE)

output_dir <- '../output'

# ベクタデータ
Basin <- st_read("../data/Basin/major_hydrobasins.shp")
 
#---
# 解像度と0.05度グリッド生成

regmap_resol <- 0.05
grid_points <- expand.grid(
  lon005 = seq(-180, 180, by = regmap_resol),
  lat005 = seq(-90, 90, by = regmap_resol)
) %>%
  mutate(
    lon = floor(lon005 * 2) / 2,  # 0.5度に丸める
    lat = floor(lat005 * 2) / 2
  )

# 並列処理の準備
plan(multisession)  # or sequential if not using parallel
options(future.seed = TRUE)


basin_agg <- read.xlsx("../data/Basin/Basin_agg.xlsx",sheet = "Aggregate")

# POINTジオメトリ化
pts_sf <- st_as_sf(grid_points, coords = c("lon005", "lat005"), crs = 4326, remove = FALSE)
  
# 空間結合でどのBasinに属するか判定
# 結果整形（必要ならNAとジオメトリ情報削除）
pts_joined <- st_join(pts_sf, Basin, join = st_intersects, left = TRUE) %>%
  st_drop_geometry() %>%
  select(lon005, lat005, lon, lat, MAJ_BAS, MAJ_NAME, MAJ_AREA) %>%
  filter(!is.na(MAJ_BAS))

pts_joined2<- full_join(pts_joined,basin_agg,by="MAJ_BAS")  %>%
  filter(!is.na(MAJ_BAS2)) %>% select(!MAJ_BAS) %>% rename("MAJ_BAS"="MAJ_BAS2")

pts_joined3 <- pts_joined2[c(-1,-2,-6)]

# display results
#head(pts_joined2)

symDim <- 5
attr(pts_joined3, "symName") <- "gridbasin"
lst <- wgdx.reshape(pts_joined3, symDim)
wgdx.lst(gdxName = "../output/gridbasinmap_wname.gdx",lst)

