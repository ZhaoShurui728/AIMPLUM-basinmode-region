*-*-*-*- This program is included by ..\prog\combine.gms
parameter
GHGL%1(Y,L)
Psol_stat%1(Y,ST,SP)                  Solution report
Area%1(Y,L)
Area_base%1(L,Sacol)
CSB%1
PBIO%1(Y,G,Scol)
*BIOENE%1(G)
VYL%1(Y,L,G)

YIELD%1(L,G)
VYPL%1(Y,L,G)
pa_road%1(Y,L,G)
pa_emit%1(Y,G)
pa_lab%1(Y)
pa_irri%1(Y,L)
MFA%1     management factor for bio crops in base year
MFB%1     management factor for bio crops (coefficient)
YIELDL%1(Y,L)	Agerage yield of land category L region R in year Y [tonne per ha per year]
YIELDLDM%1(Y,LDM)	Agerage yield of land category L region R in year Y [tonne per ha per year]
RR%1(G)	the range-rarity map
BIIcoefG%1(L,G)	the Biodiversity Intactness Index (BII) coefficients
sharepix%1(LULC_class,I,J)
VYLAFR_baunocc%1(Y,LAFR,G)
VYLAFR_baubiod%1(Y,LAFR,G)
protectfracL%1(G,L)	Protected area fraction (0 to 1) of land category L in land area of the category L in each cell G
;

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/%1.gdx'
$load Psol_stat%1=Psol_stat
$load GHGL%1=GHGL
$load VYPL%1=VYP_load
$load pa_road%1=pa_road
$load pa_emit%1=pa_emit
$load pa_lab%1=pa_lab
$load pa_irri%1=pa_irri
$load YIELDL%1=YIELDL_OUT
$load YIELDLDM%1=YIELDLDM_OUT
*$load VYL%1=VY_load

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/analysis/%1.gdx'
$load VYL%1=VY_load

$gdxin '%prog_dir%/../output/gdx/base/%1/basedata.gdx'
$load Area_base%1=Area_base
$load YIELD%1=YIELD
$load MFA%1=MFA
$load MFB%1=MFB
$load BIIcoefG%1=BIIcoefG
$load RR%1=RR
$load sharepix%1=sharepix

Psol_stat("%1",Y,ST,SP)$Psol_stat%1(Y,ST,SP)=Psol_stat%1(Y,ST,SP);
Area_base("%1",L,Sacol)$(Area_base%1(L,Sacol))=Area_base%1(L,Sacol);
GHGL("%1",Y,L)$GHGL%1(Y,L)=GHGL%1(Y,L);

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/analysis/%1.gdx'
$load Area%1=Area_load
$gdxin '%prog_dir%/../output/gdx/base/%1/analysis/%base_year%.gdx'
$load CSB%1=CSB
*$load VY_load%1=VY_load

Area("%1",Y,L)$Area%1(Y,L)=Area%1(Y,L);
CSB("%1")$(CSB%1)=CSB%1;

YIELD_load("%1",L,G)$YIELD%1(L,G)=YIELD%1(L,G);
VYPL("%1",Y,L,G)$VYPL%1(Y,L,G)=VYPL%1(Y,L,G);
pa_road("%1",Y,L,G)$pa_road%1(Y,L,G)=pa_road%1(Y,L,G);
pa_emit("%1",Y,G)$pa_emit%1(Y,G)=pa_emit%1(Y,G);
pa_lab("%1",Y)$pa_lab%1(Y)=pa_lab%1(Y);
pa_irri("%1",Y,L)$pa_irri%1(Y,L)=pa_irri%1(Y,L);

YIELDL_OUT("%1",Y,L)=YIELDL%1(Y,L);
YIELDLDM_OUT("%1",Y,LDM)=YIELDLDM%1(Y,LDM);

MFA("%1")$MFA%1=MFA%1;
MFB("%1")$MFB%1=MFB%1;

VYL("%1",Y,L,G)$VYL%1(Y,L,G)=VYL%1(Y,L,G);
*VYL("%1",Y,"FRSGL",G)=VYL%1(Y,"FRS",G)+VYL%1(Y,"GL",G);


RR(G)$RR%1(G)=RR%1(G);
BIIcoefG(L,G)$BIIcoefG%1(L,G)=BIIcoefG%1(L,G);
sharepix(LULC_class,I,J)$sharepix%1(LULC_class,I,J)=sharepix%1(LULC_class,I,J);

$ontext
$ifthen not %IAV%==NoCC

$gdxin '%prog_dir%/../output/gdx/%SCE%_BaU_NoCC/analysis/%1.gdx'
$load VYLAFR_baunocc%1=VY_load

$gdxin '%prog_dir%/../output/gdx/%SCE%_BaU_BIOD/analysis/%1.gdx'
$load VYLAFR_baubiod%1=VY_load

VYLAFR_baunocc("%1",Y,G)$VYLAFR_baunocc%1(Y,"AFR",G)=VYLAFR_baunocc%1(Y,"AFR",G);

VYLAFR_baubiod("%1",Y,G)$VYLAFR_baubiod%1(Y,"AFR",G)=VYLAFR_baubiod%1(Y,"AFR",G);


* protected area

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%1/2010.gdx'
$load protectfracL%1=protectfracL

protectfracL("%1",G,L)$(protectfracL%1(G,L))=protectfracL%1(G,L);

$endif
$offtext

