mkdir ..\..\exe
mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\output\gdx\all

rem-----------------------------
rem call settings\default.bat
call settings\%2_%3\%1
rem-----------------------------

set YEAR=2005 2010 2015 2020 2025 2030 2035 2040 2045 2050 2055 2060 2065 2070 2075 2080 2085 2090 2095 2100

cd ..\..\exe

# 3) Disaggregation of FRS and grassland

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
for %%A in (%COUNTRY%) do (
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

