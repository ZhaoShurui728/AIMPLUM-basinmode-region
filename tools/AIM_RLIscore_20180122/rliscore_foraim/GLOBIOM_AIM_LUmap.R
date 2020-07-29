


glo <- fread('C:\\Users\\wwc\\Desktop\\inner_GLOBIOM_LUCC_sample_v3_scen1.csv')


aim <- fread('D:\\Dropbox\\To_Hasegawa\\20171222bend\\AIM\\RLIscore_forAIM\\input_scenarios\\SSP1p_20W_SPA1_BI3G.csv')

torast <- function(yr){
  glo_yr <- glo %>% 
    dplyr::filter(YEAR==yr)
  
  aim_yr <- aim %>% 
    dplyr::filter(YEAR==yr)
  
  basegrid <- expand.grid(x = seq(-179,179, 2), y =seq(89, -89, -2))
  LUTs <- c("share.CrpLnd", "share.GrsLnd", "share.NatLnd", "share.MngFor",
            "share.PriFor", "share.OagLnd", "share.WetLnd", "share.NotRel",
            "share.RstLnd")
  
  obj <- paste('rs',yr, 1:9, sep = '_' )
  
  rspGLO <- function(model_yr, var){
    rs <- model_yr %>%
      dplyr::select(x,y,var) %>%
      merge(basegrid, by = c('x', 'y'), all.y = T) %>%
      dcast(y ~x) %>%
      arrange(desc(y)) %>%
      dplyr::select(-y) %>%
      as.matrix() %>%
      raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
    plot(rs, main = paste(yr, var, 'GLOBIOM', sep = ' '))
  }
  
  rspAIM <- function(model_yr, var){
    rs <- model_yr %>%
      dplyr::select(x,y,var) %>%
      merge(basegrid, by = c('x', 'y'), all.y = T) %>%
      dcast(y ~x) %>%
      arrange(desc(y)) %>%
      dplyr::select(-y) %>%
      as.matrix() %>%
      raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
    plot(rs, main = 'AIM')
  }
  par(mfrow = c(9,2))
  for (i in 1:9) {
    rspGLO(glo_yr, LUTs[i])
    rspAIM(aim_yr, LUTs[i])
  }
  mtext(side = 3, line=1, outer=T, text = "Title", cex=2)
  
}


pdf('GLOBIOM_AIM_all_yr.pdf', height = 30, width = 10)
torast(2010)
torast(2020)
torast(2030)
torast(2040)
torast(2050)
dev.off()



torast_sep <- function(yr){
  glo_yr <- glo %>% 
    dplyr::filter(YEAR==yr)
  
  aim_yr <- aim %>% 
    dplyr::filter(YEAR==yr)
  
  basegrid <- expand.grid(x = seq(-179,179, 2), y =seq(89, -89, -2))
  LUTs <- c("share.CrpLnd", "share.GrsLnd", "share.NatLnd", "share.MngFor",
            "share.PriFor", "share.OagLnd", "share.WetLnd", "share.NotRel",
            "share.RstLnd")
  
  obj <- paste('rs',yr, 1:9, sep = '_' )
  
  rspGLO <- function(model_yr, var){
    rs <- model_yr %>%
      dplyr::select(x,y,var) %>%
      merge(basegrid, by = c('x', 'y'), all.y = T) %>%
      dcast(y ~x) %>%
      arrange(desc(y)) %>%
      dplyr::select(-y) %>%
      as.matrix() %>%
      raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
    plot(rs, main = 'GLOBIOM')
  }
  
  rspAIM <- function(model_yr, var){
    rs <- model_yr %>%
      dplyr::select(x,y,var) %>%
      merge(basegrid, by = c('x', 'y'), all.y = T) %>%
      dcast(y ~x) %>%
      arrange(desc(y)) %>%
      dplyr::select(-y) %>%
      as.matrix() %>%
      raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
    plot(rs, main = 'AIM')
  }
  
  for (i in 1:9) {
    par(mfrow = c(1,2), oma = c(0, 0, 2, 2))
    rspGLO(glo_yr, LUTs[i])
    rspAIM(aim_yr, LUTs[i])
    mtext(text = paste(yr, ': ', LUTs[i], sep = ''), side = 3, line=0, outer=T, cex=1.5)
  }
  
}


pdf('GLOBIOM_AIM_2010.pdf', height = 6, width = 18)
torast_sep(2010)
dev.off()




torast_eight <- function(yr){
  SSP1p_20W_SPA1_BI3G <-  fread("GLOBIOM_AIM\\scenarios\\AIM\\SSP1p_20W_SPA1_BI3G.csv")%>% 
    dplyr::filter(YEAR==yr)
  
  SSP1p_20W_SPA1_BIOE <- fread("GLOBIOM_AIM\\scenarios\\AIM\\SSP1p_20W_SPA1_BIOE.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  SSP1p_BaU_BIOD <- fread("GLOBIOM_AIM\\scenarios\\AIM\\SSP1p_BaU_BIOD.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  SSP1p_BaU_NoCC <- fread("GLOBIOM_AIM\\scenarios\\AIM\\SSP1p_BaU_NoCC.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  SSP2_BaU_BIOD <- fread("GLOBIOM_AIM\\scenarios\\AIM\\SSP2_BaU_BIOD.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  SSP2_BaU_NoCC <- fread("GLOBIOM_AIM\\scenarios\\AIM\\SSP2_BaU_NoCC.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  inner_GLOBIOM_LUCC_sample_v3_scen1 <- fread("GLOBIOM_AIM\\scenarios\\GLOBIOM\\inner_GLOBIOM_LUCC_sample_v3_scen1.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  inner_GLOBIOM_LUCC_sample_v3_scen2 <- fread("GLOBIOM_AIM\\scenarios\\GLOBIOM\\inner_GLOBIOM_LUCC_sample_v3_scen2.csv") %>% 
    dplyr::filter(YEAR==yr)
  
  basegrid <- expand.grid(x = seq(-179,179, 2), y =seq(89, -89, -2))
  LUTs <- c("share.CrpLnd", "share.GrsLnd", "share.NatLnd", "share.MngFor",
            "share.PriFor", "share.OagLnd", "share.WetLnd", "share.NotRel",
            "share.RstLnd")
  
  obj <- paste('rs',yr, 1:9, sep = '_' )
  
  rspSce <- function(scenario, var){
    rs <- scenario %>%
      dplyr::select(x,y,var) %>%
      merge(basegrid, by = c('x', 'y'), all.y = T) %>%
      dcast(y ~x) %>%
      arrange(desc(y)) %>%
      dplyr::select(-y) %>%
      as.matrix() %>%
      raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
    plot(rs, main = deparse(substitute(scenario)))
  }
  
  
  for (i in 1:9) {
    par(mfrow = c(2,4), oma = c(0, 0, 2, 2))
    rspSce(inner_GLOBIOM_LUCC_sample_v3_scen1, LUTs[i])
    rspSce(SSP1p_20W_SPA1_BIOE, LUTs[i])
    rspSce(SSP1p_20W_SPA1_BI3G, LUTs[i])
    rspSce(SSP1p_BaU_BIOD, LUTs[i])
    
    rspSce(inner_GLOBIOM_LUCC_sample_v3_scen2, LUTs[i])
    rspSce(SSP1p_BaU_NoCC, LUTs[i])
    rspSce(SSP2_BaU_BIOD, LUTs[i])
    rspSce(SSP2_BaU_NoCC, LUTs[i])
    mtext(text = paste(yr, ': ', LUTs[i], sep = ''), side = 3, line=0, outer=T, cex=1.5)
  }
  
}


for (i in seq(2010, 2050,10)) {
  pdf(paste('GLOBIOM_AIM_scenarios_', i, '.pdf', sep = ''), height = 8, width = 18)
  torast_eight(i)
  dev.off()
}



















