set
*G	Cell number (1 to 360*720) / 1 * 259200 /
I	Vertical position	/ 1*361 /
J	Horizontal position	/ 1*721 /
lon/
$include ../../../define/lon.set
/
lat/
$include ../../../define/lat.set
/
map_lon(lon,j)/
$include ../../../define/lon.map
/
map_lat(lat,i)/
$include ../../../define/lat.map
/

Rall 17 regions + ISO countries /
$include      ../../../define/region17exclNations.set
$include      ../../../define/region_iso.set
/
Sr17(Rall)/
$include      ../../../define/region17.set
/
RISO(Rall)/
$include      ../../../define/region_iso.set
/
map_RISO(RISO,Rall)/
$        include ../../../define/region_iso_17exclNations.map
$        include ../../../define/region_Riso_Riso.map
/
MAP_R17IJ(Sr17,I,J)	Relationship between 17 regions and cell position I J
MAP_RISOIJ(RISO,I,J)	Relationship between ISO countries and cell position I J
*MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
;

Alias(RISO,RRISO),(Sr17,Srr17);



parameter
landshare0(lon,lat,RISO) parcentage ratio of land area to grid area (0 to 1) in original lat lon sets
landshare(I,J,Rall)      parcentage ratio of land area to grid area (0 to 1) in PLUM lat lon sets
landshare_r17(Sr17)      parcentage ratio of land area to total grid area in 17 regions (0 to 1)
landarea_r17(Sr17)       total land area in 17 regions (kha)
GAIJ0(I,J) grid area (kha)
GAIJ(I) grid area (kha)

landarea_riso_check(RISO,I,J)       total land area in 17 regions (kha)
landarea_riso_check2(RISO)       total land area in 17 regions (kha)

landarea_r17_check(Sr17,I,J)       total land area in 17 regions (kha)

;

$gdxin '../../../define/data_prep.gdx'
$load GAIJ0=GAIJ

GAIJ(I)=GAIJ0(I,"1");

$gdxin '../../../output/gridmapping/landshare_iso.gdx'
$load landshare0=landshare

landshare(I,J,RISO)=sum(lat$map_lat(lat,i),sum(lon$map_lon(lon,j),landshare0(lon,lat,RISO)));

landshare(I,J,Sr17)$(sum(RISO$(map_RISO(RISO,Sr17) and landshare(I,J,RISO)),GAIJ(I)))=sum(RISO$(map_RISO(RISO,Sr17) and landshare(I,J,RISO)),GAIJ(I)*landshare(I,J,RISO))/sum(RISO$(map_RISO(RISO,Sr17) and landshare(I,J,RISO)),GAIJ(I));

landshare_r17(Sr17)$(sum(RISO$map_RISO(RISO,Sr17),sum((I,J)$landshare(I,J,RISO),GAIJ(I))))=sum(RISO$map_RISO(RISO,Sr17),sum((I,J)$landshare(I,J,RISO),GAIJ(I)*landshare(I,J,RISO)))/sum(RISO$map_RISO(RISO,Sr17),sum((I,J)$landshare(I,J,RISO),GAIJ(I)));

MAP_RISOIJ(RISO,I,J)$(landshare(I,J,RISO)=smax(RRISO$(landshare(I,J,RRISO)),landshare(I,J,RRISO)))=Yes;
MAP_R17IJ(Sr17,I,J)$(sum(RISO$map_RISO(RISO,Sr17),MAP_RISOIJ(RISO,I,J)))=Yes;


* for check
landarea_riso_check(RISO,I,J)=GAIJ(I)*landshare(I,J,RISO);
landarea_riso_check2(RISO)=sum((I,J),landarea_riso_check(RISO,I,J));

landarea_r17_check(Sr17,I,J)=sum(RISO$map_RISO(RISO,Sr17),landarea_riso_check2(RISO));

execute_unload '../../../output/gridmapping/countrymap.gdx'
Sr17
RISO
map_RISO
MAP_R17IJ
MAP_RISOIJ
;

execute_unload '../../../output/gridmapping/landshare_isoIJ.gdx'
RISO
landshare
*landshare_r17
*landarea_r17
landarea_riso_check
landarea_riso_check2
landarea_r17_check
;

* Japans land area = 37797.3 kha


