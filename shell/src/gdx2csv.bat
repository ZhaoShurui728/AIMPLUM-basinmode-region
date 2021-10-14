rem -----------------------------
rem call settings\default.bat
call settings\%1

rem abondonned land treatment option.
set OPT=1 3 5
set pausemode=%2
set closemode=%3
set basecsv=%4
set BTC3option=%5
set lumip=%6
set bioyielcal=%7
set ssprcp=%8
rem -----------------------------
cd ..\..\exe

rem ### gdx files aggregation
gdxmerge "..\output\gdx\%1\analysis\*.gdx" output="..\output\gdx\results\results_%1.gdx"
rem ### csv file created
if %basecsv%==on gams ..\AIMPLUM\prog\gdx2csv.gms --split=1 --sce=%SCE% --clp=%CLP% --iav=%IAV% MaxProcDir=100 S=gdx2csv2nc1_%1
if %BTC3option%==on (
  for %%A in (%OPT%) do (
    gams ..\AIMPLUM\prog\gdx2csv.gms --split=2 --sce=%SCE% --clp=%CLP% --iav=%IAV% --wwfopt=%%A --wwfclass=opt MaxProcDir=100 R=gdx2csv2nc1_%1
  )
)
if %lumip%==on (
  gams ..\AIMPLUM\prog\gdx2csv.gms --split=2 --sce=%SCE% --clp=%CLP% --iav=%IAV% --wwfopt=1 --lumip=on MaxProcDir=100 R=gdx2csv2nc1_%1
)
if %bioyielcal%==on (
  gams ..\AIMPLUM\prog\gdx2csv.gms --split=2 --sce=%SCE% --clp=%CLP% --iav=%IAV% --bioyieldcalc=on MaxProcDir=100 R=gdx2csv2nc1_%1
)
if %ssprcp%==on (
  gams ..\AIMPLUM\prog\gdx2csv.gms --split=2 --sce=%SCE% --clp=%CLP% --iav=%IAV% --lumip=off --wwfclass=off MaxProcDir=100 R=gdx2csv2nc1_%1
)

del "..\output\gdx\results\results_%1.gdx"
echo a > ..\output\txt\scenario_merge_end_%1.txt
del ..\output\txt\scenario_merge_%1.txt

if not %closemode%==on pause
exit


