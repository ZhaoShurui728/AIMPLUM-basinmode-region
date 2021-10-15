
rem-----------------------------
rem call settings\default.bat
rem call settings\%1

set SingleCOUNTRY=%1
set pausemode=%2
set CPLEXThreadOp=%3
rem-----------------------------

cd ..\..\exe
echo a > ..\output\txt\base_%1.txt

for %%A in (%SingleCOUNTRY%) do (

	mkdir ..\output\gdx\base\%%A
	mkdir ..\output\gdx\base\%%A\analysis

	gams ..\AIMPLUM\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --CPLEXThreadOp=%CPLEXThreadOp% --parallel=on MaxProcDir=100
	gams ..\AIMPLUM\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC MaxProcDir=100
#	gams ..\AIMPLUM\prog\Bioland.gms --Sr=%%A --Sy=2005 --SCE=SSP2 --CLP=BaU --IAV=NoCC --parallel=off MaxProcDir=100
)
if %pausemode%==on pause

echo a > ..\output\txt\base_end_%1.txt
del ..\output\txt\base_%1.txt
EXIT
