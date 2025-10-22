
# Set model settings
modelsettings='BTC' # BTC or HPD
# Set versions [default or your specification] 
PRJ='default' # if default, calculate BII with prepared coefficients.(data/coefficients). In other case, this will be the identifer of your settings. 
# directory settings [AIMPLUM/Cluster]
dirSettings='Cluster' # currently, directory settings for KUSC is not implemented.
# Set landuse scenarios
scn=(SSP2_BaU_NoCC_No)
#scn=(SSP2_500C_CACN_DAC_BIOD_No SSP2_500C_CACN_DAC_NoCC_No SSP2_BaU_BIOD_No SSP2_BaU_NoCC_No SSP2_SDGLand_500C_CACN_DAC_BIOD_No SSP2_SDGLand_500C_CACN_DAC_NoCC_No SSP2_SDGLand_BaU_BIOD_No SSP2_SDGLand_BaU_NoCC_No)

# --  if modelsettings is HPD, please check arguments below --
# Set climate condition scenario
Climate_sce="none" # ssp370, ssp126 or none

# Select exection process ---------------------------------------------------------------------------
# Set Data Preparation Process [on/off]
DataPrep=off # Get and process climate data  and process population data, once you run, you don't need to run. 
    process_climdata="off"                   #[on/off] if modelsettings is BTC, not necessary
    process_humanpopdata="off"               #[on/off] if modelsettings is BTC, not necessary
    process_PREDICTSdatabase="off"           #[on/off]
    calculate_biodiversityindex="off"        #[on/off]

# Set Coefs Estimation Process [on/off]
EstCoefs=on
    
# Applying Coefs to Landuse data [on/grid/Regional/off]
PREDICTS_Projection=on
