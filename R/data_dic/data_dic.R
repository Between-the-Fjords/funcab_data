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

biomass <- read_csv("data/biomass/FunCaB_clean_biomass_2015-2021.csv")


biomass_dic <- make_data_dictionary(data = biomass,
                                      description_table = description_table,
                                      table_ID = NA_character_) %>%
  mutate(`Variable range or levels` = if_else(`Variable name` == "remark", NA_character_, `Variable range or levels`))


#************************************************************************
#### 2 MICROCLIMATE DATA ####
# Temperature
soil_temperature <- read_csv(file = "data/climate/FunCaB_clean_soiltemperature_2015-2016.csv")

soil_temperature_dic <- make_data_dictionary(data = soil_temperature,
                                             description_table = description_table,
                                             table_ID = NA_character_) %>%
  # dangerous but if date_time is second variable it should be fine
  slice(-3) %>%
  mutate(`Variable type` = if_else(is.na(`Variable type`), "date_time", `Variable type`),
         `Variable range or levels` = if_else(is.na(`Variable range or levels`), "2015-07-12 17:58:01 - 2016-06-27 23:05:01", `Variable range or levels`),
         `Variable range or levels` = if_else(`Variable name` == "comments", NA_character_, `Variable range or levels`))



# Soilmoisture
soilmoisture <- read_csv("data/climate/FunCaB_clean_soilMoisture_2015-2018.csv")

soilmoisture_dic <- make_data_dictionary(data = soilmoisture,
                                         description_table = description_table,
                                         table_ID = NA_character_)

#************************************************************************

### 3 COMMUNITY DATA

community <- read_csv("data/community/FunCaB_clean_composition_2015-2019.csv")


community_dic <- make_data_dictionary(data = community,
                                      description_table = description_table,
                                      table_ID = NA_character_)


#************************************************************************

#### 4 SEEDLING RECRUITMENT DATA ####





#************************************************************************

#### 5 CARBON FLUX DATA ####

cflux <- read_csv("data/cflux/FunCaB_clean_Cflux_2015-2017.csv")

cflux_dic <- make_data_dictionary(data = cflux,
                                  description_table = description_table,
                                  table_ID = "cflux") %>%
  slice(-c(8, 10, 23, 25)) %>%
  mutate(`Variable range or levels` = if_else(`Variable name` == "starttime", "2015-06-30 08:10:30 - 2017-08-01 14:17:10", `Variable range or levels`),
         `Variable range or levels` = if_else(`Variable name` == "stoptime", "2015-06-30 08:12:30 - 2017-08-01 14:19:10", `Variable range or levels`),
         `Variable range or levels` = if_else(`Variable name` == "starttime_Reco", "2015-06-30 08:14:30 - 2017-08-01 14:19:55:10", `Variable range or levels`),
         `Variable range or levels` = if_else(`Variable name` == "stoptime_Reco", "2015-06-30 08:16:00 - 2017-08-01 14:21:55:10", `Variable range or levels`),
         `Variable range or levels` = if_else(`Variable name` %in% c("comment", "flag"), NA_character_, `Variable range or levels`))


#************************************************************************

#### 6 REFLECTANCE ####

reflectance <- read_csv("data/reflectance/FunCaB_clean_reflectance_2019_2021.csv")

reflectance_dic <- make_data_dictionary(data = reflectance,
                                  description_table = description_table,
                                  table_ID = "reflectance") %>%
  slice(-12) %>%
  mutate(`Variable range or levels` = if_else(`Variable name` == "time", "08:00 - 19:55", `Variable range or levels`))



#************************************************************************

##merge all dics together to one xlsx, with each parameter as a single sheet

write_xlsx(list(biomass_removal = biomass_dic,
                plant_community = community_dic,
                soil_temperature = soil_temperature_dic,
                soil_moisture = soilmoisture_dic,
                cflux = cflux_dic,
                reflectance = reflectance_dic),
           path = "R/data_dic/data_dictionary.xlsx")



