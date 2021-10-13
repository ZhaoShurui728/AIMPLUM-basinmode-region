mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

rem-----------------------------
rem call settings\default.bat

call settings\%1

rem-----------------------------

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

	gams ..\prog\prog\LandUseModel_mcp.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E --parallel=on MaxProcDir=100

)))))
pause

# 2) GHG emissions


for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
gams ..\prog\prog\ghg_combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))

#pause


# 3) Disaggregation of FRS and grassland

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
for %%A in (%COUNTRY%) do (
for %%B in (%YEAR%) do (

#	gams ..\prog\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
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

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))
pause

EXIT


