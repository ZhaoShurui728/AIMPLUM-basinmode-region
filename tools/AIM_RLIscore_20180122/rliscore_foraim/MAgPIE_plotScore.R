
library(dplyr)
library(data.table)
library(stacomirtools)
library(ggplot2)
MAgPIE <- fread("output\\biodiv_MAgPIE_V1.csv", sep = ';', stringsAsFactors = F, header = T)

indices <- c('Biodiversity|ESHI','Biodiversity|NPotSpeciesInRegion',
  'Biodiversity|NSpeciesExtinctAtFirstYear','Biodiversity|RLI')

pmag <- function(index){
  MAgPIE_score <- MAgPIE %>%
    filter(Variable == index) %>%
    dplyr::select(-Model, -Variable, -Unit, -V26) %>%
    data.table::melt(id.vars = c("Scenario", "Region"), variable.name = 'year', variable.factor = F)%>%
    killfactor() %>%
    mutate(year = as.numeric(year))
  
  p <- ggplot(MAgPIE_score, aes(x = year, y = value))
  p + geom_line(aes(color = Region))+
    facet_wrap( ~ Scenario ) +
    ggtitle(index)
  
}

pdf('MAgPIE_plotScore.pdf', height = 8, width = 12)
pmag(indices[1])
pmag(indices[4])
pmag(indices[3])
pmag(indices[2])
dev.off()
