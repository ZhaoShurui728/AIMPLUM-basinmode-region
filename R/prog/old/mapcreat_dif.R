getwd()
getwd()
setwd(getwd())

setwd("C:/_LandUseModel/prog/R/prog")

library(ggplot2)
library(plyr)
library(reshape2)


colnames <- c("Variable","X1","X2","Value")
porg <- read.table("../../../output/difJPN2010.txt")
names(porg) <- colnames

#PAS
pdata <- porg[porg$Variable=="PAS", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_PASdif.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("pasture") + scale_fill_gradient2()

#WHT
pdata <- porg[porg$Variable=="WHT", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_WHTdif.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("wheat") + scale_fill_gradient2()


#OSD
pdata <- porg[porg$Variable=="OSD", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_OSDdif.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("oil crops") + scale_fill_gradient2()


#GRO
pdata <- porg[porg$Variable=="GRO", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_GROdif.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("other coarse grain")  + scale_fill_gradient2()

#C_B
pdata <- porg[porg$Variable=="C_B", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_C_Bdif.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85)+ ggtitle("sugar crops")  + scale_fill_gradient2()


#PDR
pdata <- porg[porg$Variable=="PDR", c(-1)]
names(pdata) <- c("X1","X2","Value")
outname <- paste('../../../output/plot/JAN2010_PDRdif.png', sep = '')
png(filename=outname, width=730, height=600, res=150)
ggplot(pdata, aes(x=X2, y=X1, fill=Value)) +    geom_raster() + ylim(135,85) + ggtitle("rice") + scale_fill_gradient2()