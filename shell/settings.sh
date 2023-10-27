# Parameter Settings

# Set Simulation Year [ten year step from 2010]
YEAR0=(2010 2020 2030 2040 2050 2060 2070 2080 2090 2100)
# Set Global [on/off]
global=off
# if global=off, the following country code should be assigned 
# valid codes: (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
# if you would like to plot multiple regions but from global model, set global "off" and put multiple regional codes into this CountryC 
CountryC=(JPN)
# Set Scenarios
## scn=(SSP2_BaU_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC SSP2NoAff_800Cf_CACNup200_NoCC SSP2NoBio_600C_CACNup200_NoCC SSP2_800Cf_CACNup200_NoCC SSP2_BaU_DEMFWR_JPN)
## scn=(SSP2_BaU_NoCC SSP2_BaU_DEMFWR_JPN SSP2_BaU_DEMFWR_USA SSP2_BaU_DEMFWR_XE25 SSP2_BaU_DEMFWR_BRA SSP2_BaU_DEMFWR_CHN SSP2_BaU_DEMFWR_IND SSP2_BaU_DEMFWR_XOC SSP2_BaU_SUP_JPN SSP2_BaU_SUP_USA SSP2_BaU_SUP_XE25 SSP2_BaU_SUP_BRA SSP2_BaU_SUP_CHN SSP2_BaU_SUP_IND SSP2_BaU_SUP_XOC SSP2_BaU_SUP SSP2_BaU_SUP_NonOECD SSP2_BaU_SUP_OECD SSP2_BaU_All SSP2_BaU_DEMFWR SSP2_BaU_DEMFWR_OECD SSP2_BaU_DEMFWR_NonOECD)
scn=(SSP2_BaU_NoCC)
# Set CPU Core Threads
CPUthreads=5
# Set Pause Mode [on/off]
pausemode=on

# Set Data Preparation Process [on/off]
DataPrep=off

# Set Data Preparation Process split2 [on/off]
DataPrep2=off

# Set Base Year Simulation [on/off]
Basesim=on

# Set Future Simulation [on/off]
Futuresim=on
    ## loop level change: [CTY (country), SCN (scenario)]
    Sub_Futuresim_Loop=SCN
    ## switch whether normal scenario core run is carried out or not (normally it should be on) 
    Sub_Futuresim_NormalRun=on
    ## switch whether disaggregation of forest and other natural land is carried out or not (normally it should be on)
    Sub_Futuresim_DisagrrFRS=on
    ## bio supply curve switch
    Sub_Futuresim_Biocurve=off

# Set Scenario Merge [on/off]
ScnMerge=on
    ## option to calculation biomass supply curve
    Sub_ScnMerge_BiocurveSort=off

# Set Merge Results for Each Scenario and Make CSV for Netcdf Files [on/off] (full running excluding base takes around 15 min. Full execution including netcdf file generation would be around 45 min)
MergeResCSV4NC=on
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

# Set Netcdf Creation [on/off]
netcdfgen=on
    ## name of the project for netcdf file naming (only used for the BTC format)
    Sub_Netcdfgen_projectname=BTC

# Set Making GDX Files for PNG File Creation Default Map [on/off]
gdx4png=on
    ## set year for map visualization.
    YearListFig=(2010 2050 2100)
    ## difference from base year is ploted if this switch on
    Sub_gdx4png_dif=on

# Set PNG File Creation [on/off]
plot=on

# Set Merge Final Results for All Scenarios [on/off] 
Allmerge=on
