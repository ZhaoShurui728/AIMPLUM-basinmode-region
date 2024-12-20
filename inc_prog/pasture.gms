*--- Pasture ---
parameter
Planduse_pas
PASarea
ADD_PAS
SF_PAS
SF_PASG(G)
Y_NPROTPASG(G)	fraction  non-protected area = PRM_SEC - protected area - pasture
Y_NPROTPAS	fraction  non-protected area = PRM_SEC - protected area - pasture (for check)
AREA_NPAS	Area of potentail grassland
SF_PAS2
PNBPAS(G)
Y_NPROT(G)	non-protected area = PRM_SEC - protected area
R_ADD_PAS
PASarea_NPROT	pasture area in the grid which has potential area for pasture
SMALL/1.0E-10/
FLAG_YIELD(G)	flag of grid where potential crop yields exist.

;

* STEP1

SF_PAS=1;
FLAG_YIELD(G)$(SUM(L$(LCROPA(L) AND YIELD(L,G)),YIELD(L,G)))=YES;

Planduse_pas=Planduse("%Sy%","GRAZING");
Y_NPROT(G)$((CS(G) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)-protect_wopas(G)>0)=VYL("PRM_SEC",G)-protect_wopas(G);

VYL("PAS",G)$(Y_pre("PAS",G) AND Y_NPROT(G) AND Y_NPROT(G)>=Y_pre("PAS",G))=Y_pre("PAS",G);
VYL("PAS",G)$(Y_pre("PAS",G) AND Y_NPROT(G) AND Y_NPROT(G)<Y_pre("PAS",G))=Y_NPROT(G);
Y_NPROTPASG(G)$(Y_NPROT(G) and Y_NPROT(G) - VYL("PAS",G)>SMALL)=Y_NPROT(G) - VYL("PAS",G);
PASarea_NPROT=SUM(G$(VYL("PAS",G) AND Y_NPROTPASG(G)),VYL("PAS",G)*GA(G));
PASarea=SUM(G$VYL("PAS",G),VYL("PAS",G)*GA(G));

ADD_PAS=Planduse_pas-PASarea;

* if pasture area decreases from previous year, pasture fraction is decreased at the same ratio.
IF(ADD_PAS<0,
VYL("PAS",G)$(Y_pre("PAS",G) AND PASarea)=VYL("PAS",G)*Planduse_pas/PASarea;
)

scalar iter;

IteCounter=0;
*###STEP1
While(((ADD_PAS>0 AND SF_PAS>0)  AND IteCounter<=1000),
Y_NPROTPASG(G)=0;
SF_PASG(G)=0;
SF_PAS=0;
R_ADD_PAS=0;

Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

R_ADD_PAS$PASarea_NPROT=ADD_PAS/PASarea_NPROT;

SF_PASG(G)$(Y_NPROTPASG(G) and VYL("PAS",G))=Y_NPROTPASG(G)/VYL("PAS",G);

SF_PAS=min(R_ADD_PAS,smin(G$(SF_PASG(G)),SF_PASG(G)));

VYL("PAS",G)$(VYL("PAS",G) AND SF_PASG(G)) =VYL("PAS",G)*(1+SF_PAS);

Y_NPROTPASG(G)=0;
Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

PASarea_NPROT=SUM(G$(VYL("PAS",G) AND Y_NPROTPASG(G)),VYL("PAS",G)*GA(G));

PASarea=SUM(G$(VYL("PAS",G)),VYL("PAS",G)*GA(G));

ADD_PAS=Planduse_pas-PASarea;

IteCounter=IteCounter+1;
*display ADD_PAS, SF_PAS;
);
*execute_unload '../output/temp3_step1.gdx'

scalar
BacktoStep1	/0/
;
* STEP2 neighborhood cell
*For(iter=1 to 10,

IteCounter=0;
*###STEP1
While(((ADD_PAS>0 AND BacktoStep1=0)  AND IteCounter<=1000),
PNBPAS(G)=0;
AREA_NPAS=0;
SF_PAS2=0;

* The pasture expands to cell neighbor in order.
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G))=SUM(G2$(VYL("PAS",G2) AND MAP_WG(G,G2)),1);
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G4$(MAP_WG(G,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G5$(MAP_WG(G,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1)));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G6$(MAP_WG(G,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1))));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G7$(MAP_WG(G,G7)),SUM(G6$(MAP_WG(G7,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1)))));
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G8$(MAP_WG(G,G8)),SUM(G7$(MAP_WG(G8,G7)),SUM(G6$(MAP_WG(G7,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1))))));
* if theres is no potential area in neighbor cells, the pasture expands to cell where cropland or settlements exist.
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0 AND (VYL("SL",G) OR VYL("CL",G)))=1;


AREA_NPAS=SUM(G$(PNBPAS(G)),Y_NPROT(G)*GA(G));

SF_PAS2$(AREA_NPAS)= ADD_PAS/AREA_NPAS;

VYL("PAS",G)$(SF_PAS2>0 AND SF_PAS2<=1 AND PNBPAS(G))=Y_NPROT(G)*SF_PAS2;
VYL("PAS",G)$(SF_PAS2>1 AND PNBPAS(G))=Y_NPROT(G);

PASarea=SUM(G$(VYL("PAS",G)),VYL("PAS",G)*GA(G));
ADD_PAS=Planduse_pas-PASarea;

Y_NPROTPAS=SUM(G$(VYL("PRM_SEC",G)-VYL("PAS",G)-protect_wopas(G)>SMALL),VYL("PRM_SEC",G)-VYL("PAS",G)-protect_wopas(G));

* if there is no area left for pasture, pasture expands to protected area with low carbon density.
IF((Y_NPROTPAS=0 and ADD_PAS>0),
BacktoStep1=1;
Y_NPROT(G)$(((CS(G) AND CS(G)<CSB) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)>0)=VYL("PRM_SEC",G);

$ontext
PNBPAS(G)$((NOT VYL("PAS",G)) AND Y_NPROT(G))=1;
AREA_NPAS=SUM(G$(PNBPAS(G)),Y_NPROT(G)*GA(G));
IF((AREA_NPAS=0),
* if there is still no area left, pasture expands to protected area with high carbon density.
Y_NPROT(G)$((CS(G) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)>0)=VYL("PRM_SEC",G);
);
$offtext
);

*display PNBPAS,AREA_NPAS,SF_PAS2,PASarea,ADD_PAS,Y_NPROTPAS;
IteCounter=IteCounter+1;
);



SF_PAS=1;
IteCounter=0;
*###STEP1
While(((ADD_PAS>0 AND SF_PAS>0)  AND IteCounter<=1000),
Y_NPROTPASG(G)=0;
SF_PASG(G)=0;
SF_PAS=0;
R_ADD_PAS=0;

Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

R_ADD_PAS$PASarea_NPROT=ADD_PAS/PASarea_NPROT;

SF_PASG(G)$(Y_NPROTPASG(G) and VYL("PAS",G))=Y_NPROTPASG(G)/VYL("PAS",G);

SF_PAS=min(R_ADD_PAS,smin(G$(SF_PASG(G)),SF_PASG(G)));

VYL("PAS",G)$(VYL("PAS",G) AND SF_PASG(G)) =VYL("PAS",G)*(1+SF_PAS);

Y_NPROTPASG(G)=0;
Y_NPROTPASG(G)$(Y_NPROT(G) and (Y_NPROT(G)-VYL("PAS",G))>SMALL)=Y_NPROT(G) - VYL("PAS",G);

PASarea_NPROT=SUM(G$(VYL("PAS",G) AND Y_NPROTPASG(G)),VYL("PAS",G)*GA(G));

PASarea=SUM(G$(VYL("PAS",G)),VYL("PAS",G)*GA(G));

ADD_PAS=Planduse_pas-PASarea;
IteCounter=IteCounter+1;
*display ADD_PAS, SF_PAS;
);


VYL("FRSGL",G)$(VYL("PRM_SEC",G)-VYL("PAS",G)>=0)=VYL("PRM_SEC",G)-VYL("PAS",G);