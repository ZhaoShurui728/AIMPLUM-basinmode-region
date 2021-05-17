cd ..\..\exe
mkdir ..\output\csv\
mkdir ..\output\cdl\
mkdir ..\output\nc\

set SCE=SSP1 SSP2
set CLP=BaU 26W
set SCE=SSP2
set CLP=BaU

set IAV=NoCC

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

mkdir ..\output\csv\%%C_%%D_%%E

### gdx files aggregation
	gdxmerge "..\output\gdx\%%C_%%D_%%E\analysis\*.gdx"
	copy merged.gdx ..\output\gdx\results\results_%%C_%%D_%%E.gdx
	del merged.gdx

### csv file created
gams ..\AIMPLUM\prog\gdx2csv.gms --split=1 --sce=%%C --clp=%%D --iav=%%E MaxProcDir=100 S=gdx2csv2nc1_%%C_%%D_%%E
#pause
gams ..\AIMPLUM\prog\gdx2csv.gms --split=2 --sce=%%C --clp=%%D --iav=%%E MaxProcDir=100 R=gdx2csv2nc1_%%C_%%D_%%E
#pause
)))
pause


