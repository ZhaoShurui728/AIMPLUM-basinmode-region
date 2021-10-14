
rem -----------------------------
rem call settings\default.bat
call settings\%1
set SCENARIO=%1
set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
rem set COUNTRY=WLD
rem set YEAR=2005 2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
set YEAR=%~3

rem set YEAR=2050 2070
rem set YEAR=2005 2050
rem -----------------------------

cd ..\..\exe
echo %YEAR% > ../output/txt/%SCENARIO%_year.txt
echo a > ..\output\txt\scenario_plot_%SCENARIO%.txt
for %%B in (%YEAR%) do (
rem  gams ..\AIMPLUM\prog\gdx2txt.gms --Sr=WLD --Sy=%%B --sce=%SCE% --clp=%CLP% --iav=%IAV% MaxProcDir=100
  for %%A in (%COUNTRY%) do (
  rem 	gams ..\AIMPLUM\prog\gdx2txt.gms --Sr=%%A --Sy=%%B --sce=%SCE% --clp=%CLP% --iav=%IAV% MaxProcDir=100
  )
)
echo a > ..\output\txt\scenario_plot_end_%SCENARIO%.txt
del ..\output\txt\scenario_plot_%SCENARIO%.txt

EXIT

