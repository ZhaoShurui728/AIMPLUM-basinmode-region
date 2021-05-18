set COUNTRY0=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY0=XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR
#set COUNTRY0=CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR XOC CHN IND XSE XSA

set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
#set YEAR=2020 2030 2040 2050 2060 2070 2080 2090 2100

####### for test run
rem set COUNTRY0=JPN
rem set YEAR=2005
rem set scn=SSP2_BaU_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC
rem set scn=SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC
rem set scn=SSP2NoAff_800Cf_CACNup200_NoCC
set scn=SSP2_BaU_NoCC
########

for %%A in (%COUNTRY0%) do (
	echo %%A
 	start call LandUseModel3_split1.bat %%A
)
pause

for %%F in (%scn%) do (

	echo %%F
######  Land allocation calculation
	start call LandUseModel3_all.bat %%F

######  To creat NetCDF file of land use map, run LandUseModel3_gdx2csv.bat and a bat file (shell/csv2nc.bat)
#	start call LandUseModel3_gdx2csv.bat %%F

######  To creat PNG file of land use map using R, run LandUseModel3_gdx2txt.bat and a R code (R/prog/plot_all.R)
# 	start call LandUseModel3_gdx2txt.bat %%F

######  Just to merge and conbine results
# 	start call LandUseModel3_merge.bat %%F
######  Just to conbine results
# 	start call LandUseModel3_combine.bat %%F

)
pause


