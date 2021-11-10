### create meta data

source("R/load_packages.R")

siteID = c("Arhelleren", "Alrust", "Fauske","Gudmedalen", "Hogsete", "Lavisdalen", "Ovstedal", "Rambera", "Skjelingahaugen", "Ulvehaugen", "Veskre", "Vikesland")

blockID = c(1:4)

treatment = c("C", "F", "G", "B", "FB", "GB", "GF", "FGB")

funder_metadata <- crossing(siteID, blockID, treatment) %>%
  mutate(blockID = paste0(str_sub(siteID, 1, 3), blockID),
         plotID = paste0(blockID, treatment))

write_csv(funcab_metadata, "FunCaB_2021_metadata.csv")
