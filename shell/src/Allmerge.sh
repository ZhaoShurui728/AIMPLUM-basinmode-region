# To merge all result
Allmerge() {
  cd ../output/gdx/analysis
  gdxmerge *.gdx output=../final_results.gdx
  cd ../../../exe

  if [ ${pausemode} = "on" ]; then read -p "push any key"; fi
}
