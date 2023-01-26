* ghg_emission.gms

$Setglobal Sr JPN
$Setglobal base_year 2005
$Setglobal end_year 2100
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC

$Setglobal prog_dir ../prog

set
R	17 regions	/%Sr%/
G	Cell number  /
* 1 * 259200
$offlisting
$include %prog_dir%//define/set_g/G_%Sr%.set
$onlisting
/
Y year	/ %base_year%*%end_year% /
Y5(Y)/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/

L land use type /
PRM_SEC	primary and secondary land
*PRM_FRS	primary forest land
*HAV_FRS	production forest land
AFR	afforestation
PAS	grazing pasture land
$ontext
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
BIO	bio crops
$offtext
CROP_FLW	fallow land
CL	cropland
*GL	grassland
SL	built_up
OL	ice or water
LUC	land use change total
*TOT	total
/
*LHAVFRS(L)/HAV_FRS/
LPRMSEC(L)/PRM_SEC/
LAFR(L)/AFR/
;
Alias (Y,Y2,Y3);

parameter
GA(G)		Grid area of cell G kha
VY_load(Y,L,G)	area ratio of land category L in cell G [kha]
delta_Y(Y,L,G)	change in area ratio of land category L in cell G
CSL(L,G)	carbon density in year Y of forest planed in year Y2 in cell G (MgC ha-1 year-1)
GHGLG(Y,L,G)	GHG emission of land category L cell G in year Y [MtCO2 per cell per year]
GHGL(Y,L)		GHG emission of land category L in year Y [MtCO2 per year]
FLAG_G(G)		Grid flag
ordy(Y)
Y_base(L,G)
CS(G)		biomass stock in base year in grid G (MgC ha-1)
CFT(G,Y,Y2)	carbon flow in year Y of forest planed in year Y2 in grid G	(MgC ha-1 year-1)
ACF(G)		average carbon flow in year Y of forest planed in year Y2 in grid G	(MgC ha-1 year-1)
;


$gdxin '%prog_dir%/data/Data_prep.gdx'
$load GA

ordy(Y) = ord(Y) + %base_year% -1;

$gdxin '%prog_dir%/../output/gdx/%sce%_%CLP%_%IAV%/analysis/%Sr%.gdx'
$load VY_load

delta_Y(Y,L,G)$(ordy(Y)>=ordy("%base_year%")+5 AND ordy(Y)<=ordy("%end_year%"))=(VY_load(Y,L,G)-VY_load(Y-5,L,G))/5;

parameter
checkArea(Y,L)
;
checkArea(Y,L)=sum(G,delta_Y(Y,L,G) *GA(G));

$gdxin '%prog_dir%/../data/biomass/output/biomass%Sr%.gdx'
$load CS

$gdxin '%prog_dir%/../data/biomass/output/biomass%Sr%_aez.gdx'
$load ACF
*$load CFT


CSL("CL",G)=5;
CSL("PAS",G)=2.5;
CSL("PRM_SEC",G)=CS(G);

$ontext
*-----�X�т݂̂̃X�g�b�N�ʂ��v�Z
parameter
CDTmax	maximam carbon density of forest planed (MgC ha-1 year-1)
;

CDTmax=smax(G,CSL("PRM_SEC",G,"2005","2005"));


$gdxin '%prog_dir%/../output/gdx/%sce%_%CLP%_%IAV%/%Sr%/%base_year%.gdx'
$load Y_base

CSL("PRM_SEC",G,Y,Y)$(1-Y_base("CL",G)-Y_base("PAS",G)>0)
= (CSL("PRM_SEC",G,Y,Y))/(1-Y_base("CL",G)-Y_base("PAS",G));

CSL("PRM_SEC",G,Y,Y)$(1-Y_base("CL",G)-Y_base("PAS",G)<0 AND 1-Y_base("PAS",G)>0)
= (CSL("PRM_SEC",G,Y,Y))/(1-Y_base("PAS",G));

CSL("PRM_SEC",G,Y,Y)$(CSL("PRM_SEC",G,Y,Y)>CDTmax)=CDTmax;

*-----
$offtext



GHGLG(Y,L,G)= CSL(L,G)*delta_Y(Y,L,G) *GA(G) * 44/12 /10**3 * (-1);

*GHGLG(Y,L,G)$(LAFR(L) AND Y5(Y))= SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy(Y)), CFT(G,Y,Y2)*VY_load(Y2,L,G)) *GA(G) * 44/12 /10**3 * (-1);
GHGLG(Y,L,G)$(LAFR(L) AND Y5(Y))= ACF(G)*VY_load(Y,L,G) *GA(G) * 44/12 /10**3 * (-1);

GHGLG(Y,L,G)$(LPRMSEC(L) AND Y5(Y))= (
				(CSL("PRM_SEC",G)*delta_Y(Y,L,G))$(delta_Y(Y,L,G)<0)
*				+ SUM(Y2$(ordy("%base_year%")<=ordy(Y2) AND ordy(Y2)<=ordy(Y) AND delta_Y(Y2,L,G)>0 AND Y5(Y2)),CFT(G,Y,Y2)*delta_Y(Y2,L,G))
				)*GA(G) * 44/12 /10**3 * (-1);



GHGLG(Y,"LUC",G)= SUM(L,GHGLG(Y,L,G));


GHGL(Y,L)= SUM(G,GHGLG(Y,L,G));

execute_unload '../output/gdx/%sce%_%CLP%_%IAV%/GHG/%Sr%.gdx'
