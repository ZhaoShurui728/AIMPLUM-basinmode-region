set num=Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14
#set num=Q1 Q2 Q3 Q4 Q5
#set num=Q6 Q7 Q8 Q9 Q10
#set num=Q11 Q12 Q13 Q14
#set num=S1 S2 S3 S4 S5
#set num=S6 S7 S8 S9 S10
#set num=S11 S12 S13 S14
set num=Q3

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY=XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR
#set COUNTRY=CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR XOC CHN IND XSE XSA

set IAV=NoCC
set YEAR=2010 2020 2030 2040 2050 2060 2070 2080 2090 2100

#for %%C in (%SCE%) do (
#for %%D in (%CLP%) do (
for %%F in (%num%) do (
	echo %%F
	start call LandUseModel2.bat global%%F.bat
)
#))
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
