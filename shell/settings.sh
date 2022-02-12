#### Parameter configuration
####### for run
# set year. this should be ten year step and starting from 2010
YEAR0=(2010 2020 2030 2040 2050 2060 2070 2080 2090 2100)
# global on/off if global off then country code should be assigned
global=on
# this country code is valid only if global is off (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
# if you would like to plot multiple regions but from global model, then turn off "global" and put multipl regional codes into this CountryC 
CountryC=JPN
# set scenarios
# scn=(SSP2_BaU_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC SSP2_BaU_DEMFWR_JPN)
# scn=SSP2_BaU_NoCC SSP2_BaU_DEMFWR_JPN SSP2_BaU_DEMFWR_USA SSP2_BaU_DEMFWR_XE25 SSP2_BaU_DEMFWR_BRA SSP2_BaU_DEMFWR_CHN SSP2_BaU_DEMFWR_IND SSP2_BaU_DEMFWR_XOC SSP2_BaU_SUP_JPN SSP2_BaU_SUP_USA SSP2_BaU_SUP_XE25 SSP2_BaU_SUP_BRA SSP2_BaU_SUP_CHN SSP2_BaU_SUP_IND SSP2_BaU_SUP_XOC SSP2_BaU_SUP SSP2_BaU_SUP_NonOECD SSP2_BaU_SUP_OECD SSP2_BaU_All SSP2_BaU_DEMFWR SSP2_BaU_DEMFWR_OECD SSP2_BaU_DEMFWR_NonOECD)
scn=(SSP2_BaU_NoCC)
# CPU core threads that can be used in this process
CPUthreads=60

# if you would like to use pause for each program, turn on this switch
pausemode=off

# data preparation process
DataPrep=off
# base year simulation switch
Basesim=on
# future year simulation switch
Futuresim=on
# loop level change: CTY, SCN
Futuresim_loop=SCN
# switch whether normal scenario core run is carried out or not (normally it should be on)
Sub_Futuresim_NormalRun=on
# switch whether disaggregation of forest and other natural land is carried out or not (normally it should be on)
Sub_Futuresim_DisagrrFRS=on
# bio supply curve switch
Sub_Futuresim_biocurve=on

# scenario merge
ScenMerge=on
# option to calculation biomass supply curve
Sub_ScenMerge_BiocurveSort=on

# merge results for each scenario and make csv for netcdf files (full runing excluing base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
MergeResCSV4NC=on
# if you would like to make base calculation for this process, then turn on basecsv. This process can be skiped once you run (but needs to be run if you revised the results)
Sub_MergeResCSV4NC_basecsv=on
# if you would like to export lumip type netcdf turn on lumip switch. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
Sub_MergeResCSV4NC_lumip=on
# if you would like to make BTC basis 5 options, then turn on BTC3option. This switch will be also used in :netcdfgen (around 3GB per scenario memory and 5min are taken in this process)
Sub_MergeResCSV4NC_BTC3option=on
# if you would like to make AIMSSPRCP dataformat nc file, turn on. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
Sub_MergeResCSV4NC_ssprcp=on
# if you would like to make bioenergy potential yield turn on bioyieldcal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
Sub_MergeResCSV4NC_bioyielcal=on
# Netcdf creation
netcdfgen=on
# name of the project for netcdf file naming (only used for the BTC format)
sub_netcdfgen_projectname=BTC
# Making GDX files for PNG file creation default map
gdx4png=on
# set year for map visualization.
YearListFig=(2010 2050 2100)
# difference from base year is ploted if this switch on
sub_gdx4png_dif=on
# PNG file creation
plot=on
# merge final results for all scenarios 
Allmerge=on

if [ ${global} = "on" ]; then 
  COUNTRY0=(JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF)
elif [ ${global} = "off" ]; then
  COUNTRY0=${CountryC}
fi

# number of scenario
NSc=0
for S in ${scn[@]}
do
  NSc=$((${NSc} + 1))
done

# CPLEX number of threds options 
CPLEXThreadOp=1
for A in 2 3
do
  NScMl=$((${NSc}*${A}))
  if [ ${CPUthreads} -gt ${NScMl} ]; then CPLEXThreadOp=${A}; fi
done
echo "CPLEX number of threads is ${CPLEXThreadOp}"

if [ ${pausemode} = "on" ]; then read -p "push any key"; fi