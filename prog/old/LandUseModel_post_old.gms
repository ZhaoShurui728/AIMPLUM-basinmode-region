* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal prog_dir ..\prog
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC

$setglobal supcuv off

$if %Sy%==2005 $setglobal supcuv on
*$if %Sy%==2010 $setglobal supcuv on
*$if %Sy%==2030 $setglobal supcuv on
$if %Sy%==2050 $setglobal supcuv on
*$if %Sy%==2080 $setglobal supcuv on
$if %Sy%==2100 $setglobal supcuv on

set
dum/1*1000000/
G	Cell number  /
$offlisting
$include %prog_dir%/\define\set_g\G_%Sr%.set
$onlisting
/
Y	/ %Sy%
$if not %Sy%==%base_year% 2005
/
R	/ %Sr% /
L land use type /
PRM_SEC	other forest and grassland
HAV_FRS	production forest
FRS	forest
AFR	afforestation
PAS	grazing pasture
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
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
GL	grassland
SL	built_up
OL	ice or water
CL	cropland
/
LCROP(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR,PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/
LPAS(L)/PAS/
LPRMSEC(L)/PRM_SEC/
LBIO(L)/PRM_SEC,CROP_FLW/
;
Alias(G,G2),(L,L2);
set
MAP_Lagg(L,L2)/
PRM_SEC	.	PRM_SEC
HAV_FRS	.	HAV_FRS
FRS	.	FRS
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
GL	.	GL
SL	.	SL
OL	.	OL
CL	.	CL
PDR	.	PDRIR
WHT	.	WHTIR
GRO	.	GROIR
OSD	.	OSDIR
C_B	.	C_BIR
OTH_A	.	OTH_AIR
PDR	.	PDRRF
WHT	.	WHTRF
GRO	.	GRORF
OSD	.	OSDRF
C_B	.	C_BRF
OTH_A	.	OTH_ARF
/;

parameter
VY_results(L,G)
Y_base(LPAS,G)
;

*------- Carbon stock ----------*
set
Ybase/ %base_year% /
LCGE	land use category in AIMCGE /PRM_FRS, MNG_FRS,GRAZING/
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
;
parameter
CDT_load(L,G,Ybase,Ybase)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
cdt(L,G)		carbon density (stock or flow) of havested forest in cell G (MgC ha-1 (year-1))
GA(G)		Grid area of cell G kha
protectfrac(G)
;

$gdxin '%prog_dir%/../data/biomass/output/biomass%Sr%.gdx'
$load CDT_load=CDT

CDT("PRM_SEC",G)=CDT_load("PRM_SEC",G,"%base_year%","%base_year%");

$gdxin '%prog_dir%/data/data_prep.gdx'
$load GA MAP_WG

$	gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%Sy%.gdx'
$	load VY_results=VY_load protectfrac

$	gdxin '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/%base_year%.gdx'
$	load Y_base

set
asord /1*15000/
;
alias(asord,asord2);

parameter
orda(asord)
CSB	carbon stock boundary in forest and grassland (MgC ha-1)
Planduse_load(Y,R,LCGE)
Planduse_pas
PGHG_load(Y,R)	Carbon price [k$ per tonne CO2]
PGHG		Carbon price [million $ per tonne C]
;

orda(asord)=ord(asord);

$gdxin '%prog_dir%/../data/cbnal0/global_17_%SCE%_%CLP%_%IAV%.gdx'
$load Planduse_load=Planduse PGHG_load

Planduse_pas=Planduse_load("%Sy%","%Sr%","GRAZING");

$ifthen %clp%==BaU
PGHG=0;
$else
PGHG=PGHG_load("%Sy%","%Sr%")/1000*44/12;
$endif

parameter
VY_load(L,G)
Area_load(L)
;

*---Pasture---
parameter
PASarea_base
SF_PAS0

ADD_PAS
Ypas_nfullG(G)
Ypas_nfull
SF_PAS

ADD4_PAS

AREA_NPAS	Area of potentail grassland
SF_PAS2
PNBPAS(G)
Y_NPROT(G)	non-protected area = PRM_SEC - protected area
;

PASarea_base=SUM(G$Y_base("PAS",G),Y_base("PAS",G)*GA(G));

SF_PAS0$PASarea_base=Planduse_pas/PASarea_base;

Y_NPROT(G)$(CDT("PRM_SEC",G) AND VY_results("PRM_SEC",G)-protectfrac(G)>0)=VY_results("PRM_SEC",G)-protectfrac(G);

*��N��PAS�̂���Z���ł
VY_load("PAS",G)$(Y_base("PAS",G) AND Y_NPROT(G) AND Y_NPROT(G)>=Y_base("PAS",G)*SF_PAS0)=Y_base("PAS",G)*SF_PAS0;
VY_load("PAS",G)$(Y_base("PAS",G) AND Y_NPROT(G) AND Y_NPROT(G)<Y_base("PAS",G)*SF_PAS0)=Y_NPROT(G);


* STEP1
ADD_PAS=Planduse_pas-SUM(G$VY_load("PAS",G),VY_load("PAS",G)*GA(G));
Ypas_nfullG(G)$(VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G))=VY_load("PAS",G);
Ypas_nfull=sum(G$Ypas_nfullG(G),Ypas_nfullG(G)*GA(G));

While (ADD_PAS>0 AND Ypas_nfull>0 ,

ADD_PAS=Planduse_pas-SUM(G$VY_load("PAS",G),VY_load("PAS",G)*GA(G));
Ypas_nfullG(G)$(VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G))=VY_load("PAS",G);
Ypas_nfull=sum(G$Ypas_nfullG(G),Ypas_nfullG(G)*GA(G));
SF_PAS$Ypas_nfull=ADD_PAS/Ypas_nfull;

VY_load("PAS",G)$(SF_PAS AND VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G) AND Y_NPROT(G)>=VY_load("PAS",G)*(1+SF_PAS)) =VY_load("PAS",G)*(1+SF_PAS);
VY_load("PAS",G)$(SF_PAS AND VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G) AND Y_NPROT(G)<VY_load("PAS",G)*(1+SF_PAS)) =Y_NPROT(G);

);

ADD_PAS=Planduse_pas-SUM(G$VY_load("PAS",G),VY_load("PAS",G)*GA(G));

* STEP2 neighbourhood cell
IF (ADD_PAS>0,

PNBPAS(G)$((NOT VY_load("PAS",G)) AND Y_NPROT(G))=SUM(G2$(VY_load("PAS",G2) AND MAP_WG(G,G2)),1);

AREA_NPAS=SUM(G$(PNBPAS(G)),Y_NPROT(G)*GA(G));

SF_PAS2$(AREA_NPAS)= ADD_PAS/AREA_NPAS;

VY_load("PAS",G)$(SF_PAS2>0 AND SF_PAS2<=1 AND PNBPAS(G))=Y_NPROT(G)*SF_PAS2;
VY_load("PAS",G)$(SF_PAS2>1 AND PNBPAS(G))=Y_NPROT(G);

);

IF (ADD_PAS>0 AND SF_PAS2>1,

PNBPAS(G)$((NOT VY_load("PAS",G)) AND Y_NPROT(G))=SUM(G2$(VY_load("PAS",G2) AND MAP_WG(G,G2)),1);

AREA_NPAS=SUM(G$(PNBPAS(G)),Y_NPROT(G)*GA(G));

SF_PAS2$(AREA_NPAS)= ADD_PAS/AREA_NPAS;

VY_load("PAS",G)$(SF_PAS2>0 AND SF_PAS2<=1 AND PNBPAS(G))=Y_NPROT(G)*SF_PAS2;
VY_load("PAS",G)$(SF_PAS2>1 AND PNBPAS(G))=Y_NPROT(G);

);

* STEP1
ADD_PAS=Planduse_pas-SUM(G$VY_load("PAS",G),VY_load("PAS",G)*GA(G));
Ypas_nfullG(G)$(VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G))=VY_load("PAS",G);
Ypas_nfull=sum(G$Ypas_nfullG(G),Ypas_nfullG(G)*GA(G));

While (ADD_PAS>0 AND Ypas_nfull>0 ,

ADD_PAS=Planduse_pas-SUM(G$VY_load("PAS",G),VY_load("PAS",G)*GA(G));
Ypas_nfullG(G)$(VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G))=VY_load("PAS",G);
Ypas_nfull=sum(G$Ypas_nfullG(G),Ypas_nfullG(G)*GA(G));
SF_PAS$Ypas_nfull=ADD_PAS/Ypas_nfull;

VY_load("PAS",G)$(SF_PAS AND VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G) AND Y_NPROT(G)>=VY_load("PAS",G)*(1+SF_PAS)) =VY_load("PAS",G)*(1+SF_PAS);
VY_load("PAS",G)$(SF_PAS AND VY_load("PAS",G) AND VY_load("PAS",G)<Y_NPROT(G) AND Y_NPROT(G)<VY_load("PAS",G)*(1+SF_PAS)) =Y_NPROT(G);

);


*execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/analysis/%Sy%_PAS.gdx'
*VY_load
*;


*--- Forest -----------

$ifthen.baseyear %Sy%==%base_year%

parameter
Pvalue(G,*)
;

Pvalue(G,"area")=(VY_results("PRM_SEC",G)-VY_load("PAS",G))*GA(G);
Pvalue(G,"cstock")$Pvalue(G,"area")=CDT("PRM_SEC",G);

set
col /cstock,area,area_acm/
;
parameter
gg(G)
orddatG(asord,G,*)
orddat(asord,*)
;

gg(G)=sum(G2$(Pvalue(G2,"cstock")>Pvalue(G,"cstock")),1);

orddatG(asord,G,col)$(ord(asord)=(gg(G)+1))=Pvalue(G,col);

orddat(asord,"cstock")$sum(G$orddatG(asord,G,"cstock"),1)=sum(G$orddatG(asord,G,"cstock"),orddatG(asord,G,"cstock"))/sum(G$orddatG(asord,G,"cstock"),1);
orddat(asord,"area")  =sum(G,orddatG(asord,G,"area"));
orddat(asord,"area_acm")$orddat(asord,"area")=sum(asord2$(orda(asord)>orda(asord2) OR orda(asord)=orda(asord2)),orddat(asord2,"area"));

parameter
FRSArea		forest area
HAVFRSArea	production forest area
FRSArea2
PASArea		pasture area
;

FRSArea=Planduse_load("%Sy%","%Sr%","PRM_FRS")+Planduse_load("%Sy%","%Sr%","MNG_FRS");
HAVFRSArea=SUM(G,VY_results("HAV_FRS",G)*GA(G));
FRSArea2=FRSArea-HAVFRSArea;

*Loop(asord,
*orddat(asord,col)$(orddat(asord,col)=0)=orddat(asord-1,col);
*);

CSB=sum(asord$(FRSArea2<=orddat(asord,"area_acm") AND FRSArea2>orddat(asord-1,"area_acm") AND orddat(asord-1,"area_acm")>0),orddat(asord,"cstock"));
*CSB$(CSB=0)=smin(asord,orddat(asord,"cstock"))

$else.baseyear

$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/analysis/%base_year%.gdx'
$load CSB

$endif.baseyear


*---------------

*VY_load(L,G)$(NOT LPAS(L))=VY_results(L,G);
VY_load(L,G)$(NOT LPAS(L))=SUM(L2$MAP_Lagg(L,L2),VY_results(L2,G));

VY_load("FRS",G)$(CDT("PRM_SEC",G)>=CSB)=VY_results("PRM_SEC",G)-VY_load("PAS",G);
VY_load("GL",G)$(CDT("PRM_SEC",G)<CSB)=VY_results("PRM_SEC",G)-VY_load("PAS",G);

Area_load(L)= SUM(L2$MAP_Lagg(L,L2),SUM(G,VY_load(L2,G)*GA(G)));
Area_load("CL")=SUM(L$LCROP(L),Area_load(L));

$if %supcuv%==on $include %prog_dir%/inc_prog/biosupplycurve.gms

execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/analysis/%Sy%.gdx'
*$ontext
VY_load
Area_load
$if %supcuv%==on Pvaluesup,Rarea_bio,pc_bio,pc_ctax
$if %Sy%==%base_year% CSB
;
*$offtext




