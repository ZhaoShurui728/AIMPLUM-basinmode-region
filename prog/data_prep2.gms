* Land Use Allocation model
* Data_prep2.gms

set
Sr17     17 regions /
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
map_r_clim(Sr17,continent,clim,Zeco,soiltype) /
$include ../%prog_loc%/individual/ForestCsink/region_continent_clim_Zeco17.map
         /
;

Parameter
cf	Carbon fraction of dry matter (Table 4.3 default value is 0.5 in Eq.7.10 but 0.47 is used) /0.47/
rr0(L,Zeco) Ratio of below-ground biomass to above-ground biomass for a specific woody vegetation (R=0 in tier1) (Table 4.4&Table6.1) /
$include ../%prog_loc%/individual/ForestCsink/Table4_4_6_1.txt
/
rr(Sr17,L)
g_w0(clim, Zeco, continent,Stc,Sfrst)    Average annual above-ground biomass growth (Table 4.9&4.10&4.12: Table4.12 is used in AFOLU model )
g_w(Sr17,Stc,Sfrst)
G_TOTAL(Sr17,Stc,Sfrst)        Average annual biomass growth above and below-ground(tonne dm per ha per yr)
LEC(Sr17) Carbon sequestration coefficient of natural forest grater than 20 years  (tonneCO2 per ha per year)
;

$libinclude xlimport g_w0 ../%prog_loc%/individual/ForestCsink/Table4_7-10.xlsx Table4_9-10g_w0!

rr(Sr17,L) = sum((continent,clim,Zeco,soiltype)$map_r_clim(Sr17,continent,clim,Zeco,soiltype),rr0(L,Zeco));

g_w(Sr17,Stc,Sfrst) = sum((continent,clim,Zeco,soiltype)$map_r_clim(Sr17,continent,clim,Zeco,soiltype),g_w0(clim,Zeco,continent,Stc,Sfrst));

G_TOTAL(Sr17,Stc,Sfrst) = g_w(Sr17,Stc,Sfrst) * (1+rr(Sr17,"FRS"));
*Eq 2.9 deltac_g of "b"
LEC(Sr17) = G_TOTAL(Sr17,"G20","N") * cf * (-44/12);

execute_unload '../%prog_loc%/data/data_prep2.gdx'
LEC
;