mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\analysis

set SCE=SSP1 SSP2 SSP3 SSP4 SSP5
set SCE=SSP3
set CLP=BaU

## CDLINKS_Ecosystem ##
set SCE=SSP2i
set CLP=BaU 20W_SPA1CO2 26W_SPA1CO2
set CLP=BaU

rem set SCE=SSP2
rem set CLP=INDC_CONT3


######################

set IAV=NoCC
cd ..\..\exe


for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E --supcuvout=off MaxProcDir=100

)))
pause

EXIT

