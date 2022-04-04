# load libraries
source("R/load_packages.R")


#### Download data from OSF ####

# download biomass data
get_file(node = "4c5v2",
         file = "FunCaB_clean_biomass_2015-2021.csv",
         path = "data/biomass",
         remote_path = "1_Biomass_removal")


# download species level biomass data
get_file(node = "4c5v2",
         file = "FunCaB_clean_species_biomass_2016.csv",
         path = "data/biomass",
         remote_path = "1_Biomass_removal")


# download climate data
get_file(node = "4c5v2",
         file = "FunCaB_clean_soilMoisture_2015-2019.csv",
         path = "data/climate",
         remote_path = "2_Soil_microclimate/Soil Moisture")

get_file(node = "4c5v2",
         file = "FunCaB_clean_soiltemperature_2015-2016.csv",
         path = "data/climate",
         remote_path = "2_Soil_microclimate/Soil Temperature")


# download community data
get_file(node = "4c5v2",
         file = "FunCaB_clean_composition_2015-2019.csv",
         path = "data/community",
         remote_path = "3_Plant_composition")

get_file(node = "4c5v2",
         file = "FunCaB_taxon_table.csv",
         path = "data/community",
         remote_path = "3_Plant_composition")


# download seedling recruitment data
get_file(node = "4c5v2",
         file = "FunCaB_clean_recruitment_2018-2019.csv",
         path = "data/recruitment",
         remote_path = "4_Seedling_recruitment")


# download carbon flux data
get_file(node = "4c5v2",
         file = "FunCaB_clean_Cflux_2015-2017.csv",
         path = "data/cflux",
         remote_path = "5_Carbon_fluxes")


# download reflectance data
get_file(node = "4c5v2",
         file = "FunCaB_clean_reflectance_2019_2021.csv",
         path = "data/reflectance",
         remote_path = "6_Reflectance")


