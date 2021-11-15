# 2019 NDVI/Reflectance Data from SeedClim/FunCaB Grid
# Data collector: Joshua Lynn
# Code: Joshua Lynn and Sonya R. Geange

# Required Packages
install.packages("pacman")
pacman::p_load(coda, car, dpylr, readxl, tidyverse)

# Download data from OSF
# Run the code from L17-L24 if you need to download the data from the OSF repository

# install.packages("remotes")
# remotes::install_github("Between-the-Fjords/dataDownloader")
# library(dataDownloader)

# get_file(node = "4c5v2",
#          file = "FunCaB_raw_reflectance_2019-2021.zip",
#          path = "data/reflectance",
#          remote_path = "Vegetation data/Reflectance")


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

# Rename Treatment
fundat$treatment <- fundat$Treatment


######################################################
# TODO: Change TTC column to match seedclim dictionary
######################################################

# Standardize dates to data dictionary
fundat$date <- as.Date(fundat$Date, "%m/%d/%y")

# For each plot we took two reflectance values, perpindicular to each other to account for the different radius for the greenseeker sensor area, and the 25cm plot size. Average these.
fundat$m_ndvi <- (fundat$Value1+ fundat$Value2)/2 # average the two values


# Add column to specify when reflectance was taken relative to cutting
fundat$pre_post_cut <- "post_cut"
fundat$time <- fundat$Time

# Remove columns no longer required
NDVI_2019 <- fundat %>%
  select(date, time, siteID, blockID, plotID, treatment, TTC_ID, pre_post_cut,
         m_ndvi, notes)


# Write file
write_csv(NDVI_2019, "data/NDVI_2019.csv")

#########################################
# 2021 Data
#########################################

# Read in Wk 28 and 29 (4sites each)
fundat_wk1 <- read.delim("./data/NDVI_Wk27.csv", header = TRUE,
                         sep = ";")
fundat_wk2 <- read.delim("./data/NDVI_Wk28.csv", header = TRUE,
                       sep = ";")

fundat_wk3 <- read.delim("./data/NDVI_Wk29.csv", header = TRUE,
                       sep = ";")

# As columns match, add rows together
fundat_wk1_2_3 <- bind_rows(fundat_wk1, fundat_wk2, fundat_wk3)

# Standardize dates to data dictionary
head(fundat_wk1_2_3$Date)
fundat_wk1_2_3$date <- format(as.Date(fundat_wk1_2_3$Date, format = "%d.%m.%Y"), "%Y-%m-%d")
fundat_wk1_2_3$date <- as.Date(fundat_wk1_2_3$date)

# Check and clean the site names, Norwegian language read-in issue.
unique(fundat_wk1_2_3$Site)
fundat_wk1_2_3$siteID <- recode(fundat_wk1_2_3$Site,
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
fundat_wk1_2_3$Site_Code<- recode(fundat_wk1_2_3$siteID,
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
fundat_wk1_2_3$blockID <- paste0(fundat_wk1_2_3$Site_Code,
                               fundat_wk1_2_3$Block)
unique(fundat_wk1_2_3$blockID)

# Create plotID
fundat_wk1_2_3$plotID <- paste0(fundat_wk1_2_3$blockID,
                              fundat_wk1_2_3$Plot)
unique(fundat_wk1_2_3$plotID)

# Rename plot as Treatment
fundat_wk1_2_3$treatment <- fundat_wk1_2_3$Plot

# For each plot we took two reflectance values, perpindicular to each other to account for the different radius for the greenseeker sensor area, and the 25cm plot size. Average these.
fundat_wk1_2_3$m_ndvi_after <- (fundat_wk1_2_3$After.1+ fundat_wk1_2_3$After.2)/2 # average the two values

# The Before cutting data
fundat_wk1_2_3$m_ndvi_before <- (fundat_wk1_2_3$Before.1+
                                 fundat_wk1_2_3$Before.1)/2 # average the two values

# Transform to long format so pre- and post-cut data can be allocated
fundat_wk1_2_3 <- fundat_wk1_2_3 %>%
  pivot_longer(
               cols = c("m_ndvi_before", "m_ndvi_after"),
               names_to = c("pre_post_cut"),
               values_to = c("m_ndvi"))


# Rename column for cutting
fundat_wk1_2_3$pre_post_cut <- recode(fundat_wk1_2_3$pre_post_cut,
                              'm_ndvi_before' = "pre_cut",
                              'm_ndvi_after' = "post_cut")

# Change the weather and date columns as well to pivot longer, atm
# It is duplicated across both before and after cutting

fundat_wk1_2_3 <- fundat_wk1_2_3 %>%
  mutate(weather = ifelse(pre_post_cut == 'pre_cut', Weather.before, Weather.after))
fundat_wk1_2_3 <- fundat_wk1_2_3 %>%
  mutate(time = ifelse(pre_post_cut == 'pre_cut', Before.time, After.time))

# Change Notes to notes
fundat_wk1_2_3$notes <- fundat_wk1_2_3$Notes

# Only select relevant columns
NDVI_2021 <- fundat_wk1_2_3 %>%
  select(date, time, siteID, blockID, plotID, treatment, pre_post_cut, m_ndvi,
          weather, notes)

# Write file
write_csv(NDVI_2021, "data/NDVI_2021.csv")


###########
# Combine 2019 and 2021 together

NDVI_FunCaB <- bind_rows(NDVI_2019, NDVI_2021)
write_csv(NDVI_FunCaB, "data/FunCaB_clean_reflectance_2019_2021.csv")
