*--- Pasture ---
parameter
Planduse_pas
Y_NPROTPAS	fraction  non-protected area = PRM_SEC - protected area - rangeland - pasture (for check)
PNBPAS(G)  Potential neighborhood cell
Y_NPROT(G)	non-protected area = PRM_SEC - protected area
PASarea_NPROT	pasture area in the grid which has potential area for pasture

FLAG_YIELD(G)	flag of grid where potential crop yields exist.
RANarea total area of rangeland allocated
MNGPASarea_poten total potenrial area of rangeland
MNGPASarea total area of rangeland allocated
ADD_MNGPAS additional area to pasture in previous year or round
ADD_RAN additional area to rangeland in previous year or round

Y_MNGPASG(G) the rest of potential area fraction for managed pasture
SF_PASG(G) potential incrase ratio at grid G
SF_PAS    minimium potential incrase ratio across all managed pasture grids
R_ADD_MNGPAS increase ratio of total managed pasture area
AREA_NPAS total area of Y_NPROT in neighborhood cells
SF_PAS2
;

* STEP0: dividing pasture (PAS) into managed pasture (MNGPAS) and rangeland (RAN) !! Moved to the main code.
*Y_pre("MNGPAS",G)$(Y_pre("PAS",G) and frac_rcp("%Sr%","MNGPAS","%base_year%",G)+frac_rcp("%Sr%","RAN","%base_year%",G)) = Y_pre("PAS",G) * frac_rcp("%Sr%","MNGPAS","%base_year%",G)/(frac_rcp("%Sr%","MNGPAS","%base_year%",G)+frac_rcp("%Sr%","RAN","%base_year%",G));
*Y_pre("RAN",G)$(Y_pre("PAS",G)) = max(0,Y_pre("PAS",G) - Y_pre("MNGPAS",G));


* STEP1 (updated)

SF_PAS=1;
FLAG_YIELD(G)$(SUM(L$(LCROPA(L) AND YIELD(L,G)),YIELD(L,G)))=YES;
Planduse_pas=Planduse("%Sy%","GRAZING");

* Fraction of potential area of rangeland that is allowed to locate in protected area.
VYL("RAN",G)$((CS(G) OR FLAG_YIELD(G) and VYL("PRM_SEC",G)))=min(Y_pre("RAN",G),VYL("PRM_SEC",G));
RANarea=SUM(G$(VYL("RAN",G)),VYL("RAN",G)*GA(G));
* Fraction of potential area of manged pasture that is not allowed to locate in protected area
VYL("MNGPAS",G)$((CS(G) OR FLAG_YIELD(G)) and VYL("PRM_SEC",G))=max(0,min(Y_pre("MNGPAS",G),VYL("PRM_SEC",G)-max(VYL("RAN",G),protect_wopas(G))));
MNGPASarea=SUM(G$(VYL("MNGPAS",G)),VYL("MNGPAS",G)*GA(G));
Y_NPROT(G)$((CS(G) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)-max(VYL("RAN",G),protect_wopas(G))>0)=max(0,VYL("PRM_SEC",G)-max(VYL("RAN",G),protect_wopas(G)));
Y_MNGPASG(G)$(Y_NPROT(G) - VYL("MNGPAS",G)>0)=Y_NPROT(G) - VYL("MNGPAS",G);
MNGPASarea_poten=SUM(G$(Y_MNGPASG(G) and VYL("MNGPAS",G)),VYL("MNGPAS",G)*GA(G));

ADD_RAN=Planduse_pas-RANarea;
ADD_MNGPAS=Planduse_pas-RANarea-MNGPASarea;
*execute_unload '../output/temp_pas_step0.gdx'


* if pasture area is smaller than rangeland area in previous year, rangeland fraction is decreased at the same ratio.
IF(ADD_RAN<=0,
VYL("RAN",G)$(Y_pre("RAN",G) AND RANarea)=VYL("RAN",G)*Planduse_pas/RANarea;
VYL("MNGPAS",G)=0;
)
* if pasture area is larger than rangeland area but smaller than pasure total in previous year, rangeland fraction keep at the same and managed pasture is decreased at the same ratio.
IF(ADD_RAN>0 AND ADD_MNGPAS<=0,
VYL("RAN",G)$(Y_pre("RAN",G))=VYL("RAN",G);
VYL("MNGPAS",G)$(Y_pre("MNGPAS",G) AND MNGPASarea)=VYL("MNGPAS",G)*ADD_RAN/MNGPASarea;
)
*execute_unload '../output/temp_pas_step1.gdx'
scalar iter;

IteCounter=0;

*###STEP2 (updated)
While(((ADD_RAN>0 AND ADD_MNGPAS>0 AND SF_PAS>0)  AND IteCounter<=1000),
Y_MNGPASG(G)=0;
SF_PASG(G)=0;
SF_PAS=0;

Y_MNGPASG(G)$(Y_NPROT(G) - VYL("MNGPAS",G)>0)=Y_NPROT(G) - VYL("MNGPAS",G);

R_ADD_MNGPAS$MNGPASarea_poten=ADD_MNGPAS/MNGPASarea_poten;

SF_PASG(G)$(Y_MNGPASG(G) and VYL("MNGPAS",G))=Y_MNGPASG(G)/VYL("MNGPAS",G);

SF_PAS=min(R_ADD_MNGPAS,smin(G$(SF_PASG(G)),SF_PASG(G)));

*execute_unload '../output/temp_pas_step2-1.gdx'
*;
VYL("MNGPAS",G)$(SF_PASG(G)) =VYL("MNGPAS",G)*(1+SF_PAS);

Y_MNGPASG(G)=0;
Y_MNGPASG(G)$(Y_NPROT(G) - VYL("MNGPAS",G)>0)=Y_NPROT(G) - VYL("MNGPAS",G);

MNGPASarea_poten=SUM(G$(VYL("MNGPAS",G) AND Y_MNGPASG(G)),VYL("MNGPAS",G)*GA(G));

MNGPASarea=SUM(G$(VYL("MNGPAS",G)),VYL("MNGPAS",G)*GA(G));

ADD_MNGPAS=Planduse_pas-RANarea-MNGPASarea;

IteCounter=IteCounter+1;
*display ADD_MNGPAS, SF_PAS;
);
*execute_unload '../output/temp_pas_step2.gdx'

scalar
BacktoStep1	/0/
;

* STEP3 neighborhood cell
*For(iter=1 to 10,

IteCounter=0;
*###STEP3-1
While(((ADD_RAN>0 AND ADD_MNGPAS>0 AND BacktoStep1=0)  AND IteCounter<=1000),
PNBPAS(G)=0;
AREA_NPAS=0;
SF_PAS2=0;
VYL("PAS",G)$(VYL("MNGPAS",G)+VYL("RAN",G))=VYL("MNGPAS",G)+VYL("RAN",G);
* The pasture expands to cell neighbor in order.
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G))=SUM(G2$(VYL("PAS",G2) AND MAP_WG(G,G2)),1);
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G4$(MAP_WG(G,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1));
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G5$(MAP_WG(G,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1)));
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G6$(MAP_WG(G,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1))));
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G7$(MAP_WG(G,G7)),SUM(G6$(MAP_WG(G7,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1)))));
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0)=SUM(G8$(MAP_WG(G,G8)),SUM(G7$(MAP_WG(G8,G7)),SUM(G6$(MAP_WG(G7,G6)),SUM(G5$(MAP_WG(G6,G5)),SUM(G4$(MAP_WG(G5,G4)),SUM(G3$(VYL("PAS",G3) AND MAP_WG(G4,G3)),1))))));
* if theres is no potential area in neighbor cells, the pasture expands to cell where cropland or settlements exist.
PNBPAS(G)$((NOT VYL("MNGPAS",G)) AND Y_NPROT(G) AND SUM(G2$PNBPAS(G2),PNBPAS(G2))=0 AND (VYL("SL",G) OR VYL("CL",G)))=1;

AREA_NPAS=SUM(G$(PNBPAS(G) and Y_NPROT(G)),Y_NPROT(G)*GA(G));

SF_PAS2$(AREA_NPAS)= ADD_MNGPAS/AREA_NPAS;

VYL("MNGPAS",G)$(SF_PAS2>0 AND SF_PAS2<=1 AND PNBPAS(G))=Y_NPROT(G)*SF_PAS2;
VYL("MNGPAS",G)$(SF_PAS2>1 AND PNBPAS(G))=Y_NPROT(G);

MNGPASarea=SUM(G$(VYL("MNGPAS",G)),VYL("MNGPAS",G)*GA(G));
ADD_MNGPAS=Planduse_pas-RANarea-MNGPASarea;

Y_NPROTPAS=SUM(G$(VYL("PRM_SEC",G)-max(VYL("RAN",G),protect_wopas(G))-VYL("MNGPAS",G)>0),VYL("PRM_SEC",G)-max(VYL("RAN",G),protect_wopas(G))-VYL("MNGPAS",G));

* if there is no area left for managed pasture, managed pasture expands to protected area with low carbon density.
IF((Y_NPROTPAS=0 and ADD_MNGPAS>0),
BacktoStep1=1;
Y_NPROT(G)$(((CS(G) AND CS(G)<CSB) OR FLAG_YIELD(G)) AND VYL("PRM_SEC",G)>0)=VYL("PRM_SEC",G);

);

*display PNBPAS,AREA_NPAS,PASarea,ADD_PAS,Y_NPROTPAS;
IteCounter=IteCounter+1;
);

VYL("PAS",G)$(VYL("RAN",G)+VYL("MNGPAS",G))=VYL("RAN",G)+VYL("MNGPAS",G);
VYL("FRSGL",G)$(VYL("PRM_SEC",G)-VYL("PAS",G)>=0)=max(0,VYL("PRM_SEC",G)-VYL("PAS",G));
*execute_unload '../output/temp_pas_step3.gdx'
