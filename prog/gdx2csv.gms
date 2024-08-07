$Setglobal prog_loc
$setglobal sce SSP3
$setglobal clp BaU
$setglobal iav NoCC
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%

$Setglobal base_year 2005
$setglobal lumip off
$setglobal bioyieldcalc off
$setglobal livdiscalc off
$setglobal gdxout on
$setglobal wwfclass opt
$setglobal wwfopt 1
$setglobal carseq off
$setglobal afftype off
$setglobal agmip off
* wwf should be selected from  off, on, opt.
*off)  native classifications.
*on)   wwf classification
*opt)  wwf classification with the following options.

* wwfopt should be selected from  1 to 5.
*OPTIONS
*opt1) wwf classification in numbers as it is
*opt2) all abandonned land that is not restored is re-classified as restored but only after 30 years - within these 30 years it remains classified as its original pre-abandonnment land use); no change in number of classes in LU netcdfs
*opt3) same as 2, but with 4 additional LU classes(*) in the netcdfs (with potentially non-zero values)

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
World,Non-OECD,ASIA2
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
Y	Year	/2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100/

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
AFRTOT     afforestation (AFR in NoCC and AFR+NRF in BIOD) consistent with GHG calc
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
NRFABD	naturally regenerating managed forest on abondoned land
NRGABD	naturally regenerating managed grassland on abondoned land
DEF	deforestion (decrease in forest area FRS from previou year)
DEG

* BtC
*abondoned land with original land category
ABD_CL
ABD_CROP_FLW
ABD_BIO
ABD_PAS
ABD_MNGFRS
ABD_AFR
/
LAFR(L)/AFR/
LAFRTOT(L)/AFRTOT/
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
Alias (I,I2),(J,J2),(L,L2,L3,LL),(Y,Y2,Y3),(R,R2);

parameter
FLAG_G(G)		Grid flag
FLAG_IJ(I,J)		Grid flag
Rarea_bio(G)

VY_load(R,Y,L,G)
VYLY_load(R,Y,Y,L,G)
VY_IJ(Y,L,I,J)
VY_IJmip(Y,Lmip,I,J)
YIELD_BIO(R,Y,G)
YIELD_IJ(Y,L,I,J) tCO2 per ha per year
GHGLG(Y,L,G)	MtCO2 per grid per year
GHG_IJ(Y,L,I,J)	MtCO2 per grid per year
GHGLGC(Y,L,G)	cumulative emissions or sequestration from base year to the year Y (MtCO2 per grid)
GHGC_IJ(Y,L,I,J)	cumulative emissions or sequestration from base year to the year Y (MtCO2 per grid)
VY_loadAFRbaunocc(R,Y,LAFR,G)
VY_IJAFRbaunocc(Y,I,J)
VY_loadAFRbaubiod(R,Y,LAFR,G)
VY_IJAFRbaubiod(Y,I,J)
VY_IJ_res(Y,L,I,J)
VY_IJ_delay(Y,L,I,J)
GAIJ(I,J)           Grid area of cell I J kha
GAIJ0(I,J)           Grid area of cell I J million ha
Y_step /10/
;

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load Map_GIJ MAP_RIJ GAIJ MAP_RG

FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;

$gdxin '../output/gdx/results/results_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VY_load=VYL
$load VYLY_load=VYLY

* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
VY_IJ(Y,L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R$(MAP_RG(R,G)),VY_load(R,Y,L,G))/SUM(R$(MAP_RG(R,G)),1));
VY_IJ(Y,L,I,J)$(FLAG_IJ(I,J) and LAFRTOT(L))=SUM(G$(MAP_GIJ(G,I,J)),SUM(R$(MAP_RG(R,G)),VYLY_load(R,Y,Y,L,G))/SUM(R$(MAP_RG(R,G)),1));
VY_IJ(Y,L,I,J)$(sum(L2$(MAP_CL(L2,L)),VY_IJ(Y,L2,I,J)))=sum(L2$(MAP_CL(L2,L)),VY_IJ(Y,L2,I,J));


* [BTC] Restored land
set
MAP_Abandoned(L,L)/
CL	.	ABD_CL
CROP_FLW	.	ABD_CROP_FLW
BIO	.	ABD_BIO
PAS	.	ABD_PAS
MNGFRS	.	ABD_MNGFRS
AFR	.	ABD_AFR
/
MAP_AB2RES(L,L)/
ABD_CL	.	RES
ABD_CROP_FLW	.	RES
ABD_BIO	.	RES
ABD_PAS	.	RES
ABD_MNGFRS	.	RES
ABD_AFR	.	RES
/
;

parameter
ordy(Y)
deltaY(Y,L,I,J)	Land area difference of land use category L and year Y from year Y-1
deltaZ(Y,I,J)	Total abundant area increments from year Y-1 to year Y (always positive)
deltaX(Y,L,I,J)	Abandoned area in categories with original land categories
X(Y,L,I,J) 	Abandoned area of land use category i and year t only considering increase of abandoned area
XF(Y,L,I,J) 	Abandoned area of land use category i and year t (final outcome)
Remain(Y,L,I,J)		Land area of land use category i and year t that can be abandoned or restored
RPA(Y,L,Y2,I,J)	Restore potential land area of land use category L and year Y that has been categorized as abandoned (abandoned-crop abandoned-pasture and abandoned-biocrop) from the year Y2
RSP(Y,L,Y2,I,J)	Restored potential land area of land use category i and year Y from the year Y2 but it includes the land that is reused by human activity
RSfrom(Y,L,Y2,I,J)	Restore land area originally categorized as land use category L and year Y from the year Y2
RS(Y,L,Y2,I,J)	Restore land area of land use category L and year Y from the year Y2 (final outcome)
RSF(Y,L,I,J)	Restore land area of land use category L and year Y
ABD(Y,L,I,J)	Abandoned land area of land use category L and year Y
*YND(Y,L,I,J)
ZT(Y,I,J)
;

RSF(Y,L,I,J)=0;
ABD(Y,L,I,J)=0;
XF(Y,L,I,J)=0;


ordy(Y) = 2010 + (ord(Y)-1)*10;

deltaY(Y,L,I,J)$(FLAG_IJ(I,J) and VY_IJ(Y,L,I,J)-VY_IJ(Y-1,L,I,J))=VY_IJ(Y,L,I,J)-VY_IJ(Y-1,L,I,J);

*$ontext
ZT(Y,I,J)=0;
loop(Y$(Y.val>=2020),
	ZT(Y,I,J)=max(0,ZT(Y-1,I,J)+SUM(L$Lnat(L),deltaY(Y,L,I,J)));
);
*$offtext
*ZT(Y,I,J)$(Y.val=2020 )=max(0,SUM(Y2$(Y2.val=2020),SUM(L$Lnat(L),deltaY(Y2,L,I,J))));
*ZT(Y,I,J)$(Y.val>=2030)=max(0,SUM(Y2$(Y2.val<=Y.val and Y2.val>=2030),SUM(L$Lnat(L),deltaY(Y2,L,I,J))));

deltaZ(Y,I,J)$(SUM(L$Lnat(L),deltaY(Y,L,I,J)))=max(0,SUM(L$Lnat(L),deltaY(Y,L,I,J)));
deltaX(Y,L,I,J)$(deltaZ(Y,I,J) and SUM(L3$(Lused(L3) and deltaY(Y,L3,I,J)<0),deltaY(Y,L3,I,J)))=deltaZ(Y,I,J)*sum(L2$(MAP_Abandoned(L2,L) and deltaY(Y,L2,I,J)<0),deltaY(Y,L2,I,J))/SUM(L3$(Lused(L3) and deltaY(Y,L3,I,J)<0),deltaY(Y,L3,I,J));
X(Y,L,I,J)$(FLAG_IJ(I,J))=SUM(Y2$(ordy(Y)>=ordy(Y2)),deltaX(Y2,L,I,J));
*YND(Y,L,I,J)$(FLAG_IJ(I,J))=SUM(Y2$(ordy(Y)>=ordy(Y2)),deltaY(Y2,L,I,J));
*XF(Y,L,I,J)$(sum(L2,X(Y,L2,I,J)))=max(0,X(Y,L,I,J)-max(0,sum(L3$(Lnat(L3) and Y.val>2020),(-1)*deltaY(Y,L3,I,J)))*X(Y,L,I,J)/sum(L2,X(Y,L2,I,J)));
XF(Y,L,I,J)$(sum(L2,X(Y,L2,I,J)))=ZT(Y,I,J)*X(Y,L,I,J)/sum(L2,X(Y,L2,I,J));

Remain(Y,L,I,J)$(XF(Y,L,I,J))=XF(Y,L,I,J);
Loop(Y2$(Y2.val>=2020),
	RPA(Y,L,Y2,I,J)$(ordy(Y)<ordy(Y2)+30 and Y.val>=Y2.val and sum(Y3,Remain(Y3,L,I,J)))=smin(Y3$(ordy(Y3)<ordy(Y2)+30 and Y3.val>=Y2.val),Remain(Y3,L,I,J));
	RSP(Y,L,Y2,I,J)$(ordy(Y)>=ordy(Y2)+30 and Y.val>=Y2.val and sum(Y3,RPA(Y3,L,Y2,I,J)))=min(smin(Y3$(ordy(Y3)<ordy(Y2)+30 and Y3.val>=Y2.val),RPA(Y3,L,Y2,I,J)),Remain(Y,L,I,J));
	RSfrom(Y,L,Y2,I,J)$(ordy(Y)>=ordy(Y2)+30 and Y.val>=Y2.val and RSP(Y,L,Y2,I,J))=RSP(Y,L,Y2,I,J);

	Loop(Y3$(Y3.val>Y2.val+30),
		RSfrom(Y3,L,Y2,I,J)$(RSP(Y3-1,L,Y2,I,J)>0 and RSP(Y3,L,Y2,I,J)>0 and RSP(Y3-1,L,Y2,I,J)<RSP(Y3,L,Y2,I,J))=RSP(Y3-1,L,Y2,I,J);
	);

	RS(Y,L2,Y2,I,J)$(ordy(Y)>=ordy(Y2)+30 and sum(L,RSfrom(Y,L,Y2,I,J))) = sum(L$MAP_AB2RES(L,L2),RSfrom(Y,L,Y2,I,J));
	Remain(Y,L,I,J)$(ordy(Y)>=ordy(Y2)+30  and Y.val>=Y2.val and Remain(Y,L,I,J))=Remain(Y,L,I,J)-RSfrom(Y,L,Y2,I,J)-RPA(Y,L,Y2,I,J);
);

RSF(Y,L,I,J)$(SUM(Y2,RS(Y,L,Y2,I,J)))=SUM(Y2,RS(Y,L,Y2,I,J));
ABD(Y,L,I,J)$(XF(Y,L,I,J)-SUM(Y2,RSFrom(Y,L,Y2,I,J)))=XF(Y,L,I,J)-SUM(Y2,RSFrom(Y,L,Y2,I,J));



$endif.split
$if %split%==1 $exit

*------------------------------
* Livestock distribution calc
*-----------------------------
$Setglobal base_year 2005
$ifthen.livdis %livdiscalc%==on
set
Sl Set for types of livestock
Slnum/1*8/
ALIV  Set for types of livestock sector in CGE
CLIV  Set for types of livestock commopdity in CGE
;
Alias (Sl,Sl2),(Slnum,Slnum2),(R,R2);
parameter
liv_dist_base(Sl,I,J)	number of animals in a grid cell I J in base year (head)
liv_dist_baseave(Sl,R)	average number of animals in a grid cell in region R in base year (head)
liv_dist_base0(Sl,Y,I,J)	benckmark number of animals in a grid cell I J by allocating regional average base-year number to the cell no pasture in base year but generated in future year Y (head)
liv_dist(Sl,Y,I,J)	number of animals in a grid cell I J (head)
liv_dist2(Sl,Y,I,J)	adjusted number of animals in a grid cell I J (head)
liv_distnum(Slnum,Y,I,J)	number of animals in a grid cell I J (head)
liv_reg(Sl,Y,R)	number of animals in each regions

liv_regbase(Sl,R)	number in region R in base year (head)
liv_regtar(Sl,Y,R)	targeted total number in region R in year t
liv_regwopas(Sl,Y,R)	total number of animals in the cell without pasture in region R in base and year t
liv_regonpas(Sl,Y,R)	targeted total number in the cell with pasture in region R in year t
prod_regsf(Sl,Y,R)	scale factor of production in region R and year t
area_regsf(Sl,Y,R)	scale factor of area in region R and year t
head_regsf(Sl,Y,R)	scale factor of head  in the cell with pasture in region R and year t
BW_map(Sl,I,J) body weight of animals (kg body weight per head)
BW_mapnum(Slnum,I,J) body weight of animals (kg body weight per head)
LUnit livestock unit (250kg per head) /250/

OUTPUTAC_load(*,Y,R,ALIV,CLIV)	Output (Production) of commodity C from sector A  (mil.$ or ktoe) (cge output)
OUTPUTSL(Y,R,Sl)	Output (Production) of commodity C from sector A (mil.$ or ktoe) (cge output)
;

$setglobal IAVload %IAV%

$gdxin '../%prog_loc%/individual/Livestock/livestock_base.gdx'
$load Sl liv_dist_base=livestock_headbasemap BW_map

$gdxin '../%prog_loc%/data/set.gdx'
$load ALIV=AGRZ CLIV

$gdxin '../%prog_loc%/data/cgeoutput/analysis.gdx'
$load OUTPUTAC_load=OUTPUTAC

set
MAP_SALIV(Sl,ALIV)/
cattle_d	.	RMK
cattle_o	.	CTL
buffaloes	.	CTL
sheep	.	CTL
goats	.	CTL
swines	.	OTH_L
chickens	.	OTH_L
ducks	.	OTH_L
/
MAP_SCLIV(Sl,CLIV)/
cattle_d	.	COM_RMK
cattle_o	.	COM_CTL
buffaloes	.	COM_CTL
sheep	.	COM_CTL
goats	.	COM_CTL
swines	.	COM_OTH_L
chickens	.	COM_OTH_L
ducks	.	COM_OTH_L
/
;

OUTPUTSL(Y,R,Sl)=SUM(ALIV$MAP_SALIV(Sl,ALIV),SUM(CLIV$MAP_SCLIV(Sl,CLIV),OUTPUTAC_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,R,ALIV,CLIV)));

liv_regbase(Sl,R)=sum((I,J)$MAP_RIJ(R,I,J),liv_dist_base(Sl,I,J));

liv_dist_baseave(Sl,R)$sum((I,J)$(MAP_RIJ(R,I,J) and liv_dist_base(Sl,I,J)),1)=sum((I,J)$(MAP_RIJ(R,I,J) and liv_dist_base(Sl,I,J)),liv_dist_base(Sl,I,J))/sum((I,J)$(MAP_RIJ(R,I,J) and liv_dist_base(Sl,I,J)),1);

liv_dist_base0(Sl,Y,I,J)=liv_dist_base(Sl,I,J);
liv_dist_base0(Sl,Y,I,J)$(liv_dist_base(Sl,I,J)=0 and VY_IJ("%base_year%","PAS",I,J)=0 and VY_IJ(Y,"PAS",I,J))=sum(R$(MAP_RIJ(R,I,J)),liv_dist_baseave(Sl,R));


liv_regtar(Sl,Y,R)$OUTPUTSL("%base_year%",R,Sl)=liv_regbase(Sl,R) * OUTPUTSL(Y,R,Sl)/OUTPUTSL("%base_year%",R,Sl);

liv_regwopas(Sl,Y,R)=sum((I,J)$(MAP_RIJ(R,I,J) and VY_IJ("%base_year%","PAS",I,J)=0 and VY_IJ(Y,"PAS",I,J)=0),liv_dist_base(Sl,I,J));
liv_regonpas(Sl,Y,R)=liv_regtar(Sl,Y,R)-liv_regwopas(Sl,Y,R);

prod_regsf(Sl,Y,R)$liv_regbase(Sl,R)=liv_regtar(Sl,Y,R)/liv_regbase(Sl,R);
area_regsf(Sl,Y,R)$(sum((I,J)$(MAP_RIJ(R,I,J)),VY_IJ("%base_year%","PAS",I,J)*GAIJ(I,J)))=sum((I,J)$(MAP_RIJ(R,I,J)),VY_IJ(Y,"PAS",I,J)*GAIJ(I,J))/sum((I,J)$(MAP_RIJ(R,I,J)),VY_IJ("%base_year%","PAS",I,J)*GAIJ(I,J));
head_regsf(Sl,Y,R)$area_regsf(Sl,Y,R)=prod_regsf(Sl,Y,R)/area_regsf(Sl,Y,R);


liv_dist(Sl,"%base_year%",I,J)=liv_dist_base(Sl,I,J);
liv_dist(Sl,Y,I,J)$(liv_dist_base0(Sl,Y,I,J) and Y.val>%base_year%)=liv_dist_base0(Sl,Y,I,J)*sum(R$(MAP_RIJ(R,I,J)),prod_regsf(Sl,Y,R));

* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
liv_dist2(Sl,Y,I,J)$FLAG_IJ(I,J)=SUM(R$(MAP_RIJ(R,I,J)),liv_dist(Sl,Y,I,J))/SUM(R$(MAP_RIJ(R,I,J)),1);
liv_reg(Sl,Y,R)=sum((I,J)$MAP_RIJ(R,I,J),liv_dist2(Sl,Y,I,J));
liv_reg(Sl,Y,R)$(sum(R2$MAP_Ragg(R2,R),liv_reg(Sl,Y,R2)))=sum(R2$MAP_Ragg(R2,R),liv_reg(Sl,Y,R2));

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

* put -99 for missing values for both terrestiral and ocean pixels. Then define -999 as NaN when making netCDF files.s
liv_distnum(Slnum,Y,I,J)$(sum(Slnum2,liv_distnum(Slnum2,Y,I,J))=0 and liv_distnum(Slnum,Y,I,J)=0)=-99;

BW_mapnum(Slnum,I,J)=sum(Sl$(MAP_Slnum(Slnum,Sl)),BW_map(Sl,I,J));
BW_mapnum(Slnum,I,J)$(sum(Slnum2,BW_mapnum(Slnum2,I,J))=0 and BW_mapnum(Slnum,I,J)=0)=-99;


$ifthen.gdxout %gdxout%==on
execute_unload '../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/livestock_distribution.gdx'
liv_dist,liv_reg,Sl,ALIV,MAP_SALIV,BW_map,liv_distnum,BW_mapnum
;
$endif.gdxout


file output / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/livestock_distribution.csv" /;
put output;
output.pw=32767;
put "Livestock_distribution", "= "/;

loop(Y,
 loop(Slnum,
  loop(I,
   loop(J,
    output.nd=10; output.nz=0; output.nr=0; output.nw=15;
    put liv_distnum(Slnum,Y,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Slnum)=8 AND ORD(Y)=11),put ",";
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
$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
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
$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load GHGLG

GHG_IJ(Y,L,I,J)$(FLAG_IJ(I,J))=SUM(G$(MAP_GIJ(G,I,J) and GHGLG(Y,L,G)),GHGLG(Y,L,G));
GHGC_IJ(Y,L,I,J)$(LABL(L) and FLAG_IJ(I,J))=GHG_IJ("2010",L,I,J)*5 + sum(Y2$(ordy("2020")<=ordy(Y2) and ordy(Y2)<=ordy(Y) and GHG_IJ(Y2,L,I,J)),GHG_IJ(Y2,L,I,J)*Y_step);

$batinclude ../%prog_loc%/inc_prog/outputcsv_ghg.gms AFRTOT
$batinclude ../%prog_loc%/inc_prog/outputcsv_ghg.gms BIO
$batinclude ../%prog_loc%/inc_prog/outputcsv_ghg.gms LUC

$exit
$endif.carseq


$ifthen.p %lumip%==on
alias (Lmip,Lmip2);
VY_IJmip(Y,Lmip,I,J)=SUM(L$MAP_LUMIP(Lmip,L),VY_IJ(Y,L,I,J));
VY_IJmip(Y,Lmip,I,J)$(sum(Lmip2,VY_IJmip(Y,Lmip2,I,J))=0 and VY_IJmip(Y,Lmip,I,J)=0)=-99;

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
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c3ann
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c4ann
*$batinclude %prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c3per
*$batinclude %prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c4per
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms irrig_c3nfx
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms crpbf_c4ann
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms flood
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms fallow
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms rice
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms wheat
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms maize
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms sugarcrops
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms oilcrops
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms othercrops
$batinclude ../%prog_loc%/inc_prog/outputcsv_lumip.gms icwtr


$ifthen.gdxout %gdxout%==on
execute_unload '../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/%SCE%_%CLP%_%IAV%%ModelInt%_lumip.gdx'
VY_IJmip
;
$endif.gdxout


$elseif.p %lumip%_%wwfclass%==off_opt

set
Lwwfnum/
$if %wwfopt%==1 1*8
$if %wwfopt%==2 1*17
$if %wwfopt%==3 1*17

/
MAP_WWFnum(Lwwfnum,L)/
$if %wwfopt%==1 $include ../%prog_loc%/individual/BendingTheCurve/luwwfnum.map
$if %wwfopt%==2 $include ../%prog_loc%/individual/BendingTheCurve/luwwfnum_org.map
$if %wwfopt%==3 $include ../%prog_loc%/individual/BendingTheCurve/luwwfnum_org.map
/
;
parameter
plwwfnum/
$if %wwfopt%==1 8
$if %wwfopt%==2 17
$if %wwfopt%==3 17
/
;

Alias (Lwwfnum,Lwwfnum2);
parameter
VW(Y,L,I,J)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance (fraction)
VW2(Y,L,I,J)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance (averaged for the cell occupided by more than one countries) (fraction)
VW_reg(Y,L,R)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance in region R (kha)
VU(Y,L,I,J)	Land area of land use category L and year Y where land is restored at the same time as abandance
VY_IJwwfnum(Y,Lwwfnum,I,J)
;

VW(Y,L,I,J)$(VY_IJ(Y,L,I,J))=VY_IJ(Y,L,I,J);
VW(Y,L,I,J)$(LRES(L) and RSF(Y,L,I,J))=RSF(Y,L,I,J);
VW(Y,L,I,J)$(LABD(L) and ABD(Y,L,I,J))=ABD(Y,L,I,J);
VW(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J)>0)=max(0,VY_IJ(Y,L,I,J)-SUM(L2,RSF(Y,L2,I,J))-SUM(L3,ABD(Y,L3,I,J)));


VU(Y,L,I,J)$(VY_IJ(Y,L,I,J))=VY_IJ(Y,L,I,J);
VU(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J) and SUM(L2,XF(Y,L2,I,J)))=max(0,VY_IJ(Y,L,I,J)-SUM(L2,XF(Y,L2,I,J)));

VU(Y,L,I,J)$(LRES(L) and SUM(L2,XF(Y,L2,I,J)))=SUM(L2,XF(Y,L2,I,J));

VW(Y,L,I,J)$(VW(Y,L,I,J)<10**(-7) AND VW(Y,L,I,J)>(-1)*10**(-7))=0;
VU(Y,L,I,J)$(VU(Y,L,I,J)<10**(-7) AND VU(Y,L,I,J)>(-1)*10**(-7))=0;

$if %wwfopt%==1 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J));
$if %wwfopt%==2 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J));
$if %wwfopt%==3 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J));


* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
VW2(Y,L,I,J)$FLAG_IJ(I,J)=SUM(R$(MAP_RIJ(R,I,J)),VW(Y,L,I,J))/SUM(R$(MAP_RIJ(R,I,J)),1);
VW_reg(Y,L,R)=sum((I,J)$MAP_RIJ(R,I,J),VW2(Y,L,I,J)*GAIJ(I,J));
VW_reg(Y,L,R)$(sum(R2$MAP_Ragg(R2,R),VW_reg(Y,L,R2)))=sum(R2$MAP_Ragg(R2,R),VW_reg(Y,L,R2));

VY_IJwwfnum(Y,Lwwfnum,I,J)=round(VY_IJwwfnum(Y,Lwwfnum,I,J),10);

* put -99 for missing values for both terrestiral and ocean pixels. Then define -999 as NaN when making netCDF files.s
VY_IJwwfnum(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum(Y,Lwwfnum2,I,J))=0 and VY_IJwwfnum(Y,Lwwfnum,I,J)=0)=-99;

$ifthen.gdxout %gdxout%==on
execute_unload '../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/%SCE%_%CLP%_%IAV%%ModelInt%_opt%wwfopt%.gdx'
VY_IJwwfnum,VW_reg
;
$endif.gdxout


file output / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/%SCE%_%CLP%_%IAV%%ModelInt%_opt%wwfopt%.csv" /;
put output;
*output.pw=100000;
output.pw=32767;
put "LC_area_share%wwfopt%", "= "/;

loop(Y,
 loop(Lwwfnum,
  loop(I,
   loop(J,
    output.nd=10; output.nz=0; output.nr=0; output.nw=15;
    put VY_IJwwfnum(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=plwwfnum AND ORD(Y)=11),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;

* Pixel area
$ifthen.wwfopt not %wwfopt%==1

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


$endif.wwfopt

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









