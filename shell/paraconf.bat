rem #### Parameter configuration
rem if you would like to use pause for each program, turn on this switch
set pausemode=off
rem if you would like to automatically close the windows that are parallel processes for multiple scenarios, turn on this switch
set closemode=off
rem base year simulation switch
set Basesim=off
rem future year simulation switch
set Futuresim=off
rem bio supply curve switch
  set biocurve=off

rem scenario merge
set scenariomerge=on
rem if you would like to calculate bioenergy potential yield turn on bioyieldcal (it would take time around 1 hour per scenario) This would also change the condition of CSV file generation process
  set bioyielcal=on

rem merge results for each scenario and make csv for netcdf files (full runing excluing base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
set mergeresCSV4NC=on
rem if you would like to make base calculation for this process, then turn on basecsv. This process can be skiped once you run (but needs to be run if you revised the results)
  set basecsv=off
rem if you would like to export lumip type netcdf turn on lumip switch. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
  set lumip=off
rem if you would like to make BTC basis 5 options, then turn on BTC3option. This switch will be also used in :netcdfgen (around 3GB per scenario memory and 5min are taken in this process)
  set BTC3option=off
rem if you would like to make AIMSSPRCP dataformat nc file, turn on. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
  set ssprcp=off
rem if you would like to make bioenergy potential yield turn on bioyieldcal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
  set bioyielcal=on
rem Netcdf creation
set netcdfgen=on
rem name of the project for netcdf file naming
  set projectname=BTC
rem Making GDX files for PNG file creation default map
set PNGmake=off
rem PNG file creation
set plot=off
rem merge final results for all scenarios 
set Allmerge=off

rem ####### for run
rem set year. this should be ten year step and starting from 2010
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
set YesrListFig=2010 2050 2100
rem global on/off if global off then country code should be assigned
set global=on
rem this country code is valid only if global is off (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
set CountryC=JPN

rem set COUNTRY0=JPN IND
rem set scn=SSP2_BaU_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC
rem set scn=SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC
rem set scn=SSP2NoAff_800Cf_CACNup200_NoCC
rem set scn=SSP2_BaU_DEMFWR_JPN
set scn=SSP2_BaU_NoCC SSP2_BaU_DEMFWR_JPN SSP2_BaU_DEMFWR_USA SSP2_BaU_DEMFWR_XE25 SSP2_BaU_DEMFWR_BRA SSP2_BaU_DEMFWR_CHN SSP2_BaU_DEMFWR_IND SSP2_BaU_DEMFWR_XOC SSP2_BaU_SUP_JPN SSP2_BaU_SUP_USA SSP2_BaU_SUP_XE25 SSP2_BaU_SUP_BRA SSP2_BaU_SUP_CHN SSP2_BaU_SUP_IND SSP2_BaU_SUP_XOC SSP2_BaU_SUP SSP2_BaU_SUP_NonOECD SSP2_BaU_SUP_OECD SSP2_BaU_All SSP2_BaU_DEMFWR SSP2_BaU_DEMFWR_OECD SSP2_BaU_DEMFWR_NonOECD
set scn=SSP2_BaU_NoCC
rem #### end of default parameter configuration
