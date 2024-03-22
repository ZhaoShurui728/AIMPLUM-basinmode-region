
# COMMENTS ----------------------------------------------------------------


# COMMENTS ----------------------------------------------------------------
# 2023 12 07

# LIBRARIES ---------------------------------------------------------------

  library(ncdf4) 
  library(raster) 
  library(reshape2) 
  library(dplyr) 

# Switch  ---------------------------------
  # weighting whether by area or potNPP 
  #weight_by <- c("area")
    weight_by <- c("prod")

    print(paste("weighting by", weight_by))

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

  # Analysis region (IPBESsubregion or AIM17regions)
    Region_sep_class <- 'AIM17regions'
    cat("Aggregate region is", Region_sep_class, "\n")

# LOAD SIDE DATA ----------------------------------------------------------

  # -- Potential NPP layer (derived from Del Grosso et al. 2008, Ecology)
   potNPP_ncfile <- nc_open(paste('../',Parent_dir,'/tools/PREDICTS/data/Supplementary/potNPP_corrected_updated.nc',sep = ""))
   #potNPP_ncfile <- nc_open('../tools/PREDICTS/data/Supplementary/potNPP_corrected_updated.nc')
   potNPP_values <- ncvar_get(potNPP_ncfile, "pot_npp")
   # revert columns
   cor_potNPP_values <-  potNPP_values[ ,ncol(potNPP_values):1 ]

  # -- link from pixels to regions
   nc_file <- nc_open(paste('../',Parent_dir,'/tools/PREDICTS/data/Supplementary/Link_halfdegreeGrid_to_',Region_sep_class,'_R2.nc',sep = ""))
   mylon <- ncvar_get(nc_file, "lon")
   mylat <- ncvar_get(nc_file, "lat")

  if(Region_sep_class == 'AIM17regions'){
       myreg <- ncvar_get(nc_file, "aim_17region")
  } else if (Region_sep_class == 'IPBESsubregion') {
       myreg <- ncvar_get(nc_file, "ipbes_subreg")
  }

   regions <- ncvar_get(nc_file, "subregion_names")
   print(paste(regions))
   share_pix_in_reg <- ncvar_get(nc_file, "Area_share_landFromRegionAndGridcell_in_landFromPixel")
   nc_close(nc_file)

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

    # add abandoned LU classes
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

     list_files_aimplum <- Landuse_output

     cur_file <- unique(list_files_aimplum)[1]

    if(exists('collector_agg_values')){rm('collector_agg_values')};for(cur_file in list_files_aimplum) {
      
      print(paste('==== Now calculating BII of',cur_file,'====='))
      
      # - get IAM model and scenario
      cur_model <- unlist(strsplit(cur_file,split = '-'))[3]
      cur_scenario <- unlist(strsplit(cur_file,split = '-'))[2]
      cur_scenario <- gsub(cur_scenario, pattern = 'LUmap_', replacement = "")
      cur_scenario <- gsub(cur_scenario, pattern = '.nc', replacement = "")
      
      # - read file
      nc_file <- nc_open(cur_file)
      
      # . LUC classes
      #   indices
      mylc_class <- ncvar_get(nc_file, "lc_class")
      #   names & extended names
      mylc_class_name <- c('cropland_other','cropland_2Gbioen','grassland','forest_unmanaged','forest_managed','restored','other','built-up','abn_cropland_other','abn_cropland_2Gbioen','abn_grassland','abn_forest_managed')
      mylc_class_name_extended <- c('cropland_other','cropland_2Gbioen','grassland','forest_unmanaged','forest_managed','restored','other','built-up','abn_cropland_other','abn_cropland_2Gbioen','abn_grassland','abn_forest_managed','forest_unmanaged_primary','forest_unmanaged_secondary','other_primary','other_secondary')
      
      # . time variable
      myth <- ncvar_get(nc_file, "time")
      
      # . pixel area
      mypixarea <- ncvar_get(nc_file, "pixel_area")
      
      # . area shares
      myLC_area_share <- ncvar_get(nc_file, "LC_area_share5")
      
      # . close file
      nc_close(nc_file)
      
      # - generate area (prod) per LU class & time step: multiply area shares by pixel area (and also potential NPP)
      
      myLC_prod <- myLC_area_share
      myLC_area <- myLC_area_share
      for(cur_LU in seq(1,length(mylc_class_name),1)) {
        for(cur_TH in seq(1,dim(myLC_area)[4],1)) {
          myLC_area[,,cur_LU,cur_TH] <- myLC_area_share[,,cur_LU,cur_TH] * mypixarea
          myLC_prod[,,cur_LU,cur_TH] <- myLC_area[,,cur_LU,cur_TH] * cor_potNPP_values
        }
      }
      
      # - process into aggregates
      # . initialize
      output_template <- as.data.frame(expand.grid(myreg,seq(1,length(mylc_class_name),1),c('f','nf'),myth))
      colnames(output_template) <- c('region','lc_class','fnf','year')
      output_template$value_prod <- NA
      output_template$value_area <- NA
      
      # region by region, compute area and prod
      for(cur_reg in seq(1,length(myreg))) {
        
        # get shares of pixel in current region
        myshares <- share_pix_in_reg[,,cur_reg]
        cor_myshares <- myshares[ ,ncol(myshares):1 ] # correct the shares as they are inverted
        
        # compute aggregated values for each LU class & time horizon
        for(cur_TH in seq(1,dim(myLC_area)[4],1)) {
          for(cur_LU in seq(1,length(mylc_class_name),1)) {
            
            # clean NAs (replaced by 0)
            temp_area <- myLC_area[,,cur_LU,cur_TH]
            na_filter <- which(is.na(temp_area))
            if(length(na_filter) > 0) { temp_area[na_filter] <- 0}
            temp_prod <- myLC_prod[,,cur_LU,cur_TH]
            na_filter <- which(is.na(temp_prod))
            if(length(na_filter) > 0) { temp_prod[na_filter] <- 0}
            
            # multiply by shares of pixel in region, transform to vector and subset to summable
            r_values_area_nf <- as.vector(temp_area * cor_myshares * nonforest_mask_hd_data)
            r_values_area_nf <- r_values_area_nf[which(!is.na(r_values_area_nf) & r_values_area_nf>0)]
            
            r_values_prod_nf <- as.vector(temp_prod * cor_myshares * nonforest_mask_hd_data)
            r_values_prod_nf <- r_values_prod_nf[which(!is.na(r_values_prod_nf) & r_values_prod_nf>0)]
            
            r_values_area_f <- as.vector(temp_area * cor_myshares * forest_mask_hd_data)
            r_values_area_f <- r_values_area_f[which(!is.na(r_values_area_f) & r_values_area_f>0)]
            
            r_values_prod_f <- as.vector(temp_prod * cor_myshares * forest_mask_hd_data)
            r_values_prod_f <- r_values_prod_f[which(!is.na(r_values_prod_f) & r_values_prod_f>0)]
            
            
            # store  # editable
            
            cur_line_nf <- which(output_template$region==cur_reg &
                                  output_template$lc_class==cur_LU &
                                  output_template$fnf=='nf' &
                                  output_template$year==unique(output_template$year)[cur_TH])
            output_template$value_prod[cur_line_nf] <- sum(r_values_prod_nf)
            output_template$value_area[cur_line_nf] <- sum(r_values_area_nf)
            
            cur_line_f <- which(output_template$region==cur_reg &
                                  output_template$lc_class==cur_LU &
                                  output_template$fnf=='f' &
                                  output_template$year==unique(output_template$year)[cur_TH])
            output_template$value_prod[cur_line_f] <- sum(r_values_prod_f)
            output_template$value_area[cur_line_f] <- sum(r_values_area_f)
            
            
          }
        }
      }
      
    # - reformat and store
      
      output_template$region <- as.factor(output_template$region)
      levels(output_template$region) <- regions
      
      output_template$lc_class <- as.factor(output_template$lc_class)
      levels(output_template$lc_class) <- mylc_class_name
      
      temp_rf <- melt(output_template, id.vars = c('region','lc_class','fnf','year'))
      temp_rf$variable <- unlist(strsplit(as.character(temp_rf$variable),split = '_'))[seq(2,length(unlist(strsplit(as.character(temp_rf$variable),split = '_'))),2)]
      
      output_template_rf <- dcast(temp_rf,region + year + variable ~ lc_class + fnf)

      output_template_rf$scenario <- cur_scenario
      
      if(exists('collector_agg_values')) {
          collector_agg_values <- rbind.data.frame(collector_agg_values,output_template_rf)
        } else {
          collector_agg_values <- output_template_rf
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

      # # world aggregate for test
      # 
      # wld_collector_agg_values <- aggregate(collector_agg_values_bis[,c('cropland_other_f','cropland_other_nf','cropland_2Gbioen_f','cropland_2Gbioen_nf','grassland_f','grassland_nf','forest_unmanaged','forest_managed','restored_f','restored_nf','other_f','other_nf','built-up_f','built-up_nf','abn_cropland_other_f','abn_cropland_other_nf','abn_cropland_2Gbioen_f','abn_cropland_2Gbioen_nf','abn_grassland_f','abn_grassland_nf','abn_forest_managed',"sum")],
      #                                       by=list("year"=collector_agg_values_bis$year,
      #                                               "variable"=collector_agg_values_bis$variable,
      #                                               "date_tag"=collector_agg_values_bis$date_tag,
      #                                               "model"=collector_agg_values_bis$model,
      #                                               "scenario"=collector_agg_values_bis$scenario),
      #                                       FUN="sum")

    # -- reorder/ rename columns

      colnames(collector_agg_values_bis)[which(colnames(collector_agg_values_bis)=="built-up_f")] <- "built.up_f"
      colnames(collector_agg_values_bis)[which(colnames(collector_agg_values_bis)=="built-up_nf")] <- "built.up_nf"

      collector_agg_values_bis <- collector_agg_values_bis[,c('region','year','variable',
                                                              'cropland_other_f','cropland_other_nf','cropland_2Gbioen_f','cropland_2Gbioen_nf','grassland_f','grassland_nf','forest_managed','forest_unmanaged','restored_f','restored_nf','other_f','other_nf','built.up_f','built.up_nf','abn_cropland_other_f','abn_cropland_other_nf','abn_cropland_2Gbioen_f','abn_cropland_2Gbioen_nf','abn_grassland_f','abn_grassland_nf','abn_forest_managed',
                                                              'scenario','sum')]

# # EXPORT ------------------------------------------------------------------

#  # -- ALL AT ONCE
    write.table(collector_agg_values_bis, paste("../output/csv/",SceName,"/aggregated_regions_forPREDICTS_R2_final.csv",sep = ""),col.names = T, row.names = F, quote = F,sep=',')
#    #write.table(wld_collector_agg_values,'wld_aggregated_IPBESsubregions_forPREDICTS_R2_final.csv',col.names = T, row.names = F, quote = F,sep=',')

# PROCESS -----------------------------------------------------------------
  # -- read file
    agg <- collector_agg_values_bis 
    
  # -- add global aggregate to the LU data

    cols_to_agg <- c(BII_coefs$LUclass,"sum")
  # -- add global aggregate to the LU data
    R5ASIA <- c("CHN","IND","XSE","XSA")
    R5REF <- c("XER","CIS")
    R5MAF <- c("XME","XNF","XAF")
    R5LAM <- c("BRA","XLM")
    R5OECD90_EU <- c("XE25","TUR","XOC","JPN","CAN","USA")

    # agg world 
    cols_to_agg <- c(BII_coefs$LUclass,"sum")
    agg_world <- aggregate(agg[,cols_to_agg],
                          by=list('year'=agg$year, 
                                  'scenario'=agg$scenario, 
                                  'variable'=agg$variable),    # model row can be remove in original one 
                          FUN='sum', na.rm=T)
    agg_world$region <- 'World'; agg_world <- agg_world[,colnames(agg)]
    # agg R5ASIA  
    agg_region <- agg %>% 
      filter(region %in% R5ASIA) 
    agg_R5ASIA <- aggregate(agg_region[,cols_to_agg],
                             by=list('year'=agg_region$year, 
                                     'scenario'=agg_region$scenario, 
                                     'variable'=agg_region$variable),    # model row can be remove in original one 
                             FUN='sum', na.rm=T)
    agg_R5ASIA$region <- c("R5ASIA") ; agg_R5ASIA <- agg_R5ASIA[,colnames(agg)]
    # agg R5REF
    agg_region <- agg %>% 
      filter(region %in% R5REF) 
    agg_R5REF <- aggregate(agg_region[,cols_to_agg],
                            by=list('year'=agg_region$year, 
                                    'scenario'=agg_region$scenario, 
                                    'variable'=agg_region$variable),    # model row can be remove in original one 
                            FUN='sum', na.rm=T)
    agg_R5REF$region <- c("R5REF") ; agg_R5REF <- agg_R5REF[,colnames(agg)]
    # agg R5LAM
    agg_region <- agg %>% 
      filter(region %in% R5LAM) 
    agg_R5LAM <- aggregate(agg_region[,cols_to_agg],
                            by=list('year'=agg_region$year, 
                                    'scenario'=agg_region$scenario, 
                                    'variable'=agg_region$variable),    # model row can be remove in original one 
                            FUN='sum', na.rm=T)
    agg_R5LAM$region <- c("R5LAM") ; agg_R5LAM <- agg_R5LAM[,colnames(agg)]
    # agg R5MAF
    agg_region <- agg %>% 
      filter(region %in% R5MAF) 
    agg_R5MAF <- aggregate(agg_region[,cols_to_agg],
                            by=list('year'=agg_region$year, 
                                    'scenario'=agg_region$scenario, 
                                    'variable'=agg_region$variable),    # model row can be remove in original one 
                            FUN='sum', na.rm=T)
    agg_R5MAF$region <- c("R5MAF") ; agg_R5MAF <- agg_R5MAF[,colnames(agg)]
    # agg R5OECD90+EU  
    agg_region <- agg %>% 
      filter(region %in% R5OECD90_EU) 
    agg_R5OECD90_EU <- aggregate(agg_region[,cols_to_agg],
                            by=list('year'=agg_region$year, 
                                    'scenario'=agg_region$scenario, 
                                    'variable'=agg_region$variable),    # model row can be remove in original one 
                            FUN='sum', na.rm=T)
    agg_R5OECD90_EU$region <- c("R5OECD90+EU") ; agg_R5OECD90_EU <- agg_R5OECD90_EU[,colnames(agg)]
  # aggregate
    agg2 <- rbind.data.frame(agg,agg_world,agg_R5ASIA,agg_R5REF,agg_R5LAM,agg_R5MAF,agg_R5OECD90_EU)

  # -- merge 'area or prod' subset with BII value, multiply & aggregate

    to_join <- melt(agg2[which(agg2$variable==weight_by),-which(colnames(agg2)=='variable')], 
                    id.vars = c("region","year","scenario","sum"))
    to_join$variable <- as.character(to_join$variable)
    temp <- left_join(to_join,
                      BII_coefs, by=c("variable"="LUclass"))
    temp$BII_weightedvalue <- temp$BII * temp$value / temp$sum
    agg_BII <- aggregate(temp$BII_weightedvalue,
                        by=list('region'=temp$region,
                                'year'=temp$year,
                                'scenario'=temp$scenario,
                                'sum'=temp$sum),
                        FUN='sum',na.rm=T)
    colnames(agg_BII)[which(colnames(agg_BII)=='x')] <- 'value'

  # -- reformat output

    agg_BII2 <- agg_BII
    agg_BII2$unit <- "[-]"

    output <- dcast(agg_BII2[,-which(colnames(agg_BII2)%in%c('sum'))], 
                    unit + scenario + region ~ year,
                    value.var = 'value')

    colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))] <- paste('v_',colnames(output)[which(substr(colnames(output),1,1)%in%c('1','2'))],sep='')

    output2 <- output[,c("unit","scenario","region",
                        "v_2005","v_2010","v_2020","v_2030","v_2040","v_2050","v_2060","v_2070","v_2080","v_2090","v_2100")] 

    output_IAMCTemp <- output2 %>% 
      select(-c("unit","scenario"))
    colnames(output_IAMCTemp) <- c("region","2005","2010","2020","2030","2040","2050","2060","2070","2080","2090","2100")

# EXPORT ------------------------------------------------------------------

  if(weight_by == "area"){
    write.table(output2,paste("../output/csv/",SceName,"/BII_regionagg_area_",SceName,".csv",sep = ""),col.names = T, row.names = F, quote = F, sep=',')
  } else if(weight_by == "prod") {
    write.table(output2,paste("../output/csv/",SceName,"/BII_regionagg_prod_",SceName,".csv",sep = ""),col.names = T, row.names = F, quote = F, sep=',')
    write.table(output_IAMCTemp,paste("../output/csv/",SceName,"/BII_regionagg_prod_",SceName,"_IAMCTemp.csv",sep = ""),col.names = T, row.names = F, quote = F, sep=',')
  }
