# Download clean data from OSF
# install.packages("devtools")
#devtools::install_github("Between-the-Fjords/dataDownloader")
library(dataDownloader)

node <- "4c5v2"

# 1 Biomass
get_file(node = node,
         file = "FunCaB_raw_biomass_2021-11-02.xlsx",
         path = "data/biomass",
         remote_path = "Vegetation/Functional Group Biomass Removals")

