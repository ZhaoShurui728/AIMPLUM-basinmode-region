


LUT <- fread("D:\\to_Hasegawa\\20171222bend\\AIMdata\\Task1.21_RLI-LPI_estimators\\RLIscore_20Dec2017v2\\input_scenarios\\inner_GLOBIOM_LUCC_sample_v3_scen1.csv", stringsAsFactors = F)


LUTcheck <- LUT %>%
  filter(YEAR == 2000) %>%
  mutate(shareTot = rowSums(.[,5:13])) %>%
  dplyr::select(x, y, shareTot)

baseg <- expand.grid( x = seq(-179, 179, 2), y = seq(-89, 89, 2))



grids_mat <- merge(baseg, LUTcheck, by.x = c("x", "y"), by.y = c("x", "y"), all.x = T)


grids_mat_cast <- dcast(grids_mat, y ~ x) %>%
  arrange(desc(y)) %>%
  as.matrix()


plot(raster(as.matrix(grids_mat_cast), xmn = -180, xmx = 180, ymn = -90, ymx = 90))


write.csv(link_AgMIP_Reg_ID_LUID, "link_AgMIP_Reg_ID_LUID.csv", row.names = F)
