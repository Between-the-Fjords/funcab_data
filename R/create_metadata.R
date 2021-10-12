### create meta data

source("R/load_packages.R")

siteID = c("Arhelleren", "Alrust", "Fauske","Gudmedalen", "Hogsete", "Lavisdalen", "Ovstedal", "Rambera", "Skjelingahaugen", "Ulvehaugen", "Veskre", "Vikesland")

blockID = c(1:4)

treatment = c("C", "F", "G", "B", "FB", "GB", "GF", "FGB")

funder_metadata <- crossing(siteID, blockID, treatment) %>%
  mutate(plotID = paste(str_sub(siteID, 1, 3), blockID, treatment, sep = "_"))

write_csv(funder_metadata, "Funder_2021_metadata.csv")
