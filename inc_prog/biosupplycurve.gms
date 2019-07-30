*biosupplycurve.gms
*-*-*-*- This program is included by ..\prog\LandUseModel_MCP_post.gms
set
AC  global set for model accounts - aggregated microsam accounts
A(AC)  activities
C(AC)  commodities
F(AC)  factors
FL(AC) Land use AEZ
CVST	crop categoly in VISIT /C4/
;
$gdxin '%prog_dir%/data/set.gdx'
$load AC A C F FL
set
AGRO(A) /GRO/
TX(AC)/YTAX,STAX,TAR,ETAX/
;
Alias(AC,ACP);

parameter
PSAM_value(Y,R,AC,ACP)
PSAM_volume(Y,R,AC,ACP)
pc_input_bio
pc_area_bio
pc_bio(G)
pc_ctax(G)
YIELD_BIO(G)	Yield of biocrop in cell G in year Y [GJ per ha per year]
AREA_BIO(G)	Area of biocrop in cell G in year Y [ha per year]
GJ_toe
Pvaluesup(G,*)
Rbg		Ratio of below-ground residues to above-ground biomass (IPCC guideline Table11.2) /0.20/
Rarea_bio(G)	Ratio of area of biocrop in cell G in year Y [-]
PVISIT(CVST,G)	Yield of land category L cell G in year Y [Mg C per ha per year]
CS_BIO(G)	carbon stock in base year in cell G (MgC ha-1)

;

$gdxin '%prog_dir%/../data/cbnal0/global_17_%SCE%_%CLP%_%IAV%.gdx'
$load PSAM_value PSAM_volume

$gdxin '%prog_dir%/data/visit_data.gdx'
$load PVISIT

PVISIT(CVST,G)$(PVISIT(CVST,G)<0)=0;

GJ_toe=41.8;

CS_BIO(G)=PVISIT("C4",G);

* [mil$]
pc_input_bio=SUM(A$AGRO(A), SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));

* [10^5ha --> ha]
pc_area_bio=SUM(A$AGRO(A), SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5;

* [mil$/ha/year]
pc_ctax(G)$SUM(L$LBIO(L),VY_load(L,G))=SUM(L$LBIO(L),VY_load(L,G)*CS_BIO(G)*PGHG)/SUM(L$LBIO(L),VY_load(L,G));

* [mil$/ha/year]
pc_bio(G)$(pc_area_bio)=pc_input_bio/pc_area_bio+pc_ctax(G);



* [GJ/ha/year] = [tonC/ha] * [tonCrop/tonC]  * [toe/tonCrop] * [GJ/toe]
YIELD_BIO(G) = CS_BIO(G) * 1/(1+Rbg) * 2.5 * 0.38 * GJ_toe;

Rarea_bio(G) = 1-(SUM(L$(LCROP(L) OR LPAS(L)),VY_load(L,G)) + protect_wopas(G) +VY_load("AFR",G) +VY_load("HAV_FRS",G)+VY_load("SL",G)+VY_load("OL",G));


* [ha/grid] = [kha/grid] * [ha/kha]
AREA_BIO(G)$YIELD_BIO(G) = GA(G) * 10**3 * Rarea_bio(G);

* [EJ/grid/year] = [GJ/ha/year] * [ha/grid] * [EJ/GJ]
Pvaluesup(G,"quantity")=YIELD_BIO(G) * AREA_BIO(G) / 10**9;

* [million ha/grid]
Pvaluesup(G,"area")= AREA_BIO(G) / 10**6;

* [$/GJ] = [mil$/ha/year] / [GJ/ha/year] * 10**6
Pvaluesup(G,"price")$(Pvaluesup(G,"quantity") AND YIELD_BIO(G))=pc_bio(G)/YIELD_BIO(G)*(10**6);

*[tonCrop/ha/year]
Pvaluesup(G,"yield")$(Pvaluesup(G,"quantity"))=CS_BIO(G) * 2.5;


$ontext
set
colsup /quantity,area,price,yield/
colsupsum(colsup) /quantity,area/
colsupave(colsup) /price,yield/
;
parameter
ggsup(G)
PsupcuvG(asord,G,*)
Psupcuv(asord,*)
;

ggsup(G)=sum(G2$(Pvaluesup(G2,"price")<Pvaluesup(G,"price")),1);

PsupcuvG(asord,G,colsup)$(ord(asord)=(ggsup(G)+1))=Pvaluesup(G,colsup);

Psupcuv(asord,colsup)$(colsupave(colsup) and sum(G$PsupcuvG(asord,G,colsup),1))=sum(G$PsupcuvG(asord,G,colsup),PsupcuvG(asord,G,colsup))/sum(G$PsupcuvG(asord,G,colsup),1);
Psupcuv(asord,colsup)$(colsupsum(colsup)) =sum(G,PsupcuvG(asord,G,colsup));

*Psupcuv(asord,"area_acm")$Psupcuv(asord,"area")=sum(asord2$(ord(asord)>ord(asord2) OR ord(asord)=ord(asord2)),Psupcuv(asord2,"area"));
*Psupcuv(asord,"quantity_acm")$Psupcuv(asord,"quantity")=sum(asord2$(ord(asord)>ord(asord2) OR ord(asord)=ord(asord2)),Psupcuv(asord2,"quantity"));
$offtext

