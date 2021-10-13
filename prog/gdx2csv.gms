$Setglobal prog_dir ..\AIMPLUM
$setglobal sce SSP3
$setglobal clp BaU
$setglobal iav NoCC
$setglobal lumip off
$setglobal bioyieldcalc off

$setglobal wwfclass opt
$setglobal wwfopt 1
* wwf should be selected from  off, on, opt.
*off)  native classifications.
*on)   wwf classification
*opt)  wwf classification with the following options.

* wwfopt should be selected from  1 to 5.
*OPTIONS
*opt1) wwf classification in numbers as it is
*opt2) all abandonned land that is not restored is re-classified as restored; no change in number of classes in LU netcdfs
*opt3) all abandonned land that is not restored is re-classified as restored but only after 30 years - within these 30 years it remains classified as its original pre-abandonnment land use); no change in number of classes in LU netcdfs
*opt4) same as 2, but with 4 additional LU classes(*) in the netcdfs (with a zero value, because it is restored straight away)
*opt5) same as 3, but with 4 additional LU classes(*) in the netcdfs (with potentially non-zero values)

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
LULC_class/
$include %prog_dir%/individual/BendingTheCurve/LULC_class.set
/
MAP_RIJ(R,I,J)
;
Alias (I,I2),(J,J2),(L,L2,L3,LL),(Y,Y2,Y3);

parameter
FLAG_G(G)		Grid flag
FLAG_IJ(I,J)		Grid flag
Rarea_bio(G)

VY_load(R,Y,L,G)
VY_IJ(Y,L,I,J)
VY_IJmip(Y,Lmip,I,J)
VY_IJwwf(Y,Lwwf,I,J)
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

$gdxin '%prog_dir%/\data\sharepix.gdx'
$load sharepix


VY_IJ(Y,"PRMFRS",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"FRS",I,J)) = VY_IJ(Y,"FRS",I,J) * sharepix("Primary vegetation",I,J);
VY_IJ(Y,"MNGFRS",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"FRS",I,J)) = VY_IJ(Y,"FRS",I,J) * sharepix("Mature and Intermediate secondary vegetation",I,J);
VY_IJ(Y,"PRMFRS",I,J)$(FLAG_IJ(I,J) AND VY_IJ(Y,"FRS",I,J) AND sharepix("Primary vegetation",I,J)+sharepix("Mature and Intermediate secondary vegetation",I,J)=0)=VY_IJ(Y,"FRS",I,J);
VY_IJ(Y,"FRS",I,J)=0;

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
*YND(Y,L,I,J)
ZT(Y,I,J)
;

RSF(Y,L,I,J)=0;
ABD(Y,L,I,J)=0;
XF(Y,L,I,J)=0;

*$ifthen.rsfabd not %wwfopt%==1

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

*$endif.rsfabd


$endif.split
$if %split%==1 $exit

$ifthen.bioyield %bioyieldcalc%==on
$gdxin '../output/gdx/analysis/%SCE%_%CLP%_%IAV%.gdx'
$load YIELD_BIO

YIELD_IJ(Y,"BIO",I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,YIELD_BIO(R,Y,G)));
$batinclude %prog_dir%/prog/outputcsv_yield.gms BIO
$exit
$endif.bioyield


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

$elseif.p %lumip%_%wwfclass%==off_on

VY_IJwwf(Y,Lwwf,I,J)=SUM(L$MAP_WWF(Lwwf,L),VY_IJ(Y,L,I,J));

$batinclude %prog_dir%/prog/outputcsv_wwf.gms cropland_other
$batinclude %prog_dir%/prog/outputcsv_wwf.gms cropland_bioenergySRP
$batinclude %prog_dir%/prog/outputcsv_wwf.gms grassland
$batinclude %prog_dir%/prog/outputcsv_wwf.gms forest_unmanaged
$batinclude %prog_dir%/prog/outputcsv_wwf.gms forest_managed
$batinclude %prog_dir%/prog/outputcsv_wwf.gms restored
$batinclude %prog_dir%/prog/outputcsv_wwf.gms other
$batinclude %prog_dir%/prog/outputcsv_wwf.gms built_up_areas

$elseif.p %lumip%_%wwfclass%==off_opt

set
Lwwfnum/
$if %wwfopt%==1 1*10
$if %wwfopt%==2 1*10
$if %wwfopt%==3 1*10
$if %wwfopt%==4 1*14
$if %wwfopt%==5 1*14
/
MAP_WWFnum(Lwwfnum,L)/
$if %wwfopt%==1 $include %prog_dir%/individual/BendingTheCurve/luwwfnum.map
$if %wwfopt%==2 $include %prog_dir%/individual/BendingTheCurve/luwwfnum.map
$if %wwfopt%==3 $include %prog_dir%/individual/BendingTheCurve/luwwfnum2.map
*--- luwwfnum_org.map is map for restoration land with original land category
$if %wwfopt%==4 $include %prog_dir%/individual/BendingTheCurve/luwwfnum_org.map
$if %wwfopt%==5 $include %prog_dir%/individual/BendingTheCurve/luwwfnum_org.map
/
;
Alias (Lwwfnum,Lwwfnum2);
parameter
VW(Y,L,I,J)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abundance
VU(Y,L,I,J)	Land area of land use category L and year Y where land is restored at the same time as abundance
VY_IJwwfnum(Y,Lwwfnum,I,J)
;

* land category has number 1-10 for opt 1-3 and 1-14 for opt4,5).

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


$if %wwfopt%==1 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VY_IJ(Y,L,I,J));
$if %wwfopt%==2 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J));
$if %wwfopt%==3 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J));
$if %wwfopt%==4 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VU(Y,L,I,J));
$if %wwfopt%==5 VY_IJwwfnum(Y,Lwwfnum,I,J)$(SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J)))=SUM(L$MAP_WWFnum(Lwwfnum,L),VW(Y,L,I,J));

VY_IJwwfnum(Y,Lwwfnum,I,J)=round(VY_IJwwfnum(Y,Lwwfnum,I,J),10);

* put -999 for missing values for both terrestiral and ocean pixels. Then define -999 as NaN when making netCDF files.s
VY_IJwwfnum(Y,Lwwfnum,I,J)$(sum(Lwwfnum2,VY_IJwwfnum(Y,Lwwfnum2,I,J))=0 and VY_IJwwfnum(Y,Lwwfnum,I,J)=0)=-99;
execute_unload '../output/csv/%SCE%_%CLP%_%IAV%_opt%wwfopt%.gdx'
VY_IJwwfnum
;

parameter
plwwfnum/10/
;
$if %wwfopt%==4 plwwfnum=14;
$if %wwfopt%==5 plwwfnum=14;

file output /%prog_dir%\..\output\csv\%SCE%_%CLP%_%IAV%_opt%wwfopt%.csv/;
put output;
output.pw=100000;
put "LC_area_share%wwfopt%", "= "/;
* ���ʂ̏o��

loop(Y,
 loop(Lwwfnum,
  loop(I,
   loop(J,
    output.nd=10; output.nz=0; output.nr=0; output.nw=15;
    put VY_IJwwfnum(Y,Lwwfnum,I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Lwwfnum)=plwwfnum AND ORD(Y)=11),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
 );
);
put /;

* Pixel area
$ifthen.wwfopt not %wwfopt%==1

GAIJ0(I,J)$GAIJ(I,J)=GAIJ(I,J)/1000;
GAIJ0(I,J)$(GAIJ(I,J)=0)=-99;

file output_pixel_area /..\output\csv\pixel_area.csv/;
put output_pixel_area;
output_pixel_area.pw=100000;
put "pixel_area", "= "/;

 loop(I,
  loop(J,
    output_pixel_area.nd=10; output_pixel_area.nz=0; output_pixel_area.nr=0; output_pixel_area.nw=15;
    put GAIJ0(I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
put /;


* Protected area
$ontext

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

$if %CLP%==BaU protectfracIJ(I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)),SUM(R,protectfrac(R,"2010",G)));

file output_protect /..\output\csv\%SCE%_%CLP%_%IAV%_protect.csv/;
put output_protect;
output_protect.pw=100000;
put " protected_pixel_area_share", "= "/;

protectfracLIJ(Y,I,J)$(protectfracLIJ(Y,I,J)=0 AND (NOT FLAG_IJ(I,J)))=-999;

protectfracLIJ(Y,I,J)$(protectfracLIJ(Y,I,J)=0 AND FLAG_IJ(I,J))=0;


loop(Y,
 loop(I,
  loop(J,
    output_protect.nd=10; output_protect.nz=0; output_protect.nr=0; output_protect.nw=15;
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


$endif.wwfopt

$else.p


*$batinclude %prog_dir%/prog/outputcsv.gms FRS
$batinclude %prog_dir%/prog/outputcsv.gms PAS
$batinclude %prog_dir%/prog/outputcsv.gms CL
$batinclude %prog_dir%/prog/outputcsv.gms BIO
$batinclude %prog_dir%/prog/outputcsv.gms SL
$batinclude %prog_dir%/prog/outputcsv.gms OL
$batinclude %prog_dir%/prog/outputcsv.gms GL
$batinclude %prog_dir%/prog/outputcsv.gms PRMFRS
$batinclude %prog_dir%/prog/outputcsv.gms MNGFRS
$batinclude %prog_dir%/prog/outputcsv.gms RES
$batinclude %prog_dir%/prog/outputcsv.gms AFR

$endif.p






$exit









