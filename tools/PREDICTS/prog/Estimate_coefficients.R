　# Estimate model and coefficients
  # Model estimation is mainly based on tutrial
  # Coefficients estimation and output are mainly based on BTC

#--------- load packages -------------------------------------------------------
  library(Matrix)
  library(lme4)
  library(car)
  library(dplyr)

#--------- Swithces ------------------------------------------------------------
  CS_index <- "JacAbSym"

  print(paste("CS_index is",CS_index))

  Args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments

  Parent_dir <- Args
  print(Parent_dir)
  
  Envdist <- TRUE # TRUE or FALSE
#--------- data loading --------------------------------------------------------
  forsitedata_ab <- readRDS(paste('../',Parent_dir,'/tools/PREDICTS/data/ab_forest.rds',sep = ""))
  nonforsitedata_ab <- readRDS(paste('../',Parent_dir,'/tools/PREDICTS/data/ab_nonforest.rds',sep = ""))
  forsitedata_cs <- readRDS(paste('../',Parent_dir,'/tools/PREDICTS/data/cs_forest.rds',sep = ""))
  nonforsitedata_cs <- readRDS(paste('../',Parent_dir,'/tools/PREDICTS/data/cs_nonforest.rds',sep = ""))
    
#--------- Calculate Forest Random mixed models -------------------------------------------------
  #--------- Estimate Random mixed models ----------------------------------------
  # Total Abundance
    # run a simple model
    ab_m_for <- lmer(sqrt(RescaledAbundance) ~ LandUse + (1|SS) + (1|SSB), data = forsitedata_ab)
    print(summary(ab_m_for), correlation = TRUE) 
  
  # Compositional Similarity
    forsitedata_cs <- forsitedata_cs %>%       
      # logit transform the compositional similarity
      mutate(logitCS = logit(CS_index, adjust = 0.001, percents = FALSE)) %>%      
      # log10 transform the geographic distance between sites
      mutate(log10geo = log10(geog_dist + 1)) %>%      
      # make primary minimal-primary minimal the baseline again
      mutate(lu_contrast = factor(lu_contrast), 
            lu_contrast = relevel(lu_contrast, ref = "Primary vegetation Minimal use_vs_Primary vegetation Minimal use"))    
    
    # Model compositional similarity as a function of the land-use contrast and the geographic distance between sites
    cs_m_for <- lmer(logitCS ~ lu_contrast + log10geo + cubrtEnvDist + (1|SS) + (1|s2), data = forsitedata_cs)
    print(summary(cs_m_for), correlation = TRUE) 

  #--------- Derive coefficients from models -----------------------------------------------
  # Derive Ab coefficients from Mix model
    Ab.coefs.for <- data.frame(LandUse = levels(forsitedata_ab$LandUse)) %>% 
      mutate(Ab.coef = predict(ab_m_for, . , re.form = NA) ^2)
    baseline.ab <- Ab.coefs.for[1,2]
    Ab.coefs.for$Ab.coef <- Ab.coefs.for$Ab.coef/baseline.ab
    
  # Derive Ab coefficients from Mix model
    # prepare a function for inversing logit 
    inv_logit <- function(f, a){
      a <- (1-2*a)
      (a*(1+exp(f))+(exp(f)-1))/(2*a*(1+exp(f)))
    }
    
    # then get CompositionalSimilarity coefficients
    Cs.coefs.for <- data.frame(lu_contrast = levels(forsitedata_cs$lu_contrast), log10geo = 0, cubrtEnvDist = 0) %>% 
      mutate(Cs.coef = predict(cs_m_for, ., re.form = NA) %>% 
      inv_logit(a = 0.001))
    
    baseline.cs<- Cs.coefs.for[1,4]
    Cs.coefs.for$Cs.coef <- Cs.coefs.for$Cs.coef/baseline.cs
    
    # Process dataframe to make next flow easier
    Cs.coefs.for$lu_contrast <- gsub("Primary vegetation Minimal use_vs_", "" , Cs.coefs.for$lu_contrast)
    Cs.coefs.for <- dplyr::select(Cs.coefs.for, -log10geo, -cubrtEnvDist) %>% 
      rename("LandUse" = lu_contrast)
      
  #-------- Multiply coefficients and estimate final one -------------------------
  # Bind two dataframes and multiply Ab and Cs
    Coefs.forest <- inner_join(Ab.coefs.for, Cs.coefs.for, by = "LandUse") %>% 
      mutate(Finalcoefs = Ab.coef * Cs.coef)
  
  # Write coefficients to file containing propotions
    LUClass_propdata<-read.csv(paste('../',Parent_dir,'/tools/PREDICTS/data/BII_coefs.csv',sep = ""))
    LUClass_propdata$BII<-NaN
    LUClass_propdata$BII[grep("Forested Annual", LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Annual_nitrogen",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested Perennial",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Perennial",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested pasture",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Pasture",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested Primary Minimal use",LUClass_propdata$refinedLUclass)]<-1
    LUClass_propdata$BII[grep("Forested Mature secondary vegetation",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Mature secondary vegetation Minimal use",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested Primary vegetation",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Primary vegetation",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested Timber",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Secondary vegetation and Timber Light and Intense",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested Young secondary",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Young secondary vegetation Minimal use",Coefs.forest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Forested Urban",LUClass_propdata$refinedLUclass)]<-Coefs.forest$Finalcoefs[grep("Urban",Coefs.forest$LandUse)][[1]]


#--------- Calculate Non-Forest Random mixed models ----------------------------------------
  # Total Abundance
    # run a simple model
    ab_m_nonfor <- lmer(sqrt(RescaledAbundance) ~ LandUse + (1|SS) + (1|SSB), data = nonforsitedata_ab)
    print(summary(ab_m_nonfor), correlation = TRUE) 
  
  # Compositional Similarity
    nonforsitedata_cs <- nonforsitedata_cs %>%       
      # logit transform the compositional similarity
      mutate(logitCS = logit(CS_index, adjust = 0.001, percents = FALSE)) %>%      
      # log10 transform the geographic distance between sites
      mutate(log10geo = log10(geog_dist + 1)) %>%      
      # make primary minimal-primary minimal the baseline again
      mutate(lu_contrast = factor(lu_contrast), 
            lu_contrast = relevel(lu_contrast, ref = "Primary vegetation Minimal use_vs_Primary vegetation Minimal use"))   
    
    # Model compositional similarity as a function of the land-use contrast and the geographic distance between sites
    cs_m_nonfor <- lmer(logitCS ~ lu_contrast + log10geo + cubrtEnvDist + (1|SS) + (1|s2), data = nonforsitedata_cs)
    print(summary(cs_m_for), correlation = TRUE) 

  #--------- Derive coefficients from models -----------------------------------------------
  # Derive Ab coefficients from Mix model
    Ab.coefs.nonfor <- data.frame(LandUse = levels(nonforsitedata_ab$LandUse)) %>% 
      mutate(Ab.coef = predict(ab_m_nonfor, . , re.form = NA) ^2)
    baseline.ab <- Ab.coefs.nonfor[1,2]
    Ab.coefs.nonfor$Ab.coef <- Ab.coefs.nonfor$Ab.coef/baseline.ab
    
  # Derive Ab coefficients from Mix model
    # prepare a function for inversing logit 
    inv_logit <- function(f, a){
      a <- (1-2*a)
      (a*(1+exp(f))+(exp(f)-1))/(2*a*(1+exp(f)))
    }
    
    # then get CompositionalSimilarity coefficients
    Cs.coefs.nonfor <- data.frame(lu_contrast = levels(nonforsitedata_cs$lu_contrast), log10geo = 0, cubrtEnvDist = 0) %>% 
      mutate(Cs.coef = predict(cs_m_nonfor, ., re.form = NA) %>% 
      inv_logit(a = 0.001))
    
    baseline.cs<- Cs.coefs.nonfor[1,4]
    Cs.coefs.nonfor$Cs.coef <- Cs.coefs.nonfor$Cs.coef/baseline.cs
    
    # Process dataframe to make next flow easier
    Cs.coefs.nonfor$lu_contrast <- gsub("Primary vegetation Minimal use_vs_", "" , Cs.coefs.nonfor$lu_contrast)
    Cs.coefs.nonfor <- dplyr::select(Cs.coefs.nonfor, -log10geo, -cubrtEnvDist) %>% 
      rename("LandUse" = lu_contrast)
      
  #-------- Multiply coefficients and estimate final one -------------------------
  # Bind two dataframes and multiply Ab and Cs
    Coefs.nonforest <- inner_join(Ab.coefs.nonfor, Cs.coefs.nonfor, by = "LandUse") %>% 
      mutate(Finalcoefs = Ab.coef * Cs.coef)
  
  
  #-------- Derive more specific models for detailed LU classification in Secondary vegetation---------------------------------------------
   # Make a new dataframe
   # Abundance
    nonforsitedata_ab_sec <- nonforsitedata_ab %>% 
      filter(LandUse != "Secondary vegetation Minimal use") %>% 
      droplevels()

    Sec <- nonforsitedata_ab %>% 
      filter(LandUse == "Secondary vegetation Minimal use") %>% 
      mutate(LandUse = paste(LandUse_original,Use_intensity))
    
    nonforsitedata_ab_sec <- rbind(nonforsitedata_ab_sec, Sec)
    
    nonforsitedata_ab_sec$LandUse<-as.factor(nonforsitedata_ab_sec$LandUse)
    nonforsitedata_ab_sec$LandUse<-relevel(nonforsitedata_ab_sec$LandUse,"Primary vegetation Minimal use") 
  
  # Derive abundance model
    ab_m_nonforsec <- lmer(sqrt(RescaledAbundance) ~ LandUse + (1|SS) + (1|SSB), data = nonforsitedata_ab_sec)

  # Make dataset 
    Ab.coefs.nonforsec <- data.frame(LandUse = levels(nonforsitedata_ab_sec$LandUse)) %>% 
       mutate(Ab.coef = predict(ab_m_nonforsec, . , re.form = NA) ^2)
    baseline.absec <- Ab.coefs.nonforsec[1,2]
    Ab.coefs.nonforsec$Ab.coef <- Ab.coefs.nonforsec$Ab.coef/baseline.absec

  # Derive coefficients of Mature secondary vegetation minimal use
    MsecM2 <- Ab.coefs.nonforsec %>%
        filter(LandUse == "Mature secondary vegetation Minimal use") 
    MsecM <- data.frame()
    MsecM <- Coefs.nonforest %>% 
      filter(LandUse == "Mature secondary vegetation") 
    MsecM[1, "LandUse"] <- c("Mature secondary vegetation Minimal use")
    MsecM[1, "Ab.coef"] <- MsecM2[1, 2]
    MsecM[1, "Finalcoefs"] <- MsecM[1, "Ab.coef"] * MsecM[1, "Cs.coef"]
  
  # Merge datasets  
    Coefs.nonforest <- rbind(Coefs.nonforest, MsecM)


  # Write coefficients to file containing propotions
    LUClass_propdata$BII[grep("Non-forested Annual", LUClass_propdata$refinedLUclass)]<-Coefs.nonforest$Finalcoefs[grep("Annual_nitrogen",Coefs.nonforest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Non-forested Perennial",LUClass_propdata$refinedLUclass)]<-Coefs.nonforest$Finalcoefs[grep("Perennial",Coefs.nonforest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Non-forested pasture",LUClass_propdata$refinedLUclass)]<-Coefs.nonforest$Finalcoefs[grep("Pasture",Coefs.nonforest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Non-forested Primary Minimal use",LUClass_propdata$refinedLUclass)]<-1
    LUClass_propdata$BII[grep("all ages",LUClass_propdata$refinedLUclass)]<-Coefs.nonforest$Finalcoefs[grep("Secondary vegetation Minimal use",Coefs.nonforest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Non-forested Urban",LUClass_propdata$refinedLUclass)]<-Coefs.nonforest$Finalcoefs[grep("Urban",Coefs.nonforest$LandUse)][[1]]
    LUClass_propdata$BII[grep("Non-forested Mature secondary vegetation Minimal use",LUClass_propdata$refinedLUclass)]<-Coefs.nonforest$Finalcoefs[grep("Mature secondary vegetation Minimal use",Coefs.nonforest$LandUse)][[1]]
  
  #csv output
    write.csv(paste('../',Parent_dir,'/tools/PREDICTS/data/BII_coefs.csv',sep = ""))
    