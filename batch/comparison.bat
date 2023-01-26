mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

#call settings\default.bat

set SCE=SSP1 SSP2 SSP3 SSP4 SSP5
#set SCE=SSP2
set CLP=26W
set CLP=BaU
set IAV=NoCC


cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\prog\prog\comparison_scenario.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))
pause

gams ..\prog\prog\comparison.gms

pause

EXIT


EXIT

