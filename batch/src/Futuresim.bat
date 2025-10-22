
rem-----------------------------
rem call settings\default.bat
call settings\%1.bat
set pausemode=%2
set COUNTRY=%~3
set YEAR0=%~4
set biocurve=%5
set NormalRun=%6
set DisagrrFRS=%7
set CPLEXThreadOp=%8
rem-----------------------------

cd ..\..\exe

for %%A in (%COUNTRY%) do (
	copy ..\output\gdx\base\%%A\2005.gdx ..\output\gdx\%1\%%A\2005.gdx
	copy ..\output\gdx\base\%%A\analysis\2005.gdx ..\output\gdx\%1\%%A\analysis\2005.gdx
)
  
for %%B in (%YEAR%) do (
  if %NormalRun%==on (
    for %%A in (%COUNTRY%) do (
	    gams ..\AIMPLUM\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --parallel=on --CPLEXThreadOp=%CPLEXThreadOp% --biocurve=off  MaxProcDir=100
    )
  )
rem	activate this if biocurve=on
  if %biocurve%==on (
    for %%A in (%COUNTRY%) do (
      gams ..\AIMPLUM\prog\Bioland.gms --Sr=%%A --Sy=%%B --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --parallel=on --supcuvout=on MaxProcDir=100
    )
  )
)
if %pausemode%==on pause

rem 3) Disaggregation of FRS and grassland
if %DisagrrFRS%==on (
  for %%A in (%COUNTRY%) do (
    for %%B in (%YEAR%) do (
	    gams ..\AIMPLUM\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --biocurve=off MaxProcDir=100
    )
  )
)
if %pausemode%==on pause

echo a > ..\output\txt\scenario_sim_end_%1.txt
del ..\output\txt\scenario_sim_%1.txt
exit
