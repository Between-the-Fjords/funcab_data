# 2019 NDVI/Reflectance Data from SeedClim/FunCaB Grid
# Data collector: Joshua Lynn
# Code: Joshua Lynn and Sonya R. Geange

# Required Packages
require(coda)
require(car)
library(dplyr)
library(tidyverse)
library(readxl)
library(stringr)
source("R/load_packages.R")

# Download data from OSF
# Run the code from L10-L13 if you need to download the data from the OSF repository

# get_file(node = "4c5v2",
#          file = "NDVI_FunCaB_2019.csv",
#          path = "data",
#          remote_path = "Vegetation data/Reflectance/Data")

# Read in 2019 reflectance data
# Because of Norwegian characters, use UTF-8 encoding
fundat <- read.delim("./data/NDVI_FunCaB_2019.csv",
                     fileEncoding = "UTF-8",
                     sep = ",")

# Check site names
unique(fundat$Site)
# Clean the site names, Norwegian language read-in issue.
fundat$siteID <- recode(fundat$Site,
                      'Gudmesdalen' = "Gudmedalen",
                      'Låvisdalen' = "Lavisdalen",
                      'Rambæra' = "Rambera",
                      'Ulvehaugen' = "Ulvehaugen",
                      'Skjellingahaugen' = "Skjelingahaugen",
                      'Ålrust' = "Alrust",
                      'Arhelleren' = "Arhelleren",
                      'Fauske' = "Fauske",
                      'Høgsete' = "Hogsete",
                      'Øvstedal' = "Ovstedalen",
                      'Vikesland' = "Vikesland",
                      'Veskre' = "Veskre")
unique(fundat$siteID)

# Turn Site names into Site Codes to merge with block ID's later on
fundat$Site_Code<- recode(fundat$siteID,
                            'Gudmedalen' = "Gud",
                            'Lavisdalen' = "Lav",
                            'Rambera' = "Ram",
                            'Ulvehaugen' = "Ulv",
                            'Skjelingahaugen' = "Skj",
                            'Alrust' = "Alr",
                            'Arhelleren' = "Arh",
                            'Fauske' = "Fae",
                            'Hogsete' = "Hog",
                            'Ovstedalen' = "Ovs",
                            'Vikesland' = "Vik",
                            'Veskre' = "Ves")

# Create new blockID with concatenated Site_Code and Block number
fundat$blockID <- paste0(fundat$Site_Code, fundat$Block)
unique(fundat$blockID)

# Create plotID
fundat$plotID <- paste0(fundat$blockID, fundat$Treatment)
unique(fundat$plotID)

# Standardize dates to data dictionary
fundat$date <- as.Date(fundat$Date, "%m/%d/%y")

# For each plot we took two reflectance values, perpindicular to each other to account for the different radius for the greenseeker sensor area, and the 25cm plot size. Average these.
fundat$m_ndvi <- (fundat$Value1+ fundat$Value2)/2 # average the two values

# Check distributon of new NDVI values
hist(logit(fundat$m_ndvi))

# Add column to specify when reflectance was taken relative to cutting
fundat$pre_post_cut <- "post_cut"

# Remove columns no longer required
NDVI_2019 <- fundat %>%
  select(siteID, blockID, plotID, Treatment, TTC_ID, pre_post_cut,
         date, Time, m_ndvi, notes)

# Write file
write_csv(NDVI_2019, "./data/NDVI_2019.csv")

#########################################
# 2021 Data
#########################################

# Read in Wk 28 and 29 (4sites each)
fundat_wk2 <- read.delim("./data/NDVI_Wk28.csv", header = TRUE,
                       sep = ";")

fundat_wk3 <- read.delim("./data/NDVI_Wk29.csv", header = TRUE,
                       sep = ";")

# As columns match, add rows together
fundat_wk2_3 <- bind_rows(fundat_wk2, fundat_wk3)

# Standardize dates to data dictionary
head(fundat_wk2_3$Date)
fundat_wk2_3$date <- format(as.Date(fundat_wk2_3$Date, format = "%d.%m.%Y"), "%Y-%m-%d")

# Check and clean the site names, Norwegian language read-in issue.
unique(fundat_wk2_3$Site)
fundat_wk2_3$siteID <- recode(fundat_wk2_3$Site,
                        'Gudmedalen' = "Gudmedalen",
                        'Låvisdalen' = "Lavisdalen",
                        'Rambæra' = "Rambera",
                        'Ulvhaugen' = "Ulvehaugen",
                        'Skjellingahaugen' = "Skjelingahaugen",
                        'Ålrust' = "Alrust",
                        'Arhelleren' = "Arhelleren",
                        'Fauske' = "Fauske",
                        'Høgsete' = "Hogsete",
                        'Øvstedal' = "Ovstedalen",
                        'Vikesland' = "Vikesland",
                        'Veskre' = "Veskre")


# Turn Site names into Site Codes to merge with block ID's later on
fundat_wk2_3$Site_Code<- recode(fundat_wk2_3$siteID,
                          'Gudmedalen' = "Gud",
                          'Lavisdalen' = "Lav",
                          'Rambera' = "Ram",
                          'Ulvehaugen' = "Ulv",
                          'Skjelingahaugen' = "Skj",
                          'Alrust' = "Alr",
                          'Arhelleren' = "Arh",
                          'Fauske' = "Fae",
                          'Hogsete' = "Hog",
                          'Ovstedalen' = "Ovs",
                          'Vikesland' = "Vik",
                          'Veskre' = "Ves")

# Create new blockID with concatenated Site_Code and Block number
fundat_wk2_3$blockID <- paste0(fundat_wk2_3$Site_Code,
                               fundat_wk2_3$Block)
unique(fundat_wk2_3$blockID)

# Create plotID
fundat_wk2_3$plotID <- paste0(fundat_wk2_3$blockID,
                              fundat_wk2_3$Plot)
unique(fundat_wk2_3$plotID)

# Rename plot as Treatment
fundat_wk2_3$Treatment <- fundat_wk2_3$Plot

# For each plot we took two reflectance values, perpindicular to each other to account for the different radius for the greenseeker sensor area, and the 25cm plot size. Average these.
fundat_wk2_3$m_ndvi_after <- (fundat_wk2_3$After.1+ fundat_wk2_3$After.2)/2 # average the two values

# The Before cutting data
fundat_wk2_3$m_ndvi_before <- (fundat_wk2_3$Before.1+
                                 fundat_wk2_3$Before.1)/2 # average the two values

# Transform to long format so pre- and post-cut data can be allocated
fundat_wk2_3 <- fundat_wk2_3 %>%
  pivot_longer(
               cols = c("m_ndvi_before", "m_ndvi_after"),
               names_to = c("pre_post_cut"),
               values_to = c("m_ndvi"))


# Rename column for cutting
fundat_wk2_3$pre_post_cut <- recode(fundat_wk2_3$pre_post_cut,
                              'm_ndvi_before' = "pre_cut",
                              'm_ndvi_after' = "post_cut")

# Change the weather and date columns as well to pivot longer, atm
# It is duplicated across both before and after cutting

fundat_wk2_3 <- fundat_wk2_3 %>%
  mutate(Weather = ifelse(pre_post_cut == 'pre_cut', Weather.before, Weather.after))
fundat_wk2_3 <- fundat_wk2_3 %>%
  mutate(Time = ifelse(pre_post_cut == 'pre_cut', Before.time, After.time))

# Add notes column if necessary later on
fundat_wk2_3$notes <- NA

# Only select relevant columns
NDVI_2021 <- fundat_wk2_3 %>%
  select(siteID, blockID, plotID, Treatment, pre_post_cut,
         date, Time, Weather, m_ndvi,notes)

# Write file
write_csv(NDVI_2021, "./data/NDVI_2021.csv")
