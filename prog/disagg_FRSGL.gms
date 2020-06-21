* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal prog_dir ..\prog
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$include %prog_dir%/scenario/socioeconomic/%sce%.gms
set
dum/1*1000000/
G       Cell number  /
$offlisting
$ifthen %Sr%==USA
$include %prog_dir%\define\set_g\G_USA.set
$include %prog_dir%\define\set_g\G_CAN.set
$elseif %Sr%==CAN
$include %prog_dir%\define\set_g\G_USA.set
$include %prog_dir%\define\set_g\G_CAN.set
$else
$include %prog_dir%\define\set_g\G_%Sr%.set
$endif
$onlisting
/
G0(G)   Cell number  /
$offlisting
$include %prog_dir%/\define\set_g\G_%Sr%.set
$onlisting
/
Y       / %Sy%
$if not %Sy%==%base_year% 2005
/
R       / %Sr%
$if %Sr%==USA CAN
$if %Sr%==CAN USA
/
L land use type /
PRM_SEC forest + grassland + pasture
FRSGL   forest + grassland
*HAV_FRS        production forest
FRS     forest
AFR     afforestation
PAS     grazing pasture
PDR     rice
WHT     wheat
GRO     other coarse grain
OSD     oil crops
C_B     sugar crops
OTH_A   other crops
PDRIR   rice irrigated
WHTIR   wheat irrigated
GROIR   other coarse grain irrigated
OSDIR   oil crops irrigated
C_BIR   sugar crops irrigated
OTH_AIR other crops irrigated
PDRRF   rice rainfed
WHTRF   wheat rainfed
GRORF   other coarse grain rainfed
OSDRF   oil crops rainfed
C_BRF   sugar crops rainfed
OTH_ARF other crops rainfed
BIO     bio crops
CROP_FLW        fallow land
GL      grassland
SL      built_up
OL      ice or water
CL      cropland
/
LCROPB(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO/
LPRMSEC(L)/PRM_SEC/
*LBIO(L)/PRM_SEC,CROP_FLW/
;
Alias(G,G2),(L,L2);

*------- Carbon stock ----------*
set
Ybase/ %base_year% /
LCGE    land use category in AIMCGE /PRM_FRS, MNG_FRS, GRAZING/
;

parameter
CS(G)           carbon density (stock or flow) of havested forest in cell G (MgC ha-1 (year-1))
GA(G)           Grid area of cell G kha
CSB     carbon stock boundary in forest and grassland (MgC ha-1)
Planduse_load(Y,R,LCGE)
;

*$gdxin '%prog_dir%/../data/cbnal0/global_17_%SCE%_%CLP%_%IAV%.gdx'

$gdxin '%prog_dir%/../data/cbnal0/global_17_%scein%_BaU_%IAV%.gdx'
$load Planduse_load=Planduse

$gdxin '%prog_dir%/data/Data_prep.gdx'
$load GA

parameter
VYL(L,G)
VY_load(L,G)
Area_load(L)
;

$ifthen %Sr%==USA
$batinclude %prog_dir%/prog/disagg_FRSGLR.gms USA
$batinclude %prog_dir%/prog/disagg_FRSGLR.gms CAN
$elseif %Sr%==CAN
$batinclude %prog_dir%/prog/disagg_FRSGLR.gms USA
$batinclude %prog_dir%/prog/disagg_FRSGLR.gms CAN
$else
$batinclude %prog_dir%/prog/disagg_FRSGLR.gms %Sr%
$endif


VYL("FRSGL",G)$VYL("BIO",G)=VYL("FRSGL",G)-VYL("BIO",G);

*--- Forest -----------

parameter
*Pvalue(G,*)
FRSArea         forest area
OTHFRSArea      other forest area
FRSArea2
YFRS(G)
Psol_stat(*)                  Solution report
;

Variable
VC      Total carbon stock []
VYFRS(G)        fractions of forest area [grid-1]
;
Equation
EQVC
EQVYFRS(G)
EQCONS
;

$ifthen.baseyear %Sy%==%base_year%

*Pvalue(G,"area")=(VYL("FRSGL",G))*GA(G);
*Pvalue(G,"cstock")$Pvalue(G,"area")=CS(G);

$ifthen %Sr%==USA
FRSArea=Planduse_load("%Sy%","USA","PRM_FRS")+Planduse_load("%Sy%","USA","MNG_FRS")+Planduse_load("%Sy%","CAN","PRM_FRS")+Planduse_load("%Sy%","CAN","MNG_FRS");
$elseif %Sr%==CAN
FRSArea=Planduse_load("%Sy%","USA","PRM_FRS")+Planduse_load("%Sy%","USA","MNG_FRS")+Planduse_load("%Sy%","CAN","PRM_FRS")+Planduse_load("%Sy%","CAN","MNG_FRS");
$else
FRSArea=Planduse_load("%Sy%","%Sr%","PRM_FRS")+Planduse_load("%Sy%","%Sr%","MNG_FRS");
$endif

OTHFRSArea=SUM(G,VYL("AFR",G)*GA(G));
FRSArea2=FRSArea-OTHFRSArea;


EQVC..  VC=E=SUM(G$(CS(G) AND VYL("FRSGL",G)),CS(G)*GA(G)*VYFRS(G));
EQVYFRS(G)$(CS(G) AND VYL("FRSGL",G)).. VYFRS(G) =L= VYL("FRSGL",G);
EQCONS..        SUM(G$(CS(G) AND VYL("FRSGL",G)),GA(G)*VYFRS(G)) =L= FRSArea2;


VYFRS.L(G)$VYL("FRSGL",G)=VYL("FRSGL",G);
VYFRS.LO(G)=0;


MODEL FRSland /EQVC,EQVYFRS,EQCONS/;

Solve FRSland USING LP maxmizing VC;

YFRS(G)$VYFRS.L(G)=VYFRS.L(G);

CSB=smin(G$(YFRS(G) AND CS(G)),CS(G));

Psol_stat("SSOLVE")=FRSland.SOLVESTAT;Psol_stat("SMODEL")=FRSland.MODELSTAT;


$else.baseyear

$gdxin '../output/gdx/base/%Sr%/analysis/%base_year%.gdx'
$load CSB

$endif.baseyear






*---------------

VYL("FRS",G)$(G0(G) AND CS(G)>=CSB)=VYL("FRSGL",G);
VYL("GL",G)$(G0(G) AND CS(G)<CSB)=VYL("FRSGL",G);

VYL("PRM_SEC",G)=0;
VYL("FRSGL",G)=0;

Area_load(L)= SUM(G$(G0(G)),VYL(L,G)*GA(G));

VYL(L,G)=round(VYL(L,G),6);

$if not %Sy%==%base_year% execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/analysis/%Sy%.gdx'
$if %Sy%==%base_year% execute_unload '../output/gdx/base/%Sr%/analysis/%Sy%.gdx'
VYL=VY_load
Area_load
$if %Sy%==%base_year% CSB,Psol_stat,FRSArea2
;




