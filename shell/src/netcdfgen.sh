# To generate NetCDF files
netcdfgenRun() {
  
  source ../$1/shell/settings/$2.sh
  scenarioname=$2
  projectname=$3
  lumip=$4
  bioyielcal=$5
  BTC3option=$6
  ssprcp=$7

  SceName=${SCE}_${CLP}_${IAV}

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
}

netcdfgen() {
  FileCopyList=(ncheader_all_lumip ncheader_all final ncheader_all_yield ncheader_all_aimssprcplu_landcategory ncheader_all_wwf ncheader_all_wwf2 ncheader_all_wwf_landcategory ncheader_all_wwf_landcategory2 ncheader_all_wwf_landcategoryall)
  for F in ${FileCopyList[@]} 
  do 
    cp ../${parent_dir}/data/ncheader/${F}.txt ../output/csv/${F}.txt 
  done

  for S in ${scn[@]} 
  do
    netcdfgenRun ${parent_dir} ${S} ${sub_netcdfgen_projectname} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_ssprcp}
  done

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

