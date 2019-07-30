*-*-*-*- This program is included by ..\prog\comparison.gms
parameter
GHG_%1%2(R,Y,PN,SMODEL)
AREA_%1%2(R,Y,L,SMODEL)
;

$gdxin '../output/gdx/all/comparison_%1_%2_NoCC.gdx'
$load GHG_%1%2=GHG AREA_%1%2=AREA

GHG_SSP(R,Y,PN,SMODEL,"%1_%2")$GHG_%1%2(R,Y,PN,SMODEL)=GHG_%1%2(R,Y,PN,SMODEL);
AREA_SSP(R,Y,L,SMODEL,"%1_%2")$AREA_%1%2(R,Y,L,SMODEL)=AREA_%1%2(R,Y,L,SMODEL);
