*-*-*-*- This program is included by ..\prog\Bioland.gms
parameter
*PBIO%1(G,LB)
*BIOENE%1(G) GJ per ha per year
*RAREA_BIOP%1(G) Ratio of area of biocrop in cell G in year Y [-]
Y_pre%1(LCL,G)
VYL%1(L,G)
protect_wopas%1(G)
pa_bio%1(G)         land transition costs per unit area for BIO (million $ per ha)
YIELD%1(LBIO,G)
pc%1(LBIO)         land transition costs per unit area (million $ per ha)
CS%1(G)		carbon density (MgC per ha)
;

$ifthen.fileex exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%pre_year%.gdx'
$       gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%pre_year%.gdx'
$       load Y_pre%1=VY_load
$else.fileex
Y_pre%1(LCL,G)=0;
$endif.fileex

$ifthen.fileex exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%second_year%.gdx'
$       gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%second_year%.gdx'
$       load protect_wopas%1=protect_wopas
$else.fileex
protect_wopas%1(G)=0;
$endif.fileex

$ifthen exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%Sy%.gdx'
$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/%Sy%.gdx'
*$load PBIO%1=PBIO RAREA_BIOP%1=RAREA_BIOP
$load VYL%1=VY_load
$load pa_bio%1=pa_bio pc%1=pc CS%1=CS

$else
*PBIO%1(G,LB)=0;
*RAREA_BIOP%1(G)=0;
VYL%1(LCL,G)=0;
pa_bio%1(G)=0;
pc%1(LBIO)=0;
CS%1(G)=0;
$endif

$gdxin '%prog_dir%/../output/gdx/base/%1/basedata.gdx'
*$load BIOENE%1=BIOENE
$load YIELD%1=YIELD


*PBIO(G,LB)$(PBIO%1(G,LB))=PBIO%1(G,LB);
*BIOENE(G)$(BIOENE%1(G))=BIOENE%1(G);
*RAREA_BIOP(G)$(RAREA_BIOP%1(G))=RAREA_BIOP%1(G);

Y_pre("CL",G)$(Y_pre%1("CL",G))=Y_pre%1("CL",G);
*VYLCL(G)$(VYL%1("CL",G))=VYL%1("CL",G);

VYL(L,G)$(VYL%1(L,G))=VYL%1(L,G);
protect_wopas(G)$(protect_wopas%1(G))=protect_wopas%1(G);
YIELDBIO(G)$(YIELD%1("BIO",G))=YIELD%1("BIO",G);
pa_bio(G)$(pa_bio%1(G)) = pa_bio%1(G);
pc_bio("%1")$pc%1("BIO")=pc%1("BIO");
CS(G)$CS%1(G)=CS%1(G);
