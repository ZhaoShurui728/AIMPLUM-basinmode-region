library(gdxrrw)
library(ggplot2)
library(plyr)
library(reshape2)
library(RColorBrewer)
library(maps)


pres <- 150

args <- commandArgs(trailingOnly = TRUE)

default_args <- c("SSP2_BaU_NoCC","/opt/gams/gams37.1_linux_x64_64_sfx")   # Default value but gams path should be modified if GUI based R is used
default_flg <- is.na(args[1:2])
args[default_flg] <- default_args[default_flg]
scenarioname <- as.character(args[1])
gams_sys_dir <- as.character(args[2])
igdx(gams_sys_dir)
sizememory <- 1000*1024^2 
options(future.globals.maxSize= sizememory)
pngheight <- 10


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



#scenarioname <- c("SSP2_400C_2020NDC_NoCC_scenarioMIP_global2")
load_filename <- paste0('../output/gdx/analysis/lumip_',scenarioname,'.gdx')
yearin <-  c("2005","2050","2100")
colnames <- c("Year","Variable","X1","X2","Value")
landtypelist <- c("primn","primn","secdf","secdn","pastr","range","prtct_all","rice","wheat","maize","icwtr","fallow","urban")

for(absdif in c("abs")){
    if(absdif=="dif"){
      
      mypalette <- brewer.pal(11, "RdYlGn")
      load_paraname <- "Dif_Y"
      legendname <- "changes in \n fractions of \n land-use area"
      breakvalue <- c(-1.0,-0.8,-0.6,-0.4,-0.2,-0,0.2,0.4,0.6,0.8,1.0)
      limitvalue <- c(-1.0,1.0)
    }else{
      mypalette <- brewer.pal(9, "YlOrBr")
      load_paraname <- "VY_IJmip"
      legendname <- "Fractions of land-use area"
      breakvalue <- c(-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)
      limitvalue <- c(-0.00001,1.0)
    }

    if (file.exists(load_filename)) {
      pdata0 <- rgdx.param(load_filename,load_paraname)
      if (nrow(pdata0)>1) {
      	names(pdata0) <- colnames
      	pdata0$X1 <- as.numeric(levels(pdata0$X1))[pdata0$X1]
      	pdata0$X2 <- as.numeric(levels(pdata0$X2))[pdata0$X2]
      	pdata0$Variable <- as.character(pdata0$Variable)
  

    	  for(t in (1:length(yearin))){
    	    for(landtype in landtypelist){
    	      
        	  out_filename <- paste('../output/png/',scenarioname,'_',landtype,'_',yearin[t],'_',absdif,'.png', sep = '')      	 
        	  porg <- pdata0[pdata0$Variable %in% landtype, c(1,2,3,4,5)]
        	  porg <- porg[porg$Year==yearin[t], c(2,3,4,5)]
  
          	maxv <- max(porg[2])
          	minv <- min(porg[2])
          	maxh <- max(porg[3])
          	minh <- min(porg[3])
          	
          	size_adj <- 550/((maxv-minv)*14)
          	title_name <- paste(scenarioname," ",landtype," ",yearin[t])
#Here geom_tile can be geom_raster
        		plot1 <- ggplot() + geom_tile(data=porg, aes(x=X2, y=X1, fill=Value)) +
        		geom_path(data=world,aes(x = long*2+360, y = lat*(-2)+180, group = group), colour = "black", size = 0.15) +
        		ylim(maxv,minv)+ xlim(minh,maxh)+ ggtitle(title_name) +
        		ylab("") + xlab("") + 
        		scale_fill_gradientn(colours = mypalette, name=legendname,breaks=breakvalue,limits=limitvalue) +MyThemeLine

            ggsave(file = out_filename, plot = plot1, dpi = 300, width = 15, height = pngheight )
        }
      }
  	}
  }
}
