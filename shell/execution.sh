#!/bin/bash
cd `dirname $0`

# Get Model Directory Name
cd ../
parent_dir=`basename ${PWD}`
echo "Parent directory is ${parent_dir}"

# functions
fun=(makedirectory DataPrep Extra Basesim Futuresim Futuresim_loop_scn ScenMerge MergeResCSV4NC netcdfgen gdx4png plot Allmerge)

for F in ${fun[@]}
do
  source ../${parent_dir}/shell/src/${F}.sh
done

# User Settings
source ../${parent_dir}/shell/settings.sh

#### git configuration
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

# Model Execution
if [ ${DataPrep}        = "on" ]; then DataPrep        ; fi
if [ ${Basesim}         = "on" ]; then Basesim         ; fi
if [ ${Futuresim}       = "on" ]; then 
  if [ ${Futuresim_loop} = "CTY" ]   ; then Futuresim
  elif [ ${Futuresim_loop} = "SCN" ]; then Futuresim_loop_scn ; fi
fi
if [ ${ScenMerge}       = "on" ]; then ScenMerge       ; fi
if [ ${MergeResCSV4NC}  = "on" ]; then MergeResCSV4NC  ; fi
if [ ${netcdfgen}       = "on" ]; then netcdfgen       ; fi
if [ ${gdx4png}         = "on" ]; then gdx4png         ; fi
if [ ${plot}            = "on" ]; then plot            ; fi
if [ ${Allmerge}        = "on" ]; then Allmerge        ; fi

read -p "All processes are done. [enter]"