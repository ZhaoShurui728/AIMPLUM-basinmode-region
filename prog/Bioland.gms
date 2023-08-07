$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_loc
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$setglobal Sy 2010
$setglobal bioscm BSA
$setglobal parallel off
$setglobal residue on
$setglobal Ystep0 10
$setglobal supcuvout off
$setglobal biopmap on
$setglobal degradedlandprotect off
$setglobal WDPAprotect protect_all
;



$include ../%prog_loc%/inc_prog/pre_%Ystep0%year.gms
$include ../%prog_loc%/inc_prog/second_%Ystep0%year.gms

*PBIOEXOQ0 the given global bioenergy amount EJ per year
*PBIOEXOP0 the given global bioenergy price $ per GJ

$include ../%prog_loc%/scenario/socioeconomic/%sce%.gms

Set
R       17 regions      /
$include ../%prog_loc%/define/region/region17.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
Sr(R)/
WLD,OECD90,REF,ASIA,MAF,LAM
/
G       Cell number  /
$offlisting
*$include %prog_loc%/define/set_g/G_WLD.set
$include ../%prog_loc%/define/set_g/G_USA.set
$include ../%prog_loc%/define/set_g/G_XE25.set
$include ../%prog_loc%/define/set_g/G_XER.set
$include ../%prog_loc%/define/set_g/G_TUR.set
$include ../%prog_loc%/define/set_g/G_XOC.set
$include ../%prog_loc%/define/set_g/G_CHN.set
$include ../%prog_loc%/define/set_g/G_IND.set
$include ../%prog_loc%/define/set_g/G_JPN.set
$include ../%prog_loc%/define/set_g/G_XSE.set
$include ../%prog_loc%/define/set_g/G_XSA.set
$include ../%prog_loc%/define/set_g/G_CAN.set
$include ../%prog_loc%/define/set_g/G_BRA.set
$include ../%prog_loc%/define/set_g/G_XLM.set
$include ../%prog_loc%/define/set_g/G_CIS.set
$include ../%prog_loc%/define/set_g/G_XME.set
$include ../%prog_loc%/define/set_g/G_XNF.set
$include ../%prog_loc%/define/set_g/G_XAF.set
$onlisting
/
Y year  /  %Sy%  /
L land use type /
*PRM_SEC        forest + grassland + pasture
FRSGL   forest + grassland
FRS     forest
AFR     afforestation
PAS     grazing pasture
CL      cropland
BIO     bio crops
CROP_FLW        fallow land
GL      grassland
SL      built_up
OL      ice or water
LUC     land use change total
/
LB              New or old bioenergy cropland/
BION    new bioenergy cropland
BIOO    old bioenergy cropland
BION_DEG
/
LCL(L)/CL/
LBIO(L)/BIO/
LCLBIO(L)/CL,BIO/
LNBIOP(L) land category NOT for bioenergy potential /CL,PAS,CROP_FLW,SL,OL,AFR/
MAP_RG(R,G)     Relationship between country R and cell G

;
Alias(R,R2),(G,G2);
set
MAP_RAGG(R,R2)  /
$include ../%prog_loc%/define/region/region17_agg.map
/
;
parameter
YBIO(G)
YBIOLB(G,LB)
PBIO(G,LB)
GA(G)           Grid area of cell G kha
Y_pre(L,G)
VYLCL(G)
pa_bio(G)       land transition costs per unit area (million $ per ha)
pc_bio(R)
VYL(L,G)
protect_wopas(G)
YIELDBIO(G)
;

$gdxin '../%prog_loc%/data/data_prep.gdx'
$load GA MAP_RG

$batinclude ../%prog_loc%/inc_prog/BiolandR.gms USA
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XE25
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XER
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms TUR
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XOC
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms CHN
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms IND
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms JPN
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XSE
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XSA
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms CAN
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms BRA
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XLM
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms CIS
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XME
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XNF
$batinclude ../%prog_loc%/inc_prog/BiolandR.gms XAF

set
A_BTR2 Biocrop residue4 /BTR2/
;
parameter
TBI_load(*,Y,R,A_BTR2) Bioenergy use [ktoe per year]
TBI(Y,R,A_BTR2) Bioenergy use [ktoe per year]
EJ_ktoe         EJ_ktoe scaler [EJ per ktoe]
PBIOEXOQ        Global bioenergy amount (Biocrops + residue) [EJ per year] (exogenous)
PBIOEXOQ_2gen   Global bioenergy amount (Biocrops) [EJ per year] (exogenous)
trend2100
;

EJ_ktoe=41.8/1000000;

*PBIO(G,Scol)=SUM(R,PBIOR(R,G,Scol));

*---- Management factor for Biocrop yield ---*
set
YBASE/ %base_year% /
;
parameter
POP(*,YBASE,R)
GDP(*,YBASE,R)
GDPCAP_base(R)
Ppopulation(YBASE,R)
GDP_load(YBASE,R)
MF(R)      management factor for bio crops
MFA(R)     management factor for bio crops in base year
MFB(R)     management factor for bio crops (coefficient)
MFC(L)     accessibility factor for bio crops
MFAi(R)    inverce of management factor for bio crops in base year
MFArev(R)    inverce of management factor for bio crops in base year
;
$ifthen %CLP%==BaU $setglobal TBIloadSce %SCE%_BaU_%IAV%%ModelInt%
$elseif %CLP%==BaULP $setglobal TBIloadSce %SCE%_BaU_%IAV%%ModelInt%
$elseif %CLP%==C $setglobal TBIloadSce %SCE%_C_%IAV%%ModelInt%
$elseif %CLP%==CLP $setglobal TBIloadSce %SCE%_C_%IAV%%ModelInt%
$elseif %CLP%==CNA $setglobal TBIloadSce %SCE%_CNA_%IAV%%ModelInt%
$elseif %CLP%==CNALP $setglobal TBIloadSce %SCE%_CNA_%IAV%%ModelInt%
$else $setglobal TBIloadSce %SCE%_%CLP%_%IAV%%ModelInt%
$endif

$gdxin '../%prog_loc%/data/cgeoutput/analysis.gdx'
$load POP GDP TBI_load=TBI
Ppopulation(YBASE,R)=POP("%SCE%_BaU_%IAV%%ModelInt%",YBASE,R);
GDP_load(YBASE,R)=GDP("%SCE%_BaU_%IAV%%ModelInt%",YBASE,R);
TBI(Y,R,A_BTR2)=TBI_load("%TBIloadSce%",Y,R,A_BTR2);

GDPCAP_base(R)$Ppopulation("%base_year%",R)=GDP_load("%base_year%",R)/Ppopulation("%base_year%",R);

MFA(R)$(GDPCAP_base(R)>=1)=1;
MFA(R)$(GDPCAP_base(R)>0.35 AND GDPCAP_base(R)<1)=0.6;
MFA(R)$(GDPCAP_base(R)>0 AND GDPCAP_base(R)<=0.35)=0.4;

MFB(R)$(GDPCAP_base(R)>=1)=1.005;
MFB(R)$(GDPCAP_base(R)>0.35 AND GDPCAP_base(R)<1)=1.005;
MFB(R)$(GDPCAP_base(R)>0 AND GDPCAP_base(R)<=0.35)=1.01;


MF(R)$MFA(R)=min(1.3/MFA(R),MFB(R)**max(0,%Sy%-2010));

YIELDBIO(G)$(YIELDBIO(G))=YIELDBIO(G)*SUM(R$MAP_RG(R,G),MF(R));

*-------Potentail area for OLD bioenergy cropland ---*
parameter
YBIO_load(G)
YBIOO(G)        Potentail area for OLD bioenergy cropland
;

$ifthen.fileex exist '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%pre_year%.gdx'
$       gdxin '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%pre_year%.gdx'
$       load YBIO_load=YBIO
$else.fileex
YBIO_load(G)=0;
$endif.fileex

Y_pre("BIO",G)$YBIO_load(G)=YBIO_load(G);

YBIOO(G)$(SUM(L$LCLBIO(L),Y_pre(L,G))-VYL("CL",G))=max(0,SUM(L$LCLBIO(L),Y_pre(L,G))-VYL("CL",G));

*-------Bioenergy potential curve ---*

parameter
BIOENE(G)       Bioenergy potential in cell G in year Y [GJ per ha per year]
RAREA_BIOP(G)   Ratio of potential area of biocrop in cell G in year Y [-]
GJ_toe  /41.8/
Rbg             Ratio of below-ground residues to above-ground biomass (IPCC guideline Table11.2) /0.20/
PBIO(G,LB)      Price
pca_bio(G,LB)    Cost for bioenergy production including land conversion cost (million $ per ha per year)
CSB(R)	Carbon density threshold for dividing grassland and forest (MgC per C)
Avalab_FL	availablilty of light forestland source: van Vuuren et al. 2009 /0.5/
Avalab_GL	availablilty of natural grassland source: van Vuuren et al. 2009 /0.5/
degradedland(G)	Degraded land fraction (0 to 1)
degradedland_usable(G)
protectland(G)	Protected area fraction (0 to 1) of cell G (WDPA and IUCN)
;

$gdxin '../%prog_loc%/data/CSB.gdx'
$load CSB

*** CROP_FLW --> BIO

* [GJ/ha/year] = [tonC/ha] * [tonCrop/tonC]  * [toe/tonCrop] * [GJ/toe]
BIOENE(G)$(YIELDBIO(G)) = YIELDBIO(G) * 1/(1+Rbg) * 2.5 * 0.38 * GJ_toe;

RAREA_BIOP(G) = 1-(SUM(L$(LNBIOP(L)),VYL(L,G))
		  + protect_wopas(G)
*		  + VYL("FRSGL",G)$(CS(G)>SUM(R$MAP_RG(R,G),CSB(R)))
		  + (VYL("FRSGL",G)-protect_wopas(G))$(VYL("FRSGL",G)>protect_wopas(G) AND CS(G)>=15)
		  + (Avalab_FL*(VYL("FRSGL",G)-protect_wopas(G)))$(VYL("FRSGL",G)>protect_wopas(G) AND CS(G)<15 AND CS(G)>SUM(R$MAP_RG(R,G),CSB(R)))
		  + (Avalab_GL*(VYL("FRSGL",G)-protect_wopas(G)))$(VYL("FRSGL",G)>protect_wopas(G) AND CS(G)<SUM(R$MAP_RG(R,G),CSB(R)))
		  );
* adjust fraction
$if not %WDPAprotect%==off $gdxin '../%prog_loc%/data/policydata.gdx'
$if not %WDPAprotect%==off $load protectland=%WDPAprotect%
$if %WDPAprotect%==off protectland(G)=0;

$if not %degradedlandprotect%==off $gdxin '../%prog_loc%/data/policydata.gdx'
$if not %degradedlandprotect%==off $load degradedland=%degradedlandprotect%
$if %degradedlandprotect%==off degradedland(G)=0;
degradedland_usable(G)$(degradedland(G)>0 AND RAREA_BIOP(G)>0) = degradedland(G) * (protect_wopas(G)/( protectland(G) + degradedland(G)))*0.5;
RAREA_BIOP(G)$(RAREA_BIOP(G)<10**(-5))=0;

*[mil$/ha/year]
pca_bio(G,"BIOO")$(BIOENE(G) AND RAREA_BIOP(G))=SUM(R$MAP_RG(R,G),pc_bio(R));
pca_bio(G,"BION")$(BIOENE(G) AND RAREA_BIOP(G))=SUM(R$MAP_RG(R,G),pc_bio(R)) + pa_bio(G);
pca_bio(G,"BION_DEG")$(BIOENE(G))=SUM(R$MAP_RG(R,G),pc_bio(R)) + pa_bio(G);

* [$/GJ] = [mil$/ha/year] / [GJ/ha/year] * 10**6
PBIO(G,LB)$(BIOENE(G) AND RAREA_BIOP(G))=pca_bio(G,LB)/BIOENE(G)*(10**6);


*-------Bioenergy potential curve output ---*

$ifthen %supcuvout%==on
set
Scol	/quantity,price,yield,area,fraction/
;
parameter
PBIOSUP(G,LB,*)	Biosupply curve data set fraction(grid-1) area (kha per grid) quantity (EJ per grid per year) price ($ per GJ) yield (MgC per ha per year)
;

* [grid-1]
PBIOSUP(G,"BIOO","fraction")$(BIOENE(G)) = min(YBIOO(G),RAREA_BIOP(G)) ;
* the new bioenergy fraction should deduced the
PBIOSUP(G,"BION","fraction")$(BIOENE(G)) = max(0, RAREA_BIOP(G)-YBIOO(G));
** treat it as a new crop
PBIOSUP(G,"BION_DEG","fraction")$(BIOENE(G)) = max(0, degradedland_usable(G));
* [kha/grid]
PBIOSUP(G,LB,"area")$(BIOENE(G)) = PBIOSUP(G,LB,"fraction") * GA(G);

* [EJ/grid/year] = [GJ/ha/year] * [kha/grid]
PBIOSUP(G,LB,"quantity")$(BIOENE(G)) = BIOENE(G) * PBIOSUP(G,LB,"area") / 10**6;
PBIOSUP(G,'BION',"quantity")$(BIOENE(G)) = BIOENE(G) * PBIOSUP(G,'BION',"area") / 10**6;
** half yield reduction for bioenergy crops on degraded land
PBIOSUP(G,'BION_DEG',"quantity")$(BIOENE(G)) = BIOENE(G)/2 * PBIOSUP(G,'BION_DEG',"area") / 10**6;

* [$/GJ] = [mil$/ha/year] / [GJ/ha/year] * 10**6
* PBIOSUP(G,LB,"price")$(BIOENE(G) AND RAREA_BIOP(G) AND PBIOSUP(G,LB,"quantity")>0) = pca_bio(G,LB) * PBIOSUP(G,LB,"area")/PBIOSUP(G,LB,"quantity");
* PBIOSUP(G,LB,"price")$(BIOENE(G) AND PBIOSUP(G,LB,"quantity")>0) = pca_bio(G,LB) * PBIOSUP(G,LB,"area")/PBIOSUP(G,LB,"quantity");
PBIOSUP(G,"BIOO","price")$(BIOENE(G) AND PBIOSUP(G,"BIOO","quantity")>0) = pca_bio(G,"BIOO") * PBIOSUP(G,"BIOO","area")/PBIOSUP(G,"BIOO","quantity");
PBIOSUP(G,"BION","price")$(BIOENE(G) AND PBIOSUP(G,"BION","quantity")>0) = pca_bio(G,"BION") * PBIOSUP(G,"BION","area")/PBIOSUP(G,"BION","quantity");
PBIOSUP(G,"BION_DEG","price")$(BIOENE(G) AND PBIOSUP(G,"BION_DEG","quantity")>0) = pca_bio(G,"BION_DEG") * PBIOSUP(G,"BION_DEG","area")/PBIOSUP(G,"BION_DEG","quantity");
* [$/GJ] = [mil$/ha/year] / [GJ/ha/year] * 10**6
PBIOSUP(G,LB,"price")$(BIOENE(G) AND RAREA_BIOP(G)) = pca_bio(G,LB)/BIOENE(G)*(10**6);

*[MgC/ha/year]
PBIOSUP(G,LB,"yield")$(BIOENE(G) AND RAREA_BIOP(G)) = YIELDBIO(G);
PBIOSUP(G,"BION_DEG","yield")$(BIOENE(G) AND RAREA_BIOP(G)) = YIELDBIO(G)/2;
PBIOSUP(G,"BION_DEG","yield")$(BIOENE(G)) = YIELDBIO(G)/2;

PBIOSUP(G,LB,Scol)$(NOT PBIOSUP(G,LB,"area"))=0;


$endif



*--- Equation
parameter
Psol_stat(*)                  Solution report
;

Variable
VQ      Total production
VC      Total cost []
VYBIO(G,LB)     fractions of area for biocrops [grid-1]
;
Equation
EQVQ            total production
EQVC            total production cost
EQVYBIO(G)      area fractions of bioenergy cropland
EQVYBIOO(G)     area fractions of old bioenergy cropland
EQCONS  global bioenergy demand constraint
;

VYBIO.LO(G,LB)=0;
*VYBIO.L(G,"BIOO")$(BIOENE(G)) = min(YBIOO(G),RAREA_BIOP(G));
*VYBIO.L(G,"BION")$(BIOENE(G)) = max(0, RAREA_BIOP(G)-YBIOO(G));

VYBIO.FX(G,"BIOO")$(YBIOO(G)<=0)=0;
*VYBIO.FX(G,"BIOO")$(BIOENE(G)) = min(YBIOO(G),RAREA_BIOP(G));
VYBIO.FX(G,LB)$(NOT (BIOENE(G) AND RAREA_BIOP(G)))=0;


$ifthen %bioscm%==BSP

*YBIO(G)$(PBIO(G,LB)<%PBIOEXOP0%)=RAREA_BIOP(G);

VYBIO.FX(G,LB)$(PBIO(G,LB)>%PBIOEXOP0%)=0;
$if not %biodiversity%==off VYBIO.FX(SUBG(G),LB)=0�G

EQVQ..  VQ =E= SUM(LB,SUM(G$(BIOENE(G) AND RAREA_BIOP(G) AND (PBIO(G,LB)<=%PBIOEXOP0%)), BIOENE(G) * GA(G) * VYBIO(G,LB))) / 10**6;
EQVYBIO(G)$(BIOENE(G) AND RAREA_BIOP(G))..      SUM(LB$(PBIO(G,LB)<=%PBIOEXOP0%),VYBIO(G,LB)) =L= RAREA_BIOP(G);
EQVYBIOO(G)$(PBIO(G,"BIOO")<=%PBIOEXOP0% AND YBIOO(G))..        VYBIO(G,"BIOO") =L= YBIOO(G);

MODEL BiolandP /EQVQ,EQVYBIO,EQVYBIOO/;

Solve BiolandP USING LP maximizing VQ;

Psol_stat("SSOLVE")=BiolandP.SOLVESTAT;Psol_stat("SMODEL")=BiolandP.MODELSTAT;


$elseif %bioscm%==BSQ

*----Bioenergy potential SOATED ---*

trend2100=%PBIOEXOQ0%/(2100-2010);

PBIOEXOQ$(2010<=%Sy%)=trend2100*(%Sy%-2010);

$if %residue%==on PBIOEXOQ_2gen=PBIOEXOQ-SUM(R,TBI("%Sy%",R,"BTR2"))*EJ_ktoe*10;
$if %residue%==off PBIOEXOQ_2gen=PBIOEXOQ;

*                                         [$/GJ] * [GJ/ha/year] * [kha/grid] * [-]
EQVC..  VC =E= SUM(LB,SUM(G$(BIOENE(G) AND RAREA_BIOP(G)),PBIO(G,LB)* BIOENE(G) * GA(G)* VYBIO(G,LB))) / 10**6;
EQVYBIO(G)$(BIOENE(G) AND RAREA_BIOP(G))..      SUM(LB,VYBIO(G,LB)) =L= RAREA_BIOP(G);
EQVYBIOO(G)$(YBIOO(G))..        VYBIO(G,"BIOO") =L= YBIOO(G);
EQCONS..        SUM(LB,SUM(G$(BIOENE(G) AND RAREA_BIOP(G)), BIOENE(G) * GA(G) * VYBIO(G,LB))) / 10**6 =G= PBIOEXOQ_2gen;

MODEL BiolandQ /EQVC,EQVYBIO,EQVYBIOO,EQCONS/;

Solve BiolandQ USING LP minimizing VC;

Psol_stat("SSOLVE")=BiolandQ.SOLVESTAT;Psol_stat("SMODEL")=BiolandQ.MODELSTAT;

$endif


YBIOLB(G,LB)$VYBIO.L(G,LB)=VYBIO.L(G,LB);
YBIO(G)$(SUM(LB,VYBIO.L(G,LB)))=SUM(LB,VYBIO.L(G,LB));

parameter
AREA_BIOP(R,LB)    Area of biocrop in region R in year Y [kha per year]
YIELD_BIOP(R,LB)    Yield of biocrop in region R in year Y [tonCrop per ha]
TOTAREA_BIOP(R)    Total potential area of biocrop in region R in year Y [kha per year]
TOTBIOENE(R)    Total technical bioenergy potential [EJ per year]
;


AREA_BIOP(R,LB)=SUM(G$MAP_RG(R,G),VYBIO.L(G,LB)*GA(G));
AREA_BIOP(Sr,LB)=SUM(R$MAP_RAGG(R,Sr),AREA_BIOP(R,LB));

YIELD_BIOP(R,LB)$SUM(G$MAP_RG(R,G),VYBIO.L(G,LB)*GA(G))=SUM(G$MAP_RG(R,G),YIELDBIO(G)*VYBIO.L(G,LB)*GA(G))/SUM(G$MAP_RG(R,G),VYBIO.L(G,LB)*GA(G)) * 1/(1+Rbg) * 2.5;

YIELD_BIOP(Sr,LB)$SUM(R$(MAP_RAGG(R,Sr) and AREA_BIOP(R,LB)*YIELD_BIOP(R,LB)),AREA_BIOP(R,LB))
=SUM(R$(MAP_RAGG(R,Sr) and AREA_BIOP(R,LB)*YIELD_BIOP(R,LB)),AREA_BIOP(R,LB)*YIELD_BIOP(R,LB))/SUM(R$(MAP_RAGG(R,Sr) and AREA_BIOP(R,LB)*YIELD_BIOP(R,LB)),AREA_BIOP(R,LB));

TOTAREA_BIOP(R)=SUM(G$MAP_RG(R,G),RAREA_BIOP(G)*GA(G));
TOTAREA_BIOP(Sr)=SUM(R$MAP_RAGG(R,Sr),TOTAREA_BIOP(R));

TOTBIOENE(R)=SUM(G$MAP_RG(R,G),BIOENE(G)*RAREA_BIOP(G)*GA(G)) / 10**6;
TOTBIOENE(Sr)=SUM(R$MAP_RAGG(R,Sr),TOTBIOENE(R));

*-----------------------------------*

*-----EMF33
*$ontext
parameter
PCBIO(R)        average price to meet the given bioenergy amount [$ per GJ]
QCBIO(R)        quantity to meet the given bioenergy price [EJ per year]
;

PCBIO(R)$SUM(LB,SUM(G$(MAP_RG(R,G) AND PBIO(G,LB)*BIOENE(G)*YBIOLB(G,LB)),BIOENE(G) * GA(G) *YBIOLB(G,LB)))
        =SUM(LB,SUM(G$(MAP_RG(R,G) AND PBIO(G,LB)*BIOENE(G)*YBIOLB(G,LB)),PBIO(G,LB)*BIOENE(G) * GA(G) *YBIOLB(G,LB)))
                /SUM(LB,SUM(G$(MAP_RG(R,G) AND PBIO(G,LB)*BIOENE(G)*YBIOLB(G,LB)), BIOENE(G) * GA(G) *YBIOLB(G,LB)));

QCBIO(R)=SUM(LB,SUM(G$(MAP_RG(R,G) AND BIOENE(G)*YBIOLB(G,LB)), BIOENE(G) * GA(G) * YBIOLB(G,LB)))/ 10**6;

* regional aggregation
PCBIO(Sr)$SUM(R$(MAP_RAGG(R,Sr) AND QCBIO(R)*PCBIO(R)),QCBIO(R))
        = SUM(R$(MAP_RAGG(R,Sr) AND QCBIO(R)*PCBIO(R)),QCBIO(R)*PCBIO(R))
         /SUM(R$(MAP_RAGG(R,Sr) AND QCBIO(R)*PCBIO(R)),QCBIO(R));
QCBIO(Sr)= SUM(R$MAP_RAGG(R,Sr),QCBIO(R));

*-------------------------
*$offtext

$if %parallel%==off execute_unload '../output/temp3.gdx'

execute_unload '../output/gdx/%SCE%_%CLP%_%IAV%%ModelInt%/bio/%Sy%.gdx'
pca_bio
YBIOLB
YBIO
*VYBIOYBIO
PCBIO
QCBIO
AREA_BIOP
YIELD_BIOP
TOTAREA_BIOP
Psol_stat
BIOENE
PBIO
GDPCAP_base
MF
TOTBIOENE
YIELDBIO
degradedland
degradedland_usable
$if %supcuvout%==on PBIOSUP
$if %biopmap%==on RAREA_BIOP;

$exit

