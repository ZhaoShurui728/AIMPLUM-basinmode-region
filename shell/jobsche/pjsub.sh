#!/bin/sh
  
#PJM -L "rscgrp=small"
#PJM -g hp210333
#PJM -x PJM_LLIO_GFSCACHE=/vol0003
#PJM --mail-list "sfujimori@athehost.env.kyoto-u.ac.jp"
#PJM -m b
#PJM -m e
#PJM -o "batchlog.txt"
#PJM -e "batcherr.txt"
#PJM -L "node=1"
#PJM -L "elapse=01:20:00"
#PJM -X

export OMP_NUM_THREADS=12      # 環境変数の設定
echo `pwd`
cd ../
bash AIMHub_exe.sh execution01.sh 2 > log.txt
