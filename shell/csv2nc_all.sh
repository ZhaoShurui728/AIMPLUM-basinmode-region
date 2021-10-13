
sce=$1
clp=$2
iav=$3
projectname=$4;
lumip=$5
bioyielcal2=$6
BTC3option=$7
ssprcp=$8

SceName=${sce}_${clp}_${iav}
Today=`date '+%Y%m%d'`
ncgenfunc(){
  ncgen -o ../output/nc/$1_$2.nc ../output/cdl/$1_$2.cdl
  rm $3 ../output/cdl/$1_$2.cdl
}

#For LUMIP 
    if [ ${lumip} == on ]; then
      filelist="../output/csv/${SceName}/c3ann.csv ../output/csv/${SceName}/c3nfx.csv ../output/csv/${SceName}/c4ann.csv ../output/csv/${SceName}/crpbf_c4ann.csv ../output/csv/${SceName}/irrig_c3ann.csv ../output/csv/${SceName}/irrig_c3nfx.csv ../output/csv/${SceName}/irrig_c4ann.csv ../output/csv/${SceName}/pastr.csv ../output/csv/${SceName}/primf.csv ../output/csv/${SceName}/range.csv ../output/csv/${SceName}/secdf.csv ../output/csv/${SceName}/urban.csv ../output/csv/${SceName}/flood.csv ../output/csv/${SceName}/fallow.csv"
      FileName=lumip
      cat ../output/csv/ncheader_all_lumip.txt ${filelist} ../output/csv/final.txt > ../output/cdl/all_${SceName}_lumip.cdl
      ncgenfunc ${FileName} ${SceName} "${filelist}"
    fi
#Bioenergy yield
    if [ ${bioyielcal2} == on ]; then
      filelist="../output/csv/${SceName}/yield_BIO.csv"
      FileName=yield
      cat ../output/csv/ncheader_all_yield.txt ${filelist} ../output/csv/final.txt > ../output/cdl/yield_${SceName}.cdl
      ncgenfunc ${FileName} ${SceName} "${filelist}"
#      ncgen -o ../output/nc/yield_${SceName}.nc ../output/cdl/yield_${SceName}.cdl
#      rm  ${filelist} ../output/cdl/yield_${SceName}.cdl
    fi
#Bending the curve 
    if [ ${BTC3option} == on ]; then
      filelist="../output/csv/${SceName}_opt1.csv ../output/csv/${SceName}_opt3.csv  ../output/csv/${SceName}_opt5.csv"
      FileName=AIM-LUmap
      cat ../output/csv/ncheader_all_wwf_landcategoryall.txt ${filelist} ../output/csv/pixel_area.csv ../output/csv/final.txt > ../output/cdl/${SceName}.cdl
      ncgenfunc ${FileName} ${SceName} "${filelist}"
#      ncgen -o ../output/nc/AIM-LUmap-${projectname}-${ncfilename}-${Today}.nc -x ../output/cdl/AIM-LUmap-${SceName}.cdl
#      rm ${filelist} ../output/cdl/AIM-LUmap-${SceName}.cdl
    fi
#Default SSP-RCP-land use date creation 
    if [ ${ssprcp} == on ]; then
      filelist="../output/csv/${SceName}/AFR.csv ../output/csv/${SceName}/BIO.csv ../output/csv/${SceName}/CL.csv ../output/csv/${SceName}/PRMFRS.csv ../output/csv/${SceName}/MNGFRS.csv ../output/csv/${SceName}/OL.csv ../output/csv/${SceName}/GL.csv ../output/csv/${SceName}/PAS.csv ../output/csv/${SceName}/SL.csv"
      FileName=all
      cat ../output/csv/ncheader_all.txt ${filelist} ../output/csv/final.txt > ../output/cdl/all_${SceName}.cdl
      ncgenfunc ${FileName} ${SceName} "${filelist}"
#      ncgen -o ../output/nc/all_${SceName}.nc ../output/cdl/all_${SceName}.cdl
#      rm ${filelist} ../output/cdl/all_${SceName}.cdl
    fi

exit 0

