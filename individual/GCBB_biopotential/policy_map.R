library(data.table)
library(dplyr)
library(raster)
library(gridExtra)
library(rasterVis)
library(rgdal)
library(RColorBrewer)
# protect area base
protect_bs_map <- fread('policydata\\protect_bs_map.csv.gz', 
       head=F) %>% as.matrix()


# severe_land_size
severe_land_map = fread('policydata\\severe_land_map.csv.gz', 
                         head=F) %>% as.matrix()

# serious_land_size
serious_land_map = fread('policydata\\serious_land_map.csv.gz', 
       head=F) %>% as.matrix()


# protect_all_wdpa
protect_all_map = fread('policydata\\protect_all_map.csv.gz', 
       head=F) %>% as.matrix()


# serious_land_allpolicy_size
serious_land_allpolicy_map = fread('policydata\\serious_land_allpolicy_map.csv.gz', 
                                   head=F) %>% as.matrix()


## http://geog.uoregon.edu/bartlein/courses/geog490/week07-RMaps.html


# https://www.naturalearthdata.com/downloads/110m-physical-vectors/110m-coastline/
coast_shapefile <- "ne_110m_coastline\\ne_110m_coastline.shp"


layer <- ogrListLayers(coast_shapefile)

coast_lines <- readOGR(coast_shapefile, layer=layer)



###################################################
##                                               ##
##           individual policy maps              ##
##                                               ##
###################################################

###########################
##                       ##
##  severely degraded    ##
##                       ##
###########################

severe_land_map_na <- severe_land_map
severe_land_map_na[severe_land_map==0] <- NA

severe_land_map_rst <- raster(severe_land_map_na, xmn=-180, xmx=180, ymn=-90, ymx=90,
                              crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

severe_land_map_rst_r <- ratify(severe_land_map_rst)

rat_severeld <- levels(severe_land_map_rst_r)[[1]]
rat_severeld$policy <- c('Severely\ndegraded')
#rat$class <- c('A1', 'B2')
levels(severe_land_map_rst_r) <- rat_severeld

plt_severeld <- levelplot(severe_land_map_rst_r,
                              # par.settings=mapTheme, 
                              maxpixels = 1e7, 
                              main='    (c)',
                              xlab=NULL,
                              ylab=NULL,
                              colorkey=F,
                              #colorkey=list(space='right', width=2, height=1/20),
                              col.regions=c('#eb9800'))+ layer(sp.lines(coast_lines, col="black", lwd=0.5))

###########################
##                       ##
##  seriously degraded   ##
##                       ##
###########################

serious_land_map_na <- serious_land_map
serious_land_map_na[serious_land_map==0] <- NA

serious_land_map_rst <- raster(serious_land_map_na, xmn=-180, xmx=180, ymn=-90, ymx=90,
                              crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

serious_land_map_rst_r <- ratify(serious_land_map_rst)

rat_seriousld <- levels(serious_land_map_rst_r)[[1]]
rat_seriousld$policy <- c('Sriously\ndegraded')
#rat$class <- c('A1', 'B2')
levels(serious_land_map_rst_r) <- rat_seriousld

plt_seriousld <- levelplot(serious_land_map_rst_r,
                          # par.settings=mapTheme, 
                          maxpixels = 1e7, 
                          main='    (d)',
                          xlab=NULL,
                          ylab=NULL,
                          colorkey=F,
                          #colorkey=list(space='right', width=2, height=1/20),
                          col.regions=c('#eb9800'))+ layer(sp.lines(coast_lines, col="black", lwd=0.5))



###########################
##                       ##
##  all protected area   ##
##                       ##
###########################

protect_all_map_na <- protect_all_map
protect_all_map_na[protect_all_map==0] = NA

protect_all_map_rst <- raster(protect_all_map_na, xmn=-180, xmx=180, ymn=-90, ymx=90,
                              crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

protect_all_map_rst_r <- ratify(protect_all_map_rst)

rat_protectall <- levels(protect_all_map_rst_r)[[1]]
rat_protectall$policy <- c('Protected\narea')
#rat$class <- c('A1', 'B2')
levels(protect_all_map_rst_r) <- rat_protectall

plt_protectedall <- levelplot(protect_all_map_rst_r,
                          # par.settings=mapTheme, 
                          maxpixels = 1e7, 
                          main='    (a)',
                          xlab=NULL,
                          ylab=NULL,
                          colorkey=F,
                          #colorkey=list(space='right', width=2, height=1/20),
                          col.regions=c('forestgreen'))+ layer(sp.lines(coast_lines, col="black", lwd=0.5))



###########################
##                       ##
##  biodiversity index   ##
##                       ##
###########################


# read into biodiversity index data

biodindex <- raster("currentzonation.rank.compressed1.tif")
biodindex[biodindex<0.95] =NA
biodindex[!is.na(biodindex)] = 1

# expand to resolution of 1/48
biodindex_48 <- kronecker(as.matrix(biodindex), matrix(rep(1,24*24), nrow = 24))
biodindex_48[is.na(biodindex_48)] <- 0


biodindex_48_95 <- biodindex_48
biodindex_48_95[biodindex_48==0] <- NA

biodindex_48_95_rst <- raster(biodindex_48_95, xmn=-180, xmx=180, ymn=-90, ymx=90,
       crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 ')

biodindex_48_95_rst_r <- ratify(biodindex_48_95_rst)

rat_index <- levels(biodindex_48_95_rst_r)[[1]]
rat_index$policy <- c('Biodiversity\nprotection')
#rat$class <- c('A1', 'B2')
levels(biodindex_48_95_rst_r) <- rat_index

plt_bioindex <- levelplot(biodindex_48_95_rst_r,
                 # par.settings=mapTheme, 
                 maxpixels = 1e7, 
                 main='    (b)',
                 xlab=NULL,
                 ylab=NULL,
                 colorkey=F,
                 #colorkey=list(space='right', width=2, height=1/20),
                 col.regions=c('forestgreen'))+ layer(sp.lines(coast_lines, col="black", lwd=0.5))


#png(filename = "C:\\Users\\wuwenchao\\Desktop\\policydataRR\\maps\\four_figures.png", 
#    width = 12*0.8, height = 7*0.8, units = 'in', res = 1000)

jpeg(filename = "../../../anal_output_r\\Figure 2. four_figures_dpi600.jpg", 
    width = 12*0.8, height = 7*0.8, units = 'in', res = 600)

grid.arrange(plt_protectedall, plt_bioindex, plt_severeld, plt_seriousld, ncol=2)

dev.off()

###################################################
##                                               ##
##             5. full policy    map             ##
##                                               ##         
###################################################

biod_cb <- biodindex_48|protect_all_map

#plot(raster(protect_all_map))
#plot(raster(biod_cb))


serious_land_allpolicy_map_exclude <- serious_land_allpolicy_map

serious_land_allpolicy_map_exclude[biod_cb==1] <- 0

#plot(raster(serious_land_allpolicy_map))
#plot(raster(serious_land_allpolicy_map_exclude))

#plot(raster(serious_land_allpolicy_map_exclude+biod_cb))


##

serious_land_allpolicy_map_exclude[serious_land_allpolicy_map_exclude==1] =2

all_map_matrix <- serious_land_allpolicy_map_exclude+biod_cb

all_map_matrix[all_map_matrix==0] <- NA

all_map_matrix_rst <- raster(all_map_matrix, xmn=-180, xmx=180, ymn=-90, ymx=90,
                             crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 ')

# 1: biodiversity, 2: soil
fwrite(all_map_matrix, '../../../anal_output_r/all_map_matrix.csv', row.names = F, col.names = F)

all_map_matrix_rst_r <- ratify(all_map_matrix_rst)

rat <- levels(all_map_matrix_rst_r)[[1]]
rat$policy <- c( '\nBiodiversity\nprotection', 'Soil\nprotection')
#rat$class <- c('A1', 'B2')
levels(all_map_matrix_rst_r) <- rat

plt <- levelplot(all_map_matrix_rst_r,
                 # par.settings=mapTheme, 
                 maxpixels = 1e8, 
                 xlab=NULL,
                 ylab=NULL,
                 colorkey=list(space='right', width=2, height=1/10),
                 col.regions=c('forestgreen', '#ffa500'))

#pdf('full_policy.pdf', width = 12, height = 6)

#png(filename = "C:\\Users\\wuwenchao\\Desktop\\policydataRR\\maps\\full_policy.png", 
#    width = 12, height = 6, units = 'in', res = 1000)

jpeg(filename = "../../../anal_output_r\\Figure 3. full_policy_dpi600.jpg", 
    width = 12, height = 6, units = 'in', res = 600)

plt + layer(sp.lines(coast_lines, col="black", lwd=0.5))

dev.off()




###############################################
##      
##          yield map
##
##############################################



yield <- fread('swi_mis_avg.csv', 
                        head=F) %>% as.matrix()
yield_na <- yield*2
yield_na[yield==0] <- NA

yield_na_rst <- raster(yield_na, xmn=-180, xmx=180, ymn=-90, ymx=90,
                       crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

#plot(yield_na_rst)

yieldTheme <- rasterTheme(region= rev(brewer.pal(11,"RdYlBu")))

plt_yield <- levelplot(yield_na_rst,
                       margin=F,
                 # par.settings=mapTheme, 
                 maxpixels = 1e7, 
                 xlab=NULL,
                 ylab=NULL,
                 colorkey=list(space='right', width=2, height=1/2, tick.number=4, at=seq(0,80,0.8)),
                 par.settings = yieldTheme)




#png(filename = "C:\\Users\\wuwenchao\\Desktop\\policydataRR\\maps\\yieldmap_1.png", 
#    width = 12, height = 6, units = 'in', res = 1000)

jpeg(filename = "../../../anal_output_r\\Figure 4. yieldmap_1dpi600.jpg", 
    width = 12, height = 6, units = 'in', res = 600)

plt_yield+ layer(sp.lines(coast_lines, col="black", lwd=0.5))


dev.off()


############################################
##                                        ##
##          quantity map                  ##
##                                        ##
############################################



quantity_mat <- fread("../../../anal_output_r/potential_map.csv", header = T) %>%
  as.matrix() %>%
  raster(xmn=-180, xmx=180, ymn=-90, ymx=90,
         crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')




potentialTheme <- rasterTheme(region= (brewer.pal(9,"Reds")))

plt_potential <- levelplot(quantity_mat,
                       margin=F,
                       # par.settings=mapTheme, 
                       maxpixels = 1e6, 
                       xlab=NULL,
                       ylab=NULL,
                       colorkey=list(space='right', width=2, height=1/2, at=seq(0,0.16,0.002)),
                       par.settings = potentialTheme)

#png(filename = "C:\\Users\\wuwenchao\\Desktop\\policydataRR\\maps\\potential_map.png", 
#    width = 12, height = 6, units = 'in', res = 1000)

jpeg(filename = "../../../anal_output_r\\Figure 8. potential_map_dpi600.jpg", 
    width = 12, height = 6, units = 'in', res = 600)

plt_potential + layer(sp.lines(coast_lines, col="black", lwd=0.5))

dev.off()



