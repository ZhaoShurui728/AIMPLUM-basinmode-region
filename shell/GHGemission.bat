mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\exe
cd ..\..\exe

set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF
#set COUNTRY=CIS

set SCE=SSP2
set CLP=BaU
set IAV=NoCC

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
	mkdir ..\output\gdx\%%C_%%D_%%E
	mkdir ..\output\gdx\%%C_%%D_%%E\GHG

	for %%A in (%COUNTRY%) do (

	gams ..\prog\prog\ghg_emission.gms --Sr=%%A --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100

#	pause

 ))))
#pause

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (
gams ..\prog\prog\ghg_combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100
)))

pause

EXIT

