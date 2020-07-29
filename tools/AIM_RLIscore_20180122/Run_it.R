# Before running this script, please create a folder under \AIMgdx\ with whatver name
# you like (I use version name, v1, v2, ...), and store the gdx file under it 

# use the follwoing code to install packages, 
packagesList <- c('raster', 'dplyr', 'data.table', 'reshape2', 'ggplot2',
                  'stacomirtools', 'qdap', 'lazyeval')
installFun <- function(package_name){
  if(!require(package_name)){install.packages(package_name)}
}
sapply(packagesList, installFun)

# gdxrrw needs to be installed from local, source file is under \AIM
# windows: gdxrrw_1.0.3.zip
# mac: gdxrrw_1.0.3.tgz
# linux : gdxrrw_1.0.3_r_x86_64-redhat-linux-gnu.tar.gz

# load packages
library(raster)
library(dplyr)
library(data.table)
library(reshape2)
library(ggplot2)
library(stacomirtools)
library(qdap)
library(lazyeval) # for dynamic names in mutate()

library(gdxrrw)
# specify gams directory
igdx("C:\\GAMS\\win64\\24.8")

options(digits = 22)

# set working directory if necessary
setwd("D:\\Dropbox\\To_Hasegawa\\20171222bend\\AIM")

# define the version, version name should be the same as the folder name created under \AIMgdx\
# e.g. 'v1', 'v2', 'v3', ...

version = 'v3'

# 1. Convert gdx to csv
# the converted csv file is stored under the following directory for next step
# \RLIscore_forAIM\input_scenarios\version
# meanwhile, map files is under '\pdfOutput\version', refelect the AIM resolution to AgMIP resolution
source("AIM2AgMIP.R") 
convertFun(version)

# 2. Calculate indices
# the output index file is 
# \RLIscore_forAIM\output\BiodivIndicator_trends_AIM_version.csv
source('RLIscore_forAIM\\RLI_score_reg_20Dec2017_v2.R')
indexFun(version)

# 3. Plot index
# the pdf file is 
# \RLIscore_forAIM\BiodivIndicator_trends_AIM_version.pdf
source('RLIscore_forAIM\\AIM_plotScore.R')
plotScore(version)

# 4. plot AIM land use map in 2 * 2 resolution
# pdf files are under 
# \RLIscore_forAIM\AIM_LUmap\version
source('RLIscore_forAIM\\AIM_LUmapFun.R')
plotAIMfun(version)



