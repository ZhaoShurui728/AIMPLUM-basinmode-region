*-*-*-*- This program is included by ..\prog\ghg_combine.gms
parameter
GHGL%1(Y,L)
;

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/%1.gdx'
$load GHGL%1=GHGL

GHGL("%1",Y,L)$GHGL%1(Y,L)=GHGL%1(Y,L);


$ontext
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2005
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2010
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2015
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2020
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2025
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2030
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2035
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2040
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2045
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2050
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2055
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2060
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2065
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2070
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2075
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2080
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2085
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2090
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2095
$batinclude %prog_dir%/prog/ghg_combineRY.gms %1 2100
$offtext




