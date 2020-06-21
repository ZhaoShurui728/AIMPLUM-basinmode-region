mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all
mkdir ..\..\output\gdx\base
mkdir ..\..\output\gdx\all\biosupcuv

rem-----------------------------
rem call settings\default.bat
call settings\%1
rem-----------------------------

#set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF

set IAV=NoCC
#set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

#	mkdir ..\output\gdx\%%C_%%D_%%E
#	mkdir ..\output\gdx\%%C_%%D_%%E\cbnal
#	mkdir ..\output\gdx\%%C_%%D_%%E\analysis
#	mkdir ..\output\gdx\%%C_%%D_%%E\bio
#	copy ..\data\cbnal0\global_17_SSP2_%%D_%%E.gdx ..\data\cbnal0\global_17_%%C_%%D_%%E.gdx
#	copy ..\data\cbnal0\global_17_%%C_BaU_%%E.gdx ..\data\cbnal0\global_17_%%C_%%D_%%E.gdx

for %%A in (%COUNTRY%) do (
#  	mkdir ..\output\gdx\%%C_%%D_%%E\%%A
#  	mkdir ..\output\gdx\%%C_%%D_%%E\%%A\analysis
	copy ..\output\gdx\base\%%A\2005.gdx ..\output\gdx\%%C_%%D_%%E\%%A\2005.gdx
	copy ..\output\gdx\base\%%A\analysis\2005.gdx ..\output\gdx\%%C_%%D_%%E\%%A\analysis\2005.gdx
)

for %%B in (%YEAR%) do (

for %%A in (%COUNTRY%) do (
#	start gams ..\prog\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on --bioland=on  MaxProcDir=100
#	gams ..\prog\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on --bioland=on  MaxProcDir=100
#pause
)
#pause
	gams ..\prog\prog\Bioland.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on  --supcuvout=off MaxProcDir=100
#pause
)

)))
#pause

# 3) Disaggregation of FRS and grassland

set YEAR=2005 2010 2020 2030 2040 2050 2060 2070 2080 2090 2100

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

for %%A in (%COUNTRY%) do (
for %%B in (%YEAR%) do (
	gams ..\prog\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
#pause
)))))
pause

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
for %%A in (%COUNTRY%) do (

	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\cbnal\%%A.gdx
	del merged.gdx

	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\analysis\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\analysis\%%A.gdx
	del merged.gdx

)
	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\bio\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\bio.gdx
	del merged.gdx

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))
pause

EXIT

