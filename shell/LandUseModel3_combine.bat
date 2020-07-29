mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\analysis
mkdir ..\..\output\gdx\landmap
mkdir ..\..\output\gdx\base

rem-----------------------------
rem call settings\default.bat
call settings\%1

rem-----------------------------

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
pause
)))

pause

gdxmerge "..\output\gdx\analysis\*.gdx"
copy merged.gdx ..\output\gdx\final_results.gdx
del merged.gdx

pause

EXIT

