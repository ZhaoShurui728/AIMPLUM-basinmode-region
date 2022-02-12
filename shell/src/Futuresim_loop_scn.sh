# Land allocation calculation
Futuresim_loop_scn_Run() {
  source ../$1/shell/settings/$2.sh
  declare -n COUNTRY=$3
  declare -n YEAR=$4
  biocurve=$5
  NormalRun=$6
  DisagrrFRS=$7
  CPLEXThreadOp=$8

  echo "`date '+%s'`" > ../output/txt/cpu/futuresim/$2.txt
  mkdir -p ../output/txt/cpu/futuresim/$2

  for A in ${COUNTRY[@]}
  do
    cp ../output/gdx/base/${A}/2005.gdx ../output/gdx/$2/${A}/2005.gdx
    cp ../output/gdx/base/${A}/analysis/2005.gdx ../output/gdx/$2/${A}/analysis/2005.gdx
  done
  
  for Y in ${YEAR[@]}
  do
  mkdir -p ../output/txt/cpu/futuresim/$2/${Y}
    if [ ${NormalRun} = "on" ]; then
      for A in ${COUNTRY[@]} 
      do
        mkdir -p ../output/txt/cpu/futuresim/$2/${Y}/NormalRun
        echo "`date '+%s'`" > ../output/txt/cpu/futuresim/$2/${Y}/NormalRun/${A}.txt

        gams ../$1/prog/LandUseModel_mcp.gms --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --parallel=on --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=100 o=../output/lst/Futuresim/LandUseModel_mcp.lst 

        echo $(TimeDif `cat ../output/txt/cpu/futuresim/$2/${Y}/NormalRun/${A}.txt`) > ../output/txt/cpu/futuresim/$2/${Y}/NormalRun/end_${A}.txt
        rm ../output/txt/cpu/futuresim/$2/${Y}/NormalRun/${A}.txt
      done
    fi

    # activate this if biocurve=on
    if [ ${biocurve} = "on" ]; then
      for A in ${COUNTRY[@]}
      do
        mkdir -p ../output/txt/cpu/futuresim/$2/${Y}/biocurve
        echo "`date '+%s'`" > ../output/txt/cpu/futuresim/$2/${Y}/biocurve/${A}.txt

        gams ../$1/prog/Bioland.gms --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --parallel=on --supcuvout=on MaxProcDir=100 o=../output/lst/Futuresim/Bioland.lst 

        echo $(TimeDif `cat ../output/txt/cpu/futuresim/$2/${Y}/biocurve/${A}.txt`) > ../output/txt/cpu/futuresim/$2/${Y}/biocurve/end_${A}.txt
        rm ../output/txt/cpu/futuresim/$2/${Y}/biocurve/${A}.txt
      done
    fi

    # 3) Disaggregation of FRS and grassland
    if [ ${DisagrrFRS} = "on" ]; then
      for A in ${COUNTRY[@]}
      do
        mkdir -p ../output/txt/cpu/futuresim/$2/${Y}/DisagrrFRS
        echo "`date '+%s'`" > ../output/txt/cpu/futuresim/$2/${Y}/DisagrrFRS/${A}.txt

        gams ../$1/prog/Disagg_FRSGL.gms --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --biocurve=off MaxProcDir=100 o=../output/lst/Futuresim/Disagg_FRSGL.lst

        echo $(TimeDif `cat ../output/txt/cpu/futuresim/$2/${Y}/biocurve/${A}.txt`) > ../output/txt/cpu/futuresim/$2/${Y}/DisagrrFRS/end_${A}.txt
        rm ../output/txt/cpu/futuresim/$2/${Y}/DisagrrFRS/${A}.txt
      done
    fi
  done

  echo $(TimeDif `cat ../output/txt/cpu/futuresim/$2.txt`) > ../output/txt/cpu/futuresim/end_$2.txt
  rm ../output/txt/cpu/futuresim/$2.txt
}

Futuresim_loop_scn() {
  rm ../output/txt/cpu/futuresim/*.txt 2> /dev/null
  for F in ${scn[@]}
  do
    Futuresim_loop_scn_Run ${parent_dir} ${F} COUNTRY0 YEAR0 ${Sub_Futuresim_biocurve} ${Sub_Futuresim_NormalRun} ${Sub_Futuresim_DisagrrFRS} ${CPLEXThreadOp} &
    LoopmultiCPU 30 scn "futuresim" ${CPUthreads}
  done
  wait
  echo "All future simulations have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
