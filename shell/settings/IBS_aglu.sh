# Parameter Settings

# Set Simulation Year [ten year step from 2010]
YEAR0=(2010 2020 2030 2040 2050 2060 2070 2080 2090 2100)
YEAR1=(2010)
#YEAR0=(2010)
# Set Global [on/off]
global=off
# if global=off, the following country code should be assigned
# valid codes: (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
# if you would like to plot multiple regions but from global model, set global "off" and put multiple regional codes into this Country
#CountryC=(JPN)

# AgLU basin-based run. If basin-based AgLU result is used, then it should be turned on otherwise keep off.
agluauto=on
# If agluauto is on, CountryC should be country_basin code(s). 
CountryC=(JPN_JAPN USA_COLU USA_GFCO USA_GMAN USA_MSMM USA_NACC USA_PACA CHN_AMUR CHN_CHIN CHN_GOBI CHN_HHEE CHN_TARI CHN_YANG)
CountryC=(JPN_JAPN)

# Set Scenarios
scn2=(SSP2_Tech_BaU_NoCC_GEO71 SSP2_Life_BaU_NoCC_GEO71 SSP2_Life_500C_CACN_DAC_NoCC_GEO71 SSP2_Tech_500C_CACN_DAC_NoCC_GEO71)
scn=( SSP2_BaU_NoCC_No)
scn=( SSP2_400C_2020NDC_NoCC_scenarioMIP_global2)

# Set CPU Core Threads
CPUthreads=32
# Set Pause Mode [on/off]
pausemode=off
# Set Data Preparation Process [on/off]
DataPrep=off
# Set Data Preparation 2 Process [on/off]
DataPrep2=off
# Set Base Year Simulation [on/off]
Basesim=on

# Set Future Simulation [on/off]
Futuresim=on
    ## loop level change: [CTY (country), SCN (scenario)]
    Sub_Futuresim_Loop=CTY
    ## switch whether normal scenario core run is carried out or not (normally it should be on) 
    Sub_Futuresim_NormalRun=on
    ## switch whether disaggregation of forest and other natural land is carried out or not (normally it should be on)
    Sub_Futuresim_DisagrrFRS=on
    ## bio supply curve switch
    Sub_Futuresim_Biocurve=off

# Set Scenario Merge [on/off]
ScnMerge=on
    Sub_ScnMerge_Baserun=on
	## Calculate wwf regional restored area [on/off] 
	Sub_ScnMerge_Restorecal=off
	## Calcuate livestock distribution map [on/off]
	Sub_ScnMerge_Livdiscal=off
    ## option to calculation biomass supply curve
    Sub_ScnMerge_BiocurveSort=off
	## Output wwf restored area in IAMC temp [on/off]  (To be on, you need wwf regional restored area with Sub_ScnMerge_Restorecal=on)  
	WWFrestore_iamc=off
	## Set Livestock number output in IAMC temp  [on/off]  (To be on, you need livestock distribution map with Sub_ScnMerge_Livdiscal=on)  
	Livestock_iamc=off

# Set Merge Results for Each Scenario and Make CSV for Netcdf Files [on/off] (full running excluding base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
MergeResCSV4NC=on
    ## if you would like to make base calculation for this process, then turn on basecsv. This process can be skipped once you run (but needs to be run if you revised the results)
    Sub_MergeResCSV4NC_basecsv=on
    ## if you would like to export lumip type netcdf turn on lumip switch. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
    Sub_MergeResCSV4NC_lumip=on
    ## if you would like to make BTC basis 5 options, then turn on BTC3option. This switch will be also used in :netcdfgen (around 3GB per scenario memory and 5min are taken in this process)
    Sub_MergeResCSV4NC_BTC3option=off
    ## if you would like to make AIMSSPRCP dataformat nc file, turn on ssprcp. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
    Sub_MergeResCSV4NC_ssprcp=off
    ## if you would like to make bioenergy potential yield, turn on bioyieldcal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
    Sub_MergeResCSV4NC_bioyielcal=off
    ## if you would like to make carbon sequestration nc file, turn on carseq. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
    Sub_MergeResCSV4NC_carseq=off
    ## if you would like to output livestock distribution map, turn on livdiscal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
    Sub_MergeResCSV4NC_livdiscal=off
# Set Netcdf Creation [on/off]
netcdfgen=on
    ## name of the project for netcdf file naming (only used for the BTC format)
    Sub_Netcdfgen_projectname=BTC

# Set PREDICTS output [on/off]  (If on, calculate BII by PREDICTS. You need AIMPLUM netcdf output with Sub_MergeResCSV4NC_BTC3option=on)  
PREDICTS=off
    ## Data preparation process. If you want to calculate PREDICTS coefficients, you need to run. Once you run, you can skipp. (default off)
    Sub_PREDICTS_DataPrep=on
    ## If you want to calculate PREDICTS coefficients, turn on the switch below. (default off)
    Sub_PREDICTS_EstCoefs=on
    ## Flag to differenciate result used in file and directory. If 'default', skipped two process before and use coefficients in tools/PREDICTS_biodiversity/data/
    PRJ=default
    ## Flag to differenciate modelsettings.[BTC/HPD]
    PREDICTSmodelsettings=BTC
    ## Flag of whtere considering climate chagne or not. Only used for HPD modelsettings. [none/ssp370/ssp126]
    Climate_sce=none

# Set PNG File Creation [on/off]
plot=on
    ## To export lumip landtype images, turn on lumip switch. To turn on, you also need to make netcdrgen with lumip format.
    Sub_Plot_lumip=on
    ## To make BTC images, then turn on BTC switch. To turn on, you also need to make netcdrgen with BTC format.
    Sub_Plot_BTC=off

# Set Merge Final Results for All Scenarios [on/off] 
Allmerge=off
