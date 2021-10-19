
rem -----------------------------
rem call settings\default.bat
call settings\%1
set SCENARIO=%1
set pausemode=%2
set YesrListFig=%~3
set global=%4
set COUNTRY=%~5
set dif=%6
rem set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
rem set COUNTRY=WLD
rem -----------------------------

cd ..\..\exe
echo %YesrListFig% > ../output/txt/%SCENARIO%_year.txt
echo a > ..\output\txt\scenario_plot_%SCENARIO%.txt
for %%B in (%YesrListFig%) do (
  if %global%==on (
    gams ..\AIMPLUM\prog\gdx4png.gms --Sr=WLD --Sy=%%B --sce=%SCE% --clp=%CLP% --iav=%IAV% --dif=%dif% MaxProcDir=100
  ) else (
    for %%A in (%COUNTRY%) do (
      gams ..\AIMPLUM\prog\gdx4png.gms --Sr=%%A --Sy=%%B --sce=%SCE% --clp=%CLP% --iav=%IAV% --dif=%dif% MaxProcDir=100
    )
  )
)
echo a > ..\output\txt\scenario_plot_end_%SCENARIO%.txt
del ..\output\txt\scenario_plot_%SCENARIO%.txt
if %pausemode%==on pause

EXIT

