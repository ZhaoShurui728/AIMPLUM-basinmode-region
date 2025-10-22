library(tidyverse)
library(readxl)

args <- commandArgs()
prog_loc <- as.character(args[7])

read_excel(paste0("../", prog_loc, "/define/inc_shell/scenario_settings.xlsx")) %>% 
  mutate(shell = purrr::pmap(
    list(..1 = SCE, ..2 = CLP, ..3 = IAV),
      ~{write_lines(paste0("SCE=", ..1, "\nCLP=", ..2, "\nIAV=", ..3),
                    file = paste0("../", prog_loc, "/shell/settings/", ..1, "_", ..2, "_", ..3, ".sh"), sep = "\n")
       }
      )
    )
