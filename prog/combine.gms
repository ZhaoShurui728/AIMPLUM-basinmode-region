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
$setglobal agluauto off

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
$include ../%prog_loc%/define/region/region10.set
$include ../%prog_loc%/individual/basin/region_basin.set
World,Non-OECD,ASIA2,R2OECD,R2NonOECD
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
$include ../%prog_loc%/define/region/region10.set
$include ../%prog_loc%/individual/basin/region_basin.set
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
Ragg(R)/
$include ../%prog_loc%/define/region/region5.set
$include ../%prog_loc%/define/region/region10.set
$include ../%prog_loc%/define/region/region17.set
World
/
R17(Ragg)	17 regions	/
$include ../%prog_loc%/define/region/region17.set
/
RBION(Rall)/
$include ../%prog_loc%/define/region/region17exclNations.set
$include ../%prog_loc%/define/region/region_iso.set
$include ../%prog_loc%/define/region/region5.set
$include ../%prog_loc%/define/region/region10.set
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
Sacol /estimated,base_raw,base_adjusted,cge/
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
LUC
"LUC+BIO"
TOT total
TOTwoOL total witout OL

* forest subcategory (composition of FRS excl AFR)
PRMFRS	primary forest
SECFRS	secoundary forest excl AFR
MNGFRS  managed forest excl AFR
UMNFRS  unmanage forest
NRMFRS  naturally regenerating managed forest
PLNFRS  planted forest excl AFR
AGOFRS	agroforestry
AFRS	afforestation
RFRS	reforestation

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
ABD_CUM	Cumulative gross abandoned land including restored area
/
LCROPA(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO,CROP_FLW/
LPAS(L)/PAS/
LAFR(L)/AFR/

LBIO(L)/BIO/
LFRSGL(L)/FRSGL,FRS,GL/
Lused(L)/MNGFRS,AFR,CL,CROP_FLW,BIO,PAS/
Lnat(L)/GL,UMNFRS/
LABD(L)/ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR/
LABDCUM(L)/ABD_CUM/
LRES(L)/RES/
LTOT(L)/FRS,GL,CROP_FLW,CL,PAS,SL,OL,BIO,AFR/
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
MAP_RAGG_basin_17(R,R17)/
$include ../%prog_loc%/individual/Basin/region_basin_17.map
/
Rbasin(R)	basin regions	/
$include      ../%prog_loc%/individual/basin/region_basin.set
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
protectfrac(R,Y,G)	Protected area fraction (0 to 1) in each cell G
protectfracL(R,Y,G,L)	Protected area fraction (0 to 1) of land category L in each cell G
landshareG(G,Rall) Parcentage ratio of land area to grid area (0 to 1)
;

ordy(Y) = ord(Y) + %base_year% -1;

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load GA MAP_RIJ GAIJ MAP_RG
$load landshareG

FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;

$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/USA.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XE25.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XE25
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XER.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XER
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/TUR.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUR
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XOC.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XOC
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/CHN.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/IND.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/JPN.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JPN
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XSE.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XSE
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XSA.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XSA
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/CAN.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/BRA.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XLM.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XLM
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/CIS.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CIS
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XME.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XME
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XNF.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XNF
$if exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/_cbnal/XAF.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XAF
$ifthen.cmbr %agluauto%==on
$offlisting
$if exist '../output/gdx/base/ABW_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ABW_CARC
$if exist '../output/gdx/base/AFG_AMDA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AFG_AMDA
$if exist '../output/gdx/base/AFG_CSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AFG_CSEC
$if exist '../output/gdx/base/AFG_FARA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AFG_FARA
$if exist '../output/gdx/base/AFG_HELM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AFG_HELM
$if exist '../output/gdx/base/AFG_INDU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AFG_INDU
$if exist '../output/gdx/base/AGO_ANGC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AGO_ANGC
$if exist '../output/gdx/base/AGO_ASII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AGO_ASII
$if exist '../output/gdx/base/AGO_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AGO_CONG
$if exist '../output/gdx/base/AGO_ZAMB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AGO_ZAMB
$if exist '../output/gdx/base/ALB_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ALB_AGBS
$if exist '../output/gdx/base/AND_EBRO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AND_EBRO
$if exist '../output/gdx/base/ARE_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARE_ARPA
$if exist '../output/gdx/base/ARG_LAPL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_LAPL
$if exist '../output/gdx/base/ARG_NASA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_NASA
$if exist '../output/gdx/base/ARG_NEGR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_NEGR
$if exist '../output/gdx/base/ARG_PAMP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_PAMP
$if exist '../output/gdx/base/ARG_SACC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_SACC
$if exist '../output/gdx/base/ARG_SASS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_SASS
$if exist '../output/gdx/base/ARG_SGRN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARG_SGRN
$if exist '../output/gdx/base/ARM_CSSW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ARM_CSSW
$if exist '../output/gdx/base/ATG_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ATG_CARI
$if exist '../output/gdx/base/AUS_AEAC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_AEAC
$if exist '../output/gdx/base/AUS_AINT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_AINT
$if exist '../output/gdx/base/AUS_ASCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_ASCO
$if exist '../output/gdx/base/AUS_AUNC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_AUNC
$if exist '../output/gdx/base/AUS_AWEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_AWEC
$if exist '../output/gdx/base/AUS_MRDA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_MRDA
$if exist '../output/gdx/base/AUS_NZLZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUS_NZLZ
$if exist '../output/gdx/base/AUT_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AUT_DANU
$if exist '../output/gdx/base/AZE_CSSW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms AZE_CSSW
$if exist '../output/gdx/base/BDI_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BDI_CONG
$if exist '../output/gdx/base/BDI_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BDI_NILE
$if exist '../output/gdx/base/BEL_MAAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BEL_MAAS
$if exist '../output/gdx/base/BEL_SCHE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BEL_SCHE
$if exist '../output/gdx/base/BEN_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BEN_AFWC
$if exist '../output/gdx/base/BEN_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BEN_NIGE
$if exist '../output/gdx/base/BEN_VOLT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BEN_VOLT
$if exist '../output/gdx/base/BFA_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BFA_AFWC
$if exist '../output/gdx/base/BFA_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BFA_NIGE
$if exist '../output/gdx/base/BFA_VOLT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BFA_VOLT
$if exist '../output/gdx/base/BGD_BBCN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BGD_BBCN
$if exist '../output/gdx/base/BGD_GABR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BGD_GABR
$if exist '../output/gdx/base/BGR_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BGR_AGBS
$if exist '../output/gdx/base/BGR_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BGR_DANU
$if exist '../output/gdx/base/BHR_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BHR_ARPA
$if exist '../output/gdx/base/BHS_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BHS_CARI
$if exist '../output/gdx/base/BIH_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BIH_AGBS
$if exist '../output/gdx/base/BIH_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BIH_DANU
$if exist '../output/gdx/base/BLR_DAUG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BLR_DAUG
$if exist '../output/gdx/base/BLR_DNIP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BLR_DNIP
$if exist '../output/gdx/base/BLR_NEMA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BLR_NEMA
$if exist '../output/gdx/base/BLZ_YUPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BLZ_YUPA
$if exist '../output/gdx/base/BOL_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BOL_AMAZ
$if exist '../output/gdx/base/BOL_LAPL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BOL_LAPL
$if exist '../output/gdx/base/BOL_LPUN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BOL_LPUN
$if exist '../output/gdx/base/BRA_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA_AMAZ
$if exist '../output/gdx/base/BRA_LAPL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA_LAPL
$if exist '../output/gdx/base/BRA_SAOF/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA_SAOF
$if exist '../output/gdx/base/BRA_TOCA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA_TOCA
$if exist '../output/gdx/base/BRA_UBSA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRA_UBSA
$if exist '../output/gdx/base/BRB_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRB_CARC
$if exist '../output/gdx/base/BRN_NBCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BRN_NBCO
$if exist '../output/gdx/base/BTN_GABR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BTN_GABR
$if exist '../output/gdx/base/BWA_ASII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BWA_ASII
$if exist '../output/gdx/base/BWA_LIMP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BWA_LIMP
$if exist '../output/gdx/base/BWA_ORAN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms BWA_ORAN
$if exist '../output/gdx/base/CAF_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAF_CONG
$if exist '../output/gdx/base/CAF_LCHA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAF_LCHA
$if exist '../output/gdx/base/CAN_AOSB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_AOSB
$if exist '../output/gdx/base/CAN_HBCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_HBCO
$if exist '../output/gdx/base/CAN_MACK/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_MACK
$if exist '../output/gdx/base/CAN_NWTT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_NWTT
$if exist '../output/gdx/base/CAN_PACA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_PACA
$if exist '../output/gdx/base/CAN_SNEL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_SNEL
$if exist '../output/gdx/base/CAN_STLA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CAN_STLA
$if exist '../output/gdx/base/CHE_POOO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHE_POOO
$if exist '../output/gdx/base/CHE_RHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHE_RHIN
$if exist '../output/gdx/base/CHE_RHON/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHE_RHON
$if exist '../output/gdx/base/CHL_LPUN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHL_LPUN
$if exist '../output/gdx/base/CHL_NCHI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHL_NCHI
$if exist '../output/gdx/base/CHL_SCPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHL_SCPA
$if exist '../output/gdx/base/CHN_AMUR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN_AMUR
$if exist '../output/gdx/base/CHN_CHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN_CHIN
$if exist '../output/gdx/base/CHN_GOBI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN_GOBI
$if exist '../output/gdx/base/CHN_HHEE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN_HHEE
$if exist '../output/gdx/base/CHN_TARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN_TARI
$if exist '../output/gdx/base/CHN_YANG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CHN_YANG
$if exist '../output/gdx/base/CIV_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CIV_AFWC
$if exist '../output/gdx/base/CIV_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CIV_NIGE
$if exist '../output/gdx/base/CMR_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CMR_CONG
$if exist '../output/gdx/base/CMR_GFGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CMR_GFGU
$if exist '../output/gdx/base/CMR_LCHA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CMR_LCHA
$if exist '../output/gdx/base/CMR_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CMR_NIGE
$if exist '../output/gdx/base/COD_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COD_CONG
$if exist '../output/gdx/base/COG_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COG_CONG
$if exist '../output/gdx/base/COG_GFGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COG_GFGU
$if exist '../output/gdx/base/COL_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COL_AMAZ
$if exist '../output/gdx/base/COL_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COL_CARC
$if exist '../output/gdx/base/COL_CEPC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COL_CEPC
$if exist '../output/gdx/base/COL_MAGD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COL_MAGD
$if exist '../output/gdx/base/COL_ORIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COL_ORIN
$if exist '../output/gdx/base/COM_MADA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms COM_MADA
$if exist '../output/gdx/base/CRI_SCAM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CRI_SCAM
$if exist '../output/gdx/base/CUB_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CUB_CARI
$if exist '../output/gdx/base/CYM_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CYM_CARI
$if exist '../output/gdx/base/CYP_MSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CYP_MSEC
$if exist '../output/gdx/base/CZE_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CZE_DANU
$if exist '../output/gdx/base/CZE_ELBE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CZE_ELBE
$if exist '../output/gdx/base/CZE_ODER/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms CZE_ODER
$if exist '../output/gdx/base/DEU_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DEU_DANU
$if exist '../output/gdx/base/DEU_DGCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DEU_DGCO
$if exist '../output/gdx/base/DEU_ELBE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DEU_ELBE
$if exist '../output/gdx/base/DEU_EWES/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DEU_EWES
$if exist '../output/gdx/base/DEU_RHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DEU_RHIN
$if exist '../output/gdx/base/DJI_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DJI_ARGA
$if exist '../output/gdx/base/DJI_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DJI_RIFT
$if exist '../output/gdx/base/DMA_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DMA_CARI
$if exist '../output/gdx/base/DNK_DGCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DNK_DGCO
$if exist '../output/gdx/base/DOM_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DOM_CARI
$if exist '../output/gdx/base/DZA_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DZA_ANIN
$if exist '../output/gdx/base/DZA_MSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DZA_MSCC
$if exist '../output/gdx/base/DZA_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms DZA_NIGE
$if exist '../output/gdx/base/ECU_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ECU_AMAZ
$if exist '../output/gdx/base/ECU_CEPC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ECU_CEPC
$if exist '../output/gdx/base/EGY_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms EGY_ANIN
$if exist '../output/gdx/base/EGY_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms EGY_ARGA
$if exist '../output/gdx/base/EGY_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms EGY_NILE
$if exist '../output/gdx/base/ERI_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ERI_ARGA
$if exist '../output/gdx/base/ERI_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ERI_NILE
$if exist '../output/gdx/base/ERI_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ERI_RIFT
$if exist '../output/gdx/base/ESP_DOUR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_DOUR
$if exist '../output/gdx/base/ESP_EBRO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_EBRO
$if exist '../output/gdx/base/ESP_GUAD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_GUAD
$if exist '../output/gdx/base/ESP_GUDA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_GUDA
$if exist '../output/gdx/base/ESP_SPAC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_SPAC
$if exist '../output/gdx/base/ESP_SSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_SSEC
$if exist '../output/gdx/base/ESP_TAGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ESP_TAGU
$if exist '../output/gdx/base/EST_BSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms EST_BSCC
$if exist '../output/gdx/base/EST_NARV/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms EST_NARV
$if exist '../output/gdx/base/ETH_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ETH_ARGA
$if exist '../output/gdx/base/ETH_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ETH_NILE
$if exist '../output/gdx/base/ETH_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ETH_RIFT
$if exist '../output/gdx/base/ETH_SHJU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ETH_SHJU
$if exist '../output/gdx/base/FIN_FINL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FIN_FINL
$if exist '../output/gdx/base/FIN_SNCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FIN_SNCC
$if exist '../output/gdx/base/FIN_SWED/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FIN_SWED
$if exist '../output/gdx/base/FJI_SPII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FJI_SPII
$if exist '../output/gdx/base/FRA_FWCX/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRA_FWCX
$if exist '../output/gdx/base/FRA_GIRD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRA_GIRD
$if exist '../output/gdx/base/FRA_LOIR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRA_LOIR
$if exist '../output/gdx/base/FRA_NESO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRA_NESO
$if exist '../output/gdx/base/FRA_RHON/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRA_RHON
$if exist '../output/gdx/base/FRA_SEIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRA_SEIN
$if exist '../output/gdx/base/FRO_SCTD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FRO_SCTD
$if exist '../output/gdx/base/FSM_MICO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms FSM_MICO
$if exist '../output/gdx/base/GAB_GFGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GAB_GFGU
$if exist '../output/gdx/base/GBR_EAWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GBR_EAWC
$if exist '../output/gdx/base/GBR_IREL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GBR_IREL
$if exist '../output/gdx/base/GBR_SCTD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GBR_SCTD
$if exist '../output/gdx/base/GEO_BSSC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GEO_BSSC
$if exist '../output/gdx/base/GEO_CSSW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GEO_CSSW
$if exist '../output/gdx/base/GHA_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GHA_AFWC
$if exist '../output/gdx/base/GHA_VOLT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GHA_VOLT
$if exist '../output/gdx/base/GIN_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GIN_AFWC
$if exist '../output/gdx/base/GIN_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GIN_NIGE
$if exist '../output/gdx/base/GIN_SENE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GIN_SENE
$if exist '../output/gdx/base/GMB_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GMB_AFWC
$if exist '../output/gdx/base/GNB_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GNB_AFWC
$if exist '../output/gdx/base/GNQ_GFGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GNQ_GFGU
$if exist '../output/gdx/base/GRC_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GRC_AGBS
$if exist '../output/gdx/base/GRD_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GRD_CARC
$if exist '../output/gdx/base/GRL_AOIS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GRL_AOIS
$if exist '../output/gdx/base/GTM_GRIJ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GTM_GRIJ
$if exist '../output/gdx/base/GTM_SCAM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GTM_SCAM
$if exist '../output/gdx/base/GTM_YUPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GTM_YUPA
$if exist '../output/gdx/base/GUM_NMIG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GUM_NMIG
$if exist '../output/gdx/base/GUY_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GUY_AMAZ
$if exist '../output/gdx/base/GUY_NESO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms GUY_NESO
$if exist '../output/gdx/base/HKG_CHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms HKG_CHIN
$if exist '../output/gdx/base/HND_SCAM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms HND_SCAM
$if exist '../output/gdx/base/HRV_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms HRV_AGBS
$if exist '../output/gdx/base/HRV_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms HRV_DANU
$if exist '../output/gdx/base/HTI_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms HTI_CARI
$if exist '../output/gdx/base/HUN_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms HUN_DANU
$if exist '../output/gdx/base/IDN_IRJA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IDN_IRJA
$if exist '../output/gdx/base/IDN_JATI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IDN_JATI
$if exist '../output/gdx/base/IDN_KALI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IDN_KALI
$if exist '../output/gdx/base/IDN_SULA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IDN_SULA
$if exist '../output/gdx/base/IDN_SUMA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IDN_SUMA
$if exist '../output/gdx/base/IND_GABR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND_GABR
$if exist '../output/gdx/base/IND_GODA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND_GODA
$if exist '../output/gdx/base/IND_INDU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND_INDU
$if exist '../output/gdx/base/IND_KRIS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND_KRIS
$if exist '../output/gdx/base/IND_SABA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IND_SABA
$if exist '../output/gdx/base/IRL_IREL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRL_IREL
$if exist '../output/gdx/base/IRN_CIRA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRN_CIRA
$if exist '../output/gdx/base/IRN_CSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRN_CSEC
$if exist '../output/gdx/base/IRN_CSSW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRN_CSSW
$if exist '../output/gdx/base/IRN_PGCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRN_PGCO
$if exist '../output/gdx/base/IRN_TIEU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRN_TIEU
$if exist '../output/gdx/base/IRQ_TIEU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms IRQ_TIEU
$if exist '../output/gdx/base/ISL_ICEL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ISL_ICEL
$if exist '../output/gdx/base/ISR_DEAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ISR_DEAS
$if exist '../output/gdx/base/ISR_MSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ISR_MSEC
$if exist '../output/gdx/base/ITA_IECO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ITA_IECO
$if exist '../output/gdx/base/ITA_IWCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ITA_IWCO
$if exist '../output/gdx/base/ITA_MSII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ITA_MSII
$if exist '../output/gdx/base/ITA_POOO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ITA_POOO
$if exist '../output/gdx/base/ITA_TIBE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ITA_TIBE
$if exist '../output/gdx/base/JAM_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JAM_CARI
$if exist '../output/gdx/base/JOR_DEAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JOR_DEAS
$if exist '../output/gdx/base/JOR_EJSS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JOR_EJSS
$if exist '../output/gdx/base/JOR_SIPE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JOR_SIPE
$if exist '../output/gdx/base/JPN_JAPN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms JPN_JAPN
$if exist '../output/gdx/base/KAZ_CSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KAZ_CSEC
$if exist '../output/gdx/base/KAZ_CSPC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KAZ_CSPC
$if exist '../output/gdx/base/KAZ_LKBH/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KAZ_LKBH
$if exist '../output/gdx/base/KAZ_OBBB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KAZ_OBBB
$if exist '../output/gdx/base/KAZ_SYRD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KAZ_SYRD
$if exist '../output/gdx/base/KEN_AECC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KEN_AECC
$if exist '../output/gdx/base/KEN_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KEN_NILE
$if exist '../output/gdx/base/KEN_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KEN_RIFT
$if exist '../output/gdx/base/KEN_SHJU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KEN_SHJU
$if exist '../output/gdx/base/KGZ_LKBH/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KGZ_LKBH
$if exist '../output/gdx/base/KGZ_SYRD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KGZ_SYRD
$if exist '../output/gdx/base/KGZ_TARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KGZ_TARI
$if exist '../output/gdx/base/KHM_GTCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KHM_GTCC
$if exist '../output/gdx/base/KHM_MEKO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KHM_MEKO
$if exist '../output/gdx/base/KIR_KINA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KIR_KINA
$if exist '../output/gdx/base/KNA_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KNA_CARI
$if exist '../output/gdx/base/KOR_NSKU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KOR_NSKU
$if exist '../output/gdx/base/KWT_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KWT_ARPA
$if exist '../output/gdx/base/KWT_TIEU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms KWT_TIEU
$if exist '../output/gdx/base/LAO_MEKO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LAO_MEKO
$if exist '../output/gdx/base/LAO_VNCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LAO_VNCO
$if exist '../output/gdx/base/LBN_DEAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LBN_DEAS
$if exist '../output/gdx/base/LBN_MSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LBN_MSEC
$if exist '../output/gdx/base/LBR_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LBR_AFWC
$if exist '../output/gdx/base/LBY_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LBY_ANIN
$if exist '../output/gdx/base/LBY_MSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LBY_MSCC
$if exist '../output/gdx/base/LCA_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LCA_CARC
$if exist '../output/gdx/base/LIE_RHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LIE_RHIN
$if exist '../output/gdx/base/LKA_SRIL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LKA_SRIL
$if exist '../output/gdx/base/LSO_ORAN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LSO_ORAN
$if exist '../output/gdx/base/LTU_BSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LTU_BSCC
$if exist '../output/gdx/base/LTU_NEMA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LTU_NEMA
$if exist '../output/gdx/base/LUX_RHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LUX_RHIN
$if exist '../output/gdx/base/LVA_BSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LVA_BSCC
$if exist '../output/gdx/base/LVA_DAUG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms LVA_DAUG
$if exist '../output/gdx/base/MAC_XJIA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MAC_XJIA
$if exist '../output/gdx/base/MAR_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MAR_ANIN
$if exist '../output/gdx/base/MAR_ANWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MAR_ANWC
$if exist '../output/gdx/base/MAR_MSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MAR_MSCC
$if exist '../output/gdx/base/MCO_FSCD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MCO_FSCD
$if exist '../output/gdx/base/MDA_BSNC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MDA_BSNC
$if exist '../output/gdx/base/MDA_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MDA_DANU
$if exist '../output/gdx/base/MDA_DNIE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MDA_DNIE
$if exist '../output/gdx/base/MDG_MADA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MDG_MADA
$if exist '../output/gdx/base/MEX_BJCA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_BJCA
$if exist '../output/gdx/base/MEX_MCIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_MCIN
$if exist '../output/gdx/base/MEX_MNCW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_MNCW
$if exist '../output/gdx/base/MEX_RGBV/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_RGBV
$if exist '../output/gdx/base/MEX_RIBA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_RIBA
$if exist '../output/gdx/base/MEX_RIVE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_RIVE
$if exist '../output/gdx/base/MEX_RLER/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_RLER
$if exist '../output/gdx/base/MEX_YUPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MEX_YUPA
$if exist '../output/gdx/base/MKD_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MKD_AGBS
$if exist '../output/gdx/base/MLI_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MLI_ANIN
$if exist '../output/gdx/base/MLI_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MLI_NIGE
$if exist '../output/gdx/base/MLI_SENE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MLI_SENE
$if exist '../output/gdx/base/MLT_MSII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MLT_MSII
$if exist '../output/gdx/base/MMR_BBCN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MMR_BBCN
$if exist '../output/gdx/base/MMR_IRRA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MMR_IRRA
$if exist '../output/gdx/base/MMR_PMAL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MMR_PMAL
$if exist '../output/gdx/base/MMR_SALW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MMR_SALW
$if exist '../output/gdx/base/MMR_SITT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MMR_SITT
$if exist '../output/gdx/base/MNE_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MNE_AGBS
$if exist '../output/gdx/base/MNE_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MNE_DANU
$if exist '../output/gdx/base/MNG_AMUR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MNG_AMUR
$if exist '../output/gdx/base/MNG_GOBI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MNG_GOBI
$if exist '../output/gdx/base/MNG_YENS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MNG_YENS
$if exist '../output/gdx/base/MNP_NMIG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MNP_NMIG
$if exist '../output/gdx/base/MOZ_AECC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MOZ_AECC
$if exist '../output/gdx/base/MOZ_AIOC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MOZ_AIOC
$if exist '../output/gdx/base/MOZ_LIMP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MOZ_LIMP
$if exist '../output/gdx/base/MOZ_ZAMB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MOZ_ZAMB
$if exist '../output/gdx/base/MRT_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MRT_ANIN
$if exist '../output/gdx/base/MRT_ANWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MRT_ANWC
$if exist '../output/gdx/base/MRT_SENE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MRT_SENE
$if exist '../output/gdx/base/MWI_AECC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MWI_AECC
$if exist '../output/gdx/base/MWI_ZAMB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MWI_ZAMB
$if exist '../output/gdx/base/MYS_NBCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MYS_NBCO
$if exist '../output/gdx/base/MYS_PMAL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms MYS_PMAL
$if exist '../output/gdx/base/NAM_ASII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NAM_ASII
$if exist '../output/gdx/base/NAM_NAMC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NAM_NAMC
$if exist '../output/gdx/base/NAM_ORAN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NAM_ORAN
$if exist '../output/gdx/base/NCL_SPII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NCL_SPII
$if exist '../output/gdx/base/NER_LCHA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NER_LCHA
$if exist '../output/gdx/base/NER_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NER_NIGE
$if exist '../output/gdx/base/NGA_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NGA_AFWC
$if exist '../output/gdx/base/NGA_GFGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NGA_GFGU
$if exist '../output/gdx/base/NGA_LCHA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NGA_LCHA
$if exist '../output/gdx/base/NGA_NIGE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NGA_NIGE
$if exist '../output/gdx/base/NIC_SCAM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NIC_SCAM
$if exist '../output/gdx/base/NLD_MAAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NLD_MAAS
$if exist '../output/gdx/base/NLD_RHIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NLD_RHIN
$if exist '../output/gdx/base/NLD_SCHE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NLD_SCHE
$if exist '../output/gdx/base/NOR_ANTC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NOR_ANTC
$if exist '../output/gdx/base/NOR_SNCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NOR_SNCC
$if exist '../output/gdx/base/NOR_SWED/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NOR_SWED
$if exist '../output/gdx/base/NPL_GABR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NPL_GABR
$if exist '../output/gdx/base/NZL_NZLZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms NZL_NZLZ
$if exist '../output/gdx/base/OMN_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms OMN_ARPA
$if exist '../output/gdx/base/PAK_ASAC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PAK_ASAC
$if exist '../output/gdx/base/PAK_HAMU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PAK_HAMU
$if exist '../output/gdx/base/PAK_INDU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PAK_INDU
$if exist '../output/gdx/base/PAK_SABA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PAK_SABA
$if exist '../output/gdx/base/PAN_CEPC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PAN_CEPC
$if exist '../output/gdx/base/PAN_SCAM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PAN_SCAM
$if exist '../output/gdx/base/PER_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PER_AMAZ
$if exist '../output/gdx/base/PER_PERU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PER_PERU
$if exist '../output/gdx/base/PHL_NBCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PHL_NBCO
$if exist '../output/gdx/base/PHL_PHIL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PHL_PHIL
$if exist '../output/gdx/base/PLW_PAEI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PLW_PAEI
$if exist '../output/gdx/base/PNG_FLYY/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PNG_FLYY
$if exist '../output/gdx/base/PNG_IRJA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PNG_IRJA
$if exist '../output/gdx/base/PNG_PNGC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PNG_PNGC
$if exist '../output/gdx/base/PNG_SEPI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PNG_SEPI
$if exist '../output/gdx/base/POL_ODER/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms POL_ODER
$if exist '../output/gdx/base/POL_PLCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms POL_PLCO
$if exist '../output/gdx/base/POL_WISL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms POL_WISL
$if exist '../output/gdx/base/PRI_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRI_CARI
$if exist '../output/gdx/base/PRK_AMUR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRK_AMUR
$if exist '../output/gdx/base/PRK_BHKN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRK_BHKN
$if exist '../output/gdx/base/PRK_NSKU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRK_NSKU
$if exist '../output/gdx/base/PRK_RSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRK_RSEC
$if exist '../output/gdx/base/PRT_DOUR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRT_DOUR
$if exist '../output/gdx/base/PRT_GUAD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRT_GUAD
$if exist '../output/gdx/base/PRT_SPAC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRT_SPAC
$if exist '../output/gdx/base/PRT_TAGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRT_TAGU
$if exist '../output/gdx/base/PRY_LAPL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PRY_LAPL
$if exist '../output/gdx/base/PSE_DEAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PSE_DEAS
$if exist '../output/gdx/base/PSE_MSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms PSE_MSEC
$if exist '../output/gdx/base/QAT_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms QAT_ARPA
$if exist '../output/gdx/base/ROU_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ROU_DANU
$if exist '../output/gdx/base/RUS_AMUR/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_AMUR
$if exist '../output/gdx/base/RUS_LENA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_LENA
$if exist '../output/gdx/base/RUS_OBBB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_OBBB
$if exist '../output/gdx/base/RUS_PACA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_PACA
$if exist '../output/gdx/base/RUS_SNCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_SNCO
$if exist '../output/gdx/base/RUS_SWCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_SWCO
$if exist '../output/gdx/base/RUS_VOLG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_VOLG
$if exist '../output/gdx/base/RUS_YENS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RUS_YENS
$if exist '../output/gdx/base/RWA_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RWA_CONG
$if exist '../output/gdx/base/RWA_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms RWA_NILE
$if exist '../output/gdx/base/SAU_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SAU_ARPA
$if exist '../output/gdx/base/SAU_RSEE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SAU_RSEE
$if exist '../output/gdx/base/SDN_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SDN_ANIN
$if exist '../output/gdx/base/SDN_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SDN_ARGA
$if exist '../output/gdx/base/SDN_LCHA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SDN_LCHA
$if exist '../output/gdx/base/SDN_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SDN_NILE
$if exist '../output/gdx/base/SEN_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SEN_AFWC
$if exist '../output/gdx/base/SEN_SENE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SEN_SENE
$if exist '../output/gdx/base/SGP_PMAL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SGP_PMAL
$if exist '../output/gdx/base/SLB_SOLI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SLB_SOLI
$if exist '../output/gdx/base/SLB_SPII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SLB_SPII
$if exist '../output/gdx/base/SLE_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SLE_AFWC
$if exist '../output/gdx/base/SLV_SCAM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SLV_SCAM
$if exist '../output/gdx/base/SMR_IECO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SMR_IECO
$if exist '../output/gdx/base/SOM_AECC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SOM_AECC
$if exist '../output/gdx/base/SOM_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SOM_ARGA
$if exist '../output/gdx/base/SOM_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SOM_RIFT
$if exist '../output/gdx/base/SOM_SHJU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SOM_SHJU
$if exist '../output/gdx/base/SRB_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SRB_DANU
$if exist '../output/gdx/base/SSD_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SSD_CONG
$if exist '../output/gdx/base/SSD_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SSD_NILE
$if exist '../output/gdx/base/SSD_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SSD_RIFT
$if exist '../output/gdx/base/STP_GFGU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms STP_GFGU
$if exist '../output/gdx/base/SUR_NESO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SUR_NESO
$if exist '../output/gdx/base/SVK_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SVK_DANU
$if exist '../output/gdx/base/SVN_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SVN_AGBS
$if exist '../output/gdx/base/SVN_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SVN_DANU
$if exist '../output/gdx/base/SWE_SWED/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SWE_SWED
$if exist '../output/gdx/base/SWZ_SASC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SWZ_SASC
$if exist '../output/gdx/base/SYR_DEAS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SYR_DEAS
$if exist '../output/gdx/base/SYR_EJSS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SYR_EJSS
$if exist '../output/gdx/base/SYR_MSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SYR_MSEC
$if exist '../output/gdx/base/SYR_TIEU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms SYR_TIEU
$if exist '../output/gdx/base/TCA_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TCA_CARI
$if exist '../output/gdx/base/TCD_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TCD_ANIN
$if exist '../output/gdx/base/TCD_LCHA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TCD_LCHA
$if exist '../output/gdx/base/TGO_AFWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TGO_AFWC
$if exist '../output/gdx/base/TGO_VOLT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TGO_VOLT
$if exist '../output/gdx/base/THA_CHAO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms THA_CHAO
$if exist '../output/gdx/base/THA_GTCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms THA_GTCC
$if exist '../output/gdx/base/THA_MEKO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms THA_MEKO
$if exist '../output/gdx/base/THA_PMAL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms THA_PMAL
$if exist '../output/gdx/base/TJK_AMDA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TJK_AMDA
$if exist '../output/gdx/base/TJK_SYRD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TJK_SYRD
$if exist '../output/gdx/base/TKM_AMDA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TKM_AMDA
$if exist '../output/gdx/base/TKM_CSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TKM_CSEC
$if exist '../output/gdx/base/TLS_JATI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TLS_JATI
$if exist '../output/gdx/base/TTO_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TTO_CARC
$if exist '../output/gdx/base/TUN_ANIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUN_ANIN
$if exist '../output/gdx/base/TUN_MSCC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUN_MSCC
$if exist '../output/gdx/base/TUR_BSSC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUR_BSSC
$if exist '../output/gdx/base/TUR_CSSW/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUR_CSSW
$if exist '../output/gdx/base/TUR_MSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUR_MSEC
$if exist '../output/gdx/base/TUR_TIEU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUR_TIEU
$if exist '../output/gdx/base/TUV_TUVA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TUV_TUVA
$if exist '../output/gdx/base/TZA_AECC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TZA_AECC
$if exist '../output/gdx/base/TZA_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TZA_CONG
$if exist '../output/gdx/base/TZA_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TZA_NILE
$if exist '../output/gdx/base/TZA_RIFT/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms TZA_RIFT
$if exist '../output/gdx/base/UGA_NILE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UGA_NILE
$if exist '../output/gdx/base/UKR_BSNC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UKR_BSNC
$if exist '../output/gdx/base/UKR_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UKR_DANU
$if exist '../output/gdx/base/UKR_DNIE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UKR_DNIE
$if exist '../output/gdx/base/UKR_DNIP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UKR_DNIP
$if exist '../output/gdx/base/UKR_DONN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UKR_DONN
$if exist '../output/gdx/base/URY_LAPL/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms URY_LAPL
$if exist '../output/gdx/base/URY_UBSA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms URY_UBSA
$if exist '../output/gdx/base/USA_COLU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA_COLU
$if exist '../output/gdx/base/USA_GFCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA_GFCO
$if exist '../output/gdx/base/USA_GMAN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA_GMAN
$if exist '../output/gdx/base/USA_MSMM/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA_MSMM
$if exist '../output/gdx/base/USA_NACC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA_NACC
$if exist '../output/gdx/base/USA_PACA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms USA_PACA
$if exist '../output/gdx/base/UZB_AMDA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UZB_AMDA
$if exist '../output/gdx/base/UZB_CSEC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UZB_CSEC
$if exist '../output/gdx/base/UZB_SYRD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms UZB_SYRD
$if exist '../output/gdx/base/VCT_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VCT_CARC
$if exist '../output/gdx/base/VEN_AMAZ/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VEN_AMAZ
$if exist '../output/gdx/base/VEN_CARC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VEN_CARC
$if exist '../output/gdx/base/VEN_MAGD/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VEN_MAGD
$if exist '../output/gdx/base/VEN_NESO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VEN_NESO
$if exist '../output/gdx/base/VEN_ORIN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VEN_ORIN
$if exist '../output/gdx/base/VGB_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VGB_CARI
$if exist '../output/gdx/base/VIR_CARI/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VIR_CARI
$if exist '../output/gdx/base/VNM_HRIV/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VNM_HRIV
$if exist '../output/gdx/base/VNM_MEKO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VNM_MEKO
$if exist '../output/gdx/base/VNM_VNCO/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VNM_VNCO
$if exist '../output/gdx/base/VUT_SPII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms VUT_SPII
$if exist '../output/gdx/base/XKX_AGBS/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XKX_AGBS
$if exist '../output/gdx/base/XKX_DANU/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms XKX_DANU
$if exist '../output/gdx/base/YEM_ARGA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms YEM_ARGA
$if exist '../output/gdx/base/YEM_ARPA/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms YEM_ARPA
$if exist '../output/gdx/base/YEM_RSEE/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms YEM_RSEE
$if exist '../output/gdx/base/ZAF_ANTC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZAF_ANTC
$if exist '../output/gdx/base/ZAF_LIMP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZAF_LIMP
$if exist '../output/gdx/base/ZAF_ORAN/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZAF_ORAN
$if exist '../output/gdx/base/ZAF_SASC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZAF_SASC
$if exist '../output/gdx/base/ZAF_SAWC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZAF_SAWC
$if exist '../output/gdx/base/ZMB_CONG/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZMB_CONG
$if exist '../output/gdx/base/ZMB_ZAMB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZMB_ZAMB
$if exist '../output/gdx/base/ZWE_AIOC/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZWE_AIOC
$if exist '../output/gdx/base/ZWE_ASII/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZWE_ASII
$if exist '../output/gdx/base/ZWE_LIMP/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZWE_LIMP
$if exist '../output/gdx/base/ZWE_ZAMB/basedata.gdx' $batinclude ../%prog_loc%/inc_prog/combineR.gms ZWE_ZAMB
$onlisting
$endif.cmbr

* If the basin-level data exists, it is used at high priority.
Area_base(R17,L,Sacol)$(SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),Area_base(Rbasin,L,Sacol)))=SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),Area_base(Rbasin,L,Sacol));
* If not, 17 reiongal data is used.
Area_base(Ragg,L,Sacol)$(Area_base(Ragg,L,Sacol)=0 and SUM(R$MAP_RAGG(R,Ragg),Area_base(R,L,Sacol)))=SUM(R$MAP_RAGG(R,Ragg),Area_base(R,L,Sacol));

$gdxin '../output/gdx/results/cbnal_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load Psol_stat VYPL=VYP_load pa_road pa_emit pa_lab pa_irri YIELDL_OUT YIELDLDM_OUT
$load protectfrac protectfracL


$gdxin '../output/gdx/results/analysis_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VY_load=VYL GHGL GHGLG GHGLR Area AreaR
$load VYLY CSB_load=CSB

Area(R17,Y,L)$(SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),Area(Rbasin,Y,L)))=SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),Area(Rbasin,Y,L));
Area(Ragg,Y,L)$(Area(Ragg,Y,L)=0 and SUM(R$MAP_RAGG(R,Ragg),Area(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),Area(R,Y,L));
AreaLDM(R,Y,LDM)=SUM(L$MAP_LLDM(L,LDM),Area(R,Y,L));
Area_base(R,L,"estimated")=Area(R,"%base_year%",L);

Area_base(R,"TOT",Sacol)=sum(L$LTOT(L),AREA_base(R,L,Sacol));
Area_base(R,"TOTwoOL",Sacol)=sum(L$LTOT(L),AREA_base(R,L,Sacol))-AREA_base(R,"OL",Sacol);


GHGL(R17,Y,EmitCat,L)$(SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),GHGL(Rbasin,Y,EmitCat,L)))=SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),GHGL(Rbasin,Y,EmitCat,L));
GHGL(Ragg,Y,EmitCat,L)$(GHGL(Ragg,Y,EmitCat,L)=0 and SUM(R$MAP_RAGG(R,Ragg),GHGL(R,Y,EmitCat,L)))=SUM(R$MAP_RAGG(R,Ragg),GHGL(R,Y,EmitCat,L));

CSB(R)=CSB_load(R,"%base_year%");

* Subtract area of the other countries that share the same grid cell from "OL".
VY_load(R,Y,"OL",G)$(landshareG(G,R))=VY_load(R,Y,"OL",G)-(1-landshareG(G,R));

parameter
VY_load2(R,Y,L,G) for basin aggregation
;

* If the basin-level data exists, it is used at high priority. If not, 17 reiongal data is used.
* 1. Basin-level data aggregation
VY_load2(R17,Y,L,G)$(SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),VY_load(Rbasin,Y,L,G)))=SUM(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),VY_load(Rbasin,Y,L,G));
* 2. 17 regional data aggregation if the sum of basin data does not exist.
VY_load2(Ragg,Y,L,G)$(VY_load2(Ragg,Y,L,G)=0 and SUM(R$MAP_RAGG(R,Ragg),VY_load(Ragg,Y,L,G)))=SUM(R$MAP_RAGG(R,Ragg),VY_load(R,Y,L,G));

* The double counting issue was solved by using land share directly.
VY_IJ(Y,L,I,J)$FLAG_IJ(I,J)=SUM((G,R)$MAP_GIJ(G,I,J),VY_load2(R,Y,L,G));
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

*----Protected area map
set
Lmip_protect/
prtct_primf protected fraction of primary forest
prtct_primn protected fraction of primary non-forest
prtct_secdf protected fraction of secondary forest
prtct_secdn protected fraction of secondary non-forest
prtct_pltns protected fraction of plantation forest
prtct_crop  protected fraction of cropland (this is not lumip category)
prtct_all   all protected fraction (this is not lumip category)
/
MAP_Lmip_protect(L,Lmip_protect)/
PRMFRS	.	prtct_primf
SECFRS	.	prtct_secdf
PRMGL	.	prtct_primn
SECGL	.	prtct_secdn
PRMFRS	.	prtct_all
SECFRS	.	prtct_all
PRMGL	.	prtct_all
SECGL	.	prtct_all
*AFR	.	prtct_pltns
/
;
parameter
protect_prmsec(R,Y,G)
VYL_protect(R,Y,Lmip_protect,G)	a fraction of land-use L region R in year Y grid G
;

protect_prmsec(R,Y,G)$(protectfrac(R,Y,G)+protectfracL(R,Y,G,"PRM_SEC"))=max(protectfrac(R,Y,G),protectfracL(R,Y,G,"PRM_SEC"));

*VYL_protect(R,Y,Lmip_protect,G)$(VY_load(R,Y,"FRS",G)+VY_load(R,Y,"GL",G)+VY_load(R,Y,"MNGPAS",G)+VY_load(R,Y,"RAN",G)+VY_load(R,Y,"CROP_FLW",G))=max(protectfrac(R,Y,G),protectfracL(R,Y,G,"PRM_SEC"))*sum(L$(MAP_Lmip_protect(L,Lmip_protect)),VY_load(R,Y,L,G))/(VY_load(R,Y,"FRS",G)+VY_load(R,Y,"GL",G)+VY_load(R,Y,"MNGPAS",G)+VY_load(R,Y,"RAN",G)+VY_load(R,Y,"CROP_FLW",G));
VYL_protect(R,Y,"prtct_primf",G)$(protect_prmsec(R,Y,G)+VY_load(R,Y,"PRMFRS",G))=min(protect_prmsec(R,Y,G),VY_load(R,Y,"PRMFRS",G));
VYL_protect(R,Y,"prtct_secdf",G)=max(0,min(VY_load(R,Y,"SECFRS",G),protect_prmsec(R,Y,G)-VYL_protect(R,Y,"prtct_primf",G)));
VYL_protect(R,Y,"prtct_primn",G)$(protect_prmsec(R,Y,G)+VY_load(R,Y,"PRMGL",G))=min(protect_prmsec(R,Y,G),VY_load(R,Y,"PRMGL",G));
VYL_protect(R,Y,"prtct_secdn",G)=max(0,min(VY_load(R,Y,"SECGL",G),protect_prmsec(R,Y,G)-VYL_protect(R,Y,"prtct_primn",G)));
VYL_protect(R,Y,"prtct_crop",G)=protectfracL(R,Y,G,"CL");

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
VYL_protect
VY_IJ
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
X(Y,L,I,J) 	Cumulative abandoned area of land use category i and year t only considering increase of abandoned area
XF(Y,L,I,J) 	Cumulative abandoned area of land use category i and year t (final outcome)
Remain(Y,L,I,J)		Land area of land use category i and year t that can be abandoned or restored
RPA(Y,L,Y2,I,J)	Restore potential land area of land use category L and year Y that has been categorized as abandoned (abandoned-crop abandoned-pasture and abandoned-biocrop) from the year Y2
RSP(Y,L,Y2,I,J)	Restored potential land area of land use category i and year Y from the year Y2 but it includes the land that is reused by human activity
RSfrom(Y,L,Y2,I,J)	Restore land area originally categorized as land use category L and year Y from the year Y2
RS(Y,L,Y2,I,J)	Restore land area of land use category L and year Y from the year Y2 (final outcome)
RSF(Y,L,I,J)	Restore land area of land use category L and year Y
ABD(Y,L,I,J)	Abandoned land area of land use category L and year Y
*YND(Y,L,I,J)
ZT(Y,I,J)	Cumulative incrased area of natural land (UMNFRS and GL)
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
VW(Y,L,I,J)	Land area of land use category L and year Y where land is restored considering the 30 years delay from the time of abandance (fraction)
VW2(Y,L,I,J)	Land area of land use category L and year Y where land is restored considering the 30 years delay from the time of abandance (averaged for the cell occupided by more than one countries) (fraction)
VW_reg(Y,L,R)	Land area of land use category L and year Y where land is restored considering the 30 years delay from the time of abandance in region R (kha)
VU(Y,L,I,J)	Land area of land use category L and year Y where land is restored at the same time as abandance
VU2(Y,L,I,J)	Land area of land use category L and year Y where land is restored at the same time as abandance (averaged for the cell occupided by more than one countries) (fraction)
VU_reg(Y,L,R)	Land area of land use category L and year Y where land is restored at the same time as abandance
;

VW(Y,L,I,J)$(VY_IJ(Y,L,I,J))=VY_IJ(Y,L,I,J);
VW(Y,L,I,J)$(LRES(L) and RSF(Y,L,I,J))=RSF(Y,L,I,J);
VW(Y,L,I,J)$(LABD(L) and ABD(Y,L,I,J))=ABD(Y,L,I,J);
VW(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J)>0)=max(0,VY_IJ(Y,L,I,J)-SUM(L2,RSF(Y,L2,I,J))-SUM(L3,ABD(Y,L3,I,J)));
VW(Y,L,I,J)$(LABDCUM(L) and sum(L2$(LABD(L2)),XF(Y,L2,I,J)))=sum(L2$(LABD(L2)),XF(Y,L2,I,J));

VU(Y,L,I,J)$(VY_IJ(Y,L,I,J))=VY_IJ(Y,L,I,J);
VU(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J) and SUM(L2,XF(Y,L2,I,J)))=max(0,VY_IJ(Y,L,I,J)-SUM(L2,XF(Y,L2,I,J)));

VU(Y,L,I,J)$(LRES(L) and SUM(L2,XF(Y,L2,I,J)))=SUM(L2,XF(Y,L2,I,J));

VW(Y,L,I,J)$(VW(Y,L,I,J)<10**(-7) AND VW(Y,L,I,J)>(-1)*10**(-7))=0;
VU(Y,L,I,J)$(VU(Y,L,I,J)<10**(-7) AND VU(Y,L,I,J)>(-1)*10**(-7))=0;

* To avoid double counting in cell which is included in two countries due to just 50% share of land area, sum of land share is divided by the number of countires.
*VW2(Y,L,I,J)$FLAG_IJ(I,J)=SUM(R$(MAP_RIJ(R,I,J)),VW(Y,L,I,J))/SUM(R$(MAP_RIJ(R,I,J)),1);
VW_reg(Y,L,R)=sum((I,J)$MAP_RIJ(R,I,J),VW(Y,L,I,J)*GAIJ(I,J));
VW_reg(Y,L,R17)$(sum(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),VW_reg(Y,L,Rbasin)))=sum(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),VW_reg(Y,L,Rbasin));
VW_reg(Y,L,R)$(VW_reg(Y,L,R)=0 and sum(R2$MAP_Ragg(R2,R),VW_reg(Y,L,R2)))=sum(R2$MAP_Ragg(R2,R),VW_reg(Y,L,R2));
*VU2(Y,L,I,J)$FLAG_IJ(I,J)=SUM(R$(MAP_RIJ(R,I,J)),VU(Y,L,I,J))/SUM(R$(MAP_RIJ(R,I,J)),1);
VU_reg(Y,L,R)=sum((I,J)$MAP_RIJ(R,I,J),VU(Y,L,I,J)*GAIJ(I,J));
VU_reg(Y,L,R17)$(sum(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),VU_reg(Y,L,Rbasin)))=sum(Rbasin$MAP_RAGG_basin_17(Rbasin,R17),VU_reg(Y,L,Rbasin));
VU_reg(Y,L,R)$(VU_reg(Y,L,R)=0 and sum(R2$MAP_Ragg(R2,R),VU_reg(Y,L,R2)))=sum(R2$MAP_Ragg(R2,R),VU_reg(Y,L,R2));


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

execute_unload '../output/gdx/analysis/btc_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
VY_IJwwfnum,VW_reg,VU_reg
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
Alias (Sl,Sl2),(Slnum,Slnum2),(R,R2),(R17,R172),(Rbasin,Rbasin2);
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

OUTPUTAC_load(*,Y,R17,ALIV,CLIV)	Output (Production) of commodity C from sector A  (mil.$ or ktoe) (cge output)
OUTPUTSL(Y,R17,Sl)	Output (Production) of commodity C from sector A (mil.$ or ktoe) (cge output)
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
parameter
pas_rate(R,I,J) pasture share rate in a grid cell
;
pas_rate(R17,I,J)$(sum(R172$MAP_RIJ(R172,I,J),VY_IJ(Y,"PAS",I,J)))=sum(R17$MAP_RIJ(R17,I,J),VY_IJ(Y,"PAS",I,J))/sum(R172$MAP_RIJ(R172,I,J),VY_IJ(Y,"PAS",I,J));
pas_rate(Rbasin,I,J)$(sum(Rbasin2$MAP_RIJ(Rbasin2,I,J),VY_IJ(Y,"PAS",I,J)))=sum(Rbasin$MAP_RIJ(Rbasin,I,J),VY_IJ(Y,"PAS",I,J))/sum(Rbasin2$MAP_RIJ(Rbasin2,I,J),VY_IJ(Y,"PAS",I,J));

OUTPUTSL(Y,R17,Sl)=SUM(ALIV$MAP_SALIV(Sl,ALIV),SUM(CLIV$MAP_SCLIV(Sl,CLIV),OUTPUTAC_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,R17,ALIV,CLIV)));

liv_regbase(Sl,R)=sum((I,J)$MAP_RIJ(R,I,J),liv_dist_base(Sl,I,J)*pas_rate(R,I,J));

liv_dist_baseave(Sl,R)=sum((I,J)$(MAP_RIJ(R,I,J) and liv_dist_base(Sl,I,J)),liv_dist_base(Sl,I,J)*pas_rate(R,I,J));

liv_dist_base0(Sl,Y,I,J)=liv_dist_base(Sl,I,J);
liv_dist_base0(Sl,Y,I,J)$(liv_dist_base(Sl,I,J)=0 and VY_IJ("%base_year%","PAS",I,J)=0 and VY_IJ(Y,"PAS",I,J))=sum(R$(MAP_RIJ(R,I,J)),liv_dist_baseave(Sl,R));

liv_regtar(Sl,Y,R17)$OUTPUTSL("%base_year%",R17,Sl)=liv_regbase(Sl,R17) * OUTPUTSL(Y,R17,Sl)/OUTPUTSL("%base_year%",R17,Sl);
liv_regtar(Sl,Y,Rbasin)$sum(R17$MAP_RAGG_basin_17(Rbasin,R17),OUTPUTSL("%base_year%",R17,Sl))=liv_regbase(Sl,Rbasin) * sum(R17$MAP_RAGG_basin_17(Rbasin,R17),OUTPUTSL(Y,R17,Sl)/OUTPUTSL("%base_year%",R17,Sl));
*liv_regwopas(Sl,Y,R)=sum((I,J)$(MAP_RIJ(R,I,J) and VY_IJ("%base_year%","PAS",I,J)=0 and VY_IJ(Y,"PAS",I,J)=0),liv_dist_base(Sl,I,J));
*liv_regonpas(Sl,Y,R)=liv_regtar(Sl,Y,R)-liv_regwopas(Sl,Y,R);

prod_regsf(Sl,Y,R)$liv_regbase(Sl,R)=liv_regtar(Sl,Y,R)/liv_regbase(Sl,R);
*area_regsf(Sl,Y,R)$(sum((I,J)$(MAP_RIJ(R,I,J)),VY_IJ("%base_year%","PAS",I,J)*GAIJ(I,J)))=sum((I,J)$(MAP_RIJ(R,I,J)),VY_IJ(Y,"PAS",I,J)*GAIJ(I,J))/sum((I,J)$(MAP_RIJ(R,I,J)),VY_IJ("%base_year%","PAS",I,J)*GAIJ(I,J));
*head_regsf(Sl,Y,R)$area_regsf(Sl,Y,R)=prod_regsf(Sl,Y,R)/area_regsf(Sl,Y,R);


liv_dist(Sl,"%base_year%",I,J)=liv_dist_base(Sl,I,J);
liv_dist(Sl,Y,I,J)$(liv_dist_base0(Sl,Y,I,J) and Y.val>%base_year%)=liv_dist_base0(Sl,Y,I,J)*sum(R$(MAP_RIJ(R,I,J)),prod_regsf(Sl,Y,R));


*liv_reg(Sl,Y,R)=sum((I,J)$MAP_RIJ(R,I,J),liv_dist(Sl,Y,I,J));
liv_reg(Sl,Y,R)=sum((I,J)$MAP_RIJ(R,I,J),liv_dist(Sl,Y,I,J)*pas_rate(R,I,J));
liv_reg(Sl,Y,R)$(liv_reg(Sl,Y,R)=0 and sum(R2$MAP_Ragg(R2,R),liv_reg(Sl,Y,R2)))=sum(R2$MAP_Ragg(R2,R),liv_reg(Sl,Y,R2));


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
PBIOSUP(Ragg,Y,G,LB,Scol)$(PBIOSUP(R,Y,G,LB,Scol)=0 and Ysupcuv(Y) AND SUM(R$MAP_RAGG(R,Ragg),PBIOSUP(R,Y,G,LB,Scol)))=SUM(R$MAP_RAGG(R,Ragg),PBIOSUP(R,Y,G,LB,Scol));
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
BVS(Ragg,Y)$(BVS(Ragg,Y)=0 and SUM(R$MAP_RAGG(R,Ragg),BVS(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BVS(R,Y));
BVSL(Ragg,Y,L)$(BVSL(Ragg,Y,L)=0 and SUM(R$MAP_RAGG(R,Ragg),BVSL(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),BVSL(R,Y,L));
BVSLDM(Ragg,Y,LDM)$(BVSLDM(Ragg,Y,LDM)=0 and SUM(R$MAP_RAGG(R,Ragg),BVSLDM(R,Y,LDM)))=SUM(R$MAP_RAGG(R,Ragg),BVSLDM(R,Y,LDM));
BVArea(Ragg,Y)$(BVArea(Ragg,Y)=0 and SUM(R$MAP_RAGG(R,Ragg),BVArea(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BVArea(R,Y));
BVLArea(Ragg,Y,L)$(BVLArea(Ragg,Y,L)=0 and SUM(R$MAP_RAGG(R,Ragg),BVLArea(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),BVLArea(R,Y,L));
BIIArea(Ragg,Y)$(BIIArea(Ragg,Y)=0 and SUM(R$MAP_RAGG(R,Ragg),BIIArea(R,Y)))=SUM(R$MAP_RAGG(R,Ragg),BIIArea(R,Y));
BIILArea(Ragg,Y,L)$(BIILArea(Ragg,Y,L)=0 and SUM(R$MAP_RAGG(R,Ragg),BIILArea(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),BIILArea(R,Y,L));
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








