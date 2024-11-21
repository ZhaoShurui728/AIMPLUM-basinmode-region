$Setglobal Sr JPN
$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ..\..\..\prog

set
R	17 regions	/
%Sr%
*$include %prog_dir%/\define\region/region17.set
/
Y 	year	/ %base_year%*%end_year% /
YBASE(Y)/ %base_year% /
L land use type /
PRM_SEC	primary and secondary land
HAV_FRS	harvested forestland
AFR	afforestation
PAS	grazing pasture land
GL	grassland
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
CL	cropland
/
LRCP(L) /PRM_SEC,PAS,CL/
LCS(L)	land category of emission calculated based on carbon stock
LCF(L)	land category of emission calculated based on carbon flow
G	Cell number (1 to 360*720) /
* 1 * 259200
$offlisting
$include %prog_dir%/define\set_g\G_%Sr%.set
$onlisting
/
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
;
Alias (Y,Y2,Y3);

LCS(L)=YES;
LCS("AFR")=NO;
LCF("AFR")=YES;

$gdxin '%prog_dir%/data/data_prep.gdx'
$load Map_GIJ

*--- base-year carbon stock map

set
CVST	crop categoly in VISIT /cstock,co2flux/
;
parameter
PVISIT(CVST,G)	Carbon stock and flow of land category CVST cell G in 2000s  [Mg C per ha] or [Mg C per ha per year]
WCS0(G)		Above-ground biomass in forest plantations [Mg C per ha] (visit output)
CSbase0(G)	Above-ground biomass stock of cell G in base year [Mg C per ha]
CSbase(G)		Carbon stock of primary and secondary land and pasture in cell G in base year [Mg C per ha]
biomass(I,J)
;


$gdxin '../data/rcp_grid_biomass.gdx'
$load biomass

CSbase0(G)=SUM((I,J)$MAP_GIJ(G,I,J),biomass(I,J)) * 10;


$gdxin '%prog_dir%/data/visit_data.gdx'
$load PVISIT


$ontext

CSbase0(G)=PVISIT("cstock",G);

*--- calculation of forest carbpn stock by excluding cstock on cropland and pasture from VISIT average cstock
parameter
frac_rcp(R,LRCP,YBASE,G)	fraction of each gridcell G in land category L
;

* Base-year land type data
$gdxin '%prog_dir%/data/land_map_rcp.gdx'
$load frac_rcp=frac

CSbase(G)$(frac_rcp("%Sr%","PRM_SEC","%base_year%",G)+frac_rcp("%Sr%","PAS","%base_year%",G))
= (CSbase0(G)-frac_rcp("%Sr%","CL","%base_year%",G)*5)
/(frac_rcp("%Sr%","PRM_SEC","%base_year%",G)+frac_rcp("%Sr%","PAS","%base_year%",G));

$offtext


CSbase(G)=CSbase0(G);
CSbase(G)$(CSbase(G)<0)=0;

**********
WCS0(G)=CSbase(G);
**********

*--- parameter estimation of timber yield functions

parameter
delta(G)	stocking density of forest
WCS(G,Y,Y2)	Above-ground biomass stock in year Y of forest planed in year Y2 (MgC ha-1)
WCF(G,Y,Y2)	carbon flow in year Y of forest planed in year Y2	(MgC ha-1 year-1)

CST(L,G,Y,Y2)	Above-ground biomass stock in year Y of forest planed in year Y2 in cell G (MgC ha-1)
CFT(L,G,Y,Y2)	carbon flow in year Y of forest planed in year Y2 in cell G	(MgC ha-1 year-1)
CDT(L,G,Y,Y2)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
ordy(Y)
;

ordy(Y) = ord(Y) + %base_year% -1;

delta(G)= WCS0(G) / exp(5.2-30/60);

WCS(G,Y,Y2)$( ordy(Y2)<=ordy(Y)) = delta(G) * exp(5.2-30/(ordy(Y)-ordy(Y2)+1));

WCF(G,Y,Y2)$( ordy(Y2)<=ordy(Y))=WCS(G,Y+1,Y2)-WCS(G,Y,Y2);


set
LPRMSEC(L) /PRM_SEC/
LHAV(L) /HAV_FRS/
LAFR(L) /AFR/
LCROP(L) /PDR,WHT,GRO,OSD,C_B,OTH_A,BIO,CROP_FLW/
LPAS(L) /PAS/
;

CST(L,G,Y,Y)$((LPRMSEC(L) OR LHAV(L)))=CSbase(G);
CST(L,G,Y,Y)$(LCROP(L))=5;
CST(L,G,Y,Y)$(LPAS(L))=2.5;

CST(L,G,Y,Y2)$(LAFR(L) AND ordy(Y2)+60<=ordy("%base_year%") AND ordy("%base_year%")<=ordy(Y))=CSbase(G);
CST(L,G,Y,Y2)$(LAFR(L) AND ordy("%base_year%")-60<=ordy(Y2) AND ordy(Y2)<=ordy("%base_year%") AND ordy("%base_year%")<=ordy(Y))=CSbase(G)+SUM(Y3$(ordy("%base_year%")<=ordy(Y3) AND ordy(Y3)<ordy(Y)),WCF(G,Y3,Y2));
CST(L,G,Y,Y2)$(LAFR(L) AND ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy(Y))=WCS(G,Y,Y2);

CFT(L,G,Y,Y2)$(LAFR(L) AND ordy(Y2)<=ordy(Y) AND  ordy(Y)<ordy("%end_year%"))=CST(L,G,Y+1,Y2)-CST(L,G,Y,Y2);

**************
CFT(L,G,Y,Y2)$(LAFR(L))=PVISIT("co2flux",G);
*************

CDT(L,G,Y,Y)$(LCS(L))=CST(L,G,Y,Y);

CDT(L,G,Y,Y2)$(ordy(Y2)<=ordy(Y) AND LCF(L))=CFT(L,G,Y,Y2);

execute_unload '../output/biomass%Sr%.gdx'
CDT;

