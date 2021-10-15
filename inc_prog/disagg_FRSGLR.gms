parameter
VY%1(L,G)
YBIO%1(G)
CS%1(G) carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)

;

$if not %Sy%==%base_year% $gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%Sy%.gdx'
$if %Sy%==%base_year% $gdxin '%prog_dir%/../output/gdx/base/%Sr%/%Sy%.gdx'
$load VY%1=VY_load
$load CS%1=CS

VYL(L,G)$(VY%1(L,G))=VY%1(L,G);
CS(G)$CS%1(G)=CS%1(G);

$ifthen exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/bio/%Sy%.gdx'
$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/bio/%Sy%.gdx'
$load YBIO%1=YBIO
VYL("BIO",G)$(YBIO%1(G))=YBIO%1(G);
$endif



