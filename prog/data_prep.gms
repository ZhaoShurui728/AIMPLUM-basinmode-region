* Land Use Allocation model
* Data_preparation.gms
$setglobal prog_loc
Set
G	Cell number (1 to 360*720) / 1 * 259200 /
Gland(G) Cell number excluding ocean
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
IJland(I,J)	Cell number excluding ocean
R	17 regions	/
$include ../%prog_loc%/define/region/region17.set
/
RISO	ISO countries	/
$include ../%prog_loc%/define/region/region_iso.set
/
;
Alias (I,I2), (J,J2), (G,G2),(RISO,RISO2);
Set
MAP_RISO(RISO,R)	Relationship between ISO countries and 17 regions
MAP_RIJ(R,I,J)	Relationship between 17 regions R and cell position I J
MAP_RG(R,G)	Relationship between 17 regions R and cell G
MAP_RISOIJ(RISO,I,J)	Relationship between country RISO and cell position I J
MAP_RISOG(RISO,G)	Relationship between country RISO and cell G
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
MAP_IJ(I,J,I2,J2)	Neighboring relationship between cell I J and cell I2 J2
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
;
Parameter
GS		Grid size		/ 0.5 /
GAIJ(I,J)       Grid area of cell I J kha
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
ordg(G)

;

ordi(I)=ord(I);
ordj(J)=ord(J);
ordg(G)=ord(G);

LAT(I)=90-GS*ordi(i);
LOG(J)=ordj(J)*GS;

$gdxin '../%prog_loc%/define/countrymap.gdx'
$load MAP_RISO MAP_RIJ=MAP_R17IJ MAP_RISOIJ

MAP_RISOIJ("GUF","169","253")=Yes;
MAP_RISOIJ("GUF","169","254")=Yes;
MAP_RISOIJ("GUF","170","252")=Yes;
MAP_RISOIJ("GUF","170","253")=Yes;
MAP_RISOIJ("GUF","170","254")=Yes;
MAP_RISOIJ("GUF","170","255")=Yes;
MAP_RISOIJ("GUF","170","256")=Yes;
MAP_RISOIJ("GUF","171","252")=Yes;
MAP_RISOIJ("GUF","171","253")=Yes;
MAP_RISOIJ("GUF","171","254")=Yes;
MAP_RISOIJ("GUF","171","255")=Yes;
MAP_RISOIJ("GUF","171","256")=Yes;
MAP_RISOIJ("GUF","171","257")=Yes;
MAP_RISOIJ("GUF","172","252")=Yes;
MAP_RISOIJ("GUF","172","253")=Yes;
MAP_RISOIJ("GUF","172","254")=Yes;
MAP_RISOIJ("GUF","172","255")=Yes;
MAP_RISOIJ("GUF","172","256")=Yes;
MAP_RISOIJ("GUF","172","257")=Yes;
MAP_RISOIJ("GUF","173","253")=Yes;
MAP_RISOIJ("GUF","173","254")=Yes;
MAP_RISOIJ("GUF","173","255")=Yes;
MAP_RISOIJ("GUF","173","256")=Yes;
MAP_RISOIJ("GUF","174","253")=Yes;
MAP_RISOIJ("GUF","174","254")=Yes;
MAP_RISOIJ("GUF","174","255")=Yes;
MAP_RISOIJ("GUF","174","256")=Yes;
MAP_RISOIJ("GUF","175","253")=Yes;
MAP_RISOIJ("GUF","175","254")=Yes;
MAP_RISOIJ("GUF","175","255")=Yes;
MAP_RISOIJ("GUF","176","252")=Yes;

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







IJland(I,J)$(sum(R,MAP_RIJ(R,I,J)))=Yes;

MAP_GIJ(G,I,J)$(IJland(I,J) AND ordg(G)=360/GS*(ordi(I)-1)+ordj(J))=YES;

MAP_RG(R,G)$SUM((I,J)$MAP_GIJ(G,I,J),Map_RIJ(R,I,J))=YES;

Gland(G)$(SUM(R,MAP_RG(R,G)))=Yes;

MAP_RISOG(RISO,G)$SUM((I,J)$MAP_GIJ(G,I,J),MAP_RISOIJ(RISO,I,J))=YES;

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
GA(G)$(Gland(G))=SUM((I,J)$MAP_GIJ(G,I,J),GAIJ(I,J));

MAP_IJ(I,J,I2,J2)$(IJland(I,J) AND IJland(I2,J2) AND (abs(ordi(I2)-ordi(I))<=1) AND (abs(ordj(J2)-ordj(J))<=1) AND (NOT (ordi(I2)=ordi(I) AND ordj(J2)=ordj(J)))  )=YES;

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

set
G_USACAN(G)
G_USA(G)
G_XE25(G)
G_XER(G)
G_TUR(G)
G_XOC(G)
G_CHN(G)
G_IND(G)
G_JPN(G)
G_XSE(G)
G_XSA(G)
G_CAN(G)
G_BRA(G)
G_XLM(G)
G_CIS(G)
G_XME(G)
G_XNF(G)
G_XAF(G)
;

G_USACAN(G)$(MAP_RG("USA",G) or MAP_RG("CAN",G))=Yes;
G_USA(G)$(MAP_RG("USA",G))=Yes;
G_XE25(G)$(MAP_RG("XE25",G))=Yes;
G_XER(G)$(MAP_RG("XER",G))=Yes;
G_TUR(G)$(MAP_RG("TUR",G))=Yes;
G_XOC(G)$(MAP_RG("XOC",G))=Yes;
G_CHN(G)$(MAP_RG("CHN",G))=Yes;
G_IND(G)$(MAP_RG("IND",G))=Yes;
G_JPN(G)$(MAP_RG("JPN",G))=Yes;
G_XSE(G)$(MAP_RG("XSE",G))=Yes;
G_XSA(G)$(MAP_RG("XSA",G))=Yes;
G_CAN(G)$(MAP_RG("CAN",G))=Yes;
G_BRA(G)$(MAP_RG("BRA",G))=Yes;
G_XLM(G)$(MAP_RG("XLM",G))=Yes;
G_CIS(G)$(MAP_RG("CIS",G))=Yes;
G_XME(G)$(MAP_RG("XME",G))=Yes;
G_XNF(G)$(MAP_RG("XNF",G))=Yes;
G_XAF(G)$(MAP_RG("XAF",G))=Yes;

execute_unload '../%prog_loc%/define/subG.gdx'
G_USACAN
G_USA
G_XE25
G_XER
G_TUR
G_XOC
G_CHN
G_IND
G_JPN
G_XSE
G_XSA
G_CAN
G_BRA
G_XLM
G_CIS
G_XME
G_XNF
G_XAF
;

execute_unload '../%prog_loc%/data/data_prep.gdx'
Map_GIJ MAP_RG GAIJ GA MAP_RIJ
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
MAP_WG
MAP_RISOG
Gland
MAP_RISO



$exit
