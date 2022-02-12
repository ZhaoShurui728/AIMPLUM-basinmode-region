rexe() {
  R --no-save --no-restore --no-site-file --no-environ --slave $2 < $1
} 

TimeDif() {
  Now=`date '+%s'`
  Dif=$((${Now}-$1))
  ((sec=${Dif}%60, min=(${Dif}%3600)/60, hrs=${Dif}/3600))
  hms=$(printf "%d:%02d:%02d" ${hrs} ${min} ${sec})
  echo ${hms}
}

LoopmultiCPU() {
  TM=$1
  declare -n list=$2
  EceCPU="OFF"
  X=0
  for A in ${list[@]}
  do
    TRUE_FALSE="FALSE"
    if [ -e ../output/txt/cpu/$3/${A}.txt ]; then
      if [ ! -e ../output/txt/cpu/$3/end_${A}.txt ]; then
        TRUE_FALSE="TRUE"
      fi
    fi
    if [ ${TRUE_FALSE} = "TRUE" ]; then X=$(( X + 1 )); fi
  done
 
  if [ ${X} -ge $4 ]; then EceCPU="ON"; fi
  echo "Waiting due to the core number limitation"
  sleep ${TM}
  if [ ${EceCPU} = "ON" ]; then 
    LoopmultiCPU $1 $2 $3 $4
  fi
}
