getwd()
getwd()
setwd(getwd())

setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)


colnames <- c("Variable","X1","X2","Value")
porg <- read.table("../../../output/yieldJPN2010.txt")
names(porg) <- colnames

#PAS
#pdata <- porg[porg$Variable=="PAS", c(-1)]
#names(pdata) <- c("X1","X2","Value")
#outname <- paste('../../../output/plot/JAN2010_PASyield.png', sep = '')
#png(filename=outname, width=730, height=600, res=150)
#ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("pasture")

#WHT
pdata <- porg[porg$Variable=="WHT", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_WHTyield.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("wheat")


#OSD
pdata <- porg[porg$Variable=="OSD", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_OSDyield.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("oil crops")


#GRO
pdata <- porg[porg$Variable=="GRO", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_GROyield.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("other coarse grain") 

#C_B
pdata <- porg[porg$Variable=="C_B", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_C_Byield.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("sugar crops") 


#PDR
pdata <- porg[porg$Variable=="PDR", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_PDRyield.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85) + ggtitle("rice")