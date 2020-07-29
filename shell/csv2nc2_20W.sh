cp ../data/ncheader_all_lumip.txt ../output/csv/ncheader_all_lumip.txt
cp ../data/ncheader_all.txt ../output/csv/ncheader_all.txt
cp ../data/final.txt ../output/csv/final.txt
cp ../data/ncheader_all_yield.txt ../output/csv/ncheader_all_yield.txt
cp ../data/ncheader_all_aimssprcplu_landcategory.txt ../output/csv/ncheader_all_aimssprcplu_landcategory.txt
cp ../data/ncheader_all_wwf.txt ../output/csv/ncheader_all_wwf.txt
cp ../data/ncheader_all_wwf2.txt ../output/csv/ncheader_all_wwf2.txt
cp ../data/ncheader_all_wwf_landcategory.txt ../output/csv/ncheader_all_wwf_landcategory.txt
cp ../data/ncheader_all_wwf_landcategory2.txt ../output/csv/ncheader_all_wwf_landcategory2.txt

for ncfilename in SSP1-Baseline SSP1-45 SSP1-34 SSP1-26 SSP1-19 SSP2-Baseline SSP2-60 SSP2-45 SSP2-34 SSP2-26 SSP2-19 SSP3-Baseline SSP3-60 SSP3-45 SSP3-34 SSP4-Baseline SSP4-45 SSP4-34 SSP4-26 SSP5-Baseline SSP5-60 SSP5-45 SSP5-34 SSP5-26
#for ncfilename in SSP2-Baseline
#for ncfilename in SSP2-Baseline SSP2-60 SSP2-45 SSP2-34 SSP2-26 SSP2-19 SSP1-Baseline SSP1-45
do
for date in v.1.0.1
do

#	if [ "${ncfilename}" = "RCPref_SSP2_NOBIOD" ] ; then sce="SSP2"; clp="BaU"; iav="NoCC"; fi

	if [ "${ncfilename}" = "SSP1-Baseline" ] ; then sce="SSP1"; clp="BaU"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP1-45" ] ; then sce="SSP1"; clp="45W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP1-34" ] ; then sce="SSP1"; clp="37W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP1-26" ] ; then sce="SSP1"; clp="26W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP1-19" ] ; then sce="SSP1"; clp="20W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP2-Baseline" ] ; then sce="SSP2"; clp="BaU"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP2-60" ] ; then sce="SSP2"; clp="60W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP2-45" ] ; then sce="SSP2"; clp="45W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP2-34" ] ; then sce="SSP2"; clp="37W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP2-26" ] ; then sce="SSP2"; clp="26W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP2-19" ] ; then sce="SSP2"; clp="20W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP3-Baseline" ] ; then sce="SSP3"; clp="BaU"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP3-60" ] ; then sce="SSP3"; clp="60W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP3-45" ] ; then sce="SSP3"; clp="45W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP3-34" ] ; then sce="SSP3"; clp="37W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP4-Baseline" ] ; then sce="SSP4"; clp="BaU"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP4-45" ] ; then sce="SSP4"; clp="45W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP4-34" ] ; then sce="SSP4"; clp="37W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP4-26" ] ; then sce="SSP4"; clp="26W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP5-Baseline" ] ; then sce="SSP5"; clp="BaU"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP5-60" ] ; then sce="SSP5"; clp="60W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP5-45" ] ; then sce="SSP5"; clp="45W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP5-34" ] ; then sce="SSP5"; clp="37W"; iav="NoCC"; fi
	if [ "${ncfilename}" = "SSP5-26" ] ; then sce="SSP5"; clp="26W"; iav="NoCC"; fi

echo ${sce}_${clp}_${iav}

#cat ../output/csv/ncheader_all_lumip.txt ../output/csv/${sce}_${clp}_${iav}/c3ann.csv ../output/csv/${sce}_${clp}_${iav}/c3nfx.csv ../output/csv/${sce}_${clp}_${iav}/c4ann.csv ../output/csv/${sce}_${clp}_${iav}/crpbf_c4ann.csv ../output/csv/${sce}_${clp}_${iav}/irrig_c3ann.csv ../output/csv/${sce}_${clp}_${iav}/irrig_c3nfx.csv ../output/csv/${sce}_${clp}_${iav}/irrig_c4ann.csv ../output/csv/${sce}_${clp}_${iav}/pastr.csv ../output/csv/${sce}_${clp}_${iav}/primf.csv ../output/csv/${sce}_${clp}_${iav}/range.csv ../output/csv/${sce}_${clp}_${iav}/secdf.csv ../output/csv/${sce}_${clp}_${iav}/urban.csv ../output/csv/${sce}_${clp}_${iav}/flood.csv ../output/csv/${sce}_${clp}_${iav}/fallow.csv ../output/csv/final.txt > ../output/cdl/${sce}_${clp}_${iav}_lumip.cdl

#ncgen -o ../output/nc/${sce}_${clp}_${iav}_lumip.nc ../output/cdl/${sce}_${clp}_${iav}_lumip.cdl

cat ../output/csv/ncheader_all_aimssprcplu_landcategory.txt ../output/csv/${sce}_${clp}_${iav}.csv ../output/csv/final.txt > ../output/cdl/${sce}_${clp}_${iav}.cdl


#ncgen -o ../output/nc/${sce}_${clp}_${iav}.nc ../output/cdl/${sce}_${clp}_${iav}.cdl
ncgen -o ../output/nc/AIM-SSPRCP-LUmap-${ncfilename}-${date}.nc -x ../output/cdl/${sce}_${clp}_${iav}.cdl

#cat ../output/csv/ncheader_all_yield.txt ../output/csv/${sce}_${clp}_${iav}/yield_BIO.csv ../output/csv/final.txt > ../output/cdl/yield_${sce}_${clp}_${iav}.cdl
#ncgen -o ../output/nc/yield_${sce}_${clp}_${iav}.nc ../output/cdl/yield_${sce}_${clp}_${iav}.cdl

done
done

exit 0

