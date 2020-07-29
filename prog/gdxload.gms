*-*-*-*- This program is included by ..\prog\gdx2txt_wld.gms
parameter
VY_load%1(L,G)
VY_1%1(L,G)
Yield%1(L,G)
Y_base%1(L,G)
GHGLG%1(Y,L,G)
VYLAFR_nocc%1(LAFR,G)

;

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%1/analysis/%Sy%.gdx'
$load VY_load%1=VY_load

VY_load(L,G)$VY_load%1(L,G)=VY_load%1(L,G);

$if %Sy%==2100 $gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%1/analysis/%base_year%.gdx'
$if %Sy%==2100 $load VY_1%1=VY_load
$if %Sy%==2100 VY_1(L,G)$VY_1%1(L,G)=VY_1%1(L,G);


$ontext

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/GHG/%1.gdx'
$load GHGLG%1=GHGLG

GHGLG("%Sy%",L,G)$GHGLG%1("%Sy%",L,G)=GHGLG%1("%Sy%",L,G);

$offtext

$ontext

$ifthen.by2 %Sy%==2005

$gdxin '../output/gdx/base/%1/basedata.gdx'
$load Yield%1=Yield Y_base%1=Y_base

YIELD(L,G)$Yield%1(L,G)=Yield%1(L,G);
Y_base(L,G)$Y_base%1(L,G)=Y_base%1(L,G);

$endif.by2


$offtext

$ontext
$ifthen not %IAV%==NoCC

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_NoCC/%1/analysis/%Sy%.gdx'
$load VYLAFR_nocc%1=VY_load

VYLAFR_nocc(G)$VYLAFR_nocc%1("AFR",G)=VYLAFR_nocc%1("AFR",G);

$endif
$offtext



