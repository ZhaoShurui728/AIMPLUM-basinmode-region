rem call settings\default.bat
set scenarioname=%1
set pausemode=%2
set projectname=%3
set lumip=%4
set bioyielcal=%5
set BTC3option=%6
set ssprcp=%7

call settings\%1

cd ..\..\exe

bash ../AIMPLUM/shell/src/csv2nc_all.sh %SCE% %CLP% %IAV% %projectname% %lumip% %bioyielcal% %BTC3option% %ssprcp%
if %pausemode%==on pause

exit