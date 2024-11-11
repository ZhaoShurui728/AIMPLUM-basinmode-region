# Parameter Settings

# Set Simulation Year [ten year step from 2010]
YEAR0=(2010 2020 2030 2040 2050 2060 2070 2080 2090 2100)
# Set Global [on/off]
global=on
# if global=off, the following country code should be assigned
# valid codes: (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
# if you would like to plot multiple regions but from global model, set global "off" and put multiple regional codes into this Country
CountryC=(BRA)
# Set Scenarios
scn=(SSP2_BaU_NoCC_No \
     SSP2_CurPol_NoCC_No \
     SSP2_400C_2025CP_NoCC_No \
     SSP2_1100C_2025CP_NoCC_No \
     SSP2_400C_2025CP-low_NoCC_No \
     SSP2_400C_2025CP-high_NoCC_No \
     SSP3_BaU_NoCC_No \
     SSP5_BaU_NoCC_No \
#     SSP1_400C_2025CP-high_NoCC_No \
     SSP1_400C_2025CP_NoCC_No \
#     SSP1_400C_2025CP-low_NoCC_No \
     )

#scn=(SSP2_BaU_BIOD_No)

# Set CPU Core Threads
CPUthreads=30
# Set Pause Mode [on/off]
pausemode=off
# Set Data Preparation Process [on/off]
DataPrep=off
# Set Base Year Simulation [on/off]
Basesim=off

# Set Future Simulation [on/off]
Futuresim=off
    ## loop level change: [CTY (country), SCN (scenario)]
    Sub_Futuresim_Loop=CTY
    ## switch whether normal scenario core run is carried out or not (normally it should be on) 
    Sub_Futuresim_NormalRun=on
    ## switch whether disaggregation of forest and other natural land is carried out or not (normally it should be on)
    Sub_Futuresim_DisagrrFRS=on
    ## bio supply curve switch
    Sub_Futuresim_Biocurve=on

# Set Scenario Merge [on/off]
ScnMerge=off
    ## option to calculation biomass supply curve
    Sub_ScnMerge_BiocurveSort=off

# Set Merge Results for Each Scenario and Make CSV for Netcdf Files [on/off] (full running excluding base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
MergeResCSV4NC=off
    ## if you would like to make base calculation for this process, then turn on basecsv. This process can be skipped once you run (but needs to be run if you revised the results)
    Sub_MergeResCSV4NC_basecsv=on
    ## if you would like to export lumip type netcdf turn on lumip switch. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
    Sub_MergeResCSV4NC_lumip=off
    ## if you would like to make BTC basis 5 options, then turn on BTC3option. This switch will be also used in :netcdfgen (around 3GB per scenario memory and 5min are taken in this process)
    Sub_MergeResCSV4NC_BTC3option=on
    ## if you would like to make AIMSSPRCP dataformat nc file, turn on ssprcp. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on)
    Sub_MergeResCSV4NC_ssprcp=off
    ## if you would like to make bioenergy potential yield, turn on bioyieldcal. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
    Sub_MergeResCSV4NC_bioyielcal=off
    ## if you would like to make carbon sequestration nc file, turn on carseq. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
    Sub_MergeResCSV4NC_carseq=off

# Set Netcdf Creation [on/off]
netcdfgen=off
    ## name of the project for netcdf file naming (only used for the BTC format)
    Sub_Netcdfgen_projectname=IBS

# Set Making GDX Files for PNG File Creation Default Map [on/off]
gdx4png=off
    ## set year for map visualization.
    YearListFig=(2010 2100)
    ## difference from base year is ploted if this switch on
    Sub_gdx4png_dif=off

PREDICTS=on
    ## Data preparation process. If you want to calculate PREDICTS coefficients, you need to run. Once you run, you can skipp. (default off)
    Sub_PREDICTS_DataPrep=off
    ## If you want to calculate PREDICTS coefficients, turn on the switch below. (default off)
    Sub_PREDICTS_EstCoefs=off
    ## Flag to differenciate result used in file and directory. If 'default', skipped two process before and use coefficients in tools/PREDICTS_biodiversity/data/
    PRJ=default
    ## Flag to differenciate PREDICTSmodelsettings.[BTC/HPD]
    PREDICTSmodelsettings=BTC
    ## Flag of whtere considering climate chagne or not. Only used for HPD PREDICTSmodelsettings. [none/ssp370/ssp126]
    Climate_sce=none

# Set PNG File Creation [on/off]
plot=off

# Set Merge Final Results for All Scenarios [on/off] 
Allmerge=on
