gdx4pngRun() {

  source ../$1/shell/settings/$2.sh
  declare -n YListFig=$3
  global=$4
  declare -n COUNTRY=$5  
  dif=$6
  #COUNTRY=(JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF)
  #COUNTRY=WLD

  echo ${YListFig[@]} > ../output/txt/$2_year.txt
  echo "`date '+%s'`" > ../output/txt/cpu/gdx4png/$2.txt

  for Y in ${YListFig[@]} 
  do
    if [ ${global} = "on" ]; then
      gams ../$1/prog/gdx4png.gms --prog_loc=$1 --Sr=WLD --Sy=${Y} --sce=${SCE} --clp=${CLP} --iav=${IAV} --dif=${dif} MaxProcDir=100 o=../output/lst/gdx4png1.lst
    else
      for A in ${COUNTRY[@]} 
      do
        gams ../$1/prog/gdx4png.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --sce=${SCE} --clp=${CLP} --iav=${IAV} --dif=${dif} MaxProcDir=100 o=../output/lst/gdx4png2.lst
      done
    fi
  done

  echo $(TimeDif `cat ../output/txt/cpu/gdx4png/$2.txt`) > ../output/txt/cpu/gdx4png/end_$2.txt
  rm ../output/txt/cpu/gdx4png/$2.txt
}

gdx4png() {
  rm ../output/txt/cpu/gdx4png/*.txt 2> /dev/null
  
  for S in ${scn} 
  do
    gdx4pngRun ${parent_dir} ${S} YearListFig ${global} COUNTRY0 ${sub_gdx4png_dif} &
    LoopmultiCPU 10 scn "gdx4png" ${CPUthreads}
  done
  wait
  echo "Gdx preparation for plot has been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
