$eolcom !!
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
$setglobal Livestockout_exe off
$setglobal WWFlandout_exe off
$setglobal wwfopt 1
$setglobal agmip on

set
R	17 regions	/
$include ../%prog_loc%/define/region/region17exclNations.set
$include ../%prog_loc%/define/region/region_iso.set
$include ../%prog_loc%/define/region/region5.set
World,Non-OECD,ASIA2
Industrial,Transition,Developing
$    ifthen.agmip %agmip%==on
      OSA
      FSU
      EUR
      MEN
*      SSA
      SEA
      OAS
      ANZ
*      NAM
      OAM
      AME
*      SAS
*      EUU
*      WLD
$  endif.agmip

/
RISO(R)	ISO countries /
$include ../%prog_loc%/define/region/region_iso.set
/
*Y year	/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
Y year	/
$if %end_year%==2100 2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100
$if %end_year%==2050 2005,2010,2020,2030,2040,2050
/
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
AFRTOT     afforestation (AFR in NoCC and AFR+NRF in BIOD)
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
DEGCUM	Cumulative decrease in grassland area GL from previou year
NRFABDCUM	Cumulative naturally regenerating managed forest area on abondoned land
NRGABDCUM	Cumulative naturally regenerating managed grassland on abondoned land

* degreaded soil
CLDEGS	cropland with degraded soil

* original
CLIR    cropland rainged
CLRF	cropland irrigated
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
LCROPIR(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR/
LCROPRF(L)/PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/
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
Emi_CO2_Lan_Use_Flo_Pos_Emi
Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha
Emi_CO2_Lan_Use_Flo_Neg_Seq
Emi_CO2_Lan_Use_Flo_Neg_Seq_Aff
Emi_CO2_Lan_Use_Flo_Neg_Seq_Man_For
Car_Seq_Lan_Use_Soi_Car_Man	Carbon Sequestration|Land Use|Soil Carbon Management
Emi_CO2_AFO_Lan_Aba_Man_Lan
Emi_CO2_AFO_Lan
Emi_CO2_AFO_Lan_Frs

*Variables added in MOEJ-IIASA
Lan_Cov_Frs_Frs_Old	Land Cover|Forest|Forest old
Lan_Cov_Frs_Def_Rat	Land Cover|Forest|Deforestation rate
Lan_Cov_Frs_Def_Cum	Land Cover|Forest|Deforestation|Cumulative
Lan_Cov_Oth_Nat_Lan_Res_Lan	Land Cover|Other Natual Land|Restoration Land
Emi_CO2_AFO_Aff		Emissions|CO2|AFOLU|Afforestation
Emi_CO2_AFO_Def		Emissions|CO2|AFOLU|Deforestation
Emi_CO2_AFO_For_Man		Emissions|CO2|AFOLU|Forest Management
Emi_CO2_AFO_Oth_Luc		Emissions|CO2|AFOLU|Other LUC

* Original
Car_Seq_Lan_Use_Soi_Car_Man_Cro	Carbon Sequestration|Land Use|Soil Carbon Management|Cropland
Car_Seq_Lan_Use_Soi_Car_Man_Gra	Carbon Sequestration|Land Use|Soil Carbon Management|Grassland
Lan_Cov_Frs_Agr	Land Cover| Agroforestry

Liv_Ani_Sto_Num_Rum	Livestock animal stock numbers|ruminant
Liv_Ani_Sto_Num_Nrm	Livestock animal stock numbers|non-ruminant
Liv_Ani_Sto_Num_Dry	Livestock animal stock numbers|dairy
ANNR_herd	Total livestock animal numbers including follower herd　Absolute number
ANNR_prod	Livestock numbers for producer animals (for slaughter)　Absolute number

/


MapLIAMPC(L,V)/
FRS	.	Lan_Cov_Frs
AFR	.	Lan_Cov_Frs
MNGFRS	.	Lan_Cov_Frs_Man
AFR	.	Lan_Cov_Frs_Man
UMNFRS	.	Lan_Cov_Frs_Nat_Frs
$if not %iav%==BIOD	NRFABDCUM	.	Lan_Cov_Frs_Nat_Frs
AFRTOT	.	Lan_Cov_Frs_Aff_and_Ref
DEF	.	Lan_Cov_Frs_Def_Rat
DEFCUM	.	Lan_Cov_Frs_Def_Cum
$if %WWFlandout_exe%==off	NRGABDCUM	.	Lan_Cov_Oth_Nat_Lan_Res_Lan
GL	.	Lan_Cov_Oth_Nat_Lan
AGOFRS	.	Lan_Cov_Frs_Agr

CL	.	Lan_Cov_Cro
BIO	.	Lan_Cov_Cro
CROP_FLW	.	Lan_Cov_Cro
CL	.	Lan_Cov_Cro_Non_Ene_Cro
CROP_FLW	.	Lan_Cov_Cro_Non_Ene_Cro
PAS	.	Lan_Cov_Pst
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
U/"million ha","Mt CO2/yr","million head"/
;

parameter
GHGL(R,Y,EmitCat,L)	MtCO2 per year in region R
GHGLR(Y,EmitCat,L,RISO)		GHG emission of land category L in year Y [MtCO2 per year]
Area_load(R,Y,L)
Ter_Bio_BII(R,Y)
;

$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load GHGL GHGLR
$load Area_load=Area


GHGL(RISO,Y,EmitCat,L)$GHGLR(Y,EmitCat,L,RISO)=GHGLR(Y,EmitCat,L,RISO);

*---GHG emissions

parameter
LUCHEM_P(Y,R,AEZ)
LUCHEM_N(Y,R,AEZ)
LUCHEM_P_load(*,Y,R,AEZ)
LUCHEM_N_load(*,Y,R,AEZ)
Planduse(Y,R,LCGE)
Planduse_load(*,Y,R,LCGE)
GHG(R,Y,*,SMODEL)	GHG emission of land category L in year Y [MtCO2 per year]
AREA(R,Y,L,SMODEL)	Regional area of land category L [kha]
IAMCTemp(R,V,U,Y)
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
AREA(R,Y,"DEGCUM","LUM")=sum(Y2$(%base_year%<=Y2.val AND Y2.val<=Y.val),Area_load(R,Y2,"DEG"));

AREA(R2,Y,L,SMODEL)$SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL))=SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL));

IAMCTemp(R,V,"million ha",Y)=SUM(L$(MapLIAMPC(L,V)),AREA(R,Y,L,"LUM"))/1000;
IAMCTemp(R,"Lan_Cov_Frs_Frs_Old","million ha",Y)$(AREA(R,"%base_year%","FRS","LUM"))=(AREA(R,"%base_year%","FRS","LUM")-AREA(R,Y,"DEFCUM","LUM"))/1000;


IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Pos_Emi","Mt CO2/yr",Y)=GHG(R,Y,"Emissions","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha","Mt CO2/yr",Y)=GHG(R,Y,"Emissions","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq","Mt CO2/yr",Y)=GHG(R,Y,"Sink","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq_Aff","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","AFRTOT");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq_Man_For","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","MNGFRS");   !!all managed forest is accounted which is not consistent with IAM convention but this account is based on the inventory guideline wherer managed land should be accounted
IAMCTemp(R,"Emi_CO2_AFO_Lan_Aba_Man_Lan","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","NRFABDCUM");   !!Account abandoned area

IAMCTemp(R,"Emi_CO2_AFO_Aff","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","AFRTOT");
*IAMCTemp(R,"Emi_CO2_AFO_For_Man","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","AFRTOT")+GHGL(R,Y,"Negative","NRFABDCUM");
IAMCTemp(R,"Emi_CO2_AFO_Def","Mt CO2/yr",Y)=GHGL(R,Y,"Positive","DEF");
IAMCTemp(R,"Emi_CO2_AFO_Oth_Luc","Mt CO2/yr",Y)=GHGL(R,Y,"Net","CL")+GHGL(R,Y,"Net","PAS")+GHGL(R,Y,"Net","CROP_FLW")+GHGL(R,Y,"Net","GL")+GHGL(R,Y,"Net","NRFABDCUM")+GHGL(R,Y,"Net","NRGABDCUM")+GHGL(R,Y,"Net","DEG");

IAMCTemp(R,"Emi_CO2_AFO_Lan","Mt CO2/yr",Y)=GHG(R,Y,"Net_emissions","LUM");
IAMCTemp(R,"Emi_CO2_AFO_Lan_Frs","Mt CO2/yr",Y)=GHGL(R,Y,"Net","FRS");

IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man_Cro","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","CROP_FLW")+GHGL(R,Y,"Negative","CLDEGS");
IAMCTemp(R,"Car_Seq_Lan_Use_Soi_Car_Man_Gra","Mt CO2/yr",Y)=GHGL(R,Y,"Negative","NRGABDCUM");
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



$ifthen.Livestockout_exe %Livestockout_exe%==on
set
Sl Set for types of livestock
C_AGMIP Commodity for agriculture in AgMIP/
$include ../%prog_loc%/individual/Livestock/cagmip.set
/
;
parameter
liv_reg(Sl,Y,R)	number of animals in each regions
liv_reg_a(C_AGMIP,Y,R)	number of animals in each regions
;

$gdxin '../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/livestock_distribution.gdx'
$load Sl,liv_reg

set
map_Sl_C_AgMIP(Sl,C_AGMIP)/
cattle_d	.	DRY
cattle_o	.	RUM
buffaloes	.	RUM
sheep	.	RUM
goats	.	RUM
*camels	.	NRM
*horses	.	RUM
*mules	.	RUM
*asses	.	RUM
swines	.	NRM
chickens	.	NRM
ducks	.	NRM
*turkeys	.	NRM
/
V_LIV(V)/
Liv_Ani_Sto_Num_Rum	Livestock animal stock numbers|ruminant
Liv_Ani_Sto_Num_Nrm	Livestock animal stock numbers|non-ruminant
Liv_Ani_Sto_Num_Dry	Livestock animal stock numbers|dairy
ANNR_herd	Total livestock animal numbers including follower herd　Absolute number
ANNR_prod	Livestock numbers for producer animals (for slaughter)　Absolute number
/
;

liv_reg_a(C_AGMIP,Y,R)=sum(Sl$(map_Sl_C_AgMIP(Sl,C_AGMIP)),liv_reg(Sl,Y,R));

IAMCTemp(R,"Liv_Ani_Sto_Num_Rum","million head",Y)=liv_reg_a("RUM",Y,R)/10**6;
IAMCTemp(R,"Liv_Ani_Sto_Num_Nrm","million head",Y)=liv_reg_a("NRM",Y,R)/10**6;
IAMCTemp(R,"Liv_Ani_Sto_Num_Dry","million head",Y)=liv_reg_a("DRY",Y,R)/10**6;

IAMCTemp(R,"ANNR_herd","million head",Y)=IAMCTemp(R,"Liv_Ani_Sto_Num_Rum","million head",Y)+IAMCTemp(R,"Liv_Ani_Sto_Num_Nrm","million head",Y)+IAMCTemp(R,"Liv_Ani_Sto_Num_Dry","million head",Y);

IAMCTemp(R,V,U,Y)$(V_LIV(V))=SUM(R2$MAP_RAGG(R2,R),IAMCTemp(R2,V,U,Y));

$endif.Livestockout_exe

$ifthen.wwflandout %WWFlandout_exe%==on

parameter
VW_reg(Y,L,R)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance in region R (kha)
;

$gdxin '../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/%SCE%_%CLP%_%IAV%%ModelInt%_opt%wwfopt%.gdx'
$load VW_reg


IAMCTemp(R,"Lan_Cov_Oth_Nat_Lan_Res_Lan","million ha",Y)=VW_reg(Y,"RES",R)/1000;


$endif.wwflandout

IAMCTempwoU(R,V,Y)=SUM(U,IAMCTemp(R,V,U,Y));

execute_unload '../output/gdx/comparison/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
GHG,GHGL,AREA,IAMCTemp,IAMCTempwoU;





