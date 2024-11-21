
$Setglobal Sr JPN
$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_dir ..\..\..\..\AIMPLUM

set
R	17 regions	/%Sr%/
Y 	year	/ %base_year%*%end_year% /
G	grid number (1 to 360*720)
I	Vertical position	/ 1*360 /
J	Horizontal position	/ 1*720 /
AEZ	/AEZ1*AEZ18/
MAP_GIJ(G,I,J)	Relationship between cell number G and cell position I J
CLIM	climate domain	/tropical, temperate, boreal/
HUMD	humidity	/arid,dryarid,moistarid,subhumid,humid,humidyr/
ECOZ	forest type /
Tro_rainforest	Tropical rainforest
Tro_moistdeciduousforest	Tropical moistdeciduousforest
Tro_dryforest	Tropical dryforest
Tro_shrubland	Tropical shrubland
Tro_mountainsystems	Tropical mountainsystems
Str_humidforest	Subtropical humidforest
Str_dryforest	Subtropical dryforest
Str_steppe	Subtropical steppe
Str_mountainsystems	Subtropical mountainsystems
Temp_oceanicforest	Temperate oceanicforest
Temp_Temperatecontinental	Temperate Temperatecontinental
Temp_mountainsystems	Temperate mountainsystems
Bo_coniferousforest	Boreal coniferousforest
Bo_Borealtundrawoodland	Boreal Borealtundrawoodland
Bo_mountainsystems	Boreal mountainsystems
/
MAP_CLIMAEZ(CLIM,HUMD,AEZ) GTAP definision/
*Latitude		Humidity		AEZ
Tropical	.	Arid	.	AEZ1
Tropical	.	DryArid	.	AEZ2
Tropical	.	MoistArid	.	AEZ3
Tropical	.	Subhumid	.	AEZ4
Tropical	.	Humid	.	AEZ5
Tropical	.	HumidYR	.	AEZ6
Temperate	.	Arid	.	AEZ7
Temperate	.	DryArid	.	AEZ8
Temperate	.	MoistArid	.	AEZ9
Temperate	.	Subhumid	.	AEZ10
Temperate	.	Humid	.	AEZ11
Temperate	.	HumidYR	.	AEZ12
Boreal	.	Arid	.	AEZ13
Boreal	.	DryArid	.	AEZ14
Boreal	.	MoistArid	.	AEZ15
Boreal	.	Subhumid	.	AEZ16
Boreal	.	Humid	.	AEZ17
Boreal	.	HumidYR	.	AEZ18
/
MAP_CLIMECOZ(CLIM,HUMD,ECOZ)/
*Latitude		Humidity		Ecologicalzone
Tropical	.	Arid	.	Tro_shrubland
Tropical	.	DryArid	.	Tro_dryforest
Tropical	.	MoistArid	.	Tro_dryforest
Tropical	.	Subhumid	.	Tro_moistdeciduousforest
Tropical	.	Humid	.	Tro_rainforest
Tropical	.	HumidYR	.	Tro_rainforest
Temperate	.	Arid	.	Temp_Temperatecontinental
Temperate	.	DryArid	.	Temp_Temperatecontinental
Temperate	.	MoistArid	.	Temp_Temperatecontinental
Temperate	.	Subhumid	.	Temp_oceanicforest
Temperate	.	Humid	.	Temp_oceanicforest
Temperate	.	HumidYR	.	Temp_oceanicforest
Boreal	.	Arid	.	Bo_Borealtundrawoodland
Boreal	.	DryArid	.	Bo_mountainsystems
Boreal	.	MoistArid	.	Bo_mountainsystems
Boreal	.	Subhumid	.	Bo_coniferousforest
Boreal	.	Humid	.	Bo_coniferousforest
Boreal	.	HumidYR	.	Bo_coniferousforest
/
MAP_AEZECOZ(AEZ,ECOZ)
Forestage/0,10,20,30,40,50,60,70,80,90,100/
Map_Forestage(Forestage,Forestage)/
10	.	0
20	.	10
30	.	20
40	.	30
50	.	40
60	.	50
70	.	60
80	.	70
90	.	80
100	.	90
/
;

$gdxin '%prog_dir%/define/subG.gdx'
$load G=G_%Sr%

Alias (Y,Y2,Y3),(Forestage,Forestage2);
MAP_AEZECOZ(AEZ,ECOZ)$SUM((CLIM,HUMD)$MAP_CLIMAEZ(CLIM,HUMD,AEZ),MAP_CLIMECOZ(CLIM,HUMD,ECOZ))=YES;

parameter
AGB0(ECOZ)	Above-ground biomass in forest plantations (tonnes d.m. ha-1) (IPCC 2006 Table 4.12)/
Tro_rainforest	150
Tro_moistdeciduousforest	120
Tro_dryforest	60
Tro_shrubland	30
Tro_mountainsystems	90
Str_humidforest	140
Str_dryforest	60
Str_steppe	30
Str_mountainsystems	90
Temp_oceanicforest	160
Temp_Temperatecontinental	100
Temp_mountainsystems	100
Bo_coniferousforest	40
Bo_Borealtundrawoodland	15
Bo_mountainsystems	30
/
;

$gdxin '%prog_dir%/data/data_prep.gdx'
$load Map_GIJ

*--- AEZ map

set
MAP_GAEZ(G,AEZ)
;
parameter
MAPGAEZ0(G)
ordaez(AEZ)
ordy(Y)
;

ordy(Y) = ord(Y) + %base_year% -1;
ordaez(AEZ)=ord(AEZ);

table MAPAEZIJ(I,J)
$offlisting
$ondelim
$include h_axis_title.txt
$include ../data/AEZ_zone_grid.csv
$offdelim
$onlisting
;

MAPGAEZ0(G)=SUM((I,J)$MAP_GIJ(G,I,J),MAPAEZIJ(I,J));
MAP_GAEZ(G,AEZ)$(MAPGAEZ0(G)=ordaez(AEZ))=YES;

*--- parameter estimation of timber yield functions
parameter
AGB(AEZ)	Above-ground biomass in forest plantations (tonne carbon ha-1 = MgC ha-1)
delta(AEZ)	stocking density of forest in AEZ (MgC ha-1)
PCS0(AEZ)       potential biomass stock in AEZ (MgC ha-1)
WCS(AEZ,Forestage)	biomass stock in year Y of forest planed in year Y2 (MgC ha-1)
WCF(AEZ,Forestage)	carbon flow in year Y of forest planed in year Y2	(MgC ha-1 year-1)
PCS(G)		potential biomass stock in grid G (MgC ha-1)
CST(G,Forestage)	biomass stock in year Y of forest planed in year Y2 in grid G (MgC ha-1)
CFT(G,Forestage)	carbon flow in year Y of forest planed in year Y2 in grid G	(MgC ha-1 year-1)
ACF(G)		average carbon flow in grid G	(MgC ha-1 year-1)
MACF		mean value of average carbon flow in each region	(MgC ha-1 year-1)
;

* [tonne dm ha-1] --> [tonne carbon ha-1]
AGB(AEZ)=SUM(ECOZ$MAP_AEZECOZ(AEZ,ECOZ),AGB0(ECOZ))*0.47;

PCS0(AEZ)=AGB(AEZ)*1.3;

delta(AEZ)= PCS0(AEZ) / exp(5.2-30/60);
WCS(AEZ,Forestage)$(Forestage.val) = delta(AEZ) * exp(5.2-30/Forestage.val);

WCF(AEZ,Forestage)=(WCS(AEZ,Forestage)-SUM(Forestage2$Map_Forestage(Forestage,Forestage2),WCS(AEZ,Forestage2)))/10;

PCS(G)=SUM(AEZ$MAP_GAEZ(G,AEZ),PCS0(AEZ));

CST(G,Forestage)=SUM(AEZ$MAP_GAEZ(G,AEZ),WCS(AEZ,Forestage));

CFT(G,Forestage)=SUM(AEZ$MAP_GAEZ(G,AEZ),WCF(AEZ,Forestage));

ACF(G)$(sum(Forestage$(CFT(G,Forestage)),1))=sum(Forestage$(CFT(G,Forestage)),CFT(G,Forestage))/sum(Forestage$(CFT(G,Forestage)),1);

MACF=SUM(G$ACF(G),ACF(G))/SUM(G$ACF(G),1);

execute_unload '../output/biomass%Sr%_aez.gdx'
PCS
CFT
ACF
MAP_GAEZ
MACF
;
