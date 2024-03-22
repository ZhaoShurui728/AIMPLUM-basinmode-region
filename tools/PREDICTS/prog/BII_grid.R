
# COMMENTS ----------------------------------------------------------------
# date 20231207

# LIBRARIES ---------------------------------------------------------------
  # uses R 3.6.1
  library(ncdf4) 
  library(raster) 
  library(reshape2) 
  library(dplyr)
  library(tidyr)
  #library(tidyverse)

# Switches  ---------------------------------

  # select year number(2005, 2010, 2020, 2030 ...2100 : 1~11)
    CalYear <- list(1,3,4,6,11)
    timevals <- c(2005, 2010, 2030, 2050, 2100)
    
    print(paste("output", timevals))

  # AIMPLUM output file
    Args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
    SceName <- Args[1]
    cat("Scenario name is", SceName, "\n")
    #print("Scenario name is",SceName)

  # path to your nc output directory
    directory_path <- "../output/nc"

  # get all .nc file in your output directory
    all_nc_files <- list.files(directory_path, pattern = "\\.nc$", full.names = TRUE)

  # display all .nc file in your output directory
    cat("All .nc files in the directory:\n")
    print(all_nc_files)

  # get .nc file including Scename
    input_file_name <- paste("AIM-LUmap_",SceName,".nc",sep="")
    cat("Input file name is", input_file_name, "\n")
    Landuse_output <- grep(input_file_name, all_nc_files, value = TRUE, ignore.case = TRUE)

  # display your input file
    cat("Input file is", Landuse_output, "\n")
  
  # display your parent dir
    Parent_dir <- Args[2]
    cat("Parent dir is", Parent_dir, "\n")

# LOAD SIDE DATA ----------------------------------------------------------

  # -- potentiallty forested / potentially non-forested ecosystem (LUH2 v2h static data)
   forest_mask <- raster(paste('../',Parent_dir,'/tools/PREDICTS/data/Supplementary/staticData_quarterdeg.nc',sep = ""), varname = "fstnf") 
   # aggregate from quarter degree to half degree (underlying data is anyways at half degree or more)
   forest_mask_hd <- aggregate(forest_mask, fact=2)
   # to 2d array
   forest_mask_hd_data <- array(forest_mask_hd, dim = c(720,360))
   nonforest_mask_hd_data <- 1 - forest_mask_hd_data

# PREPARE BII COEFFICIENTS ------------------------------------------------

  # -- BII coefficients per LU class

    # raw data about coefs and its mapping to the aggregated LU classes

    in_PREDICTS_coefs <- read.csv(paste('../',Parent_dir,'/tools/PREDICTS/data/BII_coefs.csv',sep = ""))

    in_PREDICTS_coefs$BII_weighted <- in_PREDICTS_coefs$BII * in_PREDICTS_coefs$share_area_global_refinedLUclass.in.Luclass

    BII_coefs_wo_abn <- aggregate(in_PREDICTS_coefs[,c("BII_weighted","share_area_global_refinedLUclass.in.Luclass")], 
                                  by=list('LUclass'=in_PREDICTS_coefs$Luclass), FUN='sum') #share_areaで重みづけしたBIIを各LU毎に集計
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

  # -- files to be looped upon

    # AIMPLUM Output
     list_files_aimplum <- Landuse_output

     cur_file <- unique(list_files_aimplum)[1]

    if(exists('collector_agg_values')){
      rm('collector_agg_values')
    } else {
      for(cur_file in list_files_aimplum) {
      
        print(paste('====',cur_file))
        
        # - get IAM model and scenario
        cur_model <- unlist(strsplit(cur_file,split = '-'))[1]
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
        myLC_area_share <- ncvar_get(nc_file, "LC_area_share5")
        #myLC_area_share <- ncvar_get(nc_file, "LC_area_share")
        
        # . close file
        nc_close(nc_file)
        
        # - process into aggregates
        # . initialize
        output_template <- as.data.frame(expand.grid(mylon,mylat,seq(1,length(mylc_class_name),1) ,c('f','nf'),myth))
        colnames(output_template) <- c('lon','lat','lc_class','fnf','year')
        output_template$Areashare <- NA
        

        # compute aggregated values for each LU class & time horizon  
        #seq(1,dim(myLC_area_share)[4],1)
        for(cur_TH in CalYear) {
          
          print(paste("====== Now calculating Time number",cur_TH,"======="))
          
          for(cur_LU in seq(1,length(mylc_class_name),1)) {
            
            print(paste("Now calculating LU number",cur_LU))
            
            output_tmp <- data.frame()
            
            temp_areashare <- myLC_area_share[,,cur_LU,cur_TH]
            na_filter <- which(is.na(temp_areashare))
            if(length(na_filter) > 0) { temp_areashare[na_filter] <- 0}
            
            # multiply by shares of pixel and forest_nonforest_mask values, transform to vector
            r_values_areashare_nf <- as.vector(temp_areashare * nonforest_mask_hd_data)
            r_values_areashare_f <- as.vector(temp_areashare * forest_mask_hd_data)
            
            # store  
            cur_line_nf <- which(output_template$lc_class==cur_LU &
                                output_template$fnf=='nf' &
                                output_template$year==unique(output_template$year)[cur_TH])
            output_template$Areashare[cur_line_nf] <- r_values_areashare_nf
            
            cur_line_f <- which(output_template$lc_class==cur_LU &
                                output_template$fnf=='f' &
                                output_template$year==unique(output_template$year)[cur_TH])
            output_template$Areashare[cur_line_f] <- r_values_areashare_f
          }
        }
        
        # - reformat and store
        
        output_template$lc_class <- as.factor(output_template$lc_class)
        levels(output_template$lc_class) <- mylc_class_name
        
        output_template_rf <- tidyr::pivot_wider(output_template, names_from =c("lc_class","fnf"), values_from = Areashare)
        #output_template_rf$date_tag <- cur_date
        #output_template_rf$model <- cur_model # if necessary, please remove 
        
        output_template_rf$scenario <- cur_scenario
        
        if(exists('collector_agg_values')) {
          collector_agg_values <- rbind.data.frame(collector_agg_values,output_template_rf)
        } else {
          collector_agg_values <- output_template_rf
        }
     }
    }
    

  # -- aggregate across f / nf mask for forested areas & remove split

    collector_agg_values_bis <- collector_agg_values

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

  # -- ALL AT ONCE
    write.table(collector_agg_values_bis,paste('../output/csv/',SceName,'/GridAreashare_forPREDICTS_R2_final.csv',sep = ''),col.names = T, row.names = F, quote = F,sep=',')
    
# Calculate BII from each BII coefficients and Grid Areashare data ------------------------------------------------------------------
  # -- LU projections (aggregated to IPBES subregions, with split by ecosystem type f / nf except for forests)

    input_file <- paste('../output/csv/',SceName,'/GridAreashare_forPREDICTS_R2_final.csv',sep = '')
    agg <- read.csv(input_file)

# # Calculate BII from each BII coefficients and Grid Areashare data ------------------------------------------------------------------
#   # -- LU projections (aggregated to IPBES subregions, with split by ecosystem type f / nf except for forests)

#     agg <- collector_agg_values_bis

  # -- merge 'Areashare' with BII value, multiply & aggregate

    to_join <- melt(agg, id.vars = c("lon","lat","year","scenario","sum"))  #date_tag&model were removed
    to_join$variable <- as.character(to_join$variable)
    temp <- left_join(to_join,
                      BII_coefs, by=c("variable"="LUclass"))
    temp$BII_weightedvalue <- temp$BII * temp$value / temp$sum
    agg_BII <- aggregate(temp$BII_weightedvalue,
                        by=list(#'date_tag'=temp$date_tag,
                                #'IAM_model'=temp$model,
                                'lon'=temp$lon,
                                'lat'=temp$lat,
                                'year'=temp$year,
                                'scenario'=temp$scenario,
                                'sum'=temp$sum),
                        FUN='sum',na.rm=T)
    colnames(agg_BII)[which(colnames(agg_BII)=='x')] <- 'value'

  # -- reformat output
    output <- agg_BII %>% 
      dcast(scenario + lon + lat ~ year, value.var = 'value')

    colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))] <- paste('v_',colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))],sep='')

    #output2 <- output[,c("File","Biodiv_model","contact","indicator","unit","IAM_model","scenario","region","v_2010","v_2020","v_2030","v_2040","v_2050","v_2060","v_2070","v_2080","v_2090","v_2100")]
 
# EXPORT each grid BII ------------------------------------------------------------------

  write.table(output,paste("../output/csv/",SceName,"/BII_grid_",SceName,".csv",sep = ""),col.names = T, row.names = F, quote = F, sep=',')

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
    for (i in 1:n_distinct(BII_grid_result$scenario)){
      
      cur_sc <- unique(BII_grid_result$scenario)[i]
      print(paste("== Now make nc file ",cur_sc, "=="))
      
      BII_grid_3 <- c()
      
      for (y in 1:n_distinct(BII_grid_result$Year)) {
        
        cur_year <- unique(BII_grid_result$Year)[y]
        
        BII_grid <- BII_grid_result %>% 
          filter(scenario == cur_sc) %>%
          filter(Year == cur_year) %>% 
          select(lon, lat, BII)
        
        # merge 
        BII_grid_2 <- left_join(output_format, BII_grid, by = c("lon","lat")) 
        BII_grid_3 <- c(BII_grid_3, BII_grid_2$BII)
      }
      
      BII_grid_3dim <- array(BII_grid_3, dim = c(720,360,n_distinct(BII_grid_result$Year)))
      
      BII_grid_3dim[which(is.na(BII_grid_3dim))] <- 1.e30
      
      # Create nc files -------------------------------------------------------------------------
      # --Define dimensions
      xvals<-seq(from=-179.5, to=180, by = 0.5)
      yvals<-seq(from=89.75, to=-89.75, by = -0.5)
      
      
      timedim <- ncdim_def("time",'',timevals)
      londim<-ncdim_def("longitude","degrees_east",xvals)
      latdim<-ncdim_def("latitude","degrees_north",yvals)
      
      # --Variable difinitions  
      BIIvar <- ncvar_def("BII","-",list(londim, latdim, timedim),1.e30,longname ="Biodiversity Intactness Index, CS index is Jaccard Index")
      
      # --Make ncfile
      nc <- nc_create(filename = paste("../output/nc/PREDICTS/BIImap_",cur_sc,sep = ""),BIIvar)
      
      # --Putting variables 
      ncvar_put(nc, BIIvar, BII_grid_3dim, start = c(1,1,1))
      
      nc_close(nc)
    }  
    
  