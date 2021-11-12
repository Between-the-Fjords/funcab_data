### FLUX DATA ###

# load libraries
source("R/load_packages.R")

#### import ####
#================================================================================
#================================================================================

### 2015 AND 2016 DATA

#source functions for import/proces and calculation of CO2 flux
source("R/cflux/functions/import_process_CO2data.R")
source("R/cflux/functions/CO2flux_calculation2015.R")
source("R/cflux/functions/CO2_plot.R")
source("R/cflux/functions/import_process_SQlogger.R")

source("R/cflux/functions/TTC_dictionary.R")

#================================================================================

### DOWNLOAD RELEVANT DATA

# Download clean data from OSF
# install.packages("devtools")
#devtools::install_github("Between-the-Fjords/dataDownloader")
#library(dataDownloader)

#node <- "4c5v2"

# 5 Carbon fluxes
# get_file(node = node,
#          file = "xxx.zip",
#          remote_path = "5_Carbon_fluxes")

# Clean Soil moisture data
# get_file(node = node,
#          file = "FunCaB_clean_soilMoisture_2015-2018.csv",
#          path = "data/climate",
#          remote_path = "2_Soil_microclimate/Soil Moisture")

#================================================================================
# importing single datafiles, process and set new start and end times.
#TEST DATASET for automated quality check

#Set new start and stoptime for measurement, always indicate start and stop value with numbers otherwise inf as stoptime!
#TESTDATA<-setStartEndTimes(combine.data) # returns a list of which measurements to keep/ discard after setting new start/stoptime
#outlier.filter(combine.data)

#x$dat$keep = TRUE for newly set start and endtimes FALSE for ommited measurement points
# fluxcalc should use data for $dat$keep ==TRUE

#import all pre removal datafiles from 2015 and all datafiles of 2016
# 2015
sites.data.2015 <- read.sitefiles("data/cflux/CO2/Data/data_files_2015_pre.xlsx")
#calculate flux for all data 2016

# 2016
# Licore data

sites.data.2016Li1400 <- read.sitefiles("data/cflux/CO2/Data/datafiles_2016_cleaned.xlsx")#!Li1400 dataflagged outliers+new times
# squirle logger data
sites.data.2016SQ <- read.sitefiles.SQ("data/cflux/CO2/Data/datafiles_2016_SQ.xlsx") #!SQ dataflagged outliers+new times

# Flux calculation
# pre-removal 2015
overviewsitesdata_2015 <- do.call(rbind, lapply(sites.data.2015, fluxcalc2015)) #calculate

#calculate flux for all data 2016
overviewsitesdataLi1400_2016 <- do.call(rbind, lapply(sites.data.2016Li1400, fluxcalc2015))
overviewsitesdataSQ_2016 <- do.call(rbind, lapply(sites.data.2016SQ, fluxcalc2015))


# bind together 2016 from li1400 and SQ logger
overviewsitesdata_2016 <- rbind(overviewsitesdataSQ_2016, overviewsitesdataLi1400_2016) %>%
  mutate(airpress = as.numeric(str_replace(airpress, ",", "\\.")),
         vegbiomass = as.numeric(str_replace(vegbiomass, ",", "\\."))) %>%
         rename(soilT = airpress)

#================================================================================
#================================================================================

### 2017 DATA

#source functions for import/proces and calculation of CO2 flux
source("R/cflux/functions/import_process_CO2data_2017.R")
source("R/cflux/functions/CO2flux_calculation2015.R")
source("R/cflux/functions/CO2_plot.R")
source("R/cflux/functions/import_process_SQlogger_2017.R")


#import all pre removal datafiles from 2017
sites.data.2017Li1400 <- read.sitefiles("data/cflux/CO2/Data/Li1400files2017new.xlsx")#!Li1400 dataflagged outliers+new times
sites.data.2017SQ <- read.sitefiles.SQ("data/cflux/CO2/Data/SQfiles2017new.xlsx") #!SQ dataflagged outliers+new time

# Run fluxcalculation on all datafiles of 2017
#fluxcalc(sites.data.2017Li1400[[1]]) #calculate flux 1 plot
CO2_Li1400_2017 <- do.call(rbind, lapply(sites.data.2017Li1400, fluxcalc2015))
CO2_SQ_2017 <- do.call(rbind, lapply(sites.data.2017SQ, fluxcalc2015))
CO2_Li1400_2017$PAR_est <- as.numeric(CO2_Li1400_2017$PAR)
CO2_SQ_2017$PAR_est <- as.numeric(CO2_SQ_2017$PAR)
CO2_Li1400_2017$PAR <- NULL
CO2_SQ_2017$PAR <- NULL

# bind together 2015 and 2016 data
CO2data_2017 <- rbind(CO2_Li1400_2017, CO2_SQ_2017) %>%
  mutate(soilT = as.numeric(str_replace(soilT, ",", "\\.")),
         removal = "post") %>%
  # Correct PAR values for measurements when PAR sensor was broken with estimated value based on recorded PAR value in metadata: chamber 1 dates 03.07-06.07
  # if cover = "L" & PAR > 200 then use PAR_est value, if cover D and high PAR, correct to estimated value
  mutate(PAR = if_else(chamber == "1" & site == "ALR" | chamber == "1" & site == "FAU", PAR_est, PAR)) %>%
  select(-PAR_est)


#### cleaning ####
#================================================================================
#================================================================================


# bind all years together
CO2data <- bind_rows(overviewsitesdata_2015,
                          overviewsitesdata_2016,
                          CO2data_2017) %>%
  as_tibble() %>%
  # rename turfID Control plots of 2015/ 2016 data from FC coding to TTC coding if plot is a TTC control
  mutate(site = recode(site,
                       ULV = "Ulvehaugen",
                       ALR = "Alrust",
                       FAU = "Fauske",
                       LAV = "Lavisdalen",
                       HOG = "Hogsete",
                       VIK = "Vikesland",
                       GUD = "Gudmedalen",
                       RAM = "Rambera",
                       ARH = "Arhelleren",
                       SKJ = "Skjelingahaugen",
                       VES = "Veskre",
                       OVS = "Ovstedalen")) %>%
  mutate(plotID = paste0(substr(site, 1, 3), block, treatment),
         # change date format from character to Date
         date = as.Date(date, format="%d.%m.%Y"),
         year = year(date),
         block = paste0(substr(site, 1, 3), block),
         n = 1:n()) %>%
  # remove bad observations
  filter(!removal %in% c("x")) %>%
  # fix mix up in removal and flag column
  mutate(removal = if_else(flag == "pre" & removal == "", flag, removal),
         removal = if_else(year == 2016, "post", removal)) %>%
  # change L and D to light and dark, S1 and S2 are also light measurements
  mutate(cover = recode(cover, "D" = "dark", "L" = "light", "S1" = "light", "S2" = "light")) %>%
  # change TTC turfIDs
  mutate(turfID = plyr::mapvalues(plotID, from = dict_TTC$old, to = dict_TTC$new),
         turfID = if_else(str_detect(turfID, "TTC"), turfID, NA_character_),
         treatment = str_replace(treatment, "TTC", "C"),
         plotID = str_replace(plotID, "TTC", "C"),
         chamber = if_else(date == ymd("2016-06-28") & site == "Vikesland", 1L, chamber)) %>%
  select(year, date, siteID = site, blockID = block, plotID, treatment, measurement = cover, starttime, stoptime, cover, time, PAR, temp, soiltemp = soilT, vegHeight = vegbiomass, nee, rsqd, n, chamber, removal, weather, flag, comment, turfID)


# add mean soil moisture to each CO2flux measurement
soilmoisture <- read_csv("data/climate/FunCaB_clean_soilMoisture_2015-2018.csv")

CO2data <- CO2data %>%
  left_join(soilmoisture %>%
              select(-weather),
            by = c("date", "siteID", "blockID", "plotID", "treatment", "turfID")) %>%
  distinct(n, .keep_all = TRUE) %>%
  select(-n)


#### calculations ####
###########  Calculating GPP and cleaning observations ##############################################################################

# nee negative is CO2 uptake in the ecosystem
# nee positive is CO2 release in the atmosphere

# light = nee
# dark = Reco


# seperate L and D measurements and merge them in new file with new column GPP, selecting data with r2>=.8
CO2_clean <- CO2data %>%
  filter(rsqd >= 0.8 | measurement == "light" & rsqd <= 0.2) %>%
  # Ecosystem respiration should always be positive (CO2 release to the air)
  filter(!(measurement == "dark" & nee <= 0)) %>%
  # get temperature in kelvin
  mutate(tempK = temp + 273.15) %>%
  select(-temp)

# cross each light and dark measurement with each other
CO2_final_1517 <- crossing(
  CO2_clean %>%
    filter(measurement == "light"),

  CO2_clean %>%
    filter(measurement == "dark") %>%
    select(-siteID, -blockID, -treatment, -measurement, -year) %>%
    # need to rename all dark measurements
    rename_with(~ paste0(.x, "_Reco")) %>%
    rename(Reco = nee_Reco)
  ) %>%
  # remove all matches that are NOT on the same date and plot
  filter(date == date_Reco,
         plotID == plotID_Reco) %>%
  select(-date_Reco, -plotID_Reco, -measurement) %>%
  # get the nearest light and dark measurement
  group_by(plotID, chamber, starttime) %>%
  # get smallest difference of startime between light and dark measurement
  slice(which.min(abs(starttime - starttime_Reco))) %>%
  mutate(delta = abs(starttime - starttime_Reco)) %>%
  # remove light and dark observations that are more than 2 hours apart
  filter(delta < 2 * 60 * 60) %>%
  # nee - Reco = GPP, with GPP being negative for uptake
  mutate(gpp = nee - Reco) %>%
  # get rid off positive GPP values
  filter(gpp < 0)


write_csv(CO2_final_1517, file = "data/cflux/FunCaB_clean_Cflux_2015-2017.csv")


