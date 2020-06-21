mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

set SCE=SSP1 SSP2 SSP3 SSP4 SSP5

set SCE=SSP2_D0 SSP2_D1 SSP2_D2 SSP2_D3 SSP2_D4
set CLP=BaU C CNA

set SCE=SSP2_S1 SSP2_S2 SSP2_S3 SSP2_S4
set CLP=BaU BaULP C CLP CNA CNALP
rem set SCE=SSP2_D0 SSP2_D3
rem set CLP=BaULP CLP CNALP
rem set SCE=SSP2_EC2
rem set CLP=BaU C

rem set SCE=SSP2_EC2
rem set CLP=CNA
set SCE=SSP2_EC3
set CLP=BaU C CNA
rem set SCE=SSP2_ECS1 SSP2_ECS2 SSP2_ECS3 SSP2_ECS4
rem set CLP=BaU C CNA

rem BIOSUPCHECK!!
rem set SCE=SSP2_S1 SSP2_S2 SSP2_S3 SSP2_S4
rem set CLP=BaU C
set CLP=CLP
set SCE=SSP2_S2 SSP2_S3 SSP2_S4
set CLP=BaULP

set SCE=SSP2_D0 SSP2_D1 SSP2_D2 SSP2_D3 SSP2_D4 SSP2_EC2 SSP2_EC3
set CLP=BaU C CNA

rem set SCE=SSP2_D0 SSP2_D3
rem set CLP=BaULP CLP CNALP

set IAV=NoCC

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF


cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
for %%A in (%COUNTRY%) do (

#	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\*.gdx"
#	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\cbnal\%%A.gdx
#	del merged.gdx

#	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\analysis\*.gdx"
#	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\analysis\%%A.gdx
#	del merged.gdx

)

	gdxmerge "..\output\gdx\%%C_%%D_%%E\bio\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\bio.gdx
	del merged.gdx

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E --supcuvout=off MaxProcDir=100
)))
pause

EXIT

