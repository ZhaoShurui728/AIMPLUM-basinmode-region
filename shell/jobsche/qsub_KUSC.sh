
#============ PBS Options ============
#QSUB -q gr10502b
#QSUB -ug gr10502
#QSUB -W 336:00
#QSUB -A p=1:t=10:c=20:m=100G
#QSUB -m be
#============ Shell Script ============

export OMP_NUM_THREADS=12      # 環境変数の設定

cd /LARGE2/gr10502/sfujimori/gamssample/AIMCGE/shell
. execution_JPN.sh > log.txt
