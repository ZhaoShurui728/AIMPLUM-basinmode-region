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
rem set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
rem set COUNTRY=JPN
rem-----------------------------


cd ..\..\exe

for %%A in (%COUNTRY%) do (

	mkdir ..\output\gdx\base\%%A
	mkdir ..\output\gdx\base\%%A\analysis

	gams ..\AIMPLUM\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=on MaxProcDir=100
rem pause
	gams ..\AIMPLUM\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC MaxProcDir=100
rem pause
#	gams ..\AIMPLUM\prog\Bioland.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=off MaxProcDir=100
#pause
)

EXIT
