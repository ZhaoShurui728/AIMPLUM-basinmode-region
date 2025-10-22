

glob <- fread("C:\\Users\\gakusei\\Desktop\\inner_GLOBIOM_LUCC_sample_v3_scen1.csv")


uq <- unique(glob[,2:3])



fs <- list.files("D:\\to_Hasegawa\\20171222bend\\AIMdata\\AIMdata")

for (f in fs){
  test <- rgdx.param(f, symName = "PRLIestimator") %>%
    killfactor() %>%
    filter(LU_RLI != "Area.1000ha") %>%
    mutate(Y = as.numeric(Y), I = as.numeric(I), J = as.numeric(J), 
           PRLIestimator = as.numeric(PRLIestimator))

  unusual <- test %>%
    filter(PRLIestimator > 1.05)
  
  write.csv(unusual, paste(f, "_above1", ".csv",sep = ""))
  
}






