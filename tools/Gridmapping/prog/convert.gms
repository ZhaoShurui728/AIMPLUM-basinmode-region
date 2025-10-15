set
*G	Cell number (1 to 360*720) / 1 * 259200 /
I	Vertical position	/ 1*361 /
J	Horizontal position	/ 1*721 /
lon/
$include ../define/lon.set
/
lat/
$include ../define/lat.set
/
map_lon(lon,j)/
$include ../define/lon.map
/
map_lat(lat,i)/
$include ../define/lat.map
/

Rall 17 regions + ISO countries + basin /
$include      ../../../define/region/region17exclNations.set
$include      ../../../define/region/region_iso.set
$include      ../../../individual/basin/region_basin.set
/
Sr17(Rall)/
$include      ../../../define/region/region17.set
/
RISO(Rall)/
$include      ../../../define/region/region_iso.set
/
Rbasin(Rall)/
$include      ../../../individual/basin/region_basin.set
/
map_RISO(RISO,Rall)/
$        include ../../../define/region/region_iso_17exclNations.map
$        include ../../../define/region/region_iso.map
/
MAP_RIJ(Rall,I,J)	Relationship between 17 regions and cell position I J
MAP_RAGG_basin_17(Rbasin,Sr17)/
$include      ../../../individual/basin/region_basin_17_0.map
/
;

Alias(RISO,RRISO),(Sr17,Srr17),(Rbasin,Rbasin2);



parameter
landshare0(lon,lat,RISO) parcentage ratio of land area to grid area (0 to 1) in original lat lon sets
landshare(I,J,Rall)      parcentage ratio of land area to grid area (0 to 1) in PLUM lat lon sets
GAIJ0(I,J) grid area (kha)
GAIJ(I) grid area (kha)
num_RISO(I,J)
num_R17(I,J)

landshare_rbasin0(lon,lat,Rbasin) parcentage ratio of land area to grid area (0 to 1) in original lat lon sets
landshare_rbasin(I,J,Rbasin)      parcentage ratio of land area to grid area (0 to 1) in PLUM lat lon sets

;

$gdxin '../../../data/data_prep.gdx'
$load GAIJ0=GAIJ

GAIJ(I)=GAIJ0(I,"1");

$gdxin '../output/landshare_iso.gdx'
$load landshare0=landshare
* generating basin map
$gdxin '../output/landshare_basiniso.gdx'
$load landshare_rbasin0=landshare

landshare(I,J,RISO)=sum(lat$map_lat(lat,i),sum(lon$map_lon(lon,j),landshare0(lon,lat,RISO)));

landshare(I,J,Sr17)$(sum(RISO$(map_RISO(RISO,Sr17)),GAIJ(I)*landshare(I,J,RISO)))=sum(RISO$(map_RISO(RISO,Sr17)),GAIJ(I)*landshare(I,J,RISO))/GAIJ(I);

landshare(I,J,Rbasin)$(sum(lat$map_lat(lat,i),sum(lon$map_lon(lon,j),landshare_rbasin0(lon,lat,Rbasin))))=sum(lat$map_lat(lat,i),sum(lon$map_lon(lon,j),landshare_rbasin0(lon,lat,Rbasin)));
*Adjustmant of basin landshare into Sr17 region landshare if there is discripancy.
landshare(I,J,Rbasin)=landshare(I,J,Rbasin)*sum(Sr17$MAP_RAGG_basin_17(Rbasin,Sr17),landshare(I,J,Sr17)/sum(Rbasin2$MAP_RAGG_basin_17(Rbasin2,Sr17),landshare(I,J,Rbasin2)));



* allow multiple countries in a grid cell
MAP_RIJ(RISO,I,J)$(landshare(I,J,RISO))=Yes;
MAP_RIJ(Sr17,I,J)$(sum(RISO$map_RISO(RISO,Sr17),MAP_RIJ(RISO,I,J)))=Yes;
MAP_RIJ(Rbasin,I,J)$(landshare(I,J,Rbasin))=Yes;
num_RISO(I,J)$(sum(RISO$MAP_RIJ(RISO,I,J),1))=sum(RISO$MAP_RIJ(RISO,I,J),1);
num_R17(I,J)$(sum(Sr17$MAP_RIJ(Sr17,I,J),1))=sum(Sr17$MAP_RIJ(Sr17,I,J),1);




*--Manual modification

MAP_RIJ("GUF","169","253")=Yes;
MAP_RIJ("GUF","169","254")=Yes;
MAP_RIJ("GUF","170","252")=Yes;
MAP_RIJ("GUF","170","253")=Yes;
MAP_RIJ("GUF","170","254")=Yes;
MAP_RIJ("GUF","170","255")=Yes;
MAP_RIJ("GUF","170","256")=Yes;
MAP_RIJ("GUF","171","252")=Yes;
MAP_RIJ("GUF","171","253")=Yes;
MAP_RIJ("GUF","171","254")=Yes;
MAP_RIJ("GUF","171","255")=Yes;
MAP_RIJ("GUF","171","256")=Yes;
MAP_RIJ("GUF","171","257")=Yes;
MAP_RIJ("GUF","172","252")=Yes;
MAP_RIJ("GUF","172","253")=Yes;
MAP_RIJ("GUF","172","254")=Yes;
MAP_RIJ("GUF","172","255")=Yes;
MAP_RIJ("GUF","172","256")=Yes;
MAP_RIJ("GUF","172","257")=Yes;
MAP_RIJ("GUF","173","253")=Yes;
MAP_RIJ("GUF","173","254")=Yes;
MAP_RIJ("GUF","173","255")=Yes;
MAP_RIJ("GUF","173","256")=Yes;
MAP_RIJ("GUF","174","253")=Yes;
MAP_RIJ("GUF","174","254")=Yes;
MAP_RIJ("GUF","174","255")=Yes;
MAP_RIJ("GUF","174","256")=Yes;
MAP_RIJ("GUF","175","253")=Yes;
MAP_RIJ("GUF","175","254")=Yes;
MAP_RIJ("GUF","175","255")=Yes;
MAP_RIJ("GUF","176","252")=Yes;

MAP_RIJ("XLM","169","253")=Yes;
MAP_RIJ("XLM","169","254")=Yes;
MAP_RIJ("XLM","170","252")=Yes;
MAP_RIJ("XLM","170","253")=Yes;
MAP_RIJ("XLM","170","254")=Yes;
MAP_RIJ("XLM","170","255")=Yes;
MAP_RIJ("XLM","170","256")=Yes;
MAP_RIJ("XLM","171","252")=Yes;
MAP_RIJ("XLM","171","253")=Yes;
MAP_RIJ("XLM","171","254")=Yes;
MAP_RIJ("XLM","171","255")=Yes;
MAP_RIJ("XLM","171","256")=Yes;
MAP_RIJ("XLM","171","257")=Yes;
MAP_RIJ("XLM","172","252")=Yes;
MAP_RIJ("XLM","172","253")=Yes;
MAP_RIJ("XLM","172","254")=Yes;
MAP_RIJ("XLM","172","255")=Yes;
MAP_RIJ("XLM","172","256")=Yes;
MAP_RIJ("XLM","172","257")=Yes;
MAP_RIJ("XLM","173","253")=Yes;
MAP_RIJ("XLM","173","254")=Yes;
MAP_RIJ("XLM","173","255")=Yes;
MAP_RIJ("XLM","173","256")=Yes;
MAP_RIJ("XLM","174","253")=Yes;
MAP_RIJ("XLM","174","254")=Yes;
MAP_RIJ("XLM","174","255")=Yes;
MAP_RIJ("XLM","174","256")=Yes;
MAP_RIJ("XLM","175","253")=Yes;
MAP_RIJ("XLM","175","254")=Yes;
MAP_RIJ("XLM","175","255")=Yes;
MAP_RIJ("XLM","176","252")=Yes;
*---End of manual modification

execute_unload '../output/countrymap.gdx'
Sr17
RISO
map_RISO
MAP_RIJ
num_RISO
num_R17
landshare
;

$ontext
* for check
parameter
landarea_riso_check(RISO,I,J)       total land area in 17 regions (kha)
landarea_riso_check2(RISO)       total land area in 17 regions (kha)
landarea_r17_check(Sr17,I,J)       total land area in 17 regions (kha)
;

landarea_riso_check(RISO,I,J)=GAIJ(I)*landshare(I,J,RISO);
landarea_riso_check2(RISO)=sum((I,J),landarea_riso_check(RISO,I,J));
landarea_r17_check(Sr17,I,J)=sum(RISO$map_RISO(RISO,Sr17),landarea_riso_check2(RISO));

execute_unload '../output/landshare_isoIJ.gdx'
landarea_riso_check
landarea_riso_check2
landarea_r17_check
;
$offtext

* Japans land area = 37797.3 kha


