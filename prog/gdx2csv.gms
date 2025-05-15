$Setglobal prog_loc
$setglobal sce SSP3
$setglobal clp BaU
$setglobal iav NoCC
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%

$Setglobal base_year 2005
$Setglobal end_year 2100
$setglobal lumip off
$setglobal bioyieldcalc off
$setglobal gdxout on
$setglobal wwfclass on
$setglobal carseq off
$setglobal afftype off
$setglobal agmip off
$setglobal livdiscalc off

* wwf should be selected from  off, on
*off)  native classifications.
*on)   wwf classification

* wwf classification
*OPTIONS
*NoBIOD: all abandonned land that is not restored is re-classified as restored straight away
*BIOD; all abandonned land that is not restored is re-classified as restored but only after 30 years - within these 30 years it remains classified as its original pre-abandonnment land use)

$if exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/%sce%.gms
$if not exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/SSP2.gms
$if exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/%clp%.gms
$if not exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/BaU.gms
$if exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/%iav%.gms
$if not exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/NoCC.gms


$ifthen.split %split%==1

Set
R	17 regions	/
$include ../%prog_loc%/define/region/region17.set
$include ../%prog_loc%/define/region/region5.set
$include ../%prog_loc%/define/region/region10.set
World,Non-OECD,ASIA2,R2OECD,R2NonOECD
Industrial,Transition,Developing
$    ifthen.agmip %agmip%==on
      OSA
      FSU
      EUR
      MEN
      SSA
      SEA
      OAS
      ANZ
      NAM
      OAM
      AME
      SAS
      EUU
      WLD
$  endif.agmip
/
MAP_Ragg(R,R)/
$include ../%prog_loc%/define/region/region17_agg.map
/
G	Cell number  /1 * 259200/
I	Vertical position (LAT)	/ 1*360 /
J	Horizontal position (LON)	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
Y	Year	/
$if %end_year%==2100 2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100
$if %end_year%==2050 2005,2010,2020,2030,2040,2050
/
L land use type /
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
BIOP	potentail biocrop land
ONV	other natural vegetation
PROTECT protected area
RES	restoration land that was used for cropland or pasture and set aside for restoration (only from 2020 onwards)

* total
LUC
TOT	total

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
DEG

* BtC
*abandoned land with original land category
ABD_CL
ABD_CROP_FLW
ABD_BIO
ABD_PAS
ABD_MNGFRS
ABD_AFR
/
LAFR(L)/AFR/
Lused(L)/MNGFRS,AFR,CL,CROP_FLW,BIO,PAS/
Lnat(L)/GL,UMNFRS/
LABD(L)/ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR/
LRES(L)/RES/
LABL(L)/AFR,BIO,LUC/
*NLFRSGL/CL,CROP_FLW,BIO,PAS,MNGFRS,AFR,ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR,SL,OL/
Lmip/
$include ../%prog_loc%/define/lumip.set
rice
wheat
maize
sugarcrops
oilcrops
othercrops
*	Irrigation (units fraction of grid area) Temporary to calculate fraction to cropland area
	irrig_c3ann_g
	irrig_c3per_g
	irrig_c4ann_g
	irrig_c4per_g
	irrig_c3nfx_g
	flood_g
*	Biofuel crops (units fraction of grid area) Temporary to calculate fraction to cropland area
	cpbf1_c3ann_g
	cpbf1_c4ann_g
	cpbf1_c3per_g
	cpbf1_c4per_g
	cpbf1_c3nfx_g
	cpbf2_c3ann_g
	cpbf2_c4ann_g
	cpbf2_c3per_g
	cpbf2_c4per_g
	cpbf2_c3nfx_g
* protected area
  prtct_all   all protected fraction (this is not lumip category)
/
MAP_LUMIP(Lmip,L)/
$include ../%prog_loc%/define/lumip.map
rice	.	PDR
wheat	.	WHT
maize	.	GRO
sugarcrops	.	C_B
oilcrops	.	OSD
othercrops	.	OTH_A
/
MAP_RIJ(R,I,J)
MAP_RG(R,G)
MAP_CL(L,L) cropland aggregation map/
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
/
;
Alias (I,I2),(J,J2),(L,L2,L3,LL),(Y,Y2,Y3),(R,R2),(Lmip,Lmip2,Lmip3);

parameter
FLAG_G(G)		Grid flag
FLAG_IJ(I,J)		Grid flag
Rarea_bio(G)
VY_load(R,Y,L,G)
VY_IJ(Y,L,I,J)
VY_IJmip(Y,Lmip,I,J)
YIELD_BIO(R,Y,G)
YIELD_IJ(Y,L,I,J) tCO2 per ha per year
GHGLG(Y,L,G)	MtCO2 per grid per year
GHG_IJ(Y,L,I,J)	MtCO2 per grid per year
GHGLGC(Y,L,G)	cumulative emissions or sequestration from base year to the year Y (MtCO2 per grid)
GHGC_IJ(Y,L,I,J)	cumulative emissions or sequestration from base year to the year Y (MtCO2 per grid)
GAIJ(I,J)           Grid area of cell I J kha
GAIJ0(I,J)           Grid area of cell I J million ha
Y_step /10/
Ynum/
$if %end_year%==2100 11
$if %end_year%==2050 6
/
;

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load Map_GIJ MAP_RIJ GAIJ MAP_RG

FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;

$endif.split
$if %split%==1 $exit


$ifthen.livdis %livdiscalc%==on

set
Sl Set for types of livestock
Slnum/1*8/
;
parameter
liv_dist(Sl,Y,I,J)	number of animals in a grid cell I J (head)
liv_distnum(Slnum,Y,I,J)	number of animals in a grid cell I J (head)
BW_map(Sl,I,J) body weight of animals (kg body weight per head)
BW_mapnum(Slnum,I,J) body weight of animals (kg body weight per head)
;

$gdxin '../%prog_loc%/individual/Livestock/livestock_base.gdx'
$load Sl BW_map

$gdxin '../output/gdx/analysis/livdis_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load liv_dist

set
MAP_Slnum(Slnum,Sl)/
1	.	cattle_d
2	.	cattle_o
3	.	buffaloes
4	.	sheep
5	.	goats
6	.	swines
7	.	chickens
8	.	ducks
/
;

liv_distnum(Slnum,Y,I,J)=sum(Sl$(MAP_Slnum(Slnum,Sl)),liv_dist(Sl,Y,I,J));

* put -99 for missing values for both terrestiral and ocean pixels. Then define -999 as NaN when making netCDF files.
liv_distnum(Slnum,Y,I,J)$(sum(R$MAP_RIJ(R,I,J),1)=0 and liv_distnum(Slnum,Y,I,J)=0)=-99;

BW_mapnum(Slnum,I,J)=sum(Sl$(MAP_Slnum(Slnum,Sl)),BW_map(Sl,I,J));
BW_mapnum(Slnum,I,J)$(sum(R$MAP_RIJ(R,I,J),1)=0 and BW_mapnum(Slnum,I,J)=0)=-99;


file output / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/livestock_distribution.csv" /;
put output;
output.pw=32767;
put "Livestock_number", "= "/;

loop(Y,
 loop(Slnum,
  loop(I,
   loop(J,
    output.nd=10; output.nz=0; output.nr=0; output.nw=15;
    put liv_distnum(Slnum,Y,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Slnum)=8 AND ORD(Y)=Ynum),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;



file output_bw_map / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/BW_map.csv" /;
put output_bw_map;
output_bw_map.pw=32767;
put "BodyWeight", "= "/;
loop(Slnum,
 loop(I,
  loop(J,
   output_bw_map.nd=10; output_bw_map.nz=0; output_bw_map.nr=0; output_bw_map.nw=15;
   put BW_mapnum(Slnum,I,J);
   IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Slnum)=8),put ",";
   ELSE put ";";
   );
  );
put /;
);
);
put /;


$exit
$endif.livdis

*------------------------------
* Carbon sink land intensity calc
*-----------------------------
set
LVST/
AFR00	control(actual biome)
AFRMAX	foresttype with maximum carbon sink in each grid
AFRDIV	foresttype with maximum carbon sink considering biodiversity in each grid
AFRCUR
/
;
parameter
ACFout(LVST,R,G)	average carbon flow in grid G adjusted using VISIT estimates [MgC per ha per year]
;

$ifthen.bioyield %bioyieldcalc%==on
$gdxin '../output/gdx/analysis/bioyield_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load YIELD_BIO

YIELD_IJ(Y,"BIO",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,YIELD_BIO(R,Y,G)));

$gdxin '../%prog_loc%/data/visit_forest_growth_function.gdx'
$load ACFout

$ifthen %afftype%==cact_vst
YIELD_IJ("2005","AFR",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,ACFout("AFR00",R,G)));
$elseif %afftype%==cdiv_vst
YIELD_IJ("2005","AFR",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,ACFout("AFRDIV",R,G)));
$elseif %afftype%==cmax_vst
YIELD_IJ("2005","AFR",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,ACFout("AFRMAX",R,G)));
$elseif %afftype%==ccur_vst
YIELD_IJ("2005","AFR",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,ACFout("AFRCUR",R,G)));
$else
YIELD_IJ("2005","AFR",I,J)$FLAG_IJ(I,J)=0;
$endif

$batinclude ../%prog_loc%/inc_prog/outputcsv_yield.gms BIO
$batinclude ../%prog_loc%/inc_prog/outputcsv_yield.gms AFR

$exit
$endif.bioyield

*------------------------------
* Carbon sink calc
*-----------------------------
$ifthen.carseq %carseq%==on
$gdxin '../output/gdx/analysis/base_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load GHGLG

GHG_IJ(Y,L,I,J)$(FLAG_IJ(I,J))=SUM(G$(MAP_GIJ(G,I,J) and GHGLG(Y,L,G)),GHGLG(Y,L,G));
GHGC_IJ(Y,L,I,J)$(LABL(L) and FLAG_IJ(I,J))=GHG_IJ("2010",L,I,J)*5 + sum(Y2$(ordy("2020")<=ordy(Y2) and ordy(Y2)<=ordy(Y) and GHG_IJ(Y2,L,I,J)),GHG_IJ(Y2,L,I,J)*Y_step);

$batinclude ../%prog_loc%/inc_prog/outputcsv_ghg.gms AFR
$batinclude ../%prog_loc%/inc_prog/outputcsv_ghg.gms BIO
$batinclude ../%prog_loc%/inc_prog/outputcsv_ghg.gms LUC

$exit
$endif.carseq


$ifthen.p %lumip%==on

set
Lmip_fracmap(Lmip,Lmip,Lmip)/
* Irrigation (units fraction of grid area)
irrig_c3ann	.	irrig_c3ann_g	.	c3ann
irrig_c3per	.	irrig_c3per_g	.	c3per
irrig_c4ann	.	irrig_c4ann_g	.	c4ann
irrig_c4per	.	irrig_c4per_g	.	c4per
irrig_c3nfx	.	irrig_c3nfx_g	.	c3nfx
flood	.	flood_g	.	c3ann
* Biofuel crops (fraction of crop type area occupied by biofuel crops)
cpbf1_c3ann	.	cpbf1_c3ann_g	.	c3ann
cpbf1_c4ann	.	cpbf1_c4ann_g	.	c4ann
cpbf1_c3per	.	cpbf1_c3per_g	.	c3per
cpbf1_c4per	.	cpbf1_c4per_g	.	c4per
cpbf1_c3nfx	.	cpbf1_c3nfx_g	.	c3nfx
cpbf2_c3ann	.	cpbf2_c3ann_g	.	c3ann
cpbf2_c4ann	.	cpbf2_c4ann_g	.	c4ann
cpbf2_c3per	.	cpbf2_c3per_g	.	c3per
cpbf2_c4per	.	cpbf2_c4per_g	.	c4per
cpbf2_c3nfx	.	cpbf2_c3nfx_g	.	c3nfx
/
Lmip_out(Lmip) Lmip to be included in nc file/
c3ann
c4ann
c3per
c4per
c3nfx
range
pastr
primf
secdf
primn
secdn
urban
pltns
irrig_c3ann
irrig_c4ann
irrig_c3per
irrig_c4per
irrig_c3nfx
cpbf2_c4per
flood
fallow
rice
wheat
maize
sugarcrops
oilcrops
othercrops
icwtr
prtct_primf protected fraction of primary forest
prtct_primn protected fraction of primary non-forest
prtct_secdf protected fraction of secondary forest
prtct_secdn protected fraction of secondary non-forest
prtct_all   all protected fraction (this is not lumip category)
/
;
parameter
VYL_protect(R,Y,Lmip,G)	a fraction of land-use L region R in year Y grid G
VYL_protectIJ(Y,Lmip,I,J)	a fraction of land-use L region R in year Y grid G
;

$gdxin '../output/gdx/results/analysis_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VY_load=VYL
;
$gdxin '../output/gdx/analysis/base_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VYL_protect
;

* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
VY_IJ(Y,L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R$(MAP_RG(R,G)),VY_load(R,Y,L,G))/SUM(R$(MAP_RG(R,G)),1));
VY_IJ(Y,L,I,J)$(sum(L2$(MAP_CL(L2,L)),VY_IJ(Y,L2,I,J)))=sum(L2$(MAP_CL(L2,L)),VY_IJ(Y,L2,I,J));
VYL_protectIJ(Y,Lmip,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R$(MAP_RG(R,G)),VYL_protect(R,Y,Lmip,G))/SUM(R$(MAP_RG(R,G)),1));

VY_IJmip(Y,Lmip,I,J)=SUM(L$MAP_LUMIP(Lmip,L),VY_IJ(Y,L,I,J));
VY_IJmip(Y,Lmip,I,J)$(SUM((Lmip2,Lmip3)$Lmip_fracmap(Lmip,Lmip2,Lmip3),VY_IJmip(Y,Lmip3,I,J)))=SUM((Lmip2,Lmip3)$Lmip_fracmap(Lmip,Lmip2,Lmip3),VY_IJmip(Y,Lmip2,I,J))/SUM((Lmip2,Lmip3)$Lmip_fracmap(Lmip,Lmip2,Lmip3),VY_IJmip(Y,Lmip3,I,J));
VY_IJmip(Y,Lmip,I,J)$(VYL_protectIJ(Y,Lmip,I,J))=VYL_protectIJ(Y,Lmip,I,J);
VY_IJmip(Y,Lmip,I,J)$(sum((Lmip2,Y2),VY_IJmip(Y2,Lmip2,I,J))=0 and VY_IJmip(Y,Lmip,I,J)=0 and Lmip_out(Lmip))=-99;

$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms c3ann
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms c4ann
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms c3per
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms c4per
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms c3nfx
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms range
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms pastr
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms primf
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms secdf
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms primn
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms secdn
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms urban
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms pltns
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c3ann
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c4ann
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c3per
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c4per
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c3nfx
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms cpbf2_c4per
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms flood
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms fallow
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms rice
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms wheat
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms maize
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms sugarcrops
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms oilcrops
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms othercrops
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms icwtr
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms prtct_all
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms prtct_primf
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms prtct_primn
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms prtct_secdf
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms prtct_secdn


$ifthen.gdxout %gdxout%==on
execute_unload '../output/gdx/analysis/lumip_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
VY_IJmip
;
$endif.gdxout


$elseif.p %lumip%_%wwfclass%==off_on

set
Lwwfnum/1*17/
;
parameter
plwwfnum/17/
VY_IJwwfnum(Y,Lwwfnum,I,J)
;

$gdxin '../output/gdx/analysis/restore_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VY_IJwwfnum


file output / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/%SCE%_%CLP%_%IAV%%ModelInt%.csv" /;
put output;
*output.pw=100000;
output.pw=32767;
put "LC_area_share", "= "/;

loop(Y,
 loop(Lwwfnum,
  loop(I,
   loop(J,
    output.nd=10; output.nz=0; output.nr=0; output.nw=15;
    put VY_IJwwfnum(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=plwwfnum AND ORD(Y)=Ynum),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;

* Pixel area

GAIJ0(I,J)$GAIJ(I,J)=GAIJ(I,J)/1000;
GAIJ0(I,J)$(GAIJ(I,J)=0)=-99;

file output_pixel_area / "../output/csv/pixel_area.csv" /;
put output_pixel_area;
*output_pixel_area.pw=100000;
output_pixel_area.pw=32767;
put "pixel_area", "= "/;

 loop(I,
  loop(J,
    output_pixel_area.nd=10; output_pixel_area.nz=0; output_pixel_area.nr=0; output_pixel_area.nw=15;
    put GAIJ0(I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
put /;


* Protected area
$ontext

parameter
protectfracL(R,G,L)	Protected area fraction (0 to 1) of land category L in each cell G
protectfracLIJ(Y,I,J)	Protected area fraction (0 to 1) of land category L in each cell I J
;
protectfracLIJ(Y,I,J)=0;

$ifthen.protect not %IAV%==NoCC

$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%.gdx'
$load protectfracL

protectfracLIJ(Y,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,protectfracL(R,G,"PRM_SEC")+protectfracL(R,G,"CL")));

$endif.protect

$if %CLP%==BaU protectfracIJ(I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,protectfrac(R,"2010",G)));

file output_protect / "../output/csv/%SCE%_%CLP%_%IAV%_protect.csv" /;
put output_protect;
*output_protect.pw=100000;
output_protect.pw=32767;
put " protected_pixel_area_share", "= "/;

protectfracLIJ(Y,I,J)$(protectfracLIJ(Y,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;

protectfracLIJ(Y,I,J)$(protectfracLIJ(Y,I,J)=0 AND FLAG_IJ(I,J))=0;


loop(Y,
 loop(I,
  loop(J,
    output_protect.nd=10; output_protect.nz=0; output_protect.nr=0; output_protect.nw=15;
    put protectfracLIJ(Y,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
);
put /;
$offtext



$else.p


*$batinclude %prog_loc%/inc_prog/outputcsv.gms FRS
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms PAS
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms CL
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms BIO
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms SL
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms OL
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms GL
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms PRMFRS
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms MNGFRS
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms RES
$batinclude ../%prog_loc%/inc_prog/outputcsv.gms AFR

$endif.p






$exit









