#---- load packages ------------------------------------------------------------
 library(ncdf4)
 library(raster)
 library(dplyr)
 library(tidyr)
 library(gdxrrw)

#---- Switches -----------------------------------------------------------------
# -- Arguments from shell script  
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
# Scenario
SceName <- args[1]
cat("Landuse scenario name is", SceName, "\n")
# Project name
PRJ <- args[2]
cat("Projcet name is", PRJ, "\n")
# GAMS System Dir
gams_sys_dir <- args[3]
cat("Gams system directory is", gams_sys_dir, "\n")
# RCP scenario for EnvDist data
Climate_sce <- args[4]
cat("EnvDist scenario name is", Climate_sce, "\n")
igdx(gams_sys_dir)

# -- directory settings
# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir
 
# other
# input your PREDICTS supplementary files directory
supplementaryDir <- paste0(dataDir,"supplementary/")
# input your Output directory 
BIIOutputDir <- paste0(outputDir,"BII/")
if(!dir.exists(paste0(BIIOutputDir,"csv")))dir.create(paste0(BIIOutputDir,"csv"))
if(!dir.exists(paste0(BIIOutputDir,'gdx')))dir.create(paste0(BIIOutputDir,'gdx'))

# -- switch 
weight_by <- 'prod'

# -- identify landuse file and BII result file
# get all .nc file in your output directory
#allncFiles <- list.files(landuseDir, pattern = "\\.nc$", full.names = TRUE)
landuseFileName <- paste0(landuseDir,"AIM-LUmap_",SceName,".nc")
if(file.exists(landuseFileName) == FALSE){
  cat("There are not landuse nc file and exit")
  q()
} else {
  # display your input file
  cat("Input file is", landuseFileName, "\n")
}

# BII nc output dir and file
BIIresultFileName <- paste0("BIImap_climate_",Climate_sce,"_",SceName,"_",PRJ,".nc")
cat("BII result file is", BIIresultFileName, "\n")
  
#---- load data ----------------------------------------------------------------
# -- Potential NPP layer (derived from Del Grosso et al. 2008, Ecology)
potNPP_ncfile <- nc_open(paste(supplementaryDir,'potNPP_corrected_updated.nc', sep = ""))
potNPP_values <- ncvar_get(potNPP_ncfile, "pot_npp")

# revert columns
cor_potNPP_values <-  potNPP_values[ ,ncol(potNPP_values):1 ]

# -- link from pixels to AIM subregions (compiled by IIASA)
nc_file <- nc_open(paste(supplementaryDir,'Link_halfdegreeGrid_to_AIM17regions_R2.nc', sep = ""))
mylon <- ncvar_get(nc_file, "lon")
mylat <- ncvar_get(nc_file, "lat")
myreg <- ncvar_get(nc_file, "aim_17region")
regions <- ncvar_get(nc_file, "subregion_names")
share_pix_in_reg <- ncvar_get(nc_file, "Area_share_landFromRegionAndGridcell_in_landFromPixel")
nc_close(nc_file)

# -- link from pixels to AIM subregions (compiled by IIASA)
nc_file <- nc_open(paste(supplementaryDir,'Link_halfdegreeGrid_to_AIM5regions_R2.nc', sep = ""))
myreg2 <- ncvar_get(nc_file, "aim_5region")
regions2 <- ncvar_get(nc_file, "subregion_names")
share_pix_in_reg2 <- ncvar_get(nc_file, "Area_share_landFromRegionAndGridcell_in_landFromPixel")
nc_close(nc_file)

# -- Get pixel area from AIM/PLUM output
nc_file <- nc_open(landuseFileName)
mypixarea <- ncvar_get(nc_file, "pixel_area")
nc_close(nc_file)

# clean NAs (replaced by 0)
na_filter <- which(is.na(mypixarea))
if(length(na_filter) > 0) { mypixarea[na_filter] <- 0}
   
#---- PROCESS ------------------------------------------------------------------
 # -- files to be looped upon
   cur_file <- BIIresultFileName
     
     print(paste('==== Regeional aggregation of',cur_file))
   
   # - get scenario name
     #cur_scenario <- unlist(strsplit(cur_file,split = '-'))[2]
     cur_scenario <- gsub(cur_file, pattern = 'BIImap_', replacement = "")
     cur_scenario <- gsub(cur_scenario, pattern = '.nc', replacement = "")
     
   # - read file
     grid_BII_ncfile <- nc_open(paste0(BIIOutputDir,'/nc/',cur_file))
     grid_BII <- ncvar_get(grid_BII_ncfile, "BII")
     myth <- ncvar_get(grid_BII_ncfile, "time") 
     nc_close(grid_BII_ncfile)   
   
   # - process into aggregates
     # . initialize
     output_template <- as.data.frame(expand.grid(myreg,myth))
     colnames(output_template) <- c('region','year')
     output_template$value_prod <- NA
     output_template$value_area <- NA

   # - Aggregate grid to 17 IPBES subregions 
   # region by region, compute area and prod
     for(cur_reg in seq(1,length(myreg))) {
       
       print(paste("Now region number", cur_reg, "/17" ))
       
       # get shares of pixel in current region
       myshares <- share_pix_in_reg[,,cur_reg]
       cor_myshares <- myshares[ ,ncol(myshares):1 ] # correct the shares as they are inverted
       
       # clean NAs (replaced by 0)
       na_filter <- which(is.na(cor_myshares))
       if(length(na_filter) > 0) { cor_myshares[na_filter] <- 0}
       
       # compute aggregated values for each LU class & time horizon
       for(cur_TH in seq(1,length(myth),1)) {
         #print(paste("Now calculate time number", cur_TH ))
         
         # - prepare grid BII
         # clean NAs (replaced by 0)
         grid_BII_area <- grid_BII[,,cur_TH]
         na_filter <- which(is.na(grid_BII_area))
         if(length(na_filter) > 0) { grid_BII_area[na_filter] <- 0}
         
         grid_BII_prod <- grid_BII_area
         
         # make land mask data (grid_corrected ; takes value whether 0 or 1) for filling the gap of grid number
         grid_corrected <- grid_BII_area
         value_filter <- which(!is.na(grid_corrected) & grid_corrected >0)
         if(length(value_filter) > 0) {grid_corrected[value_filter] <- 1}
         #grid_corrected <- as.vector(grid_corrected)

         
         # multiply by shares of pixel in region, transform to vector and subset to summable
         r_grid_values_area <- mypixarea * cor_myshares * grid_corrected
         values_area <- as.vector(r_grid_values_area)
         values_area <- values_area[which(!is.na(values_area) & values_area>0)]
         r_values_area <- sum(values_area)
         
         r_grid_values_prod <- mypixarea * cor_potNPP_values * cor_myshares * grid_corrected
         values_prod <- as.vector(r_grid_values_prod)
         values_prod <- values_prod[which(!is.na(values_prod) & values_prod>0)]
         r_values_prod <- sum(values_prod)
         
         # - multiply BII with procesed grid area (or potNPP weighted area) and sum
         #grid_values_BII_area <- grid_BII_area * r_grid_values_area
         grid_values_BII_area <- as.vector(grid_BII_area * r_grid_values_area)
         grid_values_BII_prod <- as.vector(grid_BII_prod * r_grid_values_prod)  
         
         grid_values_BII_area <- grid_values_BII_area[which(!is.na(grid_values_BII_area) & grid_values_BII_area>0)]
         grid_values_BII_prod <- grid_values_BII_prod[which(!is.na(grid_values_BII_prod) & grid_values_BII_prod>0)]
         r_values_BII_area <- sum(grid_values_BII_area)/r_values_area
         r_values_BII_prod <- sum(grid_values_BII_prod)/r_values_prod
         
         # store  # editable
         
         cur_line <- which(output_template$region==cur_reg &
                                output_template$year==unique(output_template$year)[cur_TH])
         output_template$value_prod[cur_line] <- sum(r_values_BII_prod)
         output_template$value_area[cur_line] <- sum(r_values_BII_area)
       }
     }
  
  # - reformat and store
   output_template$region <- as.factor(output_template$region)
   levels(output_template$region) <- regions
   

  # - Aggregate grid to 5 subregions 
   # . initialize
   output_template_add <- as.data.frame(expand.grid(myreg2,myth))
   colnames(output_template_add) <- c('region','year')
   output_template_add$value_prod <- NA
   output_template_add$value_area <- NA
   
   # region by region, compute area and prod
   for(cur_reg in seq(1,length(myreg2))) {
     
     print(paste("Now calculate region number", cur_reg ,"/5"))
     
     # get shares of pixel in current region
     myshares <- share_pix_in_reg2[,,cur_reg]
     cor_myshares <- myshares[ ,ncol(myshares):1 ] # correct the shares as they are inverted
     
     # clean NAs (replaced by 0)
     na_filter <- which(is.na(cor_myshares))
     if(length(na_filter) > 0) { cor_myshares[na_filter] <- 0}
     
     # compute aggregated values for each LU class & time horizon
     for(cur_TH in seq(1,length(myth),1)) {
       #print(paste("Now calculate time number", cur_TH ))
       
       
       # - prepare grid BII
       # clean NAs (replaced by 0)
       grid_BII_area <- grid_BII[,,cur_TH]
       na_filter <- which(is.na(grid_BII_area))
       if(length(na_filter) > 0) { grid_BII_area[na_filter] <- 0}
       
       grid_BII_prod <- grid_BII_area
       
       # make land mask data (grid_corrected ; takes value whether 0 or 1) for filling the gap of grid number
       grid_corrected <- grid_BII_area
       value_filter <- which(!is.na(grid_corrected) & grid_corrected >0)
       if(length(value_filter) > 0) {grid_corrected[value_filter] <- 1}
       #grid_corrected <- as.vector(grid_corrected)
       
       
       # multiply by shares of pixel in region, transform to vector and subset to summable
       r_grid_values_area <- mypixarea * cor_myshares * grid_corrected
       values_area <- as.vector(r_grid_values_area)
       values_area <- values_area[which(!is.na(values_area) & values_area>0)]
       r_values_area <- sum(values_area)
       
       r_grid_values_prod <- mypixarea * cor_potNPP_values * cor_myshares * grid_corrected
       values_prod <- as.vector(r_grid_values_prod)
       values_prod <- values_prod[which(!is.na(values_prod) & values_prod>0)]
       r_values_prod <- sum(values_prod)
       
       # - multiply BII with procesed grid area (or potNPP weighted area) and sum
       #grid_values_BII_area <- grid_BII_area * r_grid_values_area
       grid_values_BII_area <- as.vector(grid_BII_area * r_grid_values_area)
       grid_values_BII_prod <- as.vector(grid_BII_prod * r_grid_values_prod)  
       
       grid_values_BII_area <- grid_values_BII_area[which(!is.na(grid_values_BII_area) & grid_values_BII_area>0)]
       grid_values_BII_prod <- grid_values_BII_prod[which(!is.na(grid_values_BII_prod) & grid_values_BII_prod>0)]
       r_values_BII_area <- sum(grid_values_BII_area)/r_values_area
       r_values_BII_prod <- sum(grid_values_BII_prod)/r_values_prod
       
       # store  # editable
       
       cur_line <- which(output_template_add$region==cur_reg &
                           output_template_add$year==unique(output_template_add$year)[cur_TH])
       output_template_add$value_prod[cur_line] <- sum(r_values_BII_prod)
       output_template_add$value_area[cur_line] <- sum(r_values_BII_area)
     }
   }
   
   # - reformat and store
   output_template_add$region <- as.factor(output_template_add$region)
   levels(output_template_add$region) <- regions2
   
   # - merge 17 regions and 5 regions
   output_template <- rbind(output_template, output_template_add)
   
    
  # - add world
   # . initialize
   output_template_add <- as.data.frame(expand.grid('World',myth))
   colnames(output_template_add) <- c('region','year')
   output_template_add$value_prod <- NA
   output_template_add$value_area <- NA
   
   # world computation
   print('World Computation')
   for(cur_TH in seq(1,length(myth),1)) {
     #print(paste("Now calculate time number", cur_TH ))
     
     # - prepare grid BII
     # clean NAs (replaced by 0)
     grid_BII_area <- grid_BII[,,cur_TH]
     na_filter <- which(is.na(grid_BII_area))
     if(length(na_filter) > 0) { grid_BII_area[na_filter] <- 0}
     
     grid_BII_prod <- grid_BII_area
     
     # make land mask data (grid_corrected ; takes value whether 0 or 1) for filling the gap of grid number
     grid_corrected <- grid_BII_area
     value_filter <- which(!is.na(grid_corrected) & grid_corrected >0)
     if(length(value_filter) > 0) {grid_corrected[value_filter] <- 1}
     #grid_corrected <- as.vector(grid_corrected)
     
     # multiply by shares of pixel in region, transform to vector and subset to summable
     r_grid_values_area <- mypixarea * grid_corrected
     values_area <- as.vector(r_grid_values_area)
     values_area <- values_area[which(!is.na(values_area) & values_area>0)]
     r_values_area <- sum(values_area)
     
     r_grid_values_prod <- mypixarea * cor_potNPP_values * grid_corrected
     values_prod <- as.vector(r_grid_values_prod)
     values_prod <- values_prod[which(!is.na(values_prod) & values_prod>0)]
     r_values_prod <- sum(values_prod)
     
     # - multiply BII with procesed grid area (or potNPP weighted area) and sum
     #grid_values_BII_area <- grid_BII_area * r_grid_values_area
     grid_values_BII_area <- as.vector(grid_BII_area * r_grid_values_area)
     grid_values_BII_prod <- as.vector(grid_BII_prod * r_grid_values_prod)  
     
     grid_values_BII_area <- grid_values_BII_area[which(!is.na(grid_values_BII_area) & grid_values_BII_area>0)]
     grid_values_BII_prod <- grid_values_BII_prod[which(!is.na(grid_values_BII_prod) & grid_values_BII_prod>0)]
     r_values_BII_area <- sum(grid_values_BII_area)/r_values_area
     r_values_BII_prod <- sum(grid_values_BII_prod)/r_values_prod
     
     # store  # editable
     
     cur_line <- which(output_template_add$region=='World' &
                         output_template_add$year==unique(output_template_add$year)[cur_TH])
     output_template_add$value_prod[cur_line] <- sum(r_values_BII_prod)
     output_template_add$value_area[cur_line] <- sum(r_values_BII_area)
   }
   
   output_template <- rbind(output_template, output_template_add)

   output <- output_template %>% 
     dplyr::select(c(paste0('value_',weight_by), region, year)) %>% 
     rename('value' = paste0('value_',weight_by)) %>% 
     pivot_wider(names_from = year, values_from = value)
   
   output_IAMCTemp <- output_template %>% 
     dplyr::select(c(paste0('value_',weight_by), region, year)) %>% 
     rename('value' = paste0('value_',weight_by)) %>% 
     pivot_wider(names_from = year, values_from = value)
   
   output_gdx <- output_IAMCTemp %>%
     wgdx.reshape(2, symName = 'BII', tName = 'year')  
   
   output$scenario <- cur_scenario
   colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))] <- paste('v_',colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))],sep='')
   
# Export -----------------------------------------------------------------------
  write.table(output,paste0(BIIOutputDir,"csv/BII_regionagg_climate_",Climate_sce,"_",SceName,"_",PRJ,".csv",sep = ""),col.names = T, row.names = F, quote = F, sep=',')
  write.table(output_IAMCTemp,paste0(BIIOutputDir,"csv/BII_regionagg_",SceName,"_IAMCTemp.csv",sep = ""),col.names = T, row.names = F, quote = F, sep=',')
  wgdx.lst(paste0(BIIOutputDir,"gdx/BII_regionagg_climate_",Climate_sce,"_",SceName,"_",PRJ,".gdx"), output_gdx)
   