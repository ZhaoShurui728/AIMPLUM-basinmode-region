
# PREDICTS
Shell script and R code for PREDICTS. 
[What is PREDICTS?](https://www.nhm.ac.uk/our-science/research/projects/predicts.html)

<br />

## System requirement
### Application
-	R (http://www.r-project.org/) ; All calculation flow are constructed by R script.
-	RStudio (http://www.rstudio.com/) ; is recommended to use R.
-	Cygwin ; (**optional**: If you want to run by Windows computer.) 
### R packages
R packages below are need to run all process.
If you use default coefficients, only 7 packages in PREDICTS_Projection process are needed.  

|  Process name  |  Name of packages |  Explanation  |
| :--- | :--- | :--- |
| DataPrep | dplyr | Easy data manipulation |
| | tidyr | Easy data manipulation |
| | data.table | Easy data manipulation |
| | remotes | For installing gdxrrw |
| | gdxrrw | Handling .gdx file |
| | raster | Handling raster file |
| | geosphere | Calculating distance between two sites  |
| | gower | Calculating gower's environmental distance between two sites |
| | furrr | Parallel calculation, set with purrr |
| | purrr | Parallel calculation, set with furrr |
| EstCoefs | lme4 | Estimating Linear-mixed models |
| | car | Logit transformation of compositional similarity and check collinearity |
| | foreach | Parallel calculation, set with doParallel |
| | doParallel | Parallel calculation, set with foreach |
| | dplyr* | |
| PREDICTS_Projection | ncdf4 | Handling .nc file |
| | raster* | |
| | dplyr* | |
| | tidyr* | |
| | foreach* | |
| | doParallel* | |
| | gdxrrw* | |
<br />

## Directory structure
### PREDICTS directory
* data ; required data
* prog ; main program 
* shell ; scripts for setting autmatically run and for PBS job management system.

<br />

## How to run
### Calculation flow
There are 3 main process.
|  Process name in settings_cout.sh  |  Corresponding main codes ( in prog dirctory) |  options  |  explanation  |
| :--- | :--- | :--- | :--- |
| DataPrep | process_climdata.R, process_humanpop.R, process_PREDICTSdatabase.R, biodiversityindex_calc.R |  | Convert climate data to Environmental Distance. Besides, convert human population data from AIM/DS to human population density. Once you run and get data, there is no need to run again.|
| EstCoefs |estimate_coefficients.R | modelsettings, PRJ, Climate_sce | Estimate the GLMM and use it to estimate coefficients, which are determined for each landuse class. If there are many variables in models, you can select which explain variables to input values and its future scenario, by optional arguments.|
| PREDICTS_Projection | BII_grid.R, gathering_gridBII_to_17region.R | modelsettings, PRJ, sce, Climate_sce | Apply coefficients to landuse data for BII estimation. You specify which coeffieints data to use, by optional arguments. |

<br />

### Get and put data
* AIM-PLUM landuse output (nc file) ; The file can be obtained from AIM-PLUM, 12 class land use gridded data. Please put the file to ../output/landuse/AIMPLUM.
* Gridded future Bioclimate data ; Future bioclimate data is needed for some models settings. If you run DataPrep, automatically putted to ../output/processedData/inputVariables/EnvDist. (It uses data in data/SharedData/PREDICTSData/WorldClim, so it won't working other than Cluster computer.)

<br />

### Model Settings (**modelsettings** in **settings_cout.sh**)
You can specify PREDICTS model settings by **modelsettings** in **settings_cout.sh**   
Currently(2024/07/11), there are below settings.
* BTC ; Settings in reference to [Lecrele et al. (2020)](https://www-nature-com.kyoto-u.idm.oclc.org/articles/s41586-020-2705-y), DOI:10.1038/s41586-020-2705-y
* HPD ; Settings in reference to [Newbold et al. (2016)](https://www.science.org/doi/10.1126/science.aaf2201), DOI:10.1126/science.aaf2201 or [De Palma et al. (2021)](https://www.nature.com/articles/s41598-021-98811-1), DOI:10.1038/s41598-021-98811-1

<br />

### Project name (**PRJ** in **settings_cout.sh**)
Besides, there can be many combinations (modelsettings × Variables scenario). So you can specify settings by **PRJ** in **settings_cout.sh**, such as HPDmodels_hpdSSP2_envdistRCP7. 
This ID is used to file or directory name distinction.  
If you choose **default**, DataPrep and EstCoefs process are skipped and estimate BII using stored coefficients in data/coefficients/.

<br />

### Scenario settings (**sce**, **Climate_sce** in **settings_cout.sh**)
If you choose BTC model setting, only landuse scenario **sce** should be changed.  
<br />
If you choose HPD model setting, adding to **sce**, **Climate_sce** should be changed.  
As for **Climate_sce**, it corresponds to climate scenario. (Default is none, which means no climate impacts consideration, because PREDICTS predicts landuse impacts well.)

<br />

### How to run the model
Copy./shell/settings_cout.sh and rename as you want.  Assuming that those files are named as ./shell/settings_cout2.sh, execute in Cygwin or linux OS under ./shell/ directory as below.
  
bash ./execution_cout.sh settings_cout2.sh
  
./shell/execution_cout.sh describes all processes and ./shell/settings_cout.sh is the file which you can configure settings what processes are carried out for each batch.

<br />


## Main results
* BII(../output/BII) ; Results are csv or nc format.  
* coefficients(../output/**PRJ**/) ; If modelsetting is HPD, gridded coefficients are obtained.  

<br />

