getwd()
getwd()
setwd(getwd())

#setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)

colnames <- c("Variable","X1","X2","Value")

regionin <- c("USA","XE25","XER","TUR","XOC","CHN","IND","JPN","XSE","XSA","CAN","BRA","XLM","CIS","XME","XNF","XAF")
regionin <-  c("USA","CHN","IND","XAF","BRA","XSE")
#regionin <-  c("BRA")
yearin <-  c("2005")
landin <-  c("PDR")
pres <- 150
scein <- c("SSP2")
clpin <- c("BaU")
iavin <- c("NoCC")

for(m in (1:length(scein))){
for(n in (1:length(clpin))){
for(l in (1:length(iavin))){

for(r in (1:length(regionin))){
for(t in (1:length(yearin))){

load_filename <- paste('../../../output/txt/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/yield.txt', sep = '')

	if (file.exists(load_filename)) {
	
	porg <- read.table(load_filename, sep="\t")
	names(porg) <- colnames
	
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

	landin <- unique(porg$Variable) 

	size_adj <- 550/((maxv-minv)*14)

		for(i in (1:length(landin))){
	
		pdata <- c(0)
		pdata <- porg[porg$Variable==landin[i], c(2,3,4)]

		maxvalue <- max(pdata[3])
		minvalue <- max(pdata[3])

		out_filename <- paste('../../../output/png/',scein[m],'_',clpin[n],'_',iavin[l],'/',regionin[r],'/',landin[i],'yield.png', sep = '')

	
		if (landin[i]=="PDR"){
			land_name <- paste("rice yield (tonne/ha)")
		} else if (landin[i]=="WHT"){
			land_name <- paste("wheat yield (tonne/ha)")
		} else if (landin[i]=="GRO"){
			land_name <- paste("other coarse grain yield (tonne/ha)")
		} else if (landin[i]=="OSD"){
			land_name <- paste("oil crops yield (tonne/ha)")
		} else if (landin[i]=="C_B"){
			land_name <- paste("sugar crops yield (tonne/ha)")
		} else if (landin[i]=="OTH_A"){
			land_name <- paste("other crops yield (tonne/ha)")
		} else if (landin[i]=="PDRIR"){
			land_name <- paste("rice irrigated yield (t/ha)")
		} else if (landin[i]=="WHTIR"){
			land_name <- paste("wheat irrigated yield (t/ha)")
		} else if (landin[i]=="GROIR"){
			land_name <- paste("other coarse grain irrigated yield (t/ha)")
		} else if (landin[i]=="OSDIR"){
			land_name <- paste("oil crops irrigated yield (t/ha)")
		} else if (landin[i]=="C_BIR"){
			land_name <- paste("sugar crops irrigated yield (t/ha)")
		} else if (landin[i]=="OTH_AIR"){
			land_name <- paste("other crops irrigated yield (t/ha)")
		} else if (landin[i]=="PDRRF"){
			land_name <- paste("rice rainfed yield (t/ha)")
		} else if (landin[i]=="WHTRF"){
			land_name <- paste("wheat rainfed yield (t/ha)")
		} else if (landin[i]=="GRORF"){
			land_name <- paste("other coarse grain rainfed yield (t/ha)")
		} else if (landin[i]=="OSDRF"){
			land_name <- paste("oil crops rainfed yield (t/ha)")
		} else if (landin[i]=="C_BRF"){
			land_name <- paste("sugar crops rainfed yield (t/ha)")
		} else if (landin[i]=="OTH_ARF"){
			land_name <- paste("other crops rainfed yield (t/ha)")
		} else if (landin[i]=="PRM_FRS"){
			land_name <- paste("primary forest (tonne/ha)")
		} else if (landin[i]=="HAV_FRS"){
			land_name <- paste("havested forest cstock (MgC/ha)")
		} else if (landin[i]=="AFR"){
			land_name <- paste("afforestation cflux (MgC/ha/year)")
		} else if (landin[i]=="PAS"){
			land_name <- paste("pasture yield (MgC/ha)")
		} else if (landin[i]=="BIO"){
			land_name <- paste("bio crops yield (MgC/ha)")
		} else if (landin[i]=="SL"){
			land_name <- paste("built-up")
		} else if (landin[i]=="OL"){
			land_name <- paste("ice or water")
		} else if (landin[i]=="GL"){
			land_name <- paste("grassland")
		} else if (landin[i]=="CROP_FLW"){
			land_name <- paste("fallow land (tonne/ha)")
		} else if (landin[i]=="CL"){
			land_name <- paste("cropland")
		} else {
			land_name <- paste("aaaaaaaaaa")
		} 


		title_name <- paste(regionin[r], land_name)

		png(filename=out_filename, width=(maxh-minh)*size_adj*14+pres, height=(maxv-minv)*size_adj*14, res=pres)

		plot <- ggplot(subset(pdata), aes(x=X2, y=X1, fill=Value)) + geom_raster() +
		ylim(maxv,minv)+ xlim(minh,maxh)+ ggtitle(title_name) + 
#		scale_fill_gradient(low="grey", high="blue")
		scale_fill_gradientn(colours = c("white", "lightblue", "blue"),breaks=c(-1,0,maxvalue),limits=c(-0.00001,maxvalue))
#		scale_fill_gradient2(low="red", mid="white", high="blue",midpoint=0)
		print(plot)
		dev.off()
		}
	}
}}}}}