rem call settings\default.bat
set scenarioname=%1
set pausemode=%2
set closemode=%3
set projectname=%4
set lumip=%5
set bioyielcal=%6
set BTC3option=%7
set ssprcp=%8

call settings\%1

cd ..\..\exe

bash ../AIMPLUM/shell/src/csv2nc_all.sh %SCE% %CLP% %IAV% %projectname% %lumip% %bioyielcal% %BTC3option% %ssprcp%

if not %closemode%==on pause
exit