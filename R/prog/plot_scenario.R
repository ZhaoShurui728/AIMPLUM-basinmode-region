getwd()
setwd(getwd())

#setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)
library(RColorBrewer)
library(maps)
args <- commandArgs(trailingOnly = T)
colnames <- c("Variable","X1","X2","Value")
scenarioname <- args[1]
pres <- 150


world <- map_data("world")

fsize <- 11
MyThemeLine <- theme_grey() +
  theme(
    panel.border=element_rect(fill=NA),
    title=element_text(size=fsize,face="bold"),
    axis.title=element_text(size=fsize,face="bold"),
    axis.text = element_text(hjust=1,size = fsize, angle = 0),
    axis.line=element_line(colour="black"),
    panel.background=element_rect(fill = "white"),
    panel.grid.major=element_blank(),
    strip.background=element_rect(fill="white", colour="white"),
    strip.text.x = element_text(size=fsize, colour = "black", angle = 0,face="bold"),
    legend.title = element_text(size=fsize),
    legend.text = element_text(size=fsize)
  )


regionin <- c("USA","XE25","XER","TUR","XOC","CHN","IND","JPN","XSE","XSA","CAN","BRA","XLM","CIS","XME","XNF","XAF")
regionin <-  c("BRA","XLM","XSE","XSA","IND","XAF")
regionin <-  c("WLD")
yearin <-  c("2005","2050","2100")
landin <-  c("FRS")
if(regionin=="WLD"){
  landtypelist <- c("all")
}else{
  landtypelist <- c("all","crop")
}
for(r in (1:length(regionin))){
  for(t in (1:length(yearin))){
    for(absdif in c("abs","dif")){
      for(landtype in landtypelist){
        if(absdif=="dif"){
          
          mypalette <- brewer.pal(11, "RdYlGn")
          load_filename <- paste('../../../output/txt/',scenarioname,'/',regionin[r],'/',yearin[t],'dif.txt', sep = '')
          legendname <- "changes in \n fractions of \n land-use area"
          breakvalue <- c(-1.0,-0.8,-0.6,-0.4,-0.2,-0,0.2,0.4,0.6,0.8,1.0)
          limitvalue <- c(-1.0,1.0)
        }else{
          mypalette <- brewer.pal(9, "YlOrBr")
          load_filename <- paste('../../../output/txt/',scenarioname,'/',regionin[r],'/',yearin[t],'.txt', sep = '')
          legendname <- "Fractions of \n cropland area"
          breakvalue <- c(-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)
          limitvalue <- c(-0.00001,1.0)
        }
        if(landtype=="crop"){pngheight <- 15}else{pngheight <- 10}
        out_filename <- paste('../../../output/png/',scenarioname,'/',regionin[r],'_',yearin[t],'_',landtype,'_',absdif,'.png', sep = '')
        if (file.exists(load_filename)) {
    	
      	pdata0 <- read.table(load_filename, sep="\t")
      	names(pdata0) <- colnames
      	if(landtype=="all"){
      	  porg <- pdata0[pdata0$Variable==c("FRS")|pdata0$Variable==c("PAS")|pdata0$Variable==c("GL")|pdata0$Variable==c("CL")|pdata0$Variable==c("BIO")|pdata0$Variable==c("AFR"), c(1,2,3,4)]
      	  porg$Variable[porg$Variable=="GL"] <- "other natural vegetation"
      	  porg$Variable[porg$Variable=="CL"] <- "cropland"
      	  porg$Variable[porg$Variable=="PAS"] <- "pasture"
      	  porg$Variable[porg$Variable=="AFR"] <- "afforestation"
      	  porg$Variable[porg$Variable=="FRS"] <- "forest"
      	  porg$Variable[porg$Variable=="BIO"] <- "bio crops"
      	  porg$Variable <- factor(porg$Variable, levels = c("forest","other natural vegetation", "cropland", "pasture","afforestation","bio crops"))
      	  
      	}else if (landtype=="crop"){
      	  porg <- pdata0[pdata0$Variable==c("PDRIR")|pdata0$Variable==c("PDRRF")|pdata0$Variable==c("WHTIR")|pdata0$Variable==c("WHTRF")|pdata0$Variable==c("GROIR")|pdata0$Variable==c("GRORF")|pdata0$Variable==c("OSDIR")|pdata0$Variable==c("OSDRF")|pdata0$Variable==c("C_BIR")|pdata0$Variable==c("C_BRF")|pdata0$Variable==c("OTH_AIR")|pdata0$Variable==c("OTH_ARF"), c(1,2,3,4)]
      	}
      
      	maxv <- max(porg[2])
      	minv <- min(porg[2])
      	maxh <- max(porg[3])
      	minh <- min(porg[3])
      	
      	if (regionin[r]=="USA"){
      		minh <- c(0)
      		maxh <- c(250)
      	} else if (regionin[r]=="CIS"){
      		minh <- c(400)
      		maxh <- c(650)
      	} 
      
      	size_adj <- 550/((maxv-minv)*14)
      	title_name <- paste(scenarioname," ",regionin[r]," ",yearin[t])
    
    		plot1 <- ggplot() + geom_raster(data=porg, aes(x=X2, y=X1, fill=Value)) +
    		geom_path(data=world,aes(x = long*2+360, y = lat*(-2)+180, group = group), colour = "black", size = 0.15) +
    		ylim(maxv,minv)+ xlim(minh,maxh)+ ggtitle(title_name) +
    		ylab("") + xlab("") + 
    		scale_fill_gradientn(colours = mypalette, name=legendname,breaks=breakvalue,limits=limitvalue) +MyThemeLine
    
        plot2 <- plot1 +coord_equal()
    		plot3 <- plot2+  facet_wrap(~Variable,ncol = 2)
        ggsave(file = out_filename, plot = plot3, dpi = 300, width = 10, height = pngheight )
    	}
  	}
  }
}
}
