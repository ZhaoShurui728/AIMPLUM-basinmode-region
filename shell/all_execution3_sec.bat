rem @echo off

set pausemode=off
set closemode=on
rem base year simulation switch
set basesim=off
rem future year simulation switch
set Futuresim=off
rem bio supply curve switch
  set biocurve=off

rem scenario merge
set scenariomerge=off
rem if you would like to calculate bioenergy potential yield turn on bioyieldcal (it would take time around 1 hour per scenario) This would also change the condition of CSV file generation process
  set bioyielcal=off

rem merge results for each scenario and make csv for netcdf files
set mergeresCSV4NC=on
rem if you would like to make base calculation for this process, then turn on basecsv. This process can be skiped once you run (but needs to be run if you revised the results)
  set basecsv=off
rem if you would like to export lumip type netcdf turn on lumip switch. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
  set lumip=on
rem if you would like to make BTC basis 5 options, then turn on BTC3option. This switch will be also used in :netcdfgen (around 3GB per scenario memory and 5min are taken in this process)
  set BTC3option=on
rem if you would like to make AIMSSPRCP dataformat nc file, turn on. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
  set ssprcp=on
rem if you would like to make bioenergy potential yield turn on bioyieldcal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
  set bioyielcal2=on
rem Netcdf creation
set netcdfgen=on
rem name of the project for netcdf file naming
  set projectname=BTC
rem PNG file creation
set PNGmake=off
rem merge final results for all scenarios 
set Allmerge=off
rem plot world map
set Plot=off

rem ####### for test run
rem set year. this should be ten year step and starting from 2010
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
set YesrListFig=2010 2050 2100
set COUNTRY0=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
rem set COUNTRY0=XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR
rem set COUNTRY0=JPN IND
rem set scn=SSP2_BaU_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC
rem set scn=SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC
rem set scn=SSP2NoAff_800Cf_CACNup200_NoCC
rem set scn=SSP2_BaU_DEMFWR_JPN
set scn=SSP2_BaU_NoCC
set scn=SSP2_BaU_NoCC SSP2_BaU_DEMFWR_JPN SSP2_BaU_DEMFWR_USA SSP2_BaU_DEMFWR_XE25 SSP2_BaU_DEMFWR_BRA SSP2_BaU_DEMFWR_CHN SSP2_BaU_DEMFWR_IND SSP2_BaU_DEMFWR_XOC SSP2_BaU_SUP_JPN SSP2_BaU_SUP_USA SSP2_BaU_SUP_XE25 SSP2_BaU_SUP_BRA SSP2_BaU_SUP_CHN SSP2_BaU_SUP_IND SSP2_BaU_SUP_XOC SSP2_BaU_SUP SSP2_BaU_SUP_NonOECD SSP2_BaU_SUP_OECD SSP2_BaU_All SSP2_BaU_DEMFWR SSP2_BaU_DEMFWR_OECD SSP2_BaU_DEMFWR_NonOECD
rem ########

call :makedirectory
if %basesim%==on ( call :basesim )
if %Futuresim%==on ( call :Futuresim )
if %scenariomerge%==on ( call :scenariomerge )
if %mergeresCSV4NC%==on ( call :mergeresCSV4NC ) 
if %netcdfgen%==on ( call :netcdfgen )
if %PNGmake%==on ( call :PNGmake )
if %Allmerge%==on ( call :Allmerge )
if %Plot%==on ( call :Plot )

pause
exit

:makedirectory
setlocal enabledelayedexpansion
set dirlist= ..\..\exe ..\..\output ..\..\output\gdx ..\..\output\gdx\all ..\..\output\gdx\base ..\..\output\gdx\base\bio ^
             ..\..\output\gdx\analysis ..\..\output\gdx\landmap ..\..\output\gdx\results ..\..\output\csv ..\..\output\txt ..\..\output\cdl\
for %%M in (%dirlist%) do (
  if not exist %%M mkdir %%M
)
for %%A in (%COUNTRY0%) do (
	if not exist ..\..\output\gdx\base\%%A\analysis mkdir ..\..\output\gdx\base\%%A\analysis
)
for %%F in (%scn%) do (
  set dirlist2=..\..\output\gdx\%%F ..\..\output\gdx\%%F\cbnal ..\..\output\gdx\%%F\analysis ..\..\output\gdx\%%F\bio ..\..\output\txt\%%F ^
              ..\..\output\csv\%%F ..\..\output\png\%%F ..\..\output\gdxii\%%F
  for %%M in (!dirlist2!) do (
    if not exist %%M mkdir %%M
  )
  for %%A in (%COUNTRY0%) do (
  	if not exist ..\..\output\gdx\%%F\%%A\analysis mkdir ..\..\output\gdx\%%F\%%A\analysis
	if not exist ..\..\output\txt\%%F\%%A mkdir ..\..\output\txt\%%F\%%A
  	if not exist ..\..\output\gdxii\%%F\%%A mkdir ..\..\output\gdxii\%%F\%%A
  )
)
exit /b

rem Base simulation
:basesim
setlocal enabledelayedexpansion
  del ..\..\output\txt\base_*.txt
  for %%A in (%COUNTRY0%) do (
	echo a > ..\..\output\txt\base_%%A.txt
 	start call LandUseModel3_split1.bat %%A %pausemode% %closemode%
  )
:Loop1k
  set NOWEXEC=OFF
  for %%A in (%COUNTRY0%) do (
	if exist ..\..\output\txt\base_%%A.txt set NOWEXEC=ON
  )
  timeout /t 60 >nul && echo waiting for finising all process of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop1k
if %pausemode%==on pause
exit /b

rem ######  Land allocation calculation
:Futuresim
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_sim_*.txt
  for %%F in (%scn%) do (
    echo a > ..\..\output\txt\scenario_sim_%%F.txt
    start call LandUseModel3_all.bat %%F %pausemode% "%COUNTRY0%" "%YEAR%" %biocurve% %closemode%
  )
:Loop15k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_sim_%%F.txt set NOWEXEC=ON
  )
  timeout /t 60 >nul && echo waiting for finising all process of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop15k
if %pausemode%==on pause
exit /b


rem ######  Just to merge and conbine results
:scenariomerge
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_merge2_*.txt
  for %%F in (%scn%) do (
    echo a > ..\..\output\txt\scenario_merge2_%%F.txt
    start call LandUseModel3_combine.bat %%F %pausemode% "%COUNTRY0%" %bioyielcal% %closemode%
  )
:Loop16k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_merge2_%%F.txt set NOWEXEC=ON
  )
  timeout /t 60 >nul && echo waiting for finising all process of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop16k
if %pausemode%==on pause
exit /b

rem ######  To creat NetCDF file of land use map, run LandUseModel3_gdx2csv.bat and a bat file (shell/csv2nc.bat)
:mergeresCSV4NC
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_merge_*.txt
  for %%F in (%scn%) do (
	echo a > ..\..\output\txt\scenario_merge_%%F.txt
    start call LandUseModel3_gdx2csv.bat %%F %pausemode% %closemode% %basecsv% %BTC3option% %lumip% %bioyielcal2% %ssprcp%
  )

:Loop2k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_merge_%%F.txt set NOWEXEC=ON
  )
  timeout /t 60 >nul && echo waiting for finising all process of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop2k
if %pausemode%==on pause
exit /b

rem TO generate NetCDF files.
:netcdfgen
setlocal enabledelayedexpansion
  for %%F in (%scn%) do (
    start call csv2nc.bat %%F %pausemode% %closemode% %projectname% %lumip% %bioyielcal2% %BTC3option% %ssprcp%
  )
if %pausemode%==on pause
exit /b

rem ######  To creat PNG file of land use map using R, run LandUseModel3_gdx2txt.bat and a R code (R/prog/plot_all.R)
:PNGmake
setlocal enabledelayedexpansion
  for %%F in (%scn%) do (
    start call LandUseModel3_gdx2txt.bat %%F %pausemode% "%YesrListFig%"
  )
exit /b

:Plot
  cd ..\R\prog\
  for %%F in (%scn%) do (
    R --vanilla --slave --args %%F < plot_scenario.R
  )
  cd ../../shell
exit /b

:Allmerge
  gdxmerge "..\..\output\gdx\analysis\*.gdx" output="..\..\output\gdx\final_results.gdx"
exit /b


pause
