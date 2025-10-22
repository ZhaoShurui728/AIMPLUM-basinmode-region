# library(raster)
# library(dplyr)
# library(data.table)

plotAIMfun <- function(version){

plotinputdir <- paste('RLIscore_forAIM\\input_scenarios\\', version, '\\', sep = '')
plotoutputdir <- paste('RLIscore_forAIM\\AIM_LUmap\\', version, '\\', sep = '')
if(!dir.exists(plotoutputdir)){dir.create(plotoutputdir)}

readf <- function(scenario){
  s <- fread(paste(plotinputdir, scenario, sep = '')) %>%
    mutate(scenario = substr(scenario, 1,nchar(scenario)-4))
  return(s)
}

scenariofiles <- list.files(plotinputdir)

svec <- substr(scenariofiles, 1,nchar(scenariofiles)-4)

for (i in 1:length(scenariofiles)){
  assign(svec[i], readf(scenariofiles[i]))
}

allsec <- NULL
for (i in 1:length(scenariofiles)) {
  allsec <- rbind(allsec, get(svec[i]))
}


LUTs <- c("share.CrpLnd", "share.GrsLnd", "share.NatLnd", "share.MngFor",
          "share.PriFor", "share.OagLnd", "share.WetLnd", "share.NotRel",
          "share.RstLnd")  
YRs <- c(2005, seq(2010, 2100,10))


torast_byLUT <- function(yr){

  cat(format(Sys.time()))
  cat('\n')
  cat('Plotting year: ')
  cat(yr)
  cat('\n')
  
  rs_year <- allsec %>% 
    dplyr::filter(YEAR==yr)
  
  basegrid <- expand.grid(x = seq(-179,179, 2), y =seq(89, -89, -2))
  LUTs <- c("share.CrpLnd", "share.GrsLnd", "share.NatLnd", "share.MngFor",
            "share.PriFor", "share.OagLnd", "share.WetLnd", "share.NotRel",
            "share.RstLnd")
  rsptype <- function(sce, LUT){
    rs <- rs_year %>%
      dplyr::filter(scenario == sce) %>%
      dplyr::select(x,y,LUT) %>%
      merge(basegrid, by = c('x', 'y'), all.y = T) %>%
      reshape2::dcast(y ~x, value.var = LUT) %>%
      arrange(desc(y)) %>%
      dplyr::select(-y) %>%
      as.matrix() %>%
      raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
    plot(rs, main = LUT)
  }
  pdf(paste(plotoutputdir,'AIM_byLUT_',yr,'.pdf', sep = ''), height = 18, width = 30)
  for (i in 1:length(scenariofiles)) {
    par(mfrow = c(3,3), oma = c(5, 5, 8, 5))
    for (j in 1:9) {
      
      rsptype(svec[i], LUTs[j])
    }
    mtext(text = paste(yr, '\n ', svec[i], sep = ''), side = 3, line=0, outer=T, cex=2)
  }
  dev.off()
}


for (i in 1:length(YRs)) {
  torast_byLUT(YRs[i])
}

}


# torast_byYEAR <- function(LUT){
# 
#   rs_year <- allsec %>%
#     dplyr::select(x,y,YEAR,LUT, scenario)
# 
#   basegrid <- expand.grid(x = seq(-179,179, 2), y =seq(89, -89, -2))
# 
#   rsptype <- function(sce, yr){
#     rs <- rs_year %>%
#       dplyr::filter(YEAR == yr, scenario == sce) %>%
#       dplyr::select(-YEAR, -scenario) %>%
#       merge(basegrid, by = c('x', 'y'), all.y = T) %>%
#       reshape2::dcast(y ~x, value.var = LUT) %>%
#       arrange(desc(y)) %>%
#       dplyr::select(-y) %>%
#       as.matrix() %>%
#       raster(xmn = -179, xmx = 179, ymn = -89,ymx = 89)
#     plot(rs, main = yr)
#   }
#   pdf(paste('AIM_LUmap\\','AIM_byYEAR_',LUT,'.pdf', sep = ''), height = 18, width = 18)
#   for (i in 1:9) {
#     par(mfrow = c(4,3), oma = c(5, 5, 5, 5))
#     for (j in 1:length(YRs)) {
#       print((i-1)*9 + j)
#       rsptype(svec[i], YRs[j])
#     }
#     mtext(text = paste(LUT, '\n', svec[i], sep = ''), side = 3, line=0, outer=T, cex=1.5)
#   }
#   dev.off()
# }


#for (i in 1:9) {
#  torast_byYEAR(LUTs[i])
#}
