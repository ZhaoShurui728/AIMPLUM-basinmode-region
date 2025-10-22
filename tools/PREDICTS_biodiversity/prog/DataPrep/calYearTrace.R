# memo ------------------------------------------------------
# script for tracing calYear into vector form in settings_cout.sh

# settings
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments
calYearAdd <- args[1]
#print(paste(calYearAdd))

outputDir <- '../output/txt/'
calYearListFile <- paste0(outputDir,"PREDICTSCalYearList.csv")

# prog
calYearAdd <- data.frame(calYear = calYearAdd)

if (file.exists(calYearListFile)) {
  calYearList <- read.csv(paste0(calYearListFile))
  calYearList <- rbind(calYearList, calYearAdd)
  write.csv(calYearList, file = paste0(calYearListFile), row.names = FALSE)
} else {
  calYearList <- data.frame(calYear = calYearAdd)
  write.csv(calYearList, file = paste0(calYearListFile), row.names = FALSE)
}
