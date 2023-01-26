$Setglobal prog_dir ../AIMPLUM

set
R	17 regions	/
$include %prog_dir%/define/region/region17.set
WLD,OECD90,REF,ASIA,MAF,LAM
/
Y year	/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
PN/Emissions,Sink,Net_emissions/
SMODEL	/LUM,CGE/
L land use type /
PRM_SEC	primary and secondary land
AFR	afforestation
PAS	grazing pasture land
CROP_FLW	fallow land
CL	cropland
SL	built_up
OL	ice or water
LUC	land use change total
FRS	forest
GL	grassland
BIO	biocrop
/
SCE_CLP/
SSP1_BaU
SSP2_BaU
SSP3_BaU
SSP4_BaU
SSP5_BaU
SSP2_26W
/
;
parameter
GHG_SSP(R,Y,PN,SMODEL,SCE_CLP)      MtCO2 per year
AREA_SSP(R,Y,L,SMODEL,SCE_CLP)	ha
EF_LUCHEM_P(R,Y,SMODEL,SCE_CLP)	emission factor (emission per unit forest area) [tCO2 per ha]
RatioLUCHEM_P(R,Y,SCE_CLP)

;


$if exist '../output/gdx/all/comparison_SSP1_BaU_NoCC.gdx' $batinclude %prog_dir%/inc_prog/comparisonR.gms SSP1 BaU
$if exist '../output/gdx/all/comparison_SSP2_BaU_NoCC.gdx' $batinclude %prog_dir%/inc_prog/comparisonR.gms SSP2 BaU
$if exist '../output/gdx/all/comparison_SSP2_26W_NoCC.gdx' $batinclude %prog_dir%/inc_prog/comparisonR.gms SSP2 26W
$if exist '../output/gdx/all/comparison_SSP3_BaU_NoCC.gdx' $batinclude %prog_dir%/inc_prog/comparisonR.gms SSP3 BaU
$if exist '../output/gdx/all/comparison_SSP4_BaU_NoCC.gdx' $batinclude %prog_dir%/inc_prog/comparisonR.gms SSP4 BaU
$if exist '../output/gdx/all/comparison_SSP5_BaU_NoCC.gdx' $batinclude %prog_dir%/inc_prog/comparisonR.gms SSP5 BaU



EF_LUCHEM_P(R,Y,SMODEL,SCE_CLP)$AREA_SSP(R,Y,"FRS",SMODEL,SCE_CLP)=GHG_SSP(R,Y,"Emissions",SMODEL,SCE_CLP)/AREA_SSP(R,Y,"FRS",SMODEL,SCE_CLP)*10**6;

RatioLUCHEM_P(R,Y,SCE_CLP)$EF_LUCHEM_P(R,Y,"CGE",SCE_CLP)=EF_LUCHEM_P(R,Y,"LUM",SCE_CLP)/EF_LUCHEM_P(R,Y,"CGE",SCE_CLP);

execute_unload '../output/gdx/all/comparison.gdx'
GHG_SSP,AREA_SSP,EF_LUCHEM_P,RatioLUCHEM_P;

