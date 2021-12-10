##########################################
### Seedling recruitment data cleaning ###
##########################################

# load libraries
source("R/load_packages.R")

# source TTC turfIDs
source("R/community/dictionaries.R")

# Download raw data
get_file(node = node,
         file = "FunCaB_raw_recruitment_2018-2019.csv",
         path = "data/community",
         remote_path = "3_Plant_composition")

get_file(node = node,
         file = "FunCaB_clean_community_2015-2019.csv",
         path = "data/community",
         remote_path = "3_Plant_composition")


# read in raw seedling data
dat <- read_delim("data/recruitment/funcab_2019 - FUNCAB_recruitment2019.csv")

# fix site names
dat <- dat %>%
  mutate(site = recode(site,
                       "Ovstedal" = "Ovstedalen",
                       "Skjellingahaugen" = "Skjelingahaugen",
                       "Ulvhaugen" = "Ulvehaugen"))

# read in community data
comp2 <- read_delim(file = "data/community/FunCaB_clean_composition_2015-2019.csv")


# generate random seedling IDs for missing seedIDs
recruitment <- dat %>%
  filter(is.na(NS),
         !Comment %in% c("out of plot"),
         !is.na(presence1) | !is.na(presence2) | !is.na(presence3) |!is.na(presence4)) %>%
  mutate(seedID = case_when(
    is.na(seedID) ~ paste0("r", row_number(), "_", turfID),
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
  pivot_longer(cols = unID:Viola,
               names_to = "species",
               values_to = "temp_present", values_drop_na = TRUE) %>%
  select(-temp_present) %>%
  # no duplicates here
  # group_by(site, blockID, treatment, turfID, seedID, species) %>%
  # summarise(n = n()) %>% filter(n > 1)
  pivot_longer(cols = matches("\\d"),
               names_to = c(".value", "round"),
               names_pattern = "(.*)(\\d$)") %>%
  tidylog::filter(!is.na(presence)) %>%
  # fixing one wrongly formatted date
  mutate(date = if_else(date == "8/82019", "8/8/2019", date)) %>%
  mutate(date = dmy(date),
         year = if_else(round %in% c(1, 2), 2018, 2019),
         round = as.numeric(round)
         ) %>%
  select(year, date, siteID = site, blockID, plotID = turfID, treatment, seedID, round, species, presence, x, y, observer = Obs, Comment, Tttreat) %>%
  mutate(presence = case_when(
    presence %in% c("NF", "not found") ~ "0",
    presence %in% c("1?") ~"1",
    #presence %in% c("225") ~"25",
    is.na(presence) ~ "0",
    TRUE ~ presence
  ),
  presence = as.numeric(presence))



# fix species
recruitment1 <- recruitment1 %>%
  mutate(species = str_replace(species, "_", "."),
         species = recode(species,
                        "Anem.sp" = "Ane.sp",
                        "Bellis" = "Bel.sp",
                        "Betula" = "Bet.sp",
                        "Epil.sp" = "Epi.sp",
                        "Galium" = "Gal.sp",
                        "Hier.sp" = "Hie.sp",
                        "Leon.sp" = "Leo.sp",
                        "Leuc.sp" = "Leu.sp",
                        "Oma" = "Oma.sp",
                        "Ranu.sp" = "Ran.sp",
                        "Rume.sp" = "Rum.sp",
                        "Stel.sp" = "Ste.sp",
                        "Tara.sp" = "Tar.sp",
                        "Trif.sp" = "Tri.sp",
                        "unID" = "NID.seedling",
                        "Veronica" = "Ver.sp",
                        "Gal sax" = "Gal.sax",
                        "Viola" = "Vio.sp"))

# make multiple seedlings into separate observation and add unique seedID
# check if this sum is the same as uncount
#recruitment1 %>% filter(presence > 1) %>% summarise(sum(presence))
new_seedlings19 <- uncount(data = recruitment1 %>%
          filter(presence > 1), weights = presence) %>%
  mutate(seedID = paste0("s", row_number(), "_", plotID))


recruitment2 <- recruitment1 %>%
  filter(presence < 2) %>%
  bind_rows(new_seedlings19) %>%
  # fix turfID
  left_join(dict_TTC_turf, by = c("plotID" = "turfID")) %>%
  rename(turfID = TTtreat) %>%
  select(-Tttreat) %>%
  mutate(blockID = paste0(substr(siteID, 1, 3), blockID),
         functional_group = "forb") %>%
  rename(comment = Comment, collecter = observer)

write_csv(recruitment2, file = "data/recruitment/FunCaB_clean_recruitment_2018-2019.csv")

