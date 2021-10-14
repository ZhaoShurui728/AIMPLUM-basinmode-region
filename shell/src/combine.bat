
rem-----------------------------
rem call settings\default.bat
call settings\%1
set pausemode=%2
set COUNTRY=%~3
set closemode=%4
rem-----------------------------

cd ..\..\exe

mkdir %1
cd %1
for %%A in (%COUNTRY%) do (
  gdxmerge "..\..\output\gdx\%1\%%A\*.gdx" output="..\..\output\gdx\%1\cbnal\%%A.gdx"
  gdxmerge "..\..\output\gdx\%1\%%A\analysis\*.gdx" output="..\..\output\gdx\%1\analysis\%%A.gdx"
)
gdxmerge "..\..\output\gdx\%1\bio\*.gdx" output="..\..\output\gdx\%1\bio.gdx"

cd ..\
rd /q /s %1
gams ..\AIMPLUM\prog\combine.gms --SCE=%SCE% --CLP=%CLP% --IAV=%IAV% --bioyielcal=on MaxProcDir=100

echo a > ..\output\txt\scenario_merge2_end_%1.txt
del ..\output\txt\scenario_merge2_%1.txt

if not %closemode%==on pause

exit
