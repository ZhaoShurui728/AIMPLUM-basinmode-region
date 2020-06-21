mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all
mkdir ..\..\output\gdx\base
mkdir ..\..\output\gdx\base\bio
rem-----------------------------
rem call settings\default.bat
rem call settings\%1

set COUNTRY=%1

rem-----------------------------


cd ..\..\exe

for %%A in (%COUNTRY%) do (

	mkdir ..\output\gdx\base\%%A
	mkdir ..\output\gdx\base\%%A\analysis

	gams ..\prog\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=on MaxProcDir=100
	gams ..\prog\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC MaxProcDir=100
#	gams ..\prog\prog\Bioland.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=off MaxProcDir=100
#pause
)

EXIT
