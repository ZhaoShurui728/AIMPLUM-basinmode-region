getwd()
getwd()
setwd(getwd())

#setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)

colnames <- c("Variable","X1","X2","Value")

regionin <- c("USA","XE25","XER","TUR","XOC","CHN","IND","JPN","XSE","XSA","CAN","BRA","XLM","CIS","XME","XNF","XAF")
regionin <-  c("BRA","XSE")
yearin <-  c("2006")
landin <-  c("PDR","WHT","GRO","C_B","OSD","OTH_A","CL","GL","PAS","FRS")
#landin <-  c("CL")
scein <- c("SSP2")
clpin <- c("BaU")
pres <- 150

for(m in (1:length(scein))){
for(n in (1:length(clpin))){

for(r in (1:length(regionin))){
for(t in (1:length(yearin))){

load_filename <- paste('../../../output/txt/',scein[m],'_',clpin[n],'/',regionin[r],'/',yearin[t],'dif.txt', sep = '')

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

#	landin <- unique(porg$Variable) 

	size_adj <- 550/((maxv-minv)*14)

		for(i in (1:length(landin))){
	
		pdata <- c(0)
		pdata <- porg[porg$Variable==landin[i], c(2,3,4)]
	
		out_filename <- paste('../../../output/png/',scein[m],'_',clpin[n],'/',regionin[r],'/',yearin[t],'_',landin[i],'dif.png', sep = '')

	
		if (landin[i]=="PDR"){
			land_name <- paste("rice")
		} else if (landin[i]=="WHT"){
			land_name <- paste("wheat")
		} else if (landin[i]=="GRO"){
			land_name <- paste("other coarse grain")
		} else if (landin[i]=="OSD"){
			land_name <- paste("oil crops")
		} else if (landin[i]=="C_B"){
			land_name <- paste("sugar crops")
		} else if (landin[i]=="OTH_A"){
			land_name <- paste("other crops")
		} else if (landin[i]=="BIO"){
			land_name <- paste("bio crops")
		} else if (landin[i]=="PRM_FRS"){
			land_name <- paste("primary forest")
		} else if (landin[i]=="MNG_FRS"){
			land_name <- paste("secondary forest")
		} else if (landin[i]=="HAV_FRS"){
			land_name <- paste("havested forest")
		} else if (landin[i]=="AFR"){
			land_name <- paste("afforestation")
		} else if (landin[i]=="PAS"){
			land_name <- paste("pasture")
		} else if (landin[i]=="SL"){
			land_name <- paste("built-up")
		} else if (landin[i]=="OL"){
			land_name <- paste("ice or water")
		} else if (landin[i]=="GL"){
			land_name <- paste("grassland")
		} else if (landin[i]=="CROP_FLW"){
			land_name <- paste("fallow land")
		} else if (landin[i]=="CL"){
			land_name <- paste("cropland")
		} else if (landin[i]=="BIOP"){
			land_name <- paste("potential area for biocrops")
		} else if (landin[i]=="FRS"){
			land_name <- paste("forest")
		} else {
			land_name <- paste("aaaaaaaaaa")
		} 


		title_name <- paste(regionin[r]," ",yearin[t]," ",land_name)

		png(filename=out_filename, width=(maxh-minh)*size_adj*14+pres, height=(maxv-minv)*size_adj*14, res=pres)

		plot <- ggplot(subset(pdata), aes(x=X2, y=X1, fill=Value)) + geom_raster() +
		ylim(maxv,minv)+ xlim(minh,maxh)+ ggtitle(title_name) + 
		scale_fill_gradient2(low="blue", mid="white", high="red",midpoint=0)

		print(plot)
		dev.off()
		}
	}
}}}}