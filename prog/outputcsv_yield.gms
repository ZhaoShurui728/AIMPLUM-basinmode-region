file output_yield_%1 /..\output\csv\%SCE%_%CLP%_%IAV%\yield_%1.csv/;
put output_yield_%1;
output_yield_%1.pw=100000;
put " %1", "= "/;
* åãâ ÇÃèoóÕ
Yield_IJ(Y,"%1",I,J)$(Yield_IJ(Y,"%1",I,J)=0)=-999;

loop(Y,
 loop(I,
  loop(J,
    output_yield_%1.nd=7; output_yield_%1.nz=0; output_yield_%1.nr=0; output_yield_%1.nw=15;
    put Yield_IJ(Y,"%1",I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND ORD(Y)=20),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
);
put /;
