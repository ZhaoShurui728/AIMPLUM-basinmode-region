rem #### Parameter configuration
rem ####### for run
rem set year. this should be ten year step and starting from 2010
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
rem global on/off if global off then country code should be assigned
set global=on
rem this country code is valid only if global is off (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
rem if you would like to plot multiple regions but from global model, then turn off "global" and put multipl regional codes into this CountryC 
set CountryC=JPN
rem set scenarios
rem set scn=SSP2_BaU_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC SSP2_BaU_DEMFWR_JPN
rem set scn=SSP2_BaU_NoCC SSP2_BaU_DEMFWR_JPN SSP2_BaU_DEMFWR_USA SSP2_BaU_DEMFWR_XE25 SSP2_BaU_DEMFWR_BRA SSP2_BaU_DEMFWR_CHN SSP2_BaU_DEMFWR_IND SSP2_BaU_DEMFWR_XOC SSP2_BaU_SUP_JPN SSP2_BaU_SUP_USA SSP2_BaU_SUP_XE25 SSP2_BaU_SUP_BRA SSP2_BaU_SUP_CHN SSP2_BaU_SUP_IND SSP2_BaU_SUP_XOC SSP2_BaU_SUP SSP2_BaU_SUP_NonOECD SSP2_BaU_SUP_OECD SSP2_BaU_All SSP2_BaU_DEMFWR SSP2_BaU_DEMFWR_OECD SSP2_BaU_DEMFWR_NonOECD
set scn=SSP2_BaU_NoCC
rem CPU core threads that can be used in this process
set CPUthreads=60

rem if you would like to use pause for each program, turn on this switch
set pausemode=on

rem data preparation process
set DataPrep=off
rem base year simulation switch
set Basesim=on
rem future year simulation switch
set Futuresim=on
rem switch whether normal scenario core run is carried out or not (normally it should be on)
  set Sub_Futuresim_NormalRun=on
rem switch whether disaggregation of forest and other natural land is carried out or not (normally it should be on)
  set Sub_Futuresim_DisagrrFRS=on
rem bio supply curve switch
  set Sub_Futuresim_biocurve=on

rem scenario merge
set ScenMerge=on
rem option to calculation biomass supply curve
  set Sub_ScenMerge_BiocurveSort=off

rem merge results for each scenario and make csv for netcdf files (full runing excluing base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
set MergeResCSV4NC=on
rem if you would like to make base calculation for this process, then turn on basecsv. This process can be skiped once you run (but needs to be run if you revised the results)
  set Sub_MergeResCSV4NC_basecsv=on
rem if you would like to export lumip type netcdf turn on lumip switch. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
  set Sub_MergeResCSV4NC_lumip=on
rem if you would like to make BTC basis 5 options, then turn on BTC3option. This switch will be also used in :netcdfgen (around 3GB per scenario memory and 5min are taken in this process)
  set Sub_MergeResCSV4NC_BTC3option=on
rem if you would like to make AIMSSPRCP dataformat nc file, turn on. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
  set Sub_MergeResCSV4NC_ssprcp=on
rem if you would like to make bioenergy potential yield turn on bioyieldcal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
  set Sub_MergeResCSV4NC_bioyielcal=on
rem Netcdf creation
set netcdfgen=on
rem name of the project for netcdf file naming (only used for the BTC format)
  set sub_netcdfgen_projectname=BTC
rem Making GDX files for PNG file creation default map
set gdx4png=on
rem set year for map visualization.
  set YesrListFig=2010 2050 2100
rem difference from base year is ploted if this switch on
  set sub_gdx4png_dif=on
rem PNG file creation
set plot=on
rem merge final results for all scenarios 
set Allmerge=on

rem #### end of default parameter configuration
