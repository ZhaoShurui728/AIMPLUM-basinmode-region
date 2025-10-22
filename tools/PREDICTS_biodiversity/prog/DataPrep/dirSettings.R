# memo -------------------------------------------------------
# Script to control data and output directory settings

# settings
args <- commandArgs(trailingOnly = TRUE) # from execution_cout.sh, second arguments

dirSettingsFor <- args[1]
ParentDir <- args[2]

if (dirSettingsFor == 'AIMPLUM') {

  dataDirName <- paste0('../',ParentDir,'/tools/PREDICTS_biodiversity/data/')
  outputDirName <- '../output/PREDICTS/'
  landuseDirName <- '../output/nc/'
  SharedDataDirName <- '/data/SharedData/PREDICTSData/'

} else if (dirSettingsFor == 'Cluster') {

  dataDirName <- './data/'
  outputDirName <- '../output/'
  landuseDirName <- '../output/landuse/AIMPLUM/'
  SharedDataDirName <- '/data/SharedData/PREDICTSData/'

} else if (dirSettingsFor == 'KUSC') {
  
  dataDirName <- './data/'
  outputDirName <- '../output/'
  landuseDirName <- '../output/landuse/AIMPLUM/'
  SharedDataDirName <- '/data/SharedData/PREDICTSData/'

} else {

  dataDirName <- './data/'
  outputDirName <- '../output/'
  landuseDirName <- '../output/nc/'
  print('Because there is not SharedData directory, cannot execute DataPrep process.')

}

directoryPathList <- data.frame(dataDir = dataDirName, outputDir = outputDirName, landuseDir = landuseDirName, SharedDataDir = SharedDataDirName)
write.csv(directoryPathList ,'../output/txt/PREDICTSDirectoryPath.csv', row.names = FALSE)