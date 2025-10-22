
# load packages and directory settings ------------------------------------
library(dplyr) # for easy data manipulation
library(tidyr) # ditto
library(geosphere) # calculating geographic distance between sites
library(purrr) # running loops
library(furrr) # running loops in parallel
library(gower)
library(data.table)

# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir

outputDir1 <- paste0(outputDir,'processedData/PREDICTSdatabase/')
if(!dir.exists(outputDir1))dir.create(outputDir1)
outputDir2 <- paste0(outputDir,'processedData/biodiversityIndex/')
if(!dir.exists(outputDir2))dir.create(outputDir2)

# switch
CS_index_name <- "JacAbSym"

multiprocesscores <- future::availableCores() -1
cat("multiprocess core number is ",multiprocesscores,"\n")

# data processing ---------------------------------------------------------
print('database processing, mainly redefine land use classes')
# -- forest
 database_forest <- readRDS(paste0(outputDir1,"database_forest.rds")) %>% 
  # make a level of Primary minimal. Everything else gets the coarse land use
  mutate(
    LandUse = ifelse(Predominant_land_use == "Primary vegetation" & Use_intensity == "Minimal use","Primary vegetation Minimal use",paste(Predominant_land_use)),
    # change cannot decide into NA
    LandUse = ifelse(Predominant_land_use == "Cannot decide",NA,paste(LandUse)),
    # relevel the factor so that Primary minimal is the first level (so that it is the intercept term in models)
    LandUse = factor(LandUse),
    LandUse = relevel(LandUse, ref = "Primary vegetation Minimal use") 
  ) %>% 
  filter(!is.na(LandUse)) %>% 
  droplevels()
 
 # loading data from BTC supplementary material
 forSSPedit <- readRDS(paste0(dataDir,"supplementary/forSSPedit_BTC.rds")) %>% 
   filter(!is.na(LandUse)) %>% 
   droplevels() %>%  
   #remove unnecessary variables
   select(-c("Study_name", "Site_name","bio5","bio6","bio13","bio14","alt","Longitude","Latitude"))
 
 # connecting two data  
 database_forest2 <- database_forest %>% 
   dplyr::left_join(forSSPedit, by = c("SS","SSB","SSS", "Diversity_metric_type", "Diversity_metric", "Source_ID","Study_number", "Site_number", "Block","Sampling_effort","Measurement","SSBS","Taxon_name_entered")) %>%
   droplevels() %>% 
   rename('LandUse' = LandUse.y) %>% 
   rename('LandUse_original' = LandUse.x)
 
 # refine the landuse class of new added data
 database_forest3 <- database_forest2 %>% 
   filter(is.na(LandUse)) %>% 
   mutate(LandUse_original = ifelse(Predominant_land_use == "Primary vegetation" & Use_intensity == "Minimal use","Primary vegetation Minimal use",paste(Predominant_land_use))) %>% 
   mutate(
     # make judge from source information
     LandUse = case_when(
       Source_ID %in% c("CM2_2009__SilvaMoco", "CM2_2012__Kone", "CM2_2009__HaroCarrion", "SS1_2013__Shahabuddin") & Predominant_land_use == "Plantation forest" ~ "Perennial",
       Source_ID %in% c("JB3_2013_Irwin", "JB3_2019__daSilva", "XH1_2015__Rachakonda", "XH1_2016__Mandal") & Predominant_land_use == "Plantation forest" ~ "Timber",
       Source_ID %in% c("JB3_2018__Chiawo", "SS1_2013__Shahabuddin", "GN1_2010__Hvenegaard", "GN1_2018__AlvarezAlvarez") & Predominant_land_use == "Cropland" ~ "Annual_nitrogen",
       TRUE ~ as.character(LandUse_original))) %>%
   filter(!(LandUse %in% c("Cropland","Plantation forest","Secondary vegetation (indeterminate age)"))) %>%
   mutate(# distinguish Mature SV Minimal use
          LandUse = ifelse(LandUse == "Mature secondary vegetation" & Use_intensity == "Minimal use","Mature secondary vegetation Minimal use",paste(LandUse)),
          # distinguish Young SV Minimal use
          LandUse = ifelse(LandUse == "Young secondary vegetation" & Use_intensity == "Minimal use","Young secondary vegetation Minimal use",paste(LandUse)),
          # merge other Secondary vegetation site into SV Timber Light and Intense (After confirming original data include whose Use_intensity = Cannot decide)
          LandUse = ifelse(grepl("Secondary", LandUse) & Use_intensity != "Minimal use", "Secondary vegetation and Timber Light and Intense",paste(LandUse)),
          # merge Timber Light and Intense into SV Timber Light and Intense
          LandUse = ifelse(LandUse == "Timber" & Use_intensity %in% c("Light use", "Intense use"), "Secondary vegetation and Timber Light and Intense", paste(LandUse)),
          # change cannot decide into NA
          LandUse = ifelse(Predominant_land_use == "Cannot decide",NA,paste(LandUse))) %>% 
   filter(!is.na(LandUse)) %>% 
   filter(!(LandUse %in% c("Mature secondary vegetation","Young secondary vegetation","Intermediate secondary vegetation"))) %>%
   droplevels()
 
 # output
 database_forest_output <- database_forest2 %>% 
   filter(!is.na(LandUse)) %>% 
   rbind(database_forest3) %>% 
   mutate(# relevel the factor so that Primary minimal is the first level (so that it is the intercept term in models)
          LandUse = factor(LandUse),
          LandUse = relevel(LandUse, ref = "Primary vegetation Minimal use")) %>% 
   saveRDS(file = paste0(outputDir1,'database_forest.rds'))
 
# -- nonforest
 database_nonforest <- readRDS(paste0(outputDir1,"database_nonforest.rds")) %>% 
   # make a level of Primary minimal. Everything else gets the coarse land use
   mutate(
     LandUse = ifelse(Predominant_land_use == "Primary vegetation" & Use_intensity == "Minimal use","Primary vegetation Minimal use",paste(Predominant_land_use)),
     # change cannot decide into NA
     LandUse = ifelse(Predominant_land_use == "Cannot decide",NA, paste(LandUse)),
     # relevel the factor so that Primary minimal is the first level (so that it is the intercept term in models)
     LandUse = factor(LandUse),
     LandUse = relevel(LandUse, ref = "Primary vegetation Minimal use") 
   ) %>% 
   filter(!is.na(LandUse)) %>% 
   droplevels()

 # for nonforest data
 nonforSSPedit <- readRDS(paste0(dataDir,"supplementary/nonforSSPedit_BTC.rds")) %>% 
  filter(!is.na(LandUse)) %>% 
  droplevels() %>% 
  #remove unnecessary variables
  select(-c("Study_name", "Site_name","bio5","bio6","bio13","bio14","alt","Longitude","Latitude"))

 database_nonforest2 <- database_nonforest %>% 
  dplyr::left_join(nonforSSPedit, by = c("SS","SSB","SSS", "Diversity_metric_type", "Diversity_metric", "Source_ID","Study_number", "Site_number", "Block","Sampling_effort", "Measurement","SSBS","Taxon_name_entered")) %>%
  droplevels() %>% 
  rename('LandUse' = LandUse.y) %>% 
  rename('LandUse_original' = LandUse.x) 
  
 # nonforest
 database_nonforest3 <- database_nonforest2 %>% 
   filter(is.na(LandUse)) %>% 
   mutate(LandUse_original = ifelse(Predominant_land_use == "Primary vegetation" & Use_intensity == "Minimal use","Primary vegetation Minimal use",paste(Predominant_land_use))) %>% 
   mutate(
     # make judgement from Source information
     LandUse = case_when(
       Source_ID %in% c("CM2_2009__SilvaMoco", "CM2_2012__Kone", "CM2_2009__HaroCarrion", "SS1_2013__Shahabuddin") & Predominant_land_use == "Plantation forest" ~ "Perennial",
       Source_ID %in% c("JB3_2013_Irwin", "JB3_2019__daSilva", "XH1_2015__Rachakonda", "XH1_2016__Mandal") & Predominant_land_use == "Plantation forest" ~ "Timber",
       Source_ID %in% c("JB3_2018__Chiawo", "SS1_2013__Shahabuddin", "GN1_2010__Hvenegaard", "GN1_2018__AlvarezAlvarez") & Predominant_land_use == "Cropland" ~ "Annual_nitrogen",
       TRUE ~ as.character(LandUse_original))) %>%
   filter(!(LandUse %in% c("Cropland","Plantation forest"))) %>% 
   mutate( 
     # merge other Secondary vegetation site into SV Timber Light and Intense (After confirming original data include whose Use_intensity = Cannot decide)
     LandUse = ifelse(grepl("Secondary", LandUse) & Use_intensity == "Minimal use", "Secondary vegetation Minimal use",paste(LandUse)),
     # change SV (indeterminate age) into NA or change cannot decide into NA
     LandUse = ifelse(Predominant_land_use == "Cannot decide" | LandUse == 'Secondary vegetation (indeterminate age)',NA,paste(LandUse))) %>% 
   filter(!is.na(LandUse)) %>%
   droplevels()
 database_nonforest_output <- database_nonforest2 %>% 
   filter(!is.na(LandUse)) %>% 
   rbind(database_nonforest3) %>% 
   mutate(# relevel the factor so that Primary minimal is the first level (so that it is the intercept term in models)
     LandUse = factor(LandUse),
     LandUse = relevel(LandUse, ref = "Primary vegetation Minimal use")) %>% 
   saveRDS(file = paste0(outputDir1,'database_nonforest.rds'))


#Calculate TotalAbundance----------------------------------------------------
print('Calculating biodiviersity index which become objective variables when constructng regression models')
print('Calculating TotalAbundance')

# read in the data
database_forest <- readRDS(paste0(outputDir1,'database_forest.rds'))
database_nonforest <- readRDS(paste0(outputDir1,'database_nonforest.rds'))

# Calculate forest side
ab_forest <- database_forest %>%    
  # pull out just the abundance measures
  filter(Diversity_metric_type == "Abundance") %>%    
  # group by SSBS (each unique value corresponds to a unique site)
  group_by(SSBS) %>%    
  # now add up all the abundance measurements within each site
  mutate(TotalAbundance = sum(Effort_corrected_measurement)) %>%    
  # ungroup
  ungroup() %>%    
  # pull out unique sites
  distinct(SSBS, .keep_all = TRUE) %>%    
  # now group by Study ID
  group_by(SS) %>%    
  # pull out the maximum abundance for each study
  mutate(MaxAbundance = max(TotalAbundance)) %>%    
  # ungroup
  ungroup() %>%    
  # now rescale total abundance, so that within each study, abundance varies from 0 to 1.
  mutate(RescaledAbundance = TotalAbundance/MaxAbundance) %>%     
  # select rows
  dplyr::select(RescaledAbundance, LandUse, LandUse_original, Use_intensity,SS, SSB, Longitude, Latitude)

# Calculate nonforest side
ab_nonforest <- database_nonforest %>%    
  # pull out just the abundance measures
  filter(Diversity_metric_type == "Abundance") %>%   
  # group by SSBS (each unique value corresponds to a unique site)
  group_by(SSBS) %>%    
  # now add up all the abundance measurements within each site
  mutate(TotalAbundance = sum(Effort_corrected_measurement)) %>%    
  # ungroup
  ungroup() %>%    
  # pull out unique sites
  distinct(SSBS, .keep_all = TRUE) %>%    
  # now group by Study ID
  group_by(SS) %>%        
  # pull out the maximum abundance for each study
  mutate(MaxAbundance = max(TotalAbundance)) %>%    
  # ungroup
  ungroup() %>%    
  # now rescale total abundance, so that within each study, abundance varies from 0 to 1.
  mutate(RescaledAbundance = TotalAbundance/MaxAbundance) %>%     
  # select rows
  dplyr::select(RescaledAbundance, LandUse, LandUse_original, Use_intensity,SS, SSB, Longitude, Latitude)

# output ------------------------------------------------------------------
saveRDS(ab_forest, file = paste0(outputDir2,"ab_forest.rds"))
saveRDS(ab_nonforest, file = paste0(outputDir2,"ab_nonforest.rds"))

#---Calculate Compositional Similarity---------------------------------------------------------
# Forest part ----------------------------------------------------- 
print(paste("Calculating CompositionalSimilarity in Forest part"))
  
#First processing
cs_data_forest <- database_forest %>% 
  #drop any rows with unknown LandUse
  filter(!is.na(LandUse)) %>%      
  #pull out only the abundance data
  filter(Diversity_metric_type == "Abundance") %>%      
  #group by Study
  group_by(SS) %>%       
  #calculate the number of unique sampling efforts within that study
  mutate(n_sample_effort = n_distinct(Sampling_effort)) %>%      
  #calculate the number of unique species sampled in that study
  mutate(n_species = n_distinct(Taxon_name_entered)) %>%      
  #check if there are any Primary vegetation Minimal use sites in the dataset
  mutate(n_primin_records = sum(LandUse == "Primary vegetation Minimal use")) %>%       
  ungroup() 
  
  #Paste the number of removing rows
  rem <- sum(database_forest$Diversity_metric_type != "Abundance") 
  print(paste("Removing", rem, "rows because their Diversity_metric_type is not Abundance")) 
  rem <- sum(cs_data_forest$n_sample_effort ==1) 
  print(paste("Removing", rem, "rows because there are different sampling efforts in the same SS")) 
  rem <- sum(cs_data_forest$n_species <=1)
  print(paste("Removing", rem, "rows because there aren't enough species numbers"))        
  rem <- sum(cs_data_forest$n_primin_records ==0) 
  print(paste("Removing", rem, "rows because there aren't primin sites in the same SS")) 
  # rem <- sum(cs_data_forest$bio5 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 5 data"))
  # rem <- sum(cs_data_forest$bio6 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 6 data")) 
  # rem <- sum(cs_data_forest$bio13 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 13 data")) 
  # rem <- sum(cs_data_forest$bio14 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 14 data")) 
  # rem <- sum(cs_data_forest$alt == NA) 
  # print(paste("Removing", rem, "rows because there aren't altitude data")) 

cs_data_forest <- cs_data_forest %>%
  #now keep only the studies with one unique sampling effort
  filter(n_sample_effort == 1) %>%       
  #and keep only studies with more than one species
  #as these studies clearly aren't looking at assemblage-level diversity
  filter(n_species >1 ) %>%       
  #and keep only studies with at least some Primary vegetation Minimal use data
  filter(n_primin_records >0 ) %>%    
  #keep only the data which have bioclimate and altitude data
  filter(!is.na(bio5)&!is.na(bio6)&!is.na(bio13)&!is.na(bio14)&!is.na(alt)) %>%  
  #drop empty factor levels
  droplevels()

print(paste("Final data has", nrow(cs_data_forest),"rows ; The number of Studies is", n_distinct(cs_data_forest$SS), "; The number of Sites is", n_distinct(cs_data_forest$SSBS)))

if(CS_index_name == "Bray"){
  
  print("Calculate Bray")
  
  get_bray <- function(s1, s2, data){      
    require(betapart)      
    sp_data <- data %>%        
      # filter out the SSBS that matches the pair of sites we're interested in
      filter(SSBS %in% c(s1, s2)) %>%        
      # pull out the site name, species name and abundance information
      dplyr::select(SSBS, Taxon_name_entered, Measurement) %>%        
      # pivot so that each column is a species and each row is a site
      pivot_wider(names_from = Taxon_name_entered, values_from = Measurement) %>%        
      # set the rownames to the SSBS and then remove that column
      column_to_rownames("SSBS")      
    # if one of the sites doesn't have any individuals in it
    # i.e. the row sum is 0
    if(sum(rowSums(sp_data) == 0, na.rm = TRUE) == 1){
      # then the similarity between sites should be 0
      bray <- 0
      # if both sites have no individuals
    }else if(sum(rowSums(sp_data) == 0, na.rm = TRUE) == 2){
      # then class the similarity as NA
      bray <- NA
      # otherwise if both sites have individuals, calculate the balanced bray-curtis
      # as similarity (1-bray)
    }else{
      bray <- 1 - 
        bray.part(sp_data) %>%
        pluck("bray.bal") %>%
        pluck(1)
    } 
  }
} else if (CS_index_name == "JacAbSym"){
  
  print("Calculate JacAbSym")
  
  get_JacAbSym <- function(s1, s2, data){
    # get the list of species that are present in site 1 (i.e., their abundance was greater than 0)
    s1species <- data %>%    
      # filter out the SSBS that matches s1
      filter(SSBS == s1) %>%    
      # filter out the species where the Measurement (abundance) is greater than 0
      filter(Measurement > 0) %>%    
      # get the unique species from this dataset
      distinct(Taxon_name_entered) %>%    
      # pull out the column into a vector
      pull  
    # for site 2, get the total abundance of species that are also present in site 1
    s2abundance_s1species <- data %>%    
      # filter out the SSBS that matches s2
      filter(SSBS == s2) %>%    
      # filter out the species that are also present in site 1
      filter(Taxon_name_entered %in% s1species) %>%
      # pull out the Measurement into a vector
      pull(Measurement) %>%
      # calculate the sum
      sum()
    # calculate the total abundance of all species in site 2
    s2_sum <- data %>%
      # filter out the SSBS that matches s2
      filter(SSBS == s2) %>%
      # pull out the measurement column (the abundance)
      pull(Measurement) %>%
      # calculate the sum
      sum()  
    # Now calculate the compositional similarity
    # this is the number of individuals of species also found in s1, divided by the total abundance in s2 
    # so that equates to the proportion of individuals in s2 that are of species also found in s1
    
    sor <- s2abundance_s1species / s2_sum
    
    # if there are no taxa in common, then sor = 0
    # if abundances of all taxa are zero, then similarity becomes NaN.
    return(sor)
    
  }
}
  
# get a vector of each study to loop over
studies <- cs_data_forest %>%
  distinct(SS) %>%
  pull()

site_comparisons_for <- map_dfr(.x = studies, .f = function(x){
    # filter out the given study
  site_data <- filter(cs_data_forest, SS == x) %>%
    # pull out the SSBS and LandUse information
    dplyr::select(SSBS, LandUse) %>%
    # simplify the data so we only have one row for each site
    distinct(SSBS, .keep_all = TRUE)      
  # pull out the sites that are Primary vegetation Minimal use (we only want to use comparisons with the baseline)
  baseline_sites <- site_data %>%
    filter(LandUse == "Primary vegetation Minimal use") %>%
    pull(SSBS)      
  # pull out all the sites
  site_list <- site_data %>%
    pull(SSBS)      
  # get all site x site comparisons for this study
  site_comparisons_for <- expand.grid(baseline_sites, site_list) %>%        
    # rename the columns so they will be what the compositional similarity function expects for ease
    rename(s1 = Var1, s2 = Var2) %>%        
    # remove the comparisons where the same site is being compared to itself
    filter(s1 != s2) %>%        
    # make the values characters rather than factors
    mutate(s1 = as.character(s1),
            s2 = as.character(s2),               
            # add the full name
            contrast = paste(s1, "vs", s2, sep = "_"),               
            # add the study id
            SS = as.character(x))      
  return(site_comparisons_for)
})

future::plan(multicore, workers = multiprocesscores)

# I'm using map2 (because there are two arguments I'm passing through - s1 and s2)
# and the map2_dbl because the output I want is a vector of numbers (double rather than integer format)
# so this function is going to go through each s1 and s2 in turn
# and pass them into the CS_index_name calculate function
if(CS_index_name == "Bray"){
  CS_index <- future_map2_dbl(.x = site_comparisons_for$s1,
                              .y = site_comparisons_for$s2,
                              ~get_bray(s1 = .x, s2 = .y, data = cs_data_forest))
} else if (CS_index_name == "JacAbSym"){
  CS_index <- future_map2_dbl(.x = site_comparisons_for$s1,
                              .y = site_comparisons_for$s2,
                              ~get_JacAbSym(s1 = .x, s2 = .y, data = cs_data_forest))
}

# stop running things in parallel for now
future::plan(sequential)

# for the other required information, we don't need to run loops
latlongs <- cs_data_forest %>%
  # for each site in the dataset
  group_by(SSBS) %>%
  # pull out the lat and long
  reframe(Lat = unique(Latitude),
            Long = unique(Longitude))

lus <- cs_data_forest %>%
  # for each site in the dataset
  group_by(SSBS) %>%
  # pull out the land use
  reframe(lu = unique(LandUse))

# now let's put all the data together
cs_data_for <- site_comparisons_for %>%
  # add in the bray-curtis data
  # which is already in the same order as site_comparisons
  mutate(CS_index = CS_index) %>%
  # get the lat and long for s1
  left_join(latlongs, by = c("s1" = "SSBS")) %>%
  rename(s1_lat = Lat,
          s1_long = Long) %>%
  # get the lat and long for s2
  left_join(latlongs, by = c("s2" = "SSBS")) %>%
  rename(s2_lat = Lat,
          s2_long = Long) %>%
  # calculate the geographic distances between s1 and s2 sites
  mutate(geog_dist = distHaversine(cbind(s1_long, s1_lat), cbind(s2_long, s2_lat))) %>%
  # get the land use for s1
  left_join(lus, by = c("s1" = "SSBS")) %>%
  rename(s1_lu = lu) %>%
  # get the land use for s2
  left_join(lus, by = c("s2" = "SSBS")) %>%
  rename(s2_lu = lu) %>%
  # create an lu_contrast column (what we'll use for modelling)
  mutate(lu_contrast = paste(s1_lu, s2_lu, sep = "_vs_"))

# Nonforest---------------------------------------------------------
print(paste("Calculating CompositionalSimilarity in Non-forest part"))

# First processing     
cs_data_nonforest <- database_nonforest %>% 
  #drop any rows with unknown LandUse
  filter(!is.na(LandUse)) %>% 
  #pull out only the abundance data
  filter(Diversity_metric_type == "Abundance") %>% 
  #group by Study
  group_by(SS) %>% 
  #calculate the number of unique sampling efforts within that study
  mutate(n_sample_effort = n_distinct(Sampling_effort)) %>% 
  #calculate the number of unique species sampled in that study
  mutate(n_species = n_distinct(Taxon_name_entered)) %>% 
  #check if there are any Primary vegetation Minimal use sites in the dataset
  mutate(n_primin_records = sum(LandUse == "Primary vegetation Minimal use")) %>% 
  ungroup() 

#Paste the number of removing rows
  rem <- sum(database_nonforest$Diversity_metric_type != "Abundance") 
  print(paste("Removing", rem, "rows because their Diversity_metric_type is not Abundance")) 
  rem <- sum(cs_data_nonforest$n_sample_effort ==1) 
  print(paste("Removing", rem, "rows because there are different sampling efforts in the same SS")) 
  rem <- sum(cs_data_nonforest$n_species <=1)
  print(paste("Removing", rem, "rows because there aren't enough species numbers"))        
  rem <- sum(cs_data_nonforest$n_primin_records ==0) 
  print(paste("Removing", rem, "rows because there aren't primin sites in the same SS")) 
  # rem <- sum(cs_data_nonforest$bio5 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 5 data"))
  # rem <- sum(cs_data_nonforest$bio6 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 6 data")) 
  # rem <- sum(cs_data_nonforest$bio13 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 13 data")) 
  # rem <- sum(cs_data_nonforest$bio14 == NA) 
  # print(paste("Removing", rem, "rows because there aren't bioclimate 14 data")) 
  # rem <- sum(cs_data_nonforest$alt == NA) 
  # print(paste("Removing", rem, "rows because there aren't altitude data")) 

cs_data_nonforest <- cs_data_nonforest %>% 
  #now keep only the studies with one unique sampling effort
  filter(n_sample_effort == 1) %>% 
  #and keep only studies with more than one species
  #as these studies clearly aren't looking at assemblage-level diversity
  filter(n_species >1 ) %>% 
  #and keep only studies with at least some Primary vegetation Minimal use data
  filter(n_primin_records >0 ) %>% 
  #keep only the data which have bioclimate and altitude data
  filter(!is.na(bio5)&!is.na(bio6)&!is.na(bio13)&!is.na(bio14)&!is.na(alt)) %>%
  #drop empty factor levels
  droplevels()

print(paste("Final data has", nrow(cs_data_nonforest),"rows ; The number of Studies is", n_distinct(cs_data_nonforest$SS), "; The number of Sites is", n_distinct(cs_data_nonforest$SSBS)))

# get a vector of each study to loop over
studies <- cs_data_nonforest %>%
  distinct(SS) %>%
  pull()

site_comparisons_nonfor <- map_dfr(.x = studies, .f = function(x){
  # filter out the given study
  site_data <- filter(cs_data_nonforest, SS == x) %>%
    # pull out the SSBS and LandUse information
    dplyr::select(SSBS, LandUse) %>%
    # simplify the data so we only have one row for each site
    distinct(SSBS, .keep_all = TRUE)
  # pull out the sites that are Primary vegetation Minimal use (we only want to use comparisons with the baseline)
  baseline_sites <- site_data %>%
    filter(LandUse == "Primary vegetation Minimal use") %>%
    pull(SSBS)
  # pull out all the sites
  site_list <- site_data %>%
    pull(SSBS)
  # get all site x site comparisons for this study
  site_comparisons_nonfor <- expand.grid(baseline_sites, site_list) %>%
    # rename the columns so they will be what the compositional similarity function expects for ease
    rename(s1 = Var1, s2 = Var2) %>%
    # remove the comparisons where the same site is being compared to itself
    filter(s1 != s2) %>%
    # make the values characters rather than factors
    mutate(s1 = as.character(s1),
            s2 = as.character(s2),
            
            # add the full name
            contrast = paste(s1, "vs", s2, sep = "_"),
            
            # add the study id
            SS = as.character(x))
  
  return(site_comparisons_nonfor)
})

future::plan(multicore, workers = multiprocesscores)

# I'm using map2 (because there are two arguments I'm passing through - s1 and s2)
# and the map2_dbl because the output I want is a vector of numbers (double rather than integer format)
# so this function is going to go through each s1 and s2 in turn
# and pass them into the CS_index calculate function
if(CS_index_name == "Bray"){
  CS_index <- future_map2_dbl(.x = site_comparisons_nonfor$s1,
                              .y = site_comparisons_nonfor$s2,
                              ~get_bray(s1 = .x, s2 = .y, data = cs_data_nonforest))
} else if (CS_index_name == "JacAbSym"){
  CS_index <- future_map2_dbl(.x = site_comparisons_nonfor$s1,
                              .y = site_comparisons_nonfor$s2,
                              ~get_JacAbSym(s1 = .x, s2 = .y, data = cs_data_nonforest))
}

# stop running things in parallel for now
future::plan(sequential)

# for the other required information, we don't need to run loops
latlongs <- cs_data_nonforest %>%
  # for each site in the dataset
  group_by(SSBS) %>%
  # pull out the lat and long
  reframe(Lat = unique(Latitude),
            Long = unique(Longitude))

lus <- cs_data_nonforest %>%
  # for each site in the dataset
  group_by(SSBS) %>%
  # pull out the land use
  reframe(lu = unique(LandUse))

# now let's put all the data together
cs_data_nonfor <- site_comparisons_nonfor %>%
  # add in the CS_index data
  # which is already in the same order as site_comparisons
  mutate(CS_index = CS_index) %>%
  # get the lat and long for s1
  left_join(latlongs, by = c("s1" = "SSBS")) %>%
  rename(s1_lat = Lat,
          s1_long = Long) %>%
  # get the lat and long for s2
  left_join(latlongs, by = c("s2" = "SSBS")) %>%
  rename(s2_lat = Lat,
          s2_long = Long) %>%
  # calculate the geographic distances between s1 and s2 sites
  mutate(geog_dist = distHaversine(cbind(s1_long, s1_lat), cbind(s2_long, s2_lat))) %>%
  # get the land use for s1
  left_join(lus, by = c("s1" = "SSBS")) %>%
  rename(s1_lu = lu) %>%
  # get the land use for s2
  left_join(lus, by = c("s2" = "SSBS")) %>%
  rename(s2_lu = lu) %>%
  # create an lu_contrast column (what we'll use for modelling)
  mutate(lu_contrast = paste(s1_lu, s2_lu, sep = "_vs_"))        

# Calculate Envdist -------------------------------------------------------    
print("Adding EnvDist")

# data prepare
forsites <- database_forest[!duplicated(database_forest$SSBS), ]
envVars = c("bio5","bio6","bio13","bio14","alt")
s1Data <- data.table(bio5 = forsites$bio5[match(cs_data_for$s1, forsites$SSBS)],
                      bio6 = forsites$bio6[match(cs_data_for$s1, forsites$SSBS)],
                      bio13 = forsites$bio13[match(cs_data_for$s1, forsites$SSBS)],
                      bio14 = forsites$bio14[match(cs_data_for$s1, forsites$SSBS)],
                      alt = forsites$alt[match(cs_data_for$s1, forsites$SSBS)])

s2Data <- data.table(bio5 = forsites$bio5[match(cs_data_for$s2, forsites$SSBS)],
                      bio6 = forsites$bio6[match(cs_data_for$s2, forsites$SSBS)],
                      bio13 = forsites$bio13[match(cs_data_for$s2, forsites$SSBS)],
                      bio14 = forsites$bio14[match(cs_data_for$s2, forsites$SSBS)],
                      alt = forsites$alt[match(cs_data_for$s2, forsites$SSBS)])
# calculate 
cs_data_for$gowerEnvDist <- gower_dist(s1Data, s2Data)
cs_data_for$cubrtEnvDist<-cs_data_for$gowerEnvDist^(1/3)

# data prepare
nonforsites <- database_nonforest[!duplicated(database_nonforest$SSBS), ]
envVars = c("bio5","bio6","bio13","bio14","alt")
s1Data <- data.table(bio5 = nonforsites$bio5[match(cs_data_nonfor$s1, nonforsites$SSBS)],
                      bio6 = nonforsites$bio6[match(cs_data_nonfor$s1, nonforsites$SSBS)],
                      bio13 = nonforsites$bio13[match(cs_data_nonfor$s1, nonforsites$SSBS)],
                      bio14 = nonforsites$bio14[match(cs_data_nonfor$s1, nonforsites$SSBS)],
                      alt = nonforsites$alt[match(cs_data_nonfor$s1, nonforsites$SSBS)])

s2Data <- data.table(bio5 = nonforsites$bio5[match(cs_data_nonfor$s2, nonforsites$SSBS)],
                      bio6 = nonforsites$bio6[match(cs_data_nonfor$s2, nonforsites$SSBS)],
                      bio13 = nonforsites$bio13[match(cs_data_nonfor$s2, nonforsites$SSBS)],
                      bio14 = nonforsites$bio14[match(cs_data_nonfor$s2, nonforsites$SSBS)],
                      alt = nonforsites$alt[match(cs_data_nonfor$s2, nonforsites$SSBS)])
# calculate 
cs_data_nonfor$gowerEnvDist <- gower_dist(s1Data, s2Data)
cs_data_nonfor$cubrtEnvDist<-cs_data_nonfor$gowerEnvDist^(1/3)
    
# output -----------------------------------------------------------------
saveRDS(cs_data_for, file = paste0(outputDir2,"cs_forest.rds"))
saveRDS(cs_data_nonfor, file = paste0(outputDir2,"cs_nonforest.rds"))