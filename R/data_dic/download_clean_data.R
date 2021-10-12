# Download clean data from OSF
# install.packages("devtools")
#devtools::install_github("Between-the-Fjords/dataDownloader")
library(dataDownloader)

node <- "4c5v2"

# 1 Biomass
get_file(node = node,
         file = "FunCaB_biomass_2015-2021.csv",
         path = "clean_data/vegetation",
         remote_path = "Vegetation")

