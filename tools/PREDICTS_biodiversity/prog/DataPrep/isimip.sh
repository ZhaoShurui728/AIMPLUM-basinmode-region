#!/bin/sh

# wget climate data
#directorysetting
DataDir=/data/SharedData/ISIMIPData/ISIMIP3b/ClimateForcing/Atmosphere
PROGHOME=/data/Individual/shirabaru/Biodiversity/output/PREDICTS_data/ISIMIP/data
txtDir=/data/Individual/shirabaru/Biodiversity/output/PREDICTS_data/ISIMIP/txt

#<<COMMENTOUT
cd ${DataDir}
#-------- making directories
dirlist="GFDL-ESM4 IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 UKESM1-0-LL"

for fl in ${dirlist} 
do
  mkdir -pm 777 ${fl}
done

for Climate in MRI-ESM2-0 UKESM1-0-LL MPI-ESM1-2-HR
do

 for time in historical picontrol ssp126 ssp370 ssp585
 do 
  mkdir -pm 777 ${DataDir}/${Climate}/${time}

  for variable in tasmax tasmin
  do 
   cd ${DataDir}/${Climate}/${time}  
   
   grep $time ${txtDir}/${Climate}.txt> ${txtDir}/${Climate}_${time}.txt 
   grep $variable ${txtDir}/${Climate}_${time}.txt> ${Climate}_${time}_${variable}.txt 
   wget -ci ${Climate}_${time}_${variable}.txt
   rm ${Climate}_${time}.txt
   rm ${Climate}_${time}_${variable}.txt
  done
  
 done   

done
COMMENTOUT

# process  climate data
#directorysetting
DataDir=/data/SharedData/ISIMIPData/ISIMIP3b/ClimateForcing/Atmosphere
PROGHOME=/data/Individual/shirabaru/Biodiversity/output/PREDICTS_data/ISIMIP/data
txtDir=/data/Individual/shirabaru/Biodiversity/output/PREDICTS_data/ISIMIP/txt
BioclimDir=/data/Individual/shirabaru/Biodiversity/output/PREDICTS_data/bioclim

#<<COMMENTOUT
cd ${DataDir}
#-------- making directories
dirlist="${Climate} IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 UKESM1-0-LL"

for fl in ${dirlist} 
do
  mkdir -pm 777 ${fl}
done

for Climate in GFDL-ESM4 IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 
do
 
 Climate_lower=$(echo "$Climate" | tr '[:upper:]' '[:lower:]')

 for time in ssp126 ssp370 ssp585
 do 
  mkdir -pm 755 ${BioclimDir}/${Climate}/${time}
  cd ${BioclimDir}/${Climate}/${time}  

  for time2 in 2021_2030 2031_2040 2041_2050 2051_2060 2061_2070 2071_2080 2081_2090 2091_2100
  do

    cdo yearmax ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_tasmax_global_daily_${time2}.nc ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmax.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmax.nc ${BioclimDir}/${Climate}/${time}/bio5_${time2}.nc

    # bio6
    cdo yearmin ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_tasmin_global_daily_${time2}.nc ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmin.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmin.nc ${BioclimDir}/${Climate}/${time}/bio6_${time2}.nc

    # bio13
    cdo monsum ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_pr_global_daily_${time2}.nc ${BioclimDir}/${Climate}/${time}/pr_${time2}_monsum.nc
    cdo yearmax ${BioclimDir}/${Climate}/${time}/pr_${time2}_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmax_monsum.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/bio13_${time2}.nc

    # bio14
    cdo yearmin ${BioclimDir}/${Climate}/${time}/pr_${time2}_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmin_monsum.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/bio14_${time2}.nc
  done

 done   

done

# UKESM1-0-LL
for time in ssp126 ssp370 ssp585
 do 
  mkdir -pm 755 ${BioclimDir}/UKESM1-0-LL/${time}
  cd ${BioclimDir}/UKESM1-0-LL/${time}  

  for time2 in 2021_2030 2031_2040 2041_2050 2051_2060 2061_2070 2071_2080 2081_2090 2091_2100
  do

    cdo yearmax ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_tasmax_global_daily_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmax.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmax.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio5_${time2}.nc

    # bio6
    cdo yearmin ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_tasmin_global_daily_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmin.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmin.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio6_${time2}.nc

    # bio13
    cdo monsum ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_pr_global_daily_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_monsum.nc
    cdo yearmax ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmax_monsum.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmax_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio13_${time2}.nc

    # bio14
    cdo yearmin ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmin_monsum.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmin_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio14_${time2}.nc
  done

done   
#COMMENTOUT

#<<COMMENTOUT
# multiyear mean
for Climate in GFDL-ESM4 IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 UKESM1-0-LL
do

 for time in ssp126 ssp370 ssp585
 do 
  cd ${BioclimDir}/${Climate}/${time}

  for variable in bio5 bio6 bio13 bio14
  do

    cdo mergetime ${BioclimDir}/${Climate}/${time}/${variable}_2021_2030.nc ${BioclimDir}/${Climate}/${time}/${variable}_2031_2040.nc ${BioclimDir}/${Climate}/${time}/${variable}_2021_2040.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/${variable}_2021_2040.nc ${BioclimDir}/${Climate}/${time}/${variable}_2030.nc

    cdo mergetime ${BioclimDir}/${Climate}/${time}/${variable}_2041_2050.nc ${BioclimDir}/${Climate}/${time}/${variable}_2051_2060.nc ${BioclimDir}/${Climate}/${time}/${variable}_2041_2060.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/${variable}_2041_2060.nc ${BioclimDir}/${Climate}/${time}/${variable}_2050.nc

    cdo mergetime ${BioclimDir}/${Climate}/${time}/${variable}_2061_2070.nc ${BioclimDir}/${Climate}/${time}/${variable}_2071_2080.nc ${BioclimDir}/${Climate}/${time}/${variable}_2061_2080.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/${variable}_2061_2080.nc ${BioclimDir}/${Climate}/${time}/${variable}_2070.nc

    cdo mergetime ${BioclimDir}/${Climate}/${time}/${variable}_2081_2090.nc ${BioclimDir}/${Climate}/${time}/${variable}_2091_2100.nc ${BioclimDir}/${Climate}/${time}/${variable}_2081_2100.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/${variable}_2081_2100.nc ${BioclimDir}/${Climate}/${time}/${variable}_2090.nc

  done

 done   

done

# take median within GCM prediction
for time in ssp126 ssp370 ssp585
do 
  mkdir -pm 755 ${BioclimDir}/GCMmedian/${time}

  for variable in bio5 bio6 bio13 bio14
  do
    
    for time2 in 2030 2050 2070 2090
    do
    cdo ensmedian ${BioclimDir}/GFDL-ESM4/${time}/${variable}_${time2}.nc ${BioclimDir}/IPSL-CM6A-LR/${time}/${variable}_${time2}.nc ${BioclimDir}/MPI-ESM1-2-HR/${time}/${variable}_${time2}.nc ${BioclimDir}/MRI-ESM2-0/${time}/${variable}_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/${variable}_${time2}.nc ${BioclimDir}/GCMmedian/${time}/${variable}_${time2}.nc
    done

  done

done   

for variable in bio5 bio6 bio13 bio14
do
  for time in ssp126 ssp370 ssp585
  do
  cdo mergetime ${BioclimDir}/GCMmedian/${time}/${variable}_2030.nc ${BioclimDir}/GCMmedian/${time}/${variable}_2050.nc ${BioclimDir}/GCMmedian/${time}/${variable}_2070.nc ${BioclimDir}/GCMmedian/${time}/${variable}_2090.nc ${BioclimDir}/GCMmedian/${time}/${variable}.nc
  done
done
#COMMENTOUT

for Climate in GFDL-ESM4 IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0
do
 mkdir -pm 755 ${BioclimDir}/tmp

 Climate_lower=$(echo "$Climate" | tr '[:upper:]' '[:lower:]')

 for time in historical
 do 
  mkdir -pm 755 ${BioclimDir}/${Climate}/${time}
  cd ${BioclimDir}/${Climate}/${time}  

  for time2 in 1901_1910 1911_1920 1921_1930 1971_1980 1981_1990 1991_2000 2001_2010
  do

    # bio5
    cdo yearmax ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_tasmax_global_daily_${time2}.nc ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmax.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmax.nc ${BioclimDir}/${Climate}/${time}/bio5_${time2}.nc

    # bio6
    cdo yearmin ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_tasmin_global_daily_${time2}.nc ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmin.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/tas_${time2}_yearmin.nc ${BioclimDir}/${Climate}/${time}/bio6_${time2}.nc

    # bio13
    cdo monsum ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_pr_global_daily_${time2}.nc ${BioclimDir}/${Climate}/${time}/pr_${time2}_monsum.nc
    cdo yearmax ${BioclimDir}/${Climate}/${time}/pr_${time2}_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmax_monsum.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/bio13_${time2}.nc

    # bio14
    cdo yearmin ${BioclimDir}/${Climate}/${time}/pr_${time2}_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmin_monsum.nc
    cdo runmean,10 ${BioclimDir}/${Climate}/${time}/pr_${time2}_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/bio14_${time2}.nc
  done

    # 2011 1014
    # bio5
    cdo yearmax ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_tasmax_global_daily_2011_2014.nc ${BioclimDir}/${Climate}/${time}/tas_2011_2014_yearmax.nc
    cdo runmean,4 ${BioclimDir}/${Climate}/${time}/tas_2011_2014_yearmax.nc ${BioclimDir}/${Climate}/${time}/bio5_2011_2014.nc

    # bio6
    cdo yearmin ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_tasmin_global_daily_2011_2014.nc ${BioclimDir}/${Climate}/${time}/tas_2011_2014_yearmin.nc
    cdo runmean,4 ${BioclimDir}/${Climate}/${time}/tas_2011_2014_yearmin.nc ${BioclimDir}/${Climate}/${time}/bio6_2011_2014.nc

    # bio13
    cdo monsum ${DataDir}/${Climate}/${time}/${Climate_lower}_r1i1p1f1_w5e5_${time}_pr_global_daily_2011_2014.nc ${BioclimDir}/${Climate}/${time}/pr_2011_2014_monsum.nc
    cdo yearmax ${BioclimDir}/${Climate}/${time}/pr_2011_2014_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_2011_2014_yearmax_monsum.nc
    cdo runmean,4 ${BioclimDir}/${Climate}/${time}/pr_2011_2014_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/bio13_2011_2014.nc

    # bio14
    cdo yearmin ${BioclimDir}/${Climate}/${time}/pr_2011_2014_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_2011_2014_yearmin_monsum.nc
    cdo runmean,4 ${BioclimDir}/${Climate}/${time}/pr_2011_2014_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/bio14_2011_2014.nc

 done   

done

# UKESM1-0-LL
for time in historical
 do 
  mkdir -pm 755 ${BioclimDir}/UKESM1-0-LL/${time}
  cd ${BioclimDir}/UKESM1-0-LL/${time}  

  for time2 in 1901_1910 1911_1920 1921_1930 1971_1980 1981_1990 1991_2000 2001_2010 
  do
    # bio5 
    cdo yearmax ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_tasmax_global_daily_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmax.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmax.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio5_${time2}.nc

    # bio6
    cdo yearmin ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_tasmin_global_daily_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmin.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/tas_${time2}_yearmin.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio6_${time2}.nc

    # bio13
    cdo monsum ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_pr_global_daily_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_monsum.nc
    cdo yearmax ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmax_monsum.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmax_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio13_${time2}.nc

    # bio14
    cdo yearmin ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmin_monsum.nc
    cdo runmean,10 ${BioclimDir}/UKESM1-0-LL/${time}/pr_${time2}_yearmin_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio14_${time2}.nc
  done
    # 2011 1014
    # bio5
    cdo yearmax ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_tasmax_global_daily_2011_2014.nc ${BioclimDir}/UKESM1-0-LL/${time}/tas_2011_2014_yearmax.nc
    cdo runmean,4 ${BioclimDir}/UKESM1-0-LL/${time}/tas_2011_2014_yearmax.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio5_2011_2014.nc

    # bio6
    cdo yearmin ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_tasmin_global_daily_2011_2014.nc ${BioclimDir}/UKESM1-0-LL/${time}/tas_2011_2014_yearmin.nc
    cdo runmean,4 ${BioclimDir}/UKESM1-0-LL/${time}/tas_2011_2014_yearmin.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio6_2011_2014.nc

    # bio13
    cdo monsum ${DataDir}/UKESM1-0-LL/${time}/ukesm1-0-ll_r1i1p1f2_w5e5_${time}_pr_global_daily_2011_2014.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_monsum.nc
    cdo yearmax ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_yearmax_monsum.nc
    cdo runmean,4 ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_yearmax_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio13_2011_2014.nc

    # bio14
    cdo yearmin ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_yearmin_monsum.nc
    cdo runmean,4 ${BioclimDir}/UKESM1-0-LL/${time}/pr_2011_2014_yearmin_monsum.nc ${BioclimDir}/UKESM1-0-LL/${time}/bio14_2011_2014.nc

done   
COMMENTOUT
# multiyear mean
for Climate in GFDL-ESM4 IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 UKESM1-0-LL
do

 for time in historical
 do 
  cd ${BioclimDir}/${Climate}/${time}

  for variable in bio5 bio6 bio13 bio14
  do

    # cdo mergetime ${BioclimDir}/${Climate}/${time}/${variable}_1901_1910.nc ${BioclimDir}/${Climate}/${time}/${variable}_1911_1920.nc ${BioclimDir}/${Climate}/${time}/${variable}_1921_1930.nc ${BioclimDir}/${Climate}/${time}/${variable}_1901_1930.nc
    # cdo timmean ${BioclimDir}/${Climate}/${time}/${variable}_1901_1930.nc ${BioclimDir}/${Climate}/${time}/${variable}_1901_1930_mean.nc

    # cdo mergetime ${BioclimDir}/${Climate}/${time}/${variable}_1971_1980.nc ${BioclimDir}/${Climate}/${time}/${variable}_1981_1990.nc ${BioclimDir}/${Climate}/${time}/${variable}_1991_2000.nc ${BioclimDir}/${Climate}/${time}/${variable}_1971_2000.nc
    # cdo timmean ${BioclimDir}/${Climate}/${time}/${variable}_1971_2000.nc ${BioclimDir}/${Climate}/${time}/${variable}_1971_2000_mean.nc

    # cdo selyear,1996,1997,1998,1999,2000 ${BioclimDir}/${Climate}/${time}/tas_1991_2000_yearmax.nc ${BioclimDir}/${Climate}/${time}/tas_1996_2000_yearmax.nc
    # cdo selyear,1996,1997,1998,1999,2000 ${BioclimDir}/${Climate}/${time}/tas_1991_2000_yearmin.nc ${BioclimDir}/${Climate}/${time}/tas_1996_2000_yearmin.nc
    # cdo selyear,1996,1997,1998,1999,2000 ${BioclimDir}/${Climate}/${time}/pr_1991_2000_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_1996_2000_yearmax_monsum.nc
    # cdo selyear,1996,1997,1998,1999,2000 ${BioclimDir}/${Climate}/${time}/pr_1991_2000_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_1996_2000_yearmin_monsum.nc
    
    #cdo mergetime ${BioclimDir}/${Climate}/${time}/tas_1996_2000_yearmax.nc ${BioclimDir}/${Climate}/${time}/tas_2001_2010_yearmax.nc ${BioclimDir}/${Climate}/${time}/tas_2011_2014_yearmax.nc ${BioclimDir}/${Climate}/${time}/tas_1996_2014_yearmax.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/tas_1996_2014_yearmax.nc ${BioclimDir}/${Climate}/${time}/bio5_2005.nc
    #cdo mergetime ${BioclimDir}/${Climate}/${time}/tas_1996_2000_yearmin.nc ${BioclimDir}/${Climate}/${time}/tas_2001_2010_yearmin.nc ${BioclimDir}/${Climate}/${time}/tas_2011_2014_yearmin.nc ${BioclimDir}/${Climate}/${time}/tas_1996_2014_yearmin.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/tas_1996_2014_yearmin.nc ${BioclimDir}/${Climate}/${time}/bio6_2005.nc
    #cdo mergetime ${BioclimDir}/${Climate}/${time}/pr_1996_2000_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_2001_2010_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_2011_2014_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_1996_2014_yearmax_monsum.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/pr_1996_2014_yearmax_monsum.nc ${BioclimDir}/${Climate}/${time}/bio13_2005.nc
    #cdo mergetime ${BioclimDir}/${Climate}/${time}/pr_1996_2000_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_2001_2010_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_2011_2014_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/pr_1996_2014_yearmin_monsum.nc
    cdo timmean ${BioclimDir}/${Climate}/${time}/pr_1996_2014_yearmin_monsum.nc ${BioclimDir}/${Climate}/${time}/bio14_2005.nc

  done

 done   

done

# take median within GCM prediction
for time in historical
do 
  mkdir -pm 755 ${BioclimDir}/GCMmedian/${time}

  for variable in bio5 bio6 bio13 bio14
  do
    
    for time2 in 1901_1930_mean 1971_2000_mean 2005
    do
    cdo ensmedian ${BioclimDir}/GFDL-ESM4/${time}/${variable}_${time2}.nc ${BioclimDir}/IPSL-CM6A-LR/${time}/${variable}_${time2}.nc ${BioclimDir}/MPI-ESM1-2-HR/${time}/${variable}_${time2}.nc ${BioclimDir}/MRI-ESM2-0/${time}/${variable}_${time2}.nc ${BioclimDir}/UKESM1-0-LL/${time}/${variable}_${time2}.nc ${BioclimDir}/GCMmedian/${time}/${variable}_${time2}.nc
    done

  done

done   
