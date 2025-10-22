*-*-*-*- This program is included by ..\prog\data_prep.gms
parameter
GL%1(G,G2)
G_%1(G)
;

GL%1(G,G2)$GL("%1",G,G2)=GL("%1",G,G2);
G_%1(G)$(MAP_RG("%1",G))=Yes;

