$eolcom !!
$Setglobal base_year 2005
$Setglobal end_year 2100
$Setglobal prog_loc ../AIMPLUM
$Setglobal prog_loc
$setglobal SCE SSP2
$setglobal CLP BaU
$setglobal IAV NoCC
$setglobal ModelInt
$if %ModelInt2%==NoValue $setglobal ModelInt
$if not %ModelInt2%==NoValue $setglobal ModelInt %ModelInt2%
$setglobal PREDICTS_exe off
$setglobal Livestockout_exe off
$setglobal WWFlandout_exe off
$setglobal wwfopt 1
$setglobal agmip on
$setglobal Ystep0 10
$setglobal not1stiter off

$if exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/%iav%.gms
$if not exist ../%prog_loc%/scenario/IAV/%iav%.gms $include ../%prog_loc%/scenario/IAV/NoCC.gms
$if %not1stiter%==off $setglobal IAVload %IAV%
$if %not1stiter%==on $setglobal IAVload %preIAV%

set
R	17 regions	/
$include ../%prog_loc%/define/region/region17exclNations.set
$include ../%prog_loc%/define/region/region_iso.set
$include ../%prog_loc%/define/region/region5.set
$include ../%prog_loc%/define/region/region10.set
World,Non-OECD,ASIA2,R2NonOECD,R2OECD
Industrial,Transition,Developing
$    ifthen.agmip %agmip%==on
      OSA
      FSU
      EUR
      MEN
*      SSA
      SEA
      OAS
      ANZ
*      NAM
      OAM
      AME
*      SAS
*      EUU
*      WLD
$  endif.agmip

/
RISO(R)	ISO countries /
$include ../%prog_loc%/define/region/region_iso.set
/
*Y year	/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
Y year	/
$if %end_year%==2100 2005,2010,2020,2030,2040,2050,2060,2070,2080,2090,2100
$if %end_year%==2050 2005,2010,2020,2030,2040,2050
/
L land use type /
PRM_SEC forest + grassland + pasture
FRSGL   forest + grassland
HAV_FRS        production forest
FRS     forest
GL      grassland
AFR     afforestation and reforestation
CL      cropland
CROP_FLW        fallow land
PAS     managed pasture + rangeland
BIO     bio crops
SL      built_up
OL      ice or water
RES	restoration land that was used for cropland or pasture and set aside for restoration

* forest subcategory
PRMFRS	primary natural forest
SECFRS	secoundary natural forest excl AFR
MNGFRS  managed forest excl AFR
UMNFRS  unmanage forest
NRMFRS  naturally regenerating managed forest
PLNFRS  planted forest incl AFR
AGOFRS	agroforestry
AFRS	afforestation
RFRS	reforestation

* grassland subcategory
PRMGL	primary grassland
SECGL	secoundary grassland
MNGPAS	managed pasture
RAN	rangeland

* total
LUC	land use change total


* crop types
PDR     rice
WHT     wheat
GRO     other coarse grain
OSD     oil crops
C_B     sugar crops
OTH_A   other crops

* crop types with irrigation/rainfed
PDRIR   rice irrigated
WHTIR   wheat irrigated
GROIR   other coarse grain irrigated
OSDIR   oil crops irrigated
C_BIR   sugar crops irrigated
OTH_AIR other crops irrigated
PDRRF   rice rainfed
WHTRF   wheat rainfed
GRORF   other coarse grain rainfed
OSDRF   oil crops rainfed
C_BRF   sugar crops rainfed
OTH_ARF other crops rainfed

* Changes in land use
NRFABD	naturally regenerating managed forest on abandoned land
NRGABD	naturally regenerating managed grassland on abandoned land
DEF	deforestion (decrease in forest area FRS from previou year)
DEG	decrease in grassland area GL from previou year
DEFCUM	Cumulative deforestation area
DEGCUM	Cumulative decrease in grassland area GL from previou year
NRFABDCUM	Cumulative naturally regenerating managed forest area on abandoned land
NRGABDCUM	Cumulative naturally regenerating managed grassland on abandoned land

* degreaded soil
CLDEGS	cropland with degraded soil

* original
CLIR    cropland rainged
CLRF	cropland irrigated
ABD	Abandoned land

* BtC
*abondoned land with original land category
ABD_CL
ABD_CROP_FLW
ABD_BIO
ABD_PAS
ABD_MNGFRS
ABD_AFR
ABD_CUM	Cumulative gross abandoned land including restored area
/
AEZ	/AEZ1*AEZ18/
SGHG	/CO2/
C	/AL/
A	/FRS/
SMODEL	/CGE,LUM/
EmitCat	Emissions categories /
"Positive"		Gross positive emissions
"Negative"	Gross negative emissions
"Net"		Net emissions (= Positive - Negative)
"Prev"		Previous version of emissions
/
LCROPIR(L)/PDRIR,WHTIR,GROIR,OSDIR,C_BIR,OTH_AIR/
LCROPRF(L)/PDRRF,WHTRF,GRORF,OSDRF,C_BRF,OTH_ARF/
LABD(L)/ABD_CL,ABD_CROP_FLW,ABD_BIO,ABD_PAS,ABD_MNGFRS,ABD_AFR/
LABDCUM(L)/ABD_CUM/
;
Alias(R,R2),(Y,Y2);

set
MAP_RAGG(R,R2)	/
$include ../%prog_loc%/define/region/region17_agg.map
/
LCGE	land use category in AIMCGE /CROP, PRM_FRS, MNG_FRS, CROP_FLW, GRAZING, GRASS,BIOCROP,URB,OTH/
MAP_LCGE(L,LCGE)/
CL	.	CROP
FRS	.	PRM_FRS
FRS	.	MNG_FRS
CROP_FLW	.	CROP_FLW
PAS	.	GRAZING
GL	.	GRASS
BIO	.	BIOCROP
SL	.	URB
OL	.	OTH
/
V/
"Lan_Cov"	"Land Cover"
"Lan_Cov_Bui_Are"	"Land Cover|Built-Up Area"
"Lan_Cov_Cro"	"Land Cover|Cropland"
"Lan_Cov_Cro_Non_Ene_Cro"
"Lan_Cov_Cro_Irr"	"Land Cover|Cropland|Irrigated"
"Lan_Cov_Cro_Ene_Cro"	"Land Cover|Cropland|Energy Crops"
"Lan_Cov_Cro_Ene_Cro_1st_gen"
"Lan_Cov_Cro_Ene_Cro_2nd_gen"
"Lan_Cov_Cro_Ene_Cro_Irr"	"Land Cover|Cropland|Energy Crops|Irrigated"
"Lan_Cov_Frs"	"Land Cover|Forest"
"Lan_Cov_Frs_Aff_and_Ref"	"Cumulative afforestation + reforestation area"
"Lan_Cov_Frs_Aff"	"Cumulative afforestation area"
"Lan_Cov_Frs_Ref"	"Cumulative reforestation area"
"Lan_Cov_Frs_Frs"
"Lan_Cov_Frs_Frs_Har_Are"
"Lan_Cov_Frs_Man"
"Lan_Cov_Frs_Man_Aff"
"Lan_Cov_Frs_Man_Ref"
"Lan_Cov_Frs_Man_Tim_Pla"
"Lan_Cov_Frs_Nat_Frs"
"Lan_Cov_Frs_Nat_Frs_Prm_Frs"
"Lan_Cov_Frs_Nat_Frs_Sec_Frs"
"Lan_Cov_Frs_Prm_Frs"
"Lan_Cov_Frs_Sec_Frs"
"Lan_Cov_Oth_Ara_Lan"
"Lan_Cov_Oth_Lan"	"Land Cover|Other Land"
"Lan_Cov_Oth_Nat_Lan"
"Lan_Cov_Pst"	"Land Cover|Pasture"
"Lan_Cov_Cro_Cer"	"Land Cover|Cropland|Cereals"
"Lan_Cov_Cro_Ric"
"Lan_Cov_Cro_Whe"
"Lan_Cov_Cro_Coa_gra"
"Lan_Cov_Cro_Oil_See"
"Lan_Cov_Cro_Oil_Cro"	"Land Cover|Cropland|Oil Crops"
"Lan_Cov_Cro_Sug_Cro"	"Land Cover|Cropland|Sugar Crops"
"Lan_Cov_Cro_Oth_Cro"	"Land Cover|Cropland|Other Crops"
"Lan_Cov_Cro_Dou"
"Lan_Cov_Cro_Rai"	"Land Cover|Cropland|Rainfed"
"Lan_Cov_Wat_Eco_Frs"
"Lan_Cov_Wat_Eco_Gla"
"Lan_Cov_Wat_Eco_Lak"
"Lan_Cov_Wat_Eco_Mou"
"Lan_Cov_Wat_Eco_Wet"
"Emi_CO2_Lan_Use_Flo_Pos_Emi"
"Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha"
"Emi_CO2_Lan_Use_Flo_Neg_Seq"
"Emi_CO2_Lan_Use_Flo_Neg_Seq_Aff"
"Emi_CO2_Lan_Use_Flo_Neg_Seq_Man_For"
"Emi_CO2_Lan_Use_Flo_Neg_Seq_Nat_For"
"Emi_CO2_AFO_Lan_Aba_Man_Lan"
"Emi_CO2_AFO_Lan"
"Emi_CO2_AFO_Lan_Frs"
"Car_Seq_Lan_Use_Soi_Car_Man"	"Carbon Sequestration|Land Use|Soil Carbon Management"
"Car_Seq_Lan_Use_Soi_Car_Man_Cro"	"Carbon Sequestration|Land Use|Soil Carbon Management|Cropland"
"Car_Seq_Lan_Use_Soi_Car_Man_Gra"	"Carbon Sequestration|Land Use|Soil Carbon Management|Grassland"
*Variables added in MOEJ-IIASA
"Lan_Cov_Frs_Frs_Old"	"Land Cover|Forest|Forest old"
"Lan_Cov_Frs_Def_Rat"	"Land Cover|Forest|Deforestation rate"
"Lan_Cov_Frs_Def_Cum"	"Land Cover|Forest|Deforestation|Cumulative"
"Lan_Cov_Oth_Nat_Lan_Res_Lan"	"Land Cover|Other Natual Land|Restoration Land"
"Lan_Cov_Frs_Res_Lan"	"Land Cover|Forest|Restoration Land"
"Lan_Cov_Res_Lan"	"Land Cover|Restoration Land"
"Lan_Cov_Abd_Lan"	"Land Cover|Abandoned Land"
"Emi_CO2_AFO_Aff"	"Emissions|CO2|AFOLU|Afforestation"
"Emi_CO2_AFO_Def"	"Emissions|CO2|AFOLU|Deforestation"
"Emi_CO2_AFO_For_Man"	"Emissions|CO2|AFOLU|Forest Management"
"Emi_CO2_AFO_Oth_Luc"	"Emissions|CO2|AFOLU|Other LUC"
* Original
"Lan_Cov_Frs_Agr"	"Land Cover|Agroforestry"
"Liv_Ani_Sto_Num_Rum"	"Livestock animal stock numbers|ruminant"
"Liv_Ani_Sto_Num_Nrm"	"Livestock animal stock numbers|non-ruminant"
"Liv_Ani_Sto_Num_Dry"	"Livestock animal stock numbers|dairy"
"ANNR_herd"	"Total livestock animal numbers including follower herd Absolute number"
"ANNR_prod"	"Livestock numbers for producer animals (for slaughter) Absolute number"
"Car_Rem_Lan_Use"	"Carbon Removal|Land Use"
"Car_Rem_Lan_Use_Agr"	"Carbon Removal|Land Use|Agroforestry"
"Car_Rem_Lan_Use_Bio"	"Carbon Removal|Land Use|Biochar"
"Car_Rem_Lan_Use_Frs_Man"	"Carbon Removal|Land Use|Forest Management"
"Car_Rem_Lan_Use_ReA"	"Carbon Removal|Land Use|ReAfforestation"
"Car_Rem_Lan_Use_ReA_Nat_Frs"	"Carbon Removal|Land Use|ReAfforestation|Natural Forest"
"Car_Rem_Lan_Use_ReA_Pla"	"Carbon Removal|Land Use|ReAfforestation|Plantation"
"Car_Rem_Lan_Use_Soi_Car_Man"	"Carbon Removal|Land Use|Soil Carbon Management"
"Car_Rem_Lan_Use_Soi_Car_Man_Cro"	"Carbon Removal|Land Use|Soil Carbon Management|Cropland"
"Car_Rem_Lan_Use_Soi_Car_Man_Gra"	"Carbon Removal|Land Use|Soil Carbon Management|Grassland"
"Emi_CO2_AFO"	"Emissions|CO2|AFOLU"
"Frs_Are_Cha"	"Forest Area Change"
"Frs_Are_Cha_Def"	"Forest Area Change|Deforestation"
"Frs_Are_Cha_Def_Prm"	"Forest Area Change|Deforestation|Primary"
"Frs_Are_Cha_Def_Sec"	"Forest Area Change|Deforestation|Secondary"
"Frs_Are_Cha_Frs_Exp"	"Forest Area Change|Forest Expansion"
"Frs_Are_Cha_Frs_Exp_Pla"	"Forest Area Change|Forest Expansion|Planted"
"Frs_Are_Cha_Frs_Exp_Pla_Nat"	"Forest Area Change|Forest Expansion|Planted|Natural"
"Frs_Are_Cha_Frs_Exp_Pla_Nat_Oth"	"Forest Area Change|Forest Expansion|Planted|Natural|Other"
"Frs_Are_Cha_Frs_Exp_Pla_Nat_ReA"	"Forest Area Change|Forest Expansion|Planted|Natural|ReAfforestation"
"Frs_Are_Cha_Frs_Exp_Pla_Pla"	"Forest Area Change|Forest Expansion|Planted|Plantation"
"Frs_Are_Cha_Frs_Exp_Pla_Pla_ReA"	"Forest Area Change|Forest Expansion|Planted|Plantation|ReAfforestation"
"Frs_Are_Cha_Frs_Exp_Pla_Pla_Tim"	"Forest Area Change|Forest Expansion|Planted|Plantation|Timber"
"Frs_Are_Cha_Frs_Exp_Pla_Pla_Oth"	"Forest Area Change|Forest Expansion|Planted|Plantation|Other"
"Frs_Are_Cha_Frs_Exp_Sec"	"Forest Area Change|Forest Expansion|Secondary"
"Gro_Emi_CO2_AFO"	"Gross Emissions|CO2|AFOLU"
"Lan_Cov_Cro_Cer_Irr"	"Land Cover|Cropland|Cereals|Irrigated"
"Lan_Cov_Cro_Cer_Rai"	"Land Cover|Cropland|Cereals|Rainfed"
"Lan_Cov_Cro_Ene_Cro_Rai"	"Land Cover|Cropland|Energy Crops|Rainfed"
"Lan_Cov_Cro_Oil_Cro_Irr"	"Land Cover|Cropland|Oil Crops|Irrigated"
"Lan_Cov_Cro_Oil_Cro_Rai"	"Land Cover|Cropland|Oil Crops|Rainfed"
"Lan_Cov_Cro_Oth_Cro_Irr"	"Land Cover|Cropland|Other Crops|Irrigated"
"Lan_Cov_Cro_Oth_Cro_Rai"	"Land Cover|Cropland|Other Crops|Rainfed"
"Lan_Cov_Cro_Sug_Cro_Irr"	"Land Cover|Cropland|Sugar Crops|Irrigated"
"Lan_Cov_Cro_Sug_Cro_Rai"	"Land Cover|Cropland|Sugar Crops|Rainfed"
"Lan_Cov_Frs_Pla"	"Land Cover|Forest|Planted"
"Lan_Cov_Frs_Pla_Nat"	"Land Cover|Forest|Planted|Natural"
"Lan_Cov_Frs_Pla_Nat_Oth"	"Land Cover|Forest|Planted|Natural|Other"
"Lan_Cov_Frs_Pla_Nat_ReA"	"Land Cover|Forest|Planted|Natural|ReAfforestation"
"Lan_Cov_Frs_Pla_Pla"	"Land Cover|Forest|Planted|Plantation"
"Lan_Cov_Frs_Pla_Pla_ReA"	"Land Cover|Forest|Planted|Plantation|ReAfforestation"
"Lan_Cov_Frs_Pla_Pla_Tim"	"Land Cover|Forest|Planted|Plantation|Timber"
"Lan_Cov_Frs_Pla_Pla_Oth"	"Land Cover|Forest|Planted|Plantation|Other"
"Lan_Cov_Frs_Prm"	"Land Cover|Forest|Primary"
"Lan_Cov_Frs_Sec"	"Land Cover|Forest|Secondary"
"Lan_Cov_Oth_Nat"	"Land Cover|Other Natural"
"Lan_Cov_Oth_Nat_Prm_Non"	"Land Cover|Other Natural|Primary Non-Forest"
"Lan_Cov_Oth_Nat_Rec"	"Land Cover|Other Natural|Recovered"
"Lan_Cov_Oth_Nat_Res"	"Land Cover|Other Natural|Restored"
"Ter_Bio_Bio_Int_Ind"	"Terrestrial Biodiversity|Biodiversity Intactness Index"
"Ter_Bio_Bio_Int_Ind_Are_Out_Key_Con_and_Cro_Lan"	"Terrestrial Biodiversity|Biodiversity Intactness Index|Areas Outside Key Conservation and Cropland Landscapes"
"Ter_Bio_Bio_Int_Ind_Bio_Hot"	"Terrestrial Biodiversity|Biodiversity Intactness Index|Biodiversity Hotspots"
"Ter_Bio_Bio_Int_Ind_Cro_Lan"	"Terrestrial Biodiversity|Biodiversity Intactness Index|Cropland Landscapes"
"Ter_Bio_Bio_Int_Ind_Key_Con_Lan"	"Terrestrial Biodiversity|Biodiversity Intactness Index|Key Conservation Landscapes"
"Ter_Bio_Mea_Spe_Abu"	"Terrestrial Biodiversity|Mean Species Abundance"
"Ter_Bio_Mea_Spe_Abu_Pla"	"Terrestrial Biodiversity|Mean Species Abundance|Plants"
"Ter_Bio_Mea_Spe_Abu_Ver"	"Terrestrial Biodiversity|Mean Species Abundance|Vertebrates"
*	"Terrestrial Biodiversity|Shannon Crop Diversity Index"
/


MapAreaIAMPC(L,V)/
$if %WWFlandout_exe%==off	NRFABDCUM	.	Lan_Cov_Abd_Lan
$if %WWFlandout_exe%==off	NRGABDCUM	.	Lan_Cov_Abd_Lan
*AIMPLUM code	.	var with ""
*	.	"Lan_Cov"
SL	.	"Lan_Cov_Bui_Are"
CL	.	"Lan_Cov_Cro"
BIO	.	"Lan_Cov_Cro"
CROP_FLW	.	"Lan_Cov_Cro"
CL	.	"Lan_Cov_Cro_Non_Ene_Cro"
*	.	"Lan_Cov_Cro_Irr"
BIO	.	"Lan_Cov_Cro_Ene_Cro"
*	.	"Lan_Cov_Cro_Ene_Cro_1st_gen"
BIO	.	"Lan_Cov_Cro_Ene_Cro_2nd_gen"
*	.	"Lan_Cov_Cro_Ene_Cro_Irr"
FRS	.	"Lan_Cov_Frs"
AFR	.	"Lan_Cov_Frs"
AFR	.	"Lan_Cov_Frs_Aff_and_Ref"
AFRS	.	"Lan_Cov_Frs_Aff"
RFRS	.	"Lan_Cov_Frs_Ref"
FRS	.	"Lan_Cov_Frs_Frs"
*	.	"Lan_Cov_Frs_Frs_Har_Are"
MNGFRS	.	"Lan_Cov_Frs_Man"
AFRS	.	"Lan_Cov_Frs_Man_Aff"
RFRS	.	"Lan_Cov_Frs_Man_Ref"
*	.	"Lan_Cov_Frs_Man_Tim_Pla"
*	.	"Lan_Cov_Frs_Nat_Frs"
PRMFRS	.	"Lan_Cov_Frs_Nat_Frs_Prm_Frs"
SECFRS	.	"Lan_Cov_Frs_Nat_Frs_Sec_Frs"
PRMFRS	.	"Lan_Cov_Frs_Prm_Frs"
SECFRS	.	"Lan_Cov_Frs_Sec_Frs"
*	.	"Lan_Cov_Oth_Ara_Lan"
OL	.	"Lan_Cov_Oth_Lan"
GL	.	"Lan_Cov_Oth_Nat_Lan"
PAS	.	"Lan_Cov_Pst"
PDRIR	.	"Lan_Cov_Cro_Cer"
WHTIR	.	"Lan_Cov_Cro_Cer"
GROIR	.	"Lan_Cov_Cro_Cer"
PDRRF	.	"Lan_Cov_Cro_Cer"
WHTRF	.	"Lan_Cov_Cro_Cer"
GRORF	.	"Lan_Cov_Cro_Cer"
PDRIR	.	"Lan_Cov_Cro_Ric"
PDRRF	.	"Lan_Cov_Cro_Ric"
WHTIR	.	"Lan_Cov_Cro_Whe"
WHTRF	.	"Lan_Cov_Cro_Whe"
GROIR	.	"Lan_Cov_Cro_Coa_gra"
GRORF	.	"Lan_Cov_Cro_Coa_gra"
OSDIR	.	"Lan_Cov_Cro_Oil_See"
OSDRF	.	"Lan_Cov_Cro_Oil_See"
OSDIR	.	"Lan_Cov_Cro_Oil_Cro"
OSDRF	.	"Lan_Cov_Cro_Oil_Cro"
C_BIR	.	"Lan_Cov_Cro_Sug_Cro"
C_BRF	.	"Lan_Cov_Cro_Sug_Cro"
OTH_AIR	.	"Lan_Cov_Cro_Oth_Cro"
OTH_ARF	.	"Lan_Cov_Cro_Oth_Cro"
*	.	"Lan_Cov_Cro_Dou"
*	.	"Lan_Cov_Cro_Rai"
*	.	"Lan_Cov_Wat_Eco_Frs"
*	.	"Lan_Cov_Wat_Eco_Gla"
*	.	"Lan_Cov_Wat_Eco_Lak"
*	.	"Lan_Cov_Wat_Eco_Mou"
*	.	"Lan_Cov_Wat_Eco_Wet"
*	.	*Variables added in MOEJ-IIASA
*	.	"Lan_Cov_Frs_Frs_Old"
DEF	.	"Lan_Cov_Frs_Def_Rat"
DEFCUM	.	"Lan_Cov_Frs_Def_Cum"
NRGABDCUM	.	"Lan_Cov_Oth_Nat_Lan_Res_Lan"
NRFABDCUM	.	"Lan_Cov_Frs_Res_Lan"
*	.	* Original
AGOFRS	.	"Lan_Cov_Frs_Agr"
PDRIR	.	"Lan_Cov_Cro_Cer_Irr"
WHTIR	.	"Lan_Cov_Cro_Cer_Irr"
GROIR	.	"Lan_Cov_Cro_Cer_Irr"
PDRRF	.	"Lan_Cov_Cro_Cer_Rai"
WHTRF	.	"Lan_Cov_Cro_Cer_Rai"
GRORF	.	"Lan_Cov_Cro_Cer_Rai"
BIO	.	"Lan_Cov_Cro_Cer_Rai"
BIO	.	"Lan_Cov_Cro_Ene_Cro_Rai"
OSDIR	.	"Lan_Cov_Cro_Oil_Cro_Irr"
OSDRF	.	"Lan_Cov_Cro_Oil_Cro_Rai"
OTH_AIR	.	"Lan_Cov_Cro_Oth_Cro_Irr"
OTH_ARF	.	"Lan_Cov_Cro_Oth_Cro_Rai"
C_BIR	.	"Lan_Cov_Cro_Sug_Cro_Irr"
C_BRF	.	"Lan_Cov_Cro_Sug_Cro_Rai"
AFR	.	"Lan_Cov_Frs_Pla_Pla_ReA"
*	.	"Lan_Cov_Frs_Pla_Pla_Tim"
*PLNFRS 	.	"Lan_Cov_Frs_Pla_Pla_Oth"
PRMFRS 	.	"Lan_Cov_Frs_Prm"
NRMFRS	.	"Lan_Cov_Frs_Sec"
GL	.	"Lan_Cov_Oth_Nat"
PRMGL	.	"Lan_Cov_Oth_Nat_Prm_Non"
NRGABDCUM	.	"Lan_Cov_Oth_Nat_Rec"
NRGABDCUM	.	"Lan_Cov_Oth_Nat_Res"

DEF	.	"Frs_Are_Cha_Def"
/


U/"million ha","Mt CO2/yr","million head","%","million ha/yr"/
MapEmisIAMPC(L,V,EmitCat)/
*AIMPLUM code	.	zz	.	EmitCat with zz
*	.	"Emi_CO2_Lan_Use_Flo_Pos_Emi"	.	"Positive"
*	.	"Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha"	.	"Positive"
*	.	"Emi_CO2_Lan_Use_Flo_Neg_Seq"	.	"Negative"
AFR	.	"Emi_CO2_Lan_Use_Flo_Neg_Seq_Aff"	.	"Negative"
MNGFRS	.	"Emi_CO2_Lan_Use_Flo_Neg_Seq_Man_For"	.	"Negative"
NRFABDCUM	.	"Emi_CO2_Lan_Use_Flo_Neg_Seq_Nat_For"	.	"Negative"
NRFABDCUM	.	"Emi_CO2_AFO_Lan_Aba_Man_Lan"	.	"Negative"
*	.	"Emi_CO2_AFO_Lan"	.
FRS	.	"Emi_CO2_AFO_Lan_Frs"	.	"Net"
CROP_FLW	.	"Car_Seq_Lan_Use_Soi_Car_Man"	.	"Negative"
CLDEGS	.	"Car_Seq_Lan_Use_Soi_Car_Man"	.	"Negative"
NRGABDCUM	.	"Car_Seq_Lan_Use_Soi_Car_Man"	.	"Negative"
CROP_FLW	.	"Car_Seq_Lan_Use_Soi_Car_Man_Cro"	.	"Negative"
CLDEGS	.	"Car_Seq_Lan_Use_Soi_Car_Man_Cro"	.	"Negative"
NRGABDCUM	.	"Car_Seq_Lan_Use_Soi_Car_Man_Gra"	.	"Negative"
AFR	.	"Emi_CO2_AFO_Aff"	.	"Negative"
DEF	.	"Emi_CO2_AFO_Def"	.	"Positive"
*MNGFRS	.	"Emi_CO2_AFO_For_Man"	.	"Negative"
CL	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
PAS	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
CROP_FLW	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
GL	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
NRFABDCUM	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
NRGABDCUM	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
DEG	.	"Emi_CO2_AFO_Oth_Luc"	.	"Net"
*	.	"Car_Rem_Lan_Use"	.
AGOFRS	.	"Car_Rem_Lan_Use_Agr"	.	"Negative"
*	.	"Car_Rem_Lan_Use_Bio"	.	"Negative"
*MNGFRS	.	"Car_Rem_Lan_Use_Frs_Man"	.	"Negative"
AFR	      .	"Car_Rem_Lan_Use_ReA"	.	"Negative"
NRFABDCUM	.	"Car_Rem_Lan_Use_ReA"	.	"Negative"
NRFABDCUM	.	"Car_Rem_Lan_Use_ReA_Nat_Frs"	.	"Negative"
AFR	.	"Car_Rem_Lan_Use_ReA_Pla"	.	"Negative"
CROP_FLW	.	"Car_Rem_Lan_Use_Soi_Car_Man"	.	"Negative"
CLDEGS	.	"Car_Rem_Lan_Use_Soi_Car_Man"	.	"Negative"
NRGABDCUM	.	"Car_Rem_Lan_Use_Soi_Car_Man"	.	"Negative"
CROP_FLW	.	"Car_Rem_Lan_Use_Soi_Car_Man_Cro"	.	"Negative"
CLDEGS	.	"Car_Rem_Lan_Use_Soi_Car_Man_Cro"	.	"Negative"
NRGABDCUM	.	"Car_Rem_Lan_Use_Soi_Car_Man_Gra"	.	"Negative"
*	.	"Emi_CO2_AFO"	.
*	.	"Gro_Emi_CO2_AFO"	.	"Positive"

/

Neg_Var(V)/
Car_Seq_Lan_Use_Soi_Car_Man
Car_Seq_Lan_Use_Soi_Car_Man_Cro
Car_Seq_Lan_Use_Soi_Car_Man_Gra
"Car_Rem_Lan_Use"	"Carbon Removal|Land Use"
"Car_Rem_Lan_Use_Agr"	"Carbon Removal|Land Use|Agroforestry"
"Car_Rem_Lan_Use_Bio"	"Carbon Removal|Land Use|Biochar"
"Car_Rem_Lan_Use_Frs_Man"	"Carbon Removal|Land Use|Forest Management"
"Car_Rem_Lan_Use_ReA"	"Carbon Removal|Land Use|ReAfforestation"
"Car_Rem_Lan_Use_ReA_Nat_Frs"	"Carbon Removal|Land Use|ReAfforestation|Natural Forest"
"Car_Rem_Lan_Use_ReA_Pla"	"Carbon Removal|Land Use|ReAfforestation|Plantation"
"Car_Rem_Lan_Use_Soi_Car_Man"	"Carbon Removal|Land Use|Soil Carbon Management"
"Car_Rem_Lan_Use_Soi_Car_Man_Cro"	"Carbon Removal|Land Use|Soil Carbon Management|Cropland"
"Car_Rem_Lan_Use_Soi_Car_Man_Gra"	"Carbon Removal|Land Use|Soil Carbon Management|Grassland"
/
MapAreChaIAMPC(L,V)/
AFR	.       "Frs_Are_Cha_Frs_Exp_Pla_Pla_ReA"
*PLNFRS	.       "Frs_Are_Cha_Frs_Exp_Pla_Pla_Oth"
NRMFRS	.       "Frs_Are_Cha_Frs_Exp_Sec"
/
FAC_Var(V) Annual forest area chagne/
"Frs_Are_Cha"	"Forest Area Change"
"Frs_Are_Cha_Def"	"Forest Area Change|Deforestation"
"Frs_Are_Cha_Def_Prm"	"Forest Area Change|Deforestation|Primary"
"Frs_Are_Cha_Def_Sec"	"Forest Area Change|Deforestation|Secondary"
"Frs_Are_Cha_Frs_Exp"	"Forest Area Change|Forest Expansion"
"Frs_Are_Cha_Frs_Exp_Pla"	"Forest Area Change|Forest Expansion|Planted"
"Frs_Are_Cha_Frs_Exp_Pla_Nat"	"Forest Area Change|Forest Expansion|Planted|Natural"
"Frs_Are_Cha_Frs_Exp_Pla_Nat_Oth"	"Forest Area Change|Forest Expansion|Planted|Natural|Other"
"Frs_Are_Cha_Frs_Exp_Pla_Nat_ReA"	"Forest Area Change|Forest Expansion|Planted|Natural|ReAfforestation"
"Frs_Are_Cha_Frs_Exp_Pla_Pla"	"Forest Area Change|Forest Expansion|Planted|Plantation"
"Frs_Are_Cha_Frs_Exp_Pla_Pla_ReA"	"Forest Area Change|Forest Expansion|Planted|Plantation|ReAfforestation"
"Frs_Are_Cha_Frs_Exp_Pla_Pla_Tim"	"Forest Area Change|Forest Expansion|Planted|Plantation|Timber"
"Frs_Are_Cha_Frs_Exp_Pla_Pla_Oth"	"Forest Area Change|Forest Expansion|Planted|Plantation|Other"
"Frs_Are_Cha_Frs_Exp_Sec"	"Forest Area Change|Forest Expansion|Secondary"
/
MAP_AGGRE(V,V)  Left is aggregation of right/
*upper	.	lower
"Lan_Cov"	.	"Lan_Cov_Bui_Are"
"Lan_Cov"	.	"Lan_Cov_Cro"
"Lan_Cov"	.	"Lan_Cov_Frs"
*"Lan_Cov"	.	"Lan_Cov_Oth_Lan"
"Lan_Cov"	.	"Lan_Cov_Oth_Nat_Lan"
"Lan_Cov"	.	"Lan_Cov_Pst"
"Lan_Cov_Cro_Irr"	.	"Lan_Cov_Cro_Cer_Irr"
"Lan_Cov_Cro_Irr"	.	"Lan_Cov_Cro_Oil_Cro_Irr"
"Lan_Cov_Cro_Irr"	.	"Lan_Cov_Cro_Oth_Cro_Irr"
"Lan_Cov_Cro_Irr"	.	"Lan_Cov_Cro_Sug_Cro_Irr"
"Lan_Cov_Cro_Irr"	.	"Lan_Cov_Cro_Ene_Cro_Irr"
"Lan_Cov_Cro_Rai"	.	"Lan_Cov_Cro_Cer_Rai"
"Lan_Cov_Cro_Rai"	.	"Lan_Cov_Cro_Oil_Cro_Rai"
"Lan_Cov_Cro_Rai"	.	"Lan_Cov_Cro_Oth_Cro_Rai"
"Lan_Cov_Cro_Rai"	.	"Lan_Cov_Cro_Sug_Cro_Rai"
"Lan_Cov_Res_Lan"	.	"Lan_Cov_Oth_Nat_Lan_Res_Lan"
"Lan_Cov_Res_Lan"	.	"Lan_Cov_Frs_Res_Lan"
"Car_Rem_Lan_Use"	.	"Car_Rem_Lan_Use_Agr"
"Car_Rem_Lan_Use"	.	"Car_Rem_Lan_Use_Bio"
"Car_Rem_Lan_Use"	.	"Car_Rem_Lan_Use_Frs_Man"
"Car_Rem_Lan_Use"	.	"Car_Rem_Lan_Use_ReA"
"Car_Rem_Lan_Use"	.	"Car_Rem_Lan_Use_Soi_Car_Man"
"Car_Rem_Lan_Use_ReA"	.	"Car_Rem_Lan_Use_ReA_Nat_Frs"
"Car_Rem_Lan_Use_ReA"	.	"Car_Rem_Lan_Use_ReA_Pla"
"Emi_CO2_AFO"	.	"Emi_CO2_AFO_Lan"
"Frs_Are_Cha"	.	"Frs_Are_Cha_Def"
"Frs_Are_Cha"	.	"Frs_Are_Cha_Frs_Exp"
"Frs_Are_Cha_Def"	.	"Frs_Are_Cha_Def_Prm"
"Frs_Are_Cha_Def"	.	"Frs_Are_Cha_Def_Sec"
"Frs_Are_Cha_Frs_Exp"	.	"Frs_Are_Cha_Frs_Exp_Pla"
"Frs_Are_Cha_Frs_Exp"	.	"Frs_Are_Cha_Frs_Exp_Sec"
"Frs_Are_Cha_Frs_Exp_Pla"	.	"Frs_Are_Cha_Frs_Exp_Pla_Nat"
"Frs_Are_Cha_Frs_Exp_Pla"	.	"Frs_Are_Cha_Frs_Exp_Pla_Pla"
"Frs_Are_Cha_Frs_Exp_Pla_Pla"	.	"Frs_Are_Cha_Frs_Exp_Pla_Pla_ReA"
"Frs_Are_Cha_Frs_Exp_Pla_Pla"	.	"Frs_Are_Cha_Frs_Exp_Pla_Pla_Tim"
"Frs_Are_Cha_Frs_Exp_Pla_Pla"	.	"Frs_Are_Cha_Frs_Exp_Pla_Pla_Oth"
"Frs_Are_Cha_Frs_Exp_Pla_Nat"	.	"Frs_Are_Cha_Frs_Exp_Pla_Nat_Oth"
"Frs_Are_Cha_Frs_Exp_Pla_Nat"	.	"Frs_Are_Cha_Frs_Exp_Pla_Nat_ReA"
"Gro_Emi_CO2_AFO"	.	"Emi_CO2_Lan_Use_Flo_Pos_Emi"
"Lan_Cov_Frs_Pla"	.	"Lan_Cov_Frs_Pla_Nat"
"Lan_Cov_Frs_Pla"	.	"Lan_Cov_Frs_Pla_Pla"
"Lan_Cov_Frs_Pla_Pla"	.	"Lan_Cov_Frs_Pla_Pla_ReA"
"Lan_Cov_Frs_Pla_Pla"	.	"Lan_Cov_Frs_Pla_Pla_Tim"
"Lan_Cov_Frs_Pla_Pla"	.	"Lan_Cov_Frs_Pla_Pla_Oth"
"Lan_Cov_Frs_Nat_Frs"	.	"Lan_Cov_Frs_Nat_Frs_Prm_Frs"
"Lan_Cov_Frs_Nat_Frs"	.	"Lan_Cov_Frs_Nat_Frs_Sec_Frs"
/
ST	/SSOLVE,SMODEL/
SP	/SMCP,SNLP,SLP/
protect_cat	protection area categories/
WDPA_KBA_Wu2019
WildArea_KBA_WDPA_BTC
protect_bs
protect_all
/
;
parameter
Ystep(Y)
Psol_stat(R,Y,ST,SP)                  Solution report
protect_area(R,Y,protect_cat,L)	Regional aggregated protection area (kha)
;
Ystep(Y)=%Ystep0%;
$if %Ystep0%==10 Ystep("2010")=5;

Alias(V,V2);
parameter
GHGL(R,Y,EmitCat,L)	MtCO2 per year in region R
GHGLR(R,Y,EmitCat,L,RISO)		GHG emission of land category L in year Y [MtCO2 per year]
Area_load(R,Y,L)
AreaR(R,Y,L,RISO)	Regional area of land category L in RISO category [kha]
Ter_Bio_BII(R,Y)
;

$gdxin '../output/gdx/results/cbnal_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load Psol_stat protect_area

$gdxin '../output/gdx/analysis/base_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load GHGL GHGLR
$load Area_load=Area AreaR


GHGL(RISO,Y,EmitCat,L)$sum(R,GHGLR(R,Y,EmitCat,L,RISO))=sum(R,GHGLR(R,Y,EmitCat,L,RISO));

Area_load(RISO,Y,L)$sum(R,AreaR(R,Y,L,RISO))=sum(R,AreaR(R,Y,L,RISO));
protect_area(R2,Y,protect_cat,L)=sum(R$MAP_RAGG(R,R2),protect_area(R,Y,protect_cat,L));

*---GHG emissions

parameter
LUCHEM_P(Y,R,AEZ)
LUCHEM_N(Y,R,AEZ)
LUCHEM_P_load(*,Y,R,AEZ)
LUCHEM_N_load(*,Y,R,AEZ)
Planduse(Y,R,LCGE)
Planduse_load(*,Y,R,LCGE)
GHG(R,Y,*,SMODEL)	GHG emission of land category L in year Y [MtCO2 per year]
AREA(R,Y,L,SMODEL)	Regional area of land category L [kha]
IAMCTemp(R,V,U,Y)
IAMCTempwoU(R,V,Y)
AreCha(R,Y,L,SMODEL)	Annual change in area of land category L [kha per year]
;

$gdxin '../%prog_loc%/data/cgeoutput/analysis.gdx'
$load Planduse_load=Planduse
$ontext
$load LUCHEM_P=LUCHEM_P_load
$load LUCHEM_N=LUCHEM_N_load

LUCHEM_P(Y,R2,AEZ)$SUM(R$MAP_RAGG(R,R2),LUCHEM_P("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ))=SUM(R$MAP_RAGG(R,R2),LUCHEM_P_load("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ));
LUCHEM_N(Y,R2,AEZ)$SUM(R$MAP_RAGG(R,R2),LUCHEM_N("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ))=SUM(R$MAP_RAGG(R,R2),LUCHEM_N_load("%SCE%_%CLP%_%IAV%%ModelInt%",Y,R,AEZ));
LUCHEM_P(Y,R,AEZ)=LUCHEM_P(Y,R,AEZ)/10**2;
LUCHEM_N(Y,R,AEZ)=LUCHEM_N(Y,R,AEZ)/10**2;
GHG(R,Y,"Emissions","CGE")=SUM(AEZ,LUCHEM_P(Y,R,AEZ));
GHG(R,Y,"Sink","CGE")=SUM(AEZ,LUCHEM_N(Y,R,AEZ));
$offtext


GHG(R,Y,"Emissions","LUM")=GHGL(R,Y,"Positive","LUC");
GHG(R,Y,"Sink","LUM")=GHGL(R,Y,"Negative","LUC");
GHG(R,Y,"Net_emissions",SMODEL)=GHG(R,Y,"Emissions",SMODEL)+GHG(R,Y,"Sink",SMODEL);

* AREA comparison
Planduse(Y,R,LCGE)=Planduse_load("%SCE%_%CLP%_%IAVload%%ModelInt%",Y,R,LCGE);
AREA(R,Y,L,"CGE")$SUM(LCGE$MAP_LCGE(L,LCGE),Planduse(Y,R,LCGE))=SUM(LCGE$MAP_LCGE(L,LCGE),Planduse(Y,R,LCGE));
AREA(R,Y,L,"LUM")=Area_load(R,Y,L);
AREA(R,Y,"DEFCUM","LUM")=sum(Y2$(%base_year%<=Y2.val AND Y2.val<=Y.val),Area_load(R,Y2,"DEF"));
AREA(R,Y,"DEGCUM","LUM")=sum(Y2$(%base_year%<=Y2.val AND Y2.val<=Y.val),Area_load(R,Y2,"DEG"));

AREA(R2,Y,L,SMODEL)$SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL))=SUM(R$MAP_RAGG(R,R2),AREA(R,Y,L,SMODEL));

AreCha(R,Y,L,SMODEL)$(AREA(R,Y,L,SMODEL) and AREA(R,Y-1,L,SMODEL) and Ystep(Y))=(AREA(R,Y,L,SMODEL)-AREA(R,Y-1,L,SMODEL))/Ystep(Y);

IAMCTemp(R,V,"million ha",Y)$(SUM(L$(MapAreaIAMPC(L,V)),AREA(R,Y,L,"LUM")) and not FAC_Var(V))=SUM(L$(MapAreaIAMPC(L,V)),AREA(R,Y,L,"LUM"))/1000;
IAMCTemp(R,V,"million ha/yr",Y)$(FAC_Var(V) and Ystep(Y))=SUM(L$(MapAreaIAMPC(L,V)),AREA(R,Y,L,"LUM"))/1000/Ystep(Y);

IAMCTemp(R,"Lan_Cov_Frs_Frs_Old","million ha",Y)$(AREA(R,"%base_year%","FRS","LUM"))=(AREA(R,"%base_year%","FRS","LUM")-AREA(R,Y,"DEFCUM","LUM"))/1000;

IAMCTemp(R,V,"million ha/yr",Y)$(SUM(L$(MapAreChaIAMPC(L,V)),AreCha(R,Y,L,"LUM"))>0)=SUM(L$(MapAreChaIAMPC(L,V)),AreCha(R,Y,L,"LUM"))/1000;

IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Pos_Emi","Mt CO2/yr",Y)=GHG(R,Y,"Emissions","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Pos_Emi_Lan_Use_Cha","Mt CO2/yr",Y)=GHG(R,Y,"Emissions","LUM");
IAMCTemp(R,"Emi_CO2_Lan_Use_Flo_Neg_Seq","Mt CO2/yr",Y)=GHG(R,Y,"Sink","LUM");
IAMCTemp(R,"Emi_CO2_AFO_Lan","Mt CO2/yr",Y)=GHG(R,Y,"Net_emissions","LUM");

IAMCTemp(R,V,"Mt CO2/yr",Y)$(sum((EmitCat,L)$MapEmisIAMPC(L,V,EmitCat),GHGL(R,Y,EmitCat,L)))=sum((EmitCat,L)$MapEmisIAMPC(L,V,EmitCat),GHGL(R,Y,EmitCat,L));
IAMCTemp(R,V,"Mt CO2/yr",Y)$(Neg_Var(V))=IAMCTemp(R,V,"Mt CO2/yr",Y)*(-1);


*Aggregation
SCALAR ite
FOR(ite=1 to 6,
IAMCTemp(R,V,U,Y)$(SUM(V2$(MAP_AGGRE(V,V2)),1))=SUM(V2$(MAP_AGGRE(V,V2)),IAMCTemp(R,V2,U,Y));

);



$ifthen.PREDICTS_exe %PREDICTS_exe%==on

table
Ter_Bio_BII(R,Y)
$ondelim
$offlisting
$include ../output/PREDICTS/BII/csv/BII_regionagg_%SCE%_%CLP%_%IAV%%ModelInt%_IAMCTemp.csv
$onlisting
$offdelim
;


IAMCTemp(R,"Ter_Bio_Bio_Int_Ind","%",Y)=Ter_Bio_BII(R,Y)*100;

$endif.PREDICTS_exe



$ifthen.Livestockout_exe %Livestockout_exe%==on
set
Sl Set for types of livestock
C_AGMIP Commodity for agriculture in AgMIP/
$include ../%prog_loc%/individual/Livestock/cagmip.set
/
;
parameter
liv_reg(Sl,Y,R)	number of animals in each regions
liv_reg_a(C_AGMIP,Y,R)	number of animals in each regions
;

$gdxin '../output/gdx/analysis/livdis_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load Sl,liv_reg

set
map_Sl_C_AgMIP(Sl,C_AGMIP)/
cattle_d	.	DRY
cattle_o	.	RUM
buffaloes	.	RUM
sheep	.	RUM
goats	.	RUM
*camels	.	NRM
*horses	.	RUM
*mules	.	RUM
*asses	.	RUM
swines	.	NRM
chickens	.	NRM
ducks	.	NRM
*turkeys	.	NRM
/
V_LIV(V)/
Liv_Ani_Sto_Num_Rum	Livestock animal stock numbers|ruminant
Liv_Ani_Sto_Num_Nrm	Livestock animal stock numbers|non-ruminant
Liv_Ani_Sto_Num_Dry	Livestock animal stock numbers|dairy
ANNR_herd	Total livestock animal numbers including follower herd Absolute number
ANNR_prod	Livestock numbers for producer animals (for slaughter) Absolute number
/
;

liv_reg_a(C_AGMIP,Y,R)=sum(Sl$(map_Sl_C_AgMIP(Sl,C_AGMIP)),liv_reg(Sl,Y,R));

IAMCTemp(R,"Liv_Ani_Sto_Num_Rum","million head",Y)=liv_reg_a("RUM",Y,R)/10**6;
IAMCTemp(R,"Liv_Ani_Sto_Num_Nrm","million head",Y)=liv_reg_a("NRM",Y,R)/10**6;
IAMCTemp(R,"Liv_Ani_Sto_Num_Dry","million head",Y)=liv_reg_a("DRY",Y,R)/10**6;

IAMCTemp(R,"ANNR_herd","million head",Y)=IAMCTemp(R,"Liv_Ani_Sto_Num_Rum","million head",Y)+IAMCTemp(R,"Liv_Ani_Sto_Num_Nrm","million head",Y)+IAMCTemp(R,"Liv_Ani_Sto_Num_Dry","million head",Y);

IAMCTemp(R,V,U,Y)$(V_LIV(V))=SUM(R2$MAP_RAGG(R2,R),IAMCTemp(R2,V,U,Y));

$endif.Livestockout_exe

$ifthen.wwflandout %WWFlandout_exe%==on

parameter
VW_reg(Y,L,R)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance in region R (kha)
VU_reg(Y,L,R)	Land area of land use category L and year Y considering the 30 years delay restored at the same time as abandance in region R (kha)
;

$gdxin '../output/gdx/analysis/restore_%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
$load VW_reg VU_reg


$if not %iav%==BIOD IAMCTemp(R,"Lan_Cov_Res_Lan","million ha",Y)=VW_reg(Y,"RES",R)/1000;
*$if not %iav%==BIOD IAMCTemp(R,"Lan_Cov_Abd_Lan","million ha",Y)=SUM(L$LABD(L),VW_reg(Y,L,R))/1000;

IAMCTemp(R,"Lan_Cov_Abd_Lan","million ha",Y)=VW_reg(Y,"ABD_CUM",R)/1000;

$if %iav%==BIOD IAMCTemp(R,"Lan_Cov_Res_Lan","million ha",Y)=VU_reg(Y,"RES",R)/1000;
*$if %iav%==BIOD IAMCTemp(R,"Lan_Cov_Abd_Lan","million ha",Y)=VU_reg(Y,"RES",R)/1000;




$endif.wwflandout

IAMCTempwoU(R,V,Y)=SUM(U,IAMCTemp(R,V,U,Y));

execute_unload '../output/gdx/comparison/%SCE%_%CLP%_%IAV%%ModelInt%.gdx'
GHG,GHGL,AREA,IAMCTemp,IAMCTempwoU,Psol_stat,protect_area;





