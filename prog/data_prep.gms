* Land Use Allocation model
* Data_preparation.gms
$setglobal prog_loc
Set
G	Cell number (1 to 360*720) / 1 * 259200 /
Gland(G) Cell number excluding ocean
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
IJland(I,J)	Cell number excluding ocean
Rall 17 regions + ISO countries /
$include      ../%prog_loc%/define/region/region17exclNations.set
$include      ../%prog_loc%/define/region/region_iso.set
$include      ../%prog_loc%/individual/basin/region_basin.set
/
R(Rall)	17 regions	/
$include ../%prog_loc%/define/region/region17.set
/
RISO(Rall)	ISO countries	/
$include ../%prog_loc%/define/region/region_iso.set
/
Rbasin(Rall)/
$include      ../%prog_loc%/individual/basin/region_basin.set
/
;
Alias (I,I2), (J,J2), (G,G2),(RISO,RISO2);
Set
MAP_RISO(RISO,R)	Relationship between ISO countries and 17 regions
MAP_RIJ(Rall,I,J)	Relationship between 17 regions R and cell position I J
MAP_RG(Rall,G)	Relationship between 17 regions R and cell G
MAP_RISOIJ(RISO,I,J)	Relationship between country RISO and cell position I J
MAP_RISOG(RISO,G)	Relationship between country RISO and cell G
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
MAP_IJ(I,J,I2,J2)	Neighboring relationship between cell I J and cell I2 J2
MAP_WG(G,G2)        Neighboring relationship between cell G and cell G2
MAP_RbasinIJ(Rbasin,I,J)	Relationship between ISO country-and-basin and cell position I J.
MAP_RbasinG(Rbasin,G)	Relationship between ISO country-and-basin and cell G.
;
Parameter
GS		Grid size		/ 0.5 /
GAIJ(I,J)       Grid area of cell I J kha
GA(G)		Grid area of cell G kha
GLIJ(I,J,I2,J2)	Distance between cell I J and I2 J2 km
GL(Rall,G,G2)		Distance between cell G and G2 km
LAT(I)	latitude  of cell I degree
LOG(J)	longitude of cell J degree
re	earth radius km	/6378.137/
pai	pai	/3.141592/
rad_degree	/0.0174532925/

ordi(I)
ordj(J)
ordg(G)
landshare(I,J,Rall)      parcentage ratio of land area to grid area (0 to 1) in PLUM lat lon sets
landshareG(G,Rall)      parcentage ratio of land area to grid area (0 to 1) in PLUM lat lon sets
;

ordi(I)=ord(I);
ordj(J)=ord(J);
ordg(G)=ord(G);

LAT(I)=90-GS*ordi(i);
LOG(J)=ordj(J)*GS;

$gdxin '../%prog_loc%/define/countrymap.gdx'
$load MAP_RISO MAP_RIJ landshare

MAP_RISOIJ(RISO,I,J)$(MAP_RIJ(RISO,I,J))=Yes;
MAP_RbasinIJ(Rbasin,I,J)$(MAP_RIJ(Rbasin,I,J))=Yes;

IJland(I,J)$(sum(R,MAP_RIJ(R,I,J)))=Yes;

MAP_GIJ(G,I,J)$(IJland(I,J) AND ordg(G)=360/GS*(ordi(I)-1)+ordj(J))=YES;

MAP_RG(Rall,G)$SUM((I,J)$MAP_GIJ(G,I,J),Map_RIJ(Rall,I,J))=YES;

Gland(G)$(SUM(R,MAP_RG(R,G)))=Yes;

MAP_RISOG(RISO,G)$SUM((I,J)$MAP_GIJ(G,I,J),MAP_RISOIJ(RISO,I,J))=YES;
MAP_RbasinG(Rbasin,G)$SUM((I,J)$MAP_GIJ(G,I,J),MAP_RbasinIJ(Rbasin,I,J))=YES;

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

GLIJ(I,J,I2,J2)$(sum(Rall$(MAP_RIJ(Rall,I,J) AND MAP_RIJ(Rall,I2,J2)),1) AND (NOT (LAT(I)-LAT(I2)=0 AND LOG(J)-LOG(J2)=0)) AND ((abs(ordi(I2)-ordi(I))<=5) AND (abs(ordj(J2)-ordj(J))<=5) ))
=((2*pai*re*abs(LAT(I)-LAT(I2))/360) * (2*pai*re*abs(LAT(I)-LAT(I2))/360) +
  (2*pai*cos(abs((LAT(I)+LAT(I2))/2)*rad_degree)*re*abs(LOG(J)-LOG(J2))/360) * (2*pai*cos(abs((LAT(I)+LAT(I2))/2)*rad_degree)*re*abs(LOG(J)-LOG(J2))/360)
 )**(1/2);

GL(Rall,G,G2)$(MAP_RG(Rall,G) AND MAP_RG(Rall,G2))=SUM((I,J)$MAP_GIJ(G,I,J),SUM((I2,J2)$MAP_GIJ(G2,I2,J2), GLIJ(I,J,I2,J2)));

landshareG(G,Rall)$(sum((I,J)$MAP_GIJ(G,I,J),landshare(I,J,Rall)))=sum((I,J)$MAP_GIJ(G,I,J),landshare(I,J,Rall));

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
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AFG_AMDA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AFG_CSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AFG_FARA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AFG_HELM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AFG_INDU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AGO_ANGC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AGO_ASII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AGO_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AGO_ZAMB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ALB_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARE_ARPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_LAPL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_NASA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_NEGR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_PAMP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_SACC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_SASS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARG_SGRN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ARM_CSSW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ATG_CARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUS_AEAC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUS_AINT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUS_ASCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUS_AUNC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUS_AWEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUS_MRDA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AUT_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  AZE_CSSW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BDI_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BDI_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BEL_MAAS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BEL_SCHE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BEN_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BEN_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BEN_VOLT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BFA_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BFA_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BFA_VOLT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BGD_BBCN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BGD_GABR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BGR_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BGR_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BHR_ARPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BHS_CARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BIH_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BIH_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BLR_DAUG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BLR_DNIP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BLR_NEMA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BLZ_YUPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BOL_AMAZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BOL_LAPL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BOL_LPUN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRA_AMAZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRA_LAPL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRA_SAOF
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRA_TOCA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRA_UBSA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BRB_CARC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BTN_GABR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BWA_ASII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BWA_LIMP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  BWA_ORAN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAF_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAF_LCHA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_AOSB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_HBCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_MACK
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_NWTT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_PACA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_SNEL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CAN_STLA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHE_POOO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHE_RHIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHE_RHON
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHL_LPUN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHL_NCHI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHL_SCPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN_AMUR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN_CHIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN_GOBI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN_HHEE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN_TARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CHN_YANG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CIV_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CIV_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CMR_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CMR_GFGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CMR_LCHA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CMR_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COD_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COG_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COG_GFGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COL_AMAZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COL_CARC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COL_CEPC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COL_MAGD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COL_ORIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  COM_MADA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CRI_SCAM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CYP_MSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CZE_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CZE_ELBE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  CZE_ODER
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DEU_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DEU_DGCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DEU_ELBE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DEU_EWES
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DEU_RHIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DJI_ARGA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DJI_RIFT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DNK_DGCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DOM_CARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DZA_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DZA_MSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  DZA_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ECU_AMAZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ECU_CEPC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  EGY_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  EGY_ARGA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  EGY_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_DOUR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_EBRO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_GUAD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_GUDA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_SPAC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_SSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ESP_TAGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  EST_BSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  EST_NARV
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ETH_ARGA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ETH_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ETH_RIFT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ETH_SHJU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FIN_FINL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FIN_SNCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FIN_SWED
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FJI_SPII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FRA_FWCX
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FRA_GIRD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FRA_LOIR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FRA_NESO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FRA_RHON
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  FRA_SEIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GAB_GFGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GBR_EAWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GBR_IREL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GBR_SCTD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GEO_BSSC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GEO_CSSW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GHA_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GHA_VOLT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GIN_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GIN_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GIN_SENE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GMB_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GNB_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GRC_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GRD_CARC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GTM_GRIJ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GTM_SCAM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GTM_YUPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GUY_AMAZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  GUY_NESO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  HKG_CHIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  HND_SCAM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  HRV_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  HRV_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  HTI_CARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  HUN_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IDN_IRJA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IDN_JATI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IDN_KALI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IDN_SULA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IDN_SUMA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IND_GABR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IND_GODA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IND_INDU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IND_KRIS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IND_SABA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRL_IREL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRN_CIRA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRN_CSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRN_CSSW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRN_PGCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRN_TIEU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  IRQ_TIEU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ISL_ICEL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ISR_DEAS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ISR_MSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ITA_IECO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ITA_IWCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ITA_MSII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ITA_POOO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ITA_TIBE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  JAM_CARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  JOR_DEAS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  JOR_EJSS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  JOR_SIPE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  JPN_JAPN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KAZ_CSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KAZ_CSPC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KAZ_LKBH
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KAZ_OBBB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KAZ_SYRD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KEN_AECC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KEN_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KEN_RIFT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KEN_SHJU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KGZ_LKBH
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KGZ_SYRD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KGZ_TARI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KHM_GTCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KHM_MEKO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KOR_NSKU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KWT_ARPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  KWT_TIEU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LAO_MEKO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LAO_VNCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LBN_DEAS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LBN_MSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LBR_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LBY_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LBY_MSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LCA_CARC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LKA_SRIL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LSO_ORAN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LTU_BSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LTU_NEMA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LUX_RHIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LVA_BSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  LVA_DAUG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MAC_XJIA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MAR_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MAR_ANWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MAR_MSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MDA_BSNC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MDA_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MDA_DNIE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MDG_MADA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_BJCA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_MCIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_MNCW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_RGBV
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_RIBA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_RIVE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_RLER
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MEX_YUPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MKD_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MLI_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MLI_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MLI_SENE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MLT_MSII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MMR_BBCN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MMR_IRRA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MMR_PMAL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MMR_SALW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MMR_SITT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MNE_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MNE_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MNG_AMUR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MNG_GOBI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MNG_YENS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MOZ_AECC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MOZ_AIOC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MOZ_LIMP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MOZ_ZAMB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MRT_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MRT_ANWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MRT_SENE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MWI_AECC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MWI_ZAMB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MYS_NBCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  MYS_PMAL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NAM_ASII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NAM_NAMC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NAM_ORAN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NER_LCHA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NER_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NGA_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NGA_GFGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NGA_LCHA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NGA_NIGE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NIC_SCAM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NLD_MAAS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NLD_RHIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NLD_SCHE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NOR_SNCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NOR_SWED
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NPL_GABR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  NZL_NZLZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  OMN_ARPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PAK_ASAC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PAK_HAMU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PAK_INDU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PAK_SABA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PAN_CEPC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PAN_SCAM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PER_AMAZ
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PER_PERU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PHL_PHIL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PNG_FLYY
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PNG_IRJA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PNG_PNGC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PNG_SEPI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  POL_ODER
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  POL_PLCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  POL_WISL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PRT_DOUR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PRT_GUAD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PRT_SPAC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PRT_TAGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  PRY_LAPL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  QAT_ARPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ROU_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_AMUR
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_LENA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_OBBB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_SNCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_SWCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_VOLG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RUS_YENS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RWA_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  RWA_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SAU_ARPA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SAU_RSEE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SDN_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SDN_ARGA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SDN_LCHA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SDN_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SEN_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SEN_SENE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SLB_SOLI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SLB_SPII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SLE_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SLV_SCAM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SRB_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  STP_GFGU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SUR_NESO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SVK_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SVN_AGBS
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SVN_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SWE_SWED
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  SWZ_SASC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TCD_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TCD_LCHA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TGO_AFWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TGO_VOLT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  THA_CHAO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  THA_GTCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  THA_MEKO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  THA_PMAL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TJK_AMDA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TJK_SYRD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TKM_AMDA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TKM_CSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TLS_JATI
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TTO_CARC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUN_ANIN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUN_MSCC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUR_BSSC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUR_CSSW
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUR_MSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TUR_TIEU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TZA_AECC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TZA_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TZA_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  TZA_RIFT
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UGA_NILE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UKR_BSNC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UKR_DANU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UKR_DNIE
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UKR_DNIP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UKR_DONN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  URY_LAPL
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  URY_UBSA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA_COLU
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA_GFCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA_GMAN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA_MSMM
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA_NACC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  USA_PACA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UZB_AMDA
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UZB_CSEC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  UZB_SYRD
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  VCT_CARC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  VNM_HRIV
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  VNM_MEKO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  VNM_VNCO
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  VUT_SPII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZAF_LIMP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZAF_ORAN
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZAF_SASC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZAF_SAWC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZMB_CONG
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZMB_ZAMB
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZWE_AIOC
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZWE_ASII
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZWE_LIMP
$batinclude ../%prog_loc%/inc_prog/gl_region.gms  ZWE_ZAMB



set
G_USACAN(G)
;

G_USACAN(G)$(MAP_RG("USA",G) or MAP_RG("CAN",G))=Yes;

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
G_AFG_AMDA
G_AFG_CSEC
G_AFG_FARA
G_AFG_HELM
G_AFG_INDU
G_AGO_ANGC
G_AGO_ASII
G_AGO_CONG
G_AGO_ZAMB
G_ALB_AGBS
G_ARE_ARPA
G_ARG_LAPL
G_ARG_NASA
G_ARG_NEGR
G_ARG_PAMP
G_ARG_SACC
G_ARG_SASS
G_ARG_SGRN
G_ARM_CSSW
G_ATG_CARI
G_AUS_AEAC
G_AUS_AINT
G_AUS_ASCO
G_AUS_AUNC
G_AUS_AWEC
G_AUS_MRDA
G_AUT_DANU
G_AZE_CSSW
G_BDI_CONG
G_BDI_NILE
G_BEL_MAAS
G_BEL_SCHE
G_BEN_AFWC
G_BEN_NIGE
G_BEN_VOLT
G_BFA_AFWC
G_BFA_NIGE
G_BFA_VOLT
G_BGD_BBCN
G_BGD_GABR
G_BGR_AGBS
G_BGR_DANU
G_BHR_ARPA
G_BHS_CARI
G_BIH_AGBS
G_BIH_DANU
G_BLR_DAUG
G_BLR_DNIP
G_BLR_NEMA
G_BLZ_YUPA
G_BOL_AMAZ
G_BOL_LAPL
G_BOL_LPUN
G_BRA_AMAZ
G_BRA_LAPL
G_BRA_SAOF
G_BRA_TOCA
G_BRA_UBSA
G_BRB_CARC
G_BTN_GABR
G_BWA_ASII
G_BWA_LIMP
G_BWA_ORAN
G_CAF_CONG
G_CAF_LCHA
G_CAN_AOSB
G_CAN_HBCO
G_CAN_MACK
G_CAN_NWTT
G_CAN_PACA
G_CAN_SNEL
G_CAN_STLA
G_CHE_POOO
G_CHE_RHIN
G_CHE_RHON
G_CHL_LPUN
G_CHL_NCHI
G_CHL_SCPA
G_CHN_AMUR
G_CHN_CHIN
G_CHN_GOBI
G_CHN_HHEE
G_CHN_TARI
G_CHN_YANG
G_CIV_AFWC
G_CIV_NIGE
G_CMR_CONG
G_CMR_GFGU
G_CMR_LCHA
G_CMR_NIGE
G_COD_CONG
G_COG_CONG
G_COG_GFGU
G_COL_AMAZ
G_COL_CARC
G_COL_CEPC
G_COL_MAGD
G_COL_ORIN
G_COM_MADA
G_CRI_SCAM
G_CYP_MSEC
G_CZE_DANU
G_CZE_ELBE
G_CZE_ODER
G_DEU_DANU
G_DEU_DGCO
G_DEU_ELBE
G_DEU_EWES
G_DEU_RHIN
G_DJI_ARGA
G_DJI_RIFT
G_DNK_DGCO
G_DOM_CARI
G_DZA_ANIN
G_DZA_MSCC
G_DZA_NIGE
G_ECU_AMAZ
G_ECU_CEPC
G_EGY_ANIN
G_EGY_ARGA
G_EGY_NILE
G_ESP_DOUR
G_ESP_EBRO
G_ESP_GUAD
G_ESP_GUDA
G_ESP_SPAC
G_ESP_SSEC
G_ESP_TAGU
G_EST_BSCC
G_EST_NARV
G_ETH_ARGA
G_ETH_NILE
G_ETH_RIFT
G_ETH_SHJU
G_FIN_FINL
G_FIN_SNCC
G_FIN_SWED
G_FJI_SPII
G_FRA_FWCX
G_FRA_GIRD
G_FRA_LOIR
G_FRA_NESO
G_FRA_RHON
G_FRA_SEIN
G_GAB_GFGU
G_GBR_EAWC
G_GBR_IREL
G_GBR_SCTD
G_GEO_BSSC
G_GEO_CSSW
G_GHA_AFWC
G_GHA_VOLT
G_GIN_AFWC
G_GIN_NIGE
G_GIN_SENE
G_GMB_AFWC
G_GNB_AFWC
G_GRC_AGBS
G_GRD_CARC
G_GTM_GRIJ
G_GTM_SCAM
G_GTM_YUPA
G_GUY_AMAZ
G_GUY_NESO
G_HKG_CHIN
G_HND_SCAM
G_HRV_AGBS
G_HRV_DANU
G_HTI_CARI
G_HUN_DANU
G_IDN_IRJA
G_IDN_JATI
G_IDN_KALI
G_IDN_SULA
G_IDN_SUMA
G_IND_GABR
G_IND_GODA
G_IND_INDU
G_IND_KRIS
G_IND_SABA
G_IRL_IREL
G_IRN_CIRA
G_IRN_CSEC
G_IRN_CSSW
G_IRN_PGCO
G_IRN_TIEU
G_IRQ_TIEU
G_ISL_ICEL
G_ISR_DEAS
G_ISR_MSEC
G_ITA_IECO
G_ITA_IWCO
G_ITA_MSII
G_ITA_POOO
G_ITA_TIBE
G_JAM_CARI
G_JOR_DEAS
G_JOR_EJSS
G_JOR_SIPE
G_JPN_JAPN
G_KAZ_CSEC
G_KAZ_CSPC
G_KAZ_LKBH
G_KAZ_OBBB
G_KAZ_SYRD
G_KEN_AECC
G_KEN_NILE
G_KEN_RIFT
G_KEN_SHJU
G_KGZ_LKBH
G_KGZ_SYRD
G_KGZ_TARI
G_KHM_GTCC
G_KHM_MEKO
G_KOR_NSKU
G_KWT_ARPA
G_KWT_TIEU
G_LAO_MEKO
G_LAO_VNCO
G_LBN_DEAS
G_LBN_MSEC
G_LBR_AFWC
G_LBY_ANIN
G_LBY_MSCC
G_LCA_CARC
G_LKA_SRIL
G_LSO_ORAN
G_LTU_BSCC
G_LTU_NEMA
G_LUX_RHIN
G_LVA_BSCC
G_LVA_DAUG
G_MAC_XJIA
G_MAR_ANIN
G_MAR_ANWC
G_MAR_MSCC
G_MDA_BSNC
G_MDA_DANU
G_MDA_DNIE
G_MDG_MADA
G_MEX_BJCA
G_MEX_MCIN
G_MEX_MNCW
G_MEX_RGBV
G_MEX_RIBA
G_MEX_RIVE
G_MEX_RLER
G_MEX_YUPA
G_MKD_AGBS
G_MLI_ANIN
G_MLI_NIGE
G_MLI_SENE
G_MLT_MSII
G_MMR_BBCN
G_MMR_IRRA
G_MMR_PMAL
G_MMR_SALW
G_MMR_SITT
G_MNE_AGBS
G_MNE_DANU
G_MNG_AMUR
G_MNG_GOBI
G_MNG_YENS
G_MOZ_AECC
G_MOZ_AIOC
G_MOZ_LIMP
G_MOZ_ZAMB
G_MRT_ANIN
G_MRT_ANWC
G_MRT_SENE
G_MWI_AECC
G_MWI_ZAMB
G_MYS_NBCO
G_MYS_PMAL
G_NAM_ASII
G_NAM_NAMC
G_NAM_ORAN
G_NER_LCHA
G_NER_NIGE
G_NGA_AFWC
G_NGA_GFGU
G_NGA_LCHA
G_NGA_NIGE
G_NIC_SCAM
G_NLD_MAAS
G_NLD_RHIN
G_NLD_SCHE
G_NOR_SNCC
G_NOR_SWED
G_NPL_GABR
G_NZL_NZLZ
G_OMN_ARPA
G_PAK_ASAC
G_PAK_HAMU
G_PAK_INDU
G_PAK_SABA
G_PAN_CEPC
G_PAN_SCAM
G_PER_AMAZ
G_PER_PERU
G_PHL_PHIL
G_PNG_FLYY
G_PNG_IRJA
G_PNG_PNGC
G_PNG_SEPI
G_POL_ODER
G_POL_PLCO
G_POL_WISL
G_PRT_DOUR
G_PRT_GUAD
G_PRT_SPAC
G_PRT_TAGU
G_PRY_LAPL
G_QAT_ARPA
G_ROU_DANU
G_RUS_AMUR
G_RUS_LENA
G_RUS_OBBB
G_RUS_SNCO
G_RUS_SWCO
G_RUS_VOLG
G_RUS_YENS
G_RWA_CONG
G_RWA_NILE
G_SAU_ARPA
G_SAU_RSEE
G_SDN_ANIN
G_SDN_ARGA
G_SDN_LCHA
G_SDN_NILE
G_SEN_AFWC
G_SEN_SENE
G_SLB_SOLI
G_SLB_SPII
G_SLE_AFWC
G_SLV_SCAM
G_SRB_DANU
G_STP_GFGU
G_SUR_NESO
G_SVK_DANU
G_SVN_AGBS
G_SVN_DANU
G_SWE_SWED
G_SWZ_SASC
G_TCD_ANIN
G_TCD_LCHA
G_TGO_AFWC
G_TGO_VOLT
G_THA_CHAO
G_THA_GTCC
G_THA_MEKO
G_THA_PMAL
G_TJK_AMDA
G_TJK_SYRD
G_TKM_AMDA
G_TKM_CSEC
G_TLS_JATI
G_TTO_CARC
G_TUN_ANIN
G_TUN_MSCC
G_TUR_BSSC
G_TUR_CSSW
G_TUR_MSEC
G_TUR_TIEU
G_TZA_AECC
G_TZA_CONG
G_TZA_NILE
G_TZA_RIFT
G_UGA_NILE
G_UKR_BSNC
G_UKR_DANU
G_UKR_DNIE
G_UKR_DNIP
G_UKR_DONN
G_URY_LAPL
G_URY_UBSA
G_USA_COLU
G_USA_GFCO
G_USA_GMAN
G_USA_MSMM
G_USA_NACC
G_USA_PACA
G_UZB_AMDA
G_UZB_CSEC
G_UZB_SYRD
G_VCT_CARC
G_VNM_HRIV
G_VNM_MEKO
G_VNM_VNCO
G_VUT_SPII
G_ZAF_LIMP
G_ZAF_ORAN
G_ZAF_SASC
G_ZAF_SAWC
G_ZMB_CONG
G_ZMB_ZAMB
G_ZWE_AIOC
G_ZWE_ASII
G_ZWE_LIMP
G_ZWE_ZAMB
;

execute_unload '../%prog_loc%/data/data_prep.gdx'
Map_GIJ MAP_RG GAIJ GA MAP_RIJ
MAP_WG
MAP_RISOG
MAP_RbasinG
Gland
MAP_RISO
landshareG
;

execute_unload '../%prog_loc%/data/GL_R17.gdx'
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
;
execute_unload '../%prog_loc%/data/GL_basin.gdx'
GLAFG_AMDA
GLAFG_CSEC
GLAFG_FARA
GLAFG_HELM
GLAFG_INDU
GLAGO_ANGC
GLAGO_ASII
GLAGO_CONG
GLAGO_ZAMB
GLALB_AGBS
GLARE_ARPA
GLARG_LAPL
GLARG_NASA
GLARG_NEGR
GLARG_PAMP
GLARG_SACC
GLARG_SASS
GLARG_SGRN
GLARM_CSSW
GLATG_CARI
GLAUS_AEAC
GLAUS_AINT
GLAUS_ASCO
GLAUS_AUNC
GLAUS_AWEC
GLAUS_MRDA
GLAUT_DANU
GLAZE_CSSW
GLBDI_CONG
GLBDI_NILE
GLBEL_MAAS
GLBEL_SCHE
GLBEN_AFWC
GLBEN_NIGE
GLBEN_VOLT
GLBFA_AFWC
GLBFA_NIGE
GLBFA_VOLT
GLBGD_BBCN
GLBGD_GABR
GLBGR_AGBS
GLBGR_DANU
GLBHR_ARPA
GLBHS_CARI
GLBIH_AGBS
GLBIH_DANU
GLBLR_DAUG
GLBLR_DNIP
GLBLR_NEMA
GLBLZ_YUPA
GLBOL_AMAZ
GLBOL_LAPL
GLBOL_LPUN
GLBRA_AMAZ
GLBRA_LAPL
GLBRA_SAOF
GLBRA_TOCA
GLBRA_UBSA
GLBRB_CARC
GLBTN_GABR
GLBWA_ASII
GLBWA_LIMP
GLBWA_ORAN
GLCAF_CONG
GLCAF_LCHA
GLCAN_AOSB
GLCAN_HBCO
GLCAN_MACK
GLCAN_NWTT
GLCAN_PACA
GLCAN_SNEL
GLCAN_STLA
GLCHE_POOO
GLCHE_RHIN
GLCHE_RHON
GLCHL_LPUN
GLCHL_NCHI
GLCHL_SCPA
GLCHN_AMUR
GLCHN_CHIN
GLCHN_GOBI
GLCHN_HHEE
GLCHN_TARI
GLCHN_YANG
GLCIV_AFWC
GLCIV_NIGE
GLCMR_CONG
GLCMR_GFGU
GLCMR_LCHA
GLCMR_NIGE
GLCOD_CONG
GLCOG_CONG
GLCOG_GFGU
GLCOL_AMAZ
GLCOL_CARC
GLCOL_CEPC
GLCOL_MAGD
GLCOL_ORIN
GLCOM_MADA
GLCRI_SCAM
GLCYP_MSEC
GLCZE_DANU
GLCZE_ELBE
GLCZE_ODER
GLDEU_DANU
GLDEU_DGCO
GLDEU_ELBE
GLDEU_EWES
GLDEU_RHIN
GLDJI_ARGA
GLDJI_RIFT
GLDNK_DGCO
GLDOM_CARI
GLDZA_ANIN
GLDZA_MSCC
GLDZA_NIGE
GLECU_AMAZ
GLECU_CEPC
GLEGY_ANIN
GLEGY_ARGA
GLEGY_NILE
GLESP_DOUR
GLESP_EBRO
GLESP_GUAD
GLESP_GUDA
GLESP_SPAC
GLESP_SSEC
GLESP_TAGU
GLEST_BSCC
GLEST_NARV
GLETH_ARGA
GLETH_NILE
GLETH_RIFT
GLETH_SHJU
GLFIN_FINL
GLFIN_SNCC
GLFIN_SWED
GLFJI_SPII
GLFRA_FWCX
GLFRA_GIRD
GLFRA_LOIR
GLFRA_NESO
GLFRA_RHON
GLFRA_SEIN
GLGAB_GFGU
GLGBR_EAWC
GLGBR_IREL
GLGBR_SCTD
GLGEO_BSSC
GLGEO_CSSW
GLGHA_AFWC
GLGHA_VOLT
GLGIN_AFWC
GLGIN_NIGE
GLGIN_SENE
GLGMB_AFWC
GLGNB_AFWC
GLGRC_AGBS
GLGRD_CARC
GLGTM_GRIJ
GLGTM_SCAM
GLGTM_YUPA
GLGUY_AMAZ
GLGUY_NESO
GLHKG_CHIN
GLHND_SCAM
GLHRV_AGBS
GLHRV_DANU
GLHTI_CARI
GLHUN_DANU
GLIDN_IRJA
GLIDN_JATI
GLIDN_KALI
GLIDN_SULA
GLIDN_SUMA
GLIND_GABR
GLIND_GODA
GLIND_INDU
GLIND_KRIS
GLIND_SABA
GLIRL_IREL
GLIRN_CIRA
GLIRN_CSEC
GLIRN_CSSW
GLIRN_PGCO
GLIRN_TIEU
GLIRQ_TIEU
GLISL_ICEL
GLISR_DEAS
GLISR_MSEC
GLITA_IECO
GLITA_IWCO
GLITA_MSII
GLITA_POOO
GLITA_TIBE
GLJAM_CARI
GLJOR_DEAS
GLJOR_EJSS
GLJOR_SIPE
GLJPN_JAPN
GLKAZ_CSEC
GLKAZ_CSPC
GLKAZ_LKBH
GLKAZ_OBBB
GLKAZ_SYRD
GLKEN_AECC
GLKEN_NILE
GLKEN_RIFT
GLKEN_SHJU
GLKGZ_LKBH
GLKGZ_SYRD
GLKGZ_TARI
GLKHM_GTCC
GLKHM_MEKO
GLKOR_NSKU
GLKWT_ARPA
GLKWT_TIEU
GLLAO_MEKO
GLLAO_VNCO
GLLBN_DEAS
GLLBN_MSEC
GLLBR_AFWC
GLLBY_ANIN
GLLBY_MSCC
GLLCA_CARC
GLLKA_SRIL
GLLSO_ORAN
GLLTU_BSCC
GLLTU_NEMA
GLLUX_RHIN
GLLVA_BSCC
GLLVA_DAUG
GLMAC_XJIA
GLMAR_ANIN
GLMAR_ANWC
GLMAR_MSCC
GLMDA_BSNC
GLMDA_DANU
GLMDA_DNIE
GLMDG_MADA
GLMEX_BJCA
GLMEX_MCIN
GLMEX_MNCW
GLMEX_RGBV
GLMEX_RIBA
GLMEX_RIVE
GLMEX_RLER
GLMEX_YUPA
GLMKD_AGBS
GLMLI_ANIN
GLMLI_NIGE
GLMLI_SENE
GLMLT_MSII
GLMMR_BBCN
GLMMR_IRRA
GLMMR_PMAL
GLMMR_SALW
GLMMR_SITT
GLMNE_AGBS
GLMNE_DANU
GLMNG_AMUR
GLMNG_GOBI
GLMNG_YENS
GLMOZ_AECC
GLMOZ_AIOC
GLMOZ_LIMP
GLMOZ_ZAMB
GLMRT_ANIN
GLMRT_ANWC
GLMRT_SENE
GLMWI_AECC
GLMWI_ZAMB
GLMYS_NBCO
GLMYS_PMAL
GLNAM_ASII
GLNAM_NAMC
GLNAM_ORAN
GLNER_LCHA
GLNER_NIGE
GLNGA_AFWC
GLNGA_GFGU
GLNGA_LCHA
GLNGA_NIGE
GLNIC_SCAM
GLNLD_MAAS
GLNLD_RHIN
GLNLD_SCHE
GLNOR_SNCC
GLNOR_SWED
GLNPL_GABR
GLNZL_NZLZ
GLOMN_ARPA
GLPAK_ASAC
GLPAK_HAMU
GLPAK_INDU
GLPAK_SABA
GLPAN_CEPC
GLPAN_SCAM
GLPER_AMAZ
GLPER_PERU
GLPHL_PHIL
GLPNG_FLYY
GLPNG_IRJA
GLPNG_PNGC
GLPNG_SEPI
GLPOL_ODER
GLPOL_PLCO
GLPOL_WISL
GLPRT_DOUR
GLPRT_GUAD
GLPRT_SPAC
GLPRT_TAGU
GLPRY_LAPL
GLQAT_ARPA
GLROU_DANU
GLRUS_AMUR
GLRUS_LENA
GLRUS_OBBB
GLRUS_SNCO
GLRUS_SWCO
GLRUS_VOLG
GLRUS_YENS
GLRWA_CONG
GLRWA_NILE
GLSAU_ARPA
GLSAU_RSEE
GLSDN_ANIN
GLSDN_ARGA
GLSDN_LCHA
GLSDN_NILE
GLSEN_AFWC
GLSEN_SENE
GLSLB_SOLI
GLSLB_SPII
GLSLE_AFWC
GLSLV_SCAM
GLSRB_DANU
GLSTP_GFGU
GLSUR_NESO
GLSVK_DANU
GLSVN_AGBS
GLSVN_DANU
GLSWE_SWED
GLSWZ_SASC
GLTCD_ANIN
GLTCD_LCHA
GLTGO_AFWC
GLTGO_VOLT
GLTHA_CHAO
GLTHA_GTCC
GLTHA_MEKO
GLTHA_PMAL
GLTJK_AMDA
GLTJK_SYRD
GLTKM_AMDA
GLTKM_CSEC
GLTLS_JATI
GLTTO_CARC
GLTUN_ANIN
GLTUN_MSCC
GLTUR_BSSC
GLTUR_CSSW
GLTUR_MSEC
GLTUR_TIEU
GLTZA_AECC
GLTZA_CONG
GLTZA_NILE
GLTZA_RIFT
GLUGA_NILE
GLUKR_BSNC
GLUKR_DANU
GLUKR_DNIE
GLUKR_DNIP
GLUKR_DONN
GLURY_LAPL
GLURY_UBSA
GLUSA_COLU
GLUSA_GFCO
GLUSA_GMAN
GLUSA_MSMM
GLUSA_NACC
GLUSA_PACA
GLUZB_AMDA
GLUZB_CSEC
GLUZB_SYRD
GLVCT_CARC
GLVNM_HRIV
GLVNM_MEKO
GLVNM_VNCO
GLVUT_SPII
GLZAF_LIMP
GLZAF_ORAN
GLZAF_SASC
GLZAF_SAWC
GLZMB_CONG
GLZMB_ZAMB
GLZWE_AIOC
GLZWE_ASII
GLZWE_LIMP
GLZWE_ZAMB

;


$exit
