* Land Use Allocation model
* Data_preparation.gms
$setglobal prog_loc
Set
G	Cell number (1 to 360*720) / 1 * 259200 /
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
N	Country number	/ 1*357 /
R	17 regions	/
$include ../%prog_loc%/define/region/region17.set
/
Sr	106 countries /
$include ../%prog_loc%/define/country.set
/
Map_R(Sr,R) /
$include ../%prog_loc%/define/region/region17.map
/
Map_NSr(N,Sr)/
$include ../%prog_loc%/define/country.map
/
;
Alias (I,I2), (J,J2), (Sr,Sr2), (G,G2);
Set
MAP_NIJ(N,I,J)
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
MAP_SrIJ(Sr,I,J)	Relationship between country Sr and cell position I J
MAP_RIJ(R,I,J)	Relationship between region R and cell position I J
MAP_SrG(Sr,G)	Relationship between country Sr and cell G
MAP_RG(R,G)	Relationship between region R and cell G
MAP_IJ(I,J,I2,J2)	Neighboring relationship between cell I J and cell I2 J2
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
;
Parameter
MAP_NIJ0(I,J)
GS		Grid size		/ 0.5 /
GAIJ(I,J)           Grid area of cell I J kha
GA(G)		Grid area of cell G kha
GLIJ(R,I,J,I2,J2)	Distance between cell I J and I2 J2 km
GL(R,G,G2)		Distance between cell G and G2 km
LAT(I)	latitude  of cell I degree
LOG(J)	longitude of cell J degree
re	earth radius km	/6378.137/
pai	pai	/3.141592/
rad_degree	/0.0174532925/

ordi(I)
ordj(J)
ordn(N)
ordg(G)
;

ordi(I)=ord(I);
ordj(J)=ord(J);
ordn(N)=ord(N);
ordg(G)=ord(G);

LAT(I)=90-GS*ordi(i);
LOG(J)=ordj(J)*GS;


table MAP_NIJ0(I,J)
$offlisting
$ondelim
$include ../%prog_loc%/define/h_axis_title.txt
$include ../%prog_loc%/define/countrymap.txt
$offdelim
$onlisting
;

MAP_NIJ0(I,J)$(MAP_NIJ0(I,J)=-9999)=0;

table GAIJ(I,J)
$offlisting
$ondelim
$include ../%prog_loc%/define/h_axis_title.txt
$include ../%prog_loc%/define/areamap.txt
$offdelim
$onlisting
;


* [km2] --> [kha]
GAIJ(I,J)=GAIJ(I,J)/10;

MAP_NIJ(N,I,J)$(MAP_NIJ0(I,J) AND MAP_NIJ0(I,J)=ordn(N))=YES;

MAP_SrIJ(Sr,I,J)$SUM(N$Map_NSr(N,Sr),MAP_NIJ(N,I,J))=YES;

MAP_RIJ(R,I,J)$SUM(Sr$Map_R(Sr,R),MAP_SrIJ(Sr,I,J))=YES;

MAP_GIJ(G,I,J)$(MAP_NIJ0(I,J) AND ordg(G)=360/GS*(ordi(I)-1)+ordj(J))=YES;

MAP_SrG(Sr,G)$SUM((I,J)$MAP_GIJ(G,I,J),Map_SrIJ(Sr,I,J))=YES;

MAP_RG(R,G)$SUM(Sr$MAP_R(Sr,R),Map_SrG(Sr,G))=YES;

GA(G)$(SUM(Sr,MAP_SrG(Sr,G)))=SUM((I,J)$MAP_GIJ(G,I,J),GAIJ(I,J));

MAP_IJ(I,J,I2,J2)$(MAP_NIJ0(I,J) AND MAP_NIJ0(I2,J2) AND (abs(ordi(I2)-ordi(I))<=1) AND (abs(ordj(J2)-ordj(J))<=1) AND (NOT (ordi(I2)=ordi(I) AND ordj(J2)=ordj(J)))  )=YES;

MAP_WG(G,G2)$SUM((I,J)$MAP_GIJ(G,I,J),SUM((I2,J2)$MAP_GIJ(G2,I2,J2),MAP_IJ(I,J,I2,J2)))=YES;


GLIJ(R,I,J,I2,J2)$(MAP_RIJ(R,I,J) AND MAP_RIJ(R,I2,J2) AND (NOT (LAT(I)-LAT(I2)=0 AND LOG(J)-LOG(J2)=0)) AND ((abs(ordi(I2)-ordi(I))<=5) AND (abs(ordj(J2)-ordj(J))<=5) ))
=((2*pai*re*abs(LAT(I)-LAT(I2))/360) * (2*pai*re*abs(LAT(I)-LAT(I2))/360) +
  (2*pai*cos(abs((LAT(I)+LAT(I2))/2)*rad_degree)*re*abs(LOG(J)-LOG(J2))/360) * (2*pai*cos(abs((LAT(I)+LAT(I2))/2)*rad_degree)*re*abs(LOG(J)-LOG(J2))/360)
 )**(1/2);

GL(R,G,G2)$(MAP_RG(R,G) AND MAP_RG(R,G2))=SUM((I,J)$MAP_GIJ(G,I,J),SUM((I2,J2)$MAP_GIJ(G2,I2,J2), GLIJ(R,I,J,I2,J2)));

$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XE25
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XER
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XOC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IND
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  JPN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XSE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XSA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XLM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CIS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XME
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XNF
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  XAF



execute_unload '../%prog_loc%/data/data_prep.gdx'
Map_GIJ MAP_RG GAIJ MAP_SrIJ GA MAP_RIJ
GLUSA
GLXE25
GLXER
GLTUR
GLXOC
GLCHN
GLIND
GLJPN
GLXSE
GLXSA
GLCAN
GLBRA
GLXLM
GLCIS
GLXME
GLXNF
GLXAF
*Map_GIJ MAP_RG GAIJ MAP_SrIJ GA
MAP_WG
MAP_SrG
;

execute_unload '../%prog_loc%/data/data_prep_check.gdx'
MAP_IJ GLIJ
;


$exit
