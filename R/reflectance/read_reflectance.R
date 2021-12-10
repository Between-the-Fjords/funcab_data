# 2019 NDVI/Reflectance Data from SeedClim/FunCaB Grid
# Data collector: Joshua Lynn
# Code: Joshua Lynn and Sonya R. Geange

# Required Packages
source("R/load_packages.R")

# Download data from OSF
# Run the code from L17-L24 if you need to download the data from the OSF repository

# install.packages("remotes")
# remotes::install_github("Between-the-Fjords/dataDownloader")
# library(dataDownloader)

get_file(node = node,
         file = "FunCaB_raw_reflectance_2019-2021.zip",
         path = "data/reflectance",
         remote_path = "6_Reflectance")

# file needs to be unziped



# Read in 2019 reflectance data
# Because of Norwegian characters, use UTF-8 encoding
# fundat <- read.delim("data/reflectance/NDVI_FunCaB_2019.csv",
#                      fileEncoding = "UTF-8",
#                      sep = ",") %>%
#   as_tibble()

fundat <- read_delim("data/reflectance/NDVI_FunCaB_2019.csv",
           delim = ",")

# Check site names
#unique(fundat$Site)
# Clean the site names, Norwegian language read-in issue.
NDVI_2019 <- fundat %>%
  mutate(siteID = recode(fundat$Site,
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
                      'Veskre' = "Veskre")) %>%
  # Create new blockID with concatenated Site_Code and Block number
  mutate(blockID = paste0(substr(siteID, 1, 3), Block),
         # Create plotID
         plotID = paste0(blockID, Treatment),
         # fix TTC column
         TTC_ID = if_else(TTC_ID != "", str_replace(TTC_ID, "(?:[A-Z]*)(\\d*)", "TTC \\1"), TTC_ID)) %>%
  # Standardize dates to data dictionary
  mutate(Date = as.Date(Date, "%m/%d/%y"),
         # For each plot we took two reflectance values, perpindicular to each other to account for the different radius for the greenseeker sensor area, and the 25cm plot size. Average thse two values
         ndvi = (Value1 + Value2)/2,
         # Add column to specify when reflectance was taken relative to cutting
         pre_post_cut = "post") %>%
  select(date = Date, time = Time, siteID, blockID, plotID, treatment = Treatment, pre_post_cut, ndvi, notes, turfID = TTC_ID)

unique(NDVI_2019$siteID)
unique(NDVI_2019$blockID)
unique(NDVI_2019$plotID)
NDVI_2019 %>% distinct(turfID)



#########################################
# 2021 Data
#########################################

NDVI_2021 <- bind_rows(w1 = read_delim("data/reflectance/NDVI_Wk27.csv", delim = ";"),
          w2 = read_delim("data/reflectance/NDVI_Wk28.csv", delim = ";"),
          w3 = read_delim("data/reflectance/NDVI_Wk29.csv", delim = ";"),
          .id = "week") %>%
  mutate(Date = dmy(Date),
         siteID = recode(Site,
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
                                         'Veskre' = "Veskre"),
         # Create new blockID with concatenated Site_Code and Block number
         blockID = paste0(substr(siteID, 1, 3), Block),
                # Create plotID
                plotID = paste0(blockID, Plot)) %>%
  rename(Before_1 = "Before 1", Before_2 = "Before 2", After_1 = "After 1", After_2 = "After 2") %>%
  # For each plot we took two reflectance values, perpindicular to each other to account for the different radius for the greenseeker sensor area, and the 25cm plot size. Average these.
  mutate(pre_ndvi = (Before_1 + Before_2)/2,
         post_ndvi = (After_1 + After_2)/2) %>%
  select(date = Date, siteID, blockID, plotID, treatment = Plot, notes = Notes, pre_ndvi, post_ndvi, pre_time = "Before time", post_time = "After time", pre_weather = `Weather before`, post_weather = `Weather after`) %>%
  pivot_longer(cols = c(pre_ndvi, post_ndvi, pre_time, post_time, pre_weather, post_weather),
               names_to = c("pre_post_cut", ".value"),
               names_pattern = "(.*)_(.*)") %>%
  # remove one TT1 measurement
  filter(treatment != "TT1")





###########
# Combine 2019 and 2021 together

NDVI_FunCaB <- bind_rows(NDVI_2019, NDVI_2021)
write_csv(NDVI_FunCaB, "data/reflectance/FunCaB_clean_reflectance_2019_2021.csv")
