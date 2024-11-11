#!/bin/bash
#$1: node number (if $1 is "0", then it is run directly with bash
#$2: shell program parameter setting file name
arg1=$1
arg2=$2
ModExe=PLUM_exe

#Get CPU number allocation
while read -r line; do
    if [[ "$line" == *CPUthreads* ]] || [[ "$line" == *MultiSol* ]]; then
        eval "$line"
    fi
done < ./settings/$2.sh
CoreN=${CPUthreads}

#Phisical memory allocation
#PhsMem=$(expr ${NCPU} \* 4)
PhsMem=250

mkdir -m 777 -p ../../output/jobreport
if [ $1 == 0 ]; then
  bash ./PLUM_exe.sh -e ./settings/$2.sh
else
  sed "s/%%%1/${arg1}/g; s/%%%2/${arg2}/g; s/%%%3/${ModExe}/g; s/%%%4/${CoreN}/g; s/%%%5/${PhsMem}/g" ./jobsche/psubjob_template.sh  > ./jobsche/psubjob_$1_$2.sh
  qsub ./jobsche/psubjob_$1_$2.sh
fi
