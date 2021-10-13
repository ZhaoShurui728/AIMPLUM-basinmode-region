rem call settings\default.bat
set scenarioname=%1
set pausemode=%2
set closemode=%3
set projectname=%4
set lumip=%5
set bioyielcal2=%6
set BTC3option=%7
set ssprcp=%8

set FileCopyList=ncheader_all_lumip ncheader_all final ncheader_all_yield ncheader_all_aimssprcplu_landcategory ncheader_all_wwf ncheader_all_wwf2 ncheader_all_wwf_landcategory ncheader_all_wwf_landcategory2 ncheader_all_wwf_landcategoryall
for %%H in (%FileCopyList%) do (
  copy ..\data\ncheader\%%H.txt ..\..\output\csv\%%H.txt 
)

call settings\%1

cd ..\..\exe

bash ../AIMPLUM/shell/csv2nc_all.sh %SCE% %CLP% %IAV% %projectname% %lumip% %bioyielcal2% %BTC3option% %ssprcp%

if not %closemode%==on pause
exit