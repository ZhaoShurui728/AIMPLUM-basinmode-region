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

* afforestation's forest type and carbon sink data selection. [cact_vst, cmax_vst,cdiv_vst off]
*'cact_vst' assuming actual current forest type calcuated by VISIT.
*'cmax_vst' assuming forest type with maximum forest carbon flow (sink)calcuated by VISIT.
*'off' assuming afforestation's carbon sink estimated by AEZ.
$setglobal afftype ccur_vst

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
YBASE(Y)/ %base_year% /
*Y       / %Sy%
*$if not %Sy%==%base_year% 2005
*/
R       / %Sr%
$if %Sr%==USA CAN
$if %Sr%==CAN USA
/
RISO	ISO countries	/
$include ../%prog_loc%/define/region/region_iso.set
/
I	Vertical position (LAT)	/ 1*360 /
J	Horizontal position (LON)	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
MAP_RG(R,G)	Relationship between region R and cell G
MAP_RISOG(RISO,G)
MAP_RISO(RISO,R)	Relationship between ISO countries and 17 regions
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
AFRTOT     afforestation (AFR in NoCC and AFR+NRF in BIOD)
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
MNGPAS	managed pasture
RAN	rangeland

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
NRFABD	naturally regenerating managed forest on abandoned land
NRGABD	naturally regenerating managed grassland on abandoned land
DEF	deforestion (decrease in forest area FRS from previou year)
DEG	decrease in grassland area GL from previou year
NRFABDCUM	Cumulative naturally regenerating managed forest area on abandoned land
NRGABDCUM	Cumulative naturally regenerating managed grassland on abandoned land

* degreaded soil
CLDEGS	cropland with degraded soil
/
LCROPB(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO/
LPRMSEC(L)/PRM_SEC/
LSUM(L)/AFR,CL,CROP_FLW,PAS,BIO,SL,OL/
L_USEDTOTAL(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,FRSGL/
L_UNUSED(L)/SL,OL/
LFRSGL(L)/FRSGL/
LdeltaY(L)/FRS,GL,CL,PAS,BIO/
LFRS(L)/FRS/
LMNGFRS(L)/MNGFRS/
LNRMFRS(L)/NRMFRS/
LAFR(L)/AFR/
LAFRTOT(L)/AFRTOT/
LGL(L)/GL/
LBIO(L)/BIO/
LLUC(L)/LUC/
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
/
LCHNG(L) changes in land use /
NRFABD	naturally regenerating managed forest on abandoned land
NRGABD	naturally regenerating managed grassland on abandoned land
DEF	deforestion (decrease in forest area FRS from previou year)
DEG	decrease in grassland area GL from previou year
NRFABDCUM	Cumulative naturally regenerating managed forest area on abandoned land
NRGABDCUM	Cumulative naturally regenerating managed grassland on abandoned land
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
LCGE    land use category in AIMCGE /PRM_FRS, MNG_FRS, GRAZING/
;

parameter
CS(G)           carbon density (stock or flow) of havested forest in cell G (MgC ha-1 (year-1))
CS_base(G)	carbon stock in base year
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
$load GA MAP_RG MAP_GIJ MAP_RISOG MAP_RISO

parameter
VYL(L,G)	area ratio of land category L in cell G
Area(L)	Regional area of land category L [kha]
AreaR(L,RISO)	Regional area of land category L in RISO category [kha]
VYL_pre(L,G)	area ratio of land category L in cell G in the previous year
delta_Y(L,G)	Change in area ratio of land category L in cell G
delta_VY(Y,L,G)	Changes in area ratio of land category L in cell G for all the earlier years
VYLY(Y,L,G)	land use in all the earlier years
CSL(L)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
GHGLG(EmitCat,L,G)	GHG emissions of land category L cell G in year Y [MtCO2 per grid per year]
GHGL(EmitCat,L)		GHG emission of land category L in year Y [MtCO2 per year]
GHGLR(EmitCat,L,RISO)		GHG emission of land category L in year Y [MtCO2 per year]
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



VYL("FRS",G)$(G0(G) AND CS_base(G)>=CSB)=VYL("FRSGL",G);
VYL("GL",G)$(G0(G) AND CS_base(G)<CSB)=VYL("FRSGL",G);

VYL("PRM_SEC",G)=0;
VYL("FRSGL",G)=0;

*---------------
* Forest is devided into managed/unmanaged/primary/secondary.
set
landcatall /
1	total  (11+20+31+32+40+53)
2	forest (11+20+31+32)
3	managed_forest (20+31+32)
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
Soil_deg(G)	A share of area with soil degradation to grid area in grid G (0-1) Wu et al 2019 GCBB developed using GLADIS (Freddy & Monica 2011).
frac_rcp(R,L,YBASE,G)	fraction of each gridcell G in land category L
;
$gdxin '../%prog_loc%/data/forest_class_export.gdx'
$load forest_management_shareG,forest_class_shareG

$gdxin '../%prog_loc%/individual/GCBB_biopotential/policydata.gdx'
$load	Soil_deg=serious_land

$gdxin '../%prog_loc%/data/land_map_luh2.gdx'
$load frac_rcp=frac

$ifthen.mng %Sy%==%base_year%
VYL("MNGFRS",G)$(VYL("FRS",G) and forest_management_shareG(G))=VYL("FRS",G)*forest_management_shareG(G);
VYL("UMNFRS",G)$(VYL("FRS",G))=VYL("FRS",G)-VYL("MNGFRS",G);

VYL("NRMFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*forest_class_shareG("20",G)/forest_class_shareG("3",G);
VYL("PLNFRS",G)$(VYL("MNGFRS",G) and forest_class_shareG("3",G))=VYL("MNGFRS",G)*(forest_class_shareG("31",G)+forest_class_shareG("32",G))/forest_class_shareG("3",G);
VYL("AGOFRS",G)$(VYL("CL",G) and forest_class_shareG("53",G))=min(VYL("CL",G), forest_class_shareG("53",G));


*VYL("SECFRS",G)$(VYL("FRS",G)) = min(frac_rcp("%Sr%","SECFRS","%base_year%",G), VYL("FRS",G) * forest_management_shareG(G));
VYL("SECFRS",G)$(VYL("FRS",G)) = min(frac_rcp("%Sr%","SECFRS","%base_year%",G), VYL("FRS",G));
VYL("PRMFRS",G)$(VYL("FRS",G)) = VYL("FRS",G) - VYL("SECFRS",G);
*VYL("PRMFRS",G)$(VYL("FRS",G)) = VYL("FRS",G) * sharepix("Primary vegetation",G);

VYL("SECGL",G)$(VYL("GL",G)) = min(frac_rcp("%Sr%","SECGL","%base_year%",G),VYL("GL",G));
VYL("PRMGL",G)$(VYL("GL",G)) = VYL("GL",G) - VYL("SECGL",G);

VYL("MNGPAS",G)$(VYL("PAS",G) and frac_rcp("%Sr%","MNGPAS","%base_year%",G)+frac_rcp("%Sr%","RAN","%base_year%",G)) = VYL("PAS",G) * frac_rcp("%Sr%","MNGPAS","%base_year%",G)/(frac_rcp("%Sr%","MNGPAS","%base_year%",G)+frac_rcp("%Sr%","RAN","%base_year%",G));
VYL("RAN",G)$(VYL("PAS",G)) = VYL("PAS",G) - VYL("MNGPAS",G);

delta_VY("%Sy%",L,G)=0;

VYL("CLDEGS",G)$(VYL("CL",G) and Soil_deg(G)) = min(VYL("CL",G),Soil_deg(G));



$else.mng

* Take difference

delta_Y(L,G)$(LdeltaY(L) and VYL(L,G)-VYL_pre(L,G))=VYL(L,G)-VYL_pre(L,G);

VYL("NRFABD",G)$(delta_Y("FRS",G)>0)=delta_Y("FRS",G);
VYL("NRGABD",G)$(delta_Y("GL",G)>0)=delta_Y("GL",G);
VYL("DEF",G)$(delta_Y("FRS",G)<0)=delta_Y("FRS",G)*(-1);
VYL("DEG",G)$(delta_Y("GL",G)<0)=delta_Y("GL",G)*(-1);

* Deforestation happens in managed forest first then the rest in unmanaged forest
VYL("MNGFRS",G)$(CS_base(G))         =VYL_pre("MNGFRS",G)+VYL("NRFABD",G)-min(VYL("DEF",G),VYL_pre("MNGFRS",G));
VYL("UMNFRS",G)$(VYL_pre("UMNFRS",G))=VYL_pre("UMNFRS",G)                -max(0,VYL("DEF",G)-VYL_pre("MNGFRS",G));

VYL("NRMFRS",G)$(VYL("FRS",G) and forest_class_shareG("3",G))=VYL_pre("NRMFRS",G)+VYL("NRFABD",G)-min(VYL("DEF",G),VYL_pre("MNGFRS",G))*forest_class_shareG("20",G)/forest_class_shareG("3",G);
VYL("PLNFRS",G)$(VYL("FRS",G) and forest_class_shareG("3",G))=VYL_pre("PLNFRS",G)                -min(VYL("DEF",G),VYL_pre("MNGFRS",G))*(forest_class_shareG("31",G)+forest_class_shareG("32",G))/forest_class_shareG("3",G);
VYL("AGOFRS",G)$(VYL_pre("AGOFRS",G))=VYL_pre("AGOFRS",G);

* Deforestation happens in secondary forest first then the rest in primary forest
VYL("SECFRS",G)$(CS_base(G))=VYL_pre("SECFRS",G) +VYL("NRFABD",G)-min(VYL("DEF",G),VYL_pre("SECFRS",G));
VYL("PRMFRS",G)$(VYL_pre("PRMFRS",G)) = VYL_pre("PRMFRS",G) - max(0,VYL("DEF",G)-VYL_pre("SECFRS",G));

VYL("SECGL",G)$(CS_base(G))=VYL_pre("SECGL",G) +VYL("NRGABD",G)-min(VYL("DEG",G),VYL_pre("SECGL",G));
VYL("PRMGL",G)$(VYL_pre("PRMGL",G)) = VYL_pre("PRMGL",G) - max(0,VYL("DEG",G)-VYL_pre("SECGL",G));



VYL("MNGPAS",G)$(delta_Y("PAS",G)>=0) = VYL_pre("MNGPAS",G) + delta_Y("PAS",G);
VYL("MNGPAS",G)$(VYL_pre("MNGPAS",G) and delta_Y("PAS",G)<0 and frac_rcp("%Sr%","MNGPAS","%base_year%",G)+frac_rcp("%Sr%","RAN","%base_year%",G))= VYL_pre("MNGPAS",G) + delta_Y("PAS",G) * frac_rcp("%Sr%","MNGPAS","%base_year%",G)/(frac_rcp("%Sr%","MNGPAS","%base_year%",G)+frac_rcp("%Sr%","RAN","%base_year%",G));

VYL("RAN",G)$(VYL("PAS",G)) = VYL("PAS",G) - VYL("MNGPAS",G);

VYL("CLDEGS",G)$(VYL("CL",G) and Soil_deg(G)) = min(VYL("CL",G),Soil_deg(G));

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

$ifthen.afftype %afftype%==cact_vst
  CFT(G,Y,Y2)=CFT_vst("AFR00","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==cdiv_vst
  CFT(G,Y,Y2)=CFT_vst("AFRDIV","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==cmax_vst
  CFT(G,Y,Y2)=CFT_vst("AFRMAX","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==ccur_vst
  CFT(G,Y,Y2)=CFT_vst("AFRCUR","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==cprevisit
$gdxin '../%prog_loc%/data/biomass/output/biomass%Sr%.gdx'
$load CFT
$else.afftype
$gdxin '../%prog_loc%/data/biomass/output/biomass%Sr%_aez.gdx'
$load CFT
$endif.afftype

*--------GHG emissions (Only Disaggregation of FRSGL into forest and grassland) --------*
set
LNRFABDCUM(L)/NRFABDCUM/
LNRGABDCUM(L)/NRGABDCUM/
LAGOFRS(L)/AGOFRS/
LCROPFLW(L)/CROP_FLW/
LDEF(L)/DEF/
LDEG(L)/DEG/
LCLDEGS(L)/CLDEGS/
MAP_EMIAGG(L,L)/
(AFRTOT,NRFABDCUM,DEF,AGOFRS)	.	FRS
(NRGABDCUM,DEG)	.	GL
(FRS,GL,CL,CROP_FLW,PAS,SL,OL)	.	LUC
(FRS,GL,CL,CROP_FLW,PAS,SL,OL,BIO)	.	"LUC+BIO"
/
Stc       Year category         / G20, LE20 /
Sfrst     Forest type (Natural forest or Plantation) / N, P/
;

Parameter
ordy(Y)
LEC(R,Stc,Sfrst) Carbon sequestration coefficient of natural forest grater or less than 20 years  (tonneCO2 per ha per year)
LEC0(Stc,Sfrst)      Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
f_mg_load(R)       Stock change factor of soil carbon for management regime(-) (Table 5.5 & 5.10 for cropland & table6.2 for grassland)
f_mg               Stock change factor of soil carbon for management regime(-) (Table 5.5 & 5.10 for cropland & table6.2 for grassland)
CSoil_load(R,G,Y)	12 times of Soil Carbon stock (MgC) in grid G and year Y in the baseline scenario (SSP2 land use and RCP4.5 climate) estimated by VISIT
CSoil(G)	Soil Carbon stock (MgC) in grid G
Application_ratio(L)/
CROP_FLW	1.0
NRGABDCUM	0.5
/
Depth_ratio	Assume 50% SoilC stock in a depth of 30cm /0.5/
;

ordy(Y) = ord(Y) + %base_year% -1;


$gdxin '../%prog_loc%/data/data_prep2.gdx'
$load LEC  f_mg_load=f_mg

$gdxin '../%prog_loc%/individual/ForestCsink/AFR00_CSoil_stock_visit.gdx'
$load	CSoil_load=CSoil


LEC0(Stc,Sfrst)=LEC("%Sr%",Stc,Sfrst);
*f_mg=f_mg_load("%Sr%");
f_mg=1.004;
CSoil_load("%Sr%",G,"2100")=CSoil_load("%Sr%",G,"2090");
CSoil(G)=CSoil_load("%Sr%",G,"%Sy%")/12*Depth_ratio;

VYL(L,G)$(not G0(G))=0;

* calc land use change over time
set
LCUM(L)	land category considering cumulative change or delta_VY/
NRFABDCUM
NRGABDCUM
NRFABD
NRGABD
AFRTOT
AGOFRS
/
Ldelta(L)/
AFRTOT
AGOFRS
NRFABDCUM

/
LNLUC(L) land category excluded from LUC to avoid double accounting/
BIO
FRS
MNGFRS
LUC
/
;

CSL("CL")=5;
CSL("BIO")=5;
CSL("PAS")=2.5;

VYLY("%Sy%",L,G)$(LCUM(L) and VYL(L,G))=VYL(L,G);

VYLY("%Sy%","NRFABDCUM",G)=sum(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%")),VYLY(Y2,"NRFABD",G));
VYLY("%Sy%","NRGABDCUM",G)=sum(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%")),VYLY(Y2,"NRGABD",G));

$ifthen.afrt %iav%==BIOD
VYLY("%Sy%","AFRTOT",G)=VYL("AFR",G)+VYLY("%Sy%","NRFABDCUM",G);
$else.afrt
VYLY("%Sy%","AFRTOT",G)=VYL("AFR",G);
$endif.afrt


Area(L)$(not LCUM(L))= SUM(G$(G0(G)),VYL(L,G)*GA(G));
Area(L)$(LCUM(L))= SUM(G$(G0(G)),VYLY("%Sy%",L,G)*GA(G));

AreaR(L,RISO)$(not LCUM(L) and MAP_RISO(RISO,"%Sr%"))= SUM(G$(G0(G) AND MAP_RISOG(RISO,G)),VYL(L,G)*GA(G));
AreaR(L,RISO)$(LCUM(L) and MAP_RISO(RISO,"%Sr%"))= SUM(G$(G0(G) AND MAP_RISOG(RISO,G)),VYLY("%Sy%",L,G)*GA(G));

delta_VY(Y,L,G)$(Ldelta(L) and ordy(Y)>=ordy("%base_year%")+Ystep AND ordy(Y)<=ordy("%Sy%") AND VYLY(Y,L,G))=(VYLY(Y,L,G)-VYLY(Y-Ystep,L,G));


$if not %Sy%==%base_year%	GHGLG("Positive",L,G)$(CSL(L) AND delta_Y(L,G)<0) = CSL(L)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1)/Ystep;
$if not %Sy%==%base_year%	GHGLG("Negative",L,G)$(CSL(L) AND delta_Y(L,G)>0) = CSL(L)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1)/Ystep;

GHGLG("Positive",L,G)$((LDEF(L) OR LDEG(L)) AND CS(G) AND VYL(L,G))= CS(G)*VYL(L,G) *GA(G) * 44/12 /10**3/Ystep;
GHGLG("Negative",L,G)$(LMNGFRS(L))= -LEC0("G20","N") * VYL(L,G) *GA(G)/10**3 * (-1);

GHGLG("Negative",L,G)$(LAFRTOT(L))= SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%") and delta_VY(Y2,L,G)>0), CFT(G,"%Sy%",Y2)*delta_VY(Y2,L,G)) *GA(G) * 44/12 /10**3 * (-1);
$if not %iav%==BIOD	GHGLG("Negative",L,G)$(LNRFABDCUM(L))= LEC0("LE20","N") * 0.5 * SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%") and delta_VY(Y2,L,G)), delta_VY(Y2,L,G)) *GA(G)/10**3;
GHGLG("Negative",L,G)$(LAGOFRS(L))= LEC0("LE20","P") * SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%") and delta_VY(Y2,L,G)>0), delta_VY(Y2,L,G)) *GA(G)/10**3;

$ifthen.scs not %clp%==BaU
GHGLG("Negative",L,G)$(LCROPFLW(L))= CSoil(G) * (f_mg-1) * VYL(L,G) * Application_ratio(L) * GA(G) * 44/12/10**3 * (-1);
GHGLG("Negative",L,G)$(LNRGABDCUM(L))= CSoil(G) * (f_mg-1) * VYLY("%Sy%",L,G) * Application_ratio(L) * GA(G)* 44/12/10**3 * (-1);
GHGLG("Negative",L,G)$(LCLDEGS(L))= CSoil(G) * (f_mg-1) * VYL(L,G) * GA(G)* 44/12/10**3 * (-1);
$endif.scs

GHGL(EmitCat,"FRSGL") = 0;




GHGL(EmitCat,L) = SUM(G$(GHGLG(EmitCat,L,G)),GHGLG(EmitCat,L,G));
GHGL(EmitCat,"LUC")$(SUM(L$(not LNLUC(L)),GHGL(EmitCat,L)))= SUM(L$(not LNLUC(L)),GHGL(EmitCat,L));
GHGL("Net",L)$(GHGL("Positive",L)+GHGL("Negative",L)) = GHGL("Positive",L)+GHGL("Negative",L);

GHGLR(EmitCat,L,RISO)$(MAP_RISO(RISO,"%Sr%")) = SUM(G$(MAP_RISOG(RISO,G) AND GHGLG(EmitCat,L,G)),GHGLG(EmitCat,L,G));
GHGLR(EmitCat,"LUC",RISO)$(SUM(L$(not LNLUC(L)),GHGLR(EmitCat,L,RISO)))= SUM(L$(not LNLUC(L)),GHGLR(EmitCat,L,RISO));
GHGLR("Net",L,RISO)$(GHGLR("Positive",L,RISO)+GHGLR("Negative",L,RISO)) = GHGLR("Positive",L,RISO)+GHGLR("Negative",L,RISO);


*Aggregation
SCALAR ite
FOR(ite=1 to 3,
GHGL(EmitCat,L)$(SUM(L2$(MAP_EMIAGG(L2,L)),GHGL(EmitCat,L2))) = SUM(L2$(MAP_EMIAGG(L2,L)),GHGL(EmitCat,L2));
GHGLR(EmitCat,L,RISO)$(SUM(L2$(MAP_EMIAGG(L2,L)),GHGLR(EmitCat,L2,RISO))) = SUM(L2$(MAP_EMIAGG(L2,L)),GHGLR(EmitCat,L2,RISO));
);







*------- Data output ----------*

$if not %Sy%==%base_year% execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/analysis/%Sy%.gdx'
$if %Sy%==%base_year% execute_unload '../output/gdx/base/%Sr%/analysis/%Sy%.gdx'
VYL
Area
AreaR
GHGLG
GHGL
GHGLR
$if %Sy%==%base_year% CSB,Psol_stat,FRSArea2
VYLY
CS

;




