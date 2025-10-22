*--------load pre-year analysis data -------*
parameter
VYL_pre%1(L,G)
VYLY%1(Y,L,G)	land use in all the earlier years
;

$ifthen.mng2 not %Sy%==%base_year%

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/analysis/%pre_year%.gdx'
$load VYL_pre%1=VYL
$load VYLY%1=VYLY

VYL_pre(L,G)$(VYL_pre%1(L,G))=VYL_pre%1(L,G);
VYLY(Y,L,G)$VYLY%1(Y,L,G)=VYLY%1(Y,L,G);

$endif.mng2




