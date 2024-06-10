parameter
VYL%1(L,G)
YBIO%1(G)
CS%1(G) carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
VYL_pre%1(L,G)
GHGLG%1(EmitCat,L,G)
delta_VY%1(Y,L,G)	Changes in land use in all the earlier years

;

$if not %Sy%==%base_year% $gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%Sy%.gdx'
$if %Sy%==%base_year% $gdxin '../output/gdx/base/%1/%Sy%.gdx'
$load VYL%1=VYL
$load GHGLG%1=GHGLG

$if not %Sy%==%base_year% $gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%pre_year%.gdx'
$if %Sy%==%base_year% $gdxin '../output/gdx/base/%1/%Sy%.gdx'
$load CS%1=CS

CS(G)$CS%1(G)=CS%1(G);

VYL(L,G)$(VYL%1(L,G))=VYL%1(L,G);
GHGLG(EmitCat,L,G)$(LEMISload(L) and GHGLG%1(EmitCat,L,G))=GHGLG%1(EmitCat,L,G);

$ifthen exist '../output/gdx/%SCE%_%CLP%%ModelInt%/bio/%Sy%.gdx'
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%Sy%.gdx'
$load YBIO%1=YBIO
VYL("BIO",G)$(YBIO%1(G))=YBIO%1(G);
$endif


*--------Land use change -------*
VYL_pre(L,G)=0;


$ifthen.mng2 not %Sy%==%base_year%

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/analysis/%pre_year%.gdx'
$load VYL_pre%1=VYL
$load delta_VY%1=delta_VY

VYL_pre(L,G)$(VYL_pre%1(L,G))=VYL_pre%1(L,G);
delta_VY(Y,L,G)$(delta_VY%1(Y,L,G))=delta_VY%1(Y,L,G);

$endif.mng2





