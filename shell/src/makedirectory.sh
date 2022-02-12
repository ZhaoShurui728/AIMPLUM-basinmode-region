makedirectory() {
  while read line || [ -n "${line}" ]
  do
    eval mkdir -p ../${line}
  done < ../${parent_dir}/define/inc_shell/dir.txt
  echo a > ../exe/mkdircomplete.txt

  if [ ${global} = "on" ]; then COUNTRY_dir=(${COUNTRY0[@]} WLD); fi
  for A in ${COUNTRY_dir[@]}
  do
    mkdir -p ../output/gdx/base/${A}/analysis
  done
  
  for S in ${scn[@]}
  do
    while read line || [ -n "${line}" ]
    do
      eval mkdir -p ../${line}
    done < ../${parent_dir}/define/inc_shell/dir_scenario.txt

    for A in ${COUNTRY_dir[@]}
    do
      mkdir -p ../output/gdx/${S}/${A}/analysis
      mkdir -p ../output/gdxii/${S}/${A}
    done    
  done
}
