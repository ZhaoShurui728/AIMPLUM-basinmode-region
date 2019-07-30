cp ../data/ncheader_all_lumip.txt ../output/csv/ncheader_all_lumip.txt
cp ../data/ncheader_all.txt ../output/csv/ncheader_all.txt
cp ../data/final.txt ../output/csv/final.txt
cp ../data/ncheader_all_yield.txt ../output/csv/ncheader_all_yield.txt
cp ../data/ncheader_all_wwf.txt ../output/csv/ncheader_all_wwf.txt
cp ../data/ncheader_all_wwf2.txt ../output/csv/ncheader_all_wwf2.txt
cp ../data/ncheader_all_wwf_landcategory.txt ../output/csv/ncheader_all_wwf_landcategory.txt

for ncfilename in RCPref_SSP2
do
for date in 14Mar18
do

	if [ "${ncfilename}" = "RCPref_SSP2_NOBIOD" ] ; then sce="SSP2"; clp="BaU"; iav="NoCC"; fi

echo ${sce}_${clp}_${iav}

#cat ../output/csv/ncheader_all_lumip.txt ../output/csv/${sce}_${clp}_${iav}/c3ann.csv ../output/csv/${sce}_${clp}_${iav}/c3nfx.csv ../output/csv/${sce}_${clp}_${iav}/c4ann.csv ../output/csv/${sce}_${clp}_${iav}/crpbf_c4ann.csv ../output/csv/${sce}_${clp}_${iav}/irrig_c3ann.csv ../output/csv/${sce}_${clp}_${iav}/irrig_c3nfx.csv ../output/csv/${sce}_${clp}_${iav}/irrig_c4ann.csv ../output/csv/${sce}_${clp}_${iav}/pastr.csv ../output/csv/${sce}_${clp}_${iav}/primf.csv ../output/csv/${sce}_${clp}_${iav}/range.csv ../output/csv/${sce}_${clp}_${iav}/secdf.csv ../output/csv/${sce}_${clp}_${iav}/urban.csv ../output/csv/${sce}_${clp}_${iav}/flood.csv ../output/csv/${sce}_${clp}_${iav}/fallow.csv ../output/csv/final.txt > ../output/cdl/${sce}_${clp}_${iav}_lumip.cdl

#ncgen -o ../output/nc/${sce}_${clp}_${iav}_lumip.nc ../output/cdl/${sce}_${clp}_${iav}_lumip.cdl

#cat ../output/csv/ncheader_all_wwf.txt ../output/csv/${sce}_${clp}_${iav}/AFR.csv ../output/csv/${sce}_${clp}_${iav}/BIO.csv ../output/csv/${sce}_${clp}_${iav}/CL.csv ../output/csv/${sce}_${clp}_${iav}/PRMFRS.csv ../output/csv/${sce}_${clp}_${iav}/MNGFRS.csv ../output/csv/${sce}_${clp}_${iav}/OL.csv ../output/csv/${sce}_${clp}_${iav}/GL.csv ../output/csv/${sce}_${clp}_${iav}/PAS.csv ../output/csv/${sce}_${clp}_${iav}/RES.csv ../output/csv/${sce}_${clp}_${iav}/SL.csv ../output/csv/final.txt > ../output/cdl/${sce}_${clp}_${iav}.cdl

#cat ../output/csv/ncheader_all_wwf2.txt ../output/csv/${sce}_${clp}_${iav}/cropland_other.csv ../output/csv/${sce}_${clp}_${iav}/cropland_bioenergySRP.csv ../output/csv/${sce}_${clp}_${iav}/grassland.csv ../output/csv/${sce}_${clp}_${iav}/forest_unmanaged.csv ../output/csv/${sce}_${clp}_${iav}/forest_managed.csv ../output/csv/${sce}_${clp}_${iav}/restored.csv ../output/csv/${sce}_${clp}_${iav}/other.csv ../output/csv/${sce}_${clp}_${iav}/built_up_areas.csv  ../output/csv/final.txt > ../output/cdl/${sce}_${clp}_${iav}.cdl

###cat ../output/csv/ncheader_all_wwf_landcategory.txt ../output/csv/${sce}_${clp}_${iav}.csv ../output/csv/final.txt > ../output/cdl/${sce}_${clp}_${iav}.cdl


#ncgen -o ../output/nc/${sce}_${clp}_${iav}.nc ../output/cdl/${sce}_${clp}_${iav}.cdl
ncgen -o ../output/nc/BendingTheCurveFT-LCproj-AIM-${ncfilename}-${date}.nc -x ../output/cdl/${sce}_${clp}_${iav}.cdl

#cat ../output/csv/ncheader_all_yield.txt ../output/csv/${sce}_${clp}_${iav}/yield_BIO.csv ../output/csv/final.txt > ../output/cdl/yield_${sce}_${clp}_${iav}.cdl
#ncgen -o ../output/nc/yield_${sce}_${clp}_${iav}.nc ../output/cdl/yield_${sce}_${clp}_${iav}.cdl

done
done

exit 0

