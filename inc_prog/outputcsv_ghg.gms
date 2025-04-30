file output_ghg_%1 / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/ghg_%1.csv" /;
put output_ghg_%1;
*output_ghg_%1.pw=100000;
output_ghg_%1.pw=32767;

GHG_IJ(Y,"%1",I,J)$(GHG_IJ(Y,"%1",I,J)=0)=-999;

put " %1", "= "/;
loop(Y,
 loop(I,
  loop(J,
    output_ghg_%1.nd=7; output_ghg_%1.nz=0; output_ghg_%1.nr=0; output_ghg_%1.nw=15;
    put GHG_IJ(Y,"%1",I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND Y.val=2100),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
);
put /;

file output_ghgc_%1 / "../output/csv/%SCE%_%CLP%_%IAV%%ModelInt%/ghgc_%1.csv" /;
put output_ghgc_%1;
*output_ghgc_%1.pw=100000;
output_ghgc_%1.pw=32767;

GHGC_IJ(Y,"%1",I,J)$(GHGC_IJ(Y,"%1",I,J)=0)=-999;

put " %1C", "= "/;
loop(Y,
 loop(I,
  loop(J,
    output_ghgc_%1.nd=7; output_ghgc_%1.nz=0; output_ghgc_%1.nr=0; output_ghgc_%1.nw=15;
    put GHGC_IJ(Y,"%1",I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND Y.val=2100),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
);
put /;
