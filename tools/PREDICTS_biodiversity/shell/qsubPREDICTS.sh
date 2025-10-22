#!/bin/sh
#PBS -N PREDICTS
#PBS -o ../../PBS-output
#PBS -e ../../PBS-output
#PBS -M hirabaru.soutarou.72s@st.kyoto-u.ac.jp
#PBS -l ncpus=20,mpiprocs=20,mem=100,host=hpc_c03
#PBS -m abe
#PBS -v OMP_NUM_THREADS=30
cd $PBS_O_WORKDIR

#echo $PBS_O_PATH | sed "s/:/:\n/g"

./execution_cout.sh settings_cout.sh