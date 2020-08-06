mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\analysis
mkdir ..\..\output\gdx\landmap
mkdir ..\..\output\gdx\base

rem-----------------------------
rem call settings\default.bat
call settings\%1.bat

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
set COUNTRY=BRA
rem-----------------------------

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

	mkdir ..\output\gdx\%%C_%%D_%%E
	mkdir ..\output\gdx\%%C_%%D_%%E\cbnal
	mkdir ..\output\gdx\%%C_%%D_%%E\analysis
	mkdir ..\output\gdx\%%C_%%D_%%E\bio
#	copy ..\data\cbnal0\global_17_SSP2_%%D_%%E.gdx ..\data\cbnal0\global_17_%%C_%%D_%%E.gdx
#	copy ..\data\cbnal0\global_17_%%C_BaU_%%E.gdx ..\data\cbnal0\global_17_%%C_%%D_%%E.gdx

for %%A in (%COUNTRY%) do (
  	mkdir ..\output\gdx\%%C_%%D_%%E\%%A
  	mkdir ..\output\gdx\%%C_%%D_%%E\%%A\analysis
	copy ..\output\gdx\base\%%A\2005.gdx ..\output\gdx\%%C_%%D_%%E\%%A\2005.gdx
	copy ..\output\gdx\base\%%A\analysis\2005.gdx ..\output\gdx\%%C_%%D_%%E\%%A\analysis\2005.gdx
)

for %%B in (%YEAR%) do (

for %%A in (%COUNTRY%) do (
	gams ..\AIMPLUM\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on --biocurve=off  MaxProcDir=100
#pause
)
#pause
#	activate this if biocurve=on
#	gams ..\AIMPLUM\prog\Bioland.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on MaxProcDir=100
#pause
)

)))
rem pause

# 3) Disaggregation of FRS and grassland

set YEAR=2005 2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
rem set YEAR=2010

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

for %%A in (%COUNTRY%) do (
for %%B in (%YEAR%) do (
	gams ..\AIMPLUM\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --biocurve=off MaxProcDir=100
rem pause
)))))
#pause

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

   echo %%C_%%D_%%E merge
#   start  "<%%C_%%D_%%E>" call ..\AIMPLUM\shell\inc_prog\merge_parallel.bat %%C %%D %%E

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

gdxmerge "..\..\output\gdx\%%C_%%D_%%E\bio\*.gdx"
copy merged.gdx ..\..\output\gdx\%%C_%%D_%%E\bio.gdx
del merged.gdx

cd ..\
rd /q /s %%C_%%D_%%E

)))
#pause

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (


gams ..\AIMPLUM\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E --supcuvout=off MaxProcDir=100

del ..\output\txt\merge_%SCE%_%CLP%_%IAV%.txt

)))
#pause

EXIT

