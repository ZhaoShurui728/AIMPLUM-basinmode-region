# To creat NetCDF file of land use map, ascii files are generated.
MergeResCSV4NCRun() {
  source ../$1/shell/settings/$2.sh

  # abondonned land treatment option.
  OPT=(1 3 5)
  basecsv=$3
  BTC3option=$4
  lumip=$5
  bioyielcal=$6
  ssprcp=$7

	echo "`date '+%s'`" > ../output/txt/cpu/merge2/$2.txt

  # csv file created
  if [ ${basecsv} = "on" ]; then
  ## gdx files aggregation
    cd ../output/gdx/$2/analysis
    gdxmerge *.gdx output=../../results/results_$2.gdx
    cd ../../../../exe
    gams ../$1/prog/gdx2csv.gms --split=1 --sce=${SCE} --clp=${CLP} --iav=${IAV} MaxProcDir=100 S=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv1.lst
  fi

  if [ ${BTC3option} = "on" ]; then
    for O in ${OPT[@]} 
    do
      gams ../$1/prog/gdx2csv.gms --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --wwfopt=${O} --wwfclass=opt MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2.lst
    done
  fi

  if [ ${lumip} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --wwfopt=1 --lumip=on MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_lumip.lst
  fi

  if [ ${bioyielcal} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --bioyieldcalc=on MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_bioyielcal.lst
  fi

  if [ ${ssprcp} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --lumip=off --wwfclass=off MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_ssprcp.lst
  fi

#  rm ../output/gdx/results/results_$2.gdx
  echo $(TimeDif `cat ../output/txt/cpu/merge2/$2.txt`) > ../output/txt/cpu/merge2/end_$2.txt
  rm ../output/txt/cpu/merge2/$2.txt
}

MergeResCSV4NC() {
  rm ../output/txt/cpu/merge2/*.txt 2> /dev/null
  for S in ${scn[@]} 
  do
    MergeResCSV4NCRun ${parent_dir} ${S} ${Sub_MergeResCSV4NC_basecsv} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_ssprcp} &
    LoopmultiCPU 20 scn "merge2" ${CPUthreads}
  done
  wait
  echo "All merges have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
