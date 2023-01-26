$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/analysis/%Sy%.gdx'
$load VY_load
$if %supcuv%==on $load Rarea_bio
$if %supcuv%==on VY_load("BIOP",G)$Rarea_bio(G)=Rarea_bio(G);

FLAG_IJ(I,J)$MAP_RIJ("%Sr%",I,J)=1;


$ifthen %Sy%==%base_year%

$gdxin '../output/gdx/base/%Sr%/basedata.gdx'
$load Yield Y_base

Yield_IJ(L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)), YIELD(L,G))  + (-0.00001)$(SUM(G,YIELD(L,G)) AND SUM(G$(MAP_GIJ(G,I,J)), YIELD(L,G))=0);
Ybase_IJ(L,I,J)$FLAG_IJ(I,J)=SUM(G$(MAP_GIJ(G,I,J)), Y_base(L,G))  + (-0.00001)$(SUM(G,Y_base(L,G)) AND SUM(G$(MAP_GIJ(G,I,J)), Y_base(L,G))=0);

file resultsall4 / "../output/txt/%SCE%_%CLP%_%IAV%/%Sr%/yield.txt" /;
resultsall4.pc=6;
put resultsall4;
loop((L,I,J)$(Yield_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,Yield_IJ(L,I,J):10:5/
);

file resultsall5 / "../output/txt/%SCE%_%CLP%_%IAV%/%Sr%/ybase.txt" /;
resultsall5.pc=6;
put resultsall5;
loop((L,I,J)$(Ybase_IJ(L,I,J)),
     put L.tl,I.tl,J.tl,Ybase_IJ(L,I,J):10:5/
);

$endif

$ifthen.dif %dif%==on
$ifthen.b not %Sy%==2005
$gdxin '../output/gdx/%SCE%_%CLP%_%IAV%/%Sr%/analysis/%base_year%.gdx'
$load VY_1=VY_load
$endif.b
$endif.dif
