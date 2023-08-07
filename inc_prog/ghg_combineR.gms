*-*-*-*- This program is included by ..\prog\ghg_combine.gms
parameter
GHGL%1(Y,L)
;

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/GHG/%1.gdx'
$load GHGL%1=GHGL

GHGL("%1",Y,L)$GHGL%1(Y,L)=GHGL%1(Y,L);
