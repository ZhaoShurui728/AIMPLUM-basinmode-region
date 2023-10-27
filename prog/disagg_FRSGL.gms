* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal prog_loc
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$setglobal biocurve off
$setglobal not1stiter off
$setglobal biodivprice off
$setglobal Ystep0 10
$if %ModelInt2%==NoValue $setglobal ModelInt 
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2% 

$include ../%prog_loc%/scenario/socioeconomic/%sce%.gms
$include ../%prog_loc%/scenario/climate_policy/%clp%.gms
$include ../%prog_loc%/scenario/IAV/%iav%.gms
$include ../%prog_loc%/inc_prog/pre_%Ystep0%year.gms

set
dum/1*1000000/
G       Cell number  /
$offlisting
$ifthen %Sr%==USA
$include ../%prog_loc%/define/set_g/G_USA.set
$include ../%prog_loc%/define/set_g/G_CAN.set
$elseif %Sr%==CAN
$include ../%prog_loc%/define/set_g/G_USA.set
$include ../%prog_loc%/define/set_g/G_CAN.set
$else
$include ../%prog_loc%/define/set_g/G_%Sr%.set
$endif
$onlisting
/
G0(G)   Cell number  /
$offlisting
$include ../%prog_loc%/define/set_g/G_%Sr%.set
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
MNGFRS  managed forest
UMNFRS  unmanage forest
PLNFRS  planted forest
NRMFRS  naturally regenerating managed forest
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
RES	restoration land that was used for cropland or pasture and set aside for restoration (only from 2020 onwards)
LUC
"LUC+BIO"
/
LCROPB(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO/
LPRMSEC(L)/PRM_SEC/
LSUM(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,FRSGL,SL,OL/
L_USEDTOTAL(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,FRSGL/
L_UNUSED(L)/SL,OL/
LFRSGL(L)/FRSGL/
LFRS(L)/FRS/
LMNGFRS(L)/MNGFRS/
LGL(L)/GL/
LBIO(L)/BIO/
LLUC(L)/LUC/
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
/
;
Alias(G,G2),(L,L2,LL);

*------- Carbon stock ----------*
set
Ybase/ %base_year% /
LCGE    land use category in AIMCGE /PRM_FRS, MNG_FRS, GRAZING/
;

parameter
CS(G)           carbon density (stock or flow) of havested forest in cell G (MgC ha-1 (year-1))
GA(G)           Grid area of cell G kha
CSB     carbon stock boundary in forest and grassland (MgC ha-1)
Planduse_load(*,Y,R,LCGE)
Planduse(Y,R,LCGE)
;

$if %not1stiter%==off $setglobal IAVload %IAV%
$if %not1stiter%==on $setglobal IAVload %preIAV%
$gdxin '../%prog_loc%/data/cgeoutput/analysis.gdx'
$load Planduse_load=Planduse
Planduse(Y,R,LCGE)=Planduse_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,R,LCGE);

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load GA

parameter
VYL(L,G)
Area_load(L)
VYL_anapre(L,G)	area ratio of land category L in cell G (previous year)
CSL(L,G)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
GHGLG(EmitCat,L,G)	GHG emissions of land category L cell G in year Y [MtCO2 per grid per year]
GHGL(EmitCat,L)		GHG emission of land category L in year Y [MtCO2 per year]
;

$ifthen %Sr%==USA
$batinclude ../%prog_loc%/inc_prog/disagg_FRSGLR.gms USA
$batinclude ../%prog_loc%/inc_prog/disagg_FRSGLR.gms CAN
$elseif %Sr%==CAN
$batinclude ../%prog_loc%/inc_prog/disagg_FRSGLR.gms USA
$batinclude ../%prog_loc%/inc_prog/disagg_FRSGLR.gms CAN
$else
$batinclude ../%prog_loc%/inc_prog/disagg_FRSGLR.gms %Sr%
$endif

$if %biocurve%==on VYL("FRSGL",G)$VYL("BIO",G)=VYL("FRSGL",G)-VYL("BIO",G);

*----Total adjustment

VYL(L,G)$(SUM(LL$(L_USEDTOTAL(LL)),VYL(LL,G)) AND NOT L_UNUSED(L))=VYL(L,G)*(1-SUM(LL$(L_UNUSED(LL)),VYL(LL,G)))/SUM(LL$(L_USEDTOTAL(LL)),VYL(LL,G));

* Sum of pixel shares should be 1.
VYL("FRSGL",G)$VYL("FRSGL",G)=1-sum(L$(LSUM(L) and (not sameas(L,"FRSGL"))),VYL(L,G));


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
FRSArea=Planduse("%Sy%","USA","PRM_FRS")+Planduse("%Sy%","USA","MNG_FRS")+Planduse("%Sy%","CAN","PRM_FRS")+Planduse("%Sy%","CAN","MNG_FRS");
$elseif %Sr%==CAN
FRSArea=Planduse("%Sy%","USA","PRM_FRS")+Planduse("%Sy%","USA","MNG_FRS")+Planduse("%Sy%","CAN","PRM_FRS")+Planduse("%Sy%","CAN","MNG_FRS");
$else
FRSArea=Planduse("%Sy%","%Sr%","PRM_FRS")+Planduse("%Sy%","%Sr%","MNG_FRS");
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

parameter
CS_base(G)	carbon stock in base year
;

$gdxin '../output/gdx/base/%Sr%/%base_year%.gdx'
$load CS_base=CS

*---------------
* Forest is devided into managed and unmanaged.
set
landcatall /
1	total
2	forest
3	managed_forest
11	naturallyRegeneratingForest_unmanage
20	naturallyRegeneratingForest_managed
31	Planted_forests >15yrs
32	Planted_forests <=15yrs
40	Oilpalmplantation
53	Agroforestry
/
;
parameter
forest_management_shareG(G) A ratio of managed forest area to total forest area  in a grid cell G (0-1)
forest_class_shareG(landcatall,G) A ratio of each forest class to grid area in a grid cell G (0-1)
;
$gdxin '../%prog_loc%/data/forest_class_export.gdx'
$load forest_management_shareG,forest_class_shareG


VYL("FRS",G)$(G0(G) AND CS_base(G)>=CSB)=VYL("FRSGL",G);
VYL("GL",G)$(G0(G) AND CS_base(G)<CSB)=VYL("FRSGL",G);

$ifthen.mng %Sy%==%base_year%
VYL("UMNFRS",G)$(VYL("FRS",G))=VYL("FRS",G)*(1-forest_management_shareG(G));
VYL("MNGFRS",G)$(VYL("FRS",G))=VYL("FRS",G)-VYL("UMNFRS",G);

VYL("NRMFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*forest_class_shareG("20",G)/forest_class_shareG("3",G);
VYL("PLNFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*(forest_class_shareG("31",G)+forest_class_shareG("32",G))/forest_class_shareG("3",G);

$else.mng

VYL("UMNFRS",G)$(VYL("FRS",G))=min(VYL_anapre("UMNFRS",G),VYL("FRS",G)*(1-forest_management_shareG(G)));
VYL("MNGFRS",G)$(VYL("FRS",G))=VYL("FRS",G)-VYL("UMNFRS",G);

VYL("NRMFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*forest_class_shareG("20",G)/forest_class_shareG("3",G);
VYL("PLNFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*(forest_class_shareG("31",G)+forest_class_shareG("32",G))/forest_class_shareG("3",G);

$endif.mng

VYL("PRM_SEC",G)=0;
VYL("FRSGL",G)=0;

Area_load(L)= SUM(G$(G0(G)),VYL(L,G)*GA(G));

VYL(L,G)$(not G0(G))=0;
*VYL(L,G)=round(VYL(L,G),6);

Parameter
LEC(R) Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
LEC0      Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
;

$gdxin '../%prog_loc%/data/data_prep2.gdx'
$load LEC

LEC0=LEC("%Sr%");

*--------GHG emissions (Only Disaggregation of FRSGL into forest and grassland) --------*

parameter
Ystep   /
$ifthen %Ystep0%_%Sy%==10_2010
5
$else
%Ystep0%
$endif
/
delta_Y(L,G)	change in area ratio of land category L in cell G
;


delta_Y(L,G)$(NOT %Sy%=%base_year% AND (VYL(L,G)-VYL_anapre(L,G)))=(VYL(L,G)-VYL_anapre(L,G))/Ystep;

GHGLG("Positive",L,G)$((LFRS(L) OR LGL(L)) AND CS(G) AND delta_Y(L,G)<0)= CS(G)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1);
GHGLG(EmitCat,L,G)$(LFRSGL(L))=0;
GHGLG("Negative",L,G)$(LMNGFRS(L) AND VYL(L,G))= LEC0 * VYL(L,G) *GA(G)/10**3 * (-1);

GHGLG("Net",L,G)$(GHGLG("Positive",L,G)+GHGLG("Negative",L,G))= GHGLG("Positive",L,G)+GHGLG("Negative",L,G);

GHGLG(EmitCat,"LUC",G)$(SUM(L$((not LBIO(L)) and (not LFRSGL(L)) and (not LLUC(L))),GHGLG(EmitCat,L,G)))= SUM(L$((not LBIO(L)) and (not LFRSGL(L)) and (not LLUC(L))),GHGLG(EmitCat,L,G));
GHGLG(EmitCat,"LUC+BIO",G)$(SUM(L$((not LFRSGL(L)) and (not LLUC(L))),GHGLG(EmitCat,L,G)))= SUM(L$((not LFRSGL(L)) and (not LLUC(L))),GHGLG(EmitCat,L,G));

GHGL(EmitCat,L)= SUM(G$(GHGLG(EmitCat,L,G)),GHGLG(EmitCat,L,G));


*------- Data output ----------*

$if not %Sy%==%base_year% execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/analysis/%Sy%.gdx'
$if %Sy%==%base_year% execute_unload '../output/gdx/base/%Sr%/analysis/%Sy%.gdx'
VYL=VY_load
Area_load
GHGLG
GHGL
$if %Sy%==%base_year% CSB,Psol_stat,FRSArea2
VYL_anapre
CS
YFRS
;




