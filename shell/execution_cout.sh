#!/bin/bash
cd `dirname $0`
git config --global core.autocrlf input
export gams_sys_dir=`which gams --skip-alias|xargs dirname`
#to make scenario names mapping for netCDF files, ../${parent_dir}/data/scenariomap.txt should be used.
# Functions ---------------------------------------------------------------------------------------
#-----function definition
function rexe() {
  R --no-save --no-restore --no-site-file --slave $2 < $1
} 
function ScenarioSpecName(){
  source ../${parent_dir}/shell/settings/${S}.sh
  if [ -z "${ModelInt}" ]; then
    ModelInt2="NoValue"
  else
    ModelInt2=${ModelInt}
  fi
}

function TimeDif() {
  Now=`date '+%s'`
  Dif=$((${Now}-$1))
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
#  echo "Waiting due to the core number limitation"
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
      mkdir -p ../output/gdxii/${S}/${A}
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
  gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=${A} --Sy=2005 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=on --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=100 o=../output/lst/Basesim/LandUseModel_mcp_${A}_base.lst   lo=4
  
  echo $(TimeDif `cat ../output/txt/cpu/basesim/$2.txt`) > ../output/txt/cpu/basesim/end_$2.txt
  rm ../output/txt/cpu/basesim/$2.txt
}
function BaseRunDisaggfrs() {
  echo "`date '+%s'`" > ../output/txt/cpu/basedsaggfrs/$2.txt
  gams ../$1/prog/disagg_FRSGL.gms --prog_loc=$1 --Sr=$2 --Sy=2005 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=100 o=../output/lst/Basesim/disagg_FRSGL_$2.lst   lo=4
  echo $(TimeDif `cat ../output/txt/cpu/basedsaggfrs/$2.txt`) > ../output/txt/cpu/basedsaggfrs/end_$2.txt
  rm ../output/txt/cpu/basedsaggfrs/$2.txt
}

function Basesim() {
  rm ../output/txt/cpu/basesim/*.txt 2> /dev/null
  rm ../output/txt/cpu/basedsaggfrs/*.txt 2> /dev/null
  S=${scn[0]}
  ScenarioSpecName
  for A in ${COUNTRY0[@]} 
  do
    BasesimRun ${parent_dir} ${A} ${CPLEXThreadOp} > ../output/log/Basesim_${A}.log 2>&1 &
    LoopmultiCPU 5 COUNTRY0 "basesim" ${CPUthreads}
  done
  wait
  echo "All base disaggregation have been done."

  for A in ${COUNTRY0[@]} 
  do
    BaseRunDisaggfrs ${parent_dir} ${A} ${CPLEXThreadOp} > ../output/log/Basedisagg_${A}.log 2>&1 &
    LoopmultiCPU 5 COUNTRY0 "basedsaggfrs" ${CPUthreads}
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

  for L in ${LOOP[@]}
  do
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

    for Y in ${YEAR[@]} 
    do
      gams ../$1/prog/LandUseModel_MCP.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=on --CPLEXThreadOp=${CPLEXThreadOp} --biocurve=off  MaxProcDir=100 o=../output/lst/Futuresim/LandUseModel_mcp_${A}_${SCE}_${CLP}_${IAV}${ModelInt}.lst   lo=4
    done
  done
  
  echo $(TimeDif `cat ../output/txt/cpu/futuresim/${PARALLEL}.txt`) > ../output/txt/cpu/futuresim/end_${PARALLEL}.txt
  rm ../output/txt/cpu/futuresim/${PARALLEL}.txt
}


function Futuresim() {
  rm ../output/txt/cpu/futuresim/* 2> /dev/null
  rm ../output/txt/cpu/futuresimpost/* 2> /dev/null
  echo future scenario simulation is run
  if [ ${Sub_Futuresim_NormalRun} = "on" ]; then
  if [ ${Sub_Futuresim_Loop} = "CTY" ]; then 
    for A in ${COUNTRY0[@]}
    do
    echo "Region ${A} simulation has been started." 
      FuturesimRun ${parent_dir} ${A} scn YEAR0 ${CPLEXThreadOp}  > ../output/log/futuresim_${A}.log 2>&1 &
      LoopmultiCPU 5 COUNTRY0 "futuresim" ${CPUthreads}
    done
  elif [ ${Sub_Futuresim_Loop} = "SCN" ]; then 
    for S in ${scn[@]}
    do
      echo "scenario ${S} simulation has been started." 
      FuturesimRun ${parent_dir} ${S} COUNTRY0 YEAR0 ${CPLEXThreadOp} > ../output/log/futuresim_${S}.log 2>&1 &
      LoopmultiCPU 5 scn "futuresim" ${CPUthreads}
    done
  fi
  fi
  wait
  echo "All future simulations have been done. Post process is running"

#Post process for disaggregation of forest and bioenergy
  if [ ${Sub_Futuresim_Biocurve} = "on" ]; then
  echo "Bioenergy curve is executed" 
    for S in ${scn[@]}
    do
    #Load scenario specification
      ScenarioSpecName
      for Y in ${YEAR0[@]}
      do
        gams ../${parent_dir}/prog/Bioland.gms --prog_loc=${parent_dir} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --parallel=on --supcuvout=on \
          MaxProcDir=100 o=../output/lst/Futuresim/Bioland_${SCE}_${CLP}_${IAV}${ModelInt}_${Y}.lst lf=../output/log/Futuresim/Bioland_${SCE}_${CLP}_${IAV}${ModelInt}_${Y}.log lo=4  > ../output/log/Bioland_${A}.log 2>&1 & 
      done
    done
  wait
  fi
  if [ ${Sub_Futuresim_DisagrrFRS} = "on" ]; then
  echo "Disaggregation of forest area is executed" 
  for S in ${scn[@]}
  do
    #Load scenario specification
    ScenarioSpecName
    for Y in ${YEAR0[@]}
    do
      for A in ${COUNTRY0[@]}
        do
          gams ../${parent_dir}/prog/disagg_FRSGL.gms --prog_loc=${parent_dir} --Sr=${A} --Sy=${Y} --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --biocurve=off \
            MaxProcDir=100 o=../output/lst/Futuresim/disagg_FRSGL_${A}_${SCE}_${CLP}_${IAV}${ModelInt}_${Y}.lst lo=4  > ../output/log/disagg_FRSGL_${A}.log 2>&1 & 
        done
      wait
    done
  done
  fi
  echo "All post processes have been done." 

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 4. Merge and Combine Results
function ScnMergeRun() {
  #Load scenario specification
  ScenarioSpecName
  declare -n COUNTRY=$3
  Biocurvesort=$4
  echo "`date '+%s'`" > ../output/txt/cpu/merge1/$2.txt
  for A in ${COUNTRY[@]}
  do
	# This change directry used for gdxmerge is to run with windows OS where the path with slash does not work in gdxmerge. 
	cd ../output/gdx/$2/${A}
	gdxmerge *.gdx 
	mv merged.gdx ../cbnal/${A}.gdx
	cd ./analysis
	gdxmerge *.gdx
	mv merged.gdx ../../analysis/${A}.gdx
	cd ../../../../../exe
 
  done
  cd ../output/gdx/$2/bio
  gdxmerge *.gdx
  mv -f merged.gdx ../bio.gdx
  cd ../../../../exe
  
  gams ../$1/prog/combine.gms --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV} --ModelInt2=${ModelInt2} --supcuvout=${Biocurvesort} MaxProcDir=100 o=../output/lst/combine_$2.lst  lo=4
  read -p "push any key";
  gams ../$1/prog/IAMCTemp_Ind.gms --prog_loc=$1 --SCE=${SCE} --CLP=${CLP} --IAV=${IAV}  --ModelInt2=${ModelInt2} MaxProcDir=100  o=../output/lst/comparison_scenario_$2.lst  lo=4
  read -p "push any key";

  echo $(TimeDif `cat ../output/txt/cpu/merge1/$2.txt`) > ../output/txt/cpu/merge1/end_$2.txt
  rm ../output/txt/cpu/merge1/$2.txt
}

function ScnMerge() {
  rm ../output/txt/cpu/merge1/*.txt 2> /dev/null
  echo scenario results merge
  
  for S in ${scn[@]}
  do
    ScnMergeRun ${parent_dir} ${S} COUNTRY0 ${Sub_ScnMerge_BiocurveSort} > ../output/log/ScnmergeRun_${S}.log 2>&1 &
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

  OPT=(1 3 5)
  basecsv=$3
  BTC3option=$4
  lumip=$5
  bioyielcal=$6
  ssprcp=$7
  carseq=$8

	echo "`date '+%s'`" > ../output/txt/cpu/merge2/$2.txt
  GAMSRunArg="--prog_loc=$1 --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt2=${ModelInt2} MaxProcDir=100 lo=4 "
  echo "--sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt2=${ModelInt2}"
  # csv file creation
  if [ ${basecsv} = "on" ]; then
    cd ../output/gdx/$2/analysis
    gdxmerge *.gdx output=../../results/results_$2.gdx
    cd ../../../../exe
    gams ../$1/prog/gdx2csv.gms --split=1 S=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv1_base_$2.lst lf=../output/log/gdx2csv1_base_$2.log ${GAMSRunArg}
  fi

  if [ ${BTC3option} = "on" ]; then
    for O in ${OPT[@]} 
    do
      gams ../$1/prog/gdx2csv.gms --wwfopt=${O} --split=2 --wwfclass=opt R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_$2.lst lf=../output/log/gdx2csv2_$2.log ${GAMSRunArg}
    done
  fi

  if [ ${lumip} = "on" ]; then
    gams ../$1/prog/gdx2csv.gms --wwfopt=1 --split=2 --lumip=on R=${savedir}gdx2csv2nc1_$2 o=../output/lst/gdx2csv2_lumip_$2.lst lf=../output/log/gdx2csv2_lumip_$2.log  ${GAMSRunArg}
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

  echo $(TimeDif `cat ../output/txt/cpu/merge2/$2.txt`) > ../output/txt/cpu/merge2/end_$2.txt
  rm ../output/txt/cpu/merge2/$2.txt
}

function MergeResCSV4NC() {
  rm ../output/txt/cpu/merge2/*.txt 2> /dev/null
  for S in ${scn[@]} 
  do
    MergeResCSV4NCRun ${parent_dir} ${S} ${Sub_MergeResCSV4NC_basecsv} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_ssprcp} ${Sub_MergeResCSV4NC_carseq} > ../output/log/MergeResCSV4NCRun_${S}.log 2>&1 &
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

  #For LUMIP 
  if [ ${lumip} == on ]; then
    filelist="../output/csv/${SceName}/c3ann.csv ../output/csv/${SceName}/c3nfx.csv ../output/csv/${SceName}/c4ann.csv ../output/csv/${SceName}/crpbf_c4ann.csv ../output/csv/${SceName}/irrig_c3ann.csv ../output/csv/${SceName}/irrig_c3nfx.csv ../output/csv/${SceName}/irrig_c4ann.csv ../output/csv/${SceName}/pastr.csv ../output/csv/${SceName}/primf.csv ../output/csv/${SceName}/range.csv ../output/csv/${SceName}/secdf.csv ../output/csv/${SceName}/urban.csv ../output/csv/${SceName}/flood.csv ../output/csv/${SceName}/fallow.csv"
    ncgenfunc lumip ${SceName} "${filelist}" ncheader_all_lumip 1
  fi
  #Bioenergy yield
  if [ ${bioyielcal} == on ]; then
    filelist="../output/csv/${SceName}/yield_BIO.csv ../output/csv/${SceName}/yield_AFR.csv"
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
  #Carbon sequestration
  if [ ${carseq} == on ]; then
    filelist="../output/csv/${SceName}/ghg_AFR.csv ../output/csv/${SceName}/ghg_BIO.csv ../output/csv/${SceName}/ghg_LUC.csv ../output/csv/${SceName}/ghgc_AFR.csv ../output/csv/${SceName}/ghgc_BIO.csv ../output/csv/${SceName}/ghgc_LUC.csv"
    ncgenfunc ghg ${SceName} "${filelist}" ncheader_all_ghg 1
  fi
}

function netcdfgen() {
  FileCopyList=(ncheader_all_lumip ncheader_all final ncheader_all_yield ncheader_all_aimssprcplu_landcategory ncheader_all_wwf ncheader_all_wwf2 ncheader_all_wwf_landcategory ncheader_all_wwf_landcategory2 ncheader_all_wwf_landcategoryall ncheader_all_ghg)
  for F in ${FileCopyList[@]} 
  do 
    cp ../${parent_dir}/data/ncheader/${F}.txt ../output/csv/${F}.txt 
  done

  for S in ${scn[@]} 
  do
    netcdfgenRun ${parent_dir} ${S} ${Sub_Netcdfgen_projectname} ${Sub_MergeResCSV4NC_lumip} ${Sub_MergeResCSV4NC_bioyielcal} ${Sub_MergeResCSV4NC_BTC3option} ${Sub_MergeResCSV4NC_ssprcp} ${Sub_MergeResCSV4NC_carseq}
  done
#File rename
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

## 7. Generation of GDX Files for Plotting
function gdx4pngRun() {
  #Load scenario specification
  ScenarioSpecName
  declare -n YListFig=$3
  global=$4
  declare -n COUNTRY=$5  
  dif=$6

  echo ${YListFig[@]} > ../output/txt/$2_year.txt
  echo "`date '+%s'`" > ../output/txt/cpu/gdx4png/$2.txt

  for Y in ${YListFig[@]} 
  do
    if [ ${global} = "on" ]; then
      gams ../$1/prog/gdx4png.gms --prog_loc=$1 --Sr=WLD --Sy=${Y} --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt2=${ModelInt2} --dif=${dif} MaxProcDir=100 o=../output/lst/gdx4png1.lst
    elif [ ${global} = "off" ]; then
      for A in ${COUNTRY[@]} 
      do
        gams ../$1/prog/gdx4png.gms --prog_loc=$1 --Sr=${A} --Sy=${Y} --sce=${SCE} --clp=${CLP} --iav=${IAV} --ModelInt2=${ModelInt2} --dif=${dif} MaxProcDir=100 o=../output/lst/gdx4png2.lst
      done
    fi
  done

  echo $(TimeDif `cat ../output/txt/cpu/gdx4png/$2.txt`) > ../output/txt/cpu/gdx4png/end_$2.txt
  rm ../output/txt/cpu/gdx4png/$2.txt
}

function gdx4png() {
  rm ../output/txt/cpu/gdx4png/*.txt 2> /dev/null
  
  for S in ${scn[@]} 
  do
    gdx4pngRun ${parent_dir} ${S} YearListFig ${global} COUNTRY0 ${Sub_gdx4png_dif} &
    LoopmultiCPU 5 scn "gdx4png" ${CPUthreads}
  done
  wait
  echo "GDX preparation for plot has been done."

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}

## 8. Graphics
function plot() {
  for S in ${scn[@]} 
  do
    if [ ${global} = "on" ]; then
      echo "WLD" > ../output/txt/${S}_region.txt
    else
      echo ${CountryC} > ../output/txt/${S}_region.txt
    fi
    R --vanilla --slave --args ${S} ${gams_sys_dir} < ../${parent_dir}/R/prog/plot_scenario.R 
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
echo "Parent directory is ${parent_dir}"

#Unzip large files
targzlist=(visit_forest_growth_function)
cat ../${parent_dir}/largefile/DataBiomass.* >> ../${parent_dir}/largefile/biomassdata.tar.gz  ##Original directory is zip by "tar czvf - biomass | split -d -b 50M - DataBiomass.tar.gz"
for fl in ${targzlist[@]}
do
  if [ ! -e ../${parent_dir}/data/${fl}.gdx ]; then tar -zxvf ../${parent_dir}/largefile/${fl}.tar.gz -C ../${parent_dir}/data; fi
done
if [ ! -e ../${parent_dir}/data/biomass/data/rcp_grid.gdx ]; then tar zxfvmp ../${parent_dir}/largefile/biomassdata.tar.gz -C ../${parent_dir}/data; fi
rm ../${parent_dir}/largefile/biomassdata.tar.gz

# Settings
## load settings
source ../${parent_dir}/shell/settings_cout.sh  # default
if [ $# -ge 1 ]; then
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
if [ ${gdx4png}        = "on" ]; then gdx4png        ; fi
if [ ${plot}           = "on" ]; then plot           ; fi
if [ ${Allmerge}       = "on" ]; then Allmerge       ; fi

#read -p "All calculations have been done. [enter]"
