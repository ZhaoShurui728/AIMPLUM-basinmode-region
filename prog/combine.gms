$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_loc
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%

$setglobal biocurve off
$setglobal supcuvout off
$setglobal costcalc off
$setglobal bioyieldcalc on
$setglobal biodivcalc off
$setglobal rlimapcalc off
$setglobal agmip off
$if %supcuvout%==on $setglobal biocurve on
$setglobal restorecalc off
$setglobal livdiscalc off

$if exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/%sce%.gms
$if not exist ../%prog_loc%/scenario/socioeconomic/%sce%.gms $include ../%prog_loc%/scenario/socioeconomic/SSP2.gms
$if exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/%clp%.gms
$if not exist ../%prog_loc%/scenario/climate_policy/%clp%.gms $include ../%prog_loc%/scenario/climate_policy/BaU.gms
$if exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/%iav%.gms
$if not exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/NoCC.gms

$ifthen.split %split%==1

Set
N /1*40000/
Rall	17 regions + ISO countries	/
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
R(Rall)	17 regions	/
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
Ragg(R)/
$include ../%prog_loc%/define/region/region5.set
World
/
RBION(Rall)/
$include ../%prog_loc%/define/region/region17exclNations.set
$include ../%prog_loc%/define/region/region_iso.set
$include ../%prog_loc%/define/region/region5.set
World
/
RISO(Rall)	ISO countries /
$include ../%prog_loc%/define/region/region_iso.set
/
MAP_RISO(RISO,R)	Relationship between ISO countries and 17 regions

G	Cell number excluding ocean (Gland)
I /1*360/
J /1*720/
MAP_GIJ(G,I,J)

Yanu year	/  %base_year%*%end_year%  /
Y(Yanu) year	/
$if %end_year%==2100 2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100
$if %end_year%==2050 2005,2010,2020,2030,2040,2050
/
Ysupcuv(Y) year	/
2030,2050,2100
/
ST	/SSOLVE,SMODEL/
SP	/SMCP,SNLP,SLP/
Scol	/quantity,price,yield,area/
Sacol	/cge,base,estimates/
L land use type /
PRM_SEC forest + grassland + pasture + fallow land
FRSGL   forest + grassland
HAV_FRS  production forest
FRS     forest excl AFR
GL      grassland
AFR     afforestation
CL      cropland
CROP_FLW        fallow land
PAS     grazing pasture
BIO     bio crops
SL      built_up
OL      ice or water
RES	restoration land that was used for cropland or pasture and set aside for restoration

* total
AFRTOT     afforestation (AFR in NoCC and AFR+NRF in BIOD) for GHG calc
LUC
"LUC+BIO"

* forest subcategory (composition of FRS excl AFR)
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

* BtC
*abandoned land with original land category
ABD_CL
ABD_CROP_FLW
ABD_BIO
ABD_PAS
ABD_MNGFRS
ABD_AFR
/
LCROPA(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO,CROP_FLW/
LPAS(L)/PAS/
LAFR(L)/AFR/
LAFRTOT(L)/AFRTOT/
LBIO(L)/BIO/
LFRSGL(L)/FRSGL,FRS,GL/
Lused(L)/MNGFRS,AFR,CL,CROP_FLW,BIO,PAS/
Lnat(L)/GL,UMNFRS/
LABD(L)/ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR/
LRES(L)/RES/
LDM land use type /
*PRM_SEC other forest and grassland
HAV_FRS production forest
FRSGL	forest + grassland
FRS	forest
GL
AFR     afforestation
PAS     grazing pasture
PDR     rice
WHT     wheat
GRO     other coarse grain
OSD     oil crops
C_B     sugar crops
OTH_A   other crops
BIO	bio crops
CROP_FLW	fallow land
SL	built_up
OL	ice or water
CL      cropland
CEREAL	cereal
RES	restoration land that was used for cropland or pasture and set aside for restoration
/
LFRSGLDM(LDM)/FRSGL,FRS,GL/
LDMCROPA(LDM)/PDR,WHT,GRO,OSD,C_B,OTH_A,BIO,CROP_FLW/
MAP_LLDM(L,LDM)/
*PRM_SEC .       PRM_SEC
HAV_FRS  .       HAV_FRS
AFR     .       AFR
PAS     .       PAS
PDRIR   .       PDR
WHTIR   .       WHT
GROIR   .       GRO
OSDIR   .       OSD
C_BIR   .       C_B
OTH_AIR .       OTH_A
PDRRF   .       PDR
WHTRF   .       WHT
GRORF   .       GRO
OSDRF   .       OSD
C_BRF   .       C_B
OTH_ARF .       OTH_A
BIO     .       BIO
CROP_FLW        .       CROP_FLW
SL      .       SL
OL      .       OL
*CL      .       CL
GL	.	GL
FRS	.	FRS
FRSGL	.	FRSGL
PDRIR   .       CEREAL
WHTIR   .       CEREAL
GROIR   .       CEREAL
PDRRF   .       CEREAL
WHTRF   .       CEREAL
GRORF   .       CEREAL
*CL      .       CL
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
*BIO	.	CL
*CROP_FLW	.	CL
RES	.	RES
/
LB              New or old bioenergy cropland/
BION    new bioenergy cropland
BIOO    old bioenergy cropland
/
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
Alias(R,R2),(G,G2),(LB,LB2),(L,L2,L3),(Y,Y2,Y3);
set
MAP_RAGG(R,R2)	/
$include ../%prog_loc%/define/region/region17_agg.map
/
LULC_class/
$include ../%prog_loc%/individual/BendingTheCurve/LULC_class.set
/
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
"Prev"		Previous version of emissions
/
MAP_RIJ(R,I,J)
MAP_RG(R,G)
;

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load G=Gland MAP_GIJ MAP_RISO

parameter
Psol_stat(R,Y,ST,SP)                  Solution report
PBIOSUP_load(Y,G,LB,Scol)
PBIOSUP(Rall,Y,G,LB,Scol)
Area(R,Y,L)	Regional area of land category L (million ha)
AreaR(R,Y,L,RISO)	Regional area of land category L in RISO category [kha]
AreaLDM(R,Y,LDM)	million ha
Area_base(R,L,Sacol)
CSB(R)
CSB_load(R,Y)
GHGL(R,Y,EmitCat,L)	MtCO2 per year in region R
GHGLG(R,Y,EmitCat,L,G)    MtCO2 per grid per year
GHGLR(R,Y,EmitCat,L,RISO)		GHG emission of land category L in year Y [MtCO2 per year]
GA(G)		Grid area of cell G kha
YBIO(R,Y,G)
PCBIO_load(Y,R)	average price to meet the given bioenergy amount [$ per GJ]
QCBIO_load(Y,R)	quantity to meet the given bioenergy price [EJ per year]
PCBIO(R,Y)	average price to meet the given bioenergy amount [$ per GJ]
QCBIO(R,Y)	quantity to meet the given bioenergy price [EJ per year]

YIELD(R,Y,L,G)
YIELD_load(R,L,G)
VY_load(R,Y,L,G)	a fraction of land-use L region R in year Y grid G
VYL(R,Y,L,G)	a fraction of land-use L region R in year Y grid G
VYPL(R,Y,L,G)
pa_road(R,Y,L,G)
pa_emit(R,Y,G)
pa_lab(R,Y,G)
pa_irri(R,Y,L)
ordy(Y)
MFA(R)     management factor for bio crops in base year
MFB(R)     management factor for bio crops (coefficient)
YIELDL_OUT(R,Y,L)	Average yield of land category L region R in year Y [tonne per ha per year]
YIELDLDM_OUT(R,Yanu,LDM)	Average yield of land category L region R in year Y [tonne per ha per year]
RR(G)	the range-rarity map
BIIcoefG(L,G)	the Biodiversity Intactness Index (BII) coefficients
sharepix(LULC_class,I,J)
VYLY(R,Y,Y,L,G)	land use in all the earlier years
VY_IJ(Y,L,I,J)
FLAG_IJ(I,J)		Grid flag
GAIJ(I,J)           Grid area of cell I J kha
;

ordy(Y) = ord(Y) + %base_year% -1;

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load GA MAP_RIJ GAIJ MAP_RG

FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;

$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/USA.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XE25.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XE25
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XER.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XER
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/TUR.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUR
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XOC.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XOC
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/CHN.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/IND.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/JPN.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JPN
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XSE.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XSE
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XSA.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XSA
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/CAN.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/BRA.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XLM.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XLM
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/CIS.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CIS
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XME.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XME
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XNF.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XNF
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/cbnal/XAF.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XAF

Area_base(Ragg,L,Sacol)$(SUM(R$MAP_RAGG(R,Ragg),Area_base(R,L,Sacol)))=SUM(R$MAP_RAGG(R,Ragg),Area_base(R,L,Sacol));


$gdxin '../output/gdx/results/cbnal_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load Psol_stat VYPL=VYP_load pa_road pa_emit pa_lab pa_irri YIELDL_OUT YIELDLDM_OUT


$gdxin '../output/gdx/results/analysis_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VY_load=VYL GHGL GHGLG GHGLR Area AreaR
$load VYLY CSB_load=CSB

Area(Ragg,Y,L)$(SUM(R$MAP_RAGG(R,Ragg),Area(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),Area(R,Y,L));
AreaLDM(R,Y,LDM)=SUM(L$MAP_LLDM(L,LDM),Area(R,Y,L));
Area_base(R,L,"estimates")=Area(R,"%base_year%",L);

GHGL(Ragg,Y,EmitCat,L)$SUM(R$MAP_RAGG(R,Ragg),GHGL(R,Y,EmitCat,L))=SUM(R$MAP_RAGG(R,Ragg),GHGL(R,Y,EmitCat,L));

CSB(R)=CSB_load(R,"%base_year%");

* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
VY_IJ(Y,L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R$(MAP_RG(R,G)),VY_load(R,Y,L,G))/SUM(R$(MAP_RG(R,G)),1));
VY_IJ(Y,L,I,J)$(FLAG_IJ(I,J) and LAFRTOT(L))=SUM(G$(MAP_GIJ(G,I,J)),SUM(R$(MAP_RG(R,G)),VYLY(R,Y,Y,L,G))/SUM(R$(MAP_RG(R,G)),1));
VY_IJ(Y,L,I,J)$(sum(L2$(MAP_CL(L2,L)),VY_IJ(Y,L2,I,J)))=sum(L2$(MAP_CL(L2,L)),VY_IJ(Y,L2,I,J));

*------------------------------------------------------
*--- Interporation of yield to feed back to AIM/CGE ---*
*------------------------------------------------------
parameter
YIELDLDM_ratio(R,Yanu,LDM)
YIELDLDM_annual(R,Yanu,LDM)
;

YIELDLDM_ratio(R,Yanu,LDM)$(Yanu.val>2010 and YIELDLDM_OUT(R,Yanu,LDM)>0 and YIELDLDM_OUT(R,Yanu-10,LDM)>0)=(YIELDLDM_OUT(R,Yanu,LDM)/YIELDLDM_OUT(R,Yanu-10,LDM))**(1/10);
YIELDLDM_ratio(R,Yanu,LDM)$(Yanu.val=2010 and YIELDLDM_OUT(R,Yanu,LDM) and YIELDLDM_OUT(R,Yanu-5,LDM))=(YIELDLDM_OUT(R,Yanu,LDM)/YIELDLDM_OUT(R,Yanu-5,LDM))**(1/5);

YIELDLDM_annual(R,Yanu,LDM)$(2005<=Yanu.val and Yanu.val<2010)=YIELDLDM_OUT(R,"2005",LDM)*YIELDLDM_ratio(R,"2010",LDM)**(Yanu.val-2005);
YIELDLDM_annual(R,Yanu,LDM)$(2010<=Yanu.val and Yanu.val<2020)=YIELDLDM_OUT(R,"2010",LDM)*YIELDLDM_ratio(R,"2020",LDM)**(Yanu.val-2010);
YIELDLDM_annual(R,Yanu,LDM)$(2020<=Yanu.val and Yanu.val<2030)=YIELDLDM_OUT(R,"2020",LDM)*YIELDLDM_ratio(R,"2030",LDM)**(Yanu.val-2020);
YIELDLDM_annual(R,Yanu,LDM)$(2030<=Yanu.val and Yanu.val<2040)=YIELDLDM_OUT(R,"2030",LDM)*YIELDLDM_ratio(R,"2040",LDM)**(Yanu.val-2030);
YIELDLDM_annual(R,Yanu,LDM)$(2040<=Yanu.val and Yanu.val<2050)=YIELDLDM_OUT(R,"2040",LDM)*YIELDLDM_ratio(R,"2050",LDM)**(Yanu.val-2040);
YIELDLDM_annual(R,Yanu,LDM)$(2050<=Yanu.val and Yanu.val<2060)=YIELDLDM_OUT(R,"2050",LDM)*YIELDLDM_ratio(R,"2060",LDM)**(Yanu.val-2050);
YIELDLDM_annual(R,Yanu,LDM)$(2060<=Yanu.val and Yanu.val<2070)=YIELDLDM_OUT(R,"2060",LDM)*YIELDLDM_ratio(R,"2070",LDM)**(Yanu.val-2060);
YIELDLDM_annual(R,Yanu,LDM)$(2070<=Yanu.val and Yanu.val<2080)=YIELDLDM_OUT(R,"2070",LDM)*YIELDLDM_ratio(R,"2080",LDM)**(Yanu.val-2070);
YIELDLDM_annual(R,Yanu,LDM)$(2080<=Yanu.val and Yanu.val<2090)=YIELDLDM_OUT(R,"2080",LDM)*YIELDLDM_ratio(R,"2090",LDM)**(Yanu.val-2080);
YIELDLDM_annual(R,Yanu,LDM)$(2090<=Yanu.val and Yanu.val<=2100)=YIELDLDM_OUT(R,"2090",LDM)*YIELDLDM_ratio(R,"2100",LDM)**(Yanu.val-2090);


execute_unload '../output/gdx/analysis/base_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
Area
AreaR
AreaLDM
Area_base
CSB
GHGL
GHGLG
GHGLR
YIELDLDM_annual
YIELDLDM_ratio
;


$endif.split
$if %split%==1 $exit

*------------------------------------------------------
*----- Restored area calc
*------------------------------------------------------
$ifthen.res %restorecalc%==on


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


parameter
VW(Y,L,I,J)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance (fraction)
VW2(Y,L,I,J)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance (averaged for the cell occupided by more than one countries) (fraction)
VW_reg(Y,L,R)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance in region R (kha)
VU(Y,L,I,J)	Land area of land use category L and year Y where land is restored at the same time as abandance
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

* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
VW2(Y,L,I,J)$FLAG_IJ(I,J)=SUM(R$(MAP_RIJ(R,I,J)),VW(Y,L,I,J))/SUM(R$(MAP_RIJ(R,I,J)),1);
VW_reg(Y,L,R)=sum((I,J)$MAP_RIJ(R,I,J),VW2(Y,L,I,J)*GAIJ(I,J));
VW_reg(Y,L,R)$(sum(R2$MAP_Ragg(R2,R),VW_reg(Y,L,R2)))=sum(R2$MAP_Ragg(R2,R),VW_reg(Y,L,R2));


set
Lwwfnum/1*17/
MAP_WWFnum(Lwwfnum,L)/
$include ../%prog_loc%/individual/BendingTheCurve/luwwfnum_org.map
/
;
Alias (Lwwfnum,Lwwfnum2);
parameter
VY_IJwwfnum(Y,Lwwfnum,I,J)
;
$if not %iav%==BIOD VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J));
$if %iav%==BIOD VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J));

VY_IJwwfnum(Y,Lwwfnum,I,J)=round(VY_IJwwfnum(Y,Lwwfnum,I,J),10);

* put -99 for missing values for both terrestiral and ocean pixels. Then define -999 as NaN when making netCDF files.s
VY_IJwwfnum(Y,Lwwfnum,I,J)$(sum((Lwwfnum2,Y2),VY_IJwwfnum(Y2,Lwwfnum2,I,J))=0 and VY_IJwwfnum(Y,Lwwfnum,I,J)=0)=-99;

execute_unload '../output/gdx/analysis/restore_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
VY_IJwwfnum,VW_reg
;

$endif.res
$if %restorecalc%==on $exit




*------------------------------
* Livestock distribution calc
*-----------------------------

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
liv_reg(Sl,Y,R)	number of animals in each regions

liv_regbase(Sl,R)	number in region R in base year (head)
liv_regtar(Sl,Y,R)	targeted total number in region R in year t
liv_regwopas(Sl,Y,R)	total number of animals in the cell without pasture in region R in base and year t
liv_regonpas(Sl,Y,R)	targeted total number in the cell with pasture in region R in year t
prod_regsf(Sl,Y,R)	scale factor of production in region R and year t
area_regsf(Sl,Y,R)	scale factor of area in region R and year t
head_regsf(Sl,Y,R)	scale factor of head  in the cell with pasture in region R and year t
LUnit livestock unit (250kg per head) /250/

OUTPUTAC_load(*,Y,R,ALIV,CLIV)	Output (Production) of commodity C from sector A  (mil.$ or ktoe) (cge output)
OUTPUTSL(Y,R,Sl)	Output (Production) of commodity C from sector A (mil.$ or ktoe) (cge output)
BW_map(Sl,I,J) body weight of animals (kg body weight per head)
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


execute_unload '../output/gdx/analysis/livdis_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
liv_dist,liv_reg,Sl,ALIV,MAP_SALIV
;

$endif.livdis
$if %livdiscalc%==on $exit


*----- Yield
$ifthen.bioyield %bioyieldcalc%==on

parameter
  MF(L,R,Y)      management factor for bio crops
  YIELD_BIO(R,Y,G)
;
MF(L,R,Y)$(SUM((Ragg,L2),Area(Ragg,Y,L2)) AND NOT LBIO(L))=1;
MF(L,R,Y)$(MFA(R) AND LBIO(L))=min(1.3/MFA(R),MFB(R)**max(0,ordy(Y)-2010));

YIELD(R,Y,L,G)$(YIELD_load(R,L,G) AND SUM((Ragg,L2),Area(Ragg,Y,L2)))=YIELD_load(R,L,G)*MF(L,R,Y);
YIELD_BIO(R,Y,G)=YIELD(R,Y,"BIO",G);

execute_unload '../output/gdx/analysis/bioyield_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
YIELD_BIO
;

$endif.bioyield



*------------------------------
*-----Land transition cost
*------------------------------
$ifthen.cost %costcalc%==on

set
costitem /total,lab,road,irri,emit/
;
parameter
PAL(R,Y,L,costitem)        average land transition cost per unit area ($ per ha)
PALDM(R,Y,LDM,costitem)    average land transition cost per unit area ($ per ha)
PATL(R,Y,L,costitem)        total land transition cost per unit area (million $)
PATLDM(R,Y,LDM,costitem)    total land transition cost per unit area (million $)
pa(R,Y,L,G)
;

pa(R,Y,L,G) = pa_lab(R,Y,G) + pa_road(R,Y,L,G)  + pa_irri(R,Y,L) + pa_emit(R,Y,G)$(NOT LFRSGL(L));

*PAL(R,Y,L,"total")$SUM(G$(pa(R,Y,L,G) * YIELD(L,G) * VYPL(L,G)), YIELD(L,G) * GA(G) *VYPL(L,G))
*=SUM(G$(pa(R,Y,L,G) * YIELD(L,G) * VYPL(L,G)),pa(R,Y,L,G) * YIELD(L,G) * GA(G) *VYPL(L,G)) /SUM(G$(pa(R,Y,L,G) * YIELD(L,G) * VYPL(L,G)), YIELD(L,G) * GA(G) *VYPL(L,G))*(10**6);
PAL(R,Y,L,"road")$SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))
=SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)) /SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))*(10**6);
PAL(R,Y,L,"emit")$((NOT LFRSGL(L)) AND SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))
=SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_emit(R,Y,G) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)) /SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))*(10**6);
PAL(R,Y,L,"lab")$(SUM(G$(pa_lab(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) * VYPL(R,Y,L,G)))=SUM(G$(pa_lab(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_lab(R,Y,G) * YIELD(R,Y,L,G) * GA(G) * VYPL(R,Y,L,G))*(10**6)/
 SUM(G$(pa_lab(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) * VYPL(R,Y,L,G));
PAL(R,Y,L,"irri")$SUM(G$(pa(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * VYPL(R,Y,L,G))=pa_irri(R,Y,L)*(10**6);
PAL(R,Y,L,"total")=sum(costitem,PAL(R,Y,L,costitem));

PATL(R,Y,L,"road")=SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_road(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G));
PATL(R,Y,L,"emit")$(NOT LFRSGL(L))=SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_emit(R,Y,G) * GA(G) *VYPL(R,Y,L,G));
PATL(R,Y,L,"lab")=SUM(G$(pa(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_lab(R,Y)  * GA(G)* VYPL(R,Y,L,G));
PATL(R,Y,L,"irri")=SUM(G$(pa(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_irri(R,Y,L) * GA(G) * VYPL(R,Y,L,G));
PATL(R,Y,L,"total")=sum(costitem,PATL(R,Y,L,costitem));

PALDM(R,Y,LDM,"road")$SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))
=SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))) /SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))*(10**6);

PALDM(R,Y,LDM,"emit")$((NOT LFRSGLDM(LDM)) AND SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))))
=SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_emit(R,Y,G) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))) /SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))*(10**6);

PALDM(R,Y,LDM,"lab")$SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(pa(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * VYPL(R,Y,L,G)))=pa_lab(R,Y)*(10**6);

PALDM(R,Y,LDM,"irri")$(LDMCROPA(LDM) AND SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))))
=SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_irri(R,Y,L) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))
/SUM(L$(MAP_LLDM(L,LDM)),SUM(G$(YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))*(10**6);

PALDM(R,Y,LDM,"total")=sum(costitem,PALDM(R,Y,LDM,costitem));

PATLDM(R,Y,LDM,costitem)=SUM(L$(MAP_LLDM(L,LDM)),PATL(R,Y,L,costitem));


execute_unload '../output/gdx/analysis/cost_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
PAL,PALDM,PATL,PATLDM
;

$endif.cost

*------------------------------
* Bioenergy supply curve SORTED
*-----------------------------


$ifthen.biocurve %biocurve%==on

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio.gdx'
$load PCBIO_load=PCBIO QCBIO_load=QCBIO

PCBIO(R,Y)=PCBIO_load(Y,R);
QCBIO(R,Y)=QCBIO_load(Y,R);

execute_unload '../output/gdx/analysis/biocurve_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
PCBIO,QCBIO
;

$endif.biocurve


$ifthen.supcuv %supcuvout%==on

set
MAP_RG(R,G)     Relationship between country R and cell G
MAP_RISOG(RISO,G)	Relationship between country RISO and cell G
;
$gdxin '../%prog_loc%/data/data_prep.gdx'
$load MAP_RG
$load MAP_RISOG

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio.gdx'
$load PBIOSUP_load=PBIOSUP


PBIOSUP(R,Y,G,LB,Scol)$MAP_RG(R,G)=PBIOSUP_load(Y,G,LB,Scol);
PBIOSUP(Ragg,Y,G,LB,Scol)$(Ysupcuv(Y) AND SUM(R$MAP_RAGG(R,Ragg),PBIOSUP(R,Y,G,LB,Scol)))=SUM(R$MAP_RAGG(R,Ragg),PBIOSUP(R,Y,G,LB,Scol));
PBIOSUP(RISO,Y,G,LB,Scol)$MAP_RISOG(RISO,G)=PBIOSUP_load(Y,G,LB,Scol);

set
Scolsum(Scol) /quantity,area/
Scolave(Scol) /price,yield/
;
alias (N,N2);
parameter
ggsup(Rall,Y,G,LB)
PBIOSOAT(Rall,Y,N,*)
PBIOSOATG(Rall,Y,N,G,LB,*)
;

ggsup(Rall,Y,G,LB)$(RBION(Rall) and Ysupcuv(Y) and PBIOSUP(Rall,Y,G,LB,"price"))=sum((G2,LB2)$(PBIOSUP(Rall,Y,G2,LB2,"price") and PBIOSUP(Rall,Y,G2,LB2,"price")<PBIOSUP(Rall,Y,G,LB,"price")),1);
PBIOSOATG(Rall,Y,N,G,LB,Scol)$(RBION(Rall) and Ysupcuv(Y) and ord(N)=(ggsup(Rall,Y,G,LB)+1))=PBIOSUP(Rall,Y,G,LB,Scol);

PBIOSOAT(Rall,Y,N,Scol)$(RBION(Rall) and Ysupcuv(Y) and Scolave(Scol) and sum((G,LB)$PBIOSOATG(Rall,Y,N,G,LB,Scol),1))=sum((G,LB)$PBIOSOATG(Rall,Y,N,G,LB,Scol),PBIOSOATG(Rall,Y,N,G,LB,Scol))/sum((G,LB)$PBIOSOATG(Rall,Y,N,G,LB,Scol),1);
PBIOSOAT(Rall,Y,N,Scol)$(RBION(Rall) and Ysupcuv(Y) and Scolsum(Scol)) =sum((G,LB),PBIOSOATG(Rall,Y,N,G,LB,Scol));
PBIOSOAT(Rall,Y,N,"area_acm")$(RBION(Rall) and Ysupcuv(Y) and PBIOSOAT(Rall,Y,N,"area"))=sum(N2$(ord(N)>ord(N2) OR ord(N)=ord(N2)),PBIOSOAT(Rall,Y,N2,"area"));
PBIOSOAT(Rall,Y,N,"quantity_acm")$(RBION(Rall) and Ysupcuv(Y) and PBIOSOAT(Rall,Y,N,"quantity"))=sum(N2$(ord(N)>ord(N2) OR ord(N)=ord(N2)),PBIOSOAT(Rall,Y,N2,"quantity"));

execute_unload '../output/gdx/all/biosupcuv_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
PBIOSOAT
;

$endif.supcuv


*----------------------------------------------
* Biodiversity value estimates  (WWF project)
*----------------------------------------------

$ifthen.biodiv %biodivcalc%==on

Parameter
BVSLG(R,Y,L,G)	biodiversity stock [*.Mha]
BVSL(R,Y,L)      biodiversity stock [*.Mha]
BVSLDM(R,Y,LDM)      biodiversity stock [*.Mha]
BVS(R,Y)		biodiversity stock [*.Mha]
BII(R,Y)		regional average BII coefficient [*]
BIIL(R,Y,L)		regional average BII coefficient [*]
BIIArea(R,Y)		regional average BII coefficient [*]
BIILArea(R,Y,L)
BVArea(R,Y)		regional average for estimating BV [*]
BVLArea(R,Y,L)		regional average for estimating BV [*]
;

BVSLG(R,Y,L,G)$(VYL(R,Y,L,G))=RR(G)*BIIcoefG(L,G)*VYL(R,Y,L,G)*GA(G)/10**3;

BVS(R,Y)=sum((L,G)$(BVSLG(R,Y,L,G)),BVSLG(R,Y,L,G));
BVSL(R,Y,L)=sum((G)$(BVSLG(R,Y,L,G)),BVSLG(R,Y,L,G));
BVSLDM(R,Y,LDM)=SUM((G,L)$(MAP_LLDM(L,LDM) AND BVSLG(R,Y,L,G)),BVSLG(R,Y,L,G));

BVArea(R,Y)$SUM((L,G)$(BIIcoefG(L,G)),VYL(R,Y,L,G)*GA(G))=SUM((L,G)$(BIIcoefG(L,G)),VYL(R,Y,L,G)*GA(G))/10**3;
BVLArea(R,Y,L)$SUM((G)$(BIIcoefG(L,G)),VYL(R,Y,L,G)*GA(G))=SUM((G)$(BIIcoefG(L,G)),VYL(R,Y,L,G)*GA(G))/10**3;

BIIArea(R,Y)$SUM((L,G)$(BIIcoefG(L,G)),RR(G)*VYL(R,Y,L,G)*GA(G))=SUM((L,G)$(BIIcoefG(L,G)),RR(G)*VYL(R,Y,L,G)*GA(G))/10**3;
BIILArea(R,Y,L)$SUM((G)$(BIIcoefG(L,G)),RR(G)*VYL(R,Y,L,G)*GA(G))=SUM((G)$(BIIcoefG(L,G)),RR(G)*VYL(R,Y,L,G)*GA(G))/10**3;

* Regional aggregation
BVS(Ragg,Y)$(SUM(R$MAP_RAGG(R,Ragg),BVS(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BVS(R,Y));
BVSL(Ragg,Y,L)$(SUM(R$MAP_RAGG(R,Ragg),BVSL(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),BVSL(R,Y,L));
BVSLDM(Ragg,Y,LDM)$(SUM(R$MAP_RAGG(R,Ragg),BVSLDM(R,Y,LDM)))=SUM(R$MAP_RAGG(R,Ragg),BVSLDM(R,Y,LDM));
BVArea(Ragg,Y)$(SUM(R$MAP_RAGG(R,Ragg),BVArea(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BVArea(R,Y));
BVLArea(Ragg,Y,L)$(SUM(R$MAP_RAGG(R,Ragg),BVLArea(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),BVLArea(R,Y,L));
BIIArea(Ragg,Y)$(SUM(R$MAP_RAGG(R,Ragg),BIIArea(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BIIArea(R,Y));
BIILArea(Ragg,Y,L)$(SUM(R$MAP_RAGG(R,Ragg),BIILArea(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),BIILArea(R,Y,L));
*-*-

BII(R,Y)$(BIIArea(R,Y))=BVS(R,Y)/BIIArea(R,Y);
BIIL(R,Y,L)$(BIILArea(R,Y,L))=BVSL(R,Y,L)/BIILArea(R,Y,L);

$ontext
parameter
VYLclass(R,Y,LULC_class,G)
VYLclassIJ(Y,LULC_class,I,J)
BIIcoefGclass(LULC_class,G)	the Biodiversity Intactness Index coefficients
BVLGclass(R,Y,LULC_class,G)	biodiversity stock [*.Mha]
BVLclass(R,Y,LULC_class)      biodiversity stock [*.Mha]
BVclass(R,Y)		biodiversity stock [*.Mha]
;

VYLclass(R,Y,LULC_class,G)$sum(L$(map_LLULC_class(L,LULC_class) and (not (LPAS(L) or sameas(L,"FRS") or sameas(L,"GL")))),VYL(R,Y,L,G))
=sum(L$(map_LLULC_class(L,LULC_class) and (not (LPAS(L) or sameas(L,"FRS") or sameas(L,"GL")))),VYL(R,Y,L,G));

*VYLclass(R,Y,LULC_class,G)$(sharepixG(LULC_class,G) * SUM(L$(map_LLULC_class(L,LULC_class) and (LPAS(L) or sameas(L,"FRS") or sameas(L,"GL"))),VYL(R,Y,L,G)))
*=sharepixG(LULC_class,G) * SUM(L$(map_LLULC_class(L,LULC_class) and (LPAS(L) or sameas(L,"FRS") or sameas(L,"GL"))),VYL(R,Y,L,G));

VYLclass(R,Y,"Managed pasture",G)=SUM(L$(LPAS(L) and is_pasture1ORrRangeland0G(G)=1),VYL(R,Y,L,G));
VYLclass(R,Y,"Rangeland",G)=SUM(L$(LPAS(L) and is_pasture1ORrRangeland0G(G)=0),VYL(R,Y,L,G));
VYLclass(R,Y,"Primary vegetation",G)=SUM(L$((sameas(L,"FRS") or sameas(L,"GL")) and is_PrimVeg1ORSecoVeg0G(G)=1),VYL(R,Y,L,G));
VYLclass(R,Y,"Mature and Intermediate secondary vegetation",G)=SUM(L$((sameas(L,"FRS") or sameas(L,"GL")) and is_PrimVeg1ORSecoVeg0G(G)=0),VYL(R,Y,L,G));

VYLclassIJ(Y,LULC_class,I,J)=SUM((G,R)$MAP_GIJ(G,I,J),VYLclass(R,Y,LULC_class,G));

BIIcoefGclass(LULC_class,G)=
BIIcoef0("forested",LULC_class,"value")$(f10_potforest(G) > 0.5)  +
BIIcoef0("nonforested",LULC_class,"value")$(f10_potforest(G) <= 0.5);

BVLGclass(R,Y,LULC_class,G)$(VYLclass(R,Y,LULC_class,G))=RR(G)*BIIcoefGclass(LULC_class,G)*VYLclass(R,Y,LULC_class,G)*GA(G)/10**3;

BVLclass(R,Y,LULC_class)=sum((G)$(BVLGclass(R,Y,LULC_class,G)),BVLGclass(R,Y,LULC_class,G));

BVclass(R,Y)=sum((LULC_class,G)$(BVLGclass(R,Y,LULC_class,G)),BVLGclass(R,Y,LULC_class,G));

BVLclass(Ragg,Y,LULC_class)$(SUM(R$MAP_RAGG(R,Ragg),BVLclass(R,Y,LULC_class)))=SUM(R$MAP_RAGG(R,Ragg),BVLclass(R,Y,LULC_class));
BVclass(Ragg,Y)$(SUM(R$MAP_RAGG(R,Ragg),BVclass(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BVclass(R,Y));
$offtext

execute_unload '../output/gdx/analysis/biodiv_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
BII,BIIL,BIIArea,BVS,BVSL,BVSLDM,BVArea,BVLArea,BIILArea
;

$endif.biodiv

$ifthen.rlimap %rlimapcalc%==on

*--------------------------------------------------------------------------
* Conversion to 8 land-use categories and estimation of land transaction
*--------------------------------------------------------------------------

set
LU_RLI/
$include ../%prog_loc%/individual/BendingTheCurve/LUclass_RLIestimator.set
/
MAP_LU_RLI(L,LU_RLI)/
$include ../%prog_loc%/individual/BendingTheCurve/LUclass_RLIestimator.map
/
MAP_LU_RLItrans(LU_RLI,LU_RLI,LU_RLI)/
$include ../%prog_loc%/individual/BendingTheCurve/LUclass_RLIestimator_trans.map
/
;
alias(LU_RLI,LU_RLI2,LU_RLI3);

parameter
VYLIJ(Y,L,I,J)
VYLRLI(Y,LU_RLI,I,J)
VYLRLIfrs(Y,LU_RLI,I,J)
VYLRLIafr(Y,LU_RLI,I,J)
VYLRLIres(Y,LU_RLI,I,J)

deltaVYL(Y,LU_RLI,I,J)

VYLtrans(Y,LU_RLI,LU_RLI2,I,J)

PRLIestimator(Y,LU_RLI,I,J)

;

VYLIJ(Y,L,I,J)$SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYL(R,Y,L,G))),sum(R,VYL(R,Y,L,G)))=SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYL(R,Y,L,G))),sum(R,VYL(R,Y,L,G)));

VYLRLI(Y,LU_RLI,I,J)$sum((L)$((not sameas(L,"FRS")) and (not sameas(L,"AFR")) and MAP_LU_RLI(L,LU_RLI) and VYLIJ(Y,L,I,J)),VYLIJ(Y,L,I,J))
=sum((L)$((not sameas(L,"FRS")) and (not sameas(L,"AFR")) and MAP_LU_RLI(L,LU_RLI) and VYLIJ(Y,L,I,J)),VYLIJ(Y,L,I,J));
*VYLRLI(Y,LU_RLI,I,J)$sum((L)$(MAP_LU_RLI(L,LU_RLI) and VYLIJ(Y,L,I,J)),VYLIJ(Y,L,I,J))=sum((L)$(MAP_LU_RLI(L,LU_RLI) and VYLIJ(Y,L,I,J)),VYLIJ(Y,L,I,J));

* FRS
VYLRLIfrs(Y,"share.PriFor",I,J)$(VYLIJ(Y,"FRS",I,J) * sharepix("Primary vegetation",I,J)) = VYLIJ(Y,"FRS",I,J) * sharepix("Primary vegetation",I,J);
VYLRLIfrs(Y,"share.MngFor",I,J)$(VYLIJ(Y,"FRS",I,J) * sharepix("Mature and Intermediate secondary vegetation",I,J) + VYLIJ(Y,"AFR",I,J))
= VYLIJ(Y,"FRS",I,J) * sharepix("Mature and Intermediate secondary vegetation",I,J) + VYLIJ(Y,"AFR",I,J);

$ontext
$if %IAV%==NoCC VYLRLIafr(Y,"share.MngFor",I,J)$(VYLIJ(Y,"AFR",I,J))=VYLIJ(Y,"AFR",I,J);
$if %IAV%==NoCC VYLRLIres(Y,"share.RstLnd",I,J)=0;
$if not %IAV%==NoCC VYLRLIafr(Y,"share.MngFor",I,J)=0;
$if not %IAV%==NoCC VYLRLIres(Y,"share.RstLnd",I,J)$(VYLIJ(Y,"AFR",I,J))=VYLIJ(Y,"AFR",I,J);
$offtext


PRLIestimator(Y,LU_RLI,I,J)$(VYLRLI(Y,LU_RLI,I,J)+VYLRLIfrs(Y,LU_RLI,I,J))=VYLRLI(Y,LU_RLI,I,J)+VYLRLIfrs(Y,LU_RLI,I,J);
*PRLIestimator(Y,LU_RLI,I,J)$(VYLRLI(Y,LU_RLI,I,J))=VYLRLI(Y,LU_RLI,I,J);


$ontext
deltaVYL(Y,LU_RLI,I,J)$((not sameas(Y,"2010")) and abs(VYLRLI(Y,LU_RLI,I,J)-VYLRLI(Y-10,LU_RLI,I,J))>10**(-5)) = VYLRLI(Y,LU_RLI,I,J)-VYLRLI(Y-10,LU_RLI,I,J);
deltaVYL(Y,LU_RLI,I,J)$(sameas(Y,"2010") and abs(VYLRLI(Y,LU_RLI,I,J)-VYLRLI(Y-5,LU_RLI,I,J))>10**(-5)) = VYLRLI(Y,LU_RLI,I,J)-VYLRLI(Y-5,LU_RLI,I,J);

VYLtrans(Y,LU_RLI,LU_RLI2,I,J)$(deltaVYL(Y,LU_RLI,I,J)<0 and deltaVYL(Y,LU_RLI2,I,J)>0 and sum(LU_RLI3$(deltaVYL(Y,LU_RLI3,I,J)>0),deltaVYL(Y,LU_RLI3,I,J)))
=(-1)*deltaVYL(Y,LU_RLI,I,J)*deltaVYL(Y,LU_RLI2,I,J)/sum(LU_RLI3$(deltaVYL(Y,LU_RLI3,I,J)>0),deltaVYL(Y,LU_RLI3,I,J));

PRLIestimator(Y,LU_RLI3,I,J)$SUM((LU_RLI,LU_RLI2)$MAP_LU_RLItrans(LU_RLI,LU_RLI2,LU_RLI3),VYLtrans(Y,LU_RLI,LU_RLI2,I,J))
=SUM((LU_RLI,LU_RLI2)$MAP_LU_RLItrans(LU_RLI,LU_RLI2,LU_RLI3),VYLtrans(Y,LU_RLI,LU_RLI2,I,J));
$offtext

PRLIestimator(Y,"Area.1000ha",I,J)$(SUM(LU_RLI3,PRLIestimator(Y,LU_RLI3,I,J))>0)=SUM((G)$MAP_GIJ(G,I,J), GA(G));

execute_unload '../output/gdx/landmap/rlimap_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
PRLIestimator;

$endif.rlimap
*-----------------------------------*








