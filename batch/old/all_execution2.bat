#set num=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
#set num=1 2 3 4 5 6 7 8 9 10 11 12 13 15 16
set num=2 11

set SCE=SSP3
set CLP=BaU

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%F in (%num%) do (
	echo %%F
	start call LandUseModel2.bat global%%F.bat %%C %%D
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
