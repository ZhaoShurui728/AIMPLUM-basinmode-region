mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\analysis
mkdir ..\..\output\gdx\landmap
mkdir ..\..\output\gdx\base

rem-----------------------------
rem call settings\default.bat
call settings\%1

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY=JPN
rem-----------------------------

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

   echo %%C_%%D_%%E merge
#   start  "<%%C_%%D_%%E>" call ..\prog\shell\inc_prog\merge_parallel.bat %%C %%D %%E

   mkdir %%C_%%D_%%E
   cd %%C_%%D_%%E

   for %%A in (%COUNTRY%) do (

		gdxmerge "..\..\output\gdx\%%C_%%D_%%E\%%A\*.gdx"
		copy merged.gdx ..\..\output\gdx\%%C_%%D_%%E\cbnal\%%A.gdx
		del merged.gdx
		
		gdxmerge "..\..\output\gdx\%%C_%%D_%%E\%%A\analysis\*.gdx"
		copy merged.gdx ..\..\output\gdx\%%C_%%D_%%E\analysis\%%A.gdx
		del merged.gdx

   )

#gdxmerge "..\..\output\gdx\%%C_%%D_%%E\bio\*.gdx"
#copy merged.gdx ..\..\output\gdx\%%C_%%D_%%E\bio.gdx
#del merged.gdx

cd ..\
rd /q /s %%C_%%D_%%E

)))
#pause

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100

)))

pause

gdxmerge "..\output\gdx\analysis\*.gdx"
copy merged.gdx ..\output\gdx\final_results.gdx
del merged.gdx

pause

EXIT

