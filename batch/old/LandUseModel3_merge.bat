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
rem-----------------------------

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

   echo %%C_%%D_%%E merge

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

gdxmerge "..\..\output\gdx\%%C_%%D_%%E\bio\*.gdx" "..\..\output\gdx\%%C_%%D_%%E\bio.gdx"

cd ..\
rd /q /s %%C_%%D_%%E

)))

EXIT

