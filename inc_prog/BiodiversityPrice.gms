* This file is included in LandUseModel_MCP.gms
* This is to calculate biodiversity index BIIcoefG(L,G)

set
LULC_class/
$include ../%prog_loc%/individual/BendingTheCurve/LULC_class.set
/
map_LLULC_class(L,LULC_class)/
$include ../%prog_loc%/individual/BendingTheCurve/map_LLULC_class.map
/
weightType /"weighted.rescaled.logTransCstBase"/
PotBiomeMask	potential biom vegetation /forested,nonforested/
map_LBiomeMask(L,PotBiomeMask,LULC_class)/
$include ../%prog_loc%/individual/BendingTheCurve/map_LBiomeMask.map
/
value /value/
;

parameter
weightIJ(I,J,weightType)
f10_potforest(G)
f10_bii_side_layers
MaskFvsNF_aggval(I,J)
sharepix_pasture(I,J)
sharepix_rangeland(I,J)
sharepix_primaryveg(I,J)
sharepix_secondaryveg(I,J)
sharepix(LULC_class,I,J)
sharepixG(LULC_class,G)
is_Forested1ORsNonForested0(I,J)
is_pasture1ORrRangeland0(I,J)
is_PrimVeg1ORSecoVeg0(I,J)
is_Forested1ORsNonForested0G(G)
is_pasture1ORrRangeland0G(G)
is_PrimVeg1ORSecoVeg0G(G)
;

PBIODIVY0(Y)$(%protectStartYear%<=2020 AND Y.val=2020)=1;
PBIODIVY0(Y)$(%protectStartYear%<=2030 AND Y.val=2030)=10;
PBIODIVY0(Y)$(%protectStartYear%<=2040 AND Y.val>=2040)=(100*(2100-Y.val)+1000*(Y.val-2040))/(2100-2040);

$gdxin '../%prog_loc%/individual/BendingTheCurve/table_weights_30Nov2017.gdx'
$load weightIJ=weight

$gdxin '../%prog_loc%/individual/BendingTheCurve/table_LUH_side_data_16Nov2017.gdx'
$load MaskFvsNF_aggval
$load sharepix_pasture
$load sharepix_rangeland
$load sharepix_primaryveg
$load sharepix_secondaryveg
$load is_pasture1ORrRangeland0
$load is_PrimVeg1ORSecoVeg0

sharepix("Managed pasture",I,J)$(sharepix_pasture(I,J)+sharepix_rangeland(I,J))=sharepix_pasture(I,J)/(sharepix_pasture(I,J)+sharepix_rangeland(I,J));
sharepix("Rangeland",I,J)$(sharepix_pasture(I,J)+sharepix_rangeland(I,J))=sharepix_rangeland(I,J)/(sharepix_pasture(I,J)+sharepix_rangeland(I,J));
sharepix("Primary vegetation",I,J)$(sharepix_primaryveg(I,J)+sharepix_secondaryveg(I,J))=sharepix_primaryveg(I,J)/(sharepix_primaryveg(I,J)+sharepix_secondaryveg(I,J));
sharepix("Mature and Intermediate secondary vegetation",I,J)$(sharepix_primaryveg(I,J)+sharepix_secondaryveg(I,J))=sharepix_secondaryveg(I,J)/(sharepix_primaryveg(I,J)+sharepix_secondaryveg(I,J));
sharepixG(LULC_class,G)$(FLAG_G(G)) =  sum((I,J)$MAP_GIJ(G,I,J),sharepix(LULC_class,I,J));
is_pasture1ORrRangeland0G(G)$(FLAG_G(G))=sum((I,J)$MAP_GIJ(G,I,J),is_pasture1ORrRangeland0(I,J));
is_PrimVeg1ORSecoVeg0G(G)$(FLAG_G(G))=sum((I,J)$MAP_GIJ(G,I,J),is_PrimVeg1ORSecoVeg0(I,J));
f10_potforest(G)$(FLAG_G(G)) =  sum((I,J)$MAP_GIJ(G,I,J),MaskFvsNF_aggval(I,J));

table BIIcoef0(PotBiomeMask,LULC_class,value)	the Biodiversity Intactness Index coefficients
$offlisting
$ondelim
*PotBiomeMask,LULC_class,value
$include ../%prog_loc%/individual/BendingTheCurve/BII_coefficients_BendingTheCurve_30Jan2018_AIM.csv
$offdelim
$onlisting
;

*cropland + afforestation + urban
BIIcoefG(L,G)$(FLAG_G(G) AND (LCROPA(L) or sameas(L,"SL") or sameas(L,"AFR") or sameas(L,"RES"))) =
sum(LULC_class$map_LLULC_class(L,LULC_class),BIIcoef0("forested",LULC_class,"value"))$(f10_potforest(G) > 0.5)  +
sum(LULC_class$map_LLULC_class(L,LULC_class),BIIcoef0("nonforested",LULC_class,"value"))$(f10_potforest(G) <= 0.5)
;
*$ontext
*pasture
BIIcoefG(L,G)$(FLAG_G(G) AND LPAS(L))=
sum(LULC_class$map_LLULC_class(L,LULC_class),BIIcoef0("forested",LULC_class,"value") * sharepixG(LULC_class,G))$(f10_potforest(G) > 0.5)  +
sum(LULC_class$map_LLULC_class(L,LULC_class),BIIcoef0("nonforested",LULC_class,"value") * sharepixG(LULC_class,G))$(f10_potforest(G) <= 0.5)
;
*forest + other natural veg
BIIcoefG(L,G)$(FLAG_G(G) AND (sameas(L,"FRS") or sameas(L,"GL")))=
sum(LULC_class$map_LLULC_class(L,LULC_class),BIIcoef0("forested",LULC_class,"value") * sharepixG(LULC_class,G))$(f10_potforest(G) > 0.5)  +
sum(LULC_class$map_LLULC_class(L,LULC_class),BIIcoef0("nonforested",LULC_class,"value") * sharepixG(LULC_class,G))$(f10_potforest(G) <= 0.5)
;
*$offtext

$ontext
*pasture
BIIcoefG(L,G)$((FLAG_G(G) AND LPAS(L))=
BIIcoef0("forested","Managed pasture","value")$(f10_potforest(G) > 0.5 and is_pasture1ORrRangeland0G(G)=1)  +
BIIcoef0("forested","Rangeland","value")$(f10_potforest(G) > 0.5 and is_pasture1ORrRangeland0G(G)=0)  +
BIIcoef0("nonforested","Managed pasture","value")$(f10_potforest(G) <= 0.5 and is_pasture1ORrRangeland0G(G)=1) +
BIIcoef0("nonforested","Rangeland","value")$(f10_potforest(G) <= 0.5 and is_pasture1ORrRangeland0G(G)=0)
;
*forest + other natural veg
BIIcoefG(L,G)$((FLAG_G(G) AND (sameas(L,"FRS") or sameas(L,"GL")))=
BIIcoef0("forested","Primary vegetation","value")$(f10_potforest(G) > 0.5 and is_PrimVeg1ORSecoVeg0G(G)=1)  +
BIIcoef0("forested","Mature and Intermediate secondary vegetation","value")$(f10_potforest(G) > 0.5 and is_PrimVeg1ORSecoVeg0G(G)=0)  +
BIIcoef0("nonforested","Primary vegetation","value")$(f10_potforest(G) <= 0.5 and is_PrimVeg1ORSecoVeg0G(G)=1) +
BIIcoef0("nonforested","Mature and Intermediate secondary vegetation","value")$(f10_potforest(G) <= 0.5 and is_PrimVeg1ORSecoVeg0G(G)=0)
;
$offtext

RR(G)$(FLAG_G(G))=SUM((I,J)$MAP_GIJ(G,I,J),weightIJ(I,J,"weighted.rescaled.logTransCstBase"));