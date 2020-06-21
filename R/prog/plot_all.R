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

#regionin <- c("USA","XE25","XER","TUR","XOC","CHN","IND","JPN","XSE","XSA","CAN","BRA","XLM","CIS","XME","XNF","XAF")
regionin <-  c("WLD")
regionin <-  c("JPN")
yearin <-  c("2100")
landin <-  c("FRS")
scein <- c("SSP2")
clpin <- c("BaU")
iavin <- c("NoCC")

pres <- 150

MyThemeLine <- theme_grey() +
  theme(
    panel.border=element_rect(fill=NA),
    axis.title=element_text(size=10,face="bold"),
    axis.text.x = element_text(hjust=1,size = 10, angle = 0),
    axis.line=element_line(colour="black"),
    panel.background=element_rect(fill = "white"),
#    panel.background=element_blank(),
    #    panel.grid.major=element_line(linetype="dashed",colour="grey",size=0.5),
    panel.grid.major=element_blank(),
    strip.background=element_rect(fill="white", colour="white"),
    strip.text.x = element_text(size=10, colour = "black", angle = 0,face="bold"),
    axis.ticks=element_blank(), axis.text = element_blank()
  )

mypalette <- brewer.pal(6, "YlOrBr")
world <- map_data("world")

for(m in (1:length(scein))){
for(n in (1:length(clpin))){
for(l in (1:length(iavin))){

for(r in (1:length(regionin))){
for(t in (1:length(yearin))){

load_filename <- paste('../../../output/txt/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',yearin[t],'.txt', sep = '')

	if (file.exists(load_filename)) {
	
	pdata0 <- read.table(load_filename, sep="\t")
	names(pdata0) <- colnames
#	porg <- pdata0[pdata0$Variable==c("FRS")|pdata0$Variable==c("PAS")|pdata0$Variable==c("GL")|pdata0$Variable==c("CL")|pdata0$Variable==c("BIO")|pdata0$Variable==c("AFR")|pdata0$Variable==c("FRSGL"), c(1,2,3,4)]
	porg <- pdata0[pdata0$Variable==c("FRS")|pdata0$Variable==c("PAS")|pdata0$Variable==c("GL")|pdata0$Variable==c("CL")|pdata0$Variable==c("BIO")|pdata0$Variable==c("AFR"), c(1,2,3,4)]

	levels(porg$Variable)[levels(porg$Variable)=="GL"] <- "other natinal vegetation"
	levels(porg$Variable)[levels(porg$Variable)=="CL"] <- "cropland"
	levels(porg$Variable)[levels(porg$Variable)=="PAS"] <- "pasture"
	levels(porg$Variable)[levels(porg$Variable)=="AFR"] <- "afforestation"
	levels(porg$Variable)[levels(porg$Variable)=="FRS"] <- "forest"
	levels(porg$Variable)[levels(porg$Variable)=="BIO"] <- "bio crops"
	
	
	maxv <- max(porg[2])
	minv <- min(porg[2])
	maxh <- max(porg[3])
	minh <- min(porg[3])
	maxvalue <- max(porg[4])
	minvalue <- max(porg[4])
	
	if (regionin[r]=="USA"){
		minh <- c(0)
		maxh <- c(250)
	} else if (regionin[r]=="CIS"){
		minh <- c(400)
		maxh <- c(750)
	}

#	landin <- unique(porg$Variable) 

	size_adj <- 550/((maxv-minv)*14)

#		for(i in (1:length(landin))){
	
#		pdata <- c(0)
#		pdata <- porg[porg$Variable==landin[i], c(2,3,4)]
	
		out_filename <- paste('../../../output/png/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',yearin[t],'.png', sep = '')

		title_name <- paste(scein[m]," ",clpin[n]," ",regionin[r]," ",yearin[t])

		png(filename=out_filename, width=(maxh-minh)*size_adj*14*2*0.8+pres, height=(maxv-minv)*size_adj*14*3, res=pres)

		plot1 <- ggplot() + geom_raster(data=porg, aes(x=X2, y=X1, fill=Value))		+
		geom_path(data=world,aes(x = long*2+360, y = lat*(-2)+180, group = group), colour = "black", size = 0.15)+
		ylim(maxv,minv)+ xlim(minh,maxh)+ 
#		ggtitle(title_name) +
#		facet_grid(Variable ~ .) + 
#		facet_wrap(~Variable,ncol = 2) + 
		ylab("") + xlab("") +
#		scale_fill_gradient(low="grey", high="blue") +
#		scale_fill_gradient2(low="white", mid="grey", high="blue", midpoint=0, limits=c(-1,maxvalue)) +
#		scale_fill_gradient2(low="red", mid="white", high="blue",midpoint=0,limits=c(-0.00001,maxvalue)) +
#		scale_fill_gradientn(colours = c("white", "lightblue", "blue"),breaks=c(-1,0,maxvalue),limits=c(-0.00001,maxvalue)) +
		scale_fill_gradientn(colours = mypalette, name="area ratio", breaks=c(0,0.2,0.4,0.6,0.8,1.0),limits=c(-0.00001,1.0))
#		MyThemeLine

		plot2 <- plot1 +coord_equal()
		plot3 <- plot2+  facet_wrap(~Variable,ncol = 2)
		print(plot3)

		dev.off()
#		}
	}
}}}}}
