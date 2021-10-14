echo off

rem #### parameter settings
call :parameter_settings
call %1
if %global%==on set COUNTRY0=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
if %global%==off set COUNTRY0=%CountryC%
rem #### end of parameter settings

rem #### Basic configuration
cd ..\
rem #### git configuration
git config --global core.autocrlf input
call :sub "%cd%"
cd shell
rem #### end of basic configuration

rem #### process run
if %Basesim%==on ( call :Basesim )
if not exist ..\..\exe\mkdircomplete.txt ( call :makedirectory )
if %Basesim%==on ( call :Basesim )
if %Futuresim%==on ( call :Futuresim )
if %scenariomerge%==on ( call :scenariomerge )
if %mergeresCSV4NC%==on ( call :mergeresCSV4NC ) 
if %netcdfgen%==on ( call :netcdfgen )
if %PNGmake%==on ( call :PNGmake )
if %plot%==on ( call :plot )
if %Allmerge%==on ( call :Allmerge )
pause
exit
rem #### end of process run

rem #### subroutines

:sub
set pwd=%~n1
if "%pwd%"=="" set pwd=\
goto :EOF
exit /b

:makedirectory
setlocal enabledelayedexpansion
set dirlist= ..\..\exe ..\..\output ..\..\output\gdx ..\..\output\gdx\all ..\..\output\gdx\base ..\..\output\gdx\base\bio ^
             ..\..\output\gdx\analysis ..\..\output\gdx\landmap ..\..\output\gdx\results ..\..\output\csv ..\..\output\txt ..\..\output\cdl\
for %%M in (%dirlist%) do (
  if not exist %%M mkdir %%M
)
echo a > ..\..\exe\mkdircomplete.txt
for %%A in (%COUNTRY0%) do (
	if not exist ..\..\output\gdx\base\%%A\analysis mkdir ..\..\output\gdx\base\%%A\analysis
)
for %%F in (%scn%) do (
  set dirlist2=..\..\output\gdx\%%F ..\..\output\gdx\%%F\cbnal ..\..\output\gdx\%%F\analysis ..\..\output\gdx\%%F\bio ..\..\output\gdxii\%%F ^
              ..\..\output\csv\%%F ..\..\output\png\%%F
  for %%M in (!dirlist2!) do (
    if not exist %%M mkdir %%M
  )
  for %%A in (%COUNTRY0%) do (
  	if not exist ..\..\output\gdx\%%F\%%A\analysis mkdir ..\..\output\gdx\%%F\%%A\analysis
  	if not exist ..\..\output\gdxii\%%F\%%A mkdir ..\..\output\gdxii\%%F\%%A
  )
)
pause
exit /b

rem Base simulation
:Basesim
setlocal enabledelayedexpansion
  del ..\..\output\txt\base_*.txt
  for %%A in (%COUNTRY0%) do (
	echo a > ..\..\output\txt\base_%%A.txt
 	start call src\base_split1.bat %%A %pausemode% %closemode%
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
    start call src\scenario_all.bat %%F %pausemode% "%COUNTRY0%" "%YEAR%" %biocurve% %closemode%
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
    start call src\combine.bat %%F %pausemode% "%COUNTRY0%" %closemode%
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
    start call src\gdx2csv.bat %%F %pausemode% %closemode% %basecsv% %BTC3option% %lumip% %bioyielcal2% %ssprcp%
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

rem To generate NetCDF files.
:netcdfgen
setlocal enabledelayedexpansion
  set FileCopyList=ncheader_all_lumip ncheader_all final ncheader_all_yield ncheader_all_aimssprcplu_landcategory ncheader_all_wwf ncheader_all_wwf2 ncheader_all_wwf_landcategory ncheader_all_wwf_landcategory2 ncheader_all_wwf_landcategoryall
  for %%H in (%FileCopyList%) do (
    copy ..\data\ncheader\%%H.txt ..\..\output\csv\%%H.txt 
  )
  for %%F in (%scn%) do (
    start call src\csv2nc.bat %%F %pausemode% %closemode% %projectname% %lumip% %bioyielcal2% %BTC3option% %ssprcp%
  )
if %pausemode%==on pause
exit /b

rem ######  To creat PNG file of land use map using R, run LandUseModel3_gdx2txt.bat and a R code (R/prog/plot_all.R)
:PNGmake
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_plot_*.txt
  for %%F in (%scn%) do (
	echo a > ..\..\output\txt\scenario_plot_%%F.txt
    start call src\gdx4png.bat %%F %pausemode% "%YesrListFig%"
  )
:Loop25k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_plot_%%F.txt set NOWEXEC=ON
  )
  timeout /t 60 >nul && echo waiting for finising all process of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop25k

if %pausemode%==on pause
exit /b

:plot
  cd ..\R\prog\
  for %%F in (%scn%) do (
    R --vanilla --slave --args %%F < plot_scenario.R
  )
  cd ../../shell


:Allmerge
  gdxmerge "..\..\output\gdx\analysis\*.gdx" output="..\..\output\gdx\final_results.gdx"
exit /b

:parameter_settings
rem #### Default parameter configuration
rem if you would like to use pause for each program, turn on this switch
set pausemode=off
rem if you would like to automatically close the windows that are parallel processes for multiple scenarios, turn on this switch
set closemode=on
rem base year simulation switch
set Basesim=off
rem future year simulation switch
set Futuresim=off
rem bio supply curve switch
  set biocurve=off

rem scenario merge
set scenariomerge=on

rem merge results for each scenario and make csv for netcdf files (full runing excluing base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
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
  set bioyielcal=on
rem Netcdf creation
set netcdfgen=on
rem name of the project for netcdf file naming
  set projectname=BTC
rem Making GDX files for PNG file creation default map
set PNGmake=on
rem PNG file creation
set plot=on
rem merge final results for all scenarios 
set Allmerge=off

rem ####### for test run
rem set year. this should be ten year step and starting from 2010
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
set YesrListFig=2010 2050 2100
rem global on/off if global off then country code should be assigned
set global=on
rem this country code is valid only if global is off (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
set CountryC=JPN
rem set COUNTRY0=JPN IND
set scn=SSP2_BaU_NoCC
rem set scn=SSP2_BaU_NoCC SSP2_BaU_DEMFWR_JPN SSP2_BaU_DEMFWR_USA SSP2_BaU_DEMFWR_XE25 SSP2_BaU_DEMFWR_BRA SSP2_BaU_DEMFWR_CHN SSP2_BaU_DEMFWR_IND SSP2_BaU_DEMFWR_XOC SSP2_BaU_SUP_JPN SSP2_BaU_SUP_USA SSP2_BaU_SUP_XE25 SSP2_BaU_SUP_BRA SSP2_BaU_SUP_CHN SSP2_BaU_SUP_IND SSP2_BaU_SUP_XOC SSP2_BaU_SUP SSP2_BaU_SUP_NonOECD SSP2_BaU_SUP_OECD SSP2_BaU_All SSP2_BaU_DEMFWR SSP2_BaU_DEMFWR_OECD SSP2_BaU_DEMFWR_NonOECD
rem #### end of default parameter configuration

exit /b

rem #### end of subroutines
