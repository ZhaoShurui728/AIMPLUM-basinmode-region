file output_%1 /..\output\csv\%SCE%_%CLP%_%IAV%\%1.csv/;
put output_%1;
output_%1.pw=100000;
put " %1", "= "/;
* ���ʂ̏o��
VY_IJmip(Y,"%1",I,J)$(VY_IJmip(Y,"%1",I,J)=0)=-999;

loop(Y,
 loop(I,
  loop(J,
    output_%1.nd=7; output_%1.nz=0; output_%1.nr=0; output_%1.nw=15;
    put VY_IJmip(Y,"%1",I,J);
    IF( NOT (ORD(J)=720 AND ORD(I)=360 AND Y.val=2100),put ",";
    ELSE put ";";
    );
   );
 put /;
 );
);
put /;
