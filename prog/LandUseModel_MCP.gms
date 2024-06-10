* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_loc
$setglobal mcp off
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$setglobal parallel on
$setglobal supcuv off
$setglobal ModelInt
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%
* if biocurve=off, biocrop is allocated.If biocurve=on, biocrop is output as a supply curve.
$setglobal biocurve off
$setglobal Ystep0 10
$setglobal carbonprice on

* BTC protection
$setglobal biodivcons off
$setglobal biodivdata WildArea_KBA_WDPA
$setglobal biodivprice off
$setglobal only3rdgenbio off
$setglobal noAFRtarget off
$setglobal not1stiter off
$setglobal CPLEXThreadOp 3

* afforestation's forest type and carbon sink data selection. [cact_vst, cmax_vst,cdiv_vst off]
*'cact_vst' assuming actual current forest type calcuated by VISIT.
*'cmax_vst' assuming forest type with maximum forest carbon flow (sink)calcuated by VISIT.
*'off' assuming afforestation's carbon sink estimated by AEZ.
$setglobal afftype off

* FAO FRA protection
$setglobal frsprotectexpand on

* ohashiprotect should be 'ohashi' and 'percentage of species importance level' e.g. ohashi75 or 'off'
$setglobal ohashiprotect off

* WDPAprotect should be selected from protect_bs, protect_all, off.
*protect_bs(G) protect area belong to WDPA IUCN_CAT Ia, Ib, II, III, and excluded in the baseline scenario
*protect_all(G) protect area including all categories of WDPA and KBA
$setglobal WDPAprotect protect_all

*degradedlandprotect should be selected from i) serious_land_allpolicy, ii) serious_land, iii) severe_land and iv) off.
$setglobal degradedlandprotect off

*Urban area data. If this option is SSP, SSP based urban area is used. Otherwise, fixed to RCP current land. [SSP, RCP]
$setglobal UrbanLandData SSP
*$if %Sr%==XNF $setglobal UrbanLandData RCP

*Base year cross entropy adjustment can be implemented by turning on. default is on. options are [on/off]
$setglobal baseadjust on

$if %Sy%==2005 $setglobal mcp off
$if not %Sy%==2005 $setglobal mcp off

$include ../%prog_loc%/inc_prog/pre_%Ystep0%year.gms
$include ../%prog_loc%/inc_prog/second_%Ystep0%year.gms

$if exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/%sce%.gms
$if not exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/SSP2.gms
$if exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/%clp%.gms
$if not exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/BaU.gms
$if exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/%iav%.gms
$if not exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/NoCC.gms

*ecosystem protection
$setglobal protectStartYear 2030
*$setglobal protectStartYear %second_year%

Set
R	17 regions	/%Sr%/
G	Cell number of the target region
MAP_RG(R,G)	Relationship between region R and cell G
I /1*360/
J /1*720/
MAP_GIJ(G,I,J)
Y year	/ %base_year%*%end_year% /
YBASE(Y)/ %base_year% /
YEND(Y) / %end_year% /
Y0(Y)   / %Sy% /
L land use type /
PRM_SEC	forest + grassland + pasture + fallow land
FRSGL	forest + grassland
$if %base_year%==%Sy% FRS
$if %base_year%==%Sy% GL
$if %base_year%==%Sy% PRM_FRS
HAV_FRS	production forest
AFR	afforestation

CROP_FLW	fallow land
CL	cropland
PAS	grazing pasture
BIO	bio crops
SL	built_up
OL	ice or water
RES	restoration land that was used for cropland or pasture and set aside for restoration

* total
TOT	Total
LUC

* crop types with irrigation/rainfed
PDRIR	rice irrigated
WHTIR	wheat irrigated
GROIR	other coarse grain irrigated
OSDIR	oil crops irrigated
C_BIR	sugar crops irrigated
OTH_AIR	other crops irrigated
PDRRF	rice rainfed
WHTRF	wheat rainfed
GRORF	other coarse grain rainfed
OSDRF	oil crops rainfed
C_BRF	sugar crops rainfed
OTH_ARF	other crops rainfed
/

LRCPnonNat(L)/
CL	cropland
PAS	grazing pasture
SL	built_up
OL	ice or water
/
LDM land use type /
PRM_SEC	other forest and grassland
$if %base_year%==%Sy% FRS
$if %base_year%==%Sy% GL
HAV_FRS	production forest
AFR	afforestation
CL	cropland
PAS	grazing pasture
CROP_FLW	fallow land
BIO	bio crops
SL	built_up
OL	ice or water

* crop types
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
/
MAP_LLDM(L,LDM)/
PRM_SEC	.	PRM_SEC
HAV_FRS	.	HAV_FRS
AFR	.	AFR
PAS	.	PAS
PDRIR	.	PDR
WHTIR	.	WHT
GROIR	.	GRO
OSDIR	.	OSD
C_BIR	.	C_B
OTH_AIR	.	OTH_A
PDRRF	.	PDR
WHTRF	.	WHT
GRORF	.	GRO
OSDRF	.	OSD
C_BRF	.	C_B
OTH_ARF	.	OTH_A
BIO	.	BIO
CROP_FLW	.	CROP_FLW
SL	.	SL
OL	.	OL
CL	.	CL
/
LCROPA(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO,CROP_FLW/
LCROPB(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO/
LCROP(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/
LCROPIR(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR/
LCROPRF(L)/PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/

LDMCROPA(LDM)/PDR,WHT,GRO,OSD,C_B,OTH_A,BIO,CROP_FLW/
LDMCROPB(LDM)/PDR,WHT,GRO,OSD,C_B,OTH_A,BIO/
LDMCROP(LDM)/PDR,WHT,GRO,OSD,C_B,OTH_A/
LFRS(L)/PRM_SEC,HAV_FRS,AFR/
LPRMSEC(L)/PRM_SEC/
LFRSGL(L)/FRSGL/
LAFR(L)/AFR/
LPAS(L)/PAS/
LBIO(L)/BIO/
LOBJ(L)
LFIX(L)/SL,OL/

;
Alias (G,G2,G3,G4,G5,G6,G7,G8),(L,L2),(Y,Y2,Y3);
set
MAP_Lagg(L,L2)/
PRM_SEC	.	PRM_SEC
*HAV_FRS	.	HAV_FRS
FRSGL	.	FRSGL
AFR	.	AFR
PAS	.	PAS
PDRIR	.	PDRIR
WHTIR	.	WHTIR
GROIR	.	GROIR
OSDIR	.	OSDIR
C_BIR	.	C_BIR
OTH_AIR	.	OTH_AIR
PDRRF	.	PDRRF
WHTRF	.	WHTRF
GRORF	.	GRORF
OSDRF	.	OSDRF
C_BRF	.	C_BRF
OTH_ARF	.	OTH_ARF
BIO	.	BIO
CROP_FLW	.	CROP_FLW
SL	.	SL
OL	.	OL
PDRIR	.	CL
WHTIR	.	CL
GROIR	.	CL
OSDIR	.	CL
C_BIR	.	CL
OTH_AIR	.	CL
PDRRF	.	CL
WHTRF	.	CL
GRORF	.	CL
OSDRF	.	CL
C_BRF	.	CL
OTH_ARF	.	CL
/
MAP_Laggprotection(L,L2) only for protection land settings to include BIO in CL /
PRM_SEC	.	PRM_SEC
*HAV_FRS	.	HAV_FRS
FRSGL	.	FRSGL
AFR	.	AFR
PAS	.	PAS
PDRIR	.	PDRIR
WHTIR	.	WHTIR
GROIR	.	GROIR
OSDIR	.	OSDIR
C_BIR	.	C_BIR
OTH_AIR	.	OTH_AIR
PDRRF	.	PDRRF
WHTRF	.	WHTRF
GRORF	.	GRORF
OSDRF	.	OSDRF
C_BRF	.	C_BRF
OTH_ARF	.	OTH_ARF
BIO	.	BIO
CROP_FLW	.	CROP_FLW
SL	.	SL
OL	.	OL
PDRIR	.	CL
WHTIR	.	CL
GROIR	.	CL
OSDIR	.	CL
C_BIR	.	CL
OTH_AIR	.	CL
PDRRF	.	CL
WHTRF	.	CL
GRORF	.	CL
OSDRF	.	CL
C_BRF	.	CL
OTH_ARF	.	CL
BIO	.	CL
/
ohashi(R,G)
;

Parameter
Ystep   /
$ifthen %Ystep0%_%Sy%==10_2010
5
$else
%Ystep0%
$endif
/
GA(G)		Grid area of cell G kha
GAT		Total grid area
FLAG_G(G)		Grid flag
GL(G,G2)		Distance between grid G and G2
;

$gdxin '../%prog_loc%/define/subG.gdx'
$load G=G_%Sr%
$gdxin '../%prog_loc%/data/data_prep.gdx'
$load GA
$load MAP_GIJ Map_RG

FLAG_G(G)$MAP_RG("%Sr%",G)=1;
GA(G)$(FLAG_G(G)=0)=0;
GAT=SUM(G$FLAG_G(G),GA(G));

set
REVG(G) cells allowed for conversion/set.G/
protect_cat	protection area categories/
WDPA_KBA_Wu2019
WildArea_KBA_WDPA_BTC
/
;
Parameter
pa(L,G)		land transition costs per unit area (million $ per ha)
pd(L,G)             a constant for decreasing returns to scale
ps(L,G)             net benefit (=cost - benefit) per unit area (million $ per ha per year)
Y_base(L,G)	area ratio of land category L in cell G (initial)
Y_pre(L,G)	area ratio of land category L in cell G (previous year)
FLAGDM(L)	flag on demand of land or carbon
PLDM(LDM)		land demand (kha)
PCDM(L)		carbon demand (tonne carbon)
pr(L,G)	revenue per unit area of commodities (million $ ha-1 yr-1)
pr_price_base(L)	base year price pf commodities (million $ per tonne)
pr_price_base0(LDM)	base year price pf commodities (million $ per tonne)
pr_pricey(Y,L)      price of commodities (2005=1)
pr_price_indx(L)	price of commodities (2005=1)
pr_price(L)         price of commodities (million $ per tonne)
pc(L)   production cost per unit area (million $ per ha per year)
pc_input(L)	input (excl. land input) for producing commodities (million $)
pc_area(L)	land area for producing commodities (ha)
CS(G)		carbon stock of havested forest in cell G (MgC ha-1)
plandrent(L)	land rent (million $ per ha)
protectfrac(G)	Protected area fraction (0 to 1) in each cell G
protectfracL(G,L)	Protected area fraction (0 to 1) of land category L in each cell G
protectland(G)	Protected area fraction (0 to 1) of cell G (WDPA and IUCN)
protect_area(protect_cat,L)	Regional aggregated protection area (kha)
degradedland(G)	Degraded land fraction (0 to 1)
FPRM
FAFR
DR	discount ratio /0.05/
YPP	payback period (year)	/60/
YIELD(L,G)	Yield of land category L cell G in year Y [tonne per ha per year]
F_PLDM(L,G)     flag for change in PLDM
FLAG_BIO(L)     flag for considering bioland
frsprotectarea	protected forest area (kha)
CSB     carbon stock boundary in forest and grassland (MgC ha-1)
C_TON	average carbon density of crops (tonne Carbon per tonne Crop) /0.5/
YPNMAXCL	Maximum change in ratio of cropland area
;
* if bioland on then FLAG_BIO should be zero to exclude BIO from allocation.
FLAG_BIO(L)=1;
$if %biocurve%==on FLAG_BIO("BIO")=0;

Variable
VOBJ	objective variables
VZ(L,G)	objective variables of land category L in cell G
VY(L,G)	area ratio of land category L in cell G
VYP(L,G)	increase in area ratio of land category L in cell G
VYN(L,G)	decrease in area ratio of land category L in cell G
VRSPRM(L,G)	Comprementary variable to VY(L G) of primary forest
VRSAFR(L,G)	Comprementary variable to VY(L G) of afforestation
;

Equation
EQOBJ	objective function
EQPRF(L,G)	preference function
EQPRF2(L,G)	preference function
EQYPN(L,G)	change in area ratio of land category L in cell G

EQTOTY(G)		constraint of total cell area
EQLDM(LDM)		constraint of land demand by land area
EQCDM(L)		constraint of land demand by carbon amount
EQYPRMSEC(G)		Area ratio of primary and secondary land area in cell G
EQ_VZ(L,G)	Derivation of objective variables of land category L in cell G
EQ_VY(L,G)	Derivation of area ratio of land category L in cell G
EQYPRMFRS(L,G)	Constraint for area ratio of primary forest
EQYAFR(L,G)	Constraint for area ratio of afforestation
EQYPROTECT(G)	Constraint for the fraction of protected area plus land degradation are in cell G
EQFRSPRT	Constraint for protected forest area in region
EQYPMAX(G)	Constraint for maximum increase in area ratio of land category L in cell G
EQYNMAX(G)	Constraint for maximum decrease in area ratio of land category L in cell G
EQYPROTECTL(G,L)	Constraint for protected area of land category L in cell G
;

*--Equation

EQOBJ..
$if not %mcp%==on	VOBJ =E= SUM((L,G)$(FLAGDM(L) AND LOBJ(L)),VZ(L,G));
$if %mcp%==on	VOBJ =E= 0;

EQYPN(L,G)$(FLAGDM(L) AND LOBJ(L) AND YIELD(L,G) AND (NOT F_PLDM(L,G)) AND FLAG_BIO(L)).. VY(L,G)-Y_pre(L,G) =E= VYP(L,G)-VYN(L,G);


EQYPMAX(G)$(YPNMAXCL)..  SUM(L$(LCROP(L) AND FLAGDM(L) AND LOBJ(L) AND YIELD(L,G) AND (NOT F_PLDM(L,G)) AND FLAG_BIO(L)),VYP(L,G)) =L= YPNMAXCL;

EQYNMAX(G)$(YPNMAXCL)..  SUM(L$(LCROP(L) AND FLAGDM(L) AND LOBJ(L) AND YIELD(L,G) AND (NOT F_PLDM(L,G)) AND FLAG_BIO(L)),VYN(L,G)) =L= YPNMAXCL;

EQPRF(L,G)$(FLAGDM(L) AND LOBJ(L) AND YIELD(L,G) AND FLAG_BIO(L)).. VZ(L,G) =E= (VY(L,G)*ps(L,G)-pa(L,G)*VYP(L,G)) * GA(G);

*EQPRF2(L,G)$(FLAGDM(L)  AND LOBJ(L)).. VZ(L,G) =E= pa(L,G)*(VY(L,G)-Y_pre(L,G))*(VY(L,G)-Y_pre(L,G)) + pb(L) * (VY(L,G)-Y_pre(L,G)) *  SUM(G2$(MAP_WG(G,G2) AND FLAG_G(G2)),(VY(L,G2)-Y_pre(L,G2))) + (VY(L,G)-pd(L,G)*ps(L,G)*(1-VRSPRM(L,G)$FPRM)*(1+VRSAFR(L,G)$FAFR))*(VY(L,G)-pd(L,G)*ps(L,G)*(1-VRSPRM(L,G)$FPRM)*(1+VRSAFR(L,G)$FAFR));

EQTOTY(G)..  1 =G= SUM(L$(FLAGDM(L) AND FLAG_BIO(L)),VY(L,G));

EQLDM(LDM)$(PLDM(LDM) AND SUM(L$(MAP_LLDM(L,LDM) AND FLAG_BIO(L)),1)).. SUM(L$(MAP_LLDM(L,LDM) AND FLAG_BIO(L)), SUM(G,ga(G)*VY(L,G))) =E= PLDM(LDM);

EQCDM(L)$(PCDM(L) AND FLAG_BIO(L)).. SUM(G,CS(G)*10**3*ga(G)*VY(L,G)) =E= PCDM(L);

EQYPRMSEC(G).. VY("PRM_SEC",G) =E= 1 - SUM(L$((NOT LPRMSEC(L)) AND FLAG_BIO(L)),VY(L,G));

EQYPRMFRS(L,G)$(FLAGDM(L) AND LPRMSEC(L) AND FPRM AND Y_pre(L,G) AND ps(L,G) AND FLAG_BIO(L)).. Y_pre(L,G)-VY(L,G) =G= 0;

EQYAFR(L,G)$(FLAGDM(L) AND LAFR(L) AND FAFR AND Y_pre(L,G) AND ps(L,G) AND YIELD(L,G) AND FLAG_BIO(L)).. VY(L,G)-Y_pre(L,G) =G= 0;

EQYPROTECT(G)$(protectfrac(G) and REVG(G))..        VY("PRM_SEC",G) =G= protectfrac(G);

EQYPROTECTL(G,L)$(protectfracL(G,L) and (not LPAS(L)))..        sum(L2$MAP_Laggprotection(L2,L),VY(L2,G)) =G= protectfracL(G,L);

EQFRSPRT$(frsprotectarea)..	SUM(G$(CS(G)>CSB),VY("PRM_SEC",G)*GA(G)) =G= frsprotectarea;


MODEL
LandUseModel/
EQOBJ
*EQPRF2
EQTOTY
EQLDM
EQCDM
EQYPRMFRS
EQYAFR
/
LandUseModel_LP/
EQYPN
EQPRF
*EQPRF2
EQOBJ
EQTOTY
EQLDM
*EQCDM
*EQYPRMFRS
EQYAFR
EQYPRMSEC
EQYPROTECT
EQYPROTECTL
EQFRSPRT
EQYPMAX
EQYNMAX
/

;

*------- Parameter_in ----------*
SET
CVST	crop categoly in VISIT /PDR,C3,C4,C3natural,C4natural,cstock,co2flux/
$ontext
Map_LCVST(L,CVST)/
BIO	.	C4
*PAS	.	C4natural
*CROP_FLW	.	C4
*HAV_FRS	.         cstock
*AFR	.	co2flux
/
$offtext
AC  global set for model accounts - aggregated microsam accounts
A(AC)  activities
ACROP(A)	crop production activities
C(AC)  commodities
CCROP(C) crop commodities
F(AC)  factors
FL(AC) Land use AEZ
Produnit /TON,C/
LCGE 	land use category in AIMCGE /CROP, PRM_FRS, MNG_FRS, CROP_FLW, GRAZING, GRASS,BIOCROP,URB,OTH/
LRCP(L) /HAV_FRS,PAS,OL/
SCENARIO /%SCE%_%CLP%_%IAV%%ModelInt%/
SSP	/%SSP%/

i_FRA/"Conservation of biodiversity"/
biodivconsdata /%biodivdata%/
L_LC land use type /
FRS forest
PAS	grazing pasture
OL	ice or water
CL	cropland
ONV	this is to load Land Conversion data in Bending The Curve project
/
map_L_LC(L_LC,L)/
FRS	.	PRM_SEC
PAS	.	PAS
*OL	.	OL
CL	.	CL
ONV	.	PRM_SEC
/
LVST/
AFR00	control(actual biome)
AFRMAX	foresttype with maximum carbon sink in each grid
AFRDIV	foresttype with maximum carbon sink considering biodiversity in each grid
AFRCUR
/
*LCGAEZ(L) /PDR,WHT,GRO,OSD,C_B,OTH_A/
LCisimip(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/
LCVST(L)  /HAV_FRS,AFR,PAS,BIO,CROP_FLW/
LCTON(L)	land category of price calculated by unit tonne /PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,CROP_FLW/
LCC(L)    land category of price calculated by unit carbon /HAV_FRS,AFR,BIO,PAS/
LDMCTON(LDM)	land category of price calculated by unit tonne /PDR,WHT,GRO,OSD,C_B,OTH_A,CROP_FLW/
LDMCC(LDM)    land category of price calculated by unit carbon /HAV_FRS,AFR,BIO,PAS/
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
/
;
$gdxin '../%prog_loc%/data/set.gdx'
$load AC A ACROP C CCROP F FL
$gdxin '../%prog_loc%/data/data_prep.gdx'
$load MAP_WG
;
SET
TX(AC)/YTAX,STAX,TAR,ETAX/
MAP_LA(L,A)/
PDRIR	.	PDR
WHTIR	.	WHT
GROIR	.	GRO
OSDIR	.	OSD
C_BIR	.	C_B
OTH_AIR	.	OTH_A
PDRRF	.	PDR
WHTRF	.	WHT
GRORF	.	GRO
OSDRF	.	OSD
C_BRF	.	C_B
OTH_ARF	.	OTH_A
BIO	.	ECR
PAS	.	CTL
PAS	.	RMK
PAS	.	OTH_L
HAV_FRS	.	FRS
AFR	.	FRS
/
MAP_LC(L,C)/
PDRIR	.	COM_PDR
WHTIR	.	COM_WHT
GROIR	.	COM_GRO
OSDIR	.	COM_OSD
C_BIR	.	COM_C_B
OTH_AIR	.	COM_OTH_A
PDRRF	.	COM_PDR
WHTRF	.	COM_WHT
GRORF	.	COM_GRO
OSDRF	.	COM_OSD
C_BRF	.	COM_C_B
OTH_ARF	.	COM_OTH_A
BIO	.	COM_ECR
PAS	.	COM_CTL
PAS	.	COM_RMK
PAS	.	COM_OTH_L
HAV_FRS	.	COM_FRS
AFR	.	COM_FRS
/

MAP_LDMA(LDM,A)/
PDR	.	PDR
WHT	.	WHT
GRO	.	GRO
OSD	.	OSD
C_B	.	C_B
OTH_A	.	OTH_A
BIO	.	ECR
PAS	.	CTL
PAS	.	RMK
PAS	.	OTH_L
HAV_FRS	.	FRS
AFR	.	FRS
/
MAP_LDMC(LDM,C)/
PDR	.	COM_PDR
WHT	.	COM_WHT
GRO	.	COM_GRO
OSD	.	COM_OSD
C_B	.	COM_C_B
OTH_A	.	COM_OTH_A
BIO	.	COM_ECR
PAS	.	COM_CTL
PAS	.	COM_RMK
PAS	.	COM_OTH_L
HAV_FRS	.	COM_FRS
AFR	.	COM_FRS
/
;
Alias(AC,ACP),(A,AP),(C,CP);
CCROP("COM_ECR")=YES;

parameter
land_basemap(R,G,L)	Percentage share of land type in base year
crop_basemap(LDM,G)	Percentage share of cropland type in base year
frac_rcp(R,L,YBASE,G)	fraction of each gridcell G in land category L
PVISIT(CVST,G)	Yield of land category L cell G in year Y [Mg C per ha per year]
YIELD_cge(Y,R,LDM)	CGE output of yield of land category L region R in year Y [tonne per ha per year]
YIELD_gaez(L,G)	GAEZ yield of land category L cell G in year Y [tonne per ha per year]
YIELD_AVE(LDM)	Agerage yield of land category L region R in year Y [tonne per ha per year]
Pisimip(L,G)    ISIMIP (LPJmL) yield of land category L cell G in year Y [tonne per ha per year]
Pprod(Y,R,LDM,PRODUNIT)	Production
TON_C(R,CVST)	Ratio of tonne to tonne Carbon [tonne per tonne C]
DW_TON	Ratio of dry matter tonne to tonne [dry matter tonne per ton] source: GAEZ model conversion factor pasture/
0.1/
C_DW		Ratio of tonne carbon to tonne dry matter of biomass [tonne C per dry matter tonne]/
0.47
/
Planduse_load(*,Y,R,LCGE)                                Land use | kha

Planduse(Y,LCGE)
PlanduseT	total land demand (kha or tonne carbon)
SF_planduse	scale factor
ordy(Y)
Ppopulation(Y0,R)
POP(*,Y0,R)
GDP_load(Y0,R)
GDP(*,Y0,R)
GDPCAP_WLD	global average of gdp per capita in base year (10 thousand $ per capita)	/0.68/
GDPCAP		GDP per capita (10 thousand $ per capita)
GDPCAP_base     GDP per capita in base year (10 thousand $ per capita)
PGHG_load(*,Y0,R)	Carbon price [k$ per tonne CO2]
PGHG	Carbon price [million $ per tonne C]
Pirri(LDM,G)	Irrigation ratio of crop LDM cell G (0 to 1)
SF_YIELD(LDM)   Scale factor to adjust average yield to CGE estimates
SSP_frac(L,Y,R,G) Fraction of built-up (SL) per grid in year Y

Pland_load(*,Y,R,A)                                     Land area by sectors
OUTPUTALL_Nominal_load(*,Y,R,AC)                         Output of sector AC nominal value| Million USD per year
OUTPUTAC_load(*,Y,R,A,C)                                 Output of C from A | mil.$ or ktoe
Pland(Y,AC)                                     Land area by sectors
OUTPUTALL_Nominal(Y,AC)                         Output of sector AC nominal value| Million USD per year
OUTPUTAC(Y,A,C)                                 Output of C from A | mil.$ or ktoe
popdens_load(Y0,SSP,G)
popdens(G)	population density (inhabitants per km2)
  VZ_load(L,G)
  VY_load(L,G)
  YBIO_load(G)
  PLDM_load(LDM)
  PCDM_load(L)

  FRA_load(R,Y,i_FRA)  protected forest area (kha) in FRA(2010)
  frsprotect_check
  protectfracIJL(I,J,biodivconsdata,L_LC)
  ACF(G)          average carbon flow in grid G
  MACF            mean value of average carbon flow in each region
  CFT(G,Y,Y2)             carbon flow in year Y of forest planted in year Y2 in grid G
  ACF_aez(G)          average carbon flow in year Y in grid G     (MgC ha-1 year-1) (AEZ data)
  MACF_aez            mean value of average carbon flow in each region        (MgC ha-1 year-1) (AEZ data)
  CFT_aez(G,Y,Y2)             carbon flow in year Y of forest planted in year Y2 in grid G     (MgC ha-1 year-1) (AEZ data)
  ACF_vst0(G)          average carbon flow in year Y in grid G     (MgC ha-1 year-1) (VISIT previous data)
  MACF_vst0            mean value of average carbon flow in each region        (MgC ha-1 year-1) (VISIT previous data)
  CFT_vst0(G,Y,Y2)             carbon flow in year Y of forest planted in year Y2 in grid G     (MgC ha-1 year-1) (VISIT previous data)
  ACF_vst(LVST,R,G)          average carbon flow in grid G (VISIT data)
  MACF_vst(LVST,R)            mean value of average carbon flow in each region (VISIT data)
  CFT_vst(LVST,R,G,Y,Y2)             carbon flow in year Y of forest planted in year Y2 in grid G (VISIT data)
  MF      management factor for bio crops
  MFA     management factor for bio crops in base year
  MFB     management factor for bio crops (coefficient)

  yield_miscanthus_rainfed_num(I,J)	miscanthus biocrop yield (kg per ha)
  yield_swichgrass_rainfed_num(I,J)	swichgrass biocrop yield (kg per ha)
  YIELDBIO_H08(G)	average biocrop yield (tonne per ha)
  PBIODIV(L,G)	price (penalty) of biodiversity loss [million US$ per ha]
  PBIODIVY0(Y) penalty of biodiversity loss [US$ per ha]
  RR(G)	the range-rarity map
* BIIcoef(L)	the Biodiversity Intactness Index coefficients
  BIIcoefG(L,G)	the Biodiversity Intactness Index (BII) coefficients
  PB_WLD	annual benefit from afforestation per ha global average (million $ per ha)	/0.00162/
  PBR	annual benefit from afforestation per ha in region (million $ per ha)	 (million $ per ha)
  PB(G)   annual benefit from afforestation per ha in grid g (million $ per ha)	 (million $ per ha)
  PLDM0(Y,LDM)
  PCDM0(Y,L)

  pldc_WLD	global average of road construction cost per unit distance (million $ per km)
  pldc	road construction cost per unit distance (million $ per km)
  irricost_WLD	global average of irrigation investment cost  (million $ per ha)	/0.01/
  irricost	irrigation investment cost (million $ per ha)
  plcc(L)	land conversion cost per ha
  ruralroadlength(R)	total load length in rural area (km)
  roaddens	mean load density in rural area (km per ha)
  GLMINHA(L,G)	minimum distance per unit grid area from the nearest cell G within the same category L (km per ha)
  psmax(L)
  psmin(L)
  GLMAX
  GLMIN0(L,G)
  GLMIN(L,G)
  GL_load(G,G2)		Distance between grid G and G2 (km)(load)
  labor	labor for land clearance (persons-days per ha) /180/
  wage	wage (million $ per capita per day)

  YPP_lab         Payback period of investment cost for agriculture /10/
  YPP_road	Payback period of investment cost for road constraction /50/
  YPP_irri	Payback period of investment cost for irrigation /15/
  YPP_emit	Payback period of investment cost for greenhouse gas emission /30/
  YPP_biodiv	Payback period of investment cost for biodiveristy loss /1/

  pannual_lab     Annualization coefficient of investment cost
  pannual_road	Annualization coefficient of investment cost
  pannual_irri	Annualization coefficient of investment cost
  pannual_emit	Annualization coefficient of investment cost
  pannual_biodiv	Annualization coefficient of investment cost

* cost breakdown
  pa_lab(G)         labor costs per unit area (million $ per ha)
  pa_road(L,G)        road construction costs per unit area (million $ per ha)
  pa_irri(L)        irrigation costs per unit area (million $ per ha)
  pa_emit(G)        emission costs per unit area (million $ per ha)
  pa_bio(G)         land transition costs per unit area for BIO (million $ per ha)
  pa_biodiv(G,L)	  costs (penalty) for biodiversity loss (million $ per ha)
  Psol_stat(*,*)                  Solution report
  VYL(L,G)	output of VY
  VYPL(L,G)	output of VYP
  VZL(L,G)	output of VZ
  protect_wopas(G)
  VY_baseresults(LFRSGL,G)
  VYLY(Y,L,G)	land use in all the earlier years
  delta_VY(Y,L,G)	Changes in land use in all the earlier years
  CSL(L,G)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
  delta_Y(L,G)	annual change in area ratio of land category L in cell G
  GHGLG(EmitCat,L,G)	GHG emissions of land category L cell G in year Y [MtCO2 per grid per year]
  GHGL(EmitCat,L)		GHG emission of land category L in year Y [MtCO2 per year]
  CS_post(G)	carbon stock in next year  (MgC ha-1)
  YIELDL_OUT(L)	Agerage yield of land category L region R in year Y [tonne per ha per year]
  YIELDLDM_OUT(LDM)	Agerage yield of land category L region R in year Y [tonne per ha per year]
  data_check(G,L)
;
ordy(Y) = ord(Y) + %base_year% -1;

*-------Base-year map data load ----------*
* Base-year land type data
$gdxin '../%prog_loc%/data/land_map_gtap.gdx'
$load land_basemap=base_map

* Base-year land type data
$gdxin '../%prog_loc%/data/land_map_luh2.gdx'
$load frac_rcp=frac

* Settled land type data
$gdxin '../%prog_loc%/data/urban/%SSP%_Frac.gdx'
$load SSP_frac = Frac

* Base-year cropland map data
$gdxin '../%prog_loc%/data/cropland_map_rmk.gdx'
$load crop_basemap

$gdxin '../%prog_loc%/data/cgeoutput/analysis.gdx'
$load Pland_load=Pland_phs
$load Outputall_nominal_load=Outputall_nominal OUTPUTAC_load=OUTPUTAC
$load PGHG_load=PGHG
$load POP
$load GDP
$load Planduse_load=Planduse

$if %not1stiter%==off $setglobal IAVload %IAV%
$if %not1stiter%==on $setglobal IAVload %preIAV%
Ppopulation(Y0,R)=POP("%SCE%_%CLP%_%IAVload%%ModelInt%",Y0,R);
GDP_load(Y0,R)=GDP("%SCE%_%CLP%_%IAVload%%ModelInt%",Y0,R);
$if %carbonprice%==off PGHG_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y0,R)=0;
Planduse(Y,LCGE)=Planduse_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,"%Sr%",LCGE);
PGHG(Y0)=PGHG_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y0,"%Sr%")/1000*44/12;
Pland(Y,A)=Pland_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,"%Sr%",A);
OUTPUTALL_Nominal(Y,A)=OUTPUTALL_Nominal_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,"%Sr%",A);
OUTPUTAC(Y,A,C)=OUTPUTAC_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,"%Sr%",A,C);

* Base-year irrigation map data
$gdxin '../%prog_loc%/data/mirca.gdx'
$load Pirri

$gdxin '../%prog_loc%/data/ssppopmap.gdx'
$load popdens_load=popdens

popdens(G)=popdens_load("%Sy%","%SSP%",G);
GDPCAP$Ppopulation("%Sy%","%Sr%")=GDP_load("%Sy%","%Sr%")/Ppopulation("%Sy%","%Sr%");

*-------Pre-year land map load ----------*
$ifthen.baseyear %Sy%==%base_year%
*---Y_base preparation
Y_base(L,G)$(LRCP(L))=frac_rcp("%Sr%",L,"%base_year%",G);
$if %UrbanLandData%==SSP Y_base("SL",G)$(SSP_frac("SL","2010","%Sr%",G))= SSP_frac("SL","2010","%Sr%",G);
$if not %UrbanLandData%==SSP Y_base("SL",G)=frac_rcp("%Sr%","SL","%base_year%",G);
Y_base(L,G)$(LPRMSEC(L))=frac_rcp("%Sr%","PRM_SEC","%base_year%",G) + frac_rcp("%Sr%","PAS","%base_year%",G);
Y_base(L,G)$(LCROPIR(L))=sum(LDM$MAP_LLDM(L,LDM),crop_basemap(LDM,G)*Pirri(LDM,G));
Y_base(L,G)$(LCROPRF(L))=sum(LDM$MAP_LLDM(L,LDM),crop_basemap(LDM,G)*(1-Pirri(LDM,G)));
Y_base("CROP_FLW",G)$(frac_rcp("%Sr%","CL","%base_year%",G)-SUM(L$LCROP(L),Y_base(L,G))>0)=frac_rcp("%Sr%","CL","%base_year%",G)-SUM(L$LCROP(L),Y_base(L,G));
*Y_base("CROP_FLW",G)$(Y_base("CROP_FLW",G)<0)=0;
Y_base("OL",G)$(Y_base("OL",G)>1-Y_base("CL",G)-Y_base("PAS",G)-Y_base("SL",G) AND 1-Y_base("CL",G)-Y_base("PAS",G)-Y_base("SL",G)>=0)=1-Y_base("CL",G)-Y_base("PAS",G)-Y_base("SL",G);
Y_base("OL",G)$(Y_base("OL",G)>1-Y_base("CL",G)-Y_base("PAS",G)-Y_base("SL",G) AND 1-Y_base("CL",G)-Y_base("PAS",G)-Y_base("SL",G)<0)=0;

*--- Y_pre
  Y_pre(L,G)$(Y_base(L,G))=Y_base(L,G);
  Y_pre(L,G)$SUM(L2$MAP_Lagg(L2,L),Y_pre(L2,G))=SUM(L2$MAP_Lagg(L2,L),Y_pre(L2,G));
  VZ_load(L,G)=0;
  PLDM_load(LDM)=0;
  PCDM_load(L)=0;
$else.baseyear
$ifthen.fileex exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%pre_year%.gdx'
$	gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%pre_year%.gdx'
$	load VY_load=VYL VZ_load=VZL
$	load PLDM_load=PLDM PCDM_load=PCDM

$else.fileex
  VY_load(L,G)=0;
$endif.fileex

*Y_pre(L,G)$(VY_load(L,G))=VY_load(L,G);
Y_pre(L,G)$(VY_load(L,G) and not sameas(L,"SL"))=VY_load(L,G);

*---load SL data for every year excl. base yr
Y_pre("SL",G)$(SSP_frac("SL","%Sy%","%Sr%",G))= SSP_frac("SL","%Sy%","%Sr%",G);

*---adjust exogenous variables to satisfy constraint
Y_pre("OL",G)$(Y_pre("OL",G)>1-Y_pre("SL",G))=1-Y_pre("SL",G);

$ifthen.bio %biocurve%==on
$ifthen.fileex exist '%../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%pre_year%.gdx'
$       gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%pre_year%.gdx'
$       load YBIO_load=YBIO
$else.fileex
    YBIO_load(G)=0;
$endif.fileex
  Y_pre("BIO",G)$(YBIO_load(G))=YBIO_load(G);
$endif.bio
$endif.baseyear

*-----Protected area-----*
protect_area(protect_cat,L)=0;
$ifthene.prtec %Sy%<%protectStartYear%
  protectfrac(G)=0;
$elseife.prtec %Sy%==%protectStartYear%
$ if not %WDPAprotect%==off $gdxin '../%prog_loc%/data/policydata.gdx'
$ if not %WDPAprotect%==off $load protectland=%WDPAprotect%
$ if %WDPAprotect%==off protectland(G)=0;

$ if not %degradedlandprotect%==off $gdxin '../%prog_loc%/data/policydata.gdx'
$ if not %degradedlandprotect%==off $load degradedland=%degradedlandprotect%
$ if %degradedlandprotect%==off degradedland(G)=0;
  protectfrac(G)=protectland(G)+degradedland(G);
  protectfrac(G)$(protectfrac(G)>Y_pre("PRM_SEC",G) or (popdens(G)<0.1))=Y_pre("PRM_SEC",G);

* protect data aggregation in NoCC
  protect_area("WDPA_KBA_Wu2019","TOT")=SUM(G,GA(G)*protectfrac(G));

$else.prtec
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%protectStartYear%.gdx'
$load protectfrac
$endif.prtec
*---minimize protected fraction to satify constraint
  protectfrac(G)$(protectfrac(G))=min(protectfrac(G),1-Y_pre("SL",G)-Y_pre("OL",G));

*-----Protected forest area-----*
$gdxin '../%prog_loc%/data/fra_data.gdx'
$load FRA_load=FRA
frsprotectarea=0;

$ifthen not %Sy%==%base_year%
$ if %frsprotectexpand%==off frsprotectarea=FRA_load("%Sr%","2010","Conservation of biodiversity");
$ if %frsprotectexpand%==on frsprotectarea=FRA_load("%Sr%","2010","Conservation of biodiversity")*(1+0.5*(%Sy%-2010)/(2100-2010));
$endif

*-----Ohashi's protected area-----*
$ifthen not %ohashiprotect%==off
$gdxin '../%prog_loc%/data/ohashiset.gdx'
$if %Sr%==XER $load ohashi = ohashi75
$if not %Sr%==XER $load ohashi = %ohashiprotect%
REVG(G)$ohashi("%Sr%", G)=no;
$endif

*-----Protected area for Bending The Curve-----*
$ifthen.biodiv %biodivcons%==off
  protectfracL(G,L)=0;
  protectfrac(G)=0;
$else.biodiv
$ ifthene.year %Sy%<%protectStartYear%
    protectfracL(G,L)=0;
$ elseife.year %Sy%==%protectStartYear%
$gdxin '../%prog_loc%/individual/BendingTheCurve/LC_cons_AIM_omit0_v3.gdx'
$load protectfracIJL=LC_cons_AIM_v3
  protectfracL(G,L)$(SUM((I,J)$MAP_GIJ(G,I,J),SUM(L_LC$(map_L_LC(L_LC,L)),protectfracIJL(I,J,"%biodivdata%",L_LC))))= SUM((I,J)$MAP_GIJ(G,I,J),SUM(L_LC$(map_L_LC(L_LC,L)),protectfracIJL(I,J,"%biodivdata%",L_LC)));
  protectfracL(G,L2)$(protectfracL(G,L2) and protectfracL(G,L2)>sum(L$MAP_Lagg(L,L2),Y_pre(L,G)))=sum(L$MAP_Lagg(L,L2),Y_pre(L,G));

* protect data aggregation in NoCC
  protect_area("WildArea_KBA_WDPA_BTC",L)=SUM(G,GA(G)*protectfracL(G,L));
  protect_area("WildArea_KBA_WDPA_BTC","TOT")=sum(L,protect_area("WildArea_KBA_WDPA_BTC",L));
$ else.year
*---minimize protected fraction to satify constraint
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%protectStartYear%.gdx'
$load protectfracL
$ endif.year
    protectfracL(G,"PRM_SEC")$(protectfracL(G,"PRM_SEC") and max(protectfrac(G),protectfracL(G,"PRM_SEC"))+protectfracL(G,"CL")+Y_pre("SL",G)+Y_pre("OL",G)>1)=max(0,1-Y_pre("SL",G)-Y_pre("OL",G)-protectfracL(G,"CL"));
    protectfracL(G,"CL")$(protectfracL(G,"CL") and max(protectfrac(G),protectfracL(G,"PRM_SEC"))+protectfracL(G,"CL")+Y_pre("SL",G)+Y_pre("OL",G)>1)=max(0,1-Y_pre("SL",G)-Y_pre("OL",G)-protectfracL(G,"PRM_SEC"));
    protectfrac(G)$(protectfrac(G) and max(protectfrac(G),protectfracL(G,"PRM_SEC"))+protectfracL(G,"CL")+Y_pre("SL",G)+Y_pre("OL",G)>1)=max(0,1-Y_pre("SL",G)-Y_pre("OL",G)-protectfracL(G,"CL"));

$endif.biodiv
$if %IAV%==NoCC protectfracL(G,L)=0;

*----Carbon flow
$gdxin '../%prog_loc%/data/fao_data.gdx'
$load TON_C Pprod

$gdxin '../%prog_loc%/data/visit_forest_growth_function.gdx'
$load ACF_vst=ACFout MACF_vst=MACFout CFT_vst=CFTout

$ifthen.afftype %afftype%==cact_vst
  ACF(G)=ACF_vst("AFR00","%Sr%",G);
  MACF=MACF_vst("AFR00","%Sr%");
  CFT(G,Y,Y2)=CFT_vst("AFR00","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==cdiv_vst
  ACF(G)=ACF_vst("AFRDIV","%Sr%",G);
  MACF=MACF_vst("AFRDIV","%Sr%");
  CFT(G,Y,Y2)=CFT_vst("AFRDIV","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==cmax_vst
  ACF(G)=ACF_vst("AFRMAX","%Sr%",G);
  MACF=MACF_vst("AFRMAX","%Sr%");
  CFT(G,Y,Y2)=CFT_vst("AFRMAX","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==ccur_vst
  ACF(G)=ACF_vst("AFRCUR","%Sr%",G);
  MACF=MACF_vst("AFRCUR","%Sr%");
  CFT(G,Y,Y2)=CFT_vst("AFRCUR","%Sr%",G,Y,Y2);
$elseif.afftype %afftype%==cprevisit
$gdxin '../%prog_loc%/data/biomass/output/biomass%Sr%.gdx'
$load ACF_vst0=ACF MACF_vst0=MACF
$load CFT_vst0=CFT

  ACF(G)=ACF_vst0(G);
  MACF=MACF_vst0;
  CFT(G,Y,Y2)=CFT_vst0(G,Y,Y2);
$else.afftype
$gdxin '../%prog_loc%/data/biomass/output/biomass%Sr%_aez.gdx'
$load ACF_aez=ACF MACF_aez=MACF
$load CFT_aez=CFT

  ACF(G)=ACF_aez(G);
  MACF=MACF_aez;
  CFT(G,Y,Y2)=CFT_aez(G,Y,Y2);
$endif.afftype

*---- Management factor for Biocrop yield ---*
$ifthen.baseyear %Sy%==%base_year%
  GDPCAP_base$Ppopulation("%base_year%","%Sr%")=GDP_load("%base_year%","%Sr%")/Ppopulation("%base_year%","%Sr%");
  MFA$(GDPCAP_base>=1)=1;
  MFA$(GDPCAP_base>0.35 AND GDPCAP_base<1)=0.6;
  MFA$(GDPCAP_base>0 AND GDPCAP_base<=0.35)=0.4;
  MFB$(GDPCAP_base>0.35)=1.005;
  MFB$(GDPCAP_base>0 AND GDPCAP_base<=0.35)=1.01;
$else.baseyear
$gdxin '../output/gdx/base/%Sr%/basedata.gdx'
$load MFA MFB
$endif.baseyear

*-------Productivity (YIELD) data ----------*
$ifthen.baseyear %Sy%==%base_year%
*$gdxin '%prog_loc%/data/yield_map_gaez.gdx'
*$load YIELD_gaez=crop_yieldmap_gaez
$gdxin '../%prog_loc%/data/isimipagr.gdx'
$load Pisimip

$gdxin '../%prog_loc%/data/visit_data.gdx'
$load PVISIT

  PVISIT(CVST,G)$(PVISIT(CVST,G)<10**(-2) AND (NOT sameas(CVST,"co2flux")))=0;

$ gdxin '../%prog_loc%/data/analysis_agr.gdx'
$ load YIELD_cge=YIELD

$gdxin '../%prog_loc%/data/H08_yield_num_gdx.gdx'
$load yield_miscanthus_rainfed_num
$load yield_swichgrass_rainfed_num

  YIELDBIO_H08(G)=SUM((I,J)$(MAP_GIJ(G,I,J) AND yield_miscanthus_rainfed_num(I,J)+yield_swichgrass_rainfed_num(I,J)),yield_miscanthus_rainfed_num(I,J)+yield_swichgrass_rainfed_num(I,J))/2/1000;
  TON_C(R,"C4natural")= 1/C_DW/DW_TON;

*YIELD(L,G)$(LCGAEZ(L) AND YIELD_gaez(L,G))=YIELD_gaez(L,G);
  YIELD(L,G)$(LCisimip(L) AND Pisimip(L,G))=Pisimip(L,G);

* MgC/ha/year] --> [tonne/ha/year]
*YIELD(L,G)$(LCVST(L) AND LCTON(L)) = SUM(CVST$Map_LCVST(L,CVST),PVISIT(CVST,G) * TON_C("%Sr%",CVST));
* MgC/ha/year]
*YIELD(L,G)$(LCVST(L) AND LCC(L))   = SUM(CVST$Map_LCVST(L,CVST),PVISIT(CVST,G));
* [tonne/ha/year] --> MgC/ha/year]
  YIELD("BIO",G)$(YIELDBIO_H08(G))=YIELDBIO_H08(G) * C_TON;
  YIELD("CROP_FLW",G)$SUM(L$(LCROPA(L) AND YIELD(L,G)),1)= SUM(L$(LCROPA(L) AND YIELD(L,G)),YIELD(L,G))/SUM(L$(LCROPA(L) AND YIELD(L,G)),1);
  YIELD("OTH_ARF",G)$(YIELD("OTH_ARF",G)=0 AND SUM(L$(LCROPRF(L) AND YIELD(L,G)),1))= SUM(L$(LCROPRF(L) AND YIELD(L,G)),YIELD(L,G))/SUM(L$(LCROPRF(L) AND YIELD(L,G)),1);
  YIELD("OTH_AIR",G)$(YIELD("OTH_AIR",G)=0 AND SUM(L$(LCROPIR(L) AND YIELD(L,G)),1))= SUM(L$(LCROPIR(L) AND YIELD(L,G)),YIELD(L,G))/SUM(L$(LCROPIR(L) AND YIELD(L,G)),1);

*--- Adjustment of productivity (crop yield) to CGE estimates ---*
  YIELD_AVE(LDM)$(LDMCROPA(LDM) AND SUM(L$MAP_LLDM(L,LDM),SUM(G,GA(G)*Y_base(L,G))))= SUM(L$MAP_LLDM(L,LDM),SUM(G,GA(G)*Y_base(L,G)*YIELD(L,G))) / SUM(L$MAP_LLDM(L,LDM),SUM(G,GA(G)*Y_base(L,G)));
  SF_YIELD(LDM)$(LDMCROPA(LDM) AND YIELD_AVE(LDM))=YIELD_cge("%base_year%","%Sr%",LDM)/YIELD_AVE(LDM);
  YIELD(L,G)$(LCROPA(L) AND SUM(LDM$MAP_LLDM(L,LDM),SF_YIELD(LDM)) )=YIELD(L,G)*SUM(LDM$MAP_LLDM(L,LDM),SF_YIELD(LDM));
  YIELD(LAFR,G)$ACF(G)=ACF(G);
  YIELD(L,G)$(LBIO(L) AND YIELD(L,G))=YIELD(L,G)*MFA;
$else.baseyear
$gdxin '../output/gdx/base/%Sr%/basedata.gdx'
$load YIELD
$endif.baseyear

*---- Management factor for Biocrop yield ---*
MF=min(1.3/MFA,MFB**max(0,%Sy%-2010));
YIELD(L,G)$(LBIO(L) AND YIELD(L,G))=YIELD(L,G)*MF;

*-----Carbon stock ---*
$ifthen.baseyear %Sy%==%base_year%
$ gdxin '../%prog_loc%/data/biomass/output/biomass%Sr%.gdx'
$ load CS
CSB=0;
$else.baseyear
$ gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%pre_year%.gdx'
$ load CS
$ gdxin '../output/gdx/base/%Sr%/analysis/%base_year%.gdx'
$ load CSB
$endif.baseyear
*----------------------*



*----- Biodiversity price ---*
PBIODIV(L,G)=0;

$if %Sy%==%base_year% $include ../%prog_loc%/inc_prog/BiodiversityPrice.gms

$ifthen.pbiodiv  %biodivprice%==on
$ ifthen.year %Sy%==%base_year%
  PBIODIV(L,G)=0;
$ else.year
$ gdxin '../output/gdx/base/%Sr%/basedata.gdx'
$ load BIIcoefG,RR,PBIODIVY0

  PBIODIV(L,G)=PBIODIVY0("%Sy%")*RR(G)*BIIcoefG(L,G)/10**6;
$ endif.year
$else.pbiodiv
  PBIODIV(L,G)=0;
$endif.pbiodiv

PBIODIV(L,G)=PBIODIV(L,G)*0.3;

*-------Benefit from afforestation
PBR=PB_WLD*(GDPCAP/GDPCAP_WLD)**0.5;
PB(G)$MACF=PBR*ACF(G)/MACF;

*-------- Land demand
PlanduseT=SUM(LCGE,Planduse("%Sy%",LCGE));
SF_planduse$PlanduseT=GAT/PlanduseT;
*Planduse("%Sy%",LCGE)$(PlanduseT>GAT)=Planduse("%Sy%",LCGE)*SF_planduse;

PCDM0(Y,L)=0;

* [1000ha]
PLDM0(Y,LDM)$(LDMCROPB(LDM))=SUM(A$MAP_LDMA(LDM,A), Pland("%Sy%",A));
PLDM0(Y,"AFR")$(Planduse(Y,"PRM_FRS")-Planduse("2020","PRM_FRS")>0 AND ordy(Y)>=2020)=Planduse(Y,"PRM_FRS")-Planduse("2020","PRM_FRS");

*[tonne carbon]
PCDM(L)$(PCDM0("%Sy%",L))=PCDM0("%Sy%",L);
PLDM(LDM)$(PLDM0("%Sy%",LDM)>0.01)=PLDM0("%Sy%",LDM);
PLDM("SL")=SUM(G,GA(G)*Y_pre("SL",G));
PLDM("OL")=SUM(G,GA(G)*Y_pre("OL",G));

FLAGDM(L)$(SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)) OR PCDM(L))=1;

* mil.$/ton or mil.$/tonC
pr_price_base0(LDM)$(LDMCTON(LDM) AND Pprod("%base_year%","%Sr%",LDM,"TON")) =  SUM(A$MAP_LDMA(LDM,A),OUTPUTALL_Nominal("%base_year%",A)) / Pprod("%base_year%","%Sr%",LDM,"TON");
pr_price_base0(LDM)$(LDMCC(LDM) AND Pprod("%base_year%","%Sr%",LDM,"C")) =  SUM(A$MAP_LDMA(LDM,A),OUTPUTALL_Nominal("%base_year%",A)) / Pprod("%base_year%","%Sr%",LDM,"C");

pr_price_base(L)$(FLAGDM(L))=SUM(LDM$MAP_LLDM(L,LDM),pr_price_base0(LDM));
pr_price_base("CROP_FLW")$SUM(LDM$LDMCROP(LDM),Pprod("%base_year%","%Sr%",LDM,"TON")) =  SUM(A$(ACROP(A)),OUTPUTALL_Nominal("%base_year%",A)) / SUM(LDM$LDMCROP(LDM),Pprod("%base_year%","%Sr%",LDM,"TON"));

pr_pricey(Y,L)$(FLAGDM(L) AND SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),OUTPUTAC(Y,A,C)))) =
  SUM(A$MAP_LA(L,A),OUTPUTALL_Nominal(Y,A)) / SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),OUTPUTAC(Y,A,C)));
pr_pricey(Y,"CROP_FLW")$SUM(A$ACROP(A),SUM(C$CCROP(C),OUTPUTAC(Y,A,C))) =
  SUM(A$ACROP(A),OUTPUTALL_Nominal(Y,A)) / SUM(A$ACROP(A),SUM(C$CCROP(C),OUTPUTAC(Y,A,C)));
pr_price_indx(L)$pr_pricey("%base_year%",L)=pr_pricey("%Sy%",L)/pr_pricey("%base_year%",L);

* mil.$/ton or mil.$/tonC
*Be careful to deal with Biomass sector name has been changed.
pr_price(L)=pr_price_base(L) * pr_price_indx(L);
pr_price("BIO")$(OUTPUTALL_Nominal("%Sy%","ECR") AND OUTPUTAC("%Sy%","ECR","COM_ECR")) =
  OUTPUTALL_Nominal("%Sy%","ECR") / (OUTPUTAC("%Sy%","ECR","COM_ECR")*10**3) * 0.38 * C_TON;

* mil.$/ha/year = mil.$/ton * ton/(ha*year)
pr(L,G)$(FLAGDM(L))= pr_price(L) * YIELD(L,G);
pr("AFR",G)$(PB(G))= PB(G) + PGHG("%Sy%") * SUM(Y$(ordy("%Sy%")<=ordy(Y) and ordy(Y)<=ordy(Y)+YPP),CFT(G,Y,"%Sy%")/((1+DR)**(ordy(Y)-ordy("%Sy%")))) / YPP;

* [mil. $]
pc_input(L)$(SUM(A$MAP_LA(L,A),1))=SUM(A$MAP_LA(L,A),OUTPUTALL_Nominal("%Sy%",A));
pc_input("CROP_FLW")=SUM(A$(ACROP(A)),OUTPUTALL_Nominal("%Sy%",A));
* use 2020 value for after 2020 not to reflect yield improve to bioenergy potential
pc_input("BIO")=0.5*SUM(A$(sameas(A,"GRO")),OUTPUTALL_Nominal("2020",A));

* [10^3ha --> ha]
pc_area(L)$(SUM(A$MAP_LA(L,A),1))=SUM(A$MAP_LA(L,A),Pland("%Sy%",A)) * 10**3;
pc_area("CROP_FLW")=SUM(A$(ACROP(A)),Pland("%Sy%",A)) * 10**3;
* use 2020 value for after 2020 not to reflect yield improve to bioenergy potential
pc_area("BIO")=SUM(A$(sameas(A,"GRO")),Pland("2020",A)) * 10**3;


* [mil.$/ha/year]
pc(L)$(pc_area(L))=pc_input(L)/pc_area(L);
ps(L,G)$(YIELD(L,G))=pr(L,G)-pc(L);
LOBJ(L)$(FLAGDM(L) AND  sum(G,ps(L,G)))=YES;

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
ps("PAS",G)=0;
LOBJ("PAS")=0;
PLDM("PAS")=0;

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
$ifthen.ba %baseadjust%==on
$if %Sy%==%base_year% $include ../%prog_loc%/inc_prog/baseadjust.gms
$endif.ba
*$exit
*------- Land conversion cost ----------*
wage=GDPCAP/(365-100)/100;
pldc_WLD=0.866-0.254;
pldc=pldc_WLD*(GDPCAP/GDPCAP_WLD)**0.5;
irricost=irricost_WLD*(GDPCAP/GDPCAP_WLD)**0.5;

$ifthen %Sy%==%base_year%
$gdxin '../%prog_loc%/data/roads.gdx'
$load ruralroadlength
  roaddens=ruralroadlength("%Sr%")/SUM(LDM$LDMCROP(LDM),PLDM(LDM))/1000;
$gdxin '../%prog_loc%/data/data_prep.gdx'
$load GL=GL%Sr%

* ��苗���ȏ㗣�ꂽ�G���A�ɂ͍ő�l������
  GLMAX=smax((G,G2)$GL(G,G2),GL(G,G2));
  GL(G,G2)$(GL(G,G2)=0 AND (NOT sameas(G,G2)))=GLMAX;
  GLMIN0(L,G)$(LAFR(L) AND NOT Y_base("HAV_FRS",G))=smin(G2$(Y_base("HAV_FRS",G2)),GL(G,G2));
  GLMIN0(L,G)$(LCROPA(L) AND (NOT SUM(L2$LCROPA(L2),Y_pre(L2,G))))=smin(G2$(SUM(L2$LCROPA(L2),Y_pre(L2,G2))),GL(G,G2));
*psmax(L)=smax(G,ps(L,G)-pldc*roaddens);
  psmax(L)$(LOBJ(L))=smax(G$ps(L,G),ps(L,G));
  psmin(L)$(LOBJ(L)AND sum(G$(Y_base(L,G)),1))=smin(G$(Y_base(L,G) AND ps(L,G)),ps(L,G));
  plcc(L)=psmax(L)-psmin(L);
$else
$gdxin '../output/gdx/base/%Sr%/basedata.gdx'
$load plcc
$load roaddens
$load GL
$load GLMIN0

*GL(G,G2)=GL_load(G,G2);
$endif

*GLMIN(L,G)$((NOT LCROPA(L)) AND (NOT LAFR(L)))=smin(G2$(Y_pre(L,G2)),GL(G,G2));
GLMIN(L,G)$(LAFR(L) OR (LCROPA(L) AND (NOT LBIO(L))))=GLMIN0(L,G);
GLMIN(L,G)$(LBIO(L) AND (NOT SUM(L2$LCROPA(L2),Y_pre(L2,G))))=smin(G2$(SUM(L2$LCROPA(L2),Y_pre(L2,G2)) and GL(G,G2)),GL(G,G2));
*GLMIN(L,G)$(LAFR(L) AND (NOT Y_base("HAV_FRS",G)))=smin(G2$(Y_base("HAV_FRS",G2)),GL(G,G2));
GLMINHA(L,G)$((LAFR(L) OR LCROPA(L)) AND GA(G)) = GLMIN(L,G)/(GA(G)*1000);

pannual_lab =(DR*(1+DR)**YPP_lab) /((1+DR)**YPP_lab-1);
pannual_road=(DR*(1+DR)**YPP_road)/((1+DR)**YPP_road-1);
pannual_irri=(DR*(1+DR)**YPP_irri)/((1+DR)**YPP_irri-1);
pannual_emit=(DR*(1+DR)**YPP_emit)/((1+DR)**YPP_emit-1);
pannual_biodiv=(DR*(1+DR)**YPP_biodiv)/((1+DR)**YPP_biodiv-1);

pa_lab(G)$(popdens(G)) = wage * labor * pannual_lab * (1+popdens(G))**(-0.005);
pa_road(L,G)$(NOT LPRMSEC(L)) =  (plcc(L)*100 + pldc*(roaddens + GLMINHA(L,G))) * pannual_road;
pa_irri(L)$(LCROPIR(L)) = irricost * pannual_irri;
pa_emit(G)$(CS(G)) =  PGHG("%Sy%") * CS(G) * pannual_emit;
pa_biodiv(G,L)$(PBIODIV(L,G)) =  PBIODIV(L,G) * pannual_biodiv;

pa(L,G)$(LOBJ(L) OR LBIO(L))= pa_lab(G) + pa_road(L,G)  + pa_irri(L) + pa_emit(G)$(NOT LPRMSEC(L)) + pa_biodiv(G,L);
pa_bio(G)$pa("BIO",G)=pa("BIO",G);
YPNMAXCL=0.01;

$if %parallel%==off execute_unload '../output/temp1.gdx';

*------- Initial data ----------*
FPRM$(%Sy%>%base_year%)=1;
FAFR$(%Sy%>%base_year% AND PCDM("AFR")>=PCDM_load("AFR"))=1;
*-*-*-*-*
FAFR=0;
*-*-*-*-*
*FAFR$(PLDM("AFR")<PLDM_load("AFR"))=0;

VRSPRM.L(L,G)$(FLAGDM(L) AND LPRMSEC(L) AND FPRM AND Y_pre(L,G) AND ps(L,G))=0.01;
VRSAFR.L(L,G)$(FLAGDM(L) AND LAFR(L) AND FAFR AND Y_pre(L,G) AND ps(L,G))=0.01;
VY.L(L,G)$(Y_pre(L,G))=Y_pre(L,G);
VZ.L(L,G)$(VZ_load(L,G))=VZ_load(L,G);
VY.L(L,G)$(Y_pre(L,G)<10**(-5))=0;
VZ.L(L,G)$(VZ_load(L,G)<10**(-5))=0;
VOBJ.L=0;

VY.LO(L,G)=0;
VYP.LO(L,G)=0;
VYN.LO(L,G)=0;
*VY.LO("AFR",G)$(Y_pre("AFR",G) AND CS(G)<CSB)=Y_pre("AFR",G);

VRSPRM.FX(L,G)$(FLAGDM(L) AND (NOT LPRMSEC(L)))=0;
VRSPRM.FX(L,G)$(FLAGDM(L) AND LPRMSEC(L) AND (NOT Y_pre(L,G)))=0;
VRSAFR.FX(L,G)$(FLAGDM(L) AND (NOT LAFR(L)))=0;
VRSAFR.FX(L,G)$(FLAGDM(L) AND LAFR(L) AND (NOT Y_pre(L,G)))=0;
VY.FX(L,G)$((NOT LPRMSEC(L)) AND ((NOT FLAGDM(L)) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;
VZ.FX(L,G)$((NOT LPRMSEC(L)) AND ((NOT FLAGDM(L)) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;
VYP.FX(L,G)$((NOT LPRMSEC(L)) AND ((SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)-PLDM_load(LDM))=0 AND PCDM(L)-PCDM_load(L)=0) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;
VYN.FX(L,G)$((NOT LPRMSEC(L)) AND ((SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)-PLDM_load(LDM))=0 AND PCDM(L)-PCDM_load(L)=0) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;
VY.FX("SL",G)$(Y_pre("SL",G))=Y_pre("SL",G);
VY.FX("OL",G)$(Y_pre("OL",G))=Y_pre("OL",G);

$ifthen %Sr%==CAN
  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2050 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2050))=0;
$elseif %Sr%==USA
$if %CLP%==20W  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2030 AND %Sy%<2060 AND CS(G)>=CSB*5)=0;
$if %CLP%==20Wp VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2030 AND %Sy%<2060 AND CS(G)>=CSB*5)=0;
$if %CLP%==20W  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.2**(%Sy%-2060))=0;
$if %CLP%==20Wp VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.2**(%Sy%-2060))=0;
$if %CLP%==600C_CACNup200  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%=2030 AND %Sy%<2060 AND CS(G)>=CSB*5)=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%=2030 AND %Sy%<2060 AND CS(G)>=CSB*5)=0;
$if %CLP%==600C_CACNup200  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*50*1.05**(%Sy%-2060))=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*50*1.05**(%Sy%-2060))=0;
*$if %CLP%==800Cf_CACNup200 VY.UP("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060)=+INF;
$elseif %Sr%==XER
$if %CLP%_%IAV%==20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2070 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2070))=0;
$if %CLP%==600C_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2070 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2070))=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2070 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2070))=0;
$elseif %Sr%==XOC
$if %CLP%_%IAV%==20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2060))=0;
$if %CLP%_%IAV%==20Wp_NoCC Planduse("%Sy%","GRAZING")$(%Sy%=2100)=Planduse("%Sy%","GRAZING")*0.99;
$if %CLP%==600C_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2060))=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2060))=0;
*$if %CLP%==800Cf_CACNup200 VY.UP("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060)=+INF;
$elseif %Sr%==XE25
$if %CLP%==20W  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2090))=0;
$if %SCE%_%CLP%_%IAV%==SSP1pTECHTRADE_20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2090))=0;
$if %SCE%_%CLP%_%IAV%==SSP1p_20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2090))=0;
$if %CLP%==600C_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*10*1.02**(%Sy%-2090))=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*10*1.02**(%Sy%-2090))=0;
$elseif %Sr%==BRA
$if %CLP%==600C_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2060))=0;
$if %CLP%==600C_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*3)=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2060))=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*3)=0;
$elseif %Sr%==JPN
$if %CLP%==600C_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*20*1.02**(%Sy%-2090))=0;
$if %CLP%==800Cf_CACNup200 VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*20*1.02**(%Sy%-2090))=0;
$else
  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND CS(G)>=CSB)=0;
$endif

F_PLDM(L,G)$(LAFR(L) AND (SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)-PLDM_load(LDM))=0) AND Y_pre(L,G))=1;

*------- Solve ----------*
option reslim=10000;
option solprint=off;
option sysout=off;
option limrow=2000;
option limcol=0;
option profile=0;
option threads=%CPLEXThreadOp%;

$if %parallel%==on option SOLPRINT=ON;
LandUseModel_LP.HOLDFIXED   = 1 ;

SCALAR
	ite_his  Iteration history /1/
	maxite  Maximum solution iteration /10/
	IteCounter/0/
;

$ifthen.mcp %mcp%==on
	Solve LandUseModel_MCP USING MCP;
        Psol_stat("SSOLVE","MCP")=LandUseModel_MCP.SOLVESTAT;Psol_stat("SMODEL","MCP")=LandUseModel_MCP.MODELSTAT;
$else.mcp
	Solve LandUseModel_LP USING LP maximizing VOBJ;
        Psol_stat("SSOLVE","SLP")=LandUseModel_LP.SOLVESTAT;Psol_stat("SMODEL","SLP")=LandUseModel_LP.MODELSTAT;Psol_stat("ITE_HIS","SLP")=ite_his;
$endif.mcp

*-*-*-*-*
*-*-*-*-*
*YPNMAXCL=0.10;
*FOR(ite_his=11 to maxite,
*-*-*-*-*
*-*-*-*-*

FOR(ite_his=2 to maxite,
IF((NOT (Psol_stat("SMODEL","SLP")=1 AND Psol_stat("SSOLVE","SLP")=1)),
        YPNMAXCL=min(1,YPNMAXCL+0.1);
	Solve LandUseModel_LP USING LP maximizing VOBJ;
        Psol_stat("SSOLVE","SLP")=LandUseModel_LP.SOLVESTAT;Psol_stat("SMODEL","SLP")=LandUseModel_LP.MODELSTAT;Psol_stat("ITE_HIS","SLP")=ite_his;Psol_stat("YPNMAXCL","SLP")=YPNMAXCL;
));

VYL(L,G)$(VY.L(L,G))=VY.L(L,G);
VZL(L,G)$(VZ.L(L,G))=VZ.L(L,G);
VYPL(L,G)$(VY.L(L,G))=VYP.L(L,G);
VYL(L,G)$SUM(L2$MAP_Lagg(L2,L),VYL(L2,G))=SUM(L2$MAP_Lagg(L2,L),VYL(L2,G));
frsprotect_check$(frsprotectarea)=SUM(G$(CS(G)>CSB),VY.L("PRM_SEC",G)*GA(G));

*-------- Pasture --------*
*-----Protected area-----*
$ifthen %Sy%==%base_year%
  protect_wopas(G)=0;
$elseif %Sy%==%second_year%
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%base_year%.gdx'
$load VY_baseresults=VYL
  protect_wopas(G)=0;
* protect_wopas(G)$protectfrac(G)=protectfrac(G);
* protect_wopas(G)$(protectfrac(G)>VY_baseresults("FRSGL",G) AND VY_baseresults("FRSGL",G)>0)=VY_baseresults("FRSGL",G);
  protect_wopas(G)$max(protectfracL(G,"PRM_SEC"),protectfrac(G))=max(protectfracL(G,"PRM_SEC"),protectfrac(G));
  protect_wopas(G)$(max(protectfracL(G,"PRM_SEC"),protectfrac(G))>VY_baseresults("FRSGL",G) AND VY_baseresults("FRSGL",G)>0)=VY_baseresults("FRSGL",G);
$else
*$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%second_year%.gdx'
*$load protect_wopas
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%base_year%.gdx'
$load VY_baseresults=VYL

  protect_wopas(G)=0;
  protect_wopas(G)$max(protectfracL(G,"PRM_SEC"),protectfrac(G))=max(protectfracL(G,"PRM_SEC"),protectfrac(G));
  protect_wopas(G)$(max(protectfracL(G,"PRM_SEC"),protectfrac(G))>VY_baseresults("FRSGL",G) AND VY_baseresults("FRSGL",G)>0)=VY_baseresults("FRSGL",G);
$endif


*------ Pasture -----------*
$include ../%prog_loc%/inc_prog/pasture.gms
*------ Crop fallow -----------*
$include ../%prog_loc%/inc_prog/crop_fallow.gms

*------ Digit adjustment -----------*

*VYL(L,G)=round(VYL(L,G),6);

$ontext
*------- Bioenergy potential curve -----*
set
LB              New or old bioenergy cropland   /BION,BIOO/;
parameter
BIOENE(G)       Bioenergy potential in cell G in year Y [GJ per ha per year]
RAREA_BIOP(G)   Ratio of potential area of biocrop in cell G in year Y [-]
GJ_toe  /41.8/
Rbg             Ratio of below-ground residues to above-ground biomass (IPCC guideline Table11.2) /0.20/
PBIO(G,LB)      Price
pc_bio(G,LB)    Cost for bioenergy production including land conversion cost (million $ per ha per year)
;

*** CLOP_FLW --> BIO

* [GJ/ha/year] = [tonC/ha] * [tonCrop/tonC]  * [toe/tonCrop] * [GJ/toe]
BIOENE(G)$(YIELD("BIO",G)) = YIELD("BIO",G) * 1/(1+Rbg) * 2.5 * 0.38 * GJ_toe;

RAREA_BIOP(G) = 1-(SUM(L$(LCROP(L) OR LPAS(L)),VYL(L,G)) + VYL("CROP_FLW",G) + protect_wopas(G) + VYL("SL",G)+VYL("OL",G));
RAREA_BIOP(G)$(RAREA_BIOP(G)<10**(-5))=0;

*[mil$/ha/year]
pc_bio(G,"BIOO")$(BIOENE(G) AND RAREA_BIOP(G))=pc("BIO");
pc_bio(G,"BION")$(BIOENE(G) AND RAREA_BIOP(G))=pc("BIO")+pa("BIO",G);

* [$/GJ] = [mil$/ha/year] / [GJ/ha/year] * 10**6
PBIO(G,LB)$(BIOENE(G) AND RAREA_BIOP(G))=pc_bio(G,LB)/BIOENE(G)*(10**6);
$offtext

$ontext
* [EJ/grid/year] = [GJ/ha/year] * [kha/grid]
PBIO(G,"quantity")$(BIOENE(G))=BIOENE(G) * RAREA_BIOP(G) * GA(G) / 10**6;

* [grid-1]
PBIO(G,"fraction")$(BIOENE(G)) = RAREA_BIOP(G);

* [kha/grid]
PBIO(G,"area")$(BIOENE(G)) = GA(G) * RAREA_BIOP(G);

* [$/GJ] = [mil$/ha/year] / [GJ/ha/year] * 10**6
PBIO(G,"price")$(BIOENE(G) AND RAREA_BIOP(G))=pc_bio(G)/BIOENE(G)*(10**6);

*[MgC/ha/year]
PBIO(G,"yield")$(BIOENE(G) AND RAREA_BIOP(G))=YIELD("BIO",G);
$offtext


*--------Land use change -------*
$ifthen not %Sy%==%base_year%
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%pre_year%.gdx'
$load VYLY
$endif
VYLY("%Sy%",L,G)$(VYL(L,G))=VYL(L,G);
delta_VY(Y,L,G)$(ordy(Y)>=ordy("%base_year%")+Ystep AND ordy(Y)<=ordy("%Sy%") AND VYLY(Y,L,G))=(VYLY(Y,L,G)-VYLY(Y-Ystep,L,G));
delta_VY(Y,L,G)$(abs(delta_VY(Y,L,G))<10**(-5))=0;

*--------GHG emissions --------*
set
Stc       Year category         / G20, LE20 /
;
parameter
LEC(R,Stc) Carbon sequestration coefficient of natural forest grater or less than 20 years  (tonneCO2 per ha per year)
LEC0(Stc)      Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
;
$gdxin '../%prog_loc%/data/data_prep2.gdx'
$load LEC

LEC0(Stc)=LEC("%Sr%",Stc);

delta_Y(L,G)$(NOT %Sy%=%base_year% AND (VYL(L,G)-Y_pre(L,G)))=(VYL(L,G)-Y_pre(L,G));

CSL("CL",G)$(delta_Y("CL",G))=5;
CSL("BIO",G)$(delta_Y("BIO",G))=YIELD("BIO",G);
CSL("PAS",G)$(delta_Y("PAS",G))=2.5;

GHGLG("Positive",L,G)$(CSL(L,G) AND delta_Y(L,G)<0) = CSL(L,G)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1);
GHGLG("Positive",L,G)$(LFRSGL(L) AND delta_Y(L,G)<0) = CS(G)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1);

GHGLG("Negative",L,G)$(CSL(L,G) AND delta_Y(L,G)>0) = CSL(L,G)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1);
GHGLG("Negative",L,G)$(LFRSGL(L) AND delta_Y(L,G)>0) = LEC0("LE20") *delta_Y(L,G) *GA(G)/10**3;
GHGLG("Negative",L,G)$(LAFR(L))= SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%") and delta_VY(Y2,L,G)>0), CFT(G,"%Sy%",Y2)*delta_VY(Y2,L,G)) *GA(G) * 44/12 /10**3 * (-1);

GHGLG("Net",L,G)$(GHGLG("Positive",L,G)+GHGLG("Negative",L,G))= GHGLG("Positive",L,G)+GHGLG("Negative",L,G);
GHGLG(EmitCat,"LUC",G)$(SUM(L$(not LBIO(L)),GHGLG(EmitCat,L,G)))= SUM(L$(not LBIO(L)),GHGLG(EmitCat,L,G));
GHGL(EmitCat,L)= SUM(G$(GHGLG(EmitCat,L,G)),GHGLG(EmitCat,L,G));

*----- Change in carbon stock -----*
CS_post(G)$(CS(G) AND GA(G)) = max(0, (CS(G) * GA(G) - GHGLG("Net","LUC",G) * Ystep *10**3 *12/44)/GA(G));

*----- Average yield output -----*
YIELDL_OUT(L)$(LCROPA(L) AND SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G)))=SUM(G$(YIELD(L,G)*VYL(L,G)),YIELD(L,G)*VYL(L,G)*GA(G))/SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G));
YIELDLDM_OUT(LDM)$(LDMCROPA(LDM) AND SUM(L$MAP_LLDM(L,LDM),SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G))))=SUM(L$MAP_LLDM(L,LDM),SUM(G$(YIELD(L,G)*VYL(L,G)),YIELD(L,G)*VYL(L,G)*GA(G)))/SUM(L$MAP_LLDM(L,LDM),SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G)));

*----- Digit process -----*
$if not %Sy%==%base_year% VYL(L,G)=round(VYL(L,G),6);
$if not %Sy%==%base_year% VZL(L,G)=round(VZL(L,G),6);


*------- Data check ----------*
data_check(G,L)$(VYL(L,G)<0)=1;

*------- Data output ----------*
$if %parallel%==off execute_unload '../output/temp2.gdx'
$if not %Sy%==%base_year% execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/%Sr%/%Sy%.gdx'
$if %Sy%==%base_year% execute_unload '../output/gdx/base/%Sr%/%Sy%.gdx'
ohashi
VYL
VZL
PLDM
PCDM
*ps,PLDM,pr,pr_price_base,pr_price_indx,pc,pc_input,pc_area
SSP_frac
Psol_stat
*VYP,VYN
VOBJ
CS_post=CS
CSL
delta_Y
GHGLG
GHGL
VYLY
delta_VY
protectfrac
protectfracL
protect_wopas
$if %Sy%==%protectStartYear% protectland
$if %Sy%==%protectStartYear% degradedland
*$if %supcuv%==on PBIO,RAREA_BIOP
frsprotect_check,frsprotectarea
pa_bio pa_road pa_emit pa_lab pa_irri pc MF
VYPL=VYP_load
YIELDL_OUT
YIELDLDM_OUT
data_check
PBIODIV
protect_area
;

$ifthen %Sy%==%base_year%
PARAMETER
  AREA_base(LDM,*)	Reginoal aggregated land-use area (kha)
;
  YIELD("PRM_SEC",G)$CS(G)=CS(G);
  Y_base("CL",G)=SUM(L$LCROP(L),Y_base(L,G));
  AREA_base(LDM,"estimates")=SUM(L$MAP_LLDM(L,LDM),SUM(G,GA(G)*VYL(L,G)));
  AREA_base(LDM,"base")=SUM(L$MAP_LLDM(L,LDM),SUM(G,GA(G)*Y_base(L,G)));
  AREA_base("GL","base")=SUM(G,GA(G)*frac_rcp("%Sr%","GL","%base_year%",G));
  AREA_base("FRS","base")=SUM(G,GA(G)*frac_rcp("%Sr%","PRM_FRS","%base_year%",G));
$if not %UrbanLandData%==SSP AREA_base("SL","base")=SUM(G,GA(G)*frac_rcp("%Sr%","SL","%base_year%",G));
$if %UrbanLandData%==SSP AREA_base("SL","base")=SUM(G,GA(G)*SSP_frac("SL","%Sy%","%Sr%",G));

  AREA_base(LDM,"cge")=PLDM(LDM);
  AREA_base("CL","cge")=SUM(LDM$LDMCROP(LDM),PLDM(LDM));
  AREA_base("PAS","cge")=Planduse("%Sy%","GRAZING");
  AREA_base("GL","cge")=Planduse("%Sy%","GRASS");
  AREA_base("FRS","cge")=Planduse("%Sy%","PRM_FRS")+Planduse("%Sy%","MNG_FRS");
  AREA_base("CROP_FLW","cge")=Planduse("%Sy%","CROP_FLW");


execute_unload '../output/gdx/base/%Sr%/basedata.gdx'
plcc roaddens GL GLMIN0
YIELD PC PA
Y_base SF_planduse
AREA_base
MFA MFB
RR BIIcoefG PBIODIVY0
sharepix
;

$endif
