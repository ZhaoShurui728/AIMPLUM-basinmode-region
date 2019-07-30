mkdir ..\..\output
mkdir ..\..\output\gdx
mkdir ..\..\exe
cd ..\..\exe

set SCE=SSP4
set CLP=BaU
set IAV=NoCC
set COUNTRY=JPN USA XE25 XER TUR XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF

for %%C in (%SCE%) do (
for %%D in (%CLP%) do (
for %%E in (%IAV%) do (

	mkdir ..\output\gdx\%%C_%%D_%%E

  for %%A in (%COUNTRY%) do (

	gdxmerge "..\output\gdx\%%C_%%D_%%E\%%A\*.gdx"
	copy merged.gdx ..\output\gdx\%%C_%%D_%%E\cbnal\%%A.gdx
	del merged.gdx

)

gams ..\prog\prog\ghg_combine.gms --SCE=%%C --CLP=%%D --IAV=%%E MaxProcDir=100

)))

EXIT

