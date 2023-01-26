mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\analysis
mkdir ..\..\output\gdx\landmap

set SCE=SSP1 SSP2 SSP3 SSP4 SSP5
set SCE=SSP2
set CLP=BaU
set IAV=NoCC
set IAV=NoCC

## CDLINKS_Ecosystem ##
set SCE=SSP2i
set CLP=BaU 20W_SPA1
set CLP=BaU

set SCE=SSP2
rem set CLP=INDC_CONT3


######################


cd ..\..\exe


for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\AIMPLUM\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E --supcuvout=off --bvcalc=off MaxProcDir=100
pause

)))

gdxmerge "..\output\gdx\analysis\*.gdx"
copy merged.gdx ..\output\gdx\final_results.gdx
del merged.gdx

pause

EXIT

