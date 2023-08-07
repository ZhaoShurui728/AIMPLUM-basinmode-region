$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ../AIMPLUM
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC

set
R	17 regions	/
$include %prog_dir%/define/region/region17.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
Y year	/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
L land use type /
*PRM_SEC	primary and secondary land
FRSGL	forest + grassland
FRS	forest
AFR	afforestation
PAS	grazing pasture
CL	cropland
BIO	bio crops
CROP_FLW	fallow land
GL	grassland
SL	built_up
OL	ice or water
LUC	land use change total
/
AEZ	/AEZ1*AEZ18/
SGHG	/CO2/
C	/AL/
A	/FRS/
SMODEL	/CGE,LUM/
;
Alias(R,R2);

set
MAP_RAGG(R,R2)	/
$include %prog_dir%/define/region/region17_agg.map
/
LCGE	land use category in AIMCGE /CROP, PRM_FRS, MNG_FRS, CROP_FLW, GRAZING, GRASS,BIOCROP,URB,OTH/
MAP_LCGE(L,LCGE)/
CL	.	CROP
FRS	.	PRM_FRS
FRS	.	MNG_FRS
CROP_FLW	.	CROP_FLW
PAS	.	GRAZING
GL	.	GRASS
BIO	.	BIOCROP
SL	.	URB
OL	.	OTH
/
;

parameter
GHGL(R,Y,L)
Area_load(R,Y,L)
;

$gdxin '../output/gdx/all/analysis_%sce%_%CLP%_%IAV%%ModelInt%.gdx'
$load GHGL
$load Area_load=Area


*---GHG emissions

parameter
LUCHEM_P(Y,R,AEZ)
LUCHEM_N(Y,R,AEZ)
LUCHEM_P_load(*,Y,R,AEZ)
LUCHEM_N_load(*,Y,R,AEZ)
Planduse(Y,R,LCGE)
Planduse_load(*,Y,R,LCGE)
;

$gdxin '%prog_dir%/data/cgeoutput/analysis.gdx'
$load LUCHEM_P=LUCHEM_P_load
$load LUCHEM_N=LUCHEM_N_load
$load Planduse_load=Planduse

LUCHEM_P(Y,R2,AEZ)$SUM(R$MAP_RAGG(R,R2),LUCHEM_P("%sce%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ))=SUM(R$MAP_RAGG(R,R2),LUCHEM_P_load("%sce%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ));
LUCHEM_N(Y,R2,AEZ)$SUM(R$MAP_RAGG(R,R2),LUCHEM_N("%sce%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ))=SUM(R$MAP_RAGG(R,R2),LUCHEM_N_load("%sce%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ));
LUCHEM_P(Y,R,AEZ)=LUCHEM_P(Y,R,AEZ)/10**2;
LUCHEM_N(Y,R,AEZ)=LUCHEM_N(Y,R,AEZ)/10**2;


parameter
GHG(R,Y,*,SMODEL)
;

GHG(R,Y,"Emissions","LUM")=GHGL(R,Y,"LUC")-GHGL(R,Y,"AFR");
GHG(R,Y,"Sink","LUM")=GHGL(R,Y,"AFR");

GHG(R,Y,"Emissions","CGE")=SUM(AEZ,LUCHEM_P(Y,R,AEZ));
GHG(R,Y,"Sink","CGE")=SUM(AEZ,LUCHEM_N(Y,R,AEZ));

GHG(R,Y,"Net_emissions",SMODEL)=GHG(R,Y,"Emissions",SMODEL)+GHG(R,Y,"Sink",SMODEL);


* AREA comparison


Planduse(Y,R,LCGE)=Planduse_load("%sce%_%CLP%_%IAV%%ModelInt%",Y,R,LCGE);


parameter
AREA(R,Y,L,SMODEL)
;
AREA(R,Y,L,"LUM")=Area_load(R,Y,L);
*AREA(R,Y,"FRS","LUM")=Area_load(R,Y,"FRS")+Area_load(R,Y,"AFR");

AREA(R,Y,L,"CGE")$SUM(LCGE$MAP_LCGE(L,LCGE),Planduse(Y,R,LCGE))=SUM(LCGE$MAP_LCGE(L,LCGE),Planduse(Y,R,LCGE));

AREA(R2,Y,L,SMODEL)$SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL))=SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL));



execute_unload '../output/gdx/all/comparison_%sce%_%CLP%_%IAV%%ModelInt%.gdx'
GHG,AREA;

