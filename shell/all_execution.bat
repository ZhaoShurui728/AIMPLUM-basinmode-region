set num=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
#set num=2 7 12 14 17
#set num=1 3 4 5 6 8 9 10 11 13 15 16

set SCE=SSP3
set CLP=BaU
set IAV=NoCC
set YEAR=2005 2010 2015 2020 2025 2030 2035 2040 2045 2050 2055 2060 2065 2070 2075 2080 2085 2090 2095 2100


for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%F in (%num%) do (
	echo %%F
 	start call LandUseModel1.bat global%%F.bat
)))
pause

# 1:JPN
# 2:USA
# 3:XE25
# 4:XER
# 5:TUR
# 6:XOC
# 7:CHN
# 8:IND
# 9:XSE
# 10:XSA
# 11:CAN
# 12:BRA
# 13:XLM
# 14:CIS
# 15:XME
# 16:XNF
# 17:XAF
