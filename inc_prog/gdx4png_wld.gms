FLAG_IJ(I,J)$SUM(R,MAP_RIJ(R,I,J))=1;
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/USA/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms USA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XE25/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XE25
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XER/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XER
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/TUR/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms TUR
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XOC/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XOC
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/CHN/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms CHN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/IND/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms IND
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/JPN/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms JPN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XSE/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XSE
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XSA/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XSA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/CAN/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms CAN
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/BRA/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms BRA
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XLM/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XLM
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/CIS/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms CIS
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XME/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XME
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XNF/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XNF
$if exist '%prog_dir%/../output/gdx/%SCE%_%CLP%_%IAV%/XAF/analysis/%Sy%.gdx' $batinclude %prog_dir%/inc_prog/gdxload.gms XAF


