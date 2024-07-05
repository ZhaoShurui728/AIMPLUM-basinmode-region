* Land Use Allocation model
* Data_prep2.gms

set
R     17 regions /
$include ../%prog_loc%/define/region/region17.set
/
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
FRS
GL
LUC
RES
/
;

*-- Carbon sink coefficient for remaining managed forest --*
set
Stc       Year category         / G20, LE20 /
Sfrst     Forest type (Natural forest or Plantation) / N, P/

clim     Climate category       / tropical, subtropical, temperate, boreal, polar /
Zeco     Ecological zone        / tar, tawa, tawb, tbsh, tbwh, tm, scf, scs, sbsh, sbwh, sm, tedo, tedc, tebsk, tebwk, tem, ba, bb, bm, p /
continent Continent             / Africa, America, Asia, Europe /
soiltype  Soil type (table2 and 3)   / hac, lac, sandy, spodic, volcanic, wetland /
map_r_clim(R,continent,clim,Zeco,soiltype) /
$include ../%prog_loc%/individual/ForestCsink/region_continent_clim_Zeco17.map
         /
value/val/
;

Parameter
cf	Carbon fraction of dry matter (Table 4.3 default value is 0.5 in Eq.7.10 but 0.47 is used) /0.47/
rr0(L,Zeco) Ratio of below-ground biomass to above-ground biomass for a specific woody vegetation (R=0 in tier1) (Table 4.4&Table6.1) /
$include ../%prog_loc%/individual/ForestCsink/Table4_4_6_1.txt
/
rr(R,L)
g_w0(clim, Zeco, continent,Stc,Sfrst)    Average annual above-ground biomass growth (Table 4.9&4.10&4.12: Table4.12 is used in AFOLU model )
g_w(R,Stc,Sfrst)
G_TOTAL(R,Stc,Sfrst)        Average annual biomass growth above and below-ground(tonne dm per ha per yr)
LEC(R,Stc,Sfrst) Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
f_mg0(clim,value)     Stock change factor of soil carbon for management regime(-) (Table 5.5 & 5.10 for cropland & table6.2 for grassland)
f_mg(R)               Stock change factor of soil carbon for management regime(-) (Table 5.5 & 5.10 for cropland & table6.2 for grassland)
;

$libinclude xlimport g_w0 ../%prog_loc%/individual/ForestCsink/Table4_7-10.xlsx Table4_9-10g_w0!
$libinclude xlimport f_mg0 ../%prog_loc%/individual/ForestCsink/Table5_5.xlsx Table5_5!

rr(R,L) = sum((continent,clim,Zeco,soiltype)$map_r_clim(R,continent,clim,Zeco,soiltype),rr0(L,Zeco));

g_w(R,Stc,Sfrst) = sum((continent,clim,Zeco,soiltype)$map_r_clim(R,continent,clim,Zeco,soiltype),g_w0(clim,Zeco,continent,Stc,Sfrst));

G_TOTAL(R,Stc,Sfrst) = g_w(R,Stc,Sfrst) * (1+rr(R,"FRS"));
*Eq 2.9 deltac_g of "b"
LEC(R,Stc,Sfrst) = G_TOTAL(R,Stc,Sfrst) * cf * (-44/12);

f_mg(R) = sum((continent,clim,Zeco,soiltype)$map_r_clim(R,continent,clim,Zeco,soiltype),f_mg0(clim,"val"));

execute_unload '../%prog_loc%/data/data_prep2.gdx'
LEC
f_mg
;
