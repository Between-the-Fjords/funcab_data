# Calculations for each datset

# Biomass without extra plots
biomass <- read_csv("data/biomass/FunCaB_clean_biomass_2015-2021.csv") %>%
  filter(treatment != "XC")

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
biomax <- read_csv("data/biomass/FunCaB_clean_biomass_2015-2021.csv") %>%
  filter(treatment == "XC")

biomax %>%
  summarize(sum(biomass))

# per square meter
biomax %>%
  group_by(removed_fg) %>%
  summarise(sum = sum(biomass),
            per_sqm = sum(biomass) * 16)

# species level biomass
biomass_sp <- read_csv("data/biomass/FunCaB_clean_species_biomass_2016.csv")

dim(biomass_sp)

biomass_sp %>%
  filter(species != "NID.herb") %>%
  distinct(species) %>% pn

# most common species
biomass_sp %>%
  group_by(species) %>%
  summarise(sum = sum(biomass)) %>%
  arrange(sum) %>%
  pn

# most common in alpine vs lowland
biomass_sp %>%
  mutate(biogeographic_zone = recode(siteID,
                                     Ulvehaugen = "alpine",
                                     Lavisdalen = "alpine",
                                     Gudmedalen = "alpine",
                                     Skjelingahaugen = "alpine",
                                     Alrust = "sub.alpine",
                                     Hogsete = "sub.alpine",
                                     Rambera = "sub.alpine",
                                     Veskre = "sub.alpine",
                                     Fauske = "boreal",
                                     Vikesland = "boreal",
                                     Arhelleren = "boreal",
                                     Ovstedalen = "boreal")) %>%
  group_by(biogeographic_zone, species) %>%
  summarise(sum = sum(biomass)) %>%
            # n(),
            # se = sd(biomass)/sqrt(n()) %>%
  arrange(biogeographic_zone, sum) %>%
  pn

biomass_sp %>%
  mutate(prep_level = recode(siteID,
                             Ulvehaugen = 1,
                             Lavisdalen = 2,
                             Gudmedalen = 3,
                             Skjelingahaugen = 4,
                             Alrust = 1,
                             Hogsete = 2,
                             Rambera = 3,
                             Veskre = 4,
                             Fauske = 1,
                             Vikesland = 2,
                             Arhelleren = 3,
                             Ovstedalen = 4)) %>%
  group_by(prep_level, species) %>%
  summarise(sum = sum(biomass)) %>%
  # n(),
  # se = sd(biomass)/sqrt(n()) %>%
  arrange(prep_level, sum) %>%
  pn

biomass_sp %>%
  group_by(siteID, blockID) %>%
  summarise(n = n()) %>%
  filter(n == 1)


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
soilmoisture <- read_csv("data/climate/FunCaB_clean_soilMoisture_2015-2019.csv")

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

community %>%
  group_by(functional_group, species) %>%
  filter(cover > 50) %>%
  group_by(functional_group, species) %>%
  summarise(mean = mean(cover)) %>%
  arrange(functional_group, mean) %>% pn


# seedlings

recruitment <- read_csv("data/recruitment/FunCaB_clean_recruitment_2018-2019.csv")

dim(recruitment)

recruitment %>%
  filter(species != "NID.seedling") %>%
  count(species)

recruitment %>% distinct(species)

recruitment %>%
  mutate(id = if_else(species == "NID.seedling", "no", "yes")) %>%
  group_by(id) %>%
  summarise(n = n(),
            percentage = n/16656*100)

# count per treatment
recruitment %>%
  group_by(treatment) %>%
  count() %>%
  arrange(n)

# seedling density
recruitment %>%
  group_by(treatment, plotID) %>%
  summarise(mean = mean(n())) %>%
  mutate(sqm = mean * 16) %>%
  group_by(treatment) %>%
  summarise(sqm = mean(sqm)) %>%
  arrange(sqm)

# seedling per year
recruitment %>% group_by(year, round) %>% count()

recruitment %>%
  distinct(year, date, round) %>%
  arrange(year, round) %>% pn



# Cflux
CO2_final_1517 <- read_csv(file = "data/cflux/FunCaB_clean_Cflux_2015-2017.csv")

dim(CO2_final_1517)

CO2_final_1517 %>% distinct(treatment)

CO2_final_1517 %>% group_by(year) %>% count()

CO2_final_1517 %>% group_by(year, plotID) %>% summarise(n = n()) %>% ungroup() %>% group_by(year) %>%  summarize(median(n), min(n), max(n))

CO2_final_1517 %>% group_by(year, plotID, treatment) %>% summarise(n = n()) %>% ungroup() %>% group_by(year, treatment) %>%  summarize(median(n), min(n), max(n))

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


