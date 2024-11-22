set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
set COUNTRY=WLD

for %%A in (%COUNTRY%) do (

   	gams biomass.gms --Sr=%%A  MaxProcDir=100
#   	gams biomass_rcp.gms --Sr=%%A  MaxProcDir=100

#	pause

 )

pause

EXIT
