# Make data dictionaries

# load libraries
source(file = "R/load_packages.R")

# load clean data
#source("R/data_dic/download_clean_data.R")

# data dictionary function
source("R/data_dic/make_data_dictionary.R")

# read in data description table
description_table <- read_excel("R/data_dic/data_description.xlsx") %>%
  mutate(TableID = as.character(TableID))

#************************************************************************
#************************************************************************
### 1 BIOMASS

biomass <- read_csv("data/biomass/FunCaB_biomass_clean_2015-2021.csv")


biomass_dic <- make_data_dictionary(data = biomass,
                                      description_table = description_table,
                                      table_ID = NA_character_)


#************************************************************************

### 2 COMMUNITY DATA

community <- read_csv("data/vegetation_community/FunCaB_clean_composition_21-11-03.csv")


community_dic <- make_data_dictionary(data = community,
                                      description_table = description_table,
                                      table_ID = NA_character_)


#************************************************************************

#### 4 CARBON FLUX ####

#phenology <- read_csv("phenology/clean_data/Community_phenology_2014-2015.csv")

#phenology_dic <- make_data_dictionary(data = phenology,
    #                                  description_table = description_table,
     #                                 table_ID = "phenology")





#************************************************************************
#************************************************************************
#### 8 ENVIRONMENTAL DATA ####
# Temperature
soil_temperature <- load("data/soil_temperature/iButton2016.RData")
soil_temperature<-iButtonData

soil_temperature_dic <- make_data_dictionary(data = soil_temperature,
                                       description_table = description_table,
                                       table_ID = NA_character_)



# Soilmoisture
soilmoisture <- read_csv("data/soil_moisture/FunCaB_clean_soilMoisture_2015-2018.csv")

soilmoisture_dic <- make_data_dictionary(data = soilmoisture,
                                       description_table = description_table,
                                       table_ID = NA_character_)


##merge all dics together to one xlsx, with each parameter as a single sheet

write_xlsx(list(biomass = biomass_dic,community = community_dic, soil_temperature = soil_temperature_dic, soil_moisture = soilmoisture_dic),"R/data_dic/data_dictionary.xlsx")



