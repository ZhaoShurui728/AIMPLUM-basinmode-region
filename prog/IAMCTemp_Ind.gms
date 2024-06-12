$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_loc ../AIMPLUM
$Setglobal prog_loc
$setglobal SCE SSP2
$setglobal CLP BaU
$setglobal IAV NoCC
$setglobal ModelInt
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%
$setglobal PREDICTS_exe off

set
R	17 regions	/
$include ../%prog_loc%/define/region/region17.set
World
R5ASIA
"R5OECD90+EU"
R5REF
R5MAF
R5LAM
/
Y year	/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
L land use type /
PRM_SEC forest + grassland + pasture
FRSGL   forest + grassland
HAV_FRS        production forest
FRS     forest
GL      grassland
AFR     afforestation
CL      cropland
CROP_FLW        fallow land
PAS     grazing pasture
BIO     bio crops
SL      built_up
OL      ice or water
RES	restoration land that was used for cropland or pasture and set aside for restoration

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

* total
LUC	land use change total

* crop types
PDR     rice
WHT     wheat
GRO     other coarse grain
OSD     oil crops
C_B     sugar crops
OTH_A   other crops

* crop types with irrigation/rainfed
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
DEFCUM	Cumulative deforestation area
/
AEZ	/AEZ1*AEZ18/
SGHG	/CO2/
C	/AL/
A	/FRS/
SMODEL	/CGE,LUM/
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
"Prev"		Previous version of emissions
/
;
Alias(R,R2),(Y,Y2);

set
MAP_RAGG(R,R2)	/
$include ../%prog_loc%/define/region/region17_agg.map
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
V/
Lan_Cov
Lan_Cov_Bui_Are
Lan_Cov_Cro
Lan_Cov_Cro_Irr
Lan_Cov_Cro_Ene_Cro
Lan_Cov_Cro_Ene_Cro_Irr
Lan_Cov_Frs
Lan_Cov_Frs_Aff_and_Ref
Lan_Cov_Frs_Frs
Lan_Cov_Frs_Frs_Har_Are
Lan_Cov_Frs_Nat_Frs
Lan_Cov_Oth_Ara_Lan
Lan_Cov_Oth_Lan
Lan_Cov_Oth_Nat_Lan
Lan_Cov_Pst
Lan_Cov_Frs_Man
Lan_Cov_Cro_Cer
Lan_Cov_Cro_Ric
Lan_Cov_Cro_Whe
Lan_Cov_Cro_Coa_gra
Lan_Cov_Cro_Oil_See
Lan_Cov_Cro_Dou
Lan_Cov_Cro_Rai
Lan_Cov_Wat_Eco_Frs
Lan_Cov_Wat_Eco_Gla
Lan_Cov_Wat_Eco_Lak
Lan_Cov_Wat_Eco_Mou
Lan_Cov_Wat_Eco_Wet
Lan_Cov_Cro_Non_Ene_Cro
Lan_Cov_Cro_Ene_Cro_1st_gen
Lan_Cov_Cro_Ene_Cro_2nd_gen
Lan_Cov_Frs_Sec
Emi_CO2_Lan_Use_Flo_Neg_Seq_Aff
Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha
Car_Seq_Lan_Use_Soi_Car_Man	Carbon Sequestration|Land Use|Soil Carbon Management

*Variables added in MOEJ-IIASA
Lan_Cov_Frs_Frs_Old
Lan_Cov_Frs_Def_Rat
Lan_Cov_Frs_Def_Cum
Lan_Cov_Oth_Nat_Lan_Res_Lan
Emi_CO2_AFO_Aff
Emi_CO2_AFO_Def
Emi_CO2_AFO_For_Man
Emi_CO2_AFO_Oth_Luc

* Original
Car_Seq_Lan_Use_Soi_Car_Man_Cro	Carbon Sequestration|Land Use|Soil Carbon Management|Cropland
Car_Seq_Lan_Use_Soi_Car_Man_Gra	Carbon Sequestration|Land Use|Soil Carbon Management|Grassland
/

* forest subcategory
PRMFRS	primary forest
SECFRS	secoundary forest excl AFR
MNGFRS  managed forest excl AFR
UMNFRS  unmanage forest
NRMFRS  naturally regenerating managed forest
PLNFRS  planted forest excl AFR
AGOFRS	agroforestry


MapLIAMPC(L,V)/
FRS	.	Lan_Cov_Frs
AFR	.	Lan_Cov_Frs
MNGFRS	.	Lan_Cov_Frs_Man
AFR	.	Lan_Cov_Frs_Man
UMNFRS	.	Lan_Cov_Frs_Nat_Frs
AFR	.	Lan_Cov_Frs_Aff_and_Ref
NRFABD	.	Lan_Cov_Frs_Aff_and_Ref
DEF	.	Lan_Cov_Frs_Def_Rat

CL	.	Lan_Cov_Cro
BIO	.	Lan_Cov_Cro
CROP_FLW	.	Lan_Cov_Cro
CL	.	Lan_Cov_Cro_Non_Ene_Cro
CROP_FLW	.	Lan_Cov_Cro_Non_Ene_Cro
PAS	.	Lan_Cov_Pst
GL	.	Lan_Cov_Oth_Nat_Lan
BIO	.	Lan_Cov_Cro_Ene_Cro_2nd_gen
BIO	.	Lan_Cov_Cro_Ene_Cro
SL	.	Lan_Cov_Bui_Are

GRO .   Lan_Cov_Cro_Cer
PDR .   Lan_Cov_Cro_Cer
WHT .   Lan_Cov_Cro_Cer
GRO .   Lan_Cov_Cro_Coa_gra

OSD .   Lan_Cov_Cro_Oil_See
PDR .   Lan_Cov_Cro_Ric
WHT .   Lan_Cov_Cro_Whe
PDRIR   .   Lan_Cov_Cro_Irr
WHTIR   .   Lan_Cov_Cro_Irr
GROIR   .   Lan_Cov_Cro_Irr
OSDIR   .   Lan_Cov_Cro_Irr
C_BIR   .   Lan_Cov_Cro_Irr
OTH_AIR   .   Lan_Cov_Cro_Irr
PDRRF   .   Lan_Cov_Cro_Rai
WHTRF   .   Lan_Cov_Cro_Rai
GRORF   .   Lan_Cov_Cro_Rai
OSDRF   .   Lan_Cov_Cro_Rai
C_BRF   .   Lan_Cov_Cro_Rai
OTH_ARF   .   Lan_Cov_Cro_Rai

/
U/"million ha","Mt CO2/yr"/
;

parameter
GHGL(R,Y,EmitCat,L)
Area_load(R,Y,L)
Ter_Bio_BII(R,Y)
;

$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
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
GHG(R,Y,*,SMODEL)
AREA(R,Y,L,SMODEL)
IAMCTemp(*,*,*,*)
IAMCTempwoU(R,V,Y)
;

$gdxin '../%prog_loc%/data/cgeoutput/analysis.gdx'
$load Planduse_load=Planduse
$ontext
$load LUCHEM_P=LUCHEM_P_load
$load LUCHEM_N=LUCHEM_N_load

LUCHEM_P(Y,R2,AEZ)$SUM(R$MAP_RAGG(R,R2),LUCHEM_P("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ))=SUM(R$MAP_RAGG(R,R2),LUCHEM_P_load("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ));
LUCHEM_N(Y,R2,AEZ)$SUM(R$MAP_RAGG(R,R2),LUCHEM_N("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ))=SUM(R$MAP_RAGG(R,R2),LUCHEM_N_load("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ));
LUCHEM_P(Y,R,AEZ)=LUCHEM_P(Y,R,AEZ)/10**2;
LUCHEM_N(Y,R,AEZ)=LUCHEM_N(Y,R,AEZ)/10**2;
GHG(R,Y,"Emissions","CGE")=SUM(AEZ,LUCHEM_P(Y,R,AEZ));
GHG(R,Y,"Sink","CGE")=SUM(AEZ,LUCHEM_N(Y,R,AEZ));
$offtext


GHG(R,Y,"Emissions","LUM")=GHGL(R,Y,"Positive","LUC");
GHG(R,Y,"Sink","LUM")=GHGL(R,Y,"Negative","LUC");
GHG(R,Y,"Net_emissions",SMODEL)=GHG(R,Y,"Emissions",SMODEL)+GHG(R,Y,"Sink",SMODEL);

* AREA comparison
Planduse(Y,R,LCGE)=Planduse_load("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,LCGE);
AREA(R,Y,L,"CGE")$SUM(LCGE$MAP_LCGE(L,LCGE),Planduse(Y,R,LCGE))=SUM(LCGE$MAP_LCGE(L,LCGE),Planduse(Y,R,LCGE));
AREA(R,Y,L,"LUM")=Area_load(R,Y,L);
AREA(R,Y,"DEFCUM","LUM")=sum(Y2$(%base_year%<=Y2.val AND Y2.val<=Y.val),Area_load(R,Y2,"DEF"));

AREA(R2,Y,L,SMODEL)$SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL))=SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL));

IAMCTemp(R,V,"million ha",Y)=SUM(L$(MapLIAMPC(L,V)),AREA(R,Y,L,"LUM"))/1000;
IAMCTemp(R,"Lan_Cov_Frs_Def_Cum","million ha",Y)=AREA(R,Y,"DEFCUM","LUM")/1000;
IAMCTemp(R,"Lan_Cov_Frs_Frs_Old","million ha",Y)$(AREA(R,"%base_year%","FRS","LUM"))=(AREA(R,"%base_year%","FRS","LUM")-AREA(R,Y,"DEFCUM","LUM"))/1000;
IAMCTemp(R,"Lan_Cov_Oth_Nat_Lan_Res_Lan","million ha",Y)=AREA(R,Y,"NRGABD","LUM")/1000;


IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Pos_Emi","Mt CO2/yr",Y)=GHG(R,Y,"Emissions","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha","Mt CO2/yr",Y)=GHG(R,Y,"Emissions","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq","Mt CO2/yr",Y)=GHG(R,Y,"Sink","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq_Aff","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","AFR");
*IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq_Man_For","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","NRFABD");

IAMCTemp(R,"Emi_CO2_AFO_Aff","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","AFR");
*IAMCTemp(R,"Emi_CO2_AFO_For_Man","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","AFR")+GHGL(R,Y,"Negative","NRFABD");
IAMCTemp(R,"Emi_CO2_AFO_Def","Mt CO2/yr",Y)=GHGL(R,Y,"Positive","DEF");
IAMCTemp(R,"Emi_CO2_AFO_Oth_Luc","Mt CO2/yr",Y)=GHGL(R,Y,"Net","CL")+GHGL(R,Y,"Net","PAS")+GHGL(R,Y,"Net","BIO")+GHGL(R,Y,"Net","GL")+GHGL(R,Y,"Negative","NRFABD")+GHGL(R,Y,"Negative","NRGABD");

IAMCTemp(R,"Emi_CO2_AFO_Lan","Mt CO2/yr",Y)=GHG(R,Y,"Net_emissions","LUM");
IAMCTemp(R,"Emi_CO2_AFO_Lan_Frs","Mt CO2/yr",Y)=GHGL(R,Y,"Net","FRS");

IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man_Cro","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","CROP_FLW");
IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man_Gra","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","NRGABD");
IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man","Mt CO2/yr",Y)=IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man_Cro","Mt CO2/yr",Y)+IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man_Gra","Mt CO2/yr",Y);



$ifthen.PREDICTS_exe %PREDICTS_exe%==on

table
Ter_Bio_BII(R,Y)
$ondelim
$offlisting
$include ../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/BII_regionagg_prod_%SCE%_%CLP%_%IAV%%ModelInt%_IAMCTemp.csv
$onlisting
$offdelim
;

IAMCTemp(R,"Terrestrial Biodiversity|BII","%",Y)=Ter_Bio_BII(R,Y)*100;

$endif.PREDICTS_exe

IAMCTempwoU(R,V,Y)=SUM(U,IAMCTemp(R,V,U,Y));

execute_unload '../output/gdx/comparison/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
GHG,GHGL,AREA,IAMCTemp,IAMCTempwoU;

