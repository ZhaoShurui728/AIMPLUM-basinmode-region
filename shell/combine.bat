mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

set SCE=SSP2
#set SCE=SSP2_D4
#set SCE=SSP2_S4

set CLP=BaU

set IAV=NoCC

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E --supcuvout=off MaxProcDir=100
)))
pause

EXIT

