*-*-*-*- This program is included by ..\prog\Bioland.gms
parameter
protect_area%1(protect_cat,L)	Regional aggregated protection area (kha)
;

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%protectStartYear%.gdx'
*$gdxin '../output/gdx/base/%1/basedata.gdx'
$load protect_area%1=protect_area

protect_area("%1",protect_cat,L)$(protect_area%1(protect_cat,L))=protect_area%1(protect_cat,L);
