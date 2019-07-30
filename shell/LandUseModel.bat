mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

#call settings\default.bat

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
set COUNTRY=CIS XME XNF XAF
set COUNTRY=CIS XAF
set SCE=SSP1 SSP2 SSP3
set SCE=SSP2
set CLP=26W
set IAV=NoCC

set YEAR=2005 2010 2015 2020 2025 2030 2035 2040 2045 2050 2055 2060 2065 2070 2075 2080 2085 2090 2095 2100
#set YEAR=2005

cd ..\..\exe

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

	mkdir ..\output\gdx\%%C_%%D_%%E
	mkdir ..\output\gdx\%%C_%%D_%%E\cbnal
	mkdir ..\output\gdx\%%C_%%D_%%E\analysis

  for %%A in (%COUNTRY%) do (

  	mkdir ..\output\gdx\%%C_%%D_%%E\%%A
  	mkdir ..\output\gdx\%%C_%%D_%%E\%%A\analysis

	for %%B in (%YEAR%) do (

#	gams ..\AIMPLUM\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on MaxProcDir=100
#pause
)
	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\cbnal\%%A.gdx
	del merged.gdx

))))
#pause
# 2) GHG emissions


#for %%C in (%SCE%) do (
#for %%D in (%CLP%) do (
#for %%E in (%IAV%) do (
#gams ..\AIMPLUM\prog\ghg_combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
#)))

#pause

###########################################################################
set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
###########################################################################

# 3) Disaggregation of FRS and grassland

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
for %%A in (%COUNTRY%) do (
for %%B in (%YEAR%) do (

	gams ..\AIMPLUM\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)

	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\analysis\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\analysis\%%A.gdx
	del merged.gdx

))))
pause


# 4) Marge files by land types

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\AIMPLUM\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))
pause

EXIT

