* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ..\AIMPLUM
$setglobal mcp off
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$setglobal parallel on
$setglobal supcuv on
$setglobal protect on
$setglobal bioland off
$setglobal Ystep0 10
$setglobal frsprotect off
$setglobal carbonprice on


$if %Sy%==2005 $setglobal mcp off
$if not %Sy%==2005 $setglobal mcp off

$include %prog_dir%/inc_prog/pre_%Ystep0%year.gms
$include %prog_dir%/inc_prog/second_%Ystep0%year.gms

$include %prog_dir%/scenario/socioeconomic/%sce%.gms
$include %prog_dir%/scenario/climate_policy/%clp%.gms

Set
R	17 regions	/
%Sr%
*$include %prog_dir%/\define\region/region17.set
/
G	Cell number  /
$offlisting
$include %prog_dir%/\define\set_g\G_%Sr%.set
$onlisting
/
I /1*360/
J /1*720/
MAP_GIJ(G,I,J)
Y year	/ %base_year%*%end_year% /
YBASE(Y)/ %base_year% /
YEND(Y) / %end_year% /
Y0(Y)   / %Sy% /
L land use type /
PRM_SEC	forest + grassland + pasture
FRSGL	forest + grassland
HAV_FRS	production forest
AFR	afforestation
PAS	grazing pasture
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
BIO	bio crops
CROP_FLW	fallow land
SL	built_up
OL	ice or water
CL	cropland
$if %base_year%==%Sy% PRM_FRS
$if %base_year%==%Sy% GL
$if %base_year%==%Sy% FRS
LUC
/
LDM land use type /
PRM_SEC	other forest and grassland
HAV_FRS	production forest
AFR	afforestation
PAS	grazing pasture
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
BIO	bio crops
CROP_FLW	fallow land
SL	built_up
OL	ice or water
CL	cropland
$if %base_year%==%Sy% GL
$if %base_year%==%Sy% FRS
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
MAP_RG(R,G)	Relationship between country R and cell G
;
Alias (G,G2,G3,G4,G5,G6,G7,G8),(L,L2),(Y,Y2,Y3);
set
MAP_Lagg(L,L2)/
PRM_SEC	.	PRM_SEC
*HAV_FRS	.	HAV_FRS
AFR	.	AFR
FRSGL	.	FRSGL
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
/;
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

$gdxin '%prog_dir%/data/Data_prep.gdx'
$load Map_RG GA
$load MAP_GIJ

FLAG_G(G)$MAP_RG("%Sr%",G)=1;
GA(G)$(FLAG_G(G)=0)=0;
GAT=SUM(G$FLAG_G(G),GA(G));

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
;
* if bioland on then FLAG_BIO should be zero to exclude BIO from allocation.
FLAG_BIO(L)=1;
$if %bioland%==on FLAG_BIO("BIO")=0;

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
EQYPROTECT(G)	Constraint for protected area in cell G
EQFRSPRT	Constraint for protected forest area in region
;

*--Equation

EQOBJ..
$if not %mcp%==on	VOBJ =E= SUM((L,G)$(FLAGDM(L) AND LOBJ(L)),VZ(L,G));
$if %mcp%==on	VOBJ =E= 0;

EQYPN(L,G)$(FLAGDM(L) AND LOBJ(L) AND YIELD(L,G) AND (NOT F_PLDM(L,G)) AND FLAG_BIO(L)).. VY(L,G)-Y_pre(L,G) =E= VYP(L,G)-VYN(L,G);

EQPRF(L,G)$(FLAGDM(L) AND LOBJ(L) AND YIELD(L,G) AND FLAG_BIO(L)).. VZ(L,G) =E= (VY(L,G)*ps(L,G)-pa(L,G)*VYP(L,G)) * GA(G);

*EQPRF2(L,G)$(FLAGDM(L)  AND LOBJ(L)).. VZ(L,G) =E= pa(L,G)*(VY(L,G)-Y_pre(L,G))*(VY(L,G)-Y_pre(L,G)) + pb(L) * (VY(L,G)-Y_pre(L,G)) *  SUM(G2$(MAP_WG(G,G2) AND FLAG_G(G2)),(VY(L,G2)-Y_pre(L,G2))) + (VY(L,G)-pd(L,G)*ps(L,G)*(1-VRSPRM(L,G)$FPRM)*(1+VRSAFR(L,G)$FAFR))*(VY(L,G)-pd(L,G)*ps(L,G)*(1-VRSPRM(L,G)$FPRM)*(1+VRSAFR(L,G)$FAFR));

EQTOTY(G)..  1 =G= SUM(L$(FLAGDM(L) AND FLAG_BIO(L)),VY(L,G));

EQLDM(LDM)$(PLDM(LDM) AND SUM(L$(MAP_LLDM(L,LDM) AND FLAG_BIO(L)),1)).. SUM(L$(MAP_LLDM(L,LDM) AND FLAG_BIO(L)), SUM(G,ga(G)*VY(L,G))) =E= PLDM(LDM);

EQCDM(L)$(PCDM(L) AND FLAG_BIO(L)).. SUM(G,CS(G)*10**3*ga(G)*VY(L,G)) =E= PCDM(L);

EQYPRMSEC(G).. VY("PRM_SEC",G) =E= 1 - SUM(L$((NOT LPRMSEC(L)) AND FLAG_BIO(L)),VY(L,G));

EQYPRMFRS(L,G)$(FLAGDM(L) AND LPRMSEC(L) AND FPRM AND Y_pre(L,G) AND ps(L,G) AND FLAG_BIO(L)).. Y_pre(L,G)-VY(L,G) =G= 0;

EQYAFR(L,G)$(FLAGDM(L) AND LAFR(L) AND FAFR AND Y_pre(L,G) AND ps(L,G) AND YIELD(L,G) AND FLAG_BIO(L)).. VY(L,G)-Y_pre(L,G) =G= 0;

EQYPROTECT(G)$(protectfrac(G))..        VY("PRM_SEC",G) =G= protectfrac(G);

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
EQFRSPRT
/

;

*------- Parameter_in ----------*

set
CVST	crop categoly in VISIT /PDR,C3,C4,C3natural,C4natural,cstock,co2flux/
Map_LCVST(L,CVST)/
BIO	.	C4
*PAS	.	C4natural
*CROP_FLW	.	C4
*HAV_FRS	.         cstock
*AFR	.	co2flux
/
AC  global set for model accounts - aggregated microsam accounts
A(AC)  activities
ACROP(A)	crop production activities
C(AC)  commodities
CCROP(C) crop commodities
F(AC)  factors
FL(AC) Land use AEZ
Produnit /TON,C/
;
$gdxin '%prog_dir%/data/set.gdx'
$load AC A ACROP C CCROP F FL
Alias(AC,ACP),(A,AP),(C,CP);
CCROP("COM_ECR")=YES;
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

LCGE	land use category in AIMCGE /CROP, PRM_FRS, MNG_FRS, CROP_FLW, GRAZING, GRASS,BIOCROP,URB,OTH/
LRCP(L) /HAV_FRS,PAS,SL,OL/
SCENARIO /%SCE%_%CLP%_%IAV%/
SSP	/%SSP%/
;

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
PSAM_value(Y,R,AC,ACP)
PSAM_volume(Y,R,AC,ACP)
PSAM_price(Y,R,AC,ACP)
Planduse_load(Y,R,LCGE)
Planduse(Y,LCGE)
PlanduseT	total land demand (kha or tonne carbon)
SF_planduse	scale factor
ordy(Y)
LUCHEM_N_load(Y,R,FL)
Ppopulation(Y0,R)
GDP_load(Y0,R)
GDPCAP_WLD	global average of gdp per capita in base year (10 thousand $ per capita)	/0.68/
GDPCAP		GDP per capita (10 thousand $ per capita)
GDPCAP_base     GDP per capita in base year (10 thousand $ per capita)
PGHG_load(Y0,R)	Carbon price [k$ per tonne CO2]
PGHG	Carbon price [million $ per tonne C]
Pirri(LDM,G)	Irrigation ratio of crop LDM cell G (0 to 1)
SF_YIELD(LDM)   Scale factor to adjust average yield to CGE estimates
;

ordy(Y) = ord(Y) + %base_year% -1;

*-------Base-year map data load ----------*

* Base-year land type data
$gdxin '%prog_dir%/data/land_map_gtap.gdx'
$load land_basemap=base_map

* Base-year land type data
$gdxin '%prog_dir%/../data/land_map_rcp.gdx'
$load frac_rcp=frac

* Base-year cropland map data
$gdxin '%prog_dir%/data/cropland_map_rmk.gdx'
$load crop_basemap

$gdxin '%prog_dir%/../data/cbnal0/global_17_%SCE%_%CLP%_%IAV%.gdx'
$load PSAM_value PSAM_volume PSAM_price LUCHEM_N_load Ppopulation GDP_load Planduse_load=Planduse
$load PGHG_load

* Base-year irrigation map data
$gdxin '%prog_dir%/data/mirca.gdx'
$load Pirri

$if %carbonprice%==off PGHG_load(Y0,R)=0;

Planduse(Y,LCGE)=Planduse_load(Y,"%Sr%",LCGE);

parameter
popdens_load(Y0,SSP,G)
popdens(G)	population density (inhabitants per km2)
;

$gdxin '%prog_dir%/data/ssppopmap.gdx'
$load popdens_load=popdens

popdens(G)=popdens_load("%Sy%","%SSP%",G);

GDPCAP$Ppopulation("%Sy%","%Sr%")=GDP_load("%Sy%","%Sr%")/Ppopulation("%Sy%","%Sr%");

*-------Pre-year land map load ----------*

parameter
VZ_load(L,G)
VY_load(L,G)
YBIO_load(G)
PLDM_load(LDM)
PCDM_load(L)
;

$ifthen.baseyear %Sy%==%base_year%

*---Y_base preparation

Y_base(L,G)$(LRCP(L))=frac_rcp("%Sr%",L,"%base_year%",G);
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

$ifthen.fileex exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%pre_year%.gdx'
$	gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%pre_year%.gdx'
$	load VY_load VZ_load
$	load PLDM_load PCDM_load
$else.fileex
VY_load(L,G)=0;
$endif.fileex

Y_pre(L,G)$(VY_load(L,G))=VY_load(L,G);


$ifthen.bio %bioland%==on
$ifthen.fileex exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/bio/%pre_year%.gdx'
$       gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/bio/%pre_year%.gdx'
$       load YBIO_load=YBIO
$else.fileex
YBIO_load(G)=0;
$endif.fileex

Y_pre("BIO",G)$(YBIO_load(G))=YBIO_load(G);

$endif.bio

$endif.baseyear


*-----Protected area-----*
$ifthen %Sy%==%base_year%

protectfrac(G)=0;

$elseif %Sy%==%second_year%

$gdxin '%prog_dir%/../data/protected_area.gdx'
$load protectfrac

protectfrac(G)$(protectfrac(G)>Y_pre("PRM_SEC",G) or (popdens(G)<0.1))=Y_pre("PRM_SEC",G);

$if not %protect%==on protectfrac(G)=0;

$else

$	gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%second_year%.gdx'
$	load protectfrac

$endif

*-----Protected forest area-----*
frsprotectarea=0;



set
i_FRA/"Conservation of biodiversity"/
;
parameter
FRA_load(R,Y,i_FRA)  protected forest area (kha) in FRA(2010)
frsprotect_check
;

$gdxin '%prog_dir%/data/fra_data.gdx'
$load FRA_load=FRA


$ifthen %Sy%==%base_year%
frsprotectarea=0;
$else
$if %frsprotect%==off frsprotectarea=FRA_load("%Sr%","2010","Conservation of biodiversity");
$if %frsprotect%==on frsprotectarea=FRA_load("%Sr%","2010","Conservation of biodiversity")*(1+0.5*(%Sy%-2010)/(2100-2010));
$endif

*----Carbon flow

parameter
ACF(G)          average carbon flow in year Y of forest planed in year Y2 in grid G     (MgC ha-1 year-1)
MACF            mean value of average carbon flow in each region        (MgC ha-1 year-1)
CFT(G,Y,Y2)             carbon flow in year Y of forest planed in year Y2 in grid G     (MgC ha-1 year-1)
;

$gdxin '%prog_dir%/../data/biomass/output/biomass%Sr%_aez.gdx'
$load ACF CFT MACF

$gdxin '%prog_dir%/data/fao_data.gdx'
$load TON_C Pprod


set

*LCGAEZ(L) /PDR,WHT,GRO,OSD,C_B,OTH_A/
LCisimip(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/
LCVST(L)  /HAV_FRS,AFR,PAS,BIO,CROP_FLW/
LCTON(L)	land category of price calculated by unit tonne /PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,CROP_FLW/
LCC(L)    land category of price calculated by unit carbon /HAV_FRS,AFR,BIO,PAS/
LDMCTON(LDM)	land category of price calculated by unit tonne /PDR,WHT,GRO,OSD,C_B,OTH_A,CROP_FLW/
LDMCC(LDM)    land category of price calculated by unit carbon /HAV_FRS,AFR,BIO,PAS/
;

*---- Management factor for Biocrop yield ---*
parameter
MF      management factor for bio crops
MFA     management factor for bio crops in base year
MFB     management factor for bio crops (coefficient)
;
$ifthen %Sy%==%base_year%

GDPCAP_base$Ppopulation("%base_year%","%Sr%")=GDP_load("%base_year%","%Sr%")/Ppopulation("%base_year%","%Sr%");

MFA$(GDPCAP_base>=1)=1;
MFA$(GDPCAP_base>0.35 AND GDPCAP_base<1)=0.6;
MFA$(GDPCAP_base>0 AND GDPCAP_base<=0.35)=0.4;

MFB$(GDPCAP_base>0.35)=1.005;
MFB$(GDPCAP_base>0 AND GDPCAP_base<=0.35)=1.01;


$else

$gdxin '%prog_dir%/../output/gdx/base/%Sr%/basedata.gdx'
$load MFA MFB


$endif

*-------Productivity (YIELD) data ----------*

$ifthen %Sy%==%base_year%

*$gdxin '%prog_dir%/data/yield_map_gaez.gdx'
*$load YIELD_gaez=crop_yieldmap_gaez

$gdxin '%prog_dir%/data/isimipagr.gdx'
$load Pisimip

$gdxin '%prog_dir%/data/visit_data.gdx'
$load PVISIT

PVISIT(CVST,G)$(PVISIT(CVST,G)<10**(-2) AND (NOT sameas(CVST,"co2flux")))=0;

$gdxin '%prog_dir%/data/analysis_agr.gdx'
$load YIELD_cge=YIELD

parameter
yield_miscanthus_rainfed_num(I,J)	miscanthus biocrop yield (kg per ha)
yield_swichgrass_rainfed_num(I,J)	swichgrass biocrop yield (kg per ha)
YIELDBIO_H08(G)	average biocrop yield (tonne per ha)
;

$gdxin '%prog_dir%/data/H08_yield_num_gdx.gdx'
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

YIELD("AFR",G)$ACF(G)=ACF(G);

YIELD(L,G)$(LBIO(L) AND YIELD(L,G))=YIELD(L,G)*MFA;

$else

$gdxin '%prog_dir%/../output/gdx/base/%Sr%/basedata.gdx'
$load YIELD

$endif

*---- Management factor for Biocrop yield ---*

MF=min(1.3/MFA,MFB**max(0,%Sy%-2010));

YIELD(L,G)$(LBIO(L) AND YIELD(L,G))=YIELD(L,G)*MF;

*---- Carbon price ---*

PGHG=PGHG_load("%Sy%","%Sr%")/1000*44/12;

*-----Carbon stock ---*

$ifthen %Sy%==%base_year%

$gdxin '%prog_dir%/../data/biomass/output/biomass%Sr%.gdx'
$load CS

CSB=0;

$else

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%pre_year%.gdx'
$load CS
$gdxin '%prog_dir%/../output/gdx/base/%Sr%/analysis/%base_year%.gdx'
$load CSB

$endif

*----------------------*

*-------Benefit from afforestation

parameter
PB_WLD	annual benefit from afforestation per ha global average (million $ per ha)	/0.00162/
PBR	annual benefit from afforestation per ha in region (million $ per ha)	 (million $ per ha)
PB(G)   annual benefit from afforestation per ha in grid g (million $ per ha)	 (million $ per ha)
;


PBR=PB_WLD*(GDPCAP/GDPCAP_WLD)**0.5;
PB(G)$MACF=PBR*ACF(G)/MACF;


*-------- Land demand
PlanduseT=SUM(LCGE,Planduse("%Sy%",LCGE));
SF_planduse$PlanduseT=GAT/PlanduseT;
*Planduse("%Sy%",LCGE)$(PlanduseT>GAT)=Planduse("%Sy%",LCGE)*SF_planduse;

parameter
PLDM0(Y,LDM)
PCDM0(Y,L)
;
PCDM0(Y,L)=0;

* [10^5ha --> 000ha]
PLDM0(Y,LDM)$(LDMCROPB(LDM))=SUM(A$MAP_LDMA(LDM,A), SUM(FL,PSAM_volume(Y,"%Sr%",FL,A) )) * 10**2;
PLDM0(Y,"CROP_FLW")=Planduse(Y,"CROP_FLW");
*PLDM0(Y,"HAV_FRS")=Planduse(Y,"MNG_FRS");

*PLDM0(Y,"AFR")=SUM(Y2$(ordy("%base_year%")+1<=ordy(Y2) AND ordy(Y2)<=ordy(Y) AND (Planduse(Y2,"PRM_FRS")-Planduse(Y2-1,"PRM_FRS"))>0),Planduse(Y2,"PRM_FRS")-Planduse(Y2-1,"PRM_FRS"));
PLDM0(Y,"AFR")$(Planduse(Y,"PRM_FRS")-Planduse("%base_year%","PRM_FRS")>0)=Planduse(Y,"PRM_FRS")-Planduse("%base_year%","PRM_FRS");

*PLDM0(Y,"AFR")$(PLDM0(Y,"AFR")<0)=0;

*[tonne carbon]
*PCDM0(Y,"HAV_FRS")$PSAM_volume("%base_year%","%Sr%","FRS","COM_FRS")=Pprod("%base_year%","%Sr%","HAV_FRS","C") *PSAM_volume(Y,"%Sr%","FRS","COM_FRS")/PSAM_volume("%base_year%","%Sr%","FRS","COM_FRS");
*PCDM0(Y,"AFR")$(SUM(FL,LUCHEM_N_load(Y,"%Sr%",FL))*(-1)>10**(-9))=SUM(FL,LUCHEM_N_load(Y,"%Sr%",FL))*(-1)*10**4*(12/44);

PCDM(L)$(PCDM0("%Sy%",L))=PCDM0("%Sy%",L);
PLDM(LDM)$(PLDM0("%Sy%",LDM)>0.01)=PLDM0("%Sy%",LDM);
PLDM("SL")=SUM(G,GA(G)*Y_pre("SL",G));
PLDM("OL")=SUM(G,GA(G)*Y_pre("OL",G));

FLAGDM(L)$(SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)) OR PCDM(L))=1;

* mil.$/ton or mil.$/tonC
pr_price_base0(LDM)$(LDMCTON(LDM) AND Pprod("%base_year%","%Sr%",LDM,"TON")) =  SUM(A$MAP_LDMA(LDM,A),SUM(C$MAP_LDMC(LDM,C),PSAM_value("%base_year%","%Sr%",A,C))) / Pprod("%base_year%","%Sr%",LDM,"TON");
pr_price_base0(LDM)$(LDMCC(LDM) AND Pprod("%base_year%","%Sr%",LDM,"C")) =  SUM(A$MAP_LDMA(LDM,A),SUM(C$MAP_LDMC(LDM,C),PSAM_value("%base_year%","%Sr%",A,C))) / Pprod("%base_year%","%Sr%",LDM,"C");

pr_price_base(L)$(FLAGDM(L))=SUM(LDM$MAP_LLDM(L,LDM),pr_price_base0(LDM));
pr_price_base("CROP_FLW")$SUM(LDM$LDMCROP(LDM),Pprod("%base_year%","%Sr%",LDM,"TON")) =  SUM(A$(ACROP(A)),SUM(C$(CCROP(C)),PSAM_value("%base_year%","%Sr%",A,C))) / SUM(LDM$LDMCROP(LDM),Pprod("%base_year%","%Sr%",LDM,"TON"));

pr_pricey(Y,L)$(FLAGDM(L) AND SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_volume(Y,"%Sr%",A,C)))) =  SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_value(Y,"%Sr%",A,C))) / SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_volume(Y,"%Sr%",A,C)));
pr_pricey(Y,"CROP_FLW")$SUM(A$ACROP(A),SUM(C$CCROP(C),PSAM_volume(Y,"%Sr%",A,C))) = SUM(A$ACROP(A),SUM(C$CCROP(C),PSAM_value(Y,"%Sr%",A,C))) / SUM(A$ACROP(A),SUM(C$CCROP(C),PSAM_volume(Y,"%Sr%",A,C)));

pr_price_indx(L)$pr_pricey("%base_year%",L)=pr_pricey("%Sy%",L)/pr_pricey("%base_year%",L);

* mil.$/ton or mil.$/tonC
pr_price(L)=pr_price_base(L) * pr_price_indx(L);
pr_price("BIO")$PSAM_volume("%Sy%","%Sr%","BTR3","COM_BIO") = PSAM_value("%Sy%","%Sr%","BTR3","COM_BIO") / (PSAM_volume("%Sy%","%Sr%","BTR3","COM_BIO")*10**3) * 0.38 * C_TON;


* mil.$/ha/year = mil.$/ton * ton/ha/year
pr(L,G)$(FLAGDM(L))= pr_price(L) * YIELD(L,G);

pr("AFR",G)$(PB(G))=PB(G) + PGHG * SUM(Y$(ordy(Y)<=ordy(Y)+YPP),CFT(G,"%end_year%",Y)/((1+DR)**(ordy(Y)-ordy("%base_year%")))) / YPP;

* [mil. $]
*pc_input(L)$(SUM(A$MAP_LA(L,A),1))=SUM(A$MAP_LA(L,A), SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) - SUM(FL,PSAM_value("%Sy%","%Sr%",FL,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));
*pc_input("CROP_FLW")=SUM(A$(ACROP(A)),SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) - SUM(FL,PSAM_value("%Sy%","%Sr%",FL,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));
pc_input(L)$(SUM(A$MAP_LA(L,A),1))=SUM(A$MAP_LA(L,A), SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));
pc_input("CROP_FLW")=SUM(A$(ACROP(A)),SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));
* use 2020 value for after 2020 not to reflect yield improve to bioenergy potential
*pc_input("BIO")=SUM(A$(ACROP(A)),SUM(C,PSAM_value("2020","%Sr%",C,A)) + SUM(F,PSAM_value("2020","%Sr%",F,A)) + SUM(TX,PSAM_value("2020","%Sr%",TX,A)) + PSAM_value("2020","%Sr%","ATAX",A));
pc_input("BIO")=0.5*SUM(A$(sameas(A,"GRO")),SUM(C,PSAM_value("2020","%Sr%",C,A)) + SUM(F,PSAM_value("2020","%Sr%",F,A)) + SUM(TX,PSAM_value("2020","%Sr%",TX,A)) + PSAM_value("2020","%Sr%","ATAX",A));

* [10^5ha --> ha]
pc_area(L)$(SUM(A$MAP_LA(L,A),1))=SUM(A$MAP_LA(L,A),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5;
pc_area("CROP_FLW")=SUM(A$(ACROP(A)),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5;
* use 2020 value for after 2020 not to reflect yield improve to bioenergy potential
*pc_area("BIO")=SUM(A$(ACROP(A)),SUM(FL,PSAM_volume("2020","%Sr%",FL,A))) * 10**5;
pc_area("BIO")=SUM(A$(sameas(A,"GRO")),SUM(FL,PSAM_volume("2020","%Sr%",FL,A))) * 10**5;

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


*------- Land conversion cost ----------*

*mil$/ha
*plandrent(L)$SUM(A$MAP_LA(L,A),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) =  SUM(A$MAP_LA(L,A),SUM(FL,PSAM_value("%Sy%","%Sr%",FL,A))) / (SUM(A$MAP_LA(L,A),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5);
*plandrent("CROP_FLW")$SUM(A$(ACROP(A)),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) = SUM(A$ACROP(A),SUM(FL,PSAM_value("%Sy%","%Sr%",FL,A))) / (SUM(A$(ACROP(A)),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5);
*plandrent("HAV_FRS")=plandrent("HAV_FRS")/30;
*plandrent("AFR")=plandrent("AFR")/30;

parameter
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
;
wage=GDPCAP/(365-100)/100;

pldc_WLD=0.866-0.254;
pldc=pldc_WLD*(GDPCAP/GDPCAP_WLD)**0.5;
irricost=irricost_WLD*(GDPCAP/GDPCAP_WLD)**0.5;

$ifthen %Sy%==%base_year%

$gdxin '%prog_dir%/data/roads.gdx'
$load ruralroadlength

roaddens=ruralroadlength("%Sr%")/SUM(LDM$LDMCROP(LDM),PLDM(LDM))/1000;

$gdxin '%prog_dir%/data/Data_prep.gdx'
$load GL=GL%Sr%

* 一定距離以上離れたエリアには最大値を入れる
GLMAX=smax((G,G2)$GL(G,G2),GL(G,G2));
GL(G,G2)$(GL(G,G2)=0 AND (NOT sameas(G,G2)))=GLMAX;
GLMIN0(L,G)$(LAFR(L) AND NOT Y_base("HAV_FRS",G))=smin(G2$(Y_base("HAV_FRS",G2)),GL(G,G2));
GLMIN0(L,G)$(LCROPA(L) AND (NOT SUM(L2$LCROPA(L2),Y_pre(L2,G))))=smin(G2$(SUM(L2$LCROPA(L2),Y_pre(L2,G2))),GL(G,G2));

*psmax(L)=smax(G,ps(L,G)-pldc*roaddens);
psmax(L)$(LOBJ(L))=smax(G$ps(L,G),ps(L,G));
psmin(L)$(LOBJ(L)AND sum(G$(Y_base(L,G)),1))=smin(G$(Y_base(L,G) AND ps(L,G)),ps(L,G));
plcc(L)=psmax(L)-psmin(L);

$else

$gdxin '%prog_dir%/../output/gdx/base/%Sr%/basedata.gdx'
$load plcc
$load roaddens
$load GL
$load GLMIN0

*GL(G,G2)=GL_load(G,G2);

$endif

*GLMIN(L,G)$((NOT LCROPA(L)) AND (NOT LAFR(L)))=smin(G2$(Y_pre(L,G2)),GL(G,G2));
GLMIN(L,G)$(LAFR(L) OR (LCROPA(L) AND (NOT LBIO(L))))=GLMIN0(L,G);
GLMIN(L,G)$(LBIO(L) AND (NOT SUM(L2$LCROPA(L2),Y_pre(L2,G))))=smin(G2$(SUM(L2$LCROPA(L2),Y_pre(L2,G2))),GL(G,G2));
*GLMIN(L,G)$(LAFR(L) AND (NOT Y_base("HAV_FRS",G)))=smin(G2$(Y_base("HAV_FRS",G2)),GL(G,G2));
GLMINHA(L,G)$(LAFR(L) OR LCROPA(L)) = GLMIN(L,G)/(GA(G)*1000);


$ontext
plcc(L)$SUM(A$MAP_LA(L,A),PSAM_price("%base_year%","%Sr%","LAB",A))=plcc(L)*SUM(A$MAP_LA(L,A),PSAM_price("%Sy%","%Sr%","LAB",A))/SUM(A$MAP_LA(L,A),PSAM_price("%base_year%","%Sr%","LAB",A));
plcc("CROP_FLW")$(SUM(A$(ACROP(A)),PSAM_volume("%Sy%","%Sr%","LAB",A)) AND SUM(A$(ACROP(A)),PSAM_value("%base_year%","%Sr%","LAB",A)) AND SUM(A$(ACROP(A)),PSAM_volume("%base_year%","%Sr%","LAB",A)))
=plcc("CROP_FLW")*
(SUM(A$(ACROP(A)),PSAM_value("%Sy%","%Sr%","LAB",A))/SUM(A$(ACROP(A)),PSAM_volume("%Sy%","%Sr%","LAB",A)))/
(SUM(A$(ACROP(A)),PSAM_value("%base_year%","%Sr%","LAB",A))/SUM(A$(ACROP(A)),PSAM_volume("%base_year%","%Sr%","LAB",A)))
;
$offtext

parameter
YPP_lab         Payback period of investment cost for agriculture /10/
YPP_road	Payback period of investment cost for road constraction /50/
YPP_irri	Payback period of investment cost for irrigation /15/
YPP_emit	Payback period of investment cost for greenhouse gas emission /30/
pannual_lab     Annualization coefficient of investment cost
pannual_road	Annualization coefficient of investment cost
pannual_irri	Annualization coefficient of investment cost
pannual_emit	Annualization coefficient of investment cost

* cost breakdown
pa_lab         labor costs per unit area (million $ per ha)
pa_road(L,G)        road construction costs per unit area (million $ per ha)
pa_irri(L)        irrigation costs per unit area (million $ per ha)
pa_emit(G)        emission costs per unit area (million $ per ha)
pa_bio(G)         land transition costs per unit area for BIO (million $ per ha)
;
pannual_lab =(DR*(1+DR)**YPP_lab) /((1+DR)**YPP_lab-1);
pannual_road=(DR*(1+DR)**YPP_road)/((1+DR)**YPP_road-1);
pannual_irri=(DR*(1+DR)**YPP_irri)/((1+DR)**YPP_irri-1);
pannual_emit=(DR*(1+DR)**YPP_emit)/((1+DR)**YPP_emit-1);

pa_lab = wage * labor * pannual_lab;
pa_road(L,G)$(NOT LPRMSEC(L)) =  (plcc(L) + pldc*(roaddens + GLMINHA(L,G))) * pannual_road;
pa_irri(L)$(LCROPIR(L)) = irricost * pannual_irri;
pa_emit(G)$(CS(G)) =  PGHG * CS(G) * pannual_emit;


pa(L,G)$(LOBJ(L) OR LBIO(L))= pa_lab + pa_road(L,G)  + pa_irri(L) + pa_emit(G)$(NOT LPRMSEC(L));

pa_bio(G)$pa("BIO",G)=pa("BIO",G);

*pa(L,G)$(LOBJ(L) OR LBIO(L))= wage * labor * pannual_lab + (plcc(L) + pldc*(roaddens + GLMINHA(L,G))) * pannual_road  + (irricost* pannual_irri)$(LCROPIR(L)) + (PGHG * CS(G) * pannual_emit)$((NOT LPRMSEC(L)) AND CS(G));

*------- Initial data ----------*
FPRM$(%Sy%>%base_year%)=1;
FAFR$(%Sy%>%base_year% AND PCDM("AFR")>=PCDM_load("AFR"))=1;
*-*-*-*-*
FAFR=0;
*-*-*-*-*

*FAFR$(PLDM("AFR")<PLDM_load("AFR"))=0;

VRSPRM.L(L,G)$(FLAGDM(L) AND LPRMSEC(L) AND FPRM AND Y_pre(L,G) AND ps(L,G))=0.01;
VRSAFR.L(L,G)$(FLAGDM(L) AND LAFR(L) AND FAFR AND Y_pre(L,G) AND ps(L,G))=0.01;

VRSPRM.FX(L,G)$(FLAGDM(L) AND (NOT LPRMSEC(L)))=0;
VRSPRM.FX(L,G)$(FLAGDM(L) AND LPRMSEC(L) AND (NOT Y_pre(L,G)))=0;
VRSAFR.FX(L,G)$(FLAGDM(L) AND (NOT LAFR(L)))=0;
VRSAFR.FX(L,G)$(FLAGDM(L) AND LAFR(L) AND (NOT Y_pre(L,G)))=0;


VY.LO(L,G)=0;
VYP.LO(L,G)=0;
VYN.LO(L,G)=0;

VY.L(L,G)$(Y_pre(L,G))=Y_pre(L,G);
VZ.L(L,G)$(VZ_load(L,G))=VZ_load(L,G);

VY.L(L,G)$(Y_pre(L,G)<10**(-5))=0;
VZ.L(L,G)$(VZ_load(L,G)<10**(-5))=0;

VOBJ.L=0;

VY.FX(L,G)$((NOT LPRMSEC(L)) AND ((NOT FLAGDM(L)) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;
VZ.FX(L,G)$((NOT LPRMSEC(L)) AND ((NOT FLAGDM(L)) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;

VYP.FX(L,G)$((NOT LPRMSEC(L)) AND ((SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)-PLDM_load(LDM))=0 AND PCDM(L)-PCDM_load(L)=0) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;
VYN.FX(L,G)$((NOT LPRMSEC(L)) AND ((SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)-PLDM_load(LDM))=0 AND PCDM(L)-PCDM_load(L)=0) OR (NOT YIELD(L,G))) OR (NOT FLAG_BIO(L)))=0;

VY.FX("SL",G)$(Y_pre("SL",G))=Y_pre("SL",G);
VY.FX("OL",G)$(Y_pre("OL",G))=Y_pre("OL",G);

*VY.LO("AFR",G)$(Y_pre("AFR",G) AND CS(G)<CSB)=Y_pre("AFR",G);

$ifthen %Sr%==CAN
VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2050 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2050))=0;
$elseif %Sr%==USA
$if %CLP%==20W  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%=2030 AND CS(G)>=CSB*5)=0;
$if %CLP%==20W  VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.2**(%Sy%-2060))=0;
$elseif %Sr%==XER
$if %CLP%_%IAV%==20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2070 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2070))=0;
$elseif %Sr%==XOC
$if %CLP%_%IAV%==20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2060 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2060))=0;

$elseif %Sr%==XE25
$if %SCENAME%_%CLP%_%IAV%==SSP1p_20W_NoCC VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND %Sy%>=2090 AND CS(G)>=CSB*1.5*1.02**(%Sy%-2090))=0;

$else
VY.FX("AFR",G)$((NOT Y_pre("AFR",G)) AND CS(G)>=CSB)=0;
$endif

*$elseif %SCE%_%CLP%_%IAV%==SSP2_20W_SPA1p_BIOD2

*$else



*$endif



F_PLDM(L,G)$(LAFR(L) AND (SUM(LDM$MAP_LLDM(L,LDM),PLDM(LDM)-PLDM_load(LDM))=0) AND Y_pre(L,G))=1;

$if %parallel%==off execute_unload '../output/temp.gdx'
;
*------- Solve ----------*

option reslim=10000;
option solprint=off;
option sysout=off;
option limrow=0;
option limcol=0;
option profile=0;

$if %parallel%==on option SOLPRINT=ON;
LandUseModel_LP.HOLDFIXED   = 1 ;

$ifthen %mcp%==on
	Solve LandUseModel_MCP USING MCP;
$else
	Solve LandUseModel_LP USING LP maximizing VOBJ;
$endif

$if %parallel%==off execute_unload '../output/temp2.gdx'

parameter
VYL(L,G)	output of VY
VYPL(L,G)	output of VYP
VZL(L,G)	output of VZ
;

VYL(L,G)$(VY.L(L,G))=VY.L(L,G);
VZL(L,G)$(VZ.L(L,G))=VZ.L(L,G);
VYPL(L,G)$(VY.L(L,G))=VYP.L(L,G);


VYL(L,G)$SUM(L2$MAP_Lagg(L2,L),VYL(L2,G))=SUM(L2$MAP_Lagg(L2,L),VYL(L2,G));


*-------- Pasture --------*

set
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
;
$gdxin '%prog_dir%/data/Data_prep.gdx'
$load MAP_WG

*-----Protected area-----*
parameter
protect_wopas(G)
VY_baseresults(LFRSGL,G)
;

$ifthen %Sy%==%base_year%
protect_wopas(G)=0;
$elseif %Sy%==%second_year%

$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%base_year%.gdx'
$load VY_baseresults=VY_load

protect_wopas(G)=0;
protect_wopas(G)$protectfrac(G)=protectfrac(G);
protect_wopas(G)$(protectfrac(G)>VY_baseresults("FRSGL",G) AND VY_baseresults("FRSGL",G)>0)=VY_baseresults("FRSGL",G);

$else

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%second_year%.gdx'
$load protect_wopas

$endif

frsprotect_check$(frsprotectarea)=SUM(G$(CS(G)>CSB),VY.L("PRM_SEC",G)*GA(G));

*---Pasture---
parameter
Planduse_pas
PASarea
ADD_PAS
SF_PAS
SF_PASG(G)
Y_NPROTPASG(G)	fraction  non-protected area = PRM_SEC - protected area - pasture
Y_NPROTPAS	fraction  non-protected area = PRM_SEC - protected area - pasture (for check)
AREA_NPAS	Area of potentail grassland
SF_PAS2
PNBPAS(G)
Y_NPROT(G)	non-protected area = PRM_SEC - protected area
R_ADD_PAS
PASarea_NPROT	pasture area in the grid which has potential area for pasture
SMALL/1.0E-10/
FLAG_YIELD(G)	flag of grid where potential crop yields exist.

;

* STEP1

SF_PAS=1;
FLAG_YIELD(G)$(SUM(L$(LCROPA(L) AND YIELD(L,G)),YIELD(L,G)))=YES;

Planduse_pas=Planduse("%Sy%","GRAZING");
Y_NPROT(G)$((CS(G) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)-protect_wopas(G)>0)=VYL("PRM_SEC",G)-protect_wopas(G);
*基準年でPASのあるセルでいけるところまでいれる
VYL("PAS",G)$(Y_pre("PAS",G) AND Y_NPROT(G) AND Y_NPROT(G)>=Y_pre("PAS",G))=Y_pre("PAS",G);
VYL("PAS",G)$(Y_pre("PAS",G) AND Y_NPROT(G) AND Y_NPROT(G)<Y_pre("PAS",G))=Y_NPROT(G);
Y_NPROTPASG(G)$(Y_NPROT(G) and Y_NPROT(G) - VYL("PAS",G)>SMALL)=Y_NPROT(G) - VYL("PAS",G);
PASarea_NPROT=SUM(G$(VYL("PAS",G) AND Y_NPROTPASG(G)),VYL("PAS",G)*GA(G));
PASarea=SUM(G$VYL("PAS",G),VYL("PAS",G)*GA(G));

ADD_PAS=Planduse_pas-PASarea;

* if pasture area decreases from previous year, pasture fraction is decreased at the same ratio.
IF(ADD_PAS<0,
VYL("PAS",G)$(Y_pre("PAS",G) AND PASarea)=VYL("PAS",G)*Planduse_pas/PASarea;
)

scalar iter;

While(ADD_PAS>0 AND SF_PAS>0,
Y_NPROTPASG(G)=0;
SF_PASG(G)=0;
SF_PAS=0;
R_ADD_PAS=0;

Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

R_ADD_PAS$PASarea_NPROT=ADD_PAS/PASarea_NPROT;

SF_PASG(G)$(Y_NPROTPASG(G) and VYL("PAS",G))=Y_NPROTPASG(G)/VYL("PAS",G);

SF_PAS=min(R_ADD_PAS,smin(G$(SF_PASG(G)),SF_PASG(G)));

VYL("PAS",G)$(VYL("PAS",G) AND SF_PASG(G)) =VYL("PAS",G)*(1+SF_PAS);

Y_NPROTPASG(G)=0;
Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

PASarea_NPROT=SUM(G$(VYL("PAS",G) AND Y_NPROTPASG(G)),VYL("PAS",G)*GA(G));

PASarea=SUM(G$(VYL("PAS",G)),VYL("PAS",G)*GA(G));

ADD_PAS=Planduse_pas-PASarea;

*display ADD_PAS, SF_PAS;
);
*execute_unload '../output/temp3_step1.gdx'

scalar
BacktoStep1	/0/
;

* STEP2 neighborhood cell
*For(iter=1 to 10,
While ((ADD_PAS>0 AND BacktoStep1=0),
PNBPAS(G)=0;
AREA_NPAS=0;
SF_PAS2=0;

* The pasture expands to cell neighbor in order.
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G))=SUM(G2$(VYL("PAS",G2) AND MAP_WG(G,G2)),1);
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G4$(MAP_WG(G,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G5$(MAP_WG(G,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1)));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G6$(MAP_WG(G,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1))));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G7$(MAP_WG(G,G7)),SUM(G6$(MAP_WG(G7,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1)))));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G8$(MAP_WG(G,G8)),SUM(G7$(MAP_WG(G8,G7)),SUM(G6$(MAP_WG(G7,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1))))));
* if theres is no potential area in neighbor cells, the pasture expands to cell where cropland or settlements exist.
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0 AND (VYL("SL",G) OR VYL("CL",G)))=1;


AREA_NPAS=SUM(G$(PNBPAS(G)),Y_NPROT(G)*GA(G));

SF_PAS2$(AREA_NPAS)= ADD_PAS/AREA_NPAS;

VYL("PAS",G)$(SF_PAS2>0 AND SF_PAS2<=1 AND PNBPAS(G))=Y_NPROT(G)*SF_PAS2;
VYL("PAS",G)$(SF_PAS2>1 AND PNBPAS(G))=Y_NPROT(G);

PASarea=SUM(G$(VYL("PAS",G)),VYL("PAS",G)*GA(G));
ADD_PAS=Planduse_pas-PASarea;

Y_NPROTPAS=SUM(G$(VYL("PRM_SEC",G)-VYL("PAS",G)-protect_wopas(G)>SMALL),VYL("PRM_SEC",G)-VYL("PAS",G)-protect_wopas(G));

* if there is no area left for pasture, pasture expands to protected area with low carbon density.
IF((Y_NPROTPAS=0 and ADD_PAS>0),
BacktoStep1=1;
Y_NPROT(G)$(((CS(G) AND CS(G)<CSB) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)>0)=VYL("PRM_SEC",G);

$ontext
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G))=1;
AREA_NPAS=SUM(G$(PNBPAS(G)),Y_NPROT(G)*GA(G));
IF((AREA_NPAS=0),
* if there is still no area left, pasture expands to protected area with high carbon density.
Y_NPROT(G)$((CS(G) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)>0)=VYL("PRM_SEC",G);
);
$offtext
);

*display PNBPAS,AREA_NPAS,SF_PAS2,PASarea,ADD_PAS,Y_NPROTPAS;

);

SF_PAS=1;
*###STEP1
While(ADD_PAS>0 AND SF_PAS>0,
Y_NPROTPASG(G)=0;
SF_PASG(G)=0;
SF_PAS=0;
R_ADD_PAS=0;

Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

R_ADD_PAS$PASarea_NPROT=ADD_PAS/PASarea_NPROT;

SF_PASG(G)$(Y_NPROTPASG(G) and VYL("PAS",G))=Y_NPROTPASG(G)/VYL("PAS",G);

SF_PAS=min(R_ADD_PAS,smin(G$(SF_PASG(G)),SF_PASG(G)));

VYL("PAS",G)$(VYL("PAS",G) AND SF_PASG(G)) =VYL("PAS",G)*(1+SF_PAS);

Y_NPROTPASG(G)=0;
Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

PASarea_NPROT=SUM(G$(VYL("PAS",G) AND Y_NPROTPASG(G)),VYL("PAS",G)*GA(G));

PASarea=SUM(G$(VYL("PAS",G)),VYL("PAS",G)*GA(G));

ADD_PAS=Planduse_pas-PASarea;

*display ADD_PAS, SF_PAS;
);


VYL("FRSGL",G)$(VYL("PRM_SEC",G)-VYL("PAS",G)>0)=VYL("PRM_SEC",G)-VYL("PAS",G);

$ontext
*-------Bioenergy potential curve ---*
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
parameter
VYLY(Y,L,G)
delta_VYLY(Y,L,G)
;

$ifthen not %Sy%==%base_year%

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%pre_year%.gdx'
$load VYLY
$endif

VYLY("%Sy%",L,G)$(VYL(L,G))=VYL(L,G);

delta_VYLY(Y,L,G)$(ordy(Y)>=ordy("%base_year%")+Ystep AND ordy(Y)<=ordy("%Sy%") AND VYLY(Y,L,G)*VYLY(Y-Ystep,L,G))=(VYLY(Y,L,G)-VYLY(Y-Ystep,L,G));


*--------GHG emissions --------*

parameter
CSL(L,G)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
delta_Y(L,G)	change in area ratio of land category L in cell G
GHGLG(L,G)	GHG emission of land category L cell G in year Y [MtCO2 per cell per year]
GHGL(L)		GHG emission of land category L in year Y [MtCO2 per year]
checkArea(L)

;

delta_Y(L,G)$(NOT %Sy%=%base_year% AND (VYL(L,G)-Y_pre(L,G)))=(VYL(L,G)-Y_pre(L,G))/Ystep;

CSL("CL",G)$(delta_Y("CL",G))=5;
CSL("BIO",G)$(delta_Y("BIO",G))=5;
CSL("PAS",G)$(delta_Y("PAS",G))=2.5;
CSL("FRSGL",G)$(CS(G) AND delta_Y("FRSGL",G))=CS(G);

checkArea(L)$(NOT LCROP(L))=sum(G,delta_Y(L,G) *GA(G));

GHGLG(L,G)$(NOT LFRSGL(L) AND CSL(L,G)*delta_Y(L,G)) = CSL(L,G)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1);
GHGLG(L,G)$(LFRSGL(L) AND delta_Y(L,G)<0 AND CSL(L,G)*delta_Y(L,G))= CSL(L,G)*delta_Y(L,G) *GA(G) * 44/12 /10**3 * (-1);

GHGLG(L,G)$(LAFR(L))= SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy("%Sy%")), CFT(G,"%Sy%",Y2)*delta_VYLY(Y2,L,G)) *GA(G) * 44/12 /10**3 * (-1);
*GHGLG(L,G)$(LAFR(L) AND (NOT %Sy%=%base_year%))= ACF(G)*VYL(L,G) *GA(G) * 44/12 /10**3 * (-1);

GHGLG("LUC",G)$(SUM(L,GHGLG(L,G)))= SUM(L,GHGLG(L,G));

GHGL(L)= SUM(G$(GHGLG(L,G)),GHGLG(L,G));


*----- Change in carbon stock -----*

parameter
CS_post(G)	carbon stock in next year  (MgC ha-1)
;
CS_post(G)$(CS(G) AND GA(G)) = max(0, (CS(G) * GA(G) - GHGLG("LUC",G) * Ystep *10**3 *12/44)/GA(G));


*----- Average yield output -----*
parameter
YIELDL_OUT(L)	Agerage yield of land category L region R in year Y [tonne per ha per year]
YIELDLDM_OUT(LDM)	Agerage yield of land category L region R in year Y [tonne per ha per year]
;

YIELDL_OUT(L)$(LCROPA(L) AND SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G)))=SUM(G$(YIELD(L,G)*VYL(L,G)),YIELD(L,G)*VYL(L,G)*GA(G))/SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G));

YIELDLDM_OUT(LDM)$(LDMCROPA(LDM) AND SUM(L$MAP_LLDM(L,LDM),SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G))))=SUM(L$MAP_LLDM(L,LDM),SUM(G$(YIELD(L,G)*VYL(L,G)),YIELD(L,G)*VYL(L,G)*GA(G)))/SUM(L$MAP_LLDM(L,LDM),SUM(G$(YIELD(L,G)*VYL(L,G)),VYL(L,G)*GA(G)));


*------- Data output ----------*
$if %parallel%==off execute_unload '../output/temp2.gdx'

PARAMETER
Psol_stat(*,*)                  Solution report
AREA_base(LDM,*)
;

$if not %mcp%==on       Psol_stat("SSOLVE","SLP")=LandUseModel_LP.SOLVESTAT;Psol_stat("SMODEL","SLP")=LandUseModel_LP.MODELSTAT;


$if not %Sy%==%base_year% execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%Sy%.gdx'
$if %Sy%==%base_year% execute_unload '../output/gdx/base/%Sr%/%Sy%.gdx'
VYL=VY_load
VZL=VZ_load
PLDM=PLDM_load
PCDM=PCDM_load
*ps,PLDM,pr,pr_price_base,pr_price_indx,pc,pc_input,pc_area
Psol_stat
*VYP,VYN
VOBJ
CS_post=CS
CSL
delta_Y
GHGLG
GHGL
*checkArea
VYLY
delta_VYLY
$if %Sy%==%second_year% protectfrac
$if %Sy%==%second_year% protect_wopas
*$if %supcuv%==on PBIO,RAREA_BIOP
frsprotect_check,frsprotectarea
pa_bio
pa_road pa_emit pa_lab pa_irri pc MF
VYPL=VYP_load
YIELDL_OUT
YIELDLDM_OUT
;


$ifthen %Sy%==%base_year%

YIELD("PRM_SEC",G)$CS(G)=CS(G);
Y_base("CL",G)=SUM(L$LCROP(L),Y_base(L,G));
AREA_base(LDM,"base")=SUM(L$MAP_LLDM(L,LDM),SUM(G,GA(G)*Y_base(L,G)));
AREA_base("GL","base")=SUM(G,GA(G)*frac_rcp("%Sr%","GL","%base_year%",G));
AREA_base("FRS","base")=SUM(G,GA(G)*frac_rcp("%Sr%","PRM_FRS","%base_year%",G));
AREA_base(LDM,"cge")=PLDM(LDM);
AREA_base("CL","cge")=SUM(LDM$LDMCROP(LDM),PLDM(LDM));
AREA_base("PAS","cge")=Planduse("%Sy%","GRAZING");
AREA_base("GL","cge")=Planduse("%Sy%","GRASS");
AREA_base("FRS","cge")=Planduse("%Sy%","PRM_FRS")+Planduse("%Sy%","MNG_FRS");


execute_unload '../output/gdx/base/%Sr%/basedata.gdx'
plcc roaddens GL GLMIN0
YIELD PC PA
Y_base AREA_base
MFA MFB
;

$endif
