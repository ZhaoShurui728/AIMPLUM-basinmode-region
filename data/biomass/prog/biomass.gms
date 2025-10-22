$Setglobal Sr JPN
$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ..\..\..\..\AIMPLUM

set
R	17 regions	/
%Sr%
*$include %prog_dir%/\define\region/region17.set
/
Y 	year	/ %base_year%*%end_year% /
YBASE(Y)/ %base_year% /
LRCP /PRM_SEC,PAS,CL/
G	grid number (1 to 360*720)
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
;
Alias (Y,Y2,Y3);
parameter
ordy(Y)
;
ordy(Y) = ord(Y) + %base_year% -1;

$gdxin '../%prog_loc%/define/subG.gdx'
$load G=G_%Sr%

*--- base-year carbon stock map

set
CVST	crop categoly in VISIT /cstock,co2flux/
;
parameter
PVISIT(CVST,G)	Carbon stock and flow of land category CVST cell G in 2000s  [Mg C per ha] or [Mg C per ha per year]
CSbase(G)		Carbon stock of primary and secondary land and pasture in cell G in base year [Mg C per ha]
CS(G)		biomass stock in base year in grid G (MgC ha-1)
;

$gdxin '%prog_dir%/data/visit_data.gdx'
$load PVISIT

PVISIT(CVST,G)$(PVISIT(CVST,G)<0 AND (NOT sameas(CVST,"co2flux")))=0;
* cut off 0.5% highest stock
PVISIT("cstock",G)$(PVISIT("cstock",G)>400)=400;


CSbase(G)=PVISIT("cstock",G);


**************
*CS(G)=PVISIT("cstock",G);
*execute_unload '../output/biomass%Sr%.gdx'
*CS
*$exit
*************



*--- calculation of forest carbpn stock by excluding cstock on cropland and pasture from VISIT average cstock

parameter
CSmax	maximam carbon density of forest planed (MgC ha-1 year-1)
frac_rcp_load(R,LRCP,YBASE,G)	fraction of each gridcell G in land category L
frac_rcp(LRCP,G)
;
* Base-year land type data
$gdxin '%prog_dir%/data/land_map_rcp.gdx'
$load frac_rcp_load=frac

frac_rcp(LRCP,G)=frac_rcp_load("%Sr%",LRCP,"%base_year%",G);

*$gdxin '%prog_dir%/../output/gdx/SSP2_BaU_NoCC/%Sr%/%base_year%.gdx'
*$load frac_rcp=Y_base


CSmax=smax(G,CSbase(G));

CSbase(G)$(1-frac_rcp("CL",G)-frac_rcp("PAS",G)>0)
= (CSbase(G))/(1-frac_rcp("CL",G)-frac_rcp("PAS",G));

CSbase(G)$(1-frac_rcp("CL",G)-frac_rcp("PAS",G)<0 AND 1-frac_rcp("PAS",G)>0)
= (CSbase(G))/(1-frac_rcp("PAS",G));

CSbase(G)$(CSbase(G)>CSmax)=CSmax;

*--------

*--- parameter estimation of timber yield functions

parameter
PCS(G)		potential biomass in forest plantations [Mg C per ha] (visit output)
delta(G)	stocking density of forest
WCS(G,Y,Y2)	biomass stock in year Y of forest planed in year Y2 (MgC ha-1)
WCF(G,Y,Y2)	carbon flow in year Y of forest planed in year Y2	(MgC ha-1 year-1)

CST(G,Y,Y2)	biomass stock in year Y of forest planed in year Y2 in grid G (MgC ha-1)
CFT(G,Y,Y2)	carbon flow in year Y of forest planed in year Y2 in grid G	(MgC ha-1 year-1)
ACF(G)		average carbon flow in year Y of forest planed in year Y2 in grid G	(MgC ha-1 year-1)
;

******
PCS(G)=CSbase(G);
******

delta(G)= PCS(G) / exp(5.2-30/60);
WCS(G,Y,Y2)$(ordy(Y2)<=ordy(Y)) = delta(G) * exp(5.2-30/(ordy(Y)-ordy(Y2)+1));
WCF(G,Y,Y2)$(ordy(Y2)<=ordy(Y))=WCS(G,Y+1,Y2)-WCS(G,Y,Y2);


CS(G)=CSbase(G);
CST(G,Y,Y2)$(ordy(Y2)+60<=ordy("%base_year%") AND ordy("%base_year%")<=ordy(Y))=CSbase(G);
CST(G,Y,Y2)$(ordy("%base_year%")-60<=ordy(Y2) AND ordy(Y2)<=ordy("%base_year%") AND ordy("%base_year%")<=ordy(Y))=CSbase(G)+SUM(Y3$(ordy("%base_year%")<=ordy(Y3) AND ordy(Y3)<ordy(Y)),WCF(G,Y3,Y2));
CST(G,Y,Y2)$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy(Y))=WCS(G,Y,Y2);

CFT(G,Y,Y2)$(ordy(Y2)<=ordy(Y) AND  ordy(Y)<=ordy("%end_year%"))=CST(G,Y,Y2)-CST(G,Y-1,Y2);

ACF(G)=SUM((Y)$(ordy(Y)<=ordy("%end_year%")),CFT(G,"%end_year%",Y))/(%end_year%-%base_year%);

**************
CS(G)=PVISIT("cstock",G);
*CF(G)=PVISIT("co2flux",G);
*CFT(G,Y,Y2)=PVISIT("co2flux",G);
*************


execute_unload '../output/biomass%Sr%.gdx'
CS
*PCS,CFT,ACF
;

