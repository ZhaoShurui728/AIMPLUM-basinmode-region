parameter
VY%1(L,G)
YBIO%1(G)
CS%1(G) carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
VYL_anapre%1(L,G)
;

$if not %Sy%==%base_year% $gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%Sy%.gdx'
$if %Sy%==%base_year% $gdxin '../output/gdx/base/%1/%Sy%.gdx'
$load VY%1=VY_load
$load CS%1=CS

VYL(L,G)$(VY%1(L,G))=VY%1(L,G);
CS(G)$CS%1(G)=CS%1(G);

$ifthen exist '../output/gdx/%SCE%_%CLP%%ModelInt%/bio/%Sy%.gdx'
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%Sy%.gdx'
$load YBIO%1=YBIO
VYL("BIO",G)$(YBIO%1(G))=YBIO%1(G);
$endif

VYL_anapre(L,G)=0;

$ifthen.mng2 not %Sy%==%base_year%

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/analysis/%pre_year%.gdx'
$load VYL_anapre%1=VY_load

VYL_anapre(L,G)$(VYL_anapre%1(L,G))=VYL_anapre%1(L,G);

$endif.mng2





