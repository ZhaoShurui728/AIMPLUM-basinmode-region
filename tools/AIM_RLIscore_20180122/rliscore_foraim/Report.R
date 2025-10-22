
library(data.table)
library(dplyr)
readin <- fread("output\\BiodivIndicator_trends_AIM.csv")
scenarioName <- fread("Report\\ScenarioName.txt", header = F)

out <- readin %>%
  rename(Region = reg, Variable = variable, Year = year, Value = val) %>%
  mutate(Unit = ifelse(Variable %in% c("ESHI", "RLI"), "unitless", "number of species")) %>%
  mutate(Variable = paste("Biodiversity|", Variable, sep = "")) %>%
  mutate(Scenario = substr(file, 1, nchar(file)-4)) %>%
  mutate(Model = "AIM")%>%
  merge(scenarioName, by.x = "Scenario", by.y = "V1", all.x =T) 


%>%
  select(-Scenario) %>%
  rename(Scenario = V2) %>%
  arrange(Variable, Region, Year) %>%
  select(Model, Scenario, Region, Variable, Year, Unit, Value)

# SSP1p_20W_SPA1_NoCC is not in the name list 


fwrite(out, "Report\\biodiv_AIM_V1.csv", row.names = F)


which(unique(out$Scenario) %in% unique(scenarioName$V1))
