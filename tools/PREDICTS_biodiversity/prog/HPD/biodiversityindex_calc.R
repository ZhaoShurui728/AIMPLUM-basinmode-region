# comments

# load packages and settings ----------------------------------------------

library(dplyr) # for easy data manipulation
library(tidyr) # ditto
library(geosphere) # calculating geographic distance between sites
library(gower) # for calc gower's environmentarl distance
library(purrr) # running loops
library(furrr) # running loops in parallel
library(data.table)

# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir

outputDir2 <- paste0(outputDir,'processedData/biodiversityIndex')
if(!dir.exists(outputDir2))dir.create(outputDir2)

# switch
CS_index_name <- "JacAbSym"

multiprocesscores <- future::availableCores() -1
cat("multiprocess core number is ",multiprocesscores,"\n")

# data processing ---------------------------------------------------------
print('database processing, mainly redefine land use classes')

# loading PREDICTS database 
database <- readRDS(paste0(outputDir,"processedData/PREDICTSdatabase/database.rds"))
# loading plantation SSBS LandUse map
plantation_map <- read.csv(file = paste0(dataDir,'supplementary/Plantation_SSBS_LUclass_map.csv')) 
#  process
plantation_Cropland <- plantation_map %>% 
  filter(LandUse %in% c('Perennial','Annual_nitrogen'))
plantation_SVTim <- plantation_map %>% 
  filter(LandUse %in% c('Secondary vegetation and Timber Light and Intense','Timber'))

# redefine landuse class 
# Raw PREDICTS database data
database_processed <- database %>%
  # make a level of Primary minimal. Everything else gets the coarse land use
  mutate(
    LandUse = ifelse(Predominant_land_use == "Primary vegetation" & Use_intensity == "Minimal use","Primary vegetation Minimal use",paste(Predominant_land_use)),
    # change cannot decide into NA
    LandUse = ifelse(Predominant_land_use == "Cannot decide", NA, paste(LandUse))) %>% 
  filter(!is.na(LandUse)) %>%
  mutate(
    # divide Plantation forest into Timber and Perennial crop
    LandUse = ifelse(SSBS %in% plantation_Cropland$SSBS, "Cropland", paste(LandUse)),
    LandUse = ifelse(SSBS %in% plantation_SVTim$SSBS, "Secondary vegetation and Timber", paste(LandUse)),
    # Process secondary vegetation
    LandUse = ifelse(grepl("secondary", tolower(LandUse)),"Secondary vegetation and Timber",paste(LandUse)),
    # Process secondary vegetation
    LandUse = ifelse(grepl("Secondary", LandUse) & Use_intensity == "Minimal use","Secondary vegetation Minimal use",paste(LandUse))) %>% 
  # remove plantation forest which can't devide into cropland or Timber 
  filter(LandUse != 'Plantation forest') %>% 
  mutate(
    # relevel the factor so that Primary minimal is the first level (so that it is the intercept term in models)
    LandUse = factor(LandUse),
    LandUse = relevel(LandUse, ref = "Primary vegetation Minimal use"))

# output --------------------------------------------
saveRDS(database_processed, paste0(outputDir,"processedData/PREDICTSdatabase/database.rds"))

database <- readRDS(paste0(outputDir,"processedData/PREDICTSdatabase/database.rds"))

# Calculate TotalAbundance----------------------------------------------------
print('Calculating biodiviersity indexes which would be objective variables when constructng regression models')
print('Calculating TotalAbundance')

# Calculate
database_abundance <- database %>%    
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
  # calculate SS mean hpd
  mutate(Hpd_mean = mean(Human_pop_density)) %>% 
  # ungroup
  ungroup() %>%    
  # now rescale total abundance, so that within each study, abundance varies from 0 to 1.
  mutate(RescaledAbundance = TotalAbundance/MaxAbundance) %>%   
  # select rows
  dplyr::select(RescaledAbundance, LandUse, Use_intensity,SS, SSB, SSBS,Longitude, Latitude, Human_pop_density, Hpd_mean)

# output 
  saveRDS(database_abundance, file = paste0(outputDir2,'/TotalAbundance.rds'))

#Calculate Compositional Similarity---------------------------------------------------------
print(paste("Calculating CompositionalSimilarity"))

#First processing
database_composition <- database %>% 
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
rem <- sum(database$Diversity_metric_type != "Abundance") 
print(paste("Removing", rem, "rows because their Diversity_metric_type is not Abundance")) 
rem <- sum(database_composition$n_sample_effort ==1) 
print(paste("Removing", rem, "rows because there are different sampling efforts in the same SS")) 
rem <- sum(database_composition$n_species <=1)
print(paste("Removing", rem, "rows because there aren't enough species numbers"))        
rem <- sum(database_composition$n_primin_records ==0) 
print(paste("Removing", rem, "rows because there aren't primin sites in the same SS")) 

database_composition <- database_composition %>%
  #now keep only the studies with one unique sampling effort
  filter(n_sample_effort == 1) %>%       
  #and keep only studies with more than one species
  #as these studies clearly aren't looking at assemblage-level diversity
  filter(n_species >1 ) %>%       
  #and keep only studies with at least some Primary vegetation Minimal use data
  filter(n_primin_records >0 ) %>%      
  #drop empty factor levels
  droplevels()

print(paste("Final data has", nrow(database_composition),"rows ; The number of Studies is", n_distinct(database_composition$SS), "; The number of Sites is", n_distinct(database_composition$SSBS)))
  
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

# get a vector of each study to loop over
studies <- database_composition %>%
  distinct(SS) %>%
  pull()

site_comparisons <- map_dfr(.x = studies, .f = function(x){
  # filter out the given study
  site_data <- filter(database_composition, SS == x) %>%
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
  site_comparisons <- expand.grid(baseline_sites, site_list) %>%        
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
  return(site_comparisons)
})

future::plan(multisession, workers = 4)

# expand future global object size to 600MB
options(future.globals.maxSize = 600*1034^2) 

# I'm using map2 (because there are two arguments I'm passing through - s1 and s2)
# and the map2_dbl because the output I want is a vector of numbers (double rather than integer format)
# so this function is going to go through each s1 and s2 in turn
# and pass them into the CS_index_name calculate function
CS_index <- future_map2_dbl(.x = site_comparisons$s1,
                            .y = site_comparisons$s2,
                            ~get_JacAbSym(s1 = .x, s2 = .y, data = database_composition))

# stop running things in parallel for now
future::plan(sequential)

# for the other required information, we don't need to run loops
latlongs <- database_composition %>%
  # for each site in the dataset
  group_by(SSBS) %>%
  # pull out the lat and long
  summarise(Lat = unique(Latitude),
            Long = unique(Longitude))

lus <- database_composition %>%
  # for each site in the dataset
  group_by(SSBS) %>%
  # pull out the land use
  summarise(lu = unique(LandUse))

# now let's put all the data together
cd_data <- site_comparisons %>%
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

# Add Human population density
hpd <- database_composition %>% 
  group_by(SSBS) %>% 
  summarise(hpd = unique(Human_pop_density))

cd_data <- cd_data %>%
  left_join(hpd, by = c("s1" = "SSBS")) %>% 
  rename(s1_hpd = hpd) %>% 
  left_join(hpd, by = c("s2" = "SSBS")) %>% 
  rename(s2_hpd = hpd) %>% 
  mutate(Hpd_diff = s2_hpd - s1_hpd) 

Hpd_mean <- database_composition %>% 
  group_by(SS) %>% 
  summarise(Hpd_mean = mean(Human_pop_density))

cd_data <- cd_data %>% 
  left_join(Hpd_mean, by = c("SS"))

# Add total abundance in s2
TA <- database_abundance %>% 
  dplyr::select(SSBS, RescaledAbundance)

cd_data <- cd_data %>% 
  left_join(TA, by = c("s2" = "SSBS")) %>% 
  rename(s1_totalabundance = RescaledAbundance) %>% 
  left_join(TA, by = c("s2" = "SSBS")) %>% 
  rename(s2_totalabundance = RescaledAbundance) 
  
# Calculate Envdist -------------------------------------------------------
print("Adding EnvDist")
# data prepare
forsites <- database_composition[!duplicated(database_composition$SSBS), ]
envVars = c("bio5","bio6","bio13","bio14","alt")
s1Data <- data.table(bio5 = forsites$bio5[match(cd_data$s1, forsites$SSBS)],
                     bio6 = forsites$bio6[match(cd_data$s1, forsites$SSBS)],
                     bio13 = forsites$bio13[match(cd_data$s1, forsites$SSBS)],
                     bio14 = forsites$bio14[match(cd_data$s1, forsites$SSBS)],
                     alt = forsites$alt[match(cd_data$s1, forsites$SSBS)])

s2Data <- data.table(bio5 = forsites$bio5[match(cd_data$s2, forsites$SSBS)],
                     bio6 = forsites$bio6[match(cd_data$s2, forsites$SSBS)],
                     bio13 = forsites$bio13[match(cd_data$s2, forsites$SSBS)],
                     bio14 = forsites$bio14[match(cd_data$s2, forsites$SSBS)],
                     alt = forsites$alt[match(cd_data$s2, forsites$SSBS)])
# calculate
cd_data$gowerEnvDist <- gower_dist(s1Data, s2Data)
cd_data$cubrtEnvDist <- cd_data$gowerEnvDist^(1/3)

# output 
saveRDS(cd_data, file = paste0(outputDir2,"/CompositionalSimilarity.rds"))
print("finish")
