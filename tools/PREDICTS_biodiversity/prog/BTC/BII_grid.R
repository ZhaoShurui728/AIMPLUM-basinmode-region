# COMMENTS ----------------------------------------------------------------
# date 20231207
# revised 20240701
# revised 20240806, calculating year of landuse nc file

# LIBRARIES ---------------------------------------------------------------
# uses R 3.6.1
library(ncdf4) 
library(raster) 
library(dplyr)
library(tidyr)
library(foreach)
library(doParallel)

# Switches  ---------------------------------
# AIMPLUM output file
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
SceName <- args[1]
cat("Scenario name is", SceName, "\n")
PRJ <- args[2]
cat("Project name is", PRJ, "\n")

# -- directory settings
# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir

# other
# input your PREDICTS supplementary files directory
supplementaryDir <- paste0(dataDir,"supplementary")
# input your Output directory 
BIIOutputDir <- paste0(outputDir,"BII/")
if(!dir.exists(paste0(BIIOutputDir,"csv")))dir.create(paste0(BIIOutputDir,"csv"))
    if(!dir.exists(paste0(BIIOutputDir,'nc')))dir.create(paste0(BIIOutputDir,'nc'))

# define your BII coefficients data directory
if (PRJ == 'default') {
  BIICoefsDir <- c(paste0(dataDir,"/coefficients/BTC/"))
} else {
  BIICoefsDir <- c(paste0(outputDir,"/coefficients/",PRJ,"/"))
}
  
# get all .nc file in your output directory
# allncFiles <- list.files(landuseDir, pattern = "\\.nc$", full.names = TRUE)
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

# LOAD SIDE DATA ----------------------------------------------------------

# -- potentiallty forested / potentially non-forested ecosystem (LUH2 v2h static data)
forest_mask <- raster(paste0(supplementaryDir, '/staticData_quarterdeg.nc'), varname = "fstnf") 
# aggregate from quarter degree to half degree (underlying data is anyways at half degree or more)
forest_mask_hd <- raster::aggregate(forest_mask, fact=2)
# to 2d array
forest_mask_hd_data <- array(forest_mask_hd, dim = c(720,360))
nonforest_mask_hd_data <- 1 - forest_mask_hd_data

# PREPARE BII COEFFICIENTS ------------------------------------------------

# -- BII coefficients per LU class

# raw data about coefs and its mapping to the aggregated LU classes

in_PREDICTS_coefs <- read.csv(paste0(BIICoefsDir,"BII_coefs.csv"))

in_PREDICTS_coefs$BII_weighted <- in_PREDICTS_coefs$BII * in_PREDICTS_coefs$share_area_global_refinedLUclass.in.Luclass

BII_coefs_wo_abn <- aggregate(in_PREDICTS_coefs[,c("BII_weighted","share_area_global_refinedLUclass.in.Luclass")], 
                              by=list('LUclass'=in_PREDICTS_coefs$Luclass), FUN='sum') # Aggregate BII weighted by share_area for each LU
colnames(BII_coefs_wo_abn) <- c('LUclass','BII','weightSum')


# -- add abandoned LU classes
abn_cropland_other_f <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='cropland_other_f')]
abn_cropland_other_nf <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='cropland_other_nf')]
abn_cropland_2Gbioen_f <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='cropland_2Gbioen_f')]
abn_cropland_2Gbioen_nf <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='cropland_2Gbioen_nf')]
abn_grassland_f <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='grassland_f')]
abn_grassland_nf <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='grassland_nf')]
abn_forest_managed <- BII_coefs_wo_abn$BII[which(BII_coefs_wo_abn$LUclass=='forest_managed')]

add_BII_coefs_w_abn <- data.frame("LUclass" = c("abn_cropland_other_f","abn_cropland_other_nf","abn_cropland_2Gbioen_f","abn_cropland_2Gbioen_nf","abn_grassland_f","abn_grassland_nf","abn_forest_managed"),
                                  "BII" = c(abn_cropland_other_f,abn_cropland_other_nf,abn_cropland_2Gbioen_f,abn_cropland_2Gbioen_nf,abn_grassland_f,abn_grassland_nf,abn_forest_managed),
                                  "weightSum"=c(1,1,1,1,1,1,1))

BII_coefs_w_abn <- rbind.data.frame(BII_coefs_wo_abn, add_BII_coefs_w_abn)

BII_coefs <- BII_coefs_w_abn
BII_coefs$LUclass <- as.character(BII_coefs$LUclass)


# PROCESS -----------------------------------------------------------------

# -- landuse data process separating pot-forest and pot-nonforest
  print(paste('==== Processing land use file ',cur_file))
  
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
  #mylc_class_name_extended <- c('cropland_other','cropland_2Gbioen','grassland','forest_unmanaged','forest_managed','restored','other','built-up','abn_cropland_other','abn_cropland_2Gbioen','abn_grassland','abn_forest_managed','forest_unmanaged_primary','forest_unmanaged_secondary','other_primary','other_secondary')
  
  # . time variable
  myth <- ncvar_get(nc_file, "time")
  
  #  lon lat variable
  mylon <- ncvar_get(nc_file, "lon")
  mylat <- ncvar_get(nc_file, "lat")
  
  # . area shares
  myLC_area_share <- ncvar_get(nc_file, "LC_area_share")
  #myLC_area_share <- ncvar_get(nc_file, "LC_area_share5")
  
  # . close file
  nc_close(nc_file)
  
  # - process into aggregates
  # . initialize
  output_template <- as.data.frame(expand.grid(mylon,mylat,c('f','nf')))
  colnames(output_template) <- c('lon','lat','fnf')
  output_template$Areashare <- NA
  
  registerDoParallel(cores = length(mylc_class_name))
  # compute aggregated values for each LU class & time horizon  
  if(exists('output_template_yearbind'))rm('output_template_yearbind')
  for(cur_TH in seq(1,length(myth),1)) {
    #print(paste("====== Now processing Time number ",cur_TH,"======="))
  
    output_template_LUbind <- foreach(cur_LU = seq(1,length(mylc_class_name),1), 
                                .combine = 'rbind', 
                                .packages = c('dplyr', 'tidyr')) %dopar% {
      
      temp_areashare <- myLC_area_share[,,cur_LU,cur_TH]
      na_filter <- which(is.na(temp_areashare))
      if(length(na_filter) > 0) { temp_areashare[na_filter] <- 0}
      
      # multiply by shares of pixel and forest_nonforest_mask values, transform to vector
      r_values_areashare_nf <- as.vector(temp_areashare * nonforest_mask_hd_data)
      r_values_areashare_f <- as.vector(temp_areashare * forest_mask_hd_data)
      
      # store  
      cur_line_nf <- which(output_template$fnf=='nf')
      output_template$Areashare[cur_line_nf] <- r_values_areashare_nf
      
      cur_line_f <- which(output_template$fnf=='f')
      output_template$Areashare[cur_line_f] <- r_values_areashare_f
      
      output_template$lc_class <- cur_LU
      output_template$year <- myth[cur_TH]
      return(output_template)
    }
    
    output_template_LUbind$lc_class <- as.factor(output_template_LUbind$lc_class)
    levels(output_template_LUbind$lc_class) <- mylc_class_name
    
    output_template_LUbind <- tidyr::pivot_wider(output_template_LUbind, names_from =c("lc_class","fnf"), values_from = Areashare)
  
    if(exists('output_template_yearbind')){
      output_template_yearbind <- rbind(output_template_yearbind, output_template_LUbind)
    } else {
      output_template_yearbind <- output_template_LUbind
    }

  }
  stopImplicitCluster()

  # - reformat and store
  output_template_yearbind$scenario <- cur_scenario

# -- aggregate across f / nf mask for forested areas & remove split

  collector_agg_values_bis <- output_template_yearbind

  collector_agg_values_bis$forest_managed <- rowSums(collector_agg_values_bis[,c('forest_managed_f','forest_managed_nf')], na.rm=T) 
  collector_agg_values_bis$forest_unmanaged <- rowSums(collector_agg_values_bis[,c('forest_unmanaged_f','forest_unmanaged_nf')], na.rm=T)
  collector_agg_values_bis$abn_forest_managed <- rowSums(collector_agg_values_bis[,c('abn_forest_managed_f','abn_forest_managed_nf')], na.rm=T)

  cols_to_exclude <- c('forest_managed_f','forest_managed_nf','forest_unmanaged_f','forest_unmanaged_nf','abn_forest_managed_f','abn_forest_managed_nf')
  collector_agg_values_bis <- collector_agg_values_bis[,-which(colnames(collector_agg_values_bis)%in%c(cols_to_exclude))]

# -- add sum

  # sum over LU classes
  mysumcolnames <- c('cropland_other_f','cropland_other_nf','cropland_2Gbioen_f','cropland_2Gbioen_nf','grassland_f','grassland_nf','forest_unmanaged','forest_managed','restored_f','restored_nf','other_f','other_nf','built-up_f','built-up_nf','abn_cropland_other_f','abn_cropland_other_nf','abn_cropland_2Gbioen_f','abn_cropland_2Gbioen_nf','abn_grassland_f','abn_grassland_nf','abn_forest_managed')
  collector_agg_values_bis$sum <- rowSums(collector_agg_values_bis[,which(colnames(collector_agg_values_bis)%in%c(mysumcolnames))], na.rm = TRUE) 

  # remove grid where there are no Land-use projected by IAM(e.g. sea, Antarctica)
  collector_agg_values_bis <- collector_agg_values_bis %>%   
    filter(sum != 0) 

# -- reorder/ rename columns

  colnames(collector_agg_values_bis)[which(colnames(collector_agg_values_bis)=="built-up_f")] <- "built.up_f"
  colnames(collector_agg_values_bis)[which(colnames(collector_agg_values_bis)=="built-up_nf")] <- "built.up_nf"

  collector_agg_values_bis <- collector_agg_values_bis[,c('lon','lat','year','scenario',
                                                          'cropland_other_f','cropland_other_nf','cropland_2Gbioen_f','cropland_2Gbioen_nf','grassland_f','grassland_nf','forest_managed','forest_unmanaged','restored_f','restored_nf','other_f','other_nf','built.up_f','built.up_nf','abn_cropland_other_f','abn_cropland_other_nf','abn_cropland_2Gbioen_f','abn_cropland_2Gbioen_nf','abn_grassland_f','abn_grassland_nf','abn_forest_managed','sum')]

# EXPORT each grid Areashare file ------------------------------------------------------------------
# -- ALL AT ONCE
  #write.table(collector_agg_values_bis, paste(landuseDir,"GridAreashare_forPREDICTS_R2_final.csv",sep="/"),col.names = T, row.names = F, quote = F,sep=',')
  #write.table(wld_collector_agg_values,'wld_aggregated_IPBESsubregions_forPREDICTS_R2_final.csv',col.names = T, row.names = F, quote = F,sep=',')

# Calculate BII from each BII coefficients and Grid Areashare data ------------------------------------------------------------------
# -- LU projections (12class landuse grid data, with split by ecosystem type f / nf except for forests)

  agg <- collector_agg_values_bis

# -- merge 'Areashare' with BII value, multiply & aggregate

  to_join <- pivot_longer(agg, cols = -c("lon","lat","year","scenario","sum"), values_to = 'value', names_to = 'LUclass')
  to_join$LUclass <- as.character(to_join$LUclass)

  temp <- left_join(to_join,
                    BII_coefs, by=c("LUclass"))
  temp$BII_weightedvalue <- temp$BII * temp$value / temp$sum
  agg_BII <- temp %>% 
       group_by(lon,lat,year,scenario) %>% 
       reframe(value = sum(BII_weightedvalue))

# -- reformat output
  output <- agg_BII %>% 
       pivot_wider(names_from = year, values_from = value)

  colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))] <- paste('v_',colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))],sep='')

# EXPORT each grid BII ------------------------------------------------------------------
  write.table(output,paste0(BIIOutputDir,"csv/BII_grid_",SceName,"_",PRJ,".csv"),col.names = T, row.names = F, quote = F, sep=',')

# RELOAD data --------------------------------------------------------------------

# BII grid data 
  BII_grid_result <- output 
  BII_grid_result <- BII_grid_result %>% 
    pivot_longer(cols=-c("scenario","lon","lat"),names_to ="Year", values_to ="BII")

# Cleaning the data ------------------------------------------------------------
  # --BII grid data editing
   # output format
    xvals<-seq(from=-179.75, to=179.75, by = 0.5)
    yvals<-seq(from=89.75, to=-89.75, by = -0.5)
    
    output_format <- expand.grid(xvals,yvals)
    colnames(output_format) <- c('lon','lat')
    
  # exert   
    print("== Now creating  BII map ==")
    
    BII_grid_3 <- c()
    
    for (y in 1:n_distinct(BII_grid_result$Year)) {
      
      cur_year <- unique(BII_grid_result$Year)[y]
      
      BII_grid <- BII_grid_result %>% 
        filter(Year == cur_year) %>% 
        select(lon, lat, BII)
      
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
    
    
    timedim <- ncdim_def("time",'',myth)
    londim<-ncdim_def("longitude","degrees_east",xvals)
    latdim<-ncdim_def("latitude","degrees_north",yvals)
    
    # --Variable difinitions  
    BIIvar <- ncvar_def("BII","-",list(londim, latdim, timedim),1.e30,longname ="Biodiversity Intactness Index")
    
    # --Make ncfile
    nc <- nc_create(filename = paste(BIIOutputDir,"nc/BIImap_",SceName,"_",PRJ,".nc",sep = ""),BIIvar)
    
    # --Putting variables 
    ncvar_put(nc, BIIvar, BII_grid_3dim, start = c(1,1,1))
    
    nc_close(nc)

    
  