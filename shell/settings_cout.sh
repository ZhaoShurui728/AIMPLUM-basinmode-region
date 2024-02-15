# Parameter Settings

# Set Simulation Year [ten year step from 2010]
YEAR0=(2010 2020 2030 2040 2050 2060 2070 2080 2090 2100)
#YEAR0=(2030)
# Set Global [on/off]
global=on
# if global=off, the following country code should be assigned
# valid codes: (XOC CHN IND XSE XSA CAN BRA XLM CIS XME XNF XAF JPN USA XE25 XER TUR)
# if you would like to plot multiple regions but from global model, set global "off" and put multiple regional codes into this Country
#CountryC=(USA XOC XE25)
CountryC=(JPN)
# Set Scenarios
scn=(SSP2_BaU_NoCC SSP2_600C_CACNup200_All_lancet_affccur)
scn=(SSP2_500C_CACN_FullComb_NoCC)
scn=(SSP2_BaU_NoCC)
#group1
#scn=(SSP2_600C_CACNup200_affccur SSP2_BaU_NoCC SSP2NoBio_600C_CACNup200_affccur SSP2NoBio_600C_CACNup200_affcdiv SSP2NoBio_600C_CACNup200_All_lancet_affccur SSP2NoBio_600C_CACNup200_All_lancet_affcdiv SSP2NoAff_600C_CACNup200_All_lancet SSP2NoAff_600C_CACNup200_NoCC)
#group2
#scn=(SSP2NoBio_600C_CACNup200_affcmax SSP2NoBio_600C_CACNup200_All_lancet_affcmax SSP2_600C_CACNup200_All_lancet_affccur SSP2_600C_CACNup200_affcdiv SSP2_600C_CACNup200_affcmax SSP2_600C_CACNup200_All_lancet_affcdiv SSP2_600C_CACNup200_All_lancet_affcmax)
#group3
#scn=(SSP2_600C_CACNup200_affcact SSP2NoBio_600C_CACNup200_affcact SSP2NoBio_600C_CACNup200_All_lancet_affcact)
#group4
#scn=(SSP2_600C_CACNup200_NoCC SSP2NoBio_600C_CACNup200_All_lancet SSP2NoBio_600C_CACNup200_NoCC)


# Set CPU Core Threads
CPUthreads=5
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
    ## if you would like to make carbon sequestration nc file, turn on carseq. This switch will be also used in :netcdfgen. (basically it does not take time and can be kept on) 
    Sub_MergeResCSV4NC_carseq=off

# Set Netcdf Creation [on/off]
netcdfgen=on
    ## name of the project for netcdf file naming (only used for the BTC format)
    Sub_Netcdfgen_projectname=sdgmip

# Set Making GDX Files for PNG File Creation Default Map [on/off]
gdx4png=off
    ## set year for map visualization.
    YearListFig=(2010 2100)
    ## difference from base year is ploted if this switch on
    Sub_gdx4png_dif=off

# Set PNG File Creation [on/off]
plot=off

# Set Merge Final Results for All Scenarios [on/off] 
Allmerge=off
