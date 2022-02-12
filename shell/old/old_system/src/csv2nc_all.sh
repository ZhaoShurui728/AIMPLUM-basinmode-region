
sce=$1
clp=$2
iav=$3
projectname=$4;
lumip=$5
bioyielcal=$6
BTC3option=$7
ssprcp=$8

SceName=${sce}_${clp}_${iav}
Today=`date '+%Y%m%d'`
ncgenfunc(){
  if [ $5 == 1 ]; then
    cat ../output/csv/$4.txt $3 ../output/csv/final.txt > ../output/cdl/$1_$2.cdl
  else
    cat ../output/csv/$4.txt $3 ../output/csv/pixel_area.csv ../output/csv/final.txt > ../output/cdl/$1_$2.cdl
  fi
  ncgen -o ../output/nc/$1_$2.nc ../output/cdl/$1_$2.cdl
  rm $3 ../output/cdl/$1_$2.cdl
}

#For LUMIP 
    if [ ${lumip} == on ]; then
      filelist="../output/csv/${SceName}/c3ann.csv ../output/csv/${SceName}/c3nfx.csv ../output/csv/${SceName}/c4ann.csv ../output/csv/${SceName}/crpbf_c4ann.csv ../output/csv/${SceName}/irrig_c3ann.csv ../output/csv/${SceName}/irrig_c3nfx.csv ../output/csv/${SceName}/irrig_c4ann.csv ../output/csv/${SceName}/pastr.csv ../output/csv/${SceName}/primf.csv ../output/csv/${SceName}/range.csv ../output/csv/${SceName}/secdf.csv ../output/csv/${SceName}/urban.csv ../output/csv/${SceName}/flood.csv ../output/csv/${SceName}/fallow.csv"
      ncgenfunc lumip ${SceName} "${filelist}" ncheader_all_lumip 1
    fi
#Bioenergy yield
    if [ ${bioyielcal} == on ]; then
      filelist="../output/csv/${SceName}/yield_BIO.csv"
      ncgenfunc yield ${SceName} "${filelist}" ncheader_all_yield 1
    fi
#Bending the curve 
    if [ ${BTC3option} == on ]; then
      filelist="../output/csv/${SceName}/${SceName}_opt1.csv ../output/csv/${SceName}/${SceName}_opt3.csv  ../output/csv/${SceName}/${SceName}_opt5.csv"
      ncgenfunc AIM-LUmap ${SceName} "${filelist}" ncheader_all_wwf_landcategoryall 2
    fi
#Default SSP-RCP-land use date creation 
    if [ ${ssprcp} == on ]; then
      filelist="../output/csv/${SceName}/AFR.csv ../output/csv/${SceName}/BIO.csv ../output/csv/${SceName}/CL.csv ../output/csv/${SceName}/PRMFRS.csv ../output/csv/${SceName}/MNGFRS.csv ../output/csv/${SceName}/OL.csv ../output/csv/${SceName}/GL.csv ../output/csv/${SceName}/PAS.csv ../output/csv/${SceName}/SL.csv"
      ncgenfunc all ${SceName} "${filelist}" ncheader_all 1
    fi

#exit 0

