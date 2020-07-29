set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY=XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR
#set COUNTRY=CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR XOC CHN IND XSE XSA

set IAV=NoCC
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
#set YEAR=2020 2030 2040 2050 2060 2070 2080 2090 2100
#set YEAR=2050


#set COUNTRY=JPN
#set YEAR=2050 2100


set num1=SSP2_BaU_NoCC SSP2_BaU_BIOD2 SSP2_20W_SPA1_BIOD2 SSP1p_BaU_BIOD2
set num2=SSP1p_20W_SPA1_BIOE2 SSP1p_20W_SPA1_BI3G2 SSP1p_20W_SPA1_BIOD2
set num3=SSP1pDEM_BaU_NoCC SSP1pTECHTRADE_BaU_NoCC SSP1pDEM_20W_SPA1_NoCC SSP1pTECHTRADE_20W_SPA1_NoCC
set num4=SSP1pDEM_BaU_BIOD2 SSP1pTECHTRADE_BaU_BIOD2 SSP1pDEM_20W_SPA1_BIOD2
set num5=SSP1pTECHTRADE_20W_SPA1_BIOD2 SSP2_20W_SPA1_BI3G2 SSP2_20W_SPA1_BIOE2

setlocal enabledelayedexpansion

for %%A in (%COUNTRY%) do (
	echo %%A
#	start call LandUseModel3_split1.bat %%A
)
# pause

for %%F in (%num1%) do (
	echo %%F
 	start call LandUseModel4_all.bat %%F.bat
)

for %%F in (%num1%) do (
 	call Loop1k.bat %%F.bat

)

for %%F in (%num2%) do (
	echo %%F
 	start call LandUseModel4_all.bat %%F.bat
)

for %%F in (%num2%) do (
 	call Loop1k.bat %%F.bat

)

for %%F in (%num3%) do (
	echo %%F
 	start call LandUseModel4_all.bat %%F.bat
)

for %%F in (%num3%) do (
 	call Loop1k.bat %%F.bat

)

for %%F in (%num4%) do (
	echo %%F
 	start call LandUseModel4_all.bat %%F.bat
)

for %%F in (%num4%) do (
 	call Loop1k.bat %%F.bat

)

for %%F in (%num5%) do (
	echo %%F
 	start call LandUseModel4_all.bat %%F.bat
)

for %%F in (%num5%) do (
 	call Loop1k.bat %%F.bat

)

EXIT



for %%F in (%num6%) do (
	echo %%F
 	start call LandUseModel4_all.bat %%F.bat
)

for %%F in (%num6%) do (
 	call Loop1k.bat %%F.bat

)

pause


