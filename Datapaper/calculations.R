# Calculations for each datset

# Biomass

biomass <- read_csv("data/biomass/FunCaB_clean_biomass_2015-2021.csv")

dim(biomass)

total_biomass <- biomass %>%
  summarise(sum(biomass, na.rm = TRUE))

fg_biomass <- biomass %>%
  group_by(removed_fg) %>%
  summarise(sum(biomass, na.rm = TRUE))

year_biomass <- biomass %>%
  group_by(year) %>%
  summarise(sum(biomass, na.rm = TRUE))

dim(biomass)


# extra plots
# per square meter
biomass %>%
  filter(treatment == "XC") %>%
  group_by(removed_fg) %>%
  summarise(sum = sum(biomass),
            per_sqm = sum(biomass) * 16)



# Microclimate

soiltemp <- read_csv("data/climate/FunCaB_clean_soiltemperature_2015-2016.csv")

# range of measurements
soiltemp %>% summarise(min(date_time),
                       max(date_time))

# nr of loggers
soiltemp %>% distinct(iButtonID)

# temp range
soiltemp %>% summarise(min(soiltemperature, na.rm = TRUE),
                       max(soiltemperature, na.rm = TRUE))

# daily mean and max in summer month
dailyTemperature <- soiltemp %>%
  filter(!is.na(soiltemperature)) %>%
  mutate(date = dmy(format(date_time, "%d.%b.%Y"))) %>%
  group_by(date, siteID, treatment) %>%
  summarise(n = n(),
            soiltemperature = mean(soiltemperature),
            max_temp = max(soiltemperature))

dailyTemperature %>%
  mutate(month = month(date)) %>%
  filter(month %in% c(5, 6, 7, 8)) %>%
  group_by(treatment) %>%
  summarise(mean = mean(soiltemperature),
            se = sd(soiltemperature)/sqrt(n()),
            max = max(soiltemperature)) %>%
  arrange(max)


#soimoisture
soilmoisture <- read_csv("data/climate/FunCaB_clean_soilMoisture_2015-2018.csv")

# 2018 missing plotID
soilmoisture %>%
  group_by(year = year(date), plotID) %>%
  summarise(n = n()) %>%
  group_by(year, n) %>% count()


# yearly mean
soilmoisture %>%
  group_by(year(date)) %>%
  summarise(mean = mean(soilmoisture, na.rm = TRUE),
            se = sd(soilmoisture, na.rm = TRUE)/sqrt(n()))

soilmoisture %>%
  group_by(treatment) %>%
  summarise(mean = mean(soilmoisture, na.rm = TRUE),
            se = sd(soilmoisture, na.rm = TRUE)/sqrt(n())) %>%
  arrange(mean)


#community
community <- read_csv(file = "data/community/FunCaB_clean_composition_2015-2019.csv")

# nr of species
community %>%
  filter(!species %in% c("NID.gram", "NID herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  distinct(species)


community %>%
  filter(year == 2015) %>%
  filter(!species %in% c("NID.gram", "NID herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  group_by(plotID, functional_group) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  group_by(functional_group) %>%
  summarise(mean = mean(n))

community %>%
  filter(year == 2015) %>%
  filter(!species %in% c("NID.gram", "NID herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  group_by(plotID, functional_group, siteID) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  group_by(functional_group, siteID) %>%
  summarise(mean = mean(n)) %>%
  arrange(functional_group, mean) %>% print(n = Inf)


community %>%
  filter(species %in% c("NID.gram", "NID.herb", "NID.seedling", NA_character_)) %>% count(species)

community %>%
  filter(is.na(species))


community %>% distinct(species, functional_group) %>%
  arrange(functional_group) %>%
  filter(str_detect(species, "\\.sp")) %>% pn


# Cflux
CO2_final_1517 <- read_csv(file = "data/cflux/FunCaB_clean_Cflux_2015-2017.csv")

dim(CO2_final_1517)

CO2_final_1517 %>% group_by(year) %>% count()

CO2_final_1517 %>% group_by(year, plotID) %>% summarise(n = n()) %>% ungroup() %>% group_by(year) %>%  summarize(median(n), min(n), max(n))

# Light measurements
CO2_final_1517 %>%
  summarize(min(gpp),
            max(gpp),
            se_gpp = sd(gpp)/sqrt(n()),
            min(PAR),
            max(PAR),
            se_PAR = sd(PAR)/sqrt(n()),
            min(tempK - 273.15),
            max(tempK - 273.15),
            se_tempK = sd(tempK - 273.15)/sqrt(n()),
            min(soilmoisture, na.rm = TRUE),
            max(soilmoisture, na.rm = TRUE),
            se_soilmoisture = sd(soilmoisture, na.rm = TRUE)/sqrt(n()),
            ) %>% as.data.frame()


# Dark measurements
CO2_final_1517 %>%
  summarize(min(Reco),
            max(Reco),
            se_Reco = sd(Reco)/sqrt(n()),
            min(tempK_Reco - 273.15),
            max(tempK_Reco - 273.15),
            se_tempK = sd(tempK_Reco - 273.15)/sqrt(n()),
            min(soilmoisture, na.rm = TRUE),
            max(soilmoisture, na.rm = TRUE),
            se_soilmoisture = sd(soilmoisture, na.rm = TRUE)/sqrt(n())) %>% as.data.frame()


CO2_final_1517 %>%
  group_by(treatment) %>%
  summarize(mean(gpp),
            se_gpp = sd(gpp)/sqrt(n()),
            mean(Reco),
            se_Reco = sd(Reco)/sqrt(n())) %>%
  arrange(`mean(Reco)`)

CO2_final_1517


# Reflectance
reflectance <- read_csv("data/reflectance/FunCaB_clean_reflectance_2019_2021.csv")

dim(reflectance)

reflectance %>%
  count(year(date), pre_post_cut)

# Average
reflectance %>%
  group_by(year = year(date), pre_post_cut) %>%
  summarise(mean = mean(ndvi, na.rm = TRUE),
            se_ndvi = sd(ndvi, na.rm = TRUE)/sqrt(n())) %>% pn

# Highest and lowest in treatment
reflectance %>%
  group_by(year = year(date), pre_post_cut, treatment) %>%
  summarise(mean = mean(ndvi, na.rm = TRUE),
            se_ndvi = sd(ndvi, na.rm = TRUE)/sqrt(n())) %>%
  arrange(year, pre_post_cut, mean) %>% pn


