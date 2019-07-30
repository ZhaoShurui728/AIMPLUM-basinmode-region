$Setglobal prog_dir ..\prog
$setglobal sce SSP3
$setglobal clp BaU
$setglobal iav NoCC
$setglobal lumip off
$setglobal bioyieldcalc off

$ifthen.split %split%==1
Set
R	17 regions	/
$include %prog_dir%/\define\region/region17.set
/
G	Cell number  /
$offlisting
$include %prog_dir%/\define\set_g\G_WLD.set
$onlisting
/
I	Vertical position (LAT)	/ 1*360 /
J	Horizontal position (LON)	/ 1*720 /
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
*Y	Year	/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
Y	Year	/2010,2020,2030,2040,2050,2060,2070,2080,2090,2100/

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
*$ifthen.sr not %Sr%==WLD
PRM_SEC
PDR	rice
WHT	wheat
GRO	other coarse grain
OSD	oil crops
C_B	sugar crops
OTH_A	other crops
CROP_FLW	fallow land
SL	built_up
OL	ice or water
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
ONV	other natural vegetation
/
Lmip/
$include %prog_dir%/define/lumip.set
/
MAP_LUMIP(Lmip,L)/
*SL	.	urban
$include %prog_dir%/define/lumip.map

/
Lwwf/
$include %prog_dir%/define/luwwf.set
/
MAP_WWF(Lwwf,L)/
$include %prog_dir%/define/luwwf.map
/
Lwwfnum/1*7/
MAP_WWFnum(Lwwfnum,L)/
$include %prog_dir%/define/luwwfnum.map
/
MAP_RIJ(R,I,J)
;
Alias (I,I2),(J,J2);

parameter
FLAG_G(G)		Grid flag
FLAG_IJ(I,J)		Grid flag
Rarea_bio(G)
VY_load(R,Y,L,G)
VY_IJ(Y,L,I,J)
VY_IJmip(Y,Lmip,I,J)
VY_IJwwfnum(Y,Lwwfnum,I,J)
YIELD_BIO(R,Y,G)
YIELD_IJ(Y,L,I,J)
;

$gdxin '%prog_dir%/data/data_prep.gdx'
$load Map_GIJ MAP_RIJ

FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;

$gdxin '../output/gdx/results/results_%SCE%_%CLP%_%IAV%.gdx'
$load VY_load

VY_IJ(Y,L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,VY_load(R,Y,L,G)));

$ifthen.bioyield %bioyieldcalc%==on

$gdxin '../output/gdx/all/analysis_%SCE%_%CLP%_%IAV%.gdx'
$load YIELD_BIO

YIELD_IJ(Y,"BIO",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,YIELD_BIO(R,Y,G)));
$endif.bioyield

$endif.split
$if %split%==1 $exit


*$batinclude %prog_dir%/prog/outputcsv_yield.gms BIO

$ifthen %lumip%==on

VY_IJmip(Y,Lmip,I,J)=SUM(L$MAP_LUMIP(Lmip,L),VY_IJ(Y,L,I,J));

$batinclude %prog_dir%/prog/outputcsv_lumip.gms c3ann
$batinclude %prog_dir%/prog/outputcsv_lumip.gms c4ann
*$batinclude %prog_dir%/prog/outputcsv_lumip.gms c3per
*$batinclude %prog_dir%/prog/outputcsv_lumip.gms c4per
$batinclude %prog_dir%/prog/outputcsv_lumip.gms c3nfx
*$batinclude %prog_dir%/prog/outputcsv_lumip.gms range
$batinclude %prog_dir%/prog/outputcsv_lumip.gms pastr
$batinclude %prog_dir%/prog/outputcsv_lumip.gms primf
$batinclude %prog_dir%/prog/outputcsv_lumip.gms secdf
$batinclude %prog_dir%/prog/outputcsv_lumip.gms urban
$batinclude %prog_dir%/prog/outputcsv_lumip.gms irrig_c3ann
$batinclude %prog_dir%/prog/outputcsv_lumip.gms irrig_c4ann
*$batinclude %prog_dir%/prog/outputcsv_lumip.gms irrig_c3per
*$batinclude %prog_dir%/prog/outputcsv_lumip.gms irrig_c4per
$batinclude %prog_dir%/prog/outputcsv_lumip.gms irrig_c3nfx
$batinclude %prog_dir%/prog/outputcsv_lumip.gms crpbf_c4ann
$batinclude %prog_dir%/prog/outputcsv_lumip.gms flood
$batinclude %prog_dir%/prog/outputcsv_lumip.gms fallow

$else

* land category has number 1 to 8.
VY_IJwwfnum(Y,Lwwfnum,I,J)=SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J));

file output /..\output\csv\%SCE%_%CLP%_%IAV%.csv/;
put output;
output.pw=100000;
put "LC_area_share", "= "/;
* åãâ ÇÃèoóÕ

VY_IJwwfnum(Y,Lwwfnum,I,J)$(VY_IJwwfnum(Y,Lwwfnum,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;

VY_IJwwfnum(Y,Lwwfnum,I,J)$(VY_IJwwfnum(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;

loop(Y,
 loop(Lwwfnum,
  loop(I,
   loop(J,
    output.nd=7; output.nz=0; output.nr=0; output.nw=15;
    put VY_IJwwfnum(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=7 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;


$endif

execute_unload '../output/csv/%SCE%_%CLP%_%IAV%.gdx'

$exit









