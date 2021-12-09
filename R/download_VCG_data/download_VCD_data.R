###################################################
### Download Vestlandet Climate Grid (VCG) data ###
###################################################

# This script shows how to download site level data and long-term climate data from the VCG.

# load libraries
source("R/load_packages.R")

library(DBI)
library(RSQLite)

#### SITE LEVEL DATA AND ATTRIBUTES ####
# download seedclim database from OSF
get_file(node = "npfa9",
         file = "seedclim.2020.4.15.zip",
         path = "data/community",
         remote_path = "3_Community_data")

unzip("data/community/seedclim.2020.4.15.zip", exdir = "data/community")
# !!! Move to raw folder !!!

# connect to database
con <- src_sqlite(path = "data/community/raw/seedclim.sqlite", create = FALSE)

# Extract site level data from database
# latitude, longitude, elevation, temperature and precipitation levels
sites <- tbl(con, "sites") %>%
  collect()

# Extract site attributes from database
# geology, land use, aspect, slope, solar radiation and total N
site_attributes <- tbl(con, "site_attributes") %>%
  collect()



#### CLMATE DATA ####

# download seedclim temperature data from OSF
get_file(node = "npfa9",
         file = "Temperature.zip",
         path = "data/climate",
         remote_path = "8_Environmental_data")



#### LITTER AND TEABAG DATA ####

# download litter data from OSF
get_file(node = "npfa9",
         file = "Decomposition_litter_2016_clean.csv",
         path = "data/decomposition",
         remote_path = "7_Ecosystem_data")

# download teabag data from OSF
get_file(node = "npfa9",
         file = "Decomposition_teabag_2014_clean.csv",
         path = "data/decomposition",
         remote_path = "7_Ecosystem_data")



#### TRAIT DATA ####

# download trait data from OSF
get_file(node = "npfa9",
         file = "SeedClim_Trait_data_2012_2016.csv",
         path = "data/traits",
         remote_path = "5_Trait_data")


