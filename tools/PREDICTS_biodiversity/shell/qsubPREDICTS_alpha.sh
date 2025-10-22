#!/bin/sh

#PBS -q workq
#PBS -N PREDICTS
#PBS -o ../../PBS-output
#PBS -e ../../PBS-output
#PBS -M hirabaru.soutarou.72s@st.kyoto-u.ac.jp
#PBS -l ncpus=16,mpiprocs=30,mem=100gb,host=alpha-c02
#PBS -m abe

PATH=$PBS_O_PATH
cd $PBS_O_WORKDIR

echo $PBS_O_PATH | sed "s/:/:\n/g"
echo $PBS_EXEC/bin

# . /home/shirabaru/.bashrc
# which R

# export SPACK_ROOT=${HOME}/spack
# echo $SPACK_ROOT
. /home/shirabaru/spack/share/spack/setup-env.sh

spack load r/3wkwmsa
spack load r-lattice 
spack load r-ncdf4
spack load r-raster
spack load r-sp   
spack load r-spdep
spack load r-lme4
spack load r-matrix
spack load r-devtools  

./execution_cout.sh