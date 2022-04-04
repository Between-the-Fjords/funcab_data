###############################################################~#
#### Community data for all funcab analyses                  ####
####                                                         ##~#
#### project: FunCaB                                         ##~#
#### author: Francesca Jaroszynska                           ##~#
#### email: fjaroszynska@gmail.com                           ##~#
#### edited: 03/12/2021                                      ##~#
###############################################################~#

# load libraries
source("R/load_packages.R")

library(DBI)
library(RSQLite)

# Download raw data
get_file(node = node,
         file = "FunCaB_raw_community_2015-2019.zip",
         path = "data/community",
         remote_path = "3_Plant_composition")

# unzip the files
unzip("data/community/FunCaB_raw_community_2015-2019.zip", exdir = "data/community")
### !!! rename the folder containing the raw data to raw to make it simpler!!!

# download seedclim database (control plots)
get_file(node = "npfa9",
         file = "seedclim.2020.4.15.zip",
         path = "data/community",
         remote_path = "3_Community_data")

unzip("data/community/seedclim.2020.4.15.zip", exdir = "data/community")
# !!! Move also to raw folder !!!


# source required dictionaries
source("R/community/dictionaries.R")

# replace species names where mistakes have been found in database
problems <- read_delim("data/community/raw/speciesCorrections.txt") %>%
  filter(!old %in% c("Vio.can", "Com.ten", "Sel.sel")) %>%
  filter(cover != "WHAT HAPPENED") %>%
  mutate(cover = as.numeric(cover))

# load the dictionary merger
mergedictionary <- read_delim(file = "data/community/raw/mergedictionary.csv")


# connect to database
con <- src_sqlite(path = "data/community/raw/seedclim.sqlite", create = FALSE)

####-------- load funcab data ---------####
gudfun2015 <- read_excel("data/community/raw/funcab_Gudmedalen.xlsx", col_types = "text")

funcab_2015 <- read_delim("data/community/raw/funcab_composition_2015-utenGud.csv", delim = ";", col_types = cols(.default = "c"))

funcab_2016 <- read_delim("data/community/raw/funcab_composition_2016.csv", delim = ";", col_types = cols(.default = "c"))

funcab_2017 <- read_delim("data/community/raw/funcab_composition_2017.csv", delim = ";", col_types = cols(.default = "c"))

funcab_2018 <- read_excel("data/community/raw/funcab_composition_2018.xlsx", col_types = "text")

funcab_2019 <- read_csv("data/community/raw/funcab_composition_2019.csv", col_types = cols(.default = "c"))

scBryo <- read_excel("data/community/raw/2017seedclimBryophyte.xlsx")


####-------- load seedclim data ---------####
FG <- tbl(con, "species_attributes") %>%
  filter(attribute == "functional_group") %>%
  select(species, functional_group = value_character) %>%
  collect()

control_community <- tbl(con, "subturf_community") %>%
  group_by(turfID, year, species) %>%
  summarise(n_subturf = n()) %>%
  collect() %>%
  full_join(tbl(con, "turf_community") %>% collect()) %>%
  left_join(tbl(con, "taxon"), copy = TRUE) %>%
  left_join(tbl(con, "turfs"), copy = TRUE) %>%
  left_join(tbl(con, "plots"), by = c("destinationPlotID" = "plotID"), copy = TRUE) %>%
  left_join(tbl(con, "blocks"), by = "blockID", copy = TRUE) %>%
  left_join(tbl(con, "sites"), by = "siteID", copy = TRUE) %>%
  left_join(tbl(con, "turf_environment"), copy = TRUE) %>%
  select(siteID, blockID, plotID = destinationPlotID, turfID, TTtreat, GRtreat, year, species, cover, temperature_level, precipitation_level, recorder, total_vascular, total_bryophytes, vegetation_height, moss_height, litter) %>%
  mutate(TTtreat = factor(TTtreat), GRtreat = factor(GRtreat)) %>%
  ungroup() %>%
  filter(year > 2014, TTtreat == "TTC"|GRtreat == "TTC")


# fixes for botanist biases
siri <- control_community %>%
  filter(recorder == "Siri") %>%
  group_by(turfID, year) %>%
  filter(sum(cover)/total_vascular < 1.35) %>%
  distinct(turfID)

control_community <- control_community %>% mutate(cover = case_when(
  recorder == "PM" ~ cover*1.20,
  recorder == "Siri" & year %in% siri$year & turfID %in% siri$turfID ~ cover*1.3,
  TRUE ~ cover
))

# correct inconsistencies among cm/mm
control_community <- control_community %>%
  mutate(vegetation_height = case_when(
    year == 2016 ~ vegetation_height/10,
    year == 2015 & turfID == "126 TTC" ~ vegetation_height/10,
    TRUE ~ vegetation_height),
    moss_height = case_when(
      year == 2016 ~ moss_height/10,
      year == 2017 & turfID == "301 TTC" ~ 7.5,
      TRUE ~ moss_height)) %>%
  mutate(vegetation_height = vegetation_height*10,
         moss_height = moss_height*10)

# merge the GRtreat and TTtreat into one column. Join to turf dictionary
control_community <- control_community %>%
  mutate(TTtreat = coalesce(GRtreat, TTtreat)) %>%
  filter(turfID %in% dict_TTC_turf$TTtreat) %>% # or semi_join()
  mutate(treatment = "C",
         TTtreat = turfID) %>%
  left_join(dict_TTC_turf, by = "TTtreat", suffix = c(".new", "")) %>%
  select(-c(GRtreat, plotID, temperature_level, precipitation_level, total_vascular, litter, turfID.new))

# duplicating two plots that are missing from 2017
tt17 <- control_community %>%
  filter(TTtreat %in% c("297 TTC", "246 TTC"), year == 2016) %>%
  mutate(year = 2017)

control_community <- bind_rows(control_community, tt17) %>%
  mutate(siteID = recode(siteID,
                         "Ulvehaugen" = "Ulvhaugen",
                         "Skjelingahaugen" = "Skjellingahaugen",
                         "Ovstedalen" = "Ovstedal"))



####------------- FunCaB data cleaning -------------####
# calculate mean veg and moss heights for 2018
funcab_2018 <- funcab_2018 %>%
  full_join(funcab_2019) %>%
  filter(!grepl("TT1", TTtreat), !grepl("OUT", TTtreat), !grepl("OUT", turfID)) %>%
  mutate_at(vars(vegetationHeight, mossHeight), as.numeric) %>%
  group_by(turfID) %>%
  mutate(vegetationHeight = as.character(mean(vegetationHeight, na.rm = TRUE)),
         mossHeight =  as.character(mean(mossHeight, na.rm = TRUE))) %>%
  ungroup()

#problems from problem file
prob.sp <- problems %>%
  filter(!is.na(year)) %>%
  select(-functional_group)

prob.sp.name <- problems %>%
  filter(is.na(year), !old %in% c("Eri.bor")) %>%
  select(old, new) %>%
  bind_rows(mergedictionary)

problems.cover <- filter(problems, !is.na(cover)) %>%
  select(turfID, species = old, cover)


# bind funcab composition data, replace _ with . for compatibility in spp names
composition <- funcab_2016 %>%
  bind_rows(funcab_2015) %>%
  bind_rows(gudfun2015) %>%
  bind_rows(funcab_2017) %>%
  bind_rows(funcab_2018) %>%
  filter(subPlot %in% c("%", "T")) %>%
  select(c(siteID:subPlot), year, recorder, c(totalGraminoids:mossHeight), litter, acro, pleuro, c(`Ach mil`:`Vis vul`), c(`Agr can`:`Sax aiz`), c(`Bet pen`:`Ran pyg`), -comments) %>%
  select_if(colSums(!is.na(.)) > 0) %>%
  mutate(`Vio riv` = coalesce(`Vio can`, `Vio riv`),
         `Frag ves` = coalesce(`Fra vir`, `Frag ves`),
         `Fes ovi` = coalesce(`Fes viv`, `Fes ovi`),
         `Hier sp` = coalesce(`Hie juv`, `Hier sp`)) %>%
  select(-`Vio can`, -`Fra vir`, -`Hie juv`, -`Fes viv`) %>%
  gather(c("Ach mil":"Ran pyg"), key = "species", value = "cover")


# create table of species presences in turfs
subTurfFreq <- composition %>%
  filter(subPlot == "T", !is.na(cover)) %>%
  select(siteID, Treatment, turfID, year, species, presence = cover) %>%
  mutate(presence = 1)

# join species presences back onto full dataset
composition <- composition %>%
  filter(subPlot == "%") %>%
  left_join(subTurfFreq)


# overwrite problem spp with their correct names and covers
composition <- composition %>%
  mutate(species = gsub("\\ |\\_", ".", species)) %>%
  mutate_at(vars(cover, year, totalGraminoids:pleuro), as.numeric) %>%
  left_join(prob.sp, by = c("year", "turfID", "siteID", "species" = "old"), suffix = c("", ".new")) %>%
  mutate(species = coalesce(new, species),
         cover = coalesce(cover.new, cover, )) %>%
  select(-new, -cover.new, -subPlot) %>%
  left_join(prob.sp.name, by = c("species" = "old")) %>%
  mutate(species2 = if_else(!is.na(new), new, species)) %>%
  select(-species, -new) %>%
  rename(species = species2, total_graminoids = totalGraminoids, total_forbs = totalForbs, total_bryophytes = totalBryophytes, vegetation_height = vegetationHeight, moss_height = mossHeight, treatment = Treatment)


# adjust species, turf and site names
composition <- composition %>%
  left_join(dict_TTC_turf, by = c("turfID" = "TTtreat"), suffix = c(".old", ".new")) %>%
  mutate(turfID = if_else(!is.na(turfID.new), turfID.new, turfID)) %>%
  mutate(turfID = if_else((blockID == 16 & siteID == "Gudmedalen"), gsub("16", "5", turfID), turfID),
         turfID = if_else((siteID == "Alrust" & blockID == "3" & year == 2015 & treatment == "C"), "Alr3C", turfID),
         turfID = recode(turfID, "Alr4FGB" = "Alr5C"),
         blockID = if_else(blockID == 16 & siteID == "Gudmedalen", gsub("16", "5", blockID), blockID),
         blockID = if_else(turfID == "Gud12C", "12", blockID)) %>%
  filter(!(blockID == "4" & year == 2015 & siteID == "Alrust"),
         !(turfID =="Gud12C" & year == 2015),
         !is.na(turfID),
         !(turfID == "Alr3C" & recorder == "Siri"),
         !(year == 2019 & turfID == "Vik4F" & recorder == "JL"))

# filter out GFs and FGBs
FGBs <- composition %>%
  filter(treatment %in% c("FGB", "GF")) %>%
  select(-species, -cover, -turfID.new) %>%
  distinct() %>%
  filter(year > 2015)

# filter out funcab controls that are also TTCs in 2015 & 2016
ttcs1516 <- composition %>%
  filter(treatment == "C", !year %in% c(2017, 2018, 2019), !is.na(year)) %>%
  right_join(dict_TTC_turf) %>%
  select(-species, -cover, -pleuro, -acro, -litter, -presence, -turfID.new, -recorder) %>%
  distinct()

# fill in missing bryophyte covers where missing in TTC turfs
ttcs17 <- composition %>%
  filter(treatment == "C", year == 2017) %>%
  right_join(dict_TTC_turf) %>%
  select(-turfID.new, -cover, -presence, -species) %>%
  distinct() %>%
  full_join(scBryo %>% rename(total_bryophytes = totalBryophytes, vegetation_height = vegetationHeight, moss_height = mossHeight), by = "turfID", suffix = c(".old", "")) %>%
  select(-total_bryophytes.old, -moss_height.old, -vegetation_height.old, -TTtreat.old, -litter)


# join FunCab with TTC data
composition2 <- composition %>%
  mutate(blockID = paste0(substr(siteID, 1, 3), blockID)) %>%
  full_join(control_community, by = c("siteID", "blockID", "turfID", "treatment", "year", "species"), suffix = c("", ".new")) %>%
  mutate(cover = coalesce(cover.new, cover),
         recorder = coalesce(recorder.new, recorder),
         total_bryophytes = coalesce(total_bryophytes.new, total_bryophytes),
         vegetation_height = coalesce(vegetation_height.new, vegetation_height),
         moss_height = coalesce(moss_height.new, moss_height)) %>%
  select(-cover.new, -total_bryophytes.new, -vegetation_height.new, -moss_height.new, -recorder.new, -turfID.new) %>%
  mutate(turfID = if_else(grepl("TTC", turfID), turfID, substring(turfID, 4, n())),
         treatment = gsub(" ", "", treatment),
         turfID = paste0(str_sub(siteID, 1, 3), turfID),
         species = gsub(" ", ".", species),
         blockID = if_else(turfID == "Gud12C", "12", blockID)) %>%
  distinct()

####----------- corrections for missing covers -----------####
# mean of previous and next year
sampling_year <- composition2 %>%
  group_by(turfID) %>%
  distinct(turfID, year) %>%
  arrange(turfID, year) %>%
  mutate(sampling = 1:n())

# impute missing total graminoid covers
missFG_cov <- composition2 %>%
  pivot_longer(c("total_bryophytes", "total_graminoids", "total_forbs"), names_to = "FG", values_to = "totCov")

# impute missing total functional group covers
missFG_cov <- missFG_cov %>%
  group_by(turfID, treatment, FG) %>%
  filter(is.na(totCov)) %>%
  distinct(siteID, blockID, turfID, year, treatment, totCov) %>%
  left_join(sampling_year) %>%
  left_join(
    left_join(filter(missFG_cov, !is.na(totCov)), sampling_year),
    by = c("turfID", "FG"),
    suffix = c("", "_cover")) %>% #join to other years
  distinct(siteID, blockID, turfID, year, treatment_cover, year_cover, treatment, totCov, totCov_cover, sampling, sampling_cover) %>%
  filter(abs(sampling - sampling_cover) == 1) %>% #next/previous year
  group_by(siteID, blockID, treatment, turfID, year, FG) %>%
  filter(n() == 2) %>% #need before and after year
  summarise(totCov = mean(totCov_cover), flag = "Subturf w/o cover. Imputed as mean of adjacent years") %>%
  pivot_wider(names_from = "FG", values_from = "totCov") %>%
  ungroup()


# covers interpolated from cover in year before/after
missingCov <- composition2 %>%
  group_by(turfID, species, treatment) %>%
  filter(!is.na(presence) & is.na(cover)) %>%
  select(siteID, blockID, turfID, year, species, treatment)

missingCov <- missingCov %>%
  left_join(sampling_year) %>%
  left_join(
    left_join(filter(composition2, !is.na(cover)), sampling_year),
    by = c("turfID", "species"),
    suffix = c("", "_cover")) %>% #join to other years
  filter(abs(sampling - sampling_cover) == 1) %>% #next/previous year
  group_by(siteID, blockID, treatment, turfID, species, year) %>%
  filter(n() == 2) %>% #need before and after year
  summarise(cover = mean(cover), flag = "Subturf w/o cover. Imputed as mean of adjacent years") %>%
  ungroup()

# adding interpolated cover and FG cover corrections
composition2 <- composition2 %>%
  left_join(missingCov %>% select(-flag), by = c("siteID", "blockID", "treatment", "turfID", "species", "year"), suffix = c("", ".new")) %>%
  left_join(missFG_cov %>% select(-flag), by = c("siteID", "blockID", "treatment", "turfID", "year"), suffix = c("", ".new")) %>%
  mutate(cover = coalesce(cover.new, cover),
         total_bryophytes = coalesce(total_bryophytes.new, total_bryophytes),
         total_graminoids = coalesce(total_graminoids.new, total_graminoids),
         total_forbs = coalesce(total_forbs.new, total_forbs)
  ) %>%
  select(-cover.new, -total_bryophytes.new, -total_graminoids.new, total_forbs.new)

misCovSpp <- composition2 %>%
  filter(is.na(cover) & !is.na(presence)) %>%
  distinct(siteID, blockID, treatment, turfID, year, species)

# covers interpolated from site means
misCovSpp2 <- composition2 %>%
  right_join(misCovSpp %>% select(siteID, year, species)) %>%
  group_by(siteID, species, year) %>%
  summarise(cover = mean(cover, na.rm = TRUE)) %>%
  filter(!is.na(cover)) %>%
  right_join(misCovSpp)

composition2 <- composition2 %>%
  left_join(misCovSpp2, by = c("siteID", "blockID", "treatment", "turfID", "species", "year"), suffix = c("", ".new")) %>%
  mutate(cover = coalesce(cover.new, cover)) %>%
  select(-cover.new, -presence) %>%
  filter(!is.na(cover))


####------- compile TTCs from seedclim with FunCaB -------####
# rejoin funcab attributes of the TTCs in 2016 and 2017
composition3 <- composition2 %>%
  left_join(ttcs1516, by = c("siteID", "blockID", "treatment", "turfID", "year", "TTtreat"), suffix = c("", ".new")) %>%
  mutate(total_graminoids = coalesce(total_graminoids.new, total_graminoids),
         total_forbs = coalesce(total_forbs.new, total_forbs),
         total_bryophytes = coalesce(total_bryophytes.new, total_bryophytes),
         vegetation_height = coalesce(vegetation_height.new, vegetation_height),
         moss_height = coalesce(moss_height.new, moss_height)) %>%
  select(-total_bryophytes.new, -vegetation_height.new, -moss_height.new, -total_forbs.new, -total_graminoids.new) %>%
  left_join(ttcs17, by = c("siteID", "blockID", "treatment", "turfID", "year", "TTtreat", "recorder", "acro", "pleuro"), suffix = c("", ".new")) %>%
  mutate(total_graminoids = coalesce(total_graminoids.new, total_graminoids),
         total_forbs = coalesce(total_forbs.new, total_forbs),
         total_bryophytes = coalesce(total_bryophytes.new, total_bryophytes),
         vegetation_height = coalesce(vegetation_height.new, vegetation_height),
         moss_height = coalesce(moss_height.new, moss_height)) %>%
  select(-total_bryophytes.new, -vegetation_height.new, -moss_height.new, -total_forbs.new, -total_graminoids.new)

composition3 <- composition3 %>%
  full_join(FGBs) %>%
  group_by(turfID, year) %>%
  mutate(acro = case_when(!is.na(pleuro) & is.na(acro) ~ 0,
                          TRUE ~ acro),
         pleuro = case_when(!is.na(acro) & is.na(pleuro) ~ 0,
                            TRUE ~ pleuro),
         total_bryophytes = if_else(is.na(total_bryophytes), pleuro + acro, total_bryophytes)) %>%
  ungroup()

# check there are no duplicate species covers
composition3 %>% group_by(turfID, year, species) %>%
  summarise(n = n_distinct(cover)) %>%
  filter(n > 1)
# should be empty

# sum cover from duplicates
composition3 <- composition3 %>%
  group_by(turfID, year, species) %>%
  mutate(n = n_distinct(cover)) %>%
  tidylog::mutate(cover = case_when(n() > 1 ~ sum(cover),
                           TRUE ~ cover)) %>%
  distinct()


####------- compute functional group nomenclature -------####
# functional groups
composition4 <- composition3 %>%
  group_by(turfID, year, species) %>%
  mutate(cover = case_when(
    turfID == "Alr2XC" & year == 2016 & species == "Agr.cap" ~ sum(cover),
    TRUE ~ cover
  )) %>%
  left_join(FG) %>%
  mutate(functional_group = if_else(
    grepl("pteridophyte", functional_group), "forb",
    if_else(grepl("woody", functional_group), "forb", functional_group)))

# sum of covers
composition4 <- composition4 %>%
  mutate(functional_group = if_else(species %in% c("Jun.sp", "Phl.sp", "Luz.tri"), "graminoid",
                                    if_else(species %in% c("Ped.pal", "Pop.tre", "Ste.als", "Ste.sp", "Porub", "Arenaria", "Pilosella"), "forb", functional_group))) %>%
  group_by(turfID, year, functional_group) %>%
  mutate(sumcover = sum(cover))


####----------- clean and correct moss height data -----------####
composition4 <- composition4 %>%
  mutate(moss_height = case_when(
    turfID == 'Alr3G' & year == 2017 ~ 8.6,
    turfID == 'Alr5F' & year == 2017 ~ 17.5,
    turfID == 'Alr5G' & year == 2017 ~ 17.5,
    turfID == 'Fau2F' & year == 2017 ~ 4,
    turfID == 'Alr1C' & year == 2017 ~ 15,
    turfID == 'Ulv2C' & year == 2017 ~ 0,
    turfID == 'Ovs1C' & year == 2017 ~ 21, # mean of 2016 and 2018
    TRUE ~ moss_height),
    vegetation_height = case_when(
      turfID == 'Ulv3B' & year == 2017 ~ 44.5,
      turfID == 'Arh2FB' & year == 2017 ~ 127.5,
      turfID == 'Ovs1C' & year == 2017 ~ 76.85, # mean of 2016 and 2018
      TRUE ~ vegetation_height),
    total_bryophytes = case_when(
      turfID == 'Alr1FGB' & year == 2015 ~ 0,
      turfID == 'Alr1F' & year == 2015 ~ 0,
      turfID == 'Ovs1C' & year == 2015 ~ 100,
      turfID == 'Fau2C' & year == 2015 ~ 40,
      TRUE ~ total_bryophytes),
    total_forbs = case_when(
      turfID == 'Gud12C' & year == 2015 ~ 70,
      turfID == 'Fau2C' & year == 2015 ~ 65,
      turfID == 'Vik2C' & year == 2015 ~ 60,
      # missing forb covers
      turfID == 'Ulv4G' & year == 2018 ~ 68,
      turfID == 'Ulv4G' & year == 2019 ~ 90,
      turfID == 'Ves3GB' & year == 2019 ~ 60,
      TRUE ~ total_forbs),
    total_graminoids = case_when(
      turfID == 'Gud12C' & year == 2015 ~ 22,
      turfID == 'Vik2C' & year == 2015 ~ 30,
      TRUE ~ total_graminoids)) %>%
  ungroup()

# optional removal of height and cover measurements in plots after treatment
# composition4 <- composition4 %>%
#   mutate(moss_height = case_when(
#   treatment %in% c("GB", "FB", "FGB", "B") & year > 2015 ~ NA_real_,
#   TRUE ~ moss_height
# )) %>%
#   mutate(total_bryophytes = case_when(
#     treatment %in% c("GB", "FB", "FGB", "B") & year > 2015 ~ NA_real_,
#     TRUE ~ total_bryophytes
#   ))



# prettify
comp2 <- composition4 %>%
  distinct(year, siteID, blockID, treatment, turfID, total_graminoids, total_forbs, total_bryophytes, vegetation_height, moss_height, litter, species, cover, functional_group, sumcover, recorder, TTtreat) %>%
  # recode site names
  mutate(siteID = recode(siteID,
                         "Ulvhaugen" = "Ulvehaugen",
                         "Skjellingahaugen" = "Skjelingahaugen",
                         "Ovstedal" = "Ovstedalen"),
         # fix species
         species = recode(species,
                          "Sax.aiz." = "Sax.aiz",
                          "Hyp.sp." = "Hyp.sp",
                          "Arenaria" = "Are.sp",
                          "Pilosella" = "Pil.sp",
                          "Porub" = "NID.herb",
                          "CAR.KEY" = "Car.sp",
                          "Cre.tre" = "NID.herb",
                          "Crepis" = "Cre.sp",
                          "Juniper" = "Juni.sp",
                          "Maianthemum" = "Mai.sp",
                          "Myosotis.str" = "Myo.sp",
                          "Pedicularis" = "Ped.sp",
                          "Pri.mula" = "Pri.sp"),
         # some blockID are only numbers
         blockID = if_else(str_detect(blockID, "^[:digit:]+$"), paste0(substr(siteID, 1, 3), blockID), blockID)) %>%
  # fix missing functional group
  mutate(functional_group = case_when(species %in% c("Cre.sp", "Cre.tec", "Hyp.sp", "Mai.sp", "Myo.sp", "NID.herb", "Ped.sp", "Pri.sp", "Ran.pyg", "Ran.sp", "Sax.aiz", "Juni.sp", "Sal.rep") ~ "forb",
                                      species %in% c("Aco.sp", "Car.atro", "Car.dem", "Car.sp") ~ "graminoid",
                                      TRUE ~ functional_group)) %>%
  # remove total_bryophytes that should not be there
  mutate(total_bryophytes = if_else(year != 2015 & treatment %in% c("FGB", "FB", "GB", "B"), NA_real_, total_bryophytes),
         # same for total_forbs and graminoids
         total_forbs = if_else(year != 2015 & treatment %in% c("FGB", "FB", "GF", "F"), NA_real_, total_forbs),
         total_graminoids = if_else(year != 2015 & treatment %in% c("FGB", "GB", "GF", "G"), NA_real_, total_graminoids)) %>%
  # add column for pre/post removal
  mutate(removal = if_else(year == 2015, "pre", "post")) %>%
  # fix duplicates
  mutate(turfID = if_else(year == 2017 & turfID == "Arh2GF" & total_bryophytes == 80, "Arh1GF", turfID)) |>
  filter(!(turfID == "Arh3FGB" & year == 2017 & recorder == "FJ")) |>
  filter(!(turfID == "Vik4FGB" & year == 2019 & recorder == "Aud/JH")) |>
  select(year, siteID, blockID, plotID = turfID, removal, treatment, total_graminoids:litter, species, cover, functional_group, sumcover, recorder, turfID = TTtreat)

# save secondary/derived data
write_csv(comp2, file = "data/community/FunCaB_clean_composition_2015-2019.csv")
