set num=Q5 Q10 S4 S8
set COUNTRY=JPN USA XE25 XER TUR
#set COUNTRY=XOC CHN IND XSE XSA 
#set COUNTRY=CAN BRA XLM CIS XME XNF XAF

set IAV=NoCC
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100
#set YEAR=2020 2030 2040 2050 2060 2070 2080 2090 2100
#set YEAR=2010

#set num=S10
#set num=Q8
#set COUNTRY=JPN
#set YEAR=2050

for %%A in (%COUNTRY%) do (
	echo %%A
#	start call LandUseModel3_split1.bat 17regions\%%A.bat
)
# pause

for %%F in (%num%) do (
	echo %%F
 	start call LandUseModel3_all.bat global%%F.bat
# 	start call LandUseModel3_biotest.bat global%%F.bat
)
pause


