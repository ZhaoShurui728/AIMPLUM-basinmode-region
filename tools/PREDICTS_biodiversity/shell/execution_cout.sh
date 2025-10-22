#!/bin/bash
git config --global core.autocrlf input
export gams_sys_dir=`which gams --skip-alias|xargs dirname`
# Functions --------------------------------------------------------------------------
#-----function definition
# Scenario settings function
function ScenarioSpecName(){
source ../${parent_dir}/shell/settings/${S}.sh
if [ -z "${ModelInt}" ]; then
    ModelInt2="NoValue"
else
    ModelInt2=${ModelInt}
fi
}

# function which trace calYear to vector
# function calYearTrace() {
#     Rscript --no-save --no-restore --no-site-file "$1" "$2"
# }
# function calYearTraceRun() {
#     rm ../output/txt/PREDICTSCalYearList.csv
#     for Y in ${calYear[@]}
#     do
#      calYearTrace prog/DataPrep/calYearTrace.R ${Y}
#     done
# }

# fuctions for Rscript execution
function Rexe() { 
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Executing R script: Rscript "$2" "${@:3}" " 
    #Execute Rscript and capture each line of output
    Rscript --no-save --no-restore --no-site-file "$2" "${@:3}" > "$1" 2> >( while IFS= read -r line; do
        echo "$line"
    done)

    echo "$(date '+%Y-%m-%d %H:%M:%S') - R script execution finished" 
}

##  1.Data preparetion ------
# Data preparation 
function DataPrep {
    echo "Running preparing data process ..."

    if [ ${process_climdata}       = "on" ]; then 
     Rexe "../output/lst/PREDICTS_pre1.lst" prog/DataPrep/process_climdata.R > "../output/log/PREDICTS_pre1.log" 2>&1 ; fi
    if [ ${process_humanpopdata}     = "on" ]; then 
     Rexe "../output/lst/PREDICTS_pre2.lst" prog/DataPrep/process_humanpop.R ${gams_sys_dir} > "../output/log/PREDICTS_pre2.log" 2>&1 ; fi
    if [ ${process_PREDICTSdatabase}       = "on" ]; then 
     Rexe "../output/lst/PREDICTS_pre3.lst" prog/DataPrep/process_PREDICTSdatabase.R > "../output/log/PREDICTS_pre3.log" 2>&1 ; fi
    if [ ${calculate_biodiversityindex}       = "on" ]; then 
     Rexe "../output/lst/PREDICTS_pre4.lst" prog/${modelsettings}/biodiversityindex_calc.R > "../output/log/PREDICTS_pre4.log" 2>&1 ; fi

    echo "Preparing data process completed."    
}

##  2.Regression and Estimate coefficients -----
# Regression and Estimate coefficients Execution
# Define function for estimating coefficients
function EstCoefsRun {

  echo "Estimating coefficients process ..."

  for S in ${scn[@]}
  do
    echo ${S}
    ScenarioSpecName
    
    Rexe "../output/lst/Estimate_coef.lst" prog/${modelsettings}/estimate_coefficients.R ${PRJ} ${Climate_sce} ${SCE} > "../output/log/Coefficients_calc.log" 2>&1
  done 

  echo "Estinating coefficients process completed ."
}

##  3.Estimate BII ------
# Estimate BII Execution   
# Define function for estimating BII
function PREDICTScalcRun {

  echo "BII projection process ..."
  
  for S in ${scn[@]}
  do
    echo ${S}
    #ScenarioSpecName

    echo "Projecing grid BII"
    Rexe "../output/lst/PREDICTS_exe.lst" "prog/${modelsettings}/BII_grid.R" ${S} ${PRJ} ${Climate_sce} > "../output/log/PREDICTS_exe.log" 2>&1
    echo "Gathring grid BII to regional "
    Rexe "../output/lst/PREDICTS_exe2.lst" "prog/${modelsettings}/gathering_gridBII_to17region.R" ${S} ${PRJ} ${gams_sys_dir} ${Climate_sce} > "../output/log/PREDICTS_exe2.log" 2>&1

  done

  echo "BII projection process completed ."
}

# Functions end ------------------------------------------------------------------

cd ../

parent_dir=`basename ${PWD}`
echo "Parent directory is ${parent_dir}"

# Settings
    ## load settings
    if [ $# = 0 ]; then
    source ../${parent_dir}/shell/settings_cout.sh  # default
    elif [ $# -ge 1 ]; then
    source ../${parent_dir}/shell/$1           # manual settings
    fi

echo "modelsettings is ${modelsettings}"
echo "PRJ is ${PRJ}"
echo "Make the directory path list file"
Rscript --no-save --no-restore --no-site-file 'prog/DataPrep/dirSettings.R' ${dirSettings} ${parent_dir}

# Generate Directories
    dirlist="../output/BII/nc ../output/BII/csv ../output/processedData ../output/landuse ../output/analysis ../output/log ../output/lst ../output/coefficients ../output/txt/"
    for fl in ${dirlist}
    do
     mkdir -pm 777 ${fl}
    done

# Model Execution
if [ ${PRJ}       = "default" ]; then 
    echo "Pojection is default. Projecting BII with prepared coefficients."
    PREDICTScalcRun
else
    if [ ${DataPrep}       = "on" ]; then DataPrep       ; fi
    if [ ${EstCoefs}      = "on" ]; then EstCoefsRun      ; fi
    if [ ${PREDICTS_Projection}        = "on" ]; then PREDICTScalcRun        ; fi
fi 