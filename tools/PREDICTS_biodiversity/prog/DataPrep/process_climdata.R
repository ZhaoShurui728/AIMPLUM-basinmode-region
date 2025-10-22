# load packages ------------------------------------------------------------

 library(raster)
 library(dplyr)

# Settings -----------------------------------------------------------------
#GCMs <- c("ACCESS-CM2","CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0", "GISS-E2-1-G", "INM-CM5-0", 
#"IPSL-CM6A-LR", "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", "UKESM1-0-LL")
#  GCMs <- c("ACCESS-CM2","CMCC-ESM2", "EC-Earth3-Veg", "GISS-E2-1-G", "INM-CM5-0", 
#            "IPSL-CM6A-LR", "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", "UKESM1-0-LL")
GCMs <- c("IPSL-CM6A-LR", "MPI-ESM1-2-HR", "MRI-ESM2-0", "UKESM1-0-LL")      
Years <- c("2021-2040","2041-2060","2061-2080","2081-2100")
Scenarios <- c("ssp585","ssp370","ssp245","ssp126")

# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir

climDataDir <- paste0(SharedDataDir,'WorldClim/') # if use in the cluster computer
outputDir1 <- paste0(outputDir,'processedData/WorldClim')
if(!dir.exists(outputDir1))dir.create(outputDir1)
outputDir2 <- paste0(outputDir,'processedData/inputVariables/EnvDist/')
if(!dir.exists(outputDir2))dir.create(outputDir2)

# data loading -------------------------------------------------------------
#---- prepare functions -------------------------------------------------------
# aggregating to PLUM grid
# read lon, lat
  mylon <- seq(-179.75,179.75,0.5)
  mylat <- seq(89.75,-89.75,-0.5)
  mylon_adjust <- mylon + 0.25
  mylat_adjust <- mylat*(-1) + 0.25
  
# function : convert database's longitude, latitude to pot_forest's one 
  
  convertlon <- function(lon){
    rev_lon <- NA
    
    for (i in 1:length(mylon)) {
      if (lon < mylon_adjust[i]) {
        rev_lon <- mylon[i]
        break
      } 
    }
    return(rev_lon)  
  }
  
  convertlat <- function(lat){
    rev_lon <- NA
    
    for (i in 1:length(mylat)) {
      if (lat < mylat_adjust[i]) {
        rev_lat <- mylat[i]
        break
      } 
    }
    return(rev_lat)
  }
  
#---- Apply to dataset ---------------------------------------------------------
 #---- future ------------------------------------------------------------------ 
 for (cur_scen in Scenarios) {
    print(paste(cur_scen))

    for (cur_Year in Years) {
     print(paste(cur_Year))
    
      for (cur_GCM in GCMs) {
       print(paste(cur_GCM))
        
       bio5 <- raster(paste0(climDataDir,"/",cur_GCM,"/",cur_scen,"/",paste("wc2.1_10m_bioc_",cur_GCM,"_",cur_scen,"_",cur_Year,".tif",sep = "")), band = 5)
       bio5_value <- rasterToPoints(bio5)
       bio5_value <- as.data.frame(bio5_value)
       colnames(bio5_value) <- c("longitude_original","latitude_original","bio5")
       
       # apply function to one file and make lonlat dataframe
       
       lon_dataset <- bio5_value$longitude_original
       lat_dataset <- bio5_value$latitude_original
       
       longitude_prop_bioclim <- as.vector(lon_dataset)
       latitude_prop_bioclim <- as.vector(lat_dataset)
       
       for (i in 1:nrow(bio5_value)) {
         longitude_prop_bioclim[i] <- NA
         latitude_prop_bioclim[i] <- NA
         
         longitude_prop_bioclim[i] <- convertlon(lon = lon_dataset[i])
         latitude_prop_bioclim[i] <- convertlat(lat = lat_dataset[i])
       }
       
       bio5_value <- bio5_value %>% 
         mutate(longitude_rev = longitude_prop_bioclim) %>% 
         mutate(latitude_rev = latitude_prop_bioclim)
       bio5_value <- bio5_value %>% 
         group_by(longitude_rev, latitude_rev) %>% 
         mutate(bio5 = mean(bio5)) %>% 
         distinct(bio5) %>% 
         ungroup() %>% 
         mutate(GCM_id = cur_GCM) %>% 
         mutate(Scenario_id = cur_scen) %>% 
         mutate(Year_id = cur_Year)
       
       bio6 <- raster(paste0(climDataDir,"/",cur_GCM,"/",cur_scen,"/",paste("wc2.1_10m_bioc_",cur_GCM,"_",cur_scen,"_",cur_Year,".tif",sep = "")), band = 6)
       bio6_value <- rasterToPoints(bio6)
       bio6_value <- as.data.frame(bio6_value)
       colnames(bio6_value) <- c("longitude_original","latitude_original","bio6")
       bio6_value <- bio6_value %>% 
         mutate(longitude_rev = longitude_prop_bioclim) %>% 
         mutate(latitude_rev = latitude_prop_bioclim)
       bio6_value <- bio6_value %>% 
         group_by(longitude_rev, latitude_rev) %>% 
         mutate(bio6 = mean(bio6)) %>% 
         distinct(bio6)%>% 
         ungroup() %>% 
         mutate(GCM_id = cur_GCM) %>% 
         mutate(Scenario_id = cur_scen) %>% 
         mutate(Year_id = cur_Year)
       
       bio13 <- raster(paste0(climDataDir,"/",cur_GCM,"/",cur_scen,"/",paste("wc2.1_10m_bioc_",cur_GCM,"_",cur_scen,"_",cur_Year,".tif",sep = "")), band = 13)
       bio13_value <- rasterToPoints(bio13)
       bio13_value <- as.data.frame(bio13_value)
       colnames(bio13_value) <- c("longitude_original","latitude_original","bio13")
       bio13_value <- bio13_value %>% 
         mutate(longitude_rev = longitude_prop_bioclim) %>% 
         mutate(latitude_rev = latitude_prop_bioclim)
       bio13_value <- bio13_value %>% 
         group_by(longitude_rev, latitude_rev) %>% 
         mutate(bio13 = mean(bio13)) %>% 
         distinct(bio13) %>% 
         ungroup() %>% 
         mutate(GCM_id = cur_GCM) %>% 
         mutate(Scenario_id = cur_scen) %>% 
         mutate(Year_id = cur_Year)
       
       bio14 <- raster(paste0(climDataDir,"/",cur_GCM,"/",cur_scen,"/",paste("wc2.1_10m_bioc_",cur_GCM,"_",cur_scen,"_",cur_Year,".tif",sep = "")), band = 14)
       bio14_value <- rasterToPoints(bio14)
       bio14_value <- as.data.frame(bio14_value)
       colnames(bio14_value) <- c("longitude_original","latitude_original","bio14")
       bio14_value <- bio14_value %>% 
         mutate(longitude_rev = longitude_prop_bioclim) %>% 
         mutate(latitude_rev = latitude_prop_bioclim)
       bio14_value <- bio14_value %>% 
         group_by(longitude_rev, latitude_rev) %>% 
         mutate(bio14 = mean(bio14)) %>% 
         distinct(bio14) %>% 
         ungroup() %>% 
         mutate(GCM_id = cur_GCM) %>% 
         mutate(Scenario_id = cur_scen) %>% 
         mutate(Year_id = cur_Year)
       
       # output bio5
       if(exists('collector_bio5_values')) {
         collector_bio5_values <- rbind.data.frame(collector_bio5_values,bio5_value)
       } else {
         collector_bio5_values <- bio5_value
       }
       # output bio6
       if(exists('collector_bio6_values')) {
         collector_bio6_values <- rbind.data.frame(collector_bio6_values,bio6_value)
       } else {
         collector_bio6_values <- bio6_value
       }
       # output bio13
       if(exists('collector_bio13_values')) {
         collector_bio13_values <- rbind.data.frame(collector_bio13_values,bio13_value)
       } else {
         collector_bio13_values <- bio13_value
       }
       # output bio14
       if(exists('collector_bio14_values')) {
         collector_bio14_values <- rbind.data.frame(collector_bio14_values,bio14_value)
       } else {
         collector_bio14_values <- bio14_value
       }
       
      }
    }
 }

#---- take median beteween GCMs --------------------------------------------------------------
  collector_bio5_mdn <- collector_bio5_values %>% 
  group_by(longitude_rev, latitude_rev, Scenario_id, Year_id) %>% 
  mutate(bio5_mdn = median(bio5)) %>% 
  #mutate(bio5_mean = mean(bio5))
  distinct(bio5_mdn) %>% 
  ungroup()

  collector_bio6_mdn <- collector_bio6_values %>% 
  group_by(longitude_rev, latitude_rev, Scenario_id, Year_id) %>% 
  mutate(bio6_mdn = median(bio6)) %>% 
  distinct(bio6_mdn) %>% 
  ungroup() 

  collector_bio13_mdn <- collector_bio13_values %>% 
  group_by(longitude_rev, latitude_rev, Scenario_id, Year_id) %>% 
  mutate(bio13_mdn = median(bio13)) %>% 
  distinct(bio13_mdn) %>% 
  ungroup() 

  collector_bio14_mdn <- collector_bio14_values %>% 
  group_by(longitude_rev, latitude_rev, Scenario_id, Year_id) %>% 
  mutate(bio14_mdn = median(bio14)) %>% 
  distinct(bio14_mdn) %>% 
  ungroup() 

if(exists('collector_bioclim_values_scemerge')){rm(collector_bioclim_values_scemerge)} 
for (cur_scen in Scenarios) {
  if(exists('collector_bioclim_values')){rm(collector_bioclim_values)} 
  for (cur_Year in Years) {
    
    bio5 <- collector_bio5_mdn %>% 
      filter(Scenario_id == cur_scen) %>% 
      filter(Year_id == cur_Year) %>% 
      dplyr::select(-c("Scenario_id","Year_id"))
    unique(bio5$Scenario_id)
    bio6 <- collector_bio6_mdn %>% 
      filter(Scenario_id == cur_scen) %>% 
      filter(Year_id == cur_Year) %>% 
      dplyr::select(-c("Scenario_id","Year_id"))
    
    bio13 <- collector_bio13_mdn %>% 
      filter(Scenario_id == cur_scen) %>% 
      filter(Year_id == cur_Year) %>% 
      dplyr::select(-c("Scenario_id","Year_id"))
    
    bio14 <- collector_bio14_mdn %>% 
      filter(Scenario_id == cur_scen) %>% 
      filter(Year_id == cur_Year) %>% 
      dplyr::select(-c("Scenario_id","Year_id"))
    
    bioclims <- bio5 %>% 
      left_join(bio6, by = c("longitude_rev","latitude_rev")) %>% 
      left_join(bio13, by = c("longitude_rev","latitude_rev")) %>% 
      left_join(bio14, by = c("longitude_rev","latitude_rev")) %>% 
      #left_join(alt_value_hist, by = c("longitude_rev","latitude_rev")) %>% 
      mutate(id = paste(cur_scen,cur_Year,sep = "_"))
      
    if(exists('collector_bioclim_values')) {
        collector_bioclim_values <- rbind.data.frame(collector_bioclim_values,bioclims)
      } else {
        collector_bioclim_values <- bioclims
    }
  }
  # output
  write.csv(collector_bioclim_values,paste(outputDir1,"/future_values_SceYear_spec_",cur_scen,".csv",sep = ""), row.names = FALSE)
  
  if(exists('collector_bioclim_values_scemerge')) {
    collector_bioclim_values_scemerge <- rbind.data.frame(collector_bioclim_values,collector_bioclim_values_scemerge)
  } else {
    collector_bioclim_values_scemerge <- collector_bioclim_values
  }
}
unique(collector_bioclim_values_scemerge$id)
# output
write.csv(collector_bioclim_values_scemerge,paste0(outputDir1,"/future_values.csv"),row.names = FALSE)

#---- historical --------------------------------------------------------------
   # get values
   bio5 <- raster(paste0(climDataDir,"/Historical/wc2.1_10m_bio_5.tif"))
   bio5_value_hist <- rasterToPoints(bio5)
   bio5_value_hist <- as.data.frame(bio5_value_hist)
   colnames(bio5_value_hist) <- c("longitude_original","latitude_original","bio5")
   
   # apply function to one file and make lonlat dataframe
   
   lon_dataset <- bio5_value_hist$longitude_original
   lat_dataset <- bio5_value_hist$latitude_original
   
   longitude_prop_bioclim <- as.vector(lon_dataset)
   latitude_prop_bioclim <- as.vector(lat_dataset)
   
   for (i in 1:nrow(bio5_value_hist)) {
     longitude_prop_bioclim[i] <- NA
     latitude_prop_bioclim[i] <- NA
     
     longitude_prop_bioclim[i] <- convertlon(lon = lon_dataset[i])
     latitude_prop_bioclim[i] <- convertlat(lat = lat_dataset[i])
   }

   bio5_value_hist <- bio5_value_hist %>% 
     mutate(longitude_rev = longitude_prop_bioclim) %>% 
     mutate(latitude_rev = latitude_prop_bioclim)
   bio5_value_hist <- bio5_value_hist %>% 
     group_by(longitude_rev, latitude_rev) %>% 
     mutate(bio5 = mean(bio5)) %>% 
     distinct(bio5) %>% 
     ungroup()
   
   bio6 <- raster(paste0(climDataDir,"/Historical/wc2.1_10m_bio_6.tif"))
   bio6_value_hist <- rasterToPoints(bio6)
   bio6_value_hist <- as.data.frame(bio6_value_hist)
   colnames(bio6_value_hist) <- c("longitude_original","latitude_original","bio6")
   bio6_value_hist <- bio6_value_hist %>% 
     mutate(longitude_rev = longitude_prop_bioclim) %>% 
     mutate(latitude_rev = latitude_prop_bioclim)
   bio6_value_hist <- bio6_value_hist %>% 
     group_by(longitude_rev, latitude_rev) %>% 
     mutate(bio6 = mean(bio6)) %>% 
     distinct(bio6) %>% 
     ungroup()
   
   bio13 <- raster(paste0(climDataDir,"/Historical/wc2.1_10m_bio_13.tif"))
   bio13_value_hist <- rasterToPoints(bio13)
   bio13_value_hist <- as.data.frame(bio13_value_hist)
   colnames(bio13_value_hist) <- c("longitude_original","latitude_original","bio13")
   bio13_value_hist <- bio13_value_hist %>% 
     mutate(longitude_rev = longitude_prop_bioclim) %>% 
     mutate(latitude_rev = latitude_prop_bioclim)
   bio13_value_hist <- bio13_value_hist %>% 
     group_by(longitude_rev, latitude_rev) %>% 
     mutate(bio13 = mean(bio13)) %>% 
     distinct(bio13) %>% 
     ungroup()
   
   bio14 <- raster(paste0(climDataDir,"/Historical/wc2.1_10m_bio_14.tif"))
   bio14_value_hist <- rasterToPoints(bio14)
   bio14_value_hist <- as.data.frame(bio14_value_hist)
   colnames(bio14_value_hist) <- c("longitude_original","latitude_original","bio14")
   bio14_value_hist <- bio14_value_hist %>% 
     mutate(longitude_rev = longitude_prop_bioclim) %>% 
     mutate(latitude_rev = latitude_prop_bioclim)
   bio14_value_hist <- bio14_value_hist %>% 
     group_by(longitude_rev, latitude_rev) %>% 
     mutate(bio14 = mean(bio14)) %>% 
     distinct(bio14) %>% 
     ungroup()
   
   alt <- raster(paste0(climDataDir,"/Historical/wc2.1_10m_elev.tif"))
   alt_value_hist <- rasterToPoints(alt)
   alt_value_hist <- as.data.frame(alt_value_hist)
   colnames(alt_value_hist) <- c("longitude_original","latitude_original","alt")
   alt_value_hist <- alt_value_hist %>% 
     mutate(longitude_rev = longitude_prop_bioclim) %>% 
     mutate(latitude_rev = latitude_prop_bioclim)
   alt_value_hist <- alt_value_hist %>% 
     group_by(longitude_rev, latitude_rev) %>% 
     mutate(alt = mean(alt)) %>% 
     distinct(alt) %>% 
     ungroup()
   
   bioclims_hist <- bio5_value_hist %>% 
     left_join(bio6_value_hist, by = c("longitude_rev","latitude_rev")) %>% 
     left_join(bio13_value_hist, by = c("longitude_rev","latitude_rev")) %>% 
     left_join(bio14_value_hist, by = c("longitude_rev","latitude_rev")) %>% 
     left_join(alt_value_hist, by = c("longitude_rev","latitude_rev")) %>% 
     mutate(id = "historical")
   
   # output
   write.csv(bioclims_hist, paste0(outputDir1,"/historical_values.csv"),row.names = TRUE) # rownames is used to specify each site
   
#---- Calculate EnvDist by gower -----------------------------------------------
 #---- load package 
   library(gower)
   
 #---- load data 
   bioclim_values_future <- read.csv(paste0(outputDir1,"/future_values.csv"))
   bioclim_values_historical <- read.csv(paste0(outputDir1,"/historical_values.csv")) %>% 
     dplyr::select(-c(id))
   
   if(exists('collector_envdist_values'))rm(collector_envdist_values)
   for (cur_id in unique(bioclim_values_future$id)) {
     print(paste(cur_id))
     # filtering future data by each id 
     values_future <- bioclim_values_future %>% 
       filter(id == cur_id) %>% 
       dplyr::select(-c(id))
  
     # merge dataset  
     merge <- values_future %>% 
       left_join(bioclim_values_historical, by = c("longitude_rev","latitude_rev"))
     
     #---- calculating envdist -----------------------------------------------------
     envVars = c("bio5","bio6","bio13","bio14","alt")
     
     histdata <- merge %>% 
       dplyr::select(bio5, bio6, bio13, bio14, alt)
     
     futuredata <- merge %>% 
       dplyr::select(bio5_mdn, bio6_mdn, bio13_mdn, bio14_mdn, alt)
     colnames(futuredata) <- c("bio5", "bio6", "bio13", "bio14","alt")
     
     # calculate
     gowerEnvDist <- gower_dist(histdata, futuredata)
     cubrtEnvDist<-gowerEnvDist^(1/3)
     
     #----- output dataframe
     output_template <- values_future %>% 
       dplyr::select(c(longitude_rev, latitude_rev)) %>% 
       mutate(cubrtEnvDist = cubrtEnvDist) %>% 
       mutate(id = paste(cur_id)) %>% 
       mutate(latitude_rev = -latitude_rev) # invert latitude to get consistency with other data
     
     if(exists('collector_envdist_values')) {
       collector_envdist_values <- rbind.data.frame(collector_envdist_values, output_template)
     } else {
       collector_envdist_values <- output_template
     }
   }     

#---- output -------------------------------------------------------------------
  
  # all scenario merge
   all_merge <- collector_envdist_values
   all_merge$id <- gsub(pattern = c("2021-2040"), replacement = c(2030), all_merge$id)  
   all_merge$id <- gsub(pattern = c("2041-2060"), replacement = c(2050), all_merge$id)  
   all_merge$id <- gsub(pattern = c("2061-2080"), replacement = c(2070), all_merge$id) 
   all_merge$id <- gsub(pattern = c("2081-2100"), replacement = c(2090), all_merge$id)  
   
   unique(all_merge$id)

   write.csv(all_merge,paste0(outputDir2,"/cubrtEnvDist_values_SceYear_Wldclim.csv"))
