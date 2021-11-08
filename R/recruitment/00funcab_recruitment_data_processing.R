# seedling data cleaning #

#Download data from OSF
# run the code from L8-L15 if you need to download the data from OSF

# install.packages("remotes")
# remotes::install_github("Between-the-Fjords/dataDownloader")
# library(dataDownloader)

# recruitment data
# get_file(node = "4c5v2",
#          file = "2018_funcab_seedlings.csv",
#          path = "data/recruitment",
#          remote_path = "Vegetation/Recruitment")

# community data
# get_file(node = "4c5v2",
#          file = "2018_funcab_seedlings.csv",
#          path = "data/recruitment",
#          remote_path = "Vegetation/Recruitment")


# D = dead, assign alive if found alive in following year
# S = seedling
# TP = toothpick missing; essentially missing data. assign alive if found alive in following year
# E = established - two pairs of opposite leaves, or two alternate leaves
# + = fertile


#load packages
source("R/load_packages.R")

# source vegetation data, plotting code and soil temperature data
comp2 <- read_csv("data/community/FunCaB_clean_composition_21-11-03.csv")

#source("~/Documents/FunCaB/figures/plotting_dim.R")

#source("~/Documents/FunCaB/climate/LT_climate.R")

#load seedling data
seed <- read_csv2("data/recruitment/2018_funcab_seedlings.csv")



######### data preparation ###########

turfDict <- comp2 %>%
  distinct(siteID, blockID, Treatment, turfID) %>%
  filter(!Treatment  == "XC") %>%
  mutate(Round = 1, Round2 = 2) %>%
  gather(Round, Round2, key = "v", value = "Round") %>%
  select(-v)


# merge composition data with seed mass data
seedcomp <- comp2 %>%
  filter(Year == 2018)


seed <- seed %>%
  filter(is.na(NS)) %>%
  filter(!Comment %in% c("out of plot")) %>%
  mutate(Round = factor(Round),
         blockID = as.character(blockID),
         Date1 = dmy(Date1),
         Date2 = dmy(Date2),
         Leuc_sp = as.numeric(Leuc_sp),
         Tara_sp = as.numeric(Tara_sp),
         survival = if_else(is.na(survival), "alive", survival))

# join onto complete turf list to catch turfs with zero seedlings


######### ------ abundance ------ ###########
seedTot <- seed %>%
  group_by(siteID, Round, blockID, Treatment, turfID) %>%
  summarise(seed = sum(n())) %>%
  ungroup() %>%
  distinct(siteID, Round, blockID, Treatment, turfID, seed) %>%
  right_join(turfDict %>% mutate(Round = as.factor(Round))) %>%
  mutate(seed = case_when(is.na(seed) ~ 0L,
                             TRUE ~ seed)) %>%
  ungroup()

seed2018 <- seedTot %>%
  mutate(Treatment = recode(Treatment, "FGB" = "Gap", "C" = "Intact", "GF" = "B", "F" = "GB", "FB" = "G", "GB" = "F", "B" = "GF", "G" = "FB")) %>%
  mutate(monthN = recode(Round, `1` = "spr", `2` = "aut"),
         year = 2018) %>%
  select(-Round)

seedTot <- seed2018 %>%
  filter(Treatment %in% c("Intact", "Gap"))


######### ----- survival ----- ###########
survival <- seed %>%
  filter(Round == 1) %>%
  select(siteID, blockID, Treatment, turfID, survival) %>%
  mutate(survival = recode(survival, "dead" = 0, "alive" = 1, "not found" = 0, "1" = 1, "dezd" = 0)) %>%
  group_by(Treatment, turfID, blockID, siteID) %>%
  summarise(tot = n(),
            totS = sum(survival),
            survival = (totS/tot)*100) %>%
  right_join(turfDict %>% mutate(Round = as.factor(Round))) %>%
  mutate(tot = case_when(is.na(tot) ~ 0L,
                             TRUE ~ tot)) %>%
  mutate(totS = case_when(is.na(totS) ~ 0,
                             TRUE ~ totS)) %>%
  mutate(survival = case_when(is.na(survival) ~ 0,
                             TRUE ~ survival)) %>%
  left_join(weather) %>%
  ungroup()

survival <- survival %>%
  mutate(Treatment = recode(Treatment, "C" = "aC"),
         tempLevelPlot = factor(tempLevel, labels = c("6.5" = "Alpine", "8.5" = "Sub-alpine", "10.5" = "Boreal")),
         precipLevelPlot = factor(precipLevel, labels = c("600" = "Dry", "1200" = "Semi-dry", "2000" = "Semi-wet", "2700" = "Wet")),
         sprecip7010 = scale(precip7010/1000, center = TRUE, scale = FALSE),
         stemp7010 = scale(temp7010, center = TRUE, scale = FALSE),
         survival = survival/100)


save(seed2018, file = "~/OneDrive - University of Bergen/Research/FunCaB/Data/secondary/cleanedAbundData2018.RData")

save(survival, file = "~/OneDrive - University of Bergen/Research/FunCaB/Data/secondary/cleanedSurvData.RData")
