Soc1=SSP2
CL1=BaU
IA1="DEMFWR_JPN_lancet DEMFWR_USA_lancet DEMFWR_XE25_lancet DEMFWR_BRA_lancet DEMFWR_CHN_lancet DEMFWR_IND_lancet DEMFWR_XOC_lancet SUP_JPN SUP_USA SUP_XE25 SUP_BRA SUP_CHN SUP_IND SUP_XOC SUP SUP_NonOECD SUP_OECD All_lancet DEMFWR_lancet DEMFWR_OECD_lancet DEMFWR_NonOECD_lancet"
for Soc in ${Soc1}
do
  for CL in ${CL1}
  do
    for IA in ${IA1}
    do
    if [ -e ScenarioSet/${Soc}_${CL}_${IA}.bat ]; then
      echo "g"
    else
      echo -e "set SCE=${Soc}\nset CLP=${CL}\nset IAV=${IA}" > ScenarioSet/${Soc}_${CL}_${IA}.bat
    fi
    done
  done
done

for IA in ${IA1}
do
    if [ -e ../scenario/IAV/${IA}.gms ]; then
      echo "g"
    else
      cp ../scenario/IAV/NoCC.gms ../scenario/IAV/${IA}.gms
    fi
done