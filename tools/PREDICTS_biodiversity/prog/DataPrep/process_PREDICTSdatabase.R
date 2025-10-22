# memo --------------------------------------------------------------------
# merge bioclim and human pop density
# devide database into forest and nonforest

# load packages and directory settings ------------------------------------

library(dplyr)
library(tidyr)
library(raster)

# -- directory settings
# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir


if(!dir.exists(paste0(outputDir,'processedData/PREDICTSdatabase')))dir.create(paste0(outputDir,'processedData/PREDICTSdatabase'))

# load data ----------------------------------------------------------

# PREDICTSdatabase
PREDICTSdatabase_2016 <- readRDS(paste0(dataDir,'PREDICTSdatabase/database_20160418.rds'))
PREDICTSdatabase_2023 <- readRDS(paste0(dataDir,'PREDICTSdatabase/database_20230327.rds'))

# human pop density data
humanpop_Density_ras <- raster(paste0(SharedDataDir,'GRUMP/gl_grumpv1_pdens_00_grid_30/gluds00ag/w001000.adf'))

# pot forest or nonforest
# -- potentially forested / potentially non-forested ecosystem (LUH2 v2h static data)
forest_mask <- raster(paste0(dataDir,'supplementary/staticData_quarterdeg.nc'), varname = "fstnf")

# bioclim data
bio5_ras <- raster(paste0(SharedDataDir,'WorldClim/Historical/wc2.1_10m_bio_5.tif'))
bio6_ras <- raster(paste0(SharedDataDir,'WorldClim/Historical/wc2.1_10m_bio_6.tif'))
bio13_ras <- raster(paste0(SharedDataDir,'WorldClim/Historical/wc2.1_10m_bio_13.tif'))
bio14_ras <- raster(paste0(SharedDataDir,'WorldClim/Historical/wc2.1_10m_bio_14.tif'))
alt_ras <- raster(paste0(SharedDataDir,'WorldClim/Historical/wc2.1_10m_elev.tif'))


# merge HPD and bioclim data ----------------------------------------------

# bind PREDICTSdatabase
PREDICTSdatabase <- rbind(PREDICTSdatabase_2016,PREDICTSdatabase_2023)

coordinates <- PREDICTSdatabase %>% 
  dplyr::select(c(Longitude,Latitude)) 
# merge HPD data
PREDICTSdatabase$Human_pop_density <- raster::extract(humanpop_Density_ras, coordinates)
# merge bioclim data
PREDICTSdatabase$bio5 <- raster::extract(bio5_ras, coordinates)
PREDICTSdatabase$bio6 <- raster::extract(bio6_ras, coordinates)
PREDICTSdatabase$bio13 <- raster::extract(bio13_ras, coordinates)
PREDICTSdatabase$bio14 <- raster::extract(bio14_ras, coordinates)
PREDICTSdatabase$alt <- raster::extract(alt_ras, coordinates)

# output 
saveRDS(PREDICTSdatabase ,paste0(outputDir,'processedData/PREDICTSdatabase/database.rds'))

# divide potentially forest or nonforest ----------------------------------

# extract forest
PREDICTSdatabase <- PREDICTSdatabase %>%
  mutate(pot_forest = raster::extract(forest_mask, coordinates))

PREDICTSdatabase_forest <- PREDICTSdatabase %>% 
  filter(pot_forest == 1) %>% 
  dplyr::select(-c(pot_forest)) 
saveRDS(PREDICTSdatabase_forest , paste0(outputDir,'processedData/PREDICTSdatabase/database_forest.rds'))
PREDICTSdatabase_nonforest <- PREDICTSdatabase %>% 
  filter(pot_forest == 0) %>% 
  dplyr::select(-c(pot_forest)) 
saveRDS(PREDICTSdatabase_nonforest , paste0(outputDir,'processedData/PREDICTSdatabase/database_nonforest.rds'))
