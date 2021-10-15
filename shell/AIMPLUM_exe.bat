echo off

rem #### parameter settings
call :parameter_settings
call %1
if %global%==on set COUNTRY0=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
if %global%==off set COUNTRY0=%CountryC%
if %pausemode%==on echo on
set NSc=0
for %%F in (%scn%) do (
  set /a NSc = %NSc% + 1
)
set CPLEXThreadOp=1
for %%A in ( 2 3 ) do (
  set /a NScMl = %NSc% * %%A
  if %CPUthreads% geq %NScMl% ( set CPLEXThreadOp=%%A )
  echo %%A
)
rem #### end of parameter settings

rem #### Basic configuration
cd ..\
rem #### git configuration
git config --global core.autocrlf input
call :sub "%cd%"
cd shell
rem #### end of basic configuration

rem #### process run
if not exist ..\..\exe\mkdircomplete.txt ( call :makedirectory )
if %DataPrep%==on ( call src\DataPrep.bat )
if %Basesim%==on ( call :Basesim )
if %Futuresim%==on ( call :Futuresim )
if %ScenMerge%==on ( call :ScenMerge )
if %MergeResCSV4NC%==on ( call :MergeResCSV4NC ) 
if %netcdfgen%==on ( call :netcdfgen )
if %gdx4png%==on ( call :gdx4png )
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
 	  start call src\Basesim.bat %%A %pausemode% %CPLEXThreadOp%
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
    start call src\Futuresim.bat %%F %pausemode% "%COUNTRY0%" "%YEAR%" %Sub_Futuresim_biocurve% %Sub_Futuresim_NormalRun% %Sub_Futuresim_DisagrrFRS% %CPLEXThreadOp%
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
:ScenMerge
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_merge2_*.txt
  for %%F in (%scn%) do (
    echo a > ..\..\output\txt\scenario_merge2_%%F.txt
    start call src\ScenMerge.bat %%F %pausemode% "%COUNTRY0%" %Sub_ScenMerge_BiocurveSort%
  )


:Loop16k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_merge2_%%F.txt set NOWEXEC=ON
  )
  timeout /t 60 >nul && echo waiting for finising all ScenMerge processes of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop16k
if %pausemode%==on pause
exit /b

rem ######  To creat NetCDF file of land use map, ascii files are generated. 
:MergeResCSV4NC
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_merge_*.txt
  for %%F in (%scn%) do (
	echo a > ..\..\output\txt\scenario_merge_%%F.txt
    start call src\MergeResCSV4NC.bat %%F %pausemode% %Sub_MergeResCSV4NC_basecsv% %Sub_MergeResCSV4NC_BTC3option% %Sub_MergeResCSV4NC_lumip% %Sub_MergeResCSV4NC_bioyielcal% %Sub_MergeResCSV4NC_ssprcp%
  )

:Loop2k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_merge_%%F.txt set NOWEXEC=ON
  )
  timeout /t 20 >nul && echo waiting for finising all MergeResCSV4NC processes of scenario runs
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
    start call src\netcdfgen.bat %%F %pausemode% %sub_netcdfgen_projectname% %Sub_MergeResCSV4NC_lumip% %Sub_MergeResCSV4NC_bioyielcal% %Sub_MergeResCSV4NC_BTC3option% %Sub_MergeResCSV4NC_ssprcp%
  )
if %pausemode%==on pause
exit /b

rem ######  To creat PNG file of land use map using R, run LandUseModel3_gdx2txt.bat and a R code (R/prog/plot_all.R)
:gdx4png
setlocal enabledelayedexpansion
  del ..\..\output\txt\scenario_plot_*.txt
  for %%F in (%scn%) do (
	echo a > ..\..\output\txt\scenario_plot_%%F.txt
    start call src\gdx4png.bat %%F %pausemode% "%YesrListFig%" %global% "%COUNTRY0%" %Sub_gdx4png_dif%
  )
:Loop25k
  set NOWEXEC=OFF
  for %%F in (%scn%) do (
	if exist ..\..\output\txt\scenario_plot_%%F.txt set NOWEXEC=ON
  )
  timeout /t 10 >nul && echo waiting for finising PNGmake process of scenario runs
  if "!NOWEXEC!" EQU "ON" goto Loop25k

if %pausemode%==on pause
exit /b

:plot
  cd ..\R\prog\
  for %%F in (%scn%) do (
    if %global%==on ( 
      echo WLD > ../../../output/txt/%%F_region.txt
    ) else (
      echo %CountryC% > ../../../output/txt/%%F_region.txt
    )
    R --vanilla --slave --args %%F < plot_scenario.R
  )
  cd ../../shell
exit /b


:Allmerge
  gdxmerge "..\..\output\gdx\analysis\*.gdx" output="..\..\output\gdx\final_results.gdx"
exit /b

:parameter_settings
rem #### Default parameter configuration
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
set pausemode=off

rem data preparation process
set DataPrep=off
rem base year simulation switch (roughly taking one hour)
set Basesim=off
rem future year simulation switch
set Futuresim=on
rem switch whether normal scenario core run is carried out or not (normally it should be on)
  set Sub_Futuresim_NormalRun=on
rem switch whether disaggregation of forest and other natural land is carried out or not (normally it should be on) (Rounghly taking 15 min)
  set Sub_Futuresim_DisagrrFRS=on
rem bio supply curve switch
  set Sub_Futuresim_biocurve=off

rem scenario merge
set ScenMerge=on
rem option to calculation biomass supply curve
  set Sub_ScenMerge_BiocurveSort=off

rem merge results for each scenario and make csv for netcdf files (full runing excluing base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
set MergeResCSV4NC=on
rem if you would like to make base calculation for this process, then turn on basecsv. This process can be skiped once you run (but needs to be run if you revised the results)
  set Sub_MergeResCSV4NC_basecsv=off
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
rem difference from base year is ploted if this switch on
  set sub_gdx4png_dif=off
rem set year for map visualization.
  set YesrListFig=2010 2050 2100
rem PNG file creation
set plot=on
rem merge final results for all scenarios 
set Allmerge=off

exit /b
rem #### end of default parameter configuration

rem #### end of subroutines
