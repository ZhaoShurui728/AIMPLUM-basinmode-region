#!/bin/sh
#=============== Slurm Options ===============#
#SBATCH -p gr10502b
#SBATCH -t 5-00:00:00
#SBATCH -o ../../output/Slurmoutput/%x.%j.out
#SBATCH --rsc p=1:t=112:c=112:m=500G
#SBATCH --mail-user=hirabaru.soutarou.72s@st.kyoto-u.ac.jp
#SBATCH --mail-type=ALL
cd /LARGE0/gr10502/individual/shirabaru/Biodiversity/PREDICTS/shell
#=============== Shell Script ===============#
set -x
#@echo off
./execution_cout2.sh
