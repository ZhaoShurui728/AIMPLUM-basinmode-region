* ghg_emission.gms

$Setglobal Sr JPN
$Setglobal base_year 2005
$Setglobal end_year 2100
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC

$Setglobal prog_dir ..\AIMPLUM

set
R	17 regions	/%Sr%/
G	Cell number  /
* 1 * 259200
$offlisting
$include %prog_dir%/\define\set_g\G_%Sr%.set
$onlisting
/
Y year	/ %base_year%*%end_year% /
L land use type /
PRM_SEC	primary and secondary land
*PRM_FRS	primary forest land
HAV_FRS	production forest land
AFR	afforestation
PAS	grazing pasture land
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
BIO	bio crops
CROP_FLW	fallow land
*GL	grassland
SL	built_up
OL	ice or water
LUC	land use change total
TOT	total
/
LHAVFRS(L)/
HAV_FRS	production forest land
/
MAP_RG(R,G)	Relationship between country R and cell G
;
Alias (Y,Y2,Y3);

parameter
GA(G)		Grid area of cell G kha
VY_load(Y,L,G)	area ratio of land category L in cell G [kha]
delta_Y(Y,L,G)	change in area ratio of land category L in cell G
CDT(L,G,Y,Y2)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
GHGLG(Y,L,G)	GHG emission of land category L cell G in year Y [MtCO2 per cell per year]
GHGL(Y,L)		GHG emission of land category L in year Y [MtCO2 per year]
FLAG_G(G)		Grid flag
ordy(Y)
;

;

$gdxin '%prog_dir%/data/Data_prep.gdx'
$load GA Map_RG

FLAG_G(G)$MAP_RG("%Sr%",G)=1;

ordy(Y) = ord(Y) + %base_year% -1;

$gdxin '%prog_dir%/../output/gdx/%sce%_%CLP%_%IAV%/cbnal/%Sr%.gdx'
$load VY_load

delta_Y(Y,L,G)$(FLAG_G(G) AND ordy(Y)<ordy("%end_year%"))=VY_load(Y+1,L,G)-VY_load(Y,L,G);

$gdxin '%prog_dir%/../data/biomass/output/biomass%Sr%.gdx'
$load CDT

GHGLG(Y,L,G)$(FLAG_G(G) AND (NOT LHAVFRS(L)))= SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy(Y)),CDT(L,G,Y,Y2)*delta_Y(Y2,L,G)) *GA(G) * 44/12 /10**3 * (-1);

GHGLG(Y,L,G)$(FLAG_G(G) AND LHAVFRS(L))=  CDT(L,G,Y,Y)* VY_load(Y,L,G) *GA(G) * 44/12 /10**3;

GHGLG(Y,"TOT",G)= SUM(L,GHGLG(Y,L,G));
GHGLG(Y,"LUC",G)= GHGLG(Y,"TOT",G)-GHGLG(Y,"HAV_FRS",G);

GHGL(Y,L)= SUM(G$(FLAG_G(G)),GHGLG(Y,L,G));

execute_unload '../output/gdx/%sce%_%CLP%_%IAV%/GHG/%Sr%.gdx'
