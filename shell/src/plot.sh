# To make graphics
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
