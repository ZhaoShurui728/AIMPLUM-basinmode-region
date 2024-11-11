#!/bin/sh
#PBS -l ncpus=32,mpiprocs=32,mem=263192576kb,host=hpc_c07
#PBS -M fujimori.shinichiro.8a@kyoto-u.ac.jp
#PBS -m abe
#PBS -N AIM-Hub
#PBS -e ../../../output/jobreport
#PBS -o ../../../output/jobreport

export OMP_NUM_THREADS=32      # 環境変数の設定
echo Working Directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
cd ../
echo `pwd`
bash AIMHub_exe.sh vis.sh 2 > log.txt

