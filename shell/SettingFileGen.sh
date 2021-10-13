Soc1=SSP2
CL1=BaU
IA1="DEMFWR_JPN DEMFWR_USA DEMFWR_XE25 DEMFWR_BRA DEMFWR_CHN DEMFWR_IND DEMFWR_XOC SUP_JPN SUP_USA SUP_XE25 SUP_BRA SUP_CHN SUP_IND SUP_XOC SUP SUP_NonOECD SUP_OECD All DEMFWR DEMFWR_OECD DEMFWR_NonOECD"
for Soc in ${Soc1}
do
  for CL in ${CL1}
  do
    for IA in ${IA1}
    do
    if [ -e settings/${Soc}_${CL}_${IA}.bat ]; then
      echo "g"
    else
      echo -e "set SCE=${Soc}\nset CLP=${CL}\nset IAV=${IA}" > settings/${Soc}_${CL}_${IA}.bat
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