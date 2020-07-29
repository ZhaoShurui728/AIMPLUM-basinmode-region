$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ..\AIMPLUM
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC

$setglobal biocurve off
$setglobal supcuvout off
$setglobal costcalc off
$setglobal bioyieldcalc off
$setglobal biodivcalc off
$setglobal rlimapcalc on
*$setglobal restoration off




$include %prog_dir%/scenario/socioeconomic/%sce%.gms
$include %prog_dir%/scenario/climate_policy/%clp%.gms
$include %prog_dir%/scenario/IAV/%iav%.gms

Set
N /1*40000/
Rall	17 regions + 106 countries	/
XE25	EU
XLM	Rest of Brazil
CIS	Former USSR
XNF	North Africa
XAF	Sub-Sahara
*$include %prog_dir%/\define\region/region17.set
$include %prog_dir%/\define\country.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
R(Rall)	17 regions	/
$include %prog_dir%/\define\region/region17.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
Ragg(R)/
WLD,OECD90,REF,ASIA,MAF,LAM
/
RBION(Rall)/
XE25	EU
XLM	Rest of Brazil
CIS	Former USSR
XNF	North Africa
XAF	Sub-Sahara
*$include %prog_dir%/\define\region/region17.set
$include %prog_dir%/\define\country.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
Sr(Rall)	106 countries /
$include %prog_dir%/\define\country.set
/
Map_R(Sr,R) /
$include %prog_dir%/\define\region/region17.map
/
G	Cell number  /
$offlisting
*$include %prog_dir%/\define\set_g\G_WLD.set
$include %prog_dir%/\define\set_g\G_USA.set
$include %prog_dir%/\define\set_g\G_XE25.set
$include %prog_dir%/\define\set_g\G_XER.set
$include %prog_dir%/\define\set_g\G_TUR.set
$include %prog_dir%/\define\set_g\G_XOC.set
$include %prog_dir%/\define\set_g\G_CHN.set
$include %prog_dir%/\define\set_g\G_IND.set
$include %prog_dir%/\define\set_g\G_JPN.set
$include %prog_dir%/\define\set_g\G_XSE.set
$include %prog_dir%/\define\set_g\G_XSA.set
$include %prog_dir%/\define\set_g\G_CAN.set
$include %prog_dir%/\define\set_g\G_BRA.set
$include %prog_dir%/\define\set_g\G_XLM.set
$include %prog_dir%/\define\set_g\G_CIS.set
$include %prog_dir%/\define\set_g\G_XME.set
$include %prog_dir%/\define\set_g\G_XNF.set
$include %prog_dir%/\define\set_g\G_XAF.set
$onlisting
/

Y year	/  %base_year%*%end_year%  /
Ysupcuv(Y) year	/
*2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100
*2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100
2030,2050,2100
/
ST	/SSOLVE,SMODEL/
SP	/SMCP,SNLP,SLP/
Scol	/quantity,price,yield,area/
Sacol	/cge,base/
L land use type /
*PRM_SEC	forest + grassland + pasture
FRSGL	forest + grassland
FRS	forest
GL
HAV_FRS production forest
AFR	afforestation
PAS	grazing pasture
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
BIO     bio crops
CROP_FLW        fallow land
SL      built_up
OL      ice or water
CL	cropland
LUC
RES
/
LCROPA(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF,BIO,CROP_FLW/
LPAS(L)/PAS/
LAFR(L)/AFR/
LBIO(L)/BIO/
LFRSGL(L)/FRSGL,FRS,GL/
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
RES
/
LFRSGLDM(LDM)/FRSGL,FRS,GL/
LDMCROPA(LDM)/PDR,WHT,GRO,OSD,C_B,OTH_A,BIO,CROP_FLW/
MAP_LLDM(L,LDM)/
*PRM_SEC .       PRM_SEC
HAV_FRS .       HAV_FRS
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
;
Alias(R,R2),(G,G2),(LB,LB2);
set
MAP_RAGG(R,R2)	/
$include %prog_dir%\define/region/region17_agg.map
/
I /1*360/
J /1*720/
LULC_class/
$include %prog_dir%/individual/BendingTheCurve/LULC_class.set
/
MAP_GIJ(G,I,J)
;
$gdxin '%prog_dir%/data/data_prep.gdx'
$load MAP_GIJ


parameter
Psol_stat(R,Y,ST,SP)                  Solution report
PBIOSUP_load(Y,G,LB,Scol)
PBIOSUP(Rall,Y,G,LB,Scol)
Area(R,Y,L)	million ha
AreaLDM(R,Y,LDM)	million ha
Area_base(R,L,Sacol)
CSB(R)
GHGL(R,Y,L)
GA(G)		Grid area of cell G kha
YBIO(R,Y,G)
PCBIO_load(Y,R)	average price to meet the given bioenergy amount [$ per GJ]
QCBIO_load(Y,R)	quantity to meet the given bioenergy price [EJ per year]
PCBIO(R,Y)	average price to meet the given bioenergy amount [$ per GJ]
QCBIO(R,Y)	quantity to meet the given bioenergy price [EJ per year]

YIELD(R,Y,L,G)
YIELD_load(R,L,G)
VYL(R,Y,L,G)	a fraction of land-use L region R in year Y grid G
VYPL(R,Y,L,G)
pa_road(R,Y,L,G)
pa_emit(R,Y,G)
pa_lab(R,Y)
pa_irri(R,Y,L)
ordy(Y)
MFA(R)     management factor for bio crops in base year
MFB(R)     management factor for bio crops (coefficient)
YIELDL_OUT(R,Y,L)	Agerage yield of land category L region R in year Y [tonne per ha per year]
YIELDLDM_OUT(R,Y,LDM)	Agerage yield of land category L region R in year Y [tonne per ha per year]
RR(G)	the range-rarity map
BIIcoefG(L,G)	the Biodiversity Intactness Index (BII) coefficients
sharepix(LULC_class,I,J)
VYLAFR_baunocc(R,Y,G)	a fraction of land-use 'AFR' region R in year Y grid G
VYLAFR_baubiod(R,Y,G)	a fraction of land-use 'AFR' region R in year Y grid G
protectfracL(R,G,L)	Protected area fraction (0 to 1) of land category L in land area of the category L in each cell G
;

ordy(Y) = ord(Y) + %base_year% -1;

$ifthen %biocurve%==on
$gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/bio.gdx'
$load PCBIO_load=PCBIO QCBIO_load=QCBIO
$if %supcuvout%==on $load PBIOSUP_load=PBIOSUP

PCBIO(R,Y)=PCBIO_load(Y,R);
QCBIO(R,Y)=QCBIO_load(Y,R);
$endif

$gdxin '%prog_dir%/data/Data_prep.gdx'
$load GA

$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/USA.gdx' $batinclude %prog_dir%/prog/combineR.gms USA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XE25.gdx' $batinclude %prog_dir%/prog/combineR.gms XE25
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XER.gdx' $batinclude %prog_dir%/prog/combineR.gms XER
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/TUR.gdx' $batinclude %prog_dir%/prog/combineR.gms TUR
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XOC.gdx' $batinclude %prog_dir%/prog/combineR.gms XOC
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/CHN.gdx' $batinclude %prog_dir%/prog/combineR.gms CHN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/IND.gdx' $batinclude %prog_dir%/prog/combineR.gms IND
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/JPN.gdx' $batinclude %prog_dir%/prog/combineR.gms JPN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XSE.gdx' $batinclude %prog_dir%/prog/combineR.gms XSE
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XSA.gdx' $batinclude %prog_dir%/prog/combineR.gms XSA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/CAN.gdx' $batinclude %prog_dir%/prog/combineR.gms CAN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/BRA.gdx' $batinclude %prog_dir%/prog/combineR.gms BRA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XLM.gdx' $batinclude %prog_dir%/prog/combineR.gms XLM
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/CIS.gdx' $batinclude %prog_dir%/prog/combineR.gms CIS
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XME.gdx' $batinclude %prog_dir%/prog/combineR.gms XME
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XNF.gdx' $batinclude %prog_dir%/prog/combineR.gms XNF
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XAF.gdx' $batinclude %prog_dir%/prog/combineR.gms XAF

Area(Ragg,Y,L)$(SUM(R$MAP_RAGG(R,Ragg),Area(R,Y,L)))=SUM(R$MAP_RAGG(R,Ragg),Area(R,Y,L));

AreaLDM(R,Y,LDM)=SUM(L$MAP_LLDM(L,LDM),Area(R,Y,L));

Area_base(Ragg,L,Sacol)$(SUM(R$MAP_RAGG(R,Ragg),Area_base(R,L,Sacol)))=SUM(R$MAP_RAGG(R,Ragg),Area_base(R,L,Sacol));

GHGL(Ragg,Y,L)$SUM(R$MAP_RAGG(R,Ragg),GHGL(R,Y,L))=SUM(R$MAP_RAGG(R,Ragg),GHGL(R,Y,L));


*----- Yield
$ifthen %bioyieldcalc%==on

parameter
MF(L,R,Y)      management factor for bio crops

;
MF(L,R,Y)$(NOT LBIO(L))=1;
MF(L,R,Y)$(MFA(R) AND LBIO(L))=min(0.8/MFA(R),MFB(R)**max(0,ordy(Y)-2010));

YIELD(R,Y,L,G)$(YIELD_load(R,L,G))=YIELD_load(R,L,G)*MF(L,R,Y);
parameter
YIELD_BIO(R,Y,G)
;
YIELD_BIO(R,Y,G)=YIELD(R,Y,"BIO",G);

$endif

*-----Land transition cost
$ifthen %costcalc%==on

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

pa(R,Y,L,G) = pa_lab(R,Y) + pa_road(R,Y,L,G)  + pa_irri(R,Y,L) + pa_emit(R,Y,G)$(NOT LFRSGL(L));

*PAL(R,Y,L,"total")$SUM(G$(pa(R,Y,L,G) * YIELD(L,G) * VYPL(L,G)), YIELD(L,G) * GA(G) *VYPL(L,G))
*=SUM(G$(pa(R,Y,L,G) * YIELD(L,G) * VYPL(L,G)),pa(R,Y,L,G) * YIELD(L,G) * GA(G) *VYPL(L,G)) /SUM(G$(pa(R,Y,L,G) * YIELD(L,G) * VYPL(L,G)), YIELD(L,G) * GA(G) *VYPL(L,G))*(10**6);
PAL(R,Y,L,"road")$SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))
=SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)) /SUM(G$(pa_road(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))*(10**6);
PAL(R,Y,L,"emit")$((NOT LFRSGL(L)) AND SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)))
=SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), pa_emit(R,Y,G) * YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G)) /SUM(G$(pa_emit(R,Y,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * GA(G) *VYPL(R,Y,L,G))*(10**6);
PAL(R,Y,L,"lab")$SUM(G$(pa(R,Y,L,G) * YIELD(R,Y,L,G) * VYPL(R,Y,L,G)), YIELD(R,Y,L,G) * VYPL(R,Y,L,G))=pa_lab(R,Y)*(10**6);
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

$endif

*----Bioenergy supply curve SOATED ---*

$ifthen %supcuvout%==on

set
MAP_RG(R,G)     Relationship between country R and cell G
MAP_SrG(Sr,G)	Relationship between country Sr and cell G
;
$gdxin '%prog_dir%/data/Data_prep.gdx'
$load MAP_RG
$gdxin '%prog_dir%/data/MAP_SrG_tmp.gdx'
$load MAP_SrG

PBIOSUP(R,Y,G,LB,Scol)$MAP_RG(R,G)=PBIOSUP_load(Y,G,LB,Scol);
PBIOSUP(Ragg,Y,G,LB,Scol)$(Ysupcuv(Y) AND SUM(R$MAP_RAGG(R,Ragg),PBIOSUP(R,Y,G,LB,Scol)))=SUM(R$MAP_RAGG(R,Ragg),PBIOSUP(R,Y,G,LB,Scol));
PBIOSUP(Sr,Y,G,LB,Scol)$MAP_SrG(Sr,G)=PBIOSUP_load(Y,G,LB,Scol);

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

execute_unload '../output/gdx/all/biosupcuv/biosupcuv_%SCE%_%CLP%_%IAV%.gdx'
PBIOSOAT
;

$endif

*--- Interporation of yield to fed back to AIM/CGE ---*
parameter
YIELDLDM_ratio(R,Y,LDM)
YIELDLDM_annual(R,Y,LDM)
;

YIELDLDM_ratio(R,Y,LDM)$(ordy(Y)>2010 and YIELDLDM_OUT(R,Y,LDM)>0 and YIELDLDM_OUT(R,Y-10,LDM)>0)=(YIELDLDM_OUT(R,Y,LDM)/YIELDLDM_OUT(R,Y-10,LDM))**(1/10);
YIELDLDM_ratio(R,Y,LDM)$(ordy(Y)=2010 and YIELDLDM_OUT(R,Y,LDM) and YIELDLDM_OUT(R,Y-5,LDM))=(YIELDLDM_OUT(R,Y,LDM)/YIELDLDM_OUT(R,Y-5,LDM))**(1/5);

YIELDLDM_annual(R,Y,LDM)$(2005<=ordy(Y) and ordy(Y)<2010)=YIELDLDM_OUT(R,"2005",LDM)*YIELDLDM_ratio(R,"2010",LDM)**(ordy(Y)-2005);
YIELDLDM_annual(R,Y,LDM)$(2010<=ordy(Y) and ordy(Y)<2020)=YIELDLDM_OUT(R,"2010",LDM)*YIELDLDM_ratio(R,"2020",LDM)**(ordy(Y)-2010);
YIELDLDM_annual(R,Y,LDM)$(2020<=ordy(Y) and ordy(Y)<2030)=YIELDLDM_OUT(R,"2020",LDM)*YIELDLDM_ratio(R,"2030",LDM)**(ordy(Y)-2020);
YIELDLDM_annual(R,Y,LDM)$(2030<=ordy(Y) and ordy(Y)<2040)=YIELDLDM_OUT(R,"2030",LDM)*YIELDLDM_ratio(R,"2040",LDM)**(ordy(Y)-2030);
YIELDLDM_annual(R,Y,LDM)$(2040<=ordy(Y) and ordy(Y)<2050)=YIELDLDM_OUT(R,"2040",LDM)*YIELDLDM_ratio(R,"2050",LDM)**(ordy(Y)-2040);
YIELDLDM_annual(R,Y,LDM)$(2050<=ordy(Y) and ordy(Y)<2060)=YIELDLDM_OUT(R,"2050",LDM)*YIELDLDM_ratio(R,"2060",LDM)**(ordy(Y)-2050);
YIELDLDM_annual(R,Y,LDM)$(2060<=ordy(Y) and ordy(Y)<2070)=YIELDLDM_OUT(R,"2060",LDM)*YIELDLDM_ratio(R,"2070",LDM)**(ordy(Y)-2060);
YIELDLDM_annual(R,Y,LDM)$(2070<=ordy(Y) and ordy(Y)<2080)=YIELDLDM_OUT(R,"2070",LDM)*YIELDLDM_ratio(R,"2080",LDM)**(ordy(Y)-2070);
YIELDLDM_annual(R,Y,LDM)$(2080<=ordy(Y) and ordy(Y)<2090)=YIELDLDM_OUT(R,"2080",LDM)*YIELDLDM_ratio(R,"2090",LDM)**(ordy(Y)-2080);
YIELDLDM_annual(R,Y,LDM)$(2090<=ordy(Y) and ordy(Y)<=2100)=YIELDLDM_OUT(R,"2090",LDM)*YIELDLDM_ratio(R,"2100",LDM)**(ordy(Y)-2090);

*----Biodiversity value estimates  (WWF project) ----*
$ifthen %biodivcalc%==on

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

* Reginoal aggregation
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
$endif

$ifthen %rlimapcalc%==on

* Conversion to 8 land-use categories and estimation of land transaction
set
LU_RLI/
$include %prog_dir%/individual/BendingTheCurve/LUclass_RLIestimator.set
/
MAP_LU_RLI(L,LU_RLI)/
$include %prog_dir%/individual/BendingTheCurve/LUclass_RLIestimator.map
/
MAP_LU_RLItrans(LU_RLI,LU_RLI,LU_RLI)/
$include %prog_dir%/individual/BendingTheCurve/LUclass_RLIestimator_trans.map
/
;
alias(LU_RLI,LU_RLI2,LU_RLI3);

parameter
VYLIJ(Y,L,I,J)
VYLAFRIJ_baunocc(Y,I,J)
VYLAFRIJ_baubiod(Y,I,J)

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

$ontext
$ifthen.afr not %IAV%==NoCC

VYLAFRIJ_baunocc(Y,I,J)$SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYLAFR_baunocc(R,Y,G))),sum(R,VYLAFR_baunocc(R,Y,G)))=SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYLAFR_baunocc(R,Y,G))),sum(R,VYLAFR_baunocc(R,Y,G)));
VYLAFRIJ_baubiod(Y,I,J)$SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYLAFR_baubiod(R,Y,G))),sum(R,VYLAFR_baubiod(R,Y,G)))=SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYLAFR_baubiod(R,Y,G))),sum(R,VYLAFR_baubiod(R,Y,G)));


VYLRLIafr(Y,"share.MngFor",I,J)=VYLAFRIJ_baunocc(Y,I,J) + (VYLIJ(Y,"AFR",I,J) -VYLAFRIJ_baubiod(Y,I,J))$((VYLIJ(Y,"AFR",I,J) -VYLAFRIJ_baubiod(Y,I,J))>0);
VYLRLIres(Y,"share.RstLnd",I,J)$(VYLAFRIJ_baubiod(Y,I,J)-VYLAFRIJ_baunocc(Y,I,J)>0)=VYLAFRIJ_baubiod(Y,I,J)-VYLAFRIJ_baunocc(Y,I,J);

$else.afr

VYLRLIafr(Y,"share.MngFor",I,J)$(VYLIJ(Y,"AFR",I,J))=VYLIJ(Y,"AFR",I,J);
VYLRLIres(Y,"share.RstLnd",I,J)=0;

$endif.afr
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

$endif
*-----------------------------------*

execute_unload '../output/gdx/analysis/%SCE%_%CLP%_%IAV%.gdx'
Psol_stat
Area
AreaLDM
Area_base
CSB
GHGL
$if %biocurve%==on PCBIO
$if %biocurve%==on QCBIO
$if %costcalc%==on PAL,PALDM,PATL,PATLDM
$if %bioyieldcalc%==on YIELD_BIO
YIELDL_OUT
YIELDLDM_OUT
YIELDLDM_annual
YIELDLDM_ratio

$ifthen %biodivcalc%==on
BII,BIIL,BIIArea,BVS,BVSL,BVSLDM,BVArea,BVLArea,BIILArea
$if not %IAV%==NoCC protectfracL
*BIIcoefG
*f10_potforest
*BIIcoef0
*map_LLULC_class
*BIIcoefGclass
*BVLGclass
*BVLclass
*BVclass
$endif
;

$ifthen %rlimapcalc%==on

execute_unload '../output/gdx/landmap/%SCE%_%CLP%_%IAV%.gdx'
PRLIestimator
*VYLIJ

*execute_unload '../output/gdx/landmap/sharepix.gdx'
*sharepix
*;

*VYLclassIJ
*deltaVYL
*VYLtrans
*;
$endif

