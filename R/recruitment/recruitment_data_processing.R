##########################################
### Seedling recruitment data cleaning ###
##########################################

# load libraries
source("R/load_packages.R")
library(DBI)
library(RSQLite)

# Download raw data
get_file(node = node,
         file = "FunCaB_clean_community_2015-2019.csv",
         path = "data/community",
         remote_path = "3_Plant_composition")

# download seedclim database (control plots)
get_file(node = "npfa9",
         file = "seedclim.2020.4.15.zip",
         path = "data/community",
         remote_path = "3_Community_data")

unzip("data/community/seedclim.2020.4.15.zip", exdir = "data/community")
# !!! Move to raw folder !!!


#source("~/Documents/FunCaB/figures/plotting_dim.R")

#source("~/Documents/FunCaB/climate/LT_climate.R")

#load seedling data
#load("~/OneDrive - University of Bergen/Research/FunCaB/Data/secondary/composition_211123.RData")

#gs4_deauth() # works for googlesheets where link sharing is ON
#dat <- read_sheet(ss = "https://docs.google.com/spreadsheets/d/1eDVV6pAoeVfwaUGzdQuWrmN2_9s7q3EhbYQwbtvnP_M/edit#gid=595311948", sheet = "FUNCAB_recruitment2019", col_types = "c")

# read in raw seedling data
dat <- read_delim("data/recruitment/funcab_2019 - FUNCAB_recruitment2019.csv",
                  col_types = )

# read in community data
comp2 <- read_delim(file = "data/community/FunCaB_clean_composition_2015-2019.csv")

# create dataframe of all turfs
all_turfs <- comp2 %>%
  filter(treatment != "XC") %>%
  distinct(site = siteID, turfID) %>%
  crossing(year = seq(2018:2019),
           round = seq(1:4)) %>%
  filter(case_when(
    year == 1 ~ round == 1:2,
    year == 2 ~ round == 3:4)) %>%
  mutate(year = case_when(year == 1 ~ 2018,
                          year == 2 ~ 2019))

# generate random seedling IDs for missing seedIDs
recruitment <- dat %>%
  filter(is.na(NS),
         !Comment %in% c("out of plot"),
         !is.na(presence1) | !is.na(presence2) | !is.na(presence3) |!is.na(presence4)) %>%
  mutate(seedID = case_when(
    is.na(seedID) ~ paste0("r", floor(runif(nrow(is.na(.)), min = 2000, max = 5000))),
    TRUE ~ seedID))

# seedlings with duplicate IDs
# should be empty
recruitment %>%
  group_by(turfID, seedID) %>%
  filter(n() > 1) %>%
  distinct(turfID, seedID)


recruitment1 <- recruitment %>%
  mutate(seedID = paste0(seedID,"_", turfID),
         presence1 = as.character(presence1)) %>%
  select(site, turfID, seedID, date1:date4, Obs1:Obs4, presence1:presence4) %>%
  pivot_longer(date1:presence4,
               names_to = c("category", "round"),
               names_pattern = "(^.{0,8})([1-4])") %>%
  pivot_wider(values_from = value, names_from = category) %>%
  mutate(date = dmy(date),
         year = year(date),
         round = as.numeric(as.factor(round))
         ) %>%
  full_join(all_turfs) %>%
  mutate(presence = case_when(
    presence %in% c("NF", "not found", "NA") ~ "0",
    presence %in% c("1?") ~"1",
    is.na(presence) ~ "0",
    TRUE ~ presence
  ),
  presence = as.numeric(presence))


# make total seedling count per turf and per observation round
mean_survival <- recruitment1 %>%
  filter(presence < 2) %>%
  group_by(turfID, seedID) %>%
  mutate(seed_count = sum(presence)) %>%
  group_by(turfID) %>%
  summarise(mean_survival = mean(seed_count))

multiples <- recruitment1 %>% filter(presence > 1)

recruitment1 <- recruitment1 %>%
  filter(presence < 2) %>%
  group_by(turfID, round) %>%
  mutate(total_seedlings = sum(presence)) %>%
  full_join(mean_survival, by = "turfID") %>%
  bind_rows(multiples)

save(recruitment1, file = "~/OneDrive - University of Bergen/research/FunCaB/Data/secondary/recruitment_cleaned.csv")

# recruitment %>%
#   filter(is.na(presence) | presence %in% c("1", "0")) %>%
#   mutate(presence = as.numeric(presence),
#          presence = coalesce(presence, 0)) %>%
#   select(-date, -year, - Obs) %>%
#   group_by(round, turfID) %>%
#   summarise(tot = n(),
#             totS = sum(presence)) %>%
#   pivot_wider(names_from = round, values_from = presence, names_prefix = "round_")
#             survival = (totS/tot)*100





# join onto complete turf list to catch turfs with zero seedlings






# load seed mass trait data
con <- src_sqlite(path = "~/OneDrive - University of Bergen/Research/FunCaB/seedclim.sqlite", create = FALSE)



######### data preparation ###########
seedMass <- tbl(con, "numeric_traits") %>%
  filter(trait == "seedMass") %>%
  collect()

turfDict <- comp2 %>%
  distinct(siteID, blockID, Treatment, turfID) %>%
  filter(!Treatment  == "XC") %>%
  mutate(Round = 1, Round2 = 2) %>%
  gather(Round, Round2, key = "v", value = "Round") %>%
  select(-v)


# merge composition data with seed mass data
seedcomp <- comp2 %>%
  filter(Year == 2018) %>%
  left_join(seedMass) %>%
  group_by(siteID, blockID, turfID, Treatment, mossCov, vegetationHeight, mossHeight, forbCov, graminoidCov, functionalGroup) %>%
  summarise(seedMass = weighted.mean(value, cover)) %>%
  ungroup()

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
  mutate_at(tot = case_when(is.na(tot) ~ 0L,
                             TRUE ~ tot)) %>%
  mutate(totS = case_when(is.na(totS) ~ 0,
                             TRUE ~ totS)) %>%
  mutate(survival = case_when(is.na(survival) ~ 0,
                             TRUE ~ survival)) %>%
  left_join(weather) %>%
  ungroup()

