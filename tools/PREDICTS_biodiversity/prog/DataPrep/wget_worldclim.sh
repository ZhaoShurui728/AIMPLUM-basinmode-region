#!/bin/bash

#---- Name and Path specification 
GCM="ACCESS-CM2 CMCC-ESM2 EC-Earth3-Veg FIO-ESM-2-0 GISS-E2-1-G INM-CM5-0 
IPSL-CM6A-LR MIROC6 MPI-ESM1-2-HR MRI-ESM2-0 UKESM1-0-LL"
SSP="ssp126 ssp245 ssp370 ssp585"
Year="2021-2040 2041-2060 2061-2080 2081-2100"
#DataDir=/data/SharedData/PREDICTSData/ # if use in cluster computer
DataDir=../output/tmp/ # if use in local
cd ${DataDir}
echo ${DataDir}
mkdir WorldClim
cd WorldClim

# Get Future climate data
for Sce in ${SSP}
do
  for Mn in ${GCM}
    do 
      for Yval in ${Year}
      do
      mkdir -p ${Mn}/${Sce}
      cd ${Mn}/${Sce}
      wget -nc https://geodata.ucdavis.edu/cmip6/10m/${Mn}/${Sce}/wc2.1_10m_bioc_${Mn}_${Sce}_${Yval}.tif
      cd ../../
      done
  done
done 
# Get Historical climate data and elevation data
mkdir Historical 
cd Historical
wget -nc https://geodata.ucdavis.edu/climate/worldclim/2_1/base/wc2.1_10m_bio.zip
unzip wc2.1_10m_bio.zip
tar -xzvf wc2.1_10m_bio.zip
wget -nc https://geodata.ucdavis.edu/climate/worldclim/2_1/base/wc2.1_10m_elev.zip
unzip wc2.1_10m_elev.zip
tar -xzvf wc2.1_10m_elev.zip

cd ../../../../PREDICTS