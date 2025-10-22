  # Estimate model and coefficients
  # Model estimation is mainly based on tutrial
  # Coefficients estimation and output are mainly based on Leclre et al 2020

# load packages -------------------------------------------------------
#library(Matrix)
library(lme4)
library(car)
library(dplyr)
library(foreach)
library(doParallel)
#options(na.action = "na.fail") # to use MuMIn package
options(encoding = "utf-8")

# Swithces 
# -- Settings from shell script
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
# Project name
PRJ <- args[1]
cat("Projcet name is", PRJ, "\n")
# RCP scenario for EnvDist data
Climate_sce <- args[2]
cat("Climate_sce is", Climate_sce, "\n")
# HPD Scenario name
HPD_sce <- args[3]
cat("HPD scenario name is", HPD_sce, "\n")


# -- Other settings
# Parallel cores
multiprocesscores <- future::availableCores() -1
cat("Multiprocess core number is ",multiprocesscores,"\n")
registerDoParallel(cores = multiprocesscores)

# directory settings from directroyPathList
directoryPathList <- read.csv("../output/txt/PREDICTSDirectoryPath.csv")
dataDir <- directoryPathList$dataDir
outputDir <- directoryPathList$outputDir
landuseDir <- directoryPathList$landuseDir
SharedDataDir <- directoryPathList$SharedDataDir

# input your output directory path
coefOutputDir <- paste0(outputDir,"coefficients/",PRJ,"/")

if(!dir.exists(coefOutputDir))dir.create(coefOutputDir)
if(!dir.exists(paste0(coefOutputDir,'Coef_grid')))dir.create(paste0(coefOutputDir,'Coef_grid'))

# input pass to BII_coefs.csv
coefsAreaPropFileName <- paste0(dataDir,'coefficients/HPD/BII_coefs.csv')
LUClass_propdata <- read.csv(coefsAreaPropFileName)

# Calculation year
if (Climate_sce != 'none'){
  calYear <- c(2005,2010,2030,2050,2070,2090)
} else {
  calYear <- c(2005,seq(2010,2100,10))
}
cat("output", calYear,"\n")

# data loading --------------------------------------------------------
  
TotalAbundance <- readRDS(paste(outputDir,"processedData/biodiversityIndex/TotalAbundance.rds",sep = ""))
CompositionalSimilarity <- readRDS(paste(outputDir,"processedData/biodiversityIndex/CompositionalSimilarity.rds", sep = ""))

HPD_grid <- read.csv(paste(outputDir,"processedData/inputVariables/HPD/HPD_grid.csv",sep = "")) 
LonLat_gridid <- read.csv(paste(dataDir,"supplementary/LonLat_gridid.csv",sep = ""))
EnvDist_future <- read.csv(paste(outputDir,"processedData/inputVariables/EnvDist/cubrtEnvDist_values_SceYear_Wldclim.csv", sep = "")) %>% 
  dplyr::select(-c('X'))
colnames(EnvDist_future) <- c("longitude_rev", "latitude_rev", "cubrtEnvDist", "id")

#EnvDist_future$id <- gsub(pattern = paste(Climate_sce), replacement = paste(Scenario), EnvDist_future$id)
EnvDist_future$id <- gsub(pattern = "2021-2040", replacement = "2030", EnvDist_future$id)
EnvDist_future$id <- gsub(pattern = "2041-2060", replacement = "2050", EnvDist_future$id)
EnvDist_future$id <- gsub(pattern = "2061-2080", replacement = "2070", EnvDist_future$id)
EnvDist_future$id <- gsub(pattern = "2081-2100", replacement = "2090", EnvDist_future$id)

# Estimate Random mixed models --------------------------------------
# Total Abundance
print('Estimating Random mixed models')
print('Estimating Total Abundance model')
# run a simple model
TotalAbundance <- TotalAbundance %>% 
mutate(log10hpd_SSBS = log10(Human_pop_density + 1)) %>% 
mutate(log10hpd_SS = log10(Hpd_mean + 1)) %>% 
filter(!is.na(log10hpd_SS))

#ab_m <- lmer(sqrt(RescaledAbundance) ~ LandUse + LandUse*log10hpd_SS + LandUse*log10hpd_SSBS  + (1|SS) + (1|SSB), data = TotalAbundance)
# ab_m <- lmer(sqrt(RescaledAbundance) ~ LandUse + log10hpd_SS + LandUse*log10hpd_SSBS  + (1|SS) + (1|SSB), data = TotalAbundance)
# print(summary(ab_m), correlation=TRUE)
# 
# Res_ab <- MuMIn::dredge(ab_m, rank = "AIC")

# bestmodel
#ab_m_selected <- lmer(sqrt(RescaledAbundance) ~ LandUse + log10hpd_SS + LandUse*log10hpd_SSBS  + (1|SS) + (1|SSB), data = TotalAbundance)
ab_m_selected <- lmer(sqrt(RescaledAbundance) ~ LandUse + LandUse*log10hpd_SSBS  + (1|SS) + (1|SSB), data = TotalAbundance)

print(summary(ab_m_selected), correlation=TRUE)

# get r2 
#r.squaredGLMM(ab_m_selected)

# # VIF
# tmp <- vif(ab_m_selected) %>% 
#   as.data.frame() %>% 
#   write.csv(paste(outputDir,"/Analysis/Regression/csv/Abundance-model-VIF.csv",sep = "")) 

# # get model summary   
# tmp <- report(ab_m_selected) %>% 
#   as.data.frame() %>% 
#   write.csv(paste(outputDir,"/Analysis/Regression/csv/Abundance-model.csv",sep = "")) 
# tmp2 <- sqrt(diag(vcov(ab_m_selected))) %>% 
#   as.data.frame() %>% 
#   write.csv(paste(outputDir,"/Analysis/Regression/csv/Abundance-model_stdError.csv",sep = "")) 

# Compositional Similarity
print('Estimating Compositional Similarity model')

CompositionalSimilarity <- CompositionalSimilarity %>% 
  # logit transform the compositional similarity
  mutate(logitCS = logit(CS_index, adjust = 0.001, percents = FALSE)) %>%
  # log10 transform the geographic distance between sites
  mutate(log10geo = log10(geog_dist + 1)) %>%
  # add hpd related variables
  mutate(log10hpd_mean = log10(Hpd_mean +1)) %>% 
  mutate( 
    log10hpd_diff =    case_when(
      Hpd_diff<0 ~ (log10(abs(Hpd_diff) + 1))*(-1),
      Hpd_diff>=0 ~ log10(abs(Hpd_diff) + 1))) %>% 
  mutate(log10hpd_s2 = log10(s2_hpd +1)) %>% 
  # make primary minimal-primary minimal the baseline again
  mutate(lu_contrast = factor(lu_contrast), 
          lu_contrast = relevel(lu_contrast, ref = "Primary vegetation Minimal use_vs_Primary vegetation Minimal use")) %>% 
  mutate(logEnvDist = log(gowerEnvDist+1)) %>% 
  filter(!is.na(logitCS)) %>% 
  filter(!is.na(log10geo)) %>% 
  filter(!is.na(log10hpd_mean)) %>% 
  filter(!is.na(cubrtEnvDist))

# Res_cs_for_2 <- MuMIn::dredge(cs_m_selected, rank = "AIC")

cs_m_selected <- lmer(logitCS ~ lu_contrast + log10geo + cubrtEnvDist + log10hpd_diff + log10hpd_s2 + lu_contrast:cubrtEnvDist + lu_contrast:log10geo + lu_contrast:log10hpd_s2 + (1|SS) + (1|s2), data = CompositionalSimilarity) 

print(summary(cs_m_selected), correlation=TRUE)

# get r2 
#r.squaredGLMM(cs_m_selected)

# # VIF
# tmp <- vif(cs_m_selected) %>% 
#   as.data.frame() %>% 
#   write.csv(paste(outputDir,"/Analysis/Regression/csv/Similairity-model2-VIF.csv",sep = "")) 

# # get model summary   
# tmp <- report(cs_m_selected) %>% 
#   as.data.frame() %>% 
#   write.csv(paste(outputDir,"/Analysis/Regression/csv/Similairity-model2.csv",sep = "")) 
# tmp2 <- sqrt(diag(vcov(cs_m_selected))) %>% 
#   as.data.frame() %>% 
#   write.csv(paste(outputDir,"/Analysis/Regression/csv/Similairity-model2_stdError.csv",sep = ""))  

# Derive coefficients from models -----------------------------------------------
# Derive Ab coefficients from Mix model
Ab.coef <- data.frame(LandUse = levels(TotalAbundance$LandUse), log10hpd_SSBS = 0) %>% 
  mutate(Ab.coef = predict(ab_m_selected, . , re.form = NA) ^2)
baseline.ab <- Ab.coef[1,ncol(Ab.coef)]
Ab.coef$Ab.coef <- Ab.coef$Ab.coef/baseline.ab

# Derive Ab coefficients from Mix model
# prepare a function for inversing logit 
inv_logit <- function(f, a){
  a <- (1-2*a)
  (a*(1+exp(f))+(exp(f)-1))/(2*a*(1+exp(f)))
}

# then get CompositionalSimilarity coefficients
Cs.coef <- data.frame(lu_contrast = levels(CompositionalSimilarity$lu_contrast), log10geo = 0, cubrtEnvDist = 0, log10hpd_mean = 0, log10hpd_diff = 0, log10hpd_s2 = 0) %>% 
  mutate(Cs.coef = predict(cs_m_selected, ., re.form = NA) %>% 
  inv_logit(a = 0.001))

baseline.cs<- Cs.coef[1,ncol(Cs.coef)]
Cs.coef$Cs.coef <- Cs.coef$Cs.coef/baseline.cs

# Process dataframe to make next flow easier
Cs.coef$lu_contrast <- gsub(pattern = "Primary vegetation Minimal use_vs_",replacement = "", Cs.coef$lu_contrast)
Cs.coef <- dplyr::select(Cs.coef, lu_contrast, Cs.coef) %>% 
  rename("LandUse" = lu_contrast)
  
# Multiply coefficients and estimate final one 
# Bind two dataframes and multiply Ab and Cs
Coefficients_wo_variables <- inner_join(Ab.coef, Cs.coef, by = "LandUse") %>% 
  mutate(Finalcoefs = Ab.coef * Cs.coef)

# Write coefficients to file containing propotions
LUClass_propdata <- read.csv(coefsAreaPropFileName)
LUClass_propdata$BII<-NaN
LUClass_propdata$BII[grep("Cropland", LUClass_propdata$refinedLUclass)]<-Coefficients_wo_variables$Finalcoefs[grep("Cropland",Coefficients_wo_variables$LandUse)][[1]]
LUClass_propdata$BII[grep("Pasture",LUClass_propdata$refinedLUclass)]<-Coefficients_wo_variables$Finalcoefs[grep("Pasture",Coefficients_wo_variables$LandUse)][[1]]
LUClass_propdata$BII[grep("Secondary vegetation Minimal",LUClass_propdata$refinedLUclass)]<-Coefficients_wo_variables$Finalcoefs[grep("Secondary vegetation Minimal use",Coefficients_wo_variables$LandUse)][[1]]
LUClass_propdata$BII[grep("and Timber",LUClass_propdata$refinedLUclass)]<-Coefficients_wo_variables$Finalcoefs[grep("and Timber",Coefficients_wo_variables$LandUse)][[1]]
LUClass_propdata$BII[grep("Primary vegetation",LUClass_propdata$refinedLUclass)]<-Coefficients_wo_variables$Finalcoefs[grep("Primary vegetation",Coefficients_wo_variables$LandUse)][[1]]
LUClass_propdata$BII[grep("Primary vegetation Minimal",LUClass_propdata$refinedLUclass)]<-1
LUClass_propdata$BII[grep("Urban",LUClass_propdata$refinedLUclass)]<-Coefficients_wo_variables$Finalcoefs[grep("Urban",Coefficients_wo_variables$LandUse)][[1]]
write.csv(LUClass_propdata, file = paste0(coefOutputDir,'BII_coefs.csv'))

# Get coefficients for each grid -------------------------------------------
for (cur_year in unique(calYear)) {
  print(cur_year)
  # temporary process because there are no Human pop density grid data in 2005
  if(cur_year == 2005) {
    cur_hpd_sce_year <- paste(HPD_sce,2010, sep = "_")
  } else {
    cur_hpd_sce_year <- paste(HPD_sce,cur_year, sep = "_")
  }
  
  print(paste("Current Human pop density data is ",cur_hpd_sce_year))
  cur_Climate_sce_year <- paste(Climate_sce,cur_year, sep = "_")
  print(paste("Current Climate data is ",cur_Climate_sce_year))

  # HPD and EnvDist data processing  
  HPD_grid_sceyear <- HPD_grid %>% 
    filter(id == cur_hpd_sce_year) %>% 
    dplyr::select(-c('id','Syr','ssp','populationSSP_update'))
  
  EnvDist_future_sceyear <- EnvDist_future %>% 
    filter(id == cur_Climate_sce_year) 
  
  Variables_grid_process_sceyear <- LonLat_gridid %>% 
    left_join(HPD_grid_sceyear, by = c("lon"="longitude_rev", "lat"= "latitude_rev")) %>% 
    left_join(EnvDist_future_sceyear, by = c("lon" = "longitude_rev", "lat" = "latitude_rev")) 
  Variables_grid_process_sceyear$Human_pop_density[is.na(Variables_grid_process_sceyear$Human_pop_density)] <- 0
  Variables_grid_process_sceyear <- Variables_grid_process_sceyear %>%  
    mutate(log10hpd = log10(Human_pop_density + 1))
  
  # Explain variable (Continuos) settings
  grid_variables_other <- data.frame(Grid_ID = Variables_grid_process_sceyear$Grid_ID, lon = Variables_grid_process_sceyear$lon, lat = Variables_grid_process_sceyear$lat) %>% 
    mutate(log10hpd_mean = 0 ) %>% 
    mutate(log10geo = 0) 
  grid_variables_other$log10hpd_SSBS <- Variables_grid_process_sceyear$log10hpd
  grid_variables_other$log10hpd_diff <- Variables_grid_process_sceyear$log10hpd
  grid_variables_other$log10hpd_s2 <- Variables_grid_process_sceyear$log10hpd

  if (!(cur_year %in% c(2030, 2050, 2070, 2090)) || Climate_sce == 'none'){
    grid_variables_other$cubrtEnvDist <- 0
  } else {
    grid_variables_other$cubrtEnvDist <- Variables_grid_process_sceyear$cubrtEnvDist
  }
  
#---- Run model -------------------------------------------------------------  
  # Toatal Abundance model
  
  print("Now Running Total Abundance model")
  
  # Explain variables (Landuse contrast) settings  
  grid_variables_lu_ab <- expand.grid(Grid_ID = Variables_grid_process_sceyear$Grid_ID, LandUse = unique(TotalAbundance$LandUse))
  grid_coefficients_ab <- grid_variables_lu_ab %>% 
    left_join(grid_variables_other, by = "Grid_ID") 
  grid_coefficients_ab <- grid_coefficients_ab[order(grid_coefficients_ab$Grid_ID, decreasing = FALSE), ]
  
  # Prallel calculation of model coefficients 
  Ab.coefs <- foreach (cur_grid_id = unique(grid_coefficients_ab$Grid_ID),  
                        .combine = 'c',
                        .packages = 'dplyr') %dopar% {
    #print(paste(cur_grid_id))
    grid_variables <- grid_coefficients_ab %>% 
      filter(Grid_ID == cur_grid_id) 
    Ab.coef <- (Ab.coef = predict(ab_m_selected, grid_variables , re.form = NA) ^2)
    Ab.coef/baseline.ab
  }
  
  grid_coefficients_ab$Ab.coef <- Ab.coefs
  
  # Compositional Similarity model
  
  print("Now Running Compositional Similarity model")
  
  # Explain variables (Landuse contrast) settings  
  grid_variables_lu_cs <- expand.grid(Grid_ID = Variables_grid_process_sceyear$Grid_ID, lu_contrast = unique(CompositionalSimilarity$lu_contrast))
  grid_coefficients_cs <- grid_variables_lu_cs %>% 
    left_join(grid_variables_other, by = "Grid_ID") 
  grid_coefficients_cs <- grid_coefficients_cs[order(grid_coefficients_cs$Grid_ID, decreasing = FALSE), ]  
  
  # Parallel calculation of model coefficients 
  Cs.coefs <- foreach (cur_grid_id = unique(grid_coefficients_cs$Grid_ID), .combine = 'c') %dopar% {
    #print(paste(cur_grid_id))
    grid_variables <- grid_coefficients_cs %>% 
      filter(Grid_ID == cur_grid_id) 
    Cs.coef <- inv_logit(predict(cs_m_selected, grid_variables, re.form = NA), a = 0.001)  
    Cs.coef/baseline.cs
  }
  
  grid_coefficients_cs$Cs.coef <- Cs.coefs
  
  # Data processing   
  grid_coefficients_cs$lu_contrast <- gsub("Primary vegetation Minimal use_vs_", "" , grid_coefficients_cs$lu_contrast)
  
  grid_coefficients_cs <- grid_coefficients_cs %>% 
    rename("LandUse" = lu_contrast) %>% 
    dplyr::select(c(Grid_ID,LandUse,Cs.coef))
  
  # Merge Both model coefficients
  grid_coefficients <- grid_coefficients_ab %>% 
    left_join(grid_coefficients_cs, by = c("Grid_ID","LandUse")) %>% 
    mutate(Finalcoefs = Ab.coef * Cs.coef)  
  
# -- grid coefficients process 
  print("Now Processing Coefficients")
  
  # Prepare dataframe  
  grid_coefficients_all_output <- foreach (cur_grid_id = unique(grid_coefficients$Grid_ID),
                                          .combine = 'rbind') %dopar% {
                                            grid_coefficients_each <- grid_coefficients %>% 
                                              filter(Grid_ID == cur_grid_id)
                                            
                                            # Write coefficients to file containing propotions
                                            LUClass_propdata2<-read.csv(coefsAreaPropFileName)
                                            LUClass_propdata2$BII<-NaN
                                            LUClass_propdata2$BII[grep("Cropland", LUClass_propdata2$refinedLUclass)]<-grid_coefficients_each$Finalcoefs[grep("Cropland",grid_coefficients_each$LandUse)][[1]]
                                            LUClass_propdata2$BII[grep("Pasture",LUClass_propdata2$refinedLUclass)]<-grid_coefficients_each$Finalcoefs[grep("Pasture",grid_coefficients_each$LandUse)][[1]]
                                            LUClass_propdata2$BII[grep("Secondary vegetation Minimal",LUClass_propdata2$refinedLUclass)]<-grid_coefficients_each$Finalcoefs[grep("Secondary vegetation Minimal use",grid_coefficients_each$LandUse)][[1]]
                                            LUClass_propdata2$BII[grep("and Timber",LUClass_propdata2$refinedLUclass)]<-grid_coefficients_each$Finalcoefs[grep("and Timber",grid_coefficients_each$LandUse)][[1]]
                                            LUClass_propdata2$BII[grep("Primary vegetation",LUClass_propdata2$refinedLUclass)]<-grid_coefficients_each$Finalcoefs[grep("Primary vegetation",grid_coefficients_each$LandUse)][[1]]
                                            LUClass_propdata2$BII[grep("Primary vegetation Minimal",LUClass_propdata2$refinedLUclass)]<-1
                                            LUClass_propdata2$BII[grep("Urban",LUClass_propdata2$refinedLUclass)]<-grid_coefficients_each$Finalcoefs[grep("Urban",grid_coefficients_each$LandUse)][[1]]
                                            
                                            LUClass_propdata2 <- LUClass_propdata2 %>% 
                                              mutate(Grid_ID = cur_grid_id) %>%   
                                              left_join(LonLat_gridid, by = "Grid_ID")
                                            
                                            return(LUClass_propdata2)
                                          }
  
  # Export    
  write.csv(grid_coefficients_all_output, paste0(coefOutputDir,"Coef_grid/Coef_eachgrid_climate_",Climate_sce,"_",cur_year,"_",PRJ,".csv"))
  
}  

