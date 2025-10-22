
# COMMENTS ----------------------------------------------------------------
# date 20240501

# LIBRARIES ---------------------------------------------------------------
library(ncdf4) 
library(raster) 
library(dplyr)
library(tidyr)
library(foreach)
library(doParallel)

# Switches & Paths to each file ---------------------------------

# -- Arguments from shell script  
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
# Scenario
SceName <- args[1]
cat("Landuse scenario name is", SceName, "\n")
# Project name
PRJ <- args[2]
cat("Projcet name is", PRJ, "\n")
# RCP scenario for EnvDist data
Climate_sce <- args[3]
cat("Climate_sce is", Climate_sce, "\n")

# calculation year, if input climate data. # if not input climate data, calculate with land use data year
if (Climate_sce != 'none'){
  calYear <- c(2005,2010,2030,2050,2070,2090)
  cat("output", calYear,"\n")
  calYearTimeValsMap <- data.frame(calYearList = c(2005,seq(2010,2100,10)),timeValsList = seq(1,11,1))
  timeVals <- calYearTimeValsMap %>% 
     filter(calYearList %in% calYear)
  timeVals <- timeVals$timeValsList
}

# -- directory settings
# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir

# input your Output directory 
BIIOutputDir <- paste0(outputDir,'BII/')

# input pass to BII_coefs.csv
coefsAreaPropFileName <- paste0(dataDir,'coefficients/HPD/BII_coefs.csv')

# define your BII coefficients data directory
if (PRJ == 'default') {
  BIICoefsDir <- c(paste0(dataDir,"coefficients/HPD/"))
  BIICoefsOutDir <- c(paste0(outputDir,"coefficients/",PRJ,"/"))
} else {
  BIICoefsDir <- c(paste0(outputDir,"coefficients/",PRJ,"/"))
  BIICoefsOutDir <- BIICoefsDir
}
if(!dir.exists(paste0(outputDir,'coefficients/')))dir.create(paste0(outputDir,'coefficients'))
if(!dir.exists(BIICoefsOutDir))dir.create(BIICoefsOutDir)

# get all .nc file in your output directory
#allncFiles <- list.files(landuseDir, pattern = "\\.nc$", full.names = TRUE)
# display all .nc file in your output directory
#cat("All .nc files in the directory:\n")
#print(allncFiles)
# get .nc file including Scename
landuseFileName <- paste0(landuseDir,"AIM-LUmap_",SceName,".nc")
if(file.exists(landuseFileName) == FALSE){
  cat("There are not landuse nc file and exit")
  q()
} else {
  # display your input file
  cat("Input file is", landuseFileName, "\n")
  cur_file <- landuseFileName
}

# PROCESS LU DATA ----------------------------------------------------------

# -- files to be looped upon
print(paste('==== Processing land use file',cur_file,"===="))

# - get IAM model and scenario
cur_scenario <- unlist(strsplit(cur_file,split = '-'))[2]
cur_scenario <- gsub(cur_scenario, pattern = 'LUmap_', replacement = "")

# - read file
nc_file <- nc_open(cur_file)
# . LUC classes
#   indices
mylc_class <- ncvar_get(nc_file, "lc_class")
#   names & extended names
mylc_class_name <- c('cropland_other','cropland_2Gbioen','grassland','forest_unmanaged','forest_managed','restored','other','built-up','abn_cropland_other','abn_cropland_2Gbioen','abn_grassland','abn_forest_managed')
# . time variable
myth <- ncvar_get(nc_file, "time")
#  lon lat variable
mylon <- ncvar_get(nc_file, "lon")
mylat <- ncvar_get(nc_file, "lat")
# . area shares
myLC_area_share <- ncvar_get(nc_file, "LC_area_share")
# . close file
nc_close(nc_file)

# - process into aggregates
# . initialize
output_template <- as.data.frame(expand.grid(mylon,mylat))
colnames(output_template) <- c('lon','lat')
output_template$Areashare <- NA

# compute aggregated values for each LU class & time horizon 
if(Climate_sce != 'none'){
  time_loop <- timeVals
} else (
  time_loop <- seq(1,length(myth),1)
)

registerDoParallel(cores = length(mylc_class_name))
if(exists('output_template_yearbind'))rm('output_template_yearbind')
for(cur_TH in time_loop) {
  
  #print(paste("====== Now calculating Time number",cur_TH,"======="))
  
  output_template_LUbind <- foreach(cur_LU = seq(1,length(mylc_class_name),1), 
                      .combine = 'rbind', 
                      .packages = c('dplyr', 'tidyr')) %dopar% {

                      temp_areashare <- myLC_area_share[,,cur_LU,cur_TH]
                      na_filter <- which(is.na(temp_areashare))
                      if(length(na_filter) > 0) { temp_areashare[na_filter] <- 0}
                      
                      # multiply by shares of pixel and forest_nonforest_mask values, transform to vector
                      r_values_areashare <- as.vector(temp_areashare)
                      
                      # store  
                      output_template$Areashare <- r_values_areashare
                      output_template$lc_class <- cur_LU
                      output_template$year <- myth[cur_TH]
                      return(output_template)
                    }
                    
                    output_template_LUbind$lc_class <- as.factor(output_template_LUbind$lc_class)
                    levels(output_template_LUbind$lc_class) <- mylc_class_name
                    
                    output_template_LUbind <- tidyr::pivot_wider(output_template_LUbind, names_from =c("lc_class"), values_from = Areashare)
                  
                    if(exists('output_template_yearbind')){
                      output_template_yearbind <- rbind(output_template_yearbind, output_template_LUbind)
                    } else {
                      output_template_yearbind <- output_template_LUbind
                    }
}
stopImplicitCluster()

# - reformat and store
output_template_yearbind$scenario <- cur_scenario

# -- add sum
collector_agg_values_bis <- output_template_yearbind

# sum over LU classes
mysumcolnames <- c('cropland_other','cropland_2Gbioen','grassland','forest_unmanaged','forest_managed','restored','other','built-up','abn_cropland_other','abn_cropland_2Gbioen','abn_grassland','abn_forest_managed')
collector_agg_values_bis$sum <- rowSums(collector_agg_values_bis[,which(colnames(collector_agg_values_bis)%in%c(mysumcolnames))], na.rm = TRUE) 

# remove grid where there are no Land-use projected by IAM(e.g. sea, Antarctica)
collector_agg_values_bis <- collector_agg_values_bis %>%   
  filter(sum != 0) 

# -- reorder/ rename columns

colnames(collector_agg_values_bis)[which(colnames(collector_agg_values_bis)=="built-up")] <- "built.up"

collector_agg_values_bis <- collector_agg_values_bis[,c('lon','lat','year','scenario','cropland_other','cropland_2Gbioen','grassland','forest_unmanaged','forest_managed','restored','other','built.up','abn_cropland_other','abn_cropland_2Gbioen','abn_grassland','abn_forest_managed','sum')]

# EXPORT each grid Areashare file ------------------------------------------------------------------

  #write.table(collector_agg_values_bis, paste0(landuseDir,'/',cur_scenario,'_GridAreashare_forPREDICTS_R2_final.csv'),col.names = T, row.names = F, quote = F,sep=',')
    
# PREPARE BII COEFFICIENTS ------------------------------------------------
    
    # -- BII coefficients per LU class
    
    # raw data about coefs and its mapping to the aggregated LU classes
    collector_BII_coefs2 <- data.frame()
    
    # Parallel cores
    multiprocesscores <- future::availableCores() -1
    cat("multiprocess core number is ",multiprocesscores,"\n")
    registerDoParallel(cores = multiprocesscores) 
    
    # Coefficients processing loop
    for (cur_year in unique(collector_agg_values_bis$year)) {
      #print(paste("Climate",Climate_sce,"year",cur_year))
      
      # read data
      # define your BII coefficients output file name
      if (PRJ == 'default') {
        BIICoefsFileName <- c(paste0("Coef_eachgrid_climate_",Climate_sce,"_",cur_year,".csv"))
      } else {
        BIICoefsFileName <- c(paste0("Coef_grid/Coef_eachgrid_climate_",Climate_sce,"_",cur_year,"_",PRJ,".csv"))
      }
      print(paste0("==== Processing coefficietnts file ", BIICoefsDir,BIICoefsFileName," ===="))
      in_PREDICTS_coefs <- read.csv(paste0(BIICoefsDir,BIICoefsFileName)) %>% 
        dplyr::select(c("Luclass","refinedLUclass","BII","share_area_global_refinedLUclass.in.Luclass","lon","lat","Grid_ID"))
      
      in_PREDICTS_coefs$BII_weighted <- in_PREDICTS_coefs$BII * in_PREDICTS_coefs$share_area_global_refinedLUclass.in.Luclass
      
      # Parallel cores
      if(exists('collector_BII_coefs')) rm(collector_BII_coefs)
      collector_BII_coefs <- foreach (cur_grid_id = unique(in_PREDICTS_coefs$Grid_ID), 
                                      .combine = 'rbind', 
                                      .packages = 'dplyr') %dopar% {
          in_PREDICTS_coefs_grid <- in_PREDICTS_coefs %>% 
            filter(Grid_ID == cur_grid_id)
  
          BII_coefs_wo_abn <- aggregate(in_PREDICTS_coefs_grid[,c("BII_weighted","share_area_global_refinedLUclass.in.Luclass")],
                                        by=list('LUclass'=in_PREDICTS_coefs_grid$Luclass), FUN='sum')
  
          colnames(BII_coefs_wo_abn) <- c('LUclass','BII','weightSum')
  
          # -- add abandoned LU classes
          abn_cropland_other <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='cropland_other')]
          abn_cropland_2Gbioen <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='cropland_2Gbioen')]
          abn_grassland <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='grassland')]
          abn_forest_managed <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='forest_managed')]
  
          add_BII_coefs_w_abn <- data.frame("LUclass" = c("abn_cropland_other","abn_cropland_2Gbioen","abn_grassland","abn_forest_managed"),
                                            "BII" = c(abn_cropland_other,abn_cropland_2Gbioen,abn_grassland,abn_forest_managed),
                                            "weightSum"=c(1,1,1,1))
  
          BII_coefs_w_abn <- rbind.data.frame(BII_coefs_wo_abn, add_BII_coefs_w_abn) %>%
            mutate(Grid_ID = cur_grid_id)
  
          BII_coefs <- BII_coefs_w_abn
          BII_coefs$LUclass <- as.character(BII_coefs$LUclass)
          
          return(BII_coefs)
        }

      collector_BII_coefs <- collector_BII_coefs %>% 
        mutate(year = paste(cur_year)) %>% 
        filter(!is.na(BII))
      
      LonLat_gridid <- in_PREDICTS_coefs %>%
        dplyr::select(c('Grid_ID','lon','lat')) %>% 
        distinct(Grid_ID, .keep_all = TRUE) 
      colnames(LonLat_gridid) <- c("Grid_ID","lon","lat")
      
      to_join_coefficients <- left_join(collector_BII_coefs, LonLat_gridid, by = c("Grid_ID")) %>% 
        filter(!is.na(Grid_ID)) 
      to_join_coefficients$year <- as.integer(to_join_coefficients$year)
      
      if(exists('collector_BII_coefs2')) {
        collector_BII_coefs2 <- rbind.data.frame(collector_BII_coefs2,to_join_coefficients)
      } else {
        collector_BII_coefs2 <- to_join_coefficients
      } 

    } 
    stopImplicitCluster()

  # -- output --
    #write.csv(collector_BII_coefs2, file = paste0(BIICoefsOutDir,"Coef_grid_climate_",Climate_sce,"_",PRJ,".csv"), row.names = FALSE)
      
# Calculate BII from each BII coefficients and Grid Areashare data ------------------------------------------------------------------
  # -- LU projections 
   #input_file <- paste(landuseDir,'/',cur_scenario,'_GridAreashare_forPREDICTS_R2_final.csv',sep = '')
   agg <- collector_agg_values_bis

  # -- merge 'Areashare' with BII value, multiply & aggregate
   print("==== Aggregate coefficients and Landuse area and calculate BII ====")

  # process Landuse dataframe  
   to_join_LU <- pivot_longer(agg, cols = -c("lon","lat","year","scenario","sum"), values_to = 'value', names_to = 'LUclass')
   to_join_LU$LUclass <- as.character(to_join_LU$LUclass)
   to_join_LU <- as.data.frame(to_join_LU)
   
  # merge and aggregate  
   temp <- left_join(to_join_LU, collector_BII_coefs2, by=c("LUclass","lon","lat","year"))  
   temp2 <- temp %>% 
     dplyr::select(c("lon","lat","year","scenario","sum","LUclass","value","BII")) %>% 
     filter(!is.na(BII))
   temp2$BII_weightedvalue <- temp2$BII * temp2$value
   agg_BII <- temp2 %>% 
     group_by(lon,lat,year,scenario) %>% 
     reframe(value = sum(BII_weightedvalue))

  # -- reformat output
    output <- agg_BII %>% 
       pivot_wider(names_from = year, values_from = value)
    output$File <- cur_scenario

    colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))] <- paste('v_',colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))],sep='')
    #output2 <- output[,c("File","Biodiv_model","contact","indicator","unit","IAM_model","scenario","region","v_2010","v_2020","v_2030","v_2040","v_2050","v_2060","v_2070","v_2080","v_2090","v_2100")]
 
# EXPORT each grid BII ------------------------------------------------------------------

  write.table(output,paste0(BIIOutputDir,"/csv/BII_grid_climate_",Climate_sce,"_",SceName,"_",PRJ,".csv"),col.names = T, row.names = F, quote = F, sep=',')

# RELOAD data --------------------------------------------------------------------

  # BII grid data 
    BII_grid_result <- read.csv(paste0(BIIOutputDir,"/csv/BII_grid_climate_",Climate_sce,"_",SceName,"_",PRJ,".csv"), header = T) %>% 
      dplyr::select(-File) 
    BII_grid_result <- BII_grid_result %>% 
      pivot_longer(cols=-c("scenario","lon","lat"), names_to ="Year", values_to ="BII")

# Cleaning the data ------------------------------------------------------------
  # --BII grid data editing
   # output format
    xvals<-seq(from=-179.75, to=179.75, by = 0.5)
    yvals<-seq(from=89.75, to=-89.75, by = -0.5)
    
    output_format <- expand.grid(xvals,yvals)
    colnames(output_format) <- c('lon','lat')
    
    # exert   
    print("=== Netcdf output  ===")
    
    BII_grid_3 <- c()
    
    for (y in 1:n_distinct(BII_grid_result$Year)) {
      cur_year <- unique(BII_grid_result$Year)[y]
      
      BII_grid <- BII_grid_result %>% 
        filter(Year == cur_year) %>% 
        dplyr::select(lon, lat, BII)
      
      # merge 
      BII_grid_2 <- left_join(output_format, BII_grid, by = c("lon","lat")) 
      BII_grid_3 <- c(BII_grid_3, BII_grid_2$BII)
    }
    
    BII_grid_3dim <- array(BII_grid_3, dim = c(720,360,n_distinct(BII_grid_result$Year)))
    
    BII_grid_3dim[which(is.na(BII_grid_3dim))] <- 1.e30
    #BII_grid_3dim <- as.numeric(BII_grid_3dim)
    
    # Create nc files -------------------------------------------------------------------------
    # --Define dimensions
    xvals<-seq(from=-179.5, to=180, by = 0.5)
    yvals<-seq(from=89.75, to=-89.75, by = -0.5)
    
    
    timedim <- ncdim_def("time",'',unique(agg_BII$year))
    londim<-ncdim_def("longitude","degrees_east",xvals)
    latdim<-ncdim_def("latitude","degrees_north",yvals)
    
    # --Variable difinitions  
    BIIvar <- ncvar_def("BII","-",list(londim, latdim, timedim),1.e30,longname ="Biodiversity Intactness Index")
    
    # --Make ncfile
    nc <- nc_create(filename = paste0(BIIOutputDir,"/nc/BIImap_climate_",Climate_sce,"_",SceName,"_",PRJ,".nc"),BIIvar)
    
    # --Putting variables 
    ncvar_put(nc, BIIvar, BII_grid_3dim, start = c(1,1,1))
    
    nc_close(nc)
     
    
  