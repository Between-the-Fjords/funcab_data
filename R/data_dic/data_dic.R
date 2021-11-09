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
#### 2 MICROCLIMATE DATA ####
# Temperature
soil_temperature <- read_csv(file = "data/climate/FunCaB_clean_soiltemperature_2015-2017.csv")

soil_temperature_dic <- make_data_dictionary(data = soil_temperature,
                                             description_table = description_table,
                                             table_ID = NA_character_) %>%
  # dangerous but if date_time is second variable it should be fine
  slice(-3) %>%
  mutate(`Variable type` = if_else(is.na(`Variable type`), "date_time", `Variable type`),
         `Variable range or levels` = if_else(is.na(`Variable range or levels`), "2015-07-12 17:58:01 - 2016-06-27 23:05:01", `Variable range or levels`))



# Soilmoisture
soilmoisture <- read_csv("data/climate/FunCaB_clean_soilMoisture_2015-2018.csv")

soilmoisture_dic <- make_data_dictionary(data = soilmoisture,
                                         description_table = description_table,
                                         table_ID = NA_character_)

#************************************************************************

### 3 COMMUNITY DATA

community <- read_csv("data/community/FunCaB_clean_composition_21-11-03.csv")


community_dic <- make_data_dictionary(data = community,
                                      description_table = description_table,
                                      table_ID = NA_character_)


#************************************************************************

#### 4 SEEDLING RECRUITMENT DATA ####





#************************************************************************

#### 5 CARBON FLUX DATA ####

#cflux <- read_csv("phenology/clean_data/Community_phenology_2014-2015.csv")

#cflux_dic <- make_data_dictionary(data = cflux,
    #                             description_table = description_table,
     #                                 table_ID = NA_character_)



#************************************************************************

##merge all dics together to one xlsx, with each parameter as a single sheet

write_xlsx(list(biomass = biomass_dic,
                community = community_dic,
                soil_temperature = soil_temperature_dic,
                soil_moisture = soilmoisture_dic),
           path = "R/data_dic/data_dictionary.xlsx")



