$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$setglobal ModelInt
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%
$Setglobal prog_loc
*ecosystem protection
$setglobal protectStartYear 2030


set
R	17 regions	/
$include ../%prog_loc%/define/region/region17.set
World
R5ASIA
"R5OECD90+EU"
R5REF
R5MAF
R5LAM
/
set
L land use type /
PRM_SEC	forest + grassland + pasture
FRSGL	forest + grassland
HAV_FRS	production forest
AFR	afforestation
PAS	grazing pasture
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
SL	built_up
OL	ice or water
CL	cropland
$if %base_year%==%Sy% PRM_FRS
$if %base_year%==%Sy% GL
$if %base_year%==%Sy% FRS
LUC
RES
TOT
/
protect_cat	protection area categories/
WDPA_KBA_Wu2019
WildArea_KBA_WDPA_BTC
/
;
PARAMETER
protect_area(R,protect_cat,L)	Regional aggregated protection area (kha)
;

$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms USA
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XE25
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XER
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms TUR
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XOC
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms CHN
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms IND
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms JPN
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XSE
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XSA
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms CAN
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms BRA
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XLM
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms CIS
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XME
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XNF
$batinclude ../%prog_loc%/inc_prog/protect_area_aggR.gms XAF

execute_unload '../output/gdx/protect_area_agg.gdx'
protect_area
;
