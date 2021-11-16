# Calculations for each datset

# Biomass

total_biomass <- biomass %>%
  summarise(sum(biomass, na.rm = TRUE))

fg_biomass <- biomass %>%
  group_by(removed_fg) %>%
  summarise(sum(biomass, na.rm = TRUE))

year_biomass <- biomass %>%
  group_by(year) %>%
  summarise(sum(biomass, na.rm = TRUE))


dim(biomass)


# Microclimate

soiltemp <- read_csv("data/climate/FunCaB_clean_soiltemperature_2015-2017.csv")

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
community <- read_csv(file = "data/community/FunCaB_clean_composition_2015-2018.csv")

# nr of species
community %>%
  filter(!species %in% c("NID.gram", "NID.herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  distinct(species)


community %>%
  filter(year == 2015) %>%
  filter(!species %in% c("NID.gram", "NID.herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  group_by(turfID, functionalGroup) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  group_by(functionalGroup) %>%
  summarise(mean(n))

community %>%
  filter(year == 2015) %>%
  filter(!species %in% c("NID.gram", "NID.herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  group_by(turfID, functionalGroup, siteID) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  group_by(functionalGroup, siteID) %>%
  summarise(mean = mean(n)) %>%
  arrange(functionalGroup, mean) %>% print(n = Inf)


community %>%
  filter(species %in% c("NID.gram", "NID.herb", "NID.seedling", NA_character_)) %>% count(species)

community %>%
  filter(is.na(species))

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
            se_tempK = sd(tempK - 273.15)/sqrt(n()))


# Dark measurements
CO2_final_1517 %>%
  summarize(min(Reco),
            max(Reco),
            se_Reco = sd(Reco)/sqrt(n()),
            min(tempK_Reco - 273.15),
            max(tempK_Reco - 273.15),
            se_tempK = sd(tempK_Reco - 273.15)/sqrt(n()))


CO2_final_1517 %>%
  group_by(treatment) %>%
  summarize(mean(gpp),
            se_gpp = sd(gpp)/sqrt(n()),
            mean(Reco),
            se_Reco = sd(Reco)/sqrt(n())) %>%
  arrange(`mean(Reco)`)

