# Make data dictionaries

# load libraries
source(file = "R/load_packages.R")

# load clean data
#source("R/data_dic/download_clean_data.R")

# data dictionary function
source("R/data_dic/make_data_dictionary.R")

# read in data description table
description_table <- read_excel("R/data_dic/data_description.xlsx")

#************************************************************************
#************************************************************************
### 1 BIOMASS

seed_pred <- read_csv("seed_predation/data/Seed_predation_2018.csv")


seed_pred_dic <- make_data_dictionary(data = seed_pred,
                                      description_table = description_table,
                                      table_ID = "seed_predation")


#************************************************************************

### 2 COMMUNITY DATA

seed_pred <- read_csv("seed_predation/data/Seed_predation_2018.csv")


seed_pred_dic <- make_data_dictionary(data = seed_pred,
                                      description_table = description_table,
                                      table_ID = "seed_predation")


#************************************************************************

#### 4 CARBON FLUX ####

phenology <- read_csv("phenology/clean_data/Community_phenology_2014-2015.csv")

phenology_dic <- make_data_dictionary(data = phenology,
                                      description_table = description_table,
                                      table_ID = "phenology")




#************************************************************************
#### 6 ECOSYSTEM ####
# Decomposition
litter <- read_csv("decomposition/Decomposition_litter_2016_clean.csv")

litter_dic <- make_data_dictionary(data = litter,
                                   description_table = description_table,
                                   table_ID = "litterbags")

teabag <- read_csv("decomposition/Decomposition_teabag_2014_clean.csv")

teabag_dic <- make_data_dictionary(data = teabag,
                                   description_table = description_table,
                                   table_ID = "teabag")



#************************************************************************
#************************************************************************
#### 8 ENVIRONMENTAL DATA ####
# Temperature
temperature <- read_csv("climate/data/Temperature.csv")

temperature_dic <- make_data_dictionary(data = temperature,
                                       description_table = description_table,
                                       table_ID = "temperature")


# Precipitation
precipitation <- read_csv("climate/data/Precipitation.csv")

precipitation_dic <- make_data_dictionary(data = precipitation,
                                       description_table = description_table,
                                       table_ID = "precipitation")

# Soilmoisture
soilmoisture <- read_csv("climate/data/SoilMoisture.csv")

soilmoisture_dic <- make_data_dictionary(data = soilmoisture,
                                       description_table = description_table,
                                       table_ID = "soilmoisture")

# Soilmoisture
soilmoisture_plot <- read_csv("climate/data/seedclim_soilmoisture_plotlevel.csv")

soilmoisture_plot_dic <- make_data_dictionary(data = soilmoisture_plot,
                                       description_table = description_table,
                                       table_ID = "soilmoisture_plot")


# Gridded climate data
climate <- read_csv("climate/data/GriddedDailyClimateData2009-2019.csv")

climate_plot_dic <- make_data_dictionary(data = climate,
                                              description_table = description_table,
                                              table_ID = "climate")


# Soil structure
soil_structure <- read_csv("soil_structure/Soil_structure_2013-2014_clean.csv")

soilmoisture_plot_dic <- make_data_dictionary(data = soil_structure,
                                              description_table = description_table,
                                              table_ID = "soil_structure")
