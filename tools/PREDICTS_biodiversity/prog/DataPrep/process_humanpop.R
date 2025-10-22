#---- load data & packages -----------------------------------------------------
# packages  
library(gdxrrw)
library(raster)
library(dplyr)
library(tidyr)

# igdx   
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
gams_sys_dir <- args[1]
cat("Gams system directory is", gams_sys_dir, "\n")
igdx(gams_sys_dir)


# -- directory settings
# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir

# load data (Which is used in SpatialHealth and updated SSP version)
HP_grid <- rgdx.param(paste0(dataDir,"supplementary/populationSSP_update.gdx"),"populationSSP_update")

# pixel area
myarea_value <- raster(paste0(dataDir,'supplementary/staticData_quarterdeg.nc'), varname = 'carea') %>% 
  raster::aggregate(fact = 2, fun = sum) %>%
  rasterToPoints() %>%
  as.data.frame()
colnames(myarea_value) <- c("longitude_rev", "latitude_rev", "area_of_pixel") 

#---- process ------------------------------------------------------------------
 # make lon lat functions 
  convertlat <- function(lat_num_vector){
    rev_lat <- lat_num_vector
    
    for (i in 1:length(lat_num_vector)) {
      if (lat_num_vector[i] <= 180) {
        rev_lat[i] <- 90 - lat_num_vector[i]*0.5 + 0.25
      }else if (lat_num_vector[i] >= 181) {
        rev_lat[i] <- (lat_num_vector[i] - 180)*(-0.5) + 0.25  
      }
    }
    return(rev_lat)  
  }
  
  convertlon <- function(lon_num_vector){
    rev_lon <- lon_num_vector
    
    for (i in 1:length(lon_num_vector)) {
      rev_lon[i] <- (lon_num_vector[i] - 360)*0.5 - 0.25  
    }
    return(rev_lon)  
  }
  
  # Apply function to database
  
  Apply_lonlat_prop_hp <- function(dataset) {
    
    lon_database <- as.numeric(as.character(dataset$Slng)) 
    lat_database <- as.numeric(as.character(dataset$Slat))
    
    longitude_prop_hp <- convertlon(lon_database)
    latitude_prop_hp <- convertlat(lat_database)
    
    dataset <- dataset %>% 
      mutate(longitude_rev = longitude_prop_hp) %>% 
      mutate(latitude_rev = latitude_prop_hp)
    
    return(dataset)
  }

#---- execute ------------------------------------------------------------------
 HP_grid_process <- Apply_lonlat_prop_hp(HP_grid) %>% 
    dplyr::select(-Slat,-Slng)
 HP_grid_process$Syr <- as.numeric(as.character(HP_grid_process$Syr))
 HP_grid_process$ssp <- as.character(HP_grid_process$ssp)
 
#---- Convert from human_pop to human_pop_density ------------------------------
 HPD_grid_process <- HP_grid_process %>% 
   left_join(myarea_value, by = c("longitude_rev", "latitude_rev")) %>% 
   mutate(Human_pop_density = populationSSP_update/area_of_pixel) %>% 
   dplyr::select(-c(area_of_pixel)) %>% 
   mutate(id = paste(ssp,Syr,sep = "_")) 
 HPD_grid_process2 <- HPD_grid_process %>% 
   arrange(ssp, Syr, latitude_rev)
 
 if(!dir.exists(paste0(outputDir,'processedData/inputVariables/HPD')))dir.create(paste0(outputDir,'processedData/inputVariables/HPD'))
 write.csv(HPD_grid_process2, paste0(outputDir,"/processedData/inputVariables/HPD/HPD_grid.csv"), row.names = FALSE)

 