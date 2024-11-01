#!/bin/sh
#PBS -l ncpus=30,mpiprocs=30,mem=250gb,host=hpc_c11
#PBS -M fujimori.shinichiro.8a@kyoto-u.ac.jp
#PBS -m abe
#PBS -N PLUM-IBS1
#PBS -e ../../output/jobreport
#PBS -o ../../output/jobreport
export OMP_NUM_THREADS=30      # 環境変数の設定
. ~/.bashrc
echo Working Directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
echo `pwd`
timestamp=`date +"%m-%d-%y-%H-%M-%S"`
echo $timestamp > ../../output/jobreport/psublog_${PBS_JOBID}.txt 
cat ./settings/IBS1.sh >> ../../output/jobreport/psublog_${PBS_JOBID}.txt
bash PLUM_exe.sh IBS1.sh 2 >> ../../output/jobreport/psublog_${PBS_JOBID}.txt
