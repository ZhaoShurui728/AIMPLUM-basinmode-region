*-*-*-*- This program is included by ..\prog\combine.gms
parameter
Area_base%1(L,Sacol)
PBIO%1(Y,G,Scol)
*BIOENE%1(G)
YIELD%1(L,G)
MFA%1     management factor for bio crops in base year
MFB%1     management factor for bio crops (coefficient)
RR%1(G)	the range-rarity map
BIIcoefG%1(L,G)	the Biodiversity Intactness Index (BII) coefficients
sharepix%1(LULC_class,I,J)
;

$gdxin '../output/gdx/base/%1/basedata.gdx'
$load Area_base%1=Area_base
$load YIELD%1=YIELD
$load MFA%1=MFA
$load MFB%1=MFB
$load BIIcoefG%1=BIIcoefG
$load RR%1=RR
$load sharepix%1=sharepix

Area_base("%1",L,Sacol)$(Area_base%1(L,Sacol))=Area_base%1(L,Sacol);
YIELD_load("%1",L,G)$YIELD%1(L,G)=YIELD%1(L,G);
MFA("%1")$MFA%1=MFA%1;
MFB("%1")$MFB%1=MFB%1;
RR(G)$RR%1(G)=RR%1(G);
BIIcoefG(L,G)$BIIcoefG%1(L,G)=BIIcoefG%1(L,G);
sharepix(LULC_class,I,J)$sharepix%1(LULC_class,I,J)=sharepix%1(LULC_class,I,J);








