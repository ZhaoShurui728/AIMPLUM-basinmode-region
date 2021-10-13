
rem-----------------------------
rem call settings\default.bat
call settings\%1.bat
set pausemode=%2
set COUNTRY=%~3
set YEAR0=%~4
set biocurve=%5
set closemode=%6
rem-----------------------------

cd ..\..\exe

for %%A in (%COUNTRY%) do (
	copy ..\output\gdx\base\%%A\2005.gdx ..\output\gdx\%1\%%A\2005.gdx
	copy ..\output\gdx\base\%%A\analysis\2005.gdx ..\output\gdx\%1\%%A\analysis\2005.gdx
)

for %%B in (%YEAR%) do (
  for %%A in (%COUNTRY%) do (
	gams ..\AIMPLUM\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --parallel=on --biocurve=off  MaxProcDir=100
  )
rem	activate this if biocurve=on
  if %biocurve%==on (
    gams ..\AIMPLUM\prog\Bioland.gms --Sr=%%A --Sy=%%B --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --parallel=on MaxProcDir=100
  )
)
if %2==on pause

rem 3) Disaggregation of FRS and grassland
for %%A in (%COUNTRY%) do (
  for %%B in (%YEAR%) do (
	gams ..\AIMPLUM\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --biocurve=off MaxProcDir=100
    if %pausemode%==on pause
  )
)

echo a > ..\output\txt\scenario_sim_end_%1.txt
del ..\output\txt\scenario_sim_%1.txt
if not %closemode%==on pause
exit
