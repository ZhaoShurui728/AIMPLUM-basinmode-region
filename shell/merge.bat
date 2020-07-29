mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all
mkdir ..\..\output\gdx\analysis

set SCE=SSP1 SSP2 SSP3 SSP4 SSP5

## CDLINKS_Ecosystem ##
set SCE=SSP2
set CLP=INDC_CONT3

set SCE=SSP2i
set CLP=BaU 20W_SPA1CO2 26W_SPA1CO2
set CLP=BaU
#######################
set IAV=NoCC

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF


cd ..\..\exe

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

#	gdxmerge "..\output\gdx\%%C_%%D_%%E\bio\*.gdx"
#	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\bio.gdx
#	del merged.gdx

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E --supcuvout=off --bvcalc=on MaxProcDir=100
)))
#pause

gdxmerge "..\output\gdx\analysis\*.gdx"
copy merged.gdx ..\output\gdx\final_results.gdx
del merged.gdx

pause

EXIT

