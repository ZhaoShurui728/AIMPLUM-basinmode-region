$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ..\prog
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC

Set
R	17 regions	/
$include %prog_dir%\define\region/region17.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
Y year	/ %base_year%*%end_year% /
L land use type /
PRM_SEC	primary and secondaryland
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
;
Alias(R,R2);
set
MAP_RAGG(R,R2)	/
$include %prog_dir%\define/region/region17_agg.map
/
;
parameter
GHGL(R,Y,L)
;

$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/USA.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms USA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XE25.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XE25
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XER.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XER
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/TUR.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms TUR
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XOC.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XOC
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/CHN.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms CHN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/IND.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms IND
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/JPN.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms JPN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XSE.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XSE
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XSA.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XSA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/CAN.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms CAN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/BRA.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms BRA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XLM.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XLM
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/CIS.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms CIS
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XME.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XME
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XNF.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XNF
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/cbnal/XAF.gdx' $batinclude %prog_dir%/prog/ghg_combineR.gms XAF


GHGL(R2,Y,L)$SUM(R$MAP_RAGG(R,R2),GHGL(R,Y,L))=SUM(R$MAP_RAGG(R,R2),GHGL(R,Y,L));

execute_unload '../output/gdx/all/emission_%sce%_%CLP%_%IAV%.gdx'
GHGL;

