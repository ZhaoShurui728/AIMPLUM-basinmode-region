*This program aims to adjust base year map by using cross-entropy method

SET
MAP_LLDM2(L,LDM)/
FRSGL	.	PRM_SEC
AFR	.	AFR
PAS	.	PAS
PDRIR	.	PDR
WHTIR	.	WHT
GROIR	.	GRO
OSDIR	.	OSD
C_BIR	.	C_B
OTH_AIR	.	OTH_A
PDRRF	.	PDR
WHTRF	.	WHT
GRORF	.	GRO
OSDRF	.	OSD
C_BRF	.	C_B
OTH_ARF	.	OTH_A
BIO	.	BIO
CROP_FLW	.	CROP_FLW
SL	.	SL
OL	.	OL
/
;
PARAMETER
exclflag(L,G)
epsi/0.00001/
Y_pretmp(L,G)
PLDMtmp(LDM)
;
EQUATIONS
EQCEObj
EQYPRMSEC2
EQLDM2
;
MODEL 
CEBaseAdjModel/
EQCEObj,EQYPRMSEC2,EQLDM2/
;
CEBaseAdjModel.HOLDFIXED   = 1 ;
CEBaseAdjModel.scaleopt=1;

EQCEObj.. VOBJ =E= SUM((L,G)$(Y_pre(L,G) AND (NOT exclflag(L,G))),VY(L,G)*(LOG(VY(L,G)+epsi)-LOG(Y_pre(L,G)+epsi))) ;
EQLDM2(LDM)$(PLDM(LDM) AND (NOT SUM(L$(MAP_LLDM2(L,LDM) AND LFix(L)),1))).. SUM((G,L)$(MAP_LLDM2(L,LDM) AND Y_pre(L,G)),ga(G)*VY(L,G)) =E= PLDM(LDM);
EQYPRMSEC2(G)$(SUM(L$(Y_pre(L,G) AND (NOT exclflag(L,G))),1) AND (NOT Y_pre("SL",G) +Y_pre("OL",G)=SUM((L,LDM)$(PLDM(LDM) AND MAP_LLDM2(L,LDM)),Y_pre(L,G)))).. 
  SUM((L,LDM)$(PLDM(LDM) AND MAP_LLDM2(L,LDM)),VY(L,G)) =E= 1 ;

Y_pretmp(L,G)=Y_pre(L,G);
PLDMtmp(LDM)=PLDM(LDM);
Y_pre("FRSGL",G)=1-SUM(L$LRCPnonNat(L),frac_rcp("%Sr17%",L,"%base_year%",G));
Y_pre("PAS",G)=frac_rcp("%Sr17%","PAS","%base_year%",G);

*---Adjust area of the grid cell which is included in more than one country.
*---Include area of the other countries in OL and scale down area of the other categories.
*Y_pre("OL",G)$(landshare(G))=Y_pre("OL",G)*landshare(G)+(1-landshare(G));
*Y_pre("SL",G)$(Y_pre("SL",G) and landshare(G))=Y_pre("SL",G)*landshare(G);
*---END adjust

VY.SCALE(L,G)$(Y_pre(L,G))=SQRT(ABS(Y_pre(L,G)));
VY.L(L,G)=Y_pre(L,G);
exclflag(L,G)$(LFIX(L) OR Y_pre(L,G)=0 OR (NOT SUM(LDM$(MAP_LLDM2(L,LDM)),1)))=1;
VY.FX(L,G)$(exclflag(L,G))=Y_pre(L,G);
VY.LO(L,G)$(Y_pre(L,G) AND NOT exclflag(L,G))=0;

*Special treatment for ajdustment of total land area
$ifthen.agluout2 not %agluauto%==on
PLDM("PAS")=Planduse("%Sy%","GRAZING");
PLDM("CROP_FLW")=Planduse("%Sy%","CROP_FLW");
$else.agluout2
PLDM("PAS")=Planduse_aglu("%agluscenario%","%Sr%","PAS","%Sy%");
PLDM("CROP_FLW")=Planduse_aglu("%agluscenario%","%Sr%","CROP_FLW","%Sy%");
$endif.agluout2
PLDM("PRM_SEC")=0;
PLDM("PRM_SEC")=SUM(G,ga(G))-SUM(LDM,PLDM(LDM));

*if some land category is missing in CGE results, then cancel (normally crop fallow is expected ) 
Y_pre(L,G)$(SUM(LDM,MAP_LLDM2(L,LDM)) AND SUM(LDM$(PLDM(LDM) AND MAP_LLDM2(L,LDM)),1)=0)=0;

EQLDM.SCALE(LDM)$(PLDM(LDM))=SQRT(ABS(PLDM(LDM)));

parameter aaa;
aaa(LDM)$(PLDM(LDM) AND (NOT SUM(L$(MAP_LLDM2(L,LDM) AND LFix(L)),1)))= 1 ;
Y_pre("OL",G)$(Y_pre("SL",G) +Y_pre("OL",G)=SUM((L,LDM)$(PLDM(LDM) AND MAP_LLDM2(L,LDM)),Y_pre(L,G)))=1-Y_pre("SL",G) ;
PLDM("OL")=SUM(G,Y_pre("OL",G)*ga(G)); 
PLDM("SL")=SUM(G,Y_pre("SL",G)*ga(G)); 
PLDM("PRM_SEC")=SUM(G,ga(G))-(SUM(LDM,PLDM(LDM))-PLDM("PRM_SEC"));

$if %parallel%==off execute_unload '../output/temp.gdx';
$ifthen.noinp %noinput%==off
  SOLVE CEBaseAdjModel using NLP minimizing VOBJ;
  Y_pre(L,G)=VY.L(L,G);
  Y_pre("PRM_SEC",G)=VY.L("FRSGL",G)+VY.L("PAS",G);
$else.noinp
  Y_pre(L,G)=Y_pretmp(L,G);
$endif.noinp

*post process
PLDM(LDM)$((not sameas(LDM,"SL")) and (not sameas(LDM,"OL")))=PLDMtmp(LDM);
VY.SCALE(L,G)=1;
VY.UP(L,G)=+INF;
VY.LO(L,G)=-INF;
VY.L(L,G)=0;
