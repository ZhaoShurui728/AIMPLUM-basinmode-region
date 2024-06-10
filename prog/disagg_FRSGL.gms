* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal end_year 2100
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

$if exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/%sce%.gms
$if not exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/SSP2.gms
$if exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/%clp%.gms
$if not exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/BaU.gms
$if exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/%iav%.gms
$if not exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/NoCC.gms

$include ../%prog_loc%/inc_prog/pre_%Ystep0%year.gms

set
dum/1*1000000/
G	Cell number of the target region but both USA and CAN for North America
G0(G)	Cell number of the target region
Y year	/ %base_year%*%end_year% /
*Y       / %Sy%
*$if not %Sy%==%base_year% 2005
*/
R       / %Sr%
$if %Sr%==USA CAN
$if %Sr%==CAN USA
/
I	Vertical position (LAT)	/ 1*360 /
J	Horizontal position (LON)	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
MAP_RG(R,G)	Relationship between region R and cell G
L land use type /
PRM_SEC forest + grassland + pasture + fallow land
FRSGL   forest + grassland
HAV_FRS  production forest
FRS     forest
GL      grassland
AFR     afforestation
CL      cropland
CROP_FLW        fallow land
PAS     grazing pasture
BIO     bio crops
SL      built_up
OL      ice or water

* total
LUC
"LUC+BIO"

* forest subcategory
PRMFRS	primary forest
SECFRS	secoundary forest excl AFR
MNGFRS  managed forest excl AFR
UMNFRS  unmanage forest
NRMFRS  naturally regenerating managed forest
PLNFRS  planted forest excl AFR
AGOFRS	agroforestry

* grassland subcategory
PRMGL	primary grassland
SECGL	secoundary grassland

* crop types
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

* Changes in land use
NRFABD	naturally regenerating managed forest on abondoned land
NRGABD	naturally regenerating managed grassland on abondoned land
DEF	deforestion (decrease in forest area FRS from previou year)
DEG	decrease in grassland area GL from previou year

/
LCROPB(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO/
LPRMSEC(L)/PRM_SEC/
LSUM(L)/AFR,CL,CROP_FLW,PAS,BIO,SL,OL/
L_USEDTOTAL(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,FRSGL/
L_UNUSED(L)/SL,OL/
LFRSGL(L)/FRSGL/
LFRS_GL(L)/FRS,GL/
LFRS(L)/FRS/
LMNGFRS(L)/MNGFRS/
LNRMFRS(L)/NRMFRS/
LGL(L)/GL/
LBIO(L)/BIO/
LLUC(L)/LUC/
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
/
LEMISload(L)/CL,PAS,BIO,AFR/
LCHNG(L) changes in land use /
NRFABD	naturally regenerating managed forest on abondoned land
NRGABD	naturally regenerating managed grassland on abondoned land
DEF	deforestion (decrease in forest area FRS from previou year)
DEG	decrease in grassland area GL from previou year
/
;
parameter
Ystep   /
$ifthen %Ystep0%_%Sy%==10_2010
5
$else
%Ystep0%
$endif
/
;
Alias(G,G2),(L,L2,LL),(Y,Y2);

$gdxin '../%prog_loc%/define/subG.gdx'
$ifthen %Sr%==USA
$load G=G_USACAN G0=G_USA
$elseif %Sr%==CAN
$load G=G_USACAN G0=G_CAN
$else
$load G=G_%Sr% G0=G_%Sr%
$endif

*------- Load data ----------*
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
$load GA MAP_RG MAP_GIJ

parameter
VYL(L,G)	area ratio of land category L in cell G
Area(L)
VYL_pre(L,G)	area ratio of land category L in cell G in the previous year
delta_Y(L,G)	Change in area ratio of land category L in cell G
delta_VY(Y,L,G)	Changes in area ratio of land category L in cell G for all the earlier years
VYLY(Y,L,G)	land use in all the earlier years
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



*--- Division into Forest and Grassland -----------

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

VYL("FRS",G)$(G0(G) AND CS_base(G)>=CSB)=VYL("FRSGL",G);
VYL("GL",G)$(G0(G) AND CS_base(G)<CSB)=VYL("FRSGL",G);

VYL("PRM_SEC",G)=0;
VYL("FRSGL",G)=0;

*---------------
* Forest is devided into managed/unmanaged/primary/secondary.
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
LULC_class/
$include ../%prog_loc%/individual/BendingTheCurve/LULC_class.set
/
;
parameter
forest_management_shareG(G) A ratio of managed forest area to total forest area  in a grid cell G (0-1)
forest_class_shareG(landcatall,G) A ratio of each forest class to grid area in a grid cell G (0-1)
sharepix_load(LULC_class,I,J)
sharepix(LULC_class,G)

;
$gdxin '../%prog_loc%/data/forest_class_export.gdx'
$load forest_management_shareG,forest_class_shareG

$gdxin '../%prog_loc%/data/sharepix.gdx'
$load sharepix_load=sharepix

sharepix(LULC_class,G)=sum((I,J)$MAP_GIJ(G,I,J),sharepix_load(LULC_class,I,J));


$ifthen.mng %Sy%==%base_year%
VYL("MNGFRS",G)$(VYL("FRS",G) and forest_management_shareG(G))=VYL("FRS",G)*forest_management_shareG(G);
VYL("UMNFRS",G)$(VYL("FRS",G))=VYL("FRS",G)-VYL("MNGFRS",G);

VYL("NRMFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*forest_class_shareG("20",G)/forest_class_shareG("3",G);
VYL("PLNFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*(forest_class_shareG("31",G)+forest_class_shareG("32",G))/forest_class_shareG("3",G);
VYL("AGOFRS",G)$(VYL("CL",G) and forest_class_shareG("53",G))=min(VYL("CL",G), forest_class_shareG("53",G));

VYL("SECFRS",G)$(VYL("FRS",G)) = VYL("FRS",G) * min(sharepix("Mature and Intermediate secondary vegetation",G), forest_management_shareG(G));
VYL("PRMFRS",G)$(VYL("FRS",G)) = VYL("FRS",G) - VYL("SECFRS",G);
*VYL("PRMFRS",G)$(VYL("FRS",G)) = VYL("FRS",G) * sharepix("Primary vegetation",G);

VYL("SECGL",G)$(VYL("GL",G)) = VYL("GL",G) * sharepix("Mature and Intermediate secondary vegetation",G);
VYL("PRMGL",G)$(VYL("GL",G)) = VYL("GL",G) - VYL("SECGL",G);

delta_VY("%Sy%",L,G)=0;

VYLY("%Sy%",L,G)$(VYL(L,G))=VYL(L,G);

$else.mng

* Take difference

delta_Y(L,G)$(LFRS_GL(L) and VYL(L,G)-VYL_pre(L,G))=VYL(L,G)-VYL_pre(L,G);

VYL("NRFABD",G)$(delta_Y("FRS",G)>0)=delta_Y("FRS",G);
VYL("NRGABD",G)$(delta_Y("GL",G)>0)=delta_Y("GL",G);
VYL("DEF",G)$(delta_Y("FRS",G)<0)=delta_Y("FRS",G)*(-1);
VYL("DEG",G)$(delta_Y("GL",G)<0)=delta_Y("GL",G)*(-1);

* Deforestation happens in managed forest first then the rest in unmanaged forest
VYL("MNGFRS",G)$(CS_base(G))              =VYL_pre("MNGFRS",G)+VYL("NRFABD",G)-min(VYL("DEF",G),VYL_pre("MNGFRS",G));
VYL("UMNFRS",G)$(VYL_pre("UMNFRS",G))=VYL_pre("UMNFRS",G)                     -max(0,VYL("DEF",G)-VYL_pre("MNGFRS",G));

VYL("NRMFRS",G)$(VYL("FRS",G) and forest_class_shareG("3",G))=VYL_pre("NRMFRS",G)+VYL("NRFABD",G)-min(VYL("DEF",G),VYL_pre("MNGFRS",G))*forest_class_shareG("20",G)/forest_class_shareG("3",G);
VYL("PLNFRS",G)$(VYL("FRS",G) and forest_class_shareG("3",G))=VYL_pre("PLNFRS",G)                -min(VYL("DEF",G),VYL_pre("MNGFRS",G))*(forest_class_shareG("31",G)+forest_class_shareG("32",G))/forest_class_shareG("3",G);
VYL("AGOFRS",G)$(VYL_pre("AGOFRS",G))=VYL_pre("AGOFRS",G);

* Deforestation happens in secondary forest first then the rest in primary forest
VYL("SECFRS",G)$(CS_base(G))=VYL_pre("SECFRS",G) +VYL("NRFABD",G)-min(VYL("DEF",G),VYL("SECFRS",G));
VYL("PRMFRS",G)$(VYL_pre("PRMFRS",G)) = VYL_pre("PRMFRS",G) - max(0,VYL("DEF",G)-VYL_pre("SECFRS",G));

VYL("SECGL",G)$(CS_base(G))=VYL_pre("SECGL",G) +VYL("NRGABD",G)-min(VYL("DEG",G),VYL("SECGL",G));
VYL("PRMGL",G)$(VYL_pre("PRMGL",G)) = VYL_pre("PRMGL",G) - max(0,VYL("DEG",G)-VYL("SECGL",G));

delta_VY("%Sy%",L,G)$((not LCHNG(L)) and (VYL(L,G)-VYL_pre(L,G)))=(VYL(L,G)-VYL_pre(L,G));
VYLY("%Sy%",L,G)$(VYL(L,G))=VYL(L,G);

$endif.mng





*----Forest growth ratio
set
LVST/
AFR00	control(actual biome)
AFRMAX	foresttype with maximum carbon sink in each grid
AFRDIV	foresttype with maximum carbon sink considering biodiversity in each grid
AFRCUR	foresttype with
/
;
parameter
  CFT(G,Y,Y2)             carbon flow in year Y of forest planted in year Y2 in grid G
  CFT_vst(LVST,R,G,Y,Y2)             carbon flow in year Y of forest planted in year Y2 in grid G (VISIT data)
;

$gdxin '../%prog_loc%/data/visit_forest_growth_function.gdx'
$load CFT_vst=CFTout
  CFT(G,Y,Y2)=CFT_vst("AFRCUR","%Sr%",G,Y,Y2);



*--------GHG emissions (Only Disaggregation of FRSGL into forest and grassland) --------*
set
LNRFABD(L)/NRFABD/
LAGOFRS(L)/AGOFRS/
LDEF(L)/DEF/
LDEG(L)/DEG/
MAP_EMIAGG(L,L)/
(AFR,NRFABD,DEF,AGOFRS)	.	FRS
(NRGABD,DEG)	.	GL
(FRS,GL,CL,CROP_FLW,PAS,SL,OL)	.	LUC
(FRS,GL,CL,CROP_FLW,PAS,SL,OL,BIO)	.	"LUC+BIO"
/
Stc       Year category         / G20, LE20 /
;

Parameter
ordy(Y)
LEC(R,Stc) Carbon sequestration coefficient of natural forest grater or less than 20 years  (tonneCO2 per ha per year)
LEC0(Stc)      Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
;

ordy(Y) = ord(Y) + %base_year% -1;


$gdxin '../%prog_loc%/data/data_prep2.gdx'
$load LEC

LEC0(Stc)=LEC("%Sr%",Stc);

Area(L)= SUM(G$(G0(G)),VYL(L,G)*GA(G));

VYL(L,G)$(not G0(G))=0;




GHGLG("Positive",L,G)$((LDEF(L) OR LDEG(L)) AND CS(G) AND VYL(L,G))= CS(G)*VYL(L,G) *GA(G) * 44/12 /10**3;
*GHGLG("Negative",L,G)$(LMNGFRS(L))= -LEC0("G20") * VYL(L,G) *GA(G)/10**3 * (-1);

GHGLG("Negative",L,G)$(LNRFABD(L))= LEC0("LE20") * SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%") and VYLY(Y2,L,G)), VYLY(Y2,L,G)) *GA(G)/10**3;
GHGLG("Negative",L,G)$(LAGOFRS(L))= LEC0("LE20") * SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%") and delta_VY(Y2,L,G)>0), delta_VY(Y2,L,G)) *GA(G)/10**3;

GHGL(EmitCat,"FRSGL") = 0;

GHGL(EmitCat,L) = SUM(G$(GHGLG(EmitCat,L,G)),GHGLG(EmitCat,L,G));
GHGL("Net",L)$(GHGL("Positive",L)+GHGL("Negative",L)) = GHGL("Positive",L)+GHGL("Negative",L);


*Aggregation
SCALAR ite
FOR(ite=1 to 3,
GHGL(EmitCat,L)$(SUM(L2$(MAP_EMIAGG(L2,L)),GHGL(EmitCat,L2))) = SUM(L2$(MAP_EMIAGG(L2,L)),GHGL(EmitCat,L2));
);







*------- Data output ----------*

$if not %Sy%==%base_year% execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/analysis/%Sy%.gdx'
$if %Sy%==%base_year% execute_unload '../output/gdx/base/%Sr%/analysis/%Sy%.gdx'
VYL
Area
GHGLG
GHGL
$if %Sy%==%base_year% CSB,Psol_stat,FRSArea2
delta_VY
VYLY
CS

;




