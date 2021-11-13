if not exist ../../exe mkdir ../../exe
cd ../../exe
gams ../AIMPLUM/prog/data_prep.gms
cd ..\AIMPLUM\shell
if %pausemode%==on pause
