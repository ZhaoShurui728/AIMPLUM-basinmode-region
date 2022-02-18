# Base simulation
BasesimRun() {
  echo "`date '+%s'`" > ../output/txt/cpu/basesim/$2.txt
  gams ../$1/prog/LandUseModel_mcp.gms --prog_loc=$1 --Sr=$2 --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --CPLEXThreadOp=$3 --parallel=on MaxProcDir=100 o=../output/lst/Basesim/LandUseModel_mcp.lst
  gams ../$1/prog/Disagg_FRSGL.gms --prog_loc=$1 --Sr=$2 --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC MaxProcDir=100 o=../output/lst/Basesim/Disagg_FRSGL.lst
#  gams ../$1/prog/Bioland.gms --prog_loc=$1 --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=on MaxProcDir=100 o=../output/lst/Basesim/Bioland.lst
  
  echo $(TimeDif `cat ../output/txt/cpu/basesim/$2.txt`) > ../output/txt/cpu/basesim/end_$2.txt
  rm ../output/txt/cpu/basesim/$2.txt
}

Basesim() {
  rm ../output/txt/cpu/basesim/*.txt 2> /dev/null
  for A in ${COUNTRY0[@]} 
  do
    BasesimRun ${parent_dir} ${A} ${CPLEXThreadOp} &
    LoopmultiCPU 5 COUNTRY0 "basesim" ${CPUthreads}
  done
  wait
  echo "All base simulations have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
