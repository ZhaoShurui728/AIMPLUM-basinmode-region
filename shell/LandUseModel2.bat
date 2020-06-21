mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

rem-----------------------------
rem call settings\default.bat
call settings\%1
rem-----------------------------

cd ..\..\exe

# 3) Disaggregation of FRS and grassland

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
for %%A in (%COUNTRY%) do (
	copy ..\output\gdx\base\%%A\analysis\2005.gdx ..\output\gdx\%%C_%%D_%%E\%%A\analysis\2005.gdx

for %%B in (%YEAR%) do (

	gams ..\prog\prog\Disagg_FRSGL.gms --Sr=%%A --Sy=%%B --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100

)))))
pause


# 4) Marge files by land types

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

gams ..\prog\prog\combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))
pause

EXIT

