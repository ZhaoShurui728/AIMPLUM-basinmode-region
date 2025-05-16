# Share data for AIM-Global

This program is originally written by Ken Oshiro and modified by Tomoko Hasegawa.
This repository contains share dataset for AIM-Global models.

Currently, following dataset is included:

- gridmapping: Map 0.5x0.5 grid with country code. Currently it covers only land-area.

To re-calculate the programs, set `./shell` as current directory and execute  `bash run_all.sh`.
See following descriptions for more details on each data.

## gridmapping

- Dataset is provides in `output/landshare*.gdx` and `output/landshare*.csv`.
- Numbers indicate the share of land area in each country.
- Sea area is not included, which means that sum of numbers for each grid is 1.
- Currently regions are presented in R106, but to be updated.
- To reproduce or re-calculate, execute `shell/run_all.sh` with `gridmapping='on'`.
