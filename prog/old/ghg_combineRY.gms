*-*-*-*- This program is included by ..\prog\ghg_combineR.gms

parameter
GHGL%1%2(L)
;

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%2.gdx'
$load GHGL%1%2=GHGL

GHGL("%1","%2",L)$GHGL%1%2(L)=GHGL%1%2(L);
