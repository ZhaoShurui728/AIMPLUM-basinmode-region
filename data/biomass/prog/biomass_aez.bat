#bash insert_linenum.sh
#pause

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY=JPN

for %%A in (%COUNTRY%) do (

	gams biomass_aez.gms --Sr=%%A  MaxProcDir=100

#	pause

 )

pause

EXIT

