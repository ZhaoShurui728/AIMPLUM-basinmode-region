#!/bin/bash
cd `dirname $0`

# Functions ---------------------------------------------------------------------------------------
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
  for L in ${list[@]}
  do
    TRUE_FALSE="FALSE"
    if [ -e ../output/txt/cpu/$3/${L}.txt ]; then
      if [ ! -e ../output/txt/cpu/$3/end_${L}.txt ]; then
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

## 0. Directory Preparation
makedirectory() {
  while read line || [ -n "${line}" ]
  do
    eval mkdir -p ../${line}
  done < ../${parent_dir}/define/inc_shell/dir.txt

  if [ ${global} = "on" ]; then COUNTRY_dir=(${COUNTRY0[@]} WLD); fi

  for S in ${scn[@]}
  do
    while read line || [ -n "${line}" ]
    do
      eval mkdir -p ../${line}
    done < ../${parent_dir}/define/inc_shell/dir_scenario.txt

    for A in ${COUNTRY_dir[@]}
    do
      mkdir -p ../output/gdx/base/${A}/analysis
      mkdir -p ../output/gdx/${S}/${A}/analysis
      mkdir -p ../output/gdxii/${S}/${A}
    done    
  done
}

## 1. Data Preparation
DataPrep() {
  gams ../${parent_dir}/prog/data_prep.gms --prog_loc=${parent_dir} o=../output/lst/DataPrep.lst
  # scenario file generation
  rexe ../${parent_dir}/prog/shell_generation.R ${parent_dir}
  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 2. Base Simulation
BasesimRun() {
  echo "`date '+%s'`" > ../output/txt/cpu/basesim/$2.txt
  gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=$2 --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --ModelInt=${ModelInt} --CPLEXThreadOp=$3 --parallel=on MaxProcDir=100 o=../output/lst/Basesim/LandUseModel_mcp.lst
  gams ../$1/prog/disagg_FRSGL.gms --prog_loc=$1 --Sr=$2 --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --ModelInt=${ModelInt} MaxProcDir=100 o=../output/lst/Basesim/disagg_FRSGL.lst
#  gams ../$1/prog/Bioland.gms --prog_loc=$1 --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=on MaxProcDir=100 o=../output/lst/Basesim/Bioland.lst
  
  echo $(TimeDif `cat ../output/txt/cpu/basesim/$2.txt`) > ../output/txt/cpu/basesim/end_$2.txt
  rm ../output/txt/cpu/basesim/$2.txt
}

Basesim() {
  rm ../output/txt/cpu/basesim/*.txt 2> /dev/null
  for A in ${COUNTRY0[@]} 
  do
    BasesimRun ${parent_dir} ${A} ${CPLEXThreadOp} &
    LoopmultiCPU 5 COUNTRY0 "basesim" ${CPUthreads}
  done
  wait
  echo "All base simulations have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 3. Future Simulation (land allocation calculation)
FuturesimRun() {
  PARALLEL=$2
  declare -n LOOP=$3
  declare -n YEAR=$4
  biocurve=$5
  NormalRun=$6
  DisagrrFRS=$7
  CPLEXThreadOp=$8

  echo "`date '+%s'`" > ../output/txt/cpu/futuresim/${PARALLEL}.txt

  for L in ${LOOP[@]}
  do
    if [ ${Sub_Futuresim_Loop} = "CTY" ]; then 
      S=${L}
      A=${PARALLEL}
    elif [ ${Sub_Futuresim_Loop} = "SCN" ]; then 
      S=${PARALLEL}
      A=${L}
    fi

    source ../$1/shell/settings/${S}.sh
    cp ../output/gdx/base/${A}/2005.gdx ../output/gdx/${S}/${A}/2005.gdx
    cp ../output/gdx/base/${A}/analysis/2005.gdx ../output/gdx/${S}/${A}/analysis/2005.gdx

    if [ ${NormalRun} = "on" ]; then
      for Y in ${YEAR[@]} 
      do
        gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt=${ModelInt} --parallel=on --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=100 o=../output/lst/Futuresim/LandUseModel_mcp.lst 
      done
    fi

    if [ ${biocurve} = "on" ]; then
      for Y in ${YEAR[@]}
      do
        gams ../$1/prog/Bioland.gms --prog_loc=$1 --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt=${ModelInt} --parallel=on --supcuvout=on MaxProcDir=100 o=../output/lst/Futuresim/Bioland.lst 
      done
    fi

    if [ ${DisagrrFRS} = "on" ]; then
      for Y in ${YEAR[@]}
      do
        gams ../$1/prog/disagg_FRSGL.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt=${ModelInt} --biocurve=off MaxProcDir=100 o=../output/lst/Futuresim/disagg_FRSGL.lst
     done
    fi
  done

  echo $(TimeDif `cat ../output/txt/cpu/futuresim/${PARALLEL}.txt`) > ../output/txt/cpu/futuresim/end_${PARALLEL}.txt
  rm ../output/txt/cpu/futuresim/${PARALLEL}.txt
}
  
Futuresim() {
  rm ../output/txt/cpu/futuresim/* 2> /dev/null

  if [ ${Sub_Futuresim_Loop} = "CTY" ]; then 
    for A in ${COUNTRY0[@]}
    do
      FuturesimRun ${parent_dir} ${A} scn YEAR0 ${Sub_Futuresim_Biocurve} ${Sub_Futuresim_NormalRun} ${Sub_Futuresim_DisagrrFRS} ${CPLEXThreadOp} &
      LoopmultiCPU 5 COUNTRY0 "futuresim" ${CPUthreads}
    done
  elif [ ${Sub_Futuresim_Loop} = "SCN" ]; then 
    for S in ${scn[@]}
    do
      FuturesimRun ${parent_dir} ${S} COUNTRY0 YEAR0 ${Sub_Futuresim_Biocurve} ${Sub_Futuresim_NormalRun} ${Sub_Futuresim_DisagrrFRS} ${CPLEXThreadOp} &
      LoopmultiCPU 5 scn "futuresim" ${CPUthreads}
    done
  fi
  wait
  echo "All future simulations have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 4. Merge and Combine Results
ScnMergeRun() {
  source ../$1/shell/settings/$2.sh
  declare -n COUNTRY=$3
  Biocurvesort=$4

  echo "`date '+%s'`" > ../output/txt/cpu/merge1/$2.txt

  cd ../output/gdx/$2/
  for A in ${COUNTRY[@]}
  do
    cd ./${A}
    gdxmerge *.gdx output=../cbnal/${A}.gdx
    cd ./analysis
    gdxmerge *.gdx output=../../analysis/${A}.gdx
    cd ../../
  done
  cd ./bio
  gdxmerge *.gdx output=../bio.gdx

  cd ../../../../exe
  gams ../$1/prog/combine.gms --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --supcuvout=${Biocurvesort} MaxProcDir=100 o=../output/lst/combine.lst

  echo $(TimeDif `cat ../output/txt/cpu/merge1/$2.txt`) > ../output/txt/cpu/merge1/end_$2.txt
  rm ../output/txt/cpu/merge1/$2.txt
}

ScnMerge() {
  rm ../output/txt/cpu/merge1/*.txt 2> /dev/null
  
  for S in ${scn[@]}
  do
    ScnMergeRun ${parent_dir} ${S} COUNTRY0 ${Sub_ScnMerge_BiocurveSort} &
    LoopmultiCPU 5 scn "merge1" ${CPUthreads}
  done
  wait
  echo "All scenario merges have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 5. ASCII Files Generation for Creating NetCDF Files of Land Use Map
MergeResCSV4NCRun() {
  source ../$1/shell/settings/$2.sh

  OPT=(1 3 5)
  basecsv=$3
  BTC3option=$4
  lumip=$5
  bioyielcal=$6
  ssprcp=$7

	echo "`date '+%s'`" > ../output/txt/cpu/merge2/$2.txt

  # csv file creation
  if [ ${basecsv} = "on" ]; then
    cd ../output/gdx/$2/analysis
    gdxmerge *.gdx output=../../results/results_$2.gdx
    cd ../../../../exe
    gams ../$1/prog/gdx2csv.gms --prog_loc=$1 --split=1 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} MaxProcDir=100 S=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv1.lst
  fi

  if [ ${BTC3option} = "on" ]; then
    for O in ${OPT[@]} 
    do
      gams ../$1/prog/gdx2csv.gms --prog_loc=$1 --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} --wwfopt=${O} --wwfclass=opt MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2.lst
    done
  fi

  if [ ${lumip} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --prog_loc=$1 --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} --wwfopt=1 --lumip=on MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_lumip.lst
  fi

  if [ ${bioyielcal} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --prog_loc=$1 --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} --bioyieldcalc=on MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_bioyielcal.lst
  fi

  if [ ${ssprcp} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --prog_loc=$1 --split=2 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} --lumip=off --wwfclass=off MaxProcDir=100 R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_ssprcp.lst
  fi

  echo $(TimeDif `cat ../output/txt/cpu/merge2/$2.txt`) > ../output/txt/cpu/merge2/end_$2.txt
  rm ../output/txt/cpu/merge2/$2.txt
}

MergeResCSV4NC() {
  rm ../output/txt/cpu/merge2/*.txt 2> /dev/null
  for S in ${scn[@]} 
  do
    MergeResCSV4NCRun ${parent_dir} ${S} ${Sub_MergeResCSV4NC_basecsv} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_ssprcp} &
    LoopmultiCPU 5 scn "merge2" ${CPUthreads}
  done
  wait
  echo "All merges have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 6. Generation of NetCDF Files
netcdfgenRun() {
  
  source ../$1/shell/settings/$2.sh
  scenarioname=$2
  projectname=$3
  lumip=$4
  bioyielcal=$5
  BTC3option=$6
  ssprcp=$7

  SceName=${SCE}_${CLP}_${IAV}

  ncgenfunc(){
    if [ $5 == 1 ]; then
      cat ../output/csv/$4.txt $3 ../output/csv/final.txt > ../output/cdl/$1_$2.cdl
    else
      cat ../output/csv/$4.txt $3 ../output/csv/pixel_area.csv ../output/csv/final.txt > ../output/cdl/$1_$2.cdl
    fi
    ncgen -o ../output/nc/$1_$2.nc ../output/cdl/$1_$2.cdl
    rm $3 ../output/cdl/$1_$2.cdl
  }

  #For LUMIP 
  if [ ${lumip} == on ]; then
    filelist="../output/csv/${SceName}/c3ann.csv ../output/csv/${SceName}/c3nfx.csv ../output/csv/${SceName}/c4ann.csv ../output/csv/${SceName}/crpbf_c4ann.csv ../output/csv/${SceName}/irrig_c3ann.csv ../output/csv/${SceName}/irrig_c3nfx.csv ../output/csv/${SceName}/irrig_c4ann.csv ../output/csv/${SceName}/pastr.csv ../output/csv/${SceName}/primf.csv ../output/csv/${SceName}/range.csv ../output/csv/${SceName}/secdf.csv ../output/csv/${SceName}/urban.csv ../output/csv/${SceName}/flood.csv ../output/csv/${SceName}/fallow.csv"
    ncgenfunc lumip ${SceName} "${filelist}" ncheader_all_lumip 1
  fi
  #Bioenergy yield
  if [ ${bioyielcal} == on ]; then
    filelist="../output/csv/${SceName}/yield_BIO.csv"
    ncgenfunc yield ${SceName} "${filelist}" ncheader_all_yield 1
  fi
  #Bending the curve 
  if [ ${BTC3option} == on ]; then
    filelist="../output/csv/${SceName}/${SceName}_opt1.csv ../output/csv/${SceName}/${SceName}_opt3.csv  ../output/csv/${SceName}/${SceName}_opt5.csv"
    ncgenfunc AIM-LUmap ${SceName} "${filelist}" ncheader_all_wwf_landcategoryall 2
  fi
  #Default SSP-RCP-land use date creation 
  if [ ${ssprcp} == on ]; then
    filelist="../output/csv/${SceName}/AFR.csv ../output/csv/${SceName}/BIO.csv ../output/csv/${SceName}/CL.csv ../output/csv/${SceName}/PRMFRS.csv ../output/csv/${SceName}/MNGFRS.csv ../output/csv/${SceName}/OL.csv ../output/csv/${SceName}/GL.csv ../output/csv/${SceName}/PAS.csv ../output/csv/${SceName}/SL.csv"
    ncgenfunc all ${SceName} "${filelist}" ncheader_all 1
  fi
}

netcdfgen() {
  FileCopyList=(ncheader_all_lumip ncheader_all final ncheader_all_yield ncheader_all_aimssprcplu_landcategory ncheader_all_wwf ncheader_all_wwf2 ncheader_all_wwf_landcategory ncheader_all_wwf_landcategory2 ncheader_all_wwf_landcategoryall)
  for F in ${FileCopyList[@]} 
  do 
    cp ../${parent_dir}/data/ncheader/${F}.txt ../output/csv/${F}.txt 
  done

  for S in ${scn[@]} 
  do
    netcdfgenRun ${parent_dir} ${S} ${Sub_Netcdfgen_projectname} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_ssprcp}
  done

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 7. Generation of GDX Files for Plotting
gdx4pngRun() {
  source ../$1/shell/settings/$2.sh
  declare -n YListFig=$3
  global=$4
  declare -n COUNTRY=$5  
  dif=$6

  echo ${YListFig[@]} > ../output/txt/$2_year.txt
  echo "`date '+%s'`" > ../output/txt/cpu/gdx4png/$2.txt

  for Y in ${YListFig[@]} 
  do
    if [ ${global} = "on" ]; then
      gams ../$1/prog/gdx4png.gms --prog_loc=$1 --Sr=WLD --Sy=${Y} --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} --dif=${dif} MaxProcDir=100 o=../output/lst/gdx4png1.lst
    elif [ ${global} = "off" ]; then
      for A in ${COUNTRY[@]} 
      do
        gams ../$1/prog/gdx4png.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt=${ModelInt} --dif=${dif} MaxProcDir=100 o=../output/lst/gdx4png2.lst
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
    gdx4pngRun ${parent_dir} ${S} YearListFig ${global} COUNTRY0 ${Sub_gdx4png_dif} &
    LoopmultiCPU 5 scn "gdx4png" ${CPUthreads}
  done
  wait
  echo "GDX preparation for plot has been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 8. Graphics
plot() {
  for S in ${scn[@]} 
  do
    if [ ${global} = "on" ]; then
      echo "WLD" > ../output/txt/${S}_region.txt
    else
      echo ${CountryC} > ../output/txt/${S}_region.txt
    fi
    rexe ../${parent_dir}/R/prog/plot_scenario.R ${S}
  done

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 9. Merge All Results
Allmerge() {
  cd ../output/gdx/analysis
  gdxmerge *.gdx output=../final_results.gdx
  cd ../../../exe

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
# Functions end -----------------------------------------------------------------------------------

cd ../
parent_dir=`basename ${PWD}`
echo "Parent directory is ${parent_dir}"

# Settings
## load settings
if [ $# = 0 ]; then
  source ../${parent_dir}/shell/settings.sh  # default
elif [ $# -ge 1 ]; then
  source ../${parent_dir}/shell/$1           # manual settings
fi

## set regions
if [ ${global} = "on" ]; then 
  COUNTRY0=(JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF)
elif [ ${global} = "off" ]; then
  COUNTRY0=${CountryC}
fi

## set CPLEX threads number 
NSc=0
for S in ${scn[@]}
do
  NSc=$((${NSc} + 1))
done

CPLEXThreadOp=1
for Th in 2 3
do
  NScMl=$((${NSc}*${Th}))
  if [ ${CPUthreads} -gt ${NScMl} ]; then CPLEXThreadOp=${Th}; fi
done
echo "The number of CPLEX threads is ${CPLEXThreadOp}"

# Git Configuration
git config --global core.autocrlf input

# Generate Directories
makedirectory
cd ../exe

if [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  OS='Linux'
  baseos=ux
  savedir=../output/save/
elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW32_NT' ] || [ "$(expr substr $(uname -s) 1 10)" = 'CYGWIN_NT-' ]; then
  OS='Cygwin'
  baseos=wd
  savedir=..\\output\\save\\
fi

read -p "push any key"

# Model Execution
if [ ${DataPrep}       = "on" ]; then DataPrep       ; fi
if [ ${Basesim}        = "on" ]; then Basesim        ; fi
if [ ${Futuresim}      = "on" ]; then Futuresim      ; fi
if [ ${ScnMerge}       = "on" ]; then ScnMerge       ; fi
if [ ${MergeResCSV4NC} = "on" ]; then MergeResCSV4NC ; fi
if [ ${netcdfgen}      = "on" ]; then netcdfgen      ; fi
if [ ${gdx4png}        = "on" ]; then gdx4png        ; fi
if [ ${plot}           = "on" ]; then plot           ; fi
if [ ${Allmerge}       = "on" ]; then Allmerge       ; fi

read -p "All calculations have been done. [enter]"
