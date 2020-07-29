set COUNTRY0=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY0=XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR
#set COUNTRY0=CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR XOC CHN IND XSE XSA

set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
#set YEAR=2020 2030 2040 2050 2060 2070 2080 2090 2100

set scn=SSP2-Baseline SSP2-60 SSP2-45 SSP2-34 SSP2-26 SSP2-19

########
set COUNTRY0=JPN
rem set YEAR=2005
set scn=SSP2_BaU_NoCC
########

for %%A in (%COUNTRY0%) do (
	echo %%A
 	start call LandUseModel3_split1.bat %%A
)
pause

for %%F in (%scn%) do (

	echo %%F
	start call LandUseModel3_all.bat %%F
# 	start call LandUseModel3_merge.bat %%F
# 	start call LandUseModel3_combine.bat %%F
#	start call LandUseModel3_gdx2csv.bat %%F
# 	start call LandUseModel3_gdx2txt.bat %%F

)
pause


