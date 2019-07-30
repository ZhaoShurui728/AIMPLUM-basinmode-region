getwd()
getwd()
setwd(getwd())

#setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)
library(RColorBrewer)
library(maps)

pres <- 150

MyThemeLine <- theme_grey() +
  theme(
    panel.border=element_rect(fill=NA),
    axis.title=element_text(size=10,face="bold"),
    axis.text.x = element_text(hjust=1,size = 15, angle = 0),
    axis.line=element_line(colour="black"),
    panel.background=element_rect(fill = "white"),
#    panel.background=element_blank(),
    #    panel.grid.major=element_line(linetype="dashed",colour="grey",size=0.5),
    panel.grid.major=element_blank(),
    strip.background=element_rect(fill="white", colour="white"),
    strip.text.x = element_text(size=15, colour = "black", angle = 0,face="bold"),
    axis.ticks=element_blank(), axis.text = element_blank(),
    legend.title = element_text (size=13),
    legend.text = element_text (size=11)
  )

fsize <- 11
MyThemeLine <- theme_grey() +
  theme(
    panel.border=element_rect(fill=NA),
    title=element_text(size=fsize,face="bold"),
    axis.title=element_text(size=fsize,face="bold"),
    axis.text = element_text(hjust=1,size = fsize, angle = 0),
    axis.line=element_line(colour="black"),
    panel.background=element_rect(fill = "white"),
    #    panel.background=element_blank(),
    #    panel.grid.major=element_line(linetype="dashed",colour="grey",size=0.5),
    panel.grid.major=element_blank(),
    strip.background=element_rect(fill="white", colour="white"),
    strip.text.x = element_text(size=fsize, colour = "black", angle = 0,face="bold"),
    legend.title = element_text(size=fsize),
    legend.text = element_text(size=fsize)
  )

mypalette <- brewer.pal(11, "YlOrBr")
world <- map_data("world")


colnames <- c("Variable","X1","X2","Value")

regionin <- c("USA","XE25","XER","TUR","XOC","CHN","IND","JPN","XSE","XSA","CAN","BRA","XLM","CIS","XME","XNF","XAF")
regionin <-  c("BRA","XLM","XSE","XSA","IND","XAF")
regionin <-  c("JPN")
regionin <-  c("WLD")
yearin <-  c("2100")
landin <-  c("FRS")
scein <- c("SSP1","SSP2","SSP3")
scein <- c("SSP2i")
clpin <- c("BaU")
scein <- c("SSP2")
clpin <- c("INDC_CONT3")
iavin <- c("NoCC")


for(m in (1:length(scein))){
for(n in (1:length(clpin))){
for(l in (1:length(iavin))){

for(r in (1:length(regionin))){
for(t in (1:length(yearin))){

load_filename <- paste('../../../output/txt/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',yearin[t],'.txt', sep = '')

	if (file.exists(load_filename)) {
	
	pdata0 <- read.table(load_filename, sep="\t")
	names(pdata0) <- colnames
	
	porg <- pdata0[pdata0$Variable==c("FRS")|pdata0$Variable==c("PAS")|pdata0$Variable==c("GL")|pdata0$Variable==c("CL")|pdata0$Variable==c("BIO")|pdata0$Variable==c("AFR"), c(1,2,3,4)]
	

	levels(porg$Variable)[levels(porg$Variable)=="GL"] <- "other natural vegetation"
	levels(porg$Variable)[levels(porg$Variable)=="CL"] <- "cropland"
	levels(porg$Variable)[levels(porg$Variable)=="PAS"] <- "pasture"
	levels(porg$Variable)[levels(porg$Variable)=="AFR"] <- "afforestation"
	levels(porg$Variable)[levels(porg$Variable)=="FRS"] <- "forest"
	levels(porg$Variable)[levels(porg$Variable)=="BIO"] <- "bio crops"

	porg$Variable <- factor(porg$Variable, levels = c("forest","other natural vegetation", "cropland", "pasture","afforestation","bio crops"))


	
	
	maxv <- max(porg[2])
	minv <- min(porg[2])
	maxh <- max(porg[3])
	minh <- min(porg[3])
	maxvalue <- max(porg[4])
	minvalue <- min(porg[4])
	
	if (regionin[r]=="USA") {
		minh <- c(0)
		maxh <- c(250)
	} else if (regionin[r]=="CIS") {
		minh <- c(400)
		maxh <- c(750)
	}

#	landin <- unique(porg$Variable) 

	size_adj <- 550/((maxv-minv)*14)

#		for(i in (1:length(landin))){
	
#		pdata <- c(0)
#		pdata <- porg[porg$Variable==landin[i], c(2,3,4)]
	
		out_filename <- paste('../../../output/png/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',scein[m],'_',clpin[n],'_',iavin[l],'_',yearin[t],'.png', sep = '')

		title_name <- paste(scein[m]," ",clpin[n]," ",regionin[r]," ",yearin[t])

		plot1 <- ggplot() + geom_raster(data=porg, aes(x=X2, y=X1, fill=Value)) +
		geom_path(data=world,aes(x = long*2+360, y = lat*(-2)+180, group = group), colour = "black", size = 0.15) +
		ylim(maxv,minv) + xlim(minh,maxh) +
		ggtitle(title_name) +
#		facet_grid(Variable ~ .) + 
#		facet_wrap(~Variable,ncol = 2) + 
		ylab("") + xlab("") +
		scale_fill_gradientn(colours = mypalette, name="Fractions of \n land-use area", breaks=c(-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0),limits=c(-0.00001,1.0)) +
		MyThemeLine

		plot2 <- plot1 +coord_equal()
		plot3 <- plot2+  facet_wrap(~Variable,ncol = 2)

		print(plot3)

 ggsave(file = out_filename, plot = plot3, dpi = 300, width = 9, height = 6)

#		dev.off()
#		}
	}
}}}}}
