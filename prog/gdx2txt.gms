$Setglobal Sr JPN
$Setglobal Sy 2005
$Setglobal base_year 2005
$Setglobal prog_dir ..\AIMPLUM
$setglobal sce SSP2
$setglobal clp BaU
$setglobal iav NoCC
$setglobal Ystep0 10
$setglobal dif off

*$if %Sy%==2005 $setglobal supcuv on
*$if %Sy%==2030 $setglobal supcuv on
*$if %Sy%==2050 $setglobal supcuv on
*$if %Sy%==2100 $setglobal supcuv on

$include %prog_dir%/inc_prog/pre_%Ystep0%year.gms


Set
R	17 regions	/
$include %prog_dir%/\define\region/region17.set
/
G	Cell number  /
$offlisting
$include %prog_dir%/\define\set_g\G_%Sr%.set
$onlisting
/
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
Y year	/ %Sy% /
L land use type /
FRSGL
FRS	forest land
PAS	grazing pasture land
GL	grassland
CL	cropland
BIO	bio crops
BIOP	potentail biocrop land
AFR	afforestation
HAV_FRS
SL	built_up
OL	ice or water
*$ifthen.sy %Sy%==%base_year%
$ifthen.sr not %Sr%==WLD
PRM_SEC
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
CROP_FLW	fallow land
TOT	total
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
$endif.sr
*$endif.sy

/
LAFR(L)/AFR/

MAP_RIJ(R,I,J)
;
Alias (I,I2),(J,J2);

parameter
FLAG_G(G)		Grid flag
FLAG_IJ(I,J)		Grid flag
Rarea_bio(G)
VY_load(L,G)
VY_1(L,G)
Yield(L,G)
Y_base(L,G)

VY_IJ(L,I,J)
VY_1IJ(L,I,J)
Dif_Y(L,I,J)
Yield_IJ(L,I,J)
Ybase_IJ(L,I,J)
GHGLG(Y,L,G)
GHG_IJ(L,I,J)
VYLAFR_nocc(G)
VYLAFRIJ_nocc(I,J)


;

$gdxin '%prog_dir%/data/data_prep.gdx'
$load Map_GIJ MAP_RIJ

$if %Sr%==WLD $include %prog_dir%/inc_prog/gdx2txt_wld.gms
$if not %Sr%==WLD $include %prog_dir%/inc_prog/gdx2txt_region.gms


VY_IJ(L,I,J)$(FLAG_IJ(I,J))=SUM(G$(MAP_GIJ(G,I,J)),VY_load(L,G));

$ontext
$ifthen.afr not %IAV%==NoCC

VYLAFRIJ_nocc(I,J)$SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYLAFR_nocc(R,G))),sum(R,VYLAFR_nocc(R,G)))=SUM((G)$(MAP_GIJ(G,I,J) and sum(R,VYLAFR_nocc(R,G))),sum(R,VYLAFR_nocc(R,G)));

VY_IJ("AFR",I,J)$(VY_IJ("AFR",I,J)-VYLAFRIJ_nocc(I,J)>0)=VYLAFRIJ_nocc(I,J);
VY_IJ("RES",I,J)$(VY_IJ("AFR",I,J)-VYLAFRIJ_nocc(I,J)>0)=VY_IJ("AFR",I,J)-VYLAFRIJ_nocc(I,J);

$else.afr

VY_IJ("AFR",I,J)$(VY_IJ("AFR",I,J))=VY_IJ("AFR",I,J);
VY_IJ("AFR",I,J)=0;

$endif.afr
$offtext


*VY_IJ(L,I,J)$(FLAG_IJ(I,J) AND SUM((I2,J2),VY_IJ(L,I2,J2)) AND (VY_IJ(L,I,J)=0))=-0.00001;
*----- Difference

$ifthen.dif %dif%==on
$ifthen.b not %Sy%==2005
  VY_1IJ(L,I,J)$(FLAG_IJ(I,J) AND SUM(G$(MAP_GIJ(G,I,J)),VY_1(L,G)))=SUM(G$(MAP_GIJ(G,I,J)),VY_1(L,G));
  Dif_Y(L,I,J)$FLAG_IJ(I,J)=VY_IJ(L,I,J)-VY_1IJ(L,I,J);
$endif.b
$endif.dif

execute_unload '../output/gdxii/%SCE%_%CLP%_%IAV%/%Sr%/%Sy%ij.gdx'
Dif_Y,VY_IJ,Yield_IJ;
$exit


$ontext


file resultsall3 /..\output\txt\%Sr%\%Sy%org.txt/;
resultsall3.pc=6;
put resultsall3;
loop((L,I,J)$(Y_pre_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,Y_pre_IJ(L,I,J):10:5/
);


$offtext


$ontext
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/GHG/%Sr%.gdx'
$load GHGLG

GHG_IJ(L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)), GHGLG("%Sy%",L,G))  + eps$(SUM(G,GHGLG("%Sy%",L,G)) AND SUM(G$(MAP_GIJ(G,I,J)), GHGLG("%Sy%",L,G))=0);

file resultsall6 /..\output\txt\%SCE%_%CLP%_%IAV%\%Sr%\%Sy%ghg.txt/;
resultsall6.pc=6;
put resultsall6;
loop((L,I,J)$(GHG_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,GHG_IJ(L,I,J):10:5/
);

$offtext








