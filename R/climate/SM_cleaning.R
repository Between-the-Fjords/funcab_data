#### soil moisture ####

source("R/load_packages.R")

library(lme4)
library(broom)


# use soil moisture differences!
# read in soil moisture data FUNCAB point measurements
SM201516_raw <- read_excel("data/climate/soilMoisture_2015-2016.xlsx")
SM2018_raw <- read_excel("data/climate/Soilmoisture2018.xlsx")
SM2017_raw <- read_excel(path = "data/climate/Soilmoisture2017.xlsx")

source("R/community/dictionaries.R")

# 2015 and 2016 data
SM201516 <- SM201516_raw %>%
  mutate_at(.vars = c("M1", "M2", "M3", "M4"), as.numeric) %>%
  filter(comments %in% c("fewer readings", "above table", "above table 100%")|is.na(comments)) %>%
  filter(!grepl("TT1", turfID),
         !grepl("TT2", turfID),
         !grepl("TT3", turfID),
         !grepl("TT4", turfID),
         !grepl("RTC", turfID),
         !grepl("P", turfID),
         !is.na(treatment)) %>%
  group_by(date, turfID) %>%
  mutate(sameDayMeasurement = n()) %>%
  #filter(n > 1) %>%
  mutate(SM = mean(c(M1, M2, M3, M4), na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(siteID = plyr::mapvalues(site, from = dict_Site$old, to = dict_Site$new)) %>%
  mutate(removal = if_else(is.na(removal), "C", removal),
         FCturfID = if_else(!is.na(removal), paste0(str_sub(siteID, 1, 3), block, removal), ""),
         date = ymd(date)) %>%
  filter(!treatment == "XC") %>%
  select(-site, -c(M1:M4), -blockSD, -treatment, -comments, -Moisture) %>%
  rename(treatment = removal) %>%
  mutate(blockID = paste0(substr(siteID, 1, 3), block)) %>%
  # recode site names
  mutate(siteID = recode(siteID,
                         "Ulvhaugen" = "Ulvehaugen",
                         "Skjellingahaugen" = "Skjelingahaugen",
                         "Ovstedal" = "Ovstedalen")) %>%
  select(date, siteID, blockID, plotID = FCturfID, treatment, soilmoisture = SM, weather, recorder, turfID)


# 2017 data
SM2017 <- SM2017_raw %>%
  mutate(Date = if_else(str_detect(Date, fixed(".")), dmy(Date, quiet = TRUE), as.Date(as.numeric(Date), origin = "1899-12-30"))) %>%
  rename("turfID" = `Turf ID`) %>%
  filter(!grepl("TT1", turfID),
         !grepl("TT2", turfID),
         !grepl("TT3", turfID),
         !grepl("TT4", turfID),
         !grepl("RTC", turfID),
         !grepl("P", turfID)) %>%
  mutate_at(vars(Measurement1, Measurement2, Measurement3, Measurement4), as.numeric) %>%
  rowwise() %>%
  mutate(soilmoisture = mean(c(Measurement1, Measurement2, Measurement3, Measurement4), na.rm = TRUE)) %>%
  mutate(Treatment = if_else(is.na(Treatment) & grepl("TTC", turfID), "C", Treatment)) %>%
  filter(!is.na(soilmoisture),
         !is.na(Treatment)) %>%
  mutate(Site = recode(Site, "ULV" = "Ulvehaugen",
                       "LAV" = "Lavisdalen",
                       "GUD" = "Gudmedalen",
                       "SKJ" = "Skjelingahaugen",
                       "ALR" = "Alrust",
                       "HOG" = "Hogsete",
                       "RAM" = "Rambera",
                       "VES" = "Veskre",
                       "FAU" = "Fauske",
                       "VIK" = "Vikesland",
                       "ARH" = "Arhelleren",
                       "OVS" = "Ovstedalen"),
         block = coalesce(SCBlock...5, SCBlock...6),
         blockID = paste0(substr(Site, 1, 3), block),
         plotID = paste0(blockID, Treatment)) %>%
  select(date = Date, siteID = Site, blockID, plotID, treatment = Treatment, soilmoisture, weather = Weather, recorder = Recorder, turfID)



### 2018 data
TTCs <- SM2018_raw %>%
  filter(grepl("TTC", turfID)) %>%
  mutate(turfID = gsub("TTC ", "", turfID),
         turfID = if_else(str_length(turfID) < 4, paste0(turfID, " TTC"), turfID),
         Treatment = "C") %>%
  rename(TTtreat = turfID, blockID = FCBlock) %>%
  right_join(dict_Site %>% select(v2, new), by = c(Site = "v2")) %>%
  select(-Site) %>%
  rename(siteID = new) %>%
  right_join(dict_TTC_turf) %>%
  filter(!is.na(Measurement1))

SM2018 <- SM2018_raw %>%
  right_join(dict_Site %>% select(v2, new), by = c(Site = "v2")) %>%
  select(-Site) %>%
  rename(siteID = new, blockID = FCBlock) %>%
  filter(!grepl("T", turfID),
         !grepl("P", turfID)) %>%
  bind_rows(TTCs) %>%
  mutate_at(vars(Measurement1, Measurement2, Measurement3, Measurement4), list(~as.numeric(gsub("u", 0, x = .)))) %>%
  rowwise() %>%
  mutate(SM = mean(c(Measurement1, Measurement2, Measurement3, Measurement4), na.rm = TRUE),
         blockID = case_when(
           turfID == "Fau4C" ~ 4,
           turfID == "Ulv2C" ~ 2,
           turfID == "Gud12C" ~ 12,
           TRUE ~ blockID
         )) %>%
  mutate(plotID = if_else(turfID %in% c("C", "B", "G", "F", "GF", "GB", "FB", "FGB"), paste0(substr(siteID, 1, 3), blockID, Treatment), turfID),
         blockID = substr(siteID, 1, 3)) %>%
  filter(!is.na(Treatment)) %>%
  # add missing date
  mutate(Date = if_else(is.na(Date) & siteID == "Arhelleren", ymd_h("2018-07-02", truncated = 1), Date),
         Date = if_else(is.na(Date) & siteID == "Ovstedal", ymd_h("2018-07-02", truncated = 1), Date)) %>%
  # recode site names
  mutate(siteID = recode(siteID,
                         "Ulvhaugen" = "Ulvehaugen",
                         "Skjellingahaugen" = "Skjelingahaugen",
                         "Ovstedal" = "Ovstedalen")) %>%
  select(date = Date, siteID, blockID, treatment = Treatment, soilmoisture = SM, weather = Weather,  recorder = Recorder, turfID)


soilmoisture <- bind_rows(SM201516, SM2017, SM2018)

write_csv(soilmoisture, file = "data/climate/FunCaB_clean_soilMoisture_2015-2018.csv")


# data checking
soilmoisture %>%
  mutate(treatment = factor(treatment, levels = c("B", "F", "G", "FB", "GB", "FG", "FGB")),
         biogeographic_zone = recode(siteID,
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
                                     Ovstedalen = "boreal"),
         prep_level = recode(siteID,
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
                             Ovstedalen = 4),
         climate = paste0(biogeographic_zone, prep_level),
         climate = factor(climate, levels = c("boreal1", "boreal2", "boreal3", "boreal4", "sub.alpine1", "sub.alpine2", "sub.alpine3", "sub.alpine4", "alpine1", "alpine2", "alpine3", "alpine4"))) %>%
  ggplot(aes(x = treatment, y = soilmoisture, colour = siteID)) +
  geom_point() +
  facet_grid(year(date) ~ climate)



