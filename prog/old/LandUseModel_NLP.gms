* Land Use Allocation model

$Setglobal Sr JPN
$Setglobal Sy 2006
$Setglobal base_year 2005
$Setglobal prog_dir ..\AIMPLUM

$include %prog_dir%/inc_prog/pre_year.gms

Set
R	17 regions	/
%Sr%
*$include %prog_dir%/\define\region/region17.set
/
G	Cell number  /
* 1 * 259200
$offlisting
$include %prog_dir%/\define\set_g\G_%Sr%.set
$onlisting
/
Y year	/ %base_year%*2100 /
L land use type /
PRM_FRS	primary forestland
MNG_FRS	managed forestland
PAS	grazing pasture land
GL	grassland
CL	cropland
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
BIO	bio crops
CROP_FLW	fallow land
SL	built_up
OL	ice or water
$ontext
C3	cropland for C3 crops
C4	cropland for C4 crops
$offtext
/
LCROP(L)/PDR,WHT,GRO,OSD,C_B,OTH_A,BIO,CROP_FLW/
LLIV(L)/PAS/
MAP_RG(R,G)	Relationship between country R and cell G
;
Alias (G,G2),(L,L2), (Y,Y2);
Set
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
;
Parameter
GA(G)		Grid area of cell G kha
FLAG_G(G)		Grid flag
;

$gdxin '%prog_dir%/prog/Data_prep.gdx'
$load Map_RG GA MAP_WG


FLAG_G(G)$MAP_RG("%Sr%",G)=1;

GA(G)$(FLAG_G(G)=0)=0;

Parameter
pa(L,G)
pb(L)
pd(L,G)             a constant for decreasing returns to scale
ps(L,G)             net benefit (=cost - benefit) per unit area
Y_pre0(L,G)             area ratio of land category L in cell G (initial)
Y_pre(L,G)	area ratio of land category L in cell G in previous year
PLDM(L)		land demand kha
pr(L,G)	revenue per unit area of commodities doller per ha
pr_price_base(L)	base year price pf commodities
pr_price(Y,L)       price of commodities (2005=1)
pr_price_indx(L)	price of commodities (2005=1)
pc(L,G)	cost per unit area for producing commodities
pc_input(L)	input (excl. land input) for producing commodities
pc_area(L)	land area for producing commodities

;

Variable
VOBJ	objective variables
VZ(L,G)	objective variables of land category L in cell G
VY(L,G)	area ratio of land category L in cell G
;

Equation
EQOBJ	objective function
EQPRF(L,G)	preference function
EQTOTY(G)		constraint of total cell area
EQLDM(L)		constraint of land demand
;

*--Equation

EQOBJ.. VOBJ =E= SUM((L,G)$FLAG_G(G),VZ(L,G));

EQPRF(L,G)$FLAG_G(G).. VZ(L,G) =E= pa(L,G)*(VY(L,G)-Y_pre(L,G))*(VY(L,G)-Y_pre(L,G)) + pb(L) * (VY(L,G)-Y_pre(L,G)) *  SUM(G2$(MAP_WG(G,G2) AND FLAG_G(G2)),(VY(L,G2)-Y_pre(L,G2))) + (VY(L,G)-pd(L,G)*ps(L,G))*(VY(L,G)-pd(L,G)*ps(L,G));

EQTOTY(G)$FLAG_G(G).. SUM(L,VY(L,G)) =L= 1;

EQLDM(L).. SUM(G$FLAG_G(G),GA(G)*VY(L,G)) =E= PLDM(L);

MODEL LandUseModel/
EQOBJ
EQPRF
EQTOTY
EQLDM
/
;

*------- Parameter_in ----------*

pa(L,G)$FLAG_G(G) =15;
pa("PAS",G)$FLAG_G(G) =50;
pa("PRM_FRS",G)$FLAG_G(G) =50;

pb(L) = -0.5;
pb("PAS") = -6;
pb("PRM_FRS") = -6;

pd(L,G)$FLAG_G(G) =1/2;

set
CVST	crop categoly in VISIT /PDR,C3,C4,C3natural,C4natural/
Map_LCVST(L,CVST)/
PDR	.	PDR
WHT	.	C3
GRO	.	C4
OSD	.	C3
C_B	.	C4
OTH_A	.	C3
BIO	.	C4
PAS	.	C4natural
CROP_FLW	.	C4
/
AC  global set for model accounts - aggregated microsam accounts
A(AC)  activities
ACROP(A)	crop production activities
C(AC)  commodities
CCROP(C) crop commodities
F(AC)  factors
FL(AC) Land use AEZ
Unit /TON/
;
$gdxin '%prog_dir%/data/set.gdx'
$load AC A ACROP C CCROP F FL
Alias(AC,ACP),(A,AP),(C,CP);
CCROP("COM_BIO")=YES;
SET
MAP_LA(L,A)/
PDR	.	PDR
WHT	.         WHT
GRO	.         GRO
C_B	.         C_B
OSD	.         OSD
OTH_A	.	OTH_A
BIO	.	BTR3
PAS	.	CTL
PAS	.	RMK
PAS	.	OTH_L
MNG_FRS	.	FRS
/
MAP_LC(L,C)/
PDR	.	COM_PDR
WHT	.	COM_WHT
GRO	.	COM_GRO
C_B	.	COM_C_B
OSD	.	COM_OSD
OTH_A	.	COM_OTH_A
BIO	.	COM_BIO
PAS	.	COM_CTL
PAS	.	COM_RMK
PAS	.	COM_OTH_L
MNG_FRS	.	COM_FRS
/
TX(AC)/YTAX,STAX,TAR,ETAX/
LCGE	land use category in AIMCGE /CROP, PRM_FRS, MNG_FRS, CROP_FLW, GRAZING, GRASS/
;

parameter
land_basemap(R,G,L)	Percentage share of land type in base year
crop_basemap(L,G)	Percentage share of cropland type in base year
frac_rcp(R,L,Y,G)	fraction of each gridcell G in land category L
YIELD_visit(CVST,G)	Yield of land category L cell G in year Y [Mg C per ha per year]
YIELD(L,G)	Yield of land category L cell G in year Y [tonne per ha per year]
YIELD_cge(Y,R,L)	CGE output of yield of land category L region R in year Y [tonne per ha per year]
YIELD_AVE(L)	Agerage yield of land category L region R in year Y [tonne per ha per year]
Pprod(Y,R,L,UNIT)	Production
TON_C(R,CVST)	Ratio of tonne to tonne Carbon [tonne per tonne C]
DW_TON(L)		Ratio of dry matter tonne to tonne [dry matter tonne per ton]/
PAS	0.1
/
C_DW		Ratio of tonne Carbon to tonne dry matter [tonne C per dry matter tonne]/
0.47
/
PSAM_value(Y,R,AC,ACP)
PSAM_volume(Y,R,AC,ACP)
PSAM_price(Y,R,AC,ACP)
Planduse(Y,R,LCGE)
protectflag(G)	Protected area flag (1: protected 0: non-protected) in each cell G
ordy(Y)
;

ordy(Y) = ord(Y) + %base_year% -1;

*-------Base-year map data load ----------*
set
LRCP(L) /PRM_FRS,MNG_FRS,PAS,GL,SL,OL/
LGTAP(L) /GL/
;
* Base-year land type data
$gdxin '%prog_dir%/individual/land_map_gtap/output/land_map_gtap.gdx'
$load land_basemap=base_map

* Base-year land type data
$gdxin '%prog_dir%/individual/land_map_rcp/output/land_map_rcp.gdx'
$load frac_rcp=frac

* Base-year cropland map data
$gdxin '%prog_dir%/individual/cropland_map_rammankutty/output/cropland_map_rmk.gdx'
$load crop_basemap

$gdxin '%prog_dir%/data/global_17_SSP2_BaU.gdx'
$load PSAM_value PSAM_volume PSAM_price Planduse

*-------Pre-year land map load ----------*

parameter
VZ_load(L,G)
VY_load(L,G)

;

$ifthen %Sy%==%base_year%

*Y_pre0(L,G)$(FLAG_G(G) AND LGTAP(L))=land_basemap("%Sr%",G,L);
Y_pre0(L,G)$(FLAG_G(G) AND LRCP(L))=frac_rcp("%Sr%",L,"%base_year%",G);
Y_pre0(L,G)$(FLAG_G(G) AND LCROP(L))=crop_basemap(L,G);

Y_pre0("CROP_FLW",G)$FLAG_G(G)=frac_rcp("%Sr%","CL","%base_year%",G)-SUM(L$LCROP(L),Y_pre0(L,G));
Y_pre0("CROP_FLW",G)$(Y_pre0("CROP_FLW",G)<0)=0;

VZ_load(L,G)=0;

$else

$if exist '%prog_dir%/../output/gdx/%Sr%/%pre_year%.gdx' $gdxin '%prog_dir%/../output/gdx/%Sr%/%pre_year%.gdx'
$if exist '%prog_dir%/../output/gdx/%Sr%/%pre_year%.gdx' $load VY_load VZ_load

Y_pre0(L,G)$(FLAG_G(G) AND VY_load(L,G))=VY_load(L,G);

$endif



*-------Productivity (yield) data ----------*


$gdxin '%prog_dir%/individual/visit_yield/visit_yield.gdx'
$load YIELD_visit=Yield

YIELD_visit(CVST,G)$(YIELD_visit(CVST,G)<0)=0;

$gdxin '%prog_dir%/individual/fao/output/fao_out.gdx'
$load TON_C Pprod

$gdxin '%prog_dir%/data/analysis_agr.gdx'
$load YIELD_cge=YIELD

* MgC/ha/year] --> [ton/ha/year]
YIELD(L,G)$(FLAG_G(G) AND LCROP(L))=SUM(CVST$Map_LCVST(L,CVST),YIELD_visit(CVST,G) * TON_C("%Sr%",CVST));
YIELD(L,G)$(FLAG_G(G) AND LLIV(L)) =SUM(CVST$Map_LCVST(L,CVST),YIELD_visit(CVST,G)) /C_DW/DW_TON(L);


*--- Adjustment of productivity (yield) to CGE estimates ---*

parameter
SF_YIELD(L)	Scale factor to adjust average yield to CGE estimates
;

YIELD_AVE(L)$(LCROP(L) AND SUM(G$FLAG_G(G),GA(G)*Y_pre0(L,G))) = SUM(G$FLAG_G(G),GA(G)*Y_pre0(L,G)*YIELD(L,G)) / SUM(G$FLAG_G(G),GA(G)*Y_pre0(L,G));
SF_YIELD(L)$(LCROP(L) AND YIELD_AVE(L))=YIELD_cge("%Sy%","%Sr%",L)/YIELD_AVE(L);
YIELD(L,G)$(FLAG_G(G) AND LCROP(L))=YIELD(L,G)*SF_YIELD(L);


*-------- Land demand

* [10^5ha --> 000ha]
PLDM(L)=SUM(A$MAP_LA(L,A), SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A) )) * 10**2;
PLDM("PRM_FRS")=SMIN(Y$(ordy("%base_year%")<=ordy(Y) AND ordy(Y)<=ordy("%Sy%")),Planduse(Y,"%Sr%","PRM_FRS"));
PLDM("MNG_FRS")=Planduse("%Sy%","%Sr%","PRM_FRS")+Planduse("%Sy%","%Sr%","MNG_FRS")-PLDM("PRM_FRS");
PLDM("GL")=Planduse("%Sy%","%Sr%","GRASS");
PLDM("CROP_FLW")=Planduse("%Sy%","%Sr%","CROP_FLW");
PLDM("SL")=SUM(G$FLAG_G(G),GA(G)*Y_pre0("SL",G));
PLDM("OL")=SUM(G$FLAG_G(G),GA(G)*Y_pre0("OL",G));

* mil.$/ton
pr_price_base(L)$Pprod("%base_year%","%Sr%",L,"TON") =  SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_value("%base_year%","%Sr%",A,C))) / Pprod("%base_year%","%Sr%",L,"TON");
pr_price_base("CROP_FLW")$SUM(L2$LCROP(L2),Pprod("%base_year%","%Sr%",L2,"TON")) =  SUM(A$(ACROP(A)),SUM(C$(CCROP(C)),PSAM_value("%base_year%","%Sr%",A,C))) / SUM(L2$LCROP(L2),Pprod("%base_year%","%Sr%",L2,"TON"));
pr_price_base("BIO")=1;

pr_price(Y,L)$SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_volume(Y,"%Sr%",A,C))) =  SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_value(Y,"%Sr%",A,C))) / SUM(A$MAP_LA(L,A),SUM(C$MAP_LC(L,C),PSAM_volume(Y,"%Sr%",A,C)));
pr_price(Y,"CROP_FLW")$SUM(A$ACROP(A),SUM(C$CCROP(C),PSAM_volume(Y,"%Sr%",A,C))) = SUM(A$ACROP(A),SUM(C$CCROP(C),PSAM_value(Y,"%Sr%",A,C))) / SUM(A$ACROP(A),SUM(C$CCROP(C),PSAM_volume(Y,"%Sr%",A,C)));

pr_price_indx(L)$pr_price("%base_year%",L)=pr_price("%Sy%",L)/pr_price("%base_year%",L);

* mil.$/ha/year = mil.$/ton * ton/ha/year
pr(L,G)$(FLAG_G(G)) = pr_price_base(L) * pr_price_indx(L) * YIELD(L,G);
* [mil. $]
pc_input(L)=SUM(A$MAP_LA(L,A), SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));
pc_input("CROP_FLW")=SUM(A$(ACROP(A)),SUM(C,PSAM_value("%Sy%","%Sr%",C,A)) + SUM(F,PSAM_value("%Sy%","%Sr%",F,A)) + SUM(TX,PSAM_value("%Sy%","%Sr%",TX,A)) + PSAM_value("%Sy%","%Sr%","ATAX",A));

* [10^5ha --> ha]
pc_area(L)=SUM(A$MAP_LA(L,A),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5;
pc_area("CROP_FLW")=SUM(A$(ACROP(A)),SUM(FL,PSAM_volume("%Sy%","%Sr%",FL,A))) * 10**5;

* [mil.$/ha]
pc(L,G)$(FLAG_G(G) AND YIELD(L,G) AND pc_area(L))=pc_input(L)/pc_area(L);

ps(L,G)$(FLAG_G(G) AND YIELD(L,G))=pr(L,G)-pc(L,G);


* Protected area data
$gdxin '%prog_dir%/individual/protected_area/output/protected_area.gdx'
$load protectflag


*------- Initial data ----------*

Y_pre(L,G)=Y_pre0(L,G);

VY.LO(L,G)=0;

VY.L(L,G)$(Y_pre0(L,G))=Y_pre0(L,G);
VZ.L(L,G)$(VZ_load(L,G))=VZ_load(L,G);
VOBJ.L=0;

VY.FX(L,G)$(FLAG_G(G)=0)=0;
VZ.FX(L,G)$(FLAG_G(G)=0)=0;

VY.FX("PRM_FRS",G)$(protectflag(G) AND Y_pre0("PRM_FRS",G))=Y_pre0("PRM_FRS",G);
VY.FX("SL",G)$(Y_pre0("SL",G))=Y_pre0("SL",G);
VY.FX("OL",G)$(Y_pre0("OL",G))=Y_pre0("OL",G);

execute_unload '../output/temp.gdx'


Solve LandUseModel USING NLP minimizing VOBJ;


*------- Data output ----------*

Set
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
;

parameter
VY_IJ(L,I,J)
Y_pre_IJ(L,I,J)
Dif_Y(L,I,J)
Yield_IJ(L,I,J)

;

$gdxin '%prog_dir%/prog/data_prep.gdx'
$load Map_GIJ


VY_load(L,G)=0;
VZ_load(L,G)=0;
VY_load(L,G)=VY.L(L,G);
VZ_load(L,G)=VZ.L(L,G);

VY_IJ(L,I,J)=SUM(G$(MAP_GIJ(G,I,J) AND FLAG_G(G)),VY.L(L,G) + eps);
*Y_pre_IJ(L,I,J)=SUM(G$(MAP_GIJ(G,I,J) AND FLAG_G(G)),Y_pre(L,G) + eps);
*Dif_Y(L,I,J)=VY_IJ(L,I,J)-Y_pre_IJ(L,I,J);
*Yield_IJ(L,I,J)=SUM(G$(MAP_GIJ(G,I,J) AND FLAG_G(G)), YIELD(L,G) + eps);


file resultsall /..\output\txt\%Sr%\%Sy%.txt/;
resultsall.pc=6;
put resultsall;
loop((L,I,J)$(VY_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,VY_IJ(L,I,J):10:5/
);

$ontext
file resultsall2 /..\output\txt\%Sr%\%Sy%dif.txt/;
resultsall2.pc=6;
put resultsall2;
loop((L,I,J)$(Dif_Y(L,I,J)),
     put L.tl,I.tl,J.tl,Dif_Y(L,I,J):10:5/
);


file resultsall3 /..\output\txt\%Sr%\%Sy%org.txt/;
resultsall3.pc=6;
put resultsall3;
loop((L,I,J)$(Y_pre_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,Y_pre_IJ(L,I,J):10:5/
);


file resultsall4 /..\output\txt\%Sr%\%Sy%yield.txt/;
resultsall4.pc=6;
put resultsall4;
loop((L,I,J)$(Yield_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,Yield_IJ(L,I,J):10:5/
);
$offtext


execute_unload '../output/gdx/%Sr%/%Sy%.gdx'
VY_load,VZ_load
ps,PLDM,pr,pr_price_base,pr_price_indx,pc,pc_input,pc_area
$if %Sy%==2005 YIELD

;
