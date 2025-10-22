library(data.table)
library(raster)

LUID <- fread("link_AgMIP_Reg_ID_LUID.csv", stringsAsFactors = F) %>%
    mutate(LUID_n = as.numeric(substr(LUID, 3,7)) -1) %>%  
    select(LUID_n)
  
cell <- rep(0, 90*180) 

cell[LUID$LUID_n] <- 1  
  
countrygrid <- matrix(cell, nrow = 90, byrow = T)

plot(raster(countrygrid))

write.csv(countrygrid, "countrygridAgMIP.csv", row.names = F)
