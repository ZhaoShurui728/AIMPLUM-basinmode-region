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
set YEAR=2005 2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
rem-----------------------------

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

   echo %%C_%%D_%%E gdx2txt

  	mkdir ..\output\txt\%%C_%%D_%%E
	mkdir ..\output\png\%%C_%%D_%%E
	mkdir ..\output\gdxii\%%C_%%D_%%E

  for %%A in (%COUNTRY%) do (

  	mkdir ..\output\txt\%%C_%%D_%%E\%%A
 	mkdir ..\output\png\%%C_%%D_%%E\%%A
 	mkdir ..\output\gdxii\%%C_%%D_%%E\%%A

	for %%B in (%YEAR%) do (

   	gams ..\AIMPLUM\prog\gdx2txt.gms --Sr=%%A --Sy=%%B --sce=%%C --clp=%%D --iav=%%E MaxProcDir=100

#	pause
  	)
  ))))

pause

EXIT

