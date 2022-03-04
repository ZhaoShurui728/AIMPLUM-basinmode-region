# Land allocation calculation
FuturesimRun() {
  declare -n SCENARIO=$2
  declare -n YEAR=$4
  biocurve=$5
  NormalRun=$6
  DisagrrFRS=$7
  CPLEXThreadOp=$8

  echo "`date '+%s'`" > ../output/txt/cpu/futuresim/$3.txt
  
  for S in ${SCENARIO[@]}
  do
    source ../$1/shell/settings/${S}.sh
    mkdir -p ../output/txt/cpu/futuresim/${S}

    cp ../output/gdx/base/$3/2005.gdx ../output/gdx/${S}/$3/2005.gdx
    cp ../output/gdx/base/$3/analysis/2005.gdx ../output/gdx/${S}/$3/analysis/2005.gdx

    if [ ${NormalRun} = "on" ]; then
      mkdir -p ../output/txt/cpu/futuresim/${S}/NormalRun

      for Y in ${YEAR[@]} 
      do
        mkdir -p ../output/txt/cpu/futuresim/${S}/NormalRun/${Y}
        echo "`date '+%s'`" > ../output/txt/cpu/futuresim/${S}/NormalRun/${Y}/$3.txt

        gams ../$1/prog/LandUseModel_mcp.gms --prog_loc=$1 --Sr=$3 --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --parallel=on --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=100 o=../output/lst/Futuresim/LandUseModel_mcp.lst 

        echo $(TimeDif `cat ../output/txt/cpu/futuresim/${S}/NormalRun/${Y}/$3.txt`) > ../output/txt/cpu/futuresim/${S}/NormalRun/${Y}/end_$3.txt
        rm ../output/txt/cpu/futuresim/${S}/NormalRun/${Y}/$3.txt
      done
    fi

    if [ ${biocurve} = "on" ]; then
      mkdir -p ../output/txt/cpu/futuresim/${S}/biocurve

      for Y in ${YEAR[@]}
      do
        mkdir -p ../output/txt/cpu/futuresim/${S}/biocurve/${Y}
        echo "`date '+%s'`" > ../output/txt/cpu/futuresim/${S}/biocurve/${Y}/$3.txt

        gams ../$1/prog/Bioland.gms --prog_loc=$1 --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --parallel=on --supcuvout=on MaxProcDir=100 o=../output/lst/Futuresim/Bioland.lst 

        echo $(TimeDif `cat ../output/txt/cpu/futuresim/${S}/biocurve/${Y}/$3.txt`) > ../output/txt/cpu/futuresim/${S}/biocurve/${Y}/end_$3.txt
        rm ../output/txt/cpu/futuresim/${S}/biocurve/${Y}/$3.txt
      done
    fi

    # 3) Disaggregation of FRS and grassland
    if [ ${DisagrrFRS} = "on" ]; then
      mkdir -p ../output/txt/cpu/futuresim/${S}/DisagrrFRS

      for Y in ${YEAR[@]}
      do
        mkdir -p ../output/txt/cpu/futuresim/${S}/DisagrrFRS/${Y}
        echo "`date '+%s'`" > ../output/txt/cpu/futuresim/${S}/DisagrrFRS/${Y}/$3.txt

        gams ../$1/prog/Disagg_FRSGL.gms --prog_loc=$1 --Sr=$3 --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --biocurve=off MaxProcDir=100 o=../output/lst/Futuresim/Disagg_FRSGL.lst

        echo $(TimeDif `cat ../output/txt/cpu/futuresim/${S}/biocurve/${Y}/$3.txt`) > ../output/txt/cpu/futuresim/${S}/DisagrrFRS/${Y}/end_$3.txt
        rm ../output/txt/cpu/futuresim/${S}/DisagrrFRS/${Y}/$3.txt
      done
    fi
  done

  echo $(TimeDif `cat ../output/txt/cpu/futuresim/$3.txt`) > ../output/txt/cpu/futuresim/end_$3.txt
  rm ../output/txt/cpu/futuresim/$3.txt
}

Futuresim() {
  rm -rf ../output/txt/cpu/futuresim/* 2> /dev/null

  for A in ${COUNTRY0[@]}
  do
    FuturesimRun ${parent_dir} scn ${A} YEAR0 ${Sub_Futuresim_biocurve} ${Sub_Futuresim_NormalRun} ${Sub_Futuresim_DisagrrFRS} ${CPLEXThreadOp} &
    LoopmultiCPU 5 COUNTRY0 "futuresim" ${CPUthreads}
  done
  wait
  echo "All future simulations have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
