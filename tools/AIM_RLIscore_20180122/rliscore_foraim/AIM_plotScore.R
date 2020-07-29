options(digits = 3)
plotScore <- function(version){
	outputpdf <- paste("RLIscore_forAIM\\BiodivIndicator_trends_AIM_", version,".pdf", sep = '')
	bkf <- function(score, varnm){
	  tp <- filter(score, variable == varnm)
	  p <- ggplot(tp, aes(x = year, y = val, color = reg)) +
		scale_shape_manual(values = 1:19) +
		geom_point(aes(shape = reg)) +
		geom_line(aes(color = reg)) + 
		#scale_y_continuous(limits = c(0, 1))+ 
		facet_wrap(~ file, nrow = rowN) +
		theme(legend.key.width=unit(10,"cm")) + 
		theme_bw() + ggtitle(varnm)
	  print(p)
	}
  
  score <- fread(paste("RLIscore_forAIM\\output\\BiodivIndicator_trends_AIM_", version, '.csv',sep = ''))
  rowN <- round(sqrt(length(unique(score$file))))
  pdf(outputpdf, width = rowN * 5, height = rowN * 8)
  bkf(score, 'ESHI')
  bkf(score, 'RLI')
  bkf(score, 'NSpeciesExtinctAtFirstYear')
  bkf(score, 'NPotSpeciesInRegion')
  dev.off()
}















