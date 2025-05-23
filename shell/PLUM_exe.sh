#!/bin/bash
cd `dirname $0`
export gams_sys_dir=`which gams --skip-alias|xargs dirname`
#to make scenario names mapping for netCDF files, ../${parent_dir}/data/scenariomap.txt should be used.

# Functions ---------------------------------------------------------------------------------------
#-----function definition
function rexe() {
  R --no-save --no-restore --no-site-file --slave $2 < $1
} 
function ScenarioSpecName(){
  source ../${parent_dir}/shell/ScenarioSet/${S}.sh
  if [ -z "${ModelInt}" ]; then
    ModelInt2="NoValue"
  else
    ModelInt2=${ModelInt}
  fi
}

function TimeDif() {
  Now=`date '+%s'`
  Dif=$((${Now} - 1))
  ((sec=${Dif}%60, min=(${Dif}%3600)/60, hrs=${Dif}/3600))
  hms=$(printf "%d:%02d:%02d" ${hrs} ${min} ${sec})
  echo ${hms}
}

function LoopmultiCPU() {
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
#  echo "Waiting due to the core number limitation" ${X}
  sleep ${TM}
  if [ ${EceCPU} = "ON" ]; then 
    LoopmultiCPU $1 $2 $3 $4
  fi
}

## 0. Directory Preparation
function makedirectory() {
  while read line || [ -n "${line}" ]
  do
    eval mkdir -p ../${line}
  done < ../${parent_dir}/define/inc_shell/dir.txt

  if [ ${global} = "on" ]; then 
    COUNTRY_dir=(${COUNTRY0[@]} WLD)
  else
    COUNTRY_dir=(${COUNTRY0[@]})
  fi

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
    done    
  done
}

## 1. Data Preparation
function DataPrep() {
  gams ../${parent_dir}/prog/data_prep.gms --prog_loc=${parent_dir} o=../output/lst/DataPrep.lst
  # scenario file generation
  rexe ../${parent_dir}/prog/shell_generation.R ${parent_dir}
  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 1-2. Data Preparation split2
function DataPrep2() {
  gams ../${parent_dir}/prog/data_prep2.gms --prog_loc=${parent_dir} o=../output/lst/DataPrep2.lst
  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 2. Base Simulation
function BasesimRun() {
  echo "`date '+%s'`" > ../output/txt/cpu/basesim/$2.txt
  echo "SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2}, ${S}"
  gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=${A} --Sy=2005 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=on --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=700 o=../output/lst/Basesim/LandUseModel_mcp_${A}_base.lst   lo=4
  
  echo $(TimeDif `cat ../output/txt/cpu/basesim/$2.txt`) > ../output/txt/cpu/basesim/end_$2.txt
  rm ../output/txt/cpu/basesim/$2.txt
}
function BaseRunDisaggfrs() {
  echo "`date '+%s'`" > ../output/txt/cpu/basedsaggfrs/$2.txt
  gams ../$1/prog/disagg_FRSGL.gms --prog_loc=$1 --Sr=$2 --Sy=2005 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=700 o=../output/lst/Basesim/disagg_FRSGL_$2.lst   lo=4
  echo $(TimeDif `cat ../output/txt/cpu/basedsaggfrs/$2.txt`) > ../output/txt/cpu/basedsaggfrs/end_$2.txt
  rm ../output/txt/cpu/basedsaggfrs/$2.txt
}

function Basesim() {
  echo `date +"%m-%d-%y-%H-%M-%S"` 
  echo base year simulation starts for ${COUNTRY0[@]}
  rm ../output/txt/cpu/basesim/*.txt 2> /dev/null
  rm ../output/txt/cpu/basedsaggfrs/*.txt 2> /dev/null
  S=${scn[0]}
  echo ${S}
  ScenarioSpecName
  for A in ${COUNTRY0[@]} 
  do
    BasesimRun ${parent_dir} ${A} ${CPLEXThreadOp} > ../output/log/Basesim_${A}.log 2>&1 &
    LoopmultiCPU 1 COUNTRY0 "basesim" ${AvailRunNum4CPLEX}
  done
  wait
  echo "All base year simulations have been done."

  for A in ${COUNTRY0[@]} 
  do
    BaseRunDisaggfrs ${parent_dir} ${A} 1 > ../output/log/Basedisagg_${A}.log 2>&1 &
    LoopmultiCPU 1 COUNTRY0 "basedsaggfrs" ${CPUthreads}
  done
  wait
  echo "All base disaggregation have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}


## 3. Future Simulation (land allocation calculation)
function FuturesimRun() {
  PARALLEL=$2
  declare -n LOOP=$3
  declare -n YEAR=$4
  CPLEXThreadOp=$5

  echo "`date '+%s'`" > ../output/txt/cpu/futuresim/${PARALLEL}.txt

  for L in ${LOOP[@]};  do
    if [ ${Sub_Futuresim_Loop} = "CTY" ]; then 
      S=${L}
      A=${PARALLEL}
    elif [ ${Sub_Futuresim_Loop} = "SCN" ]; then 
      S=${PARALLEL}
      A=${L}
    fi
    #Load scenario specification
    ScenarioSpecName

    cp ../output/gdx/base/${A}/2005.gdx ../output/gdx/${S}/${A}/2005.gdx
    cp ../output/gdx/base/${A}/analysis/2005.gdx ../output/gdx/${S}/${A}/analysis/2005.gdx
    parallelSW=on
    if [ ${pausemode} = "on" ]; then parallelSW=off; fi 
    for Y in ${YEAR[@]};    do
      gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=${parallelSW} --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=700 o=../output/lst/Futuresim/LandUseModel_mcp_${A}_${SCE}_${CLP}_${IAV}${ModelInt}.lst lo=4
    done
  done
  

  echo $(TimeDif `cat ../output/txt/cpu/futuresim/${PARALLEL}.txt`) > ../output/txt/cpu/futuresim/end_${PARALLEL}.txt
  rm ../output/txt/cpu/futuresim/${PARALLEL}.txt
}

function FuturesimFullRun() {
  set -x 
  S=$2
  A=$3
  declare -n YEAR=$4
  echo "`date '+%s'`" > ../output/txt/cpu/futuresim/${S}_${A}.txt
  #Load scenario specification
  ScenarioSpecName
  parallelSW=on
  if [ ${pausemode} = "on" ]; then parallelSW=off; fi 
  for Y in ${YEAR[@]};    do
    if [ "${Y}" == "2010" ]; then
      cp ../output/gdx/base/${A}/2005.gdx ../output/gdx/${S}/${A}/2005.gdx
      cp ../output/gdx/base/${A}/analysis/2005.gdx ../output/gdx/${S}/${A}/analysis/2005.gdx
    fi
    gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=${parallelSW} --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=700 o=../output/lst/Futuresim/LandUseModel_mcp_${A}_${S}.lst lo=4
  done
  echo $(TimeDif `cat ../output/txt/cpu/futuresim/${S}_${A}.txt`) > ../output/txt/cpu/futuresim/end_${S}_${A}.txt
  rm ../output/txt/cpu/futuresim/${S}_${A}.txt
}


function Futuresim() {
  echo `date +"%m-%d-%y-%H-%M-%S"` 
  echo future scenario simulation is run
  if [ ${Sub_Futuresim_NormalRun} = "on" ]; then
    if [ ${Sub_Futuresim_Loop} = "CTY" ]; then 
      for A in ${COUNTRY0[@]};    do
        rm ../output/txt/cpu/futuresim/${A}.txt 2> /dev/null
        rm ../output/txt/cpu/futuresim/end_${A}.txt 2> /dev/null
      done
      for A in ${COUNTRY0[@]};    do
        echo "Region ${A} simulation has been started." 
        FuturesimRun ${parent_dir} ${A} scn YEAR0 ${CPLEXThreadOp}  > ../output/log/futuresim_${A}.log 2>&1 &
        LoopmultiCPU 1 COUNTRY0 "futuresim" ${AvailRunNum4CPLEX}
      done
    elif [ ${Sub_Futuresim_Loop} = "SCN" ]; then 
      for S in ${scn[@]};    do
        rm ../output/txt/cpu/futuresim/${S}.txt ../output/txt/cpu/futuresim/end_${S}.txt 2> /dev/null
      done
      for S in ${scn[@]};    do
        echo "scenario ${S} simulation has been started." 
        FuturesimRun ${parent_dir} ${S} COUNTRY0 YEAR0 ${CPLEXThreadOp} > ../output/log/futuresim_${S}.log 2>&1 &
        LoopmultiCPU 1 scn "futuresim" ${AvailRunNum4CPLEX}
      done
    elif [ ${Sub_Futuresim_Loop} = "Full" ]; then 
      IteCounter=0
      for XXX in ${FullList[@]};    do
        rm ../output/txt/cpu/futuresim/${XXX}.txt ../output/txt/cpu/futuresim/end_${XXX}.txt ../output/log/futuresim_${XXX}.log ../output/lst/Futuresim/LandUseModel_mcp_${XXX}.lst 2> /dev/null
      done
      for A in ${COUNTRY0[@]};    do
        for S in ${scn[@]};    do
          echo "scenario ${S} ${A} simulation has been started with full parallel mode." 
          FuturesimFullRun ${parent_dir} ${S} ${A} YEAR0 ${CPLEXThreadOp} > ../output/log/futuresim_${S}_${A}.log 2>&1 &
          LoopmultiCPU 1 FullList "futuresim" ${AvailRunNum4CPLEX}
          IteCounter=$(( IteCounter + 1 ))
        done
      done  
    fi
  fi
  wait
  echo "All future simulations have been done. Post process is running"

#Post process for disaggregation of forest and bioenergy
  if [ ${Sub_Futuresim_Biocurve} = "on" ]; then
  echo "Bioenergy curve is executed" 
    for S in ${scn[@]}; do
    #Load scenario specification
      ScenarioSpecName
      for Y in ${YEAR0[@]};  do
        gams ../${parent_dir}/prog/Bioland.gms --prog_loc=${parent_dir} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=on --supcuvout=on \
          MaxProcDir=700 o=../output/lst/Futuresim/Bioland_${SCE}_${CLP}_${IAV}${ModelInt}_${Y}.lst lf=../output/log/Futuresim/Bioland_${SCE}_${CLP}_${IAV}${ModelInt}_${Y}.log lo=4  > ../output/log/Bioland_${A}.log 2>&1 & 
      done
    done
  wait
  fi
  if [ ${Sub_Futuresim_DisagrrFRS} = "on" ]; then
    echo `date +"%m-%d-%y-%H-%M-%S"` 
    echo "Disaggregation of forest area is executed" 
    for XXX in ${FullList[@]};    do
      rm ../output/txt/cpu/disagrfrs/${XXX}.txt ../output/txt/cpu/disagrfrs/end_${XXX}.txt 2> /dev/null
    done
    for S in ${scn[@]};    do
      #Load scenario specification
      ScenarioSpecName
      for A in ${COUNTRY0[@]};    do
        echo "disaggregation of forest ${S} ${A} has been started with full parallel mode." 
        {
          echo "" > ../output/txt/cpu/disagrfrs/${S}_${A}.txt
          for Y in ${YEAR0[@]};    do
            gams ../${parent_dir}/prog/disagg_FRSGL.gms --prog_loc=${parent_dir} --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --biocurve=off \
              MaxProcDir=700 o=../output/lst/Futuresim/disagg_FRSGL_${S}_${A}.lst lo=4  > ../output/log/disagg_FRSGL_${S}_${A}.log
          done
          echo $(TimeDif `cat ../output/txt/cpu/disagrfrs/${S}_${A}.txt`) > ../output/txt/cpu/disagrfrs/end_${S}_${A}.txt
          rm ../output/txt/cpu/disagrfrs/${S}_${A}.txt
        } &
        LoopmultiCPU 1 FullList "disagrfrs" ${CPUthreads}
      done
      echo "disaggregation of forest ${S} ${A} has been finished." 
    done
    wait  

  fi
  echo "All post processes have been done." 

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 4. Merge and Combine Results
function ScnMergeRun() {
  #Load scenario specification
  ScenarioSpecName
  declare -n COUNTRY=$3
  Baserun=$4
  Restorecal=$5
  Livdiscal=$6
  Biocurvesort=$7
  	
  echo "`date '+%s'`" > ../output/txt/cpu/merge1/$2.txt
  for A in ${COUNTRY[@]};  do
	# This change directry used for gdxmerge is to run with windows OS where the path with slash does not work in gdxmerge. 
    cd ../output/gdx/$2/${A}
    gdxmerge *.gdx 
    mv merged.gdx ../cbnal/${A}.gdx
    cd ./analysis
    gdxmerge *.gdx
    mv merged.gdx ../../analysis/${A}.gdx
    cd ../../../../../exe
  done
  cd ../output/gdx/$2/cbnal
  gdxmerge *.gdx output=../../results/cbnal_$2.gdx
  cd ../../../../exe
  
  cd ../output/gdx/$2/analysis
  gdxmerge *.gdx output=../../results/analysis_$2.gdx
  cd ../../../../exe

  cd ../output/gdx/$2/bio
  gdxmerge *.gdx
  mv -f merged.gdx ../bio.gdx
  cd ../../../../exe
  
  if [ ${Baserun} = "on" ]; then
  	gams ../$1/prog/combine.gms --split=1 S=${savedir}combine_$2 o=../output/lst/combine_base_$2.lst lf=../output/log/combine_base_$2.log --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=700 lo=4
  fi
  if [ ${Restorecal} = "on" ]; then
    gams ../$1/prog/combine.gms --split=2 --restorecalc=on R=${savedir}combine_$2 o=../output/lst/combine_res_$2.lst lf=../output/log/combine_res_$2.log --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=700 lo=4	&
  fi
  if [ ${Livdiscal} = "on" ]; then
    gams ../$1/prog/combine.gms --split=2 --livdiscalc=on R=${savedir}combine_$2 o=../output/lst/combine_liv_$2.lst lf=../output/log/combine_liv_$2.log --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=700 lo=4	&
  fi
  if [ ${Biocurvesort} = "on" ]; then
    gams ../$1/prog/combine.gms --split=2 --supcuvout=on R=${savedir}combine_$2 o=../output/lst/combine_biocuv_$2.lst lf=../output/log/combine_biocuv_$2.log --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=700 lo=4	&
  fi
  wait
  gams ../$1/prog/IAMCTemp_Ind.gms --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV}  --ModelInt2=${ModelInt2} --WWFlandout_exe=$8 --Livestockout_exe=$9 MaxProcDir=700  o=../output/lst/comparison_scenario_$2.lst  lo=4
  read -p "push any key";

  echo $(TimeDif `cat ../output/txt/cpu/merge1/$2.txt`) > ../output/txt/cpu/merge1/end_$2.txt
  rm ../output/txt/cpu/merge1/$2.txt
}

function ScnMerge() {
  echo `date +"%m-%d-%y-%H-%M-%S"` 
  echo scenario results merge
  for S in ${scn[@]};  do	
    rm ../output/txt/cpu/merge1/${S}.txt 2> /dev/null
    rm ../output/txt/cpu/merge1/end_${S}.txt 2> /dev/null
  done  
  for S in ${scn[@]};  do	
    ScnMergeRun ${parent_dir} ${S} COUNTRY0 ${Sub_ScnMerge_Baserun} ${Sub_ScnMerge_Restorecal} ${Sub_ScnMerge_Livdiscal} ${Sub_ScnMerge_BiocurveSort} ${WWFrestore_iamc} ${Livestock_iamc}  > ../output/log/ScnmergeRun_${S}.log 2>&1 &
    LoopmultiCPU 5 scn "merge1" ${CPUthreads}
  done
  wait
  echo "All scenario merges have been done."
  cd ../output/gdx/comparison/
  gdxmerge *.gdx 
  mv -f merged.gdx ../all/Mergedcomparison.gdx
  cd ../../../exe

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 5. ASCII Files Generation for Creating NetCDF Files of Land Use Map
function MergeResCSV4NCRun() {
  #Load scenario specification
  ScenarioSpecName
  basecsv=$3
  BTC3option=$4
  lumip=$5
  bioyielcal=$6
  ssprcp=$7
  carseq=$8
  livdiscal=$9
  
  echo "`date '+%s'`" > ../output/txt/cpu/merge2/$2.txt
  GAMSRunArg="--prog_loc=$1 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=700 lo=4 "
  echo "--sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt2=${ModelInt2}"
  # csv file creation
  if [ ${basecsv} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=1 S=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv1_base_$2.lst lf=../output/log/gdx2csv1_base_$2.log ${GAMSRunArg}
  fi

  if [ ${BTC3option} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --wwfclass=on R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_$2.lst lf=../output/log/gdx2csv2_$2.log ${GAMSRunArg}
  fi

  if [ ${lumip} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --lumip=on R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_lumip_$2.lst lf=../output/log/gdx2csv2_lumip_$2.log  ${GAMSRunArg}
  fi

  if [ ${bioyielcal} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --bioyieldcalc=on R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_bioyielcal_$2.lst lf=../output/log/gdx2csv2_bioyielcal_$2.log ${GAMSRunArg}
  fi

  if [ ${ssprcp} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --lumip=off --wwfclass=off R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_ssprcp_$2.lst lf=../output/log/gdx2csv2_ssprcp_$2.log ${GAMSRunArg}
  fi

  if [ ${carseq} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --carseq=on R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_carseq_$2.lst lf=../output/log/gdx2csv2_carseq_$2.log  ${GAMSRunArg}
  fi

  if [ ${livdiscal} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --split=2 --livdiscalc=on R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_livdiscal_$2.lst lf=../output/log/gdx2csv2_livdiscal_$2.log ${GAMSRunArg}
  fi

  echo $(TimeDif `cat ../output/txt/cpu/merge2/$2.txt`) > ../output/txt/cpu/merge2/end_$2.txt
  rm ../output/txt/cpu/merge2/$2.txt
}

function MergeResCSV4NC() {
  echo `date +"%m-%d-%y-%H-%M-%S"` 
  echo "make ASCII files for NetCDF"
  for S in ${scn[@]};   do
    rm ../output/txt/cpu/merge2/${S}.txt ../output/txt/cpu/merge2/end_${S}.txt 2> /dev/null
  done
  for S in ${scn[@]};   do
    MergeResCSV4NCRun ${parent_dir} ${S} ${Sub_MergeResCSV4NC_basecsv} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_ssprcp} ${Sub_MergeResCSV4NC_carseq} ${Sub_MergeResCSV4NC_livdiscal} > ../output/log/MergeResCSV4NCRun_${S}.log 2>&1 &
    LoopmultiCPU 5 scn "merge2" ${CPUthreads}
  done
  wait
  echo "All merges have been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}


## 6. Generation of NetCDF Files
function netcdfgenRun() {
  
  #Load scenario specification
  ScenarioSpecName
  scenarioname=$2
  projectname=$3
  lumip=$4
  bioyielcal=$5
  BTC3option=$6
  ssprcp=$7
  carseq=$8
  livdiscal=$9

  SceName=${SCE}_${CLP}_${IAV}${ModelInt}

  function ncgenfunc(){
    if [ $5 == 1 ]; then
      cat ../output/csv/$4.txt $3 ../output/csv/final.txt > ../output/cdl/$1_$2.cdl
    else
      cat ../output/csv/$4.txt $3 ../output/csv/pixel_area.csv ../output/csv/final.txt > ../output/cdl/$1_$2.cdl
    fi
    ncgen -o ../output/nc/$1_$2.nc ../output/cdl/$1_$2.cdl
#    rm $3 ../output/cdl/$1_$2.cdl
  }
  echo "netCDF gen"
  #For LUMIP 
  if [ ${lumip} == on ]; then
    filelist="../output/csv/${SceName}/c3ann.csv ../output/csv/${SceName}/c3per.csv ../output/csv/${SceName}/c4ann.csv ../output/csv/${SceName}/c4per.csv ../output/csv/${SceName}/c3nfx.csv ../output/csv/${SceName}/cpbf2_c4per.csv ../output/csv/${SceName}/irrig_c3ann.csv ../output/csv/${SceName}/irrig_c3per.csv ../output/csv/${SceName}/irrig_c4ann.csv ../output/csv/${SceName}/irrig_c4per.csv ../output/csv/${SceName}/irrig_c3nfx.csv ../output/csv/${SceName}/pastr.csv ../output/csv/${SceName}/primf.csv ../output/csv/${SceName}/primn.csv ../output/csv/${SceName}/range.csv ../output/csv/${SceName}/secdf.csv ../output/csv/${SceName}/secdn.csv ../output/csv/${SceName}/pltns.csv ../output/csv/${SceName}/urban.csv ../output/csv/${SceName}/flood.csv ../output/csv/${SceName}/fallow.csv ../output/csv/${SceName}/icwtr.csv ../output/csv/${SceName}/prtct_primf.csv ../output/csv/${SceName}/prtct_primn.csv ../output/csv/${SceName}/prtct_secdf.csv ../output/csv/${SceName}/prtct_secdn.csv ../output/csv/${SceName}/prtct_all.csv ../output/csv/${SceName}/rice.csv ../output/csv/${SceName}/wheat.csv ../output/csv/${SceName}/maize.csv ../output/csv/${SceName}/sugarcrops.csv ../output/csv/${SceName}/oilcrops.csv ../output/csv/${SceName}/othercrops.csv"
    ncgenfunc lumip ${SceName} "${filelist}" ncheader_all_lumip 1
  fi
  #Bioenergy yield
  if [ ${bioyielcal} == on ]; then
    filelist="../output/csv/${SceName}/yield_BIO.csv ../output/csv/${SceName}/yield_AFR.csv"
    ncgenfunc yield ${SceName} "${filelist}" ncheader_all_yield 1
  fi
  #Bending the curve 
  if [ ${BTC3option} == on ]; then
    filelist="../output/csv/${SceName}/${SceName}.csv"
    ncgenfunc AIM-LUmap ${SceName} "${filelist}" ncheader_all_wwf 2
  fi
  #Default SSP-RCP-land use date creation 
  if [ ${ssprcp} == on ]; then
    filelist="../output/csv/${SceName}/AFR.csv ../output/csv/${SceName}/BIO.csv ../output/csv/${SceName}/CL.csv ../output/csv/${SceName}/PRMFRS.csv ../output/csv/${SceName}/MNGFRS.csv ../output/csv/${SceName}/OL.csv ../output/csv/${SceName}/GL.csv ../output/csv/${SceName}/PAS.csv ../output/csv/${SceName}/SL.csv"
    ncgenfunc all ${SceName} "${filelist}" ncheader_all 1
  fi
  #Carbon sequestration
  if [ ${carseq} == on ]; then
    filelist="../output/csv/${SceName}/ghg_AFR.csv ../output/csv/${SceName}/ghg_BIO.csv ../output/csv/${SceName}/ghg_LUC.csv ../output/csv/${SceName}/ghgc_AFR.csv ../output/csv/${SceName}/ghgc_BIO.csv ../output/csv/${SceName}/ghgc_LUC.csv"
    ncgenfunc ghg ${SceName} "${filelist}" ncheader_all_ghg 1
  fi
  #Livestock distribution
  if [ ${livdiscal} == on ]; then
    filelist="../output/csv/${SceName}/livestock_distribution.csv ../output/csv/${SceName}/BW_map.csv"
    ncgenfunc livdis ${SceName} "${filelist}" ncheader_livdis 1
  fi
}

function netcdfgen() {
  echo `date +"%m-%d-%y-%H-%M-%S"` 
  echo "NetCDF generation starts"
  FileCopyList=(ncheader_all_lumip ncheader_all final ncheader_all_yield ncheader_all_aimssprcplu_landcategory ncheader_all_wwf ncheader_all_ghg ncheader_livdis)
  for F in ${FileCopyList[@]} 
  do 
    cp ../${parent_dir}/data/ncheader/${F}.txt ../output/csv/${F}.txt 
  done

  for S in ${scn[@]} 
  do
    netcdfgenRun ${parent_dir} ${S} ${Sub_Netcdfgen_projectname} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_ssprcp} ${Sub_MergeResCSV4NC_carseq} ${Sub_MergeResCSV4NC_livdiscal} &
    LoopmultiCPU 5 scn "netcdfgenRun" ${CPUthreads}
  done
  wait
#File rename
  echo "NetCDF files renaming"
#Get scenario mapping
  awk 'BEGIN {FS="\t"} {OFS="\t"} {print $1}' ../${parent_dir}/data/scenariomap.txt  > ../output/txt/CGEscenario.txt
  awk 'BEGIN {FS="\t"} {OFS="\t"} {print $2}' ../${parent_dir}/data/scenariomap.txt  > ../output/txt/Outputscenario.txt
  CGEscenarioList=(`cat ../output/txt/CGEscenario.txt|xargs`)
  OutputscenarioList=(`cat ../output/txt/Outputscenario.txt|xargs`)
  CountScenario=$((${#CGEscenarioList[@]}-1))
  for scenario2 in ${CGEscenarioList[@]}; do
      for i in `seq 0 $((${CountScenario}))`; do
        if [ ${CGEscenarioList[$i]} == ${scenario2} ]; then
          ScenarioOutName2=${OutputscenarioList[$i]}
        fi
      done
      cp -f ../output/nc/AIM-LUmap_${scenario2}.nc ../output/nc/AIM-LUmap_${ScenarioOutName2}.nc
  done

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 7. PREDICTS execution
function PREDICTSRexe() { 
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Executing R script: Rscript "$2" "${@:3}" " 
    #Execute Rscript and capture each line of output
    Rscript --no-save --no-restore --no-site-file "$2" "${@:3}" > "$1" 2> >( while IFS= read -r line; do
        echo "$line"
    done)

    echo "$(date '+%Y-%m-%d %H:%M:%S') - R script execution finished" 
}
function PREDICTScalc {
  Rscript --no-save --no-restore --no-site-file ../${parent_dir}/tools/PREDICTS_biodiversity/prog/DataPrep/dirSettings.R AIMPLUM ${parent_dir}
  #Data preparation processs
  if [ ${Sub_PREDICTS_DataPrep}      == "on" ] && [ ${PRJ}     != "default" ]; then 
    echo "Running preparing data process ..."
    PREDICTSRexe "../output/lst/PREDICTS_pre1.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/DataPrep/process_climdata.R > "../output/log/PREDICTS_pre1.log" 2>&1 
    PREDICTSRexe "../output/lst/PREDICTS_pre2.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/DataPrep/process_humanpop.R ${gams_sys_dir} > "../output/log/PREDICTS_pre2.log" 2>&1 
    PREDICTSRexe "../output/lst/PREDICTS_pre3.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/DataPrep/process_PREDICTSdatabase.R > "../output/log/PREDICTS_pre3.log" 2>&1 
    PREDICTSRexe "../output/lst/PREDICTS_pre4.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/${PREDICTSmodelsettings}/biodiversityindex_calc.R > "../output/log/PREDICTS_pre4.log" 2>&1 
    echo "Preparing data process completed." 
  fi

  for S in ${scn[@]}
  do
    echo ${S}
    ScenarioSpecName

    #Estimate coefficients process
    if [ ${Sub_PREDICTS_EstCoefs}       == "on" ] && [ ${PRJ}     != "default" ]; then 
      echo "Estimating coefficients process ..."
      PREDICTSRexe "../output/lst/Estimate_coef.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/${PREDICTSmodelsettings}/estimate_coefficients.R ${PRJ} ${Climate_sce} ${SCE} > "../output/log/Coefficients_calc.log" 2>&1
      echo "Estimating coefficients process completed." 
    fi

    #PREDICTS projection process
    echo "Projecting Grid BII ..."
    PREDICTSRexe "../output/lst/PREDICTS_exe.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/${PREDICTSmodelsettings}/BII_grid.R ${S} ${PRJ} ${Climate_sce} > "../output/log/PREDICTS_exe.log" 2>&1
    echo "Gathring grid BII to regional"
    PREDICTSRexe "../output/lst/PREDICTS_exe2.lst" ../${parent_dir}/tools/PREDICTS_biodiversity/prog/${PREDICTSmodelsettings}/gathering_gridBII_to17region.R ${S} ${PRJ} ${gams_sys_dir} ${Climate_sce} > "../output/log/PREDICTS_exe2.log" 2>&1 
    echo "Projecting regional BII"
    gams ../${parent_dir}/prog/IAMCTemp_Ind.gms --prog_loc=${parent_dir} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV}  --ModelInt2=${ModelInt2} --PREDICTS_exe=on MaxProcDir=700  o=../output/lst/comparison_scenario_${S}.lst  lo=4 > "../output/log/PREDICTS_exe.log" 2>&1
          
  done
  echo "BII projection process completed."
  echo "All scenario merges have been done."
  cd ../output/gdx/comparison/
  gdxmerge *.gdx 
  mv -f merged.gdx ../all/Mergedcomparison.gdx
  cd ../../../exe
}
 
## 8. Graphics
function plot() {
  for S in ${scn[@]} 
  do
    #For LUMIP 
    if [ ${Sub_Plot_lumip} == on ]; then
      echo 'creating lumip category maps'
      R --vanilla --slave --args ${S} ${gams_sys_dir} < ../${parent_dir}/R/prog/plot_scenario_lumip.R
    fi
    #Bending the curve 
    if [ ${Sub_Plot_BTC} == on ]; then
      echo 'creating BtC category maps'
      R --vanilla --slave --args ${S} ${gams_sys_dir} < ../${parent_dir}/R/prog/plot_scenario_btc.R
    fi
  done

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 9. Merge All Results
function Allmerge() {
  cd ../output/gdx/analysis
  gdxmerge *.gdx output=../final_results.gdx
  cd ../../../exe

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

# Functions end -----------------------------------------------------------------------------------

cd ../
parent_dir=`basename ${PWD}`
rootdirorig=$PWD
echo "Parent directory is ${parent_dir}"

# Git Configuration
git config --global core.autocrlf false
git config --global --add safe.directory ${rootdirorig}

#Submodule updates
if [ -z "$(ls -A "../${parent_dir}/tools/PREDICTS_biodiversity" 2>/dev/null)" ]; then
  git submodule init
  git submodule update
  cd ../${parent_dir}/tools/PREDICTS_biodiversity 
  git switch main
  cd ../../
fi
# Settings
## load settings
source ../${parent_dir}/shell/settings/settings_cout.sh  # default
if [ $# -ge 1 ]; then
  source ../${parent_dir}/shell/settings/$1           # manual settings
fi

## set regions
if [ ${global} = "on" ]; then 
  COUNTRY0=(CIS XAF JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM XME XNF)
elif [ ${global} = "off" ]; then
  COUNTRY0=${CountryC}
fi

## set CPLEX threads number 
NSc=0
MaxThread=5
for S in ${scn[@]}
do
  NSc=$((${NSc} + 1))
done

CPLEXThreadOp=1
for Th in `seq 2 10`
do
  NScMl=$((${NSc}*${Th}))
  if [ ${CPUthreads} -gt ${NScMl} ]; then 
    CPLEXThreadOp=${Th}
  fi
done
if [ "$MaxThread" -lt "$CPLEXThreadOp" ]; then  CPLEXThreadOp=$MaxThread; fi
AvailRunNum4CPLEX=$(( (CPUthreads + CPLEXThreadOp - 1) / CPLEXThreadOp ))
echo "The number of CPLEX threads is ${CPLEXThreadOp} and parallel process is ${AvailRunNum4CPLEX}"

#Assign full list
FullList=()
for S in ${scn[@]};    do
  for A in ${COUNTRY0[@]};    do
    FullList+=("${S}_${A}")
  done
done

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
echo $savedir $baseos


if [ ${pausemode} = "on" ]; then read -p "push any key"; fi

# Model Execution
if [ ${DataPrep}       = "on" ]; then DataPrep       ; fi
if [ ${DataPrep2}      = "on" ]; then DataPrep2      ; fi
if [ ${Basesim}        = "on" ]; then Basesim        ; fi
if [ ${Futuresim}      = "on" ]; then Futuresim      ; fi
if [ ${ScnMerge}       = "on" ]; then ScnMerge       ; fi
if [ ${MergeResCSV4NC} = "on" ]; then MergeResCSV4NC ; fi
if [ ${netcdfgen}      = "on" ]; then netcdfgen      ; fi
if [ ${PREDICTS}       = "on" ]; then PREDICTScalc   ; fi
if [ ${plot}           = "on" ]; then plot           ; fi
if [ ${Allmerge}       = "on" ]; then Allmerge       ; fi

#read -p "All calculations have been done. [enter]"
