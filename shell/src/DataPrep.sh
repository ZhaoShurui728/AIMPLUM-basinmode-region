DataPrep() {
  gams ../${parent_dir}/prog/data_prep.gms --prog_loc=${parent_dir} o=../output/lst/DataPrep.lst
  # scenario file generation
  rexe ../${parent_dir}/prog/shell_generation.R ${parent_dir}
  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
