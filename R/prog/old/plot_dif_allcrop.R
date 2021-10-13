getwd()
getwd()
setwd(getwd())

#setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)
library(RColorBrewer)
library(maps)

colnames <- c("Variable","X1","X2","Value")

regionin <- c("USA","XE25","XER","TUR","XOC","CHN","IND","JPN","XSE","XSA","CAN","BRA","XLM","CIS","XME","XNF","XAF")
#regionin <-  c("XAF")
yearin <-  c("2100")
yearin <-  c("2010")
landin <-  c("PDR","WHT","GRO","C_B","OSD","OTH_A","CL","GL","PAS","FRS")
landin <-  c("FRS","PAS","GL","CL")
landin <-  c("PDR","WHT","GRO","C_B","OSD","OTH_A")
scein <- c("SSP1","SSP2","SSP3")
scein <- c("SSP2")
clpin <- c("BaU","26W")
iavin <- c("NoCC")
pres <- 150

MyThemeLine <- theme_grey() +
  theme(
    panel.border=element_rect(fill=NA),
    axis.title=element_text(size=18,face="bold"),
    axis.text.x = element_text(hjust=1,size = 18, angle = 0),
    axis.line=element_line(colour="black"),
    panel.background=element_rect(fill = "white"),
    #    panel.grid.major=element_line(linetype="dashed",colour="grey",size=0.5),
    panel.grid.major=element_blank(),
    strip.background=element_rect(fill="white", colour="white"),
    strip.text.x = element_text(size=10, colour = "black", angle = 0,face="bold")
#    legend.text = element_text (size=20)
  )

mypalette <- brewer.pal(21, "RdYlGn")
world <- map_data("world")

for(m in (1:length(scein))){
for(n in (1:length(clpin))){
for(l in (1:length(iavin))){

for(r in (1:length(regionin))){
for(t in (1:length(yearin))){


load_filename <- paste('../../../output/txt/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',yearin[t],'dif.txt', sep = '')

	if (file.exists(load_filename)) {
	
	pdata0 <- read.table(load_filename, sep="\t")
	names(pdata0) <- colnames
#	porg <- pdata0[pdata0$Variable==c("FRS")|pdata0$Variable==c("PAS")|pdata0$Variable==c("GL")|pdata0$Variable==c("CL")|pdata0$Variable==c("BIO"), c(1,2,3,4)]
	porg <- pdata0[pdata0$Variable==c("PDRIR")|pdata0$Variable==c("PDRRF")|pdata0$Variable==c("WHTIR")|pdata0$Variable==c("WHTRF")|pdata0$Variable==c("GROIR")|pdata0$Variable==c("GRORF")|pdata0$Variable==c("OSDIR")|pdata0$Variable==c("OSDRF")|pdata0$Variable==c("C_BIR")|pdata0$Variable==c("C_BRF")|pdata0$Variable==c("OTH_AIR")|pdata0$Variable==c("OTH_ARF"), c(1,2,3,4)]
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

	
		out_filename <- paste('../../../output/png/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',yearin[t],'dif_crop.png', sep = '')

		title_name <- paste(scein[m]," ",clpin[n]," ",regionin[r]," ",yearin[t])

		png(filename=out_filename, width=(maxh-minh)*size_adj*14*2*0.8+pres, height=(maxv-minv)*size_adj*14*2, res=pres)

		plot1 <- ggplot() + geom_raster(data=porg, aes(x=X2, y=X1, fill=Value)) +
		geom_path(data=world,aes(x = long*2+360, y = lat*(-2)+180, group = group), colour = "black", size = 0.15) +
		ylim(maxv,minv)+ xlim(minh,maxh)+ ggtitle(title_name) + 
#		facet_grid(Variable ~.) + 
#		facet_wrap(~Variable,ncol = 4) + 
		ylab("") + xlab("") + 
#		scale_fill_gradient2(low="blue", mid="white", high="red",midpoint=0) +
#		scale_fill_gradient2(high="#4DAF4A", mid="white", low="#984EA3",midpoint=0) +
		scale_fill_gradientn(colours = mypalette, name="change ratio",breaks=c(-1.0,-0.8,-0.6,-0.4,-0.2,-0,0.2,0.4,0.6,0.8,1.0),limits=c(-1.0,1.0)) +		MyThemeLine

		plot2 <- plot1 +coord_equal()
		plot3 <- plot2+  facet_wrap(~Variable,ncol = 4)
		print(plot3)

		dev.off()
	}
}}}}}