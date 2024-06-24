parameter
VYL%1(L,G)
YBIO%1(G)
CS%1(G) carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
CS_base%1(G)	carbon stock in base year
VYL_pre%1(L,G)
VYLY%1(Y,L,G)	land use in all the earlier years
;

$if not %Sy%==%base_year% $gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%Sy%.gdx'
$if %Sy%==%base_year% $gdxin '../output/gdx/base/%1/%Sy%.gdx'
$load VYL%1=VYL

$if not %Sy%==%base_year% $gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/%pre_year%.gdx'
$if %Sy%==%base_year% $gdxin '../output/gdx/base/%1/%Sy%.gdx'
$load CS%1=CS

$gdxin '../output/gdx/base/%Sr%/%base_year%.gdx'
$load CS_base%1=CS

CS(G)$CS%1(G)=CS%1(G);
CS_base(G)$CS_base%1(G)=CS_base%1(G);
VYL(L,G)$(VYL%1(L,G))=VYL%1(L,G);


$ifthen exist '../output/gdx/%SCE%_%CLP%%ModelInt%/bio/%Sy%.gdx'
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%Sy%.gdx'
$load YBIO%1=YBIO
VYL("BIO",G)$(YBIO%1(G))=YBIO%1(G);
$endif



*--------Land use change -------*


$ifthen.mng2 not %Sy%==%base_year%

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%1/analysis/%pre_year%.gdx'
$load VYL_pre%1=VYL
$load VYLY%1=VYLY

VYL_pre(L,G)$(VYL_pre%1(L,G))=VYL_pre%1(L,G);
VYLY(Y,L,G)$VYLY%1(Y,L,G)=VYLY%1(Y,L,G);

$endif.mng2





