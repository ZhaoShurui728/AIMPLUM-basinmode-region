mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\results
mkdir ..\..\output\gdx\base
mkdir ..\..\output\csv

rem-----------------------------
rem call settings\default.bat
call settings\%1

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY=JPN
set YEAR=2005 2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
rem-----------------------------

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

   echo %%C_%%D_%%E merge
#   start  "<%%C_%%D_%%E>" call ..\AIMPLUM\shell\inc_prog\merge_parallel.bat %%C %%D %%E

rem   mkdir ..\output\csv\%%C_%%D_%%E
   mkdir %%C_%%D_%%E
   cd %%C_%%D_%%E

### gdx files aggregation
	gdxmerge "..\..\output\gdx\%%C_%%D_%%E\analysis\*.gdx"
	copy merged.gdx ..\..\output\gdx\results\results_%%C_%%D_%%E.gdx
	del merged.gdx

cd ..\
rd /q /s %%C_%%D_%%E

### csv file created
gams ..\AIMPLUM\prog\gdx2csv.gms --split=1 --sce=%%C --clp=%%D --iav=%%E MaxProcDir=100 S=gdx2csv2nc1_%%C_%%D_%%E
pause
gams ..\AIMPLUM\prog\gdx2csv.gms --split=2 --sce=%%C --clp=%%D --iav=%%E MaxProcDir=100 R=gdx2csv2nc1_%%C_%%D_%%E
pause

)))

pause

gdxmerge "..\output\gdx\analysis\*.gdx"
copy merged.gdx ..\output\gdx\final_results.gdx
del merged.gdx

pause

EXIT

