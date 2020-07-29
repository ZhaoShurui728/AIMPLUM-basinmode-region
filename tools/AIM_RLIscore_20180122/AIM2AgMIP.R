gridsize0.5 <- fread("forConversion\\areamap.txt") %>% as.matrix()
gridsize2 <- fread("forConversion\\gridsize2.csv", stringsAsFactors = F)
countrygridAgMIP <- read.csv("forConversion\\countrygridAgMIP.csv") %>% as.matrix()
basegrid <- expand.grid(YEAR = c(2005, seq(2010, 2100, 10)), x = seq(1,360, 1), y =seq(1,720, 1)) 
  
AIMLUT <- c('share.CrpLnd', 'share.GrsLnd', 'share.NatLnd', 'share.MngFor', 'share.PriFor',
              'share.OagLnd', 'share.WetLnd', 'share.NotRel', 'share.RstLnd')


convertFun <- function(version){
  
  inputdir <- paste('AIMgdx\\', version, '\\', sep = '')
  outputdir <- paste("RLIscore_forAIM\\input_scenarios\\", version, '\\', sep = '')
  pdfdir <- paste('pdfOutput\\', version, '\\', sep = '')
  if(!dir.exists(pdfdir)) {dir.create(pdfdir)}
  if (!dir.exists(outputdir)) {dir.create(outputdir)}
  
  convertSingle <- function(gdxfilename){
    cat("\n")
    cat('------------------------------------------------------------------------')
	cat("\n")
	cat(format(Sys.time())); cat("  ")
	cat(paste('Convert', which(gdxfiles == gdxfilename), 'of', length(gdxfiles), 'GDX file', sep = ' ')); cat("  ")
    cat(paste('Scenario: ', gdxfilename, sep = ''))
	cat("\n")
    cat('------------------------------------------------------------------------')
	cat("\n")
    
    
    #gdxfilename <- 'SSP2_BaU_BIOD'
    gdx_file <- paste(inputdir, gdxfilename, '.gdx', sep = '')
    
    info <- gdxInfo(gdx_file, dump = F, returnList = T) 
   
    gdx <- rgdx.param(gdx_file, symName = info$parameters)  %>%
      killfactor() %>%
      filter(nchar(LU_RLI) == 12) %>% # used to filter out share.xx.to yy.
      mutate(Y = as.numeric(Y), I = as.numeric(I), J = as.numeric(J), 
             PRLIestimator = as.numeric(PRLIestimator)) 
     
    missingLUT <- setdiff(AIMLUT, unique(gdx$LU_RLI))
    
    # augment to fill the missing land use types to 0
    fill <- setNames(rep(list(interp(~0)),length(missingLUT)), missingLUT)
    
    scenario <- gdx %>%
      dcast( Y + I + J ~LU_RLI, value.var = "PRLIestimator") %>%
      NAer()   %>%
      rename(YEAR = Y, x = I, y = J)  %>%
      mutate_(.dots = fill) %>% # fill the missing land use types to 0
      mutate(share.NotRel = 1- (share.CrpLnd + share.GrsLnd + share.NatLnd + share.OagLnd + 
                                share.PriFor + share.MngFor + share.WetLnd + share.RstLnd)) %>%
      dplyr::select(x, y, YEAR, AIMLUT)
   
    grids <- merge(basegrid, scenario, by = c("YEAR", "x", "y"), all.x = T)
    
    t0 <- NULL
    
    for (yr in sort(unique(grids$YEAR))){
      #yr= 2005
	  cat("\n")
      cat(yr); cat("\n")
      pdf(paste(pdfdir, gdxfilename,'_',  yr, ".pdf", sep = ""), width = 12, height = 6)
      temp <- filter(grids, YEAR == yr)
      
      t1 <- NULL
      
      for(v in AIMLUT){
        cat(v); cat("   ")
        #v = "share.CrpLnd"
        #v = "share.GrsLnd"
        temp_cast <- temp %>%
          dplyr::select(x , y , v) %>%
          dcast(x ~ y, value.var =  v) %>%
          dplyr::select(-x) %>%
          as.matrix()
        
        t2 <- matrix(nrow = 90, ncol = 180)
    
        for(i in 1:90){
          for(j in 1:180){
            if(countrygridAgMIP[i,j] == 1){
              temp_0.5g <- temp_cast[(i*4-3):(i*4),(j*4-3):(j*4)]
              area_0.5g <- gridsize0.5[(i*4-3):(i*4),(j*4-3):(j*4)]
              area <- sum(temp_0.5g * area_0.5g, na.rm = T)
              areatot <- sum(area_0.5g[!is.na(temp_0.5g)])
              t2[i,j] <- ifelse(areatot == 0, 0, area/areatot)
            }
          }
        }
        row.names(t2) <- seq(89,-89,-2); colnames(t2) <- seq(-179, 179,2)
        tp <- melt(t2, value.name = v) %>% 
          filter(!is.na(.[,3])) %>% 
          rename(y = Var1, x = Var2)%>% 
          arrange(desc(y), x) %>%
          melt(id.vars = c('x', 'y')) %>%
          dplyr::select(x, y, variable, value)%>%
          killfactor()
        
        # export a map for verify, the left is the 0.5*0.5, right is the 2*2
        par(mfrow = c(1,2), oma = c(3,3,3,5))
        plot(raster(temp_cast, xmn = -180, xmx = 180, ymn = -90, ymx = 90), main = paste(yr, v, sep = " "))
        plot(raster(t2, xmn = -180, xmx = 180, ymn = -90, ymx = 90), main = "AgMIP resolution")
  
        tp_year <- cbind(ID_LUID = 1:4844, tp[,1:2], YEAR = yr, tp[,3:4], stringsAsFactors = F)
        
        t1 <- rbind(t1, tp_year)
      } 
      t1_cast <- dcast(t1,  ID_LUID + YEAR + x + y~ variable, value.var = 'value')%>% 
        arrange(desc(y), x) %>%
        merge(gridsize2, by = c('ID_LUID', 'x', 'y'))
      t0 <- rbind(t0, t1_cast)
      dev.off()
    }
    
    finaloutput <- t0 %>% 
      arrange(ID_LUID) %>%
      # keep the share sum in each grid to 1
      mutate(share.NotRel = 1- (share.CrpLnd + share.GrsLnd + share.NatLnd + share.OagLnd + 
             share.PriFor + share.MngFor + share.WetLnd + share.RstLnd)) %>%
      mutate(share.NotRel = ifelse(share.NotRel <0 ,0, share.NotRel)) %>%
      dplyr::select(ID_LUID, x, y, YEAR, AIMLUT, Area.1000ha)
    fwrite(finaloutput, paste(outputdir, gdxfilename, '.csv', sep = ''), row.names = F)
  }
  
  
  gdxfiles <- substr(list.files(inputdir),1, nchar(list.files(inputdir))-4)
  
  for (f in gdxfiles){
    convertSingle(f)
  }

}







