
$Setglobal prog_dir ..\AIMPLUM
$setglobal sce SSP3
$setglobal clp BaU
$setglobal iav NoCC
$setglobal lumip off
$setglobal bioyieldcalc off
$setglobal wwf on_landcategory

$include %prog_dir%/scenario/socioeconomic/%sce%.gms
$include %prog_dir%/scenario/climate_policy/%clp%.gms
$include %prog_dir%/scenario/IAV/%iav%.gms

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
Y	Year	/2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100/

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
*AFRRES	afforestation or restoration
PRMFRS	primary forest
MNGFRS	managed forest
PROTECT protected area
RES	restoration land that was used for cropland or pasture and set aside for restoration (only from 2020 onwards)
*restoration land with original land category
ABD_CL
ABD_CROP_FLW
ABD_BIO
ABD_PAS
ABD_MNGFRS
ABD_AFR
/

L_USEDTOTAL(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,FRS/
L_UNUSED(L)/SL,OL/
LSUM(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,SL,OL,FRS/

LSUMabsres(L)/PAS,GL,CL,BIO,AFR,CROP_FLW,SL,OL,PRMFRS,MNGFRS,RES,ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR/
LAFR(L)/AFR/
Lused(L)/CL,CROP_FLW,BIO,PAS,MNGFRS,AFR/
Lnat(L)/GL,PRMFRS/
LABD(L)/ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR/
LRES(L)/RES/
NLFRSGL/CL,CROP_FLW,BIO,PAS,MNGFRS,AFR,ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR,SL,OL/
Lmip/
$include %prog_dir%/define/lumip.set
/
MAP_LUMIP(Lmip,L)/
*SL	.	urban
$include %prog_dir%/define/lumip.map

/
Lwwf/
$include %prog_dir%/individual/BendingTheCurve/luwwf.set
/
MAP_WWF(Lwwf,L)/
$include %prog_dir%/individual/BendingTheCurve/luwwf.map
/
Lwwfnum/1*12/
LwwfnumLU(Lwwfnum)/1*7,9*12/
Lwwfnum_8(Lwwfnum)/1*8/
MAP_WWFnum(Lwwfnum,L)/
$include %prog_dir%/individual/BendingTheCurve/luwwfnum.map
/
MAP_WWFnum2(Lwwfnum,L)/
$include %prog_dir%/individual/BendingTheCurve/luwwfnum2.map
/
MAP_WWFnum_org(Lwwfnum,L) map for restoration land with original land category/
$include %prog_dir%/individual/BendingTheCurve/luwwfnum_org.map
/
LULC_class/
$include %prog_dir%/individual/BendingTheCurve/LULC_class.set
/
MAP_RIJ(R,I,J)
;
Alias (I,I2),(J,J2),(L,L2,L3,LL),(Y,Y2,Y3),(Lwwfnum,Lwwfnum2);

parameter
FLAG_G(G)		Grid flag
FLAG_IJ(I,J)		Grid flag
Rarea_bio(G)

VY_load(R,Y,L,G)
VY_IJ(Y,L,I,J)

VY_IJmip(Y,Lmip,I,J)
VY_IJwwf(Y,Lwwf,I,J)
VY_IJwwfnum(Y,Lwwfnum,I,J)
VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)
VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)
VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)
VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)
VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)
YIELD_BIO(R,Y,G)
YIELD_IJ(Y,L,I,J)
VY_loadAFRbaunocc(R,Y,LAFR,G)
VY_IJAFRbaunocc(Y,I,J)
VY_loadAFRbaubiod(R,Y,LAFR,G)
VY_IJAFRbaubiod(Y,I,J)
sharepix(LULC_class,I,J)
VY_IJ_res(Y,L,I,J)
VY_IJ_delay(Y,L,I,J)
GAIJ(I,J)           Grid area of cell I J kha
GAIJ0(I,J)           Grid area of cell I J million ha

;

$gdxin '%prog_dir%/data/data_prep.gdx'
$load Map_GIJ MAP_RIJ GAIJ

FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;

$gdxin '../output/gdx/results/results_%SCE%_%CLP%_%IAV%.gdx'
$load VY_load

VY_IJ(Y,L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,VY_load(R,Y,L,G)));

VY_IJ(Y,L,I,J)$(SUM(LL$(L_USEDTOTAL(LL)),VY_IJ(Y,LL,I,J)) AND NOT L_UNUSED(L))
=VY_IJ(Y,L,I,J)*(1-SUM(LL$(L_UNUSED(LL)),VY_IJ(Y,LL,I,J)))/SUM(LL$(L_USEDTOTAL(LL)),VY_IJ(Y,LL,I,J));

* Sum of pixel shares should be 1.
VY_IJ(Y,"FRS",I,J)$VY_IJ(Y,"FRS",I,J)=1-sum(L$(LSUM(L) and (not sameas(L,"FRS"))),VY_IJ(Y,L,I,J));
VY_IJ(Y,"GL",I,J)$VY_IJ(Y,"GL",I,J)=1-sum(L$(LSUM(L) and (not sameas(L,"GL"))),VY_IJ(Y,L,I,J));


* Forest is devided into managed and unmanaged.

$gdxin '../output/gdx/landmap/sharepix.gdx'
$load sharepix


VY_IJ(Y,"PRMFRS",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"FRS",I,J)) = VY_IJ(Y,"FRS",I,J) * sharepix("Primary vegetation",I,J);
VY_IJ(Y,"MNGFRS",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"FRS",I,J)) = VY_IJ(Y,"FRS",I,J) * sharepix("Mature and Intermediate secondary vegetation",I,J);
VY_IJ(Y,"PRMFRS",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"FRS",I,J) AND sharepix("Primary vegetation",I,J)+sharepix("Mature and Intermediate secondary vegetation",I,J)=0)=VY_IJ(Y,"FRS",I,J);
VY_IJ(Y,"FRS",I,J)=0;

* Afforestation is allocated as afforestatoin and restoration.
*VY_IJ(Y,"AFRRES",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"AFR",I,J))=VY_IJ(Y,"AFR",I,J);

*$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%.gdx'
*$load YIELD_BIO
*YIELD_IJ(Y,"BIO",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,YIELD_BIO(R,Y,G)));

* [BTC] Restored land
set
MAP_Abandoned(L,L)/
CL	.	ABD_CL
CROP_FLW	.	ABD_CROP_FLW
BIO	.	ABD_BIO
PAS	.	ABD_PAS
MNGFRS	.	ABD_MNGFRS
AFR	.	ABD_AFR
/
MAP_AB2RES(L,L)/
ABD_CL	.	RES
ABD_CROP_FLW	.	RES
ABD_BIO	.	RES
ABD_PAS	.	RES
ABD_MNGFRS	.	RES
ABD_AFR	.	RES
/

;

parameter
ordy(Y)
deltaY(Y,L,I,J)	Land area difference of land use category L and year Y from year Y-1
deltaZ(Y,I,J)	Total abundant area increments from year Y-1 to year Y (always positive)
deltaX(Y,L,I,J)	Abandoned area in categories with original land categories
X(Y,L,I,J) 	Abandoned area of land use category i and year t only considering increase of abandoned area
XF(Y,L,I,J) 	Abandoned area of land use category i and year t (final outcome)
Remain(Y,L,I,J)		Land area of land use category i and year t that can be abandoned or restored
RPA(Y,L,Y2,I,J)	Restore potential land area of land use category L and year Y that has been categorized as abandoned (abandoned-crop abandoned-pasture and abandoned-biocrop) from the year Y2
RSP(Y,L,Y2,I,J)	Restored potential land area of land use category i and year Y from the year Y2 but it includes the land that is reused by human activity
RSfrom(Y,L,Y2,I,J)	Restore land area originally categorized as land use category L and year Y from the year Y2
RS(Y,L,Y2,I,J)	Restore land area of land use category L and year Y from the year Y2 (final outcome)
RSF(Y,L,I,J)	Restore land area of land use category L and year Y
ABD(Y,L,I,J)	Abandoned land area of land use category L and year Y
VW(Y,L,I,J)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abundance
VU(Y,L,I,J)	Land area of land use category L and year Y where land is restored at the same time as abundance
*YND(Y,L,I,J)
ZT(Y,I,J)
;

ordy(Y) = 2010 + (ord(Y)-1)*10;

deltaY(Y,L,I,J)$(FLAG_IJ(I,J) and VY_IJ(Y,L,I,J)-VY_IJ(Y-1,L,I,J))=VY_IJ(Y,L,I,J)-VY_IJ(Y-1,L,I,J);

*$ontext
ZT(Y,I,J)=0;
loop(Y$(Y.val>=2020),
	ZT(Y,I,J)=max(0,ZT(Y-1,I,J)+SUM(L$Lnat(L),deltaY(Y,L,I,J)));
);
*$offtext
*ZT(Y,I,J)$(Y.val=2020 )=max(0,SUM(Y2$(Y2.val=2020),SUM(L$Lnat(L),deltaY(Y2,L,I,J))));
*ZT(Y,I,J)$(Y.val>=2030)=max(0,SUM(Y2$(Y2.val<=Y.val and Y2.val>=2030),SUM(L$Lnat(L),deltaY(Y2,L,I,J))));

deltaZ(Y,I,J)$(SUM(L$Lnat(L),deltaY(Y,L,I,J)))=max(0,SUM(L$Lnat(L),deltaY(Y,L,I,J)));
deltaX(Y,L,I,J)$(deltaZ(Y,I,J) and SUM(L3$(Lused(L3) and deltaY(Y,L3,I,J)<0),deltaY(Y,L3,I,J)))=deltaZ(Y,I,J)*sum(L2$(MAP_Abandoned(L2,L) and deltaY(Y,L2,I,J)<0),deltaY(Y,L2,I,J))/SUM(L3$(Lused(L3) and deltaY(Y,L3,I,J)<0),deltaY(Y,L3,I,J));
X(Y,L,I,J)$(FLAG_IJ(I,J))=SUM(Y2$(ordy(Y)>=ordy(Y2)),deltaX(Y2,L,I,J));
*YND(Y,L,I,J)$(FLAG_IJ(I,J))=SUM(Y2$(ordy(Y)>=ordy(Y2)),deltaY(Y2,L,I,J));
*XF(Y,L,I,J)$(sum(L2,X(Y,L2,I,J)))=max(0,X(Y,L,I,J)-max(0,sum(L3$(Lnat(L3) and Y.val>2020),(-1)*deltaY(Y,L3,I,J)))*X(Y,L,I,J)/sum(L2,X(Y,L2,I,J)));
XF(Y,L,I,J)$(sum(L2,X(Y,L2,I,J)))=ZT(Y,I,J)*X(Y,L,I,J)/sum(L2,X(Y,L2,I,J));

Remain(Y,L,I,J)$(XF(Y,L,I,J))=XF(Y,L,I,J);
Loop(Y2$(Y2.val>=2020),
	RPA(Y,L,Y2,I,J)$(ordy(Y)<ordy(Y2)+30 and Y.val>=Y2.val and sum(Y3,Remain(Y3,L,I,J)))=smin(Y3$(ordy(Y3)<ordy(Y2)+30 and Y3.val>=Y2.val),Remain(Y3,L,I,J));
	RSP(Y,L,Y2,I,J)$(ordy(Y)>=ordy(Y2)+30 and Y.val>=Y2.val and sum(Y3,RPA(Y3,L,Y2,I,J)))=min(smin(Y3$(ordy(Y3)<ordy(Y2)+30 and Y3.val>=Y2.val),RPA(Y3,L,Y2,I,J)),Remain(Y,L,I,J));
	RSfrom(Y,L,Y2,I,J)$(ordy(Y)>=ordy(Y2)+30 and Y.val>=Y2.val and RSP(Y,L,Y2,I,J))=RSP(Y,L,Y2,I,J);

	Loop(Y3$(Y3.val>Y2.val+30),
		RSfrom(Y3,L,Y2,I,J)$(RSP(Y3-1,L,Y2,I,J)>0 and RSP(Y3,L,Y2,I,J)>0 and RSP(Y3-1,L,Y2,I,J)<RSP(Y3,L,Y2,I,J))=RSP(Y3-1,L,Y2,I,J);
	);

	RS(Y,L2,Y2,I,J)$(ordy(Y)>=ordy(Y2)+30 and sum(L,RSfrom(Y,L,Y2,I,J))) = sum(L$MAP_AB2RES(L,L2),RSfrom(Y,L,Y2,I,J));
	Remain(Y,L,I,J)$(ordy(Y)>=ordy(Y2)+30  and Y.val>=Y2.val and Remain(Y,L,I,J))=Remain(Y,L,I,J)-RSfrom(Y,L,Y2,I,J)-RPA(Y,L,Y2,I,J);
);

RSF(Y,L,I,J)$(SUM(Y2,RS(Y,L,Y2,I,J)))=SUM(Y2,RS(Y,L,Y2,I,J));
ABD(Y,L,I,J)$(XF(Y,L,I,J)-SUM(Y2,RSFrom(Y,L,Y2,I,J)))=XF(Y,L,I,J)-SUM(Y2,RSFrom(Y,L,Y2,I,J));

parameter
protectfracL(R,G,L)	Protected area fraction (0 to 1) of land category L in each cell G
protectfracLIJ(Y,I,J)	Protected area fraction (0 to 1) of land category L in each cell I J
;
protectfracLIJ(Y,I,J)=0;

$ifthen.protect not %IAV%==NoCC

$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%.gdx'
$load protectfracL

protectfracLIJ(Y,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,protectfracL(R,G,"PRM_SEC")+protectfracL(R,G,"CL")));

$endif.protect

$ifthen.bioyield %bioyieldcalc%==on
$gdxin '../output/gdx/all/analysis_%SCE%_%CLP%_%IAV%.gdx'
$load YIELD_BIO

YIELD_IJ(Y,"BIO",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,YIELD_BIO(R,Y,G)));
$endif.bioyield

$if %CLP%==BaU protectfracIJ(I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,protectfrac(R,"2010",G)));

$endif.split
$if %split%==1 $exit
$ontext
$ifthen.afr not %IAV%==NoCC

$gdxin '../output/gdx/results/results_%SCE%_BaU_NoCC.gdx'
$load VY_loadAFRbaunocc=VY_load
$gdxin '../output/gdx/results/results_%SCE%_BaU_BIOD.gdx'
$load VY_loadAFRbaubiod=VY_load

VY_IJAFRbaunocc(Y,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,VY_loadAFRbaunocc(R,Y,"AFR",G)));
VY_IJAFRbaubiod(Y,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,VY_loadAFRbaubiod(R,Y,"AFR",G)));

VY_IJ(Y,"AFR",I,J)$(VY_IJ(Y,"AFR",I,J)-VY_IJAFRbaubiod(Y,I,J)>0)=VY_IJAFRbaunocc(Y,I,J) + (VY_IJ(Y,"AFR",I,J)-VY_IJAFRbaubiod(Y,I,J));
VY_IJ(Y,"RES",I,J)$(VY_IJAFRbaubiod(Y,I,J)-VY_IJAFRbaunocc(Y,I,J)>0)=VY_IJAFRbaubiod(Y,I,J)-VY_IJAFRbaunocc(Y,I,J);

$else.afr

VY_IJ(Y,"AFR",I,J)$(VY_IJ(Y,"AFR",I,J))=VY_IJ(Y,"AFR",I,J);
VY_IJ(Y,"RES",I,J)=0;

$endif.afr

$offtext


*$batinclude %prog_dir%/prog/outputcsv_yield.gms BIO

$ifthen.p %lumip%==on

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

$elseif.p %wwf%==on

VY_IJwwf(Y,Lwwf,I,J)=SUM(L$MAP_WWF(Lwwf,L),VY_IJ(Y,L,I,J));

$batinclude %prog_dir%/prog/outputcsv_wwf.gms cropland_other
$batinclude %prog_dir%/prog/outputcsv_wwf.gms cropland_bioenergySRP
$batinclude %prog_dir%/prog/outputcsv_wwf.gms grassland
$batinclude %prog_dir%/prog/outputcsv_wwf.gms forest_unmanaged
$batinclude %prog_dir%/prog/outputcsv_wwf.gms forest_managed
$batinclude %prog_dir%/prog/outputcsv_wwf.gms restored
$batinclude %prog_dir%/prog/outputcsv_wwf.gms other
$batinclude %prog_dir%/prog/outputcsv_wwf.gms built_up_areas

$elseif.p %wwf%==on_landcategory

* land category has number 1-8 for opt 1-3 and 1-12 for opt4,5).


*$ifthen %biodivprice%==on

VW(Y,L,I,J)$(VY_IJ(Y,L,I,J))=VY_IJ(Y,L,I,J);
VW(Y,L,I,J)$(LRES(L) and RSF(Y,L,I,J))=RSF(Y,L,I,J);
VW(Y,L,I,J)$(LABD(L) and ABD(Y,L,I,J))=ABD(Y,L,I,J);
VW(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J)>0)=max(0,VY_IJ(Y,L,I,J)-SUM(L2,RSF(Y,L2,I,J))-SUM(L3,ABD(Y,L3,I,J)));
*VW(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J)-deltaZ(Y,I,J))=1-SUM(L2$(LSUMabsres(L2) and not Lnat(L2)),VY_IJ(Y,L2,I,J));

VU(Y,L,I,J)$(VY_IJ(Y,L,I,J))=VY_IJ(Y,L,I,J);
VU(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J) and SUM(L2,XF(Y,L2,I,J)))=max(0,VY_IJ(Y,L,I,J)-SUM(L2,XF(Y,L2,I,J)));
*VU(Y,L,I,J)$(Lnat(L) and VY_IJ(Y,L,I,J)-deltaZ(Y,I,J))=1-SUM(L2$(LSUMabsres(L2) and not Lnat(L2)),VY_IJ(Y,L2,I,J));
VU(Y,L,I,J)$(LRES(L) and SUM(L2,XF(Y,L2,I,J)))=SUM(L2,XF(Y,L2,I,J));

VW(Y,L,I,J)$(VW(Y,L,I,J)<10**(-7) AND VW(Y,L,I,J)>(-1)*10**(-7))=0;
VU(Y,L,I,J)$(VU(Y,L,I,J)<10**(-7) AND VU(Y,L,I,J)>(-1)*10**(-7))=0;

* land category has number 1 to 7.
*VY_IJwwfnum(Y,Lwwfnum,I,J)=SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J));
*VY_IJwwfnum(Y,Lwwfnum,I,J)$(VY_IJwwfnum(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;

VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J));
VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J));
VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum2(Lwwfnum,L),VW(Y,L,I,J)))=SUM(L$MAP_WWFnum2(Lwwfnum,L),VW(Y,L,I,J));
VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum_org(Lwwfnum,L),VU(Y,L,I,J)))=SUM(L$MAP_WWFnum_org(Lwwfnum,L),VU(Y,L,I,J));
VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum_org(Lwwfnum,L),VW(Y,L,I,J)))=SUM(L$MAP_WWFnum_org(Lwwfnum,L),VW(Y,L,I,J));

* put -999 for missing values for both terrestiral and ocean pixels. Then define -999 as NaN when making netCDF files.s
VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt1(Y,Lwwfnum2,I,J))=0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)=0)=-99;
VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt2(Y,Lwwfnum2,I,J))=0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)=0)=-99;
VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt3(Y,Lwwfnum2,I,J))=0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)=0)=-99;
VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt4(Y,Lwwfnum2,I,J))=0 and VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)=0)=-99;
VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt5(Y,Lwwfnum2,I,J))=0 and VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)=0)=-99;

$ontext
VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt1(Y,Lwwfnum2,I,J))>0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;
VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt2(Y,Lwwfnum2,I,J))>0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;
VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt3(Y,Lwwfnum2,I,J))>0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;
VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt4(Y,Lwwfnum2,I,J))>0 and VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;
VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt5(Y,Lwwfnum2,I,J))>0 and VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;


VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt1(Y,Lwwfnum2,I,J))>0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;
VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt2(Y,Lwwfnum2,I,J))>0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;
VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt3(Y,Lwwfnum2,I,J))>0 and Lwwfnum_8(Lwwfnum) AND VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;
VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt4(Y,Lwwfnum2,I,J))>0 and VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;
VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum_opt5(Y,Lwwfnum2,I,J))>0 and VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)=0 AND FLAG_IJ(I,J))=0;
$offtext


VY_IJwwfnum_opt1(Y,Lwwfnum,I,J)=round(VY_IJwwfnum_opt1(Y,Lwwfnum,I,J),8);
VY_IJwwfnum_opt2(Y,Lwwfnum,I,J)=round(VY_IJwwfnum_opt2(Y,Lwwfnum,I,J),8);
VY_IJwwfnum_opt3(Y,Lwwfnum,I,J)=round(VY_IJwwfnum_opt3(Y,Lwwfnum,I,J),8);
VY_IJwwfnum_opt4(Y,Lwwfnum,I,J)=round(VY_IJwwfnum_opt4(Y,Lwwfnum,I,J),8);
VY_IJwwfnum_opt5(Y,Lwwfnum,I,J)=round(VY_IJwwfnum_opt5(Y,Lwwfnum,I,J),8);


*$ontext

file output1 /..\output\csv\%SCE%_%CLP%_%IAV%_opt1.csv/;
put output1;
output1.pw=100000;
put "LC_area_share", "= "/;
* 結果の出力

loop(Y,
 loop(Lwwfnum$Lwwfnum_8(Lwwfnum),
  loop(I,
   loop(J,
    output1.nd=8; output1.nz=0; output1.nr=0; output1.nw=15;
    put VY_IJwwfnum_opt1(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=8 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;

file output2 /..\output\csv\%SCE%_%CLP%_%IAV%_opt2.csv/;
put output2;
output2.pw=100000;
put "LC_area_share", "= "/;
* 結果の出力

loop(Y,
 loop(Lwwfnum$Lwwfnum_8(Lwwfnum),
  loop(I,
   loop(J,
    output2.nd=8; output2.nz=0; output2.nr=0; output2.nw=15;
    put VY_IJwwfnum_opt2(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=8 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;


file output3 /..\output\csv\%SCE%_%CLP%_%IAV%_opt3.csv/;
put output3;
output3.pw=100000;
put "LC_area_share", "= "/;
* 結果の出力

loop(Y,
 loop(Lwwfnum$Lwwfnum_8(Lwwfnum),
  loop(I,
   loop(J,
    output3.nd=8; output3.nz=0; output3.nr=0; output3.nw=15;
    put VY_IJwwfnum_opt3(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=8 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;


file output4 /..\output\csv\%SCE%_%CLP%_%IAV%_opt4.csv/;
put output4;
output4.pw=100000;
put "LC_area_share", "= "/;
* 結果の出力

loop(Y,
 loop(Lwwfnum,
  loop(I,
   loop(J,
    output4.nd=8; output4.nz=0; output4.nr=0; output4.nw=15;
    put VY_IJwwfnum_opt4(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=12 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;


file output5 /..\output\csv\%SCE%_%CLP%_%IAV%_opt5.csv/;
put output5;
output5.pw=100000;
put "LC_area_share", "= "/;
* 結果の出力

loop(Y,
 loop(Lwwfnum,
  loop(I,
   loop(J,
    output5.nd=8; output5.nz=0; output5.nr=0; output5.nw=15;
    put VY_IJwwfnum_opt5(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=12 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;

*$offtext




* Protected area
$ontext

file output_protect /..\output\csv\%SCE%_%CLP%_%IAV%_protect.csv/;
put output_protect;
output_protect.pw=100000;
put " protected_pixel_area_share", "= "/;

protectfracLIJ(Y,I,J)$(protectfracLIJ(Y,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;

protectfracLIJ(Y,I,J)$(protectfracLIJ(Y,I,J)=0 AND FLAG_IJ(I,J))=0;


loop(Y,
 loop(I,
  loop(J,
    output_protect.nd=8; output_protect.nz=0; output_protect.nr=0; output_protect.nw=15;
    put protectfracLIJ(Y,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Y)=10),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
);
put /;
$offtext

* Pixel area


*$ifthen.pa %SCE%_%CLP%_%IAV%=SSP2_BaU_NOBIOD

GAIJ0(I,J)$GAIJ(I,J)=GAIJ(I,J)/1000;
GAIJ0(I,J)$(GAIJ(I,J)=0)=-99;

file output_pixel_area /..\output\csv\pixel_area.csv/;
put output_pixel_area;
output_pixel_area.pw=100000;
put "pixel_area", "= "/;

 loop(I,
  loop(J,
    output_pixel_area.nd=8; output_pixel_area.nz=0; output_pixel_area.nr=0; output_pixel_area.nw=15;
    put GAIJ0(I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
put /;

*$endif.pa

SCALAR
   tor/0.0000001/;

parameter
check_negativeW(Y,L,I,J)
check_negativeU(Y,L,I,J)
check_totalWL(Y,L,I,J)
check_totalUL(Y,L,I,J)
check_totalWL2(Y,I,J)
check_totalUL2(Y,I,J)
check_unmngW(Y,I,J)
check_unmngWL(Y,L,I,J)
check_unmngU(Y,I,J)
check_unmngUL(Y,L,I,J)
check_eq(Y,I,J)
check_unmngW2(Y,I,J)
check_unmngWL2(Y,L,I,J)
check_unmngW3(Y,I,J)
;

check_totalWL(Y,L,I,J)$(LSUMabsres(L) and (SUM(L2$(LSUMabsres(L2)),VW(Y,L2,I,J))>1+tor OR SUM(L2$(LSUMabsres(L2)),VW(Y,L2,I,J))<1-tor))=VW(Y,L,I,J);
check_totalUL(Y,L,I,J)$(LSUMabsres(L) and (SUM(L2$(LSUMabsres(L2)),VU(Y,L2,I,J))>1+tor OR SUM(L2$(LSUMabsres(L2)),VU(Y,L2,I,J))<1-tor))=VU(Y,L,I,J);

check_totalWL2(Y,I,J)$((SUM(L2$(LSUMabsres(L2)),VW(Y,L2,I,J))>1+tor OR SUM(L2$(LSUMabsres(L2)),VW(Y,L2,I,J))<1-tor))=SUM(L2$(LSUMabsres(L2)),VW(Y,L2,I,J));
check_totalUL2(Y,I,J)$((SUM(L2$(LSUMabsres(L2)),VU(Y,L2,I,J))>1+tor OR SUM(L2$(LSUMabsres(L2)),VU(Y,L2,I,J))<1-tor))=SUM(L2$(LSUMabsres(L2)),VU(Y,L2,I,J));

check_negativeW(Y,L,I,J)$(VW(Y,L,I,J)<0)=VW(Y,L,I,J);
check_negativeU(Y,L,I,J)$(VU(Y,L,I,J)<0)=VU(Y,L,I,J);

check_unmngW(Y,I,J)$(y.val>=2020 AND SUM(L$(Lnat(L)),VW(Y,L,I,J))>SUM(L$(Lnat(L)),VW("2010",L,I,J))+tor AND SUM(L$(Lnat(L)),VW("2010",L,I,J)))=SUM(L$(Lnat(L)),VW(Y,L,I,J))/SUM(L$(Lnat(L)),VW("2010",L,I,J));
check_unmngWL(Y,L,I,J)$(y.val>=2020 AND SUM(L2$(Lnat(L2)),VW(Y,L2,I,J))>SUM(L2$(Lnat(L2)),VW("2010",L2,I,J))+tor AND SUM(L2$(Lnat(L2)),VW("2010",L2,I,J)))=VW(Y,L,I,J);
check_unmngU(Y,I,J)$(y.val>=2020 AND SUM(L$(Lnat(L)),VU(Y,L,I,J))>SUM(L$(Lnat(L)),VU("2010",L,I,J))+tor AND SUM(L$(Lnat(L)),VU("2010",L,I,J)))=SUM(L$(Lnat(L)),VU(Y,L,I,J))/SUM(L$(Lnat(L)),VU("2010",L,I,J));
check_unmngUL(Y,L,I,J)$(y.val>=2020 AND SUM(L2$(Lnat(L2)),VU(Y,L2,I,J))>SUM(L2$(Lnat(L2)),VU("2010",L2,I,J))+tor AND SUM(L2$(Lnat(L2)),VU("2010",L2,I,J)))=VU(Y,L,I,J);

*check_eq(Y,I,J)$((SUM(L2$LSUM(L2),VW(Y,L2,I,J))-SUM(L2$LSUM(L2),VU(Y,L2,I,J)))-SUM(L2$(LABD(L2)),VW(Y,L2,I,J)))=(SUM(L2$LSUM(L2),VW(Y,L2,I,J))-SUM(L2$LSUM(L2),VU(Y,L2,I,J)))-SUM(L2$(LRES(L2) OR LABD(L2)),VW(Y,L2,I,J));
check_unmngW2(Y,I,J)$(y.val>=2020 AND SUM(L$(Lnat(L)),VW(Y,L,I,J))>SUM(L$(Lnat(L)),VW(Y-1,L,I,J))+tor AND SUM(L$(Lnat(L)),VW(Y-1,L,I,J)))=SUM(L$(Lnat(L)),VW(Y,L,I,J))/SUM(L$(Lnat(L)),VW(Y-1,L,I,J));
check_unmngWL2(Y,L,I,J)$(y.val>=2020 AND SUM(L2$(Lnat(L2)),VW(Y,L2,I,J))>SUM(L2$(Lnat(L2)),VW(Y-1,L2,I,J))+tor AND SUM(L2$(Lnat(L2)),VW(Y-1,L2,I,J)))=VW(Y,L,I,J);

*check_unmngW3(Y,I,J)$(y.val>=2020 AND SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y,L,I,J))-SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y-1,L,I,J))>+tor AND SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y-1,L,I,J)))=SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y,L,I,J))-SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y-1,L,I,J));
check_unmngW3(Y,I,J)$(y.val>=2020 AND SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y-1,L,I,J)))=SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y,L,I,J))-SUM(L$(LSUMabsres(L) AND (NOT L_UNUSED(L))),VW(Y-1,L,I,J));
check_unmngW3(Y,I,J)$(ABS(check_unmngW3(Y,I,J))<=tor)=0;

SET
opt/opt1*opt5/
;
PARAMETER
VY_IJwwfnum_check(opt,Y,I,J)
VY_IJwwfnum_all(opt,Y,Lwwfnum,I,J)
;
VY_IJwwfnum_all("opt1",Y,Lwwfnum,I,J)=VY_IJwwfnum_opt1(Y,Lwwfnum,I,J);
VY_IJwwfnum_all("opt2",Y,Lwwfnum,I,J)=VY_IJwwfnum_opt2(Y,Lwwfnum,I,J);
VY_IJwwfnum_all("opt3",Y,Lwwfnum,I,J)=VY_IJwwfnum_opt3(Y,Lwwfnum,I,J);
VY_IJwwfnum_all("opt4",Y,Lwwfnum,I,J)=VY_IJwwfnum_opt4(Y,Lwwfnum,I,J);
VY_IJwwfnum_all("opt5",Y,Lwwfnum,I,J)=VY_IJwwfnum_opt5(Y,Lwwfnum,I,J);
VY_IJwwfnum_check(opt,Y,I,J)$(SUM(LwwfnumLU(Lwwfnum),VY_IJwwfnum_all(opt,Y-1,Lwwfnum,I,J)))=SUM(LwwfnumLU(Lwwfnum),VY_IJwwfnum_all(opt,Y,Lwwfnum,I,J)-VY_IJwwfnum_all(opt,Y-1,Lwwfnum,I,J));
VY_IJwwfnum_check(opt,Y,I,J)$(ABS(VY_IJwwfnum_check(opt,Y,I,J))<tor)=0;

$else.p


$batinclude %prog_dir%/prog/outputcsv.gms FRS
$batinclude %prog_dir%/prog/outputcsv.gms PAS
$batinclude %prog_dir%/prog/outputcsv.gms CL
$batinclude %prog_dir%/prog/outputcsv.gms BIO
$batinclude %prog_dir%/prog/outputcsv.gms SL
$batinclude %prog_dir%/prog/outputcsv.gms OL
$batinclude %prog_dir%/prog/outputcsv.gms GL
*$batinclude %prog_dir%/prog/outputcsv.gms RES
$batinclude %prog_dir%/prog/outputcsv.gms PRMFRS
$batinclude %prog_dir%/prog/outputcsv.gms MNGFRS
$batinclude %prog_dir%/prog/outputcsv.gms RES
$batinclude %prog_dir%/prog/outputcsv.gms AFR

$endif.p


*execute_unload '../output/csv/%SCE%_%CLP%_%IAV%.gdx'

execute_unload '../output/csv/check/%SCE%_%CLP%_%IAV%.gdx'
check_negativeW
check_negativeU
check_totalWL
check_totalUL
check_totalWL2
check_totalUL2
check_unmngW
check_unmngWL
check_unmngU
check_unmngUL
check_eq
check_unmngW2
check_unmngWL2
check_unmngW3
VY_IJwwfnum_check;



$exit









