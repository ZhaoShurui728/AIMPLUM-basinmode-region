# Just to merge and conbine results
ScenMergeRun() {
  source ../$1/shell/settings/$2.sh
  declare -n COUNTRY=$3
  Biocurvesort=$4

  echo "`date '+%s'`" > ../output/txt/cpu/merge1/$2.txt

  cd ../output/gdx/$2/
  for A in ${COUNTRY[@]}
  do
    cd ./${A}
    gdxmerge *.gdx output=../cbnal/${A}.gdx
    cd ./analysis
    gdxmerge *.gdx output=../../analysis/${A}.gdx
    cd ../../
  done
  cd ./bio
  gdxmerge *.gdx output=../bio.gdx

  cd ../../../../exe
  gams ../$1/prog/combine.gms --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --supcuvout=${Biocurvesort} MaxProcDir=100 o=../output/lst/combine.lst

  echo $(TimeDif `cat ../output/txt/cpu/merge1/$2.txt`) > ../output/txt/cpu/merge1/end_$2.txt
  rm ../output/txt/cpu/merge1/$2.txt
}

ScenMerge() {
  rm ../output/txt/cpu/merge1/*.txt 2> /dev/null
  
  for S in ${scn[@]}
  do
    ScenMergeRun ${parent_dir} ${S} COUNTRY0 ${Sub_ScenMerge_BiocurveSort} &
    LoopmultiCPU 60 scn "merge1" ${CPUthreads}
  done
  wait
  echo "All scenario merges have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
