#############################################################
### READ IN FUNCTIONAL REMOVAL BIOMASS DATA - 2015 - 2021 ###
#############################################################

source("R/load_packages.R")
library(janitor)

#Download data from OSF
# run the code from L10-L17 if you need to download the data from OSF

# install.packages("remotes")
# remotes::install_github("Between-the-Fjords/dataDownloader")
# library(dataDownloader)

# get_file(node = "4c5v2",
#          file = "FunCaB_raw_biomass_2021-11-02.xlsx",
#          path = "data/biomass",
#          remote_path = "Vegetation/Functional Group Biomass Removals")



path <- "data/biomass/FunCaB_raw_biomass_2021-11-02.xlsx"

biomass_raw <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map_df(read_excel, path = path, col_types = c("numeric", "text", "numeric", "text", "text", "date", "text", "numeric", "text", "text"))


# impute missing rounds
impute_round = tribble(
  ~year, ~site, ~block, ~round_new,
  2016, "ALR", list(5), "2",
  2016, "ARH", list(1, 2, 3, 4), "1",
  2016, "FAU", list(1, 2, 4, 5), "1",
  2016, "RAM", list(4, 5, 6, 8), "1",
  2016, "VIK", list(2, 3, 4, 5), "1"
) %>%
  unchop(block) %>%
  mutate(block = unlist(block))

# add missing dates in 2018
missing_dates = tribble(
  ~year, ~site, ~newdate,
  2018, "OVS", "2018-07-03",
  2018, "ARH", "2018-07-04",
  2018, "ULV", "2018-08-09",
  2018, "SKJ", "2018-08-16",
  2018, "FAU", "2018-07-10",
  2018, "LAV", "2018-08-14",
  2018, "HOG", "2018-07-05",
  2018, "VES", "2018-08-06",
  2018, "RAM", "2018-08-07",
  2018, "ALR", "2018-07-12",
  2018, "GUD", "2018-08-15",
  2018, "OVS", "2018-07-03",
  2018, "VIK", "2018-07-05"
) %>%
  mutate(newdate = ymd(newdate))


biomass <- biomass_raw %>%
  rename(year = Year, date = Date, site = Site, block = Block, treatment = Treatment, removed_fg = "Removed functional group", round = Round, biomass = Biomass, name = Name, remark = Remark) %>%
  select(year, date, site, block, treatment, removed_fg, round, biomass, name, remark) %>%
  mutate(site = recode(site, "OVSen" = "OVS"),
         round = str_sub(round, start = -1),
         date = as.Date(date)) %>%
  # impute missing info on round
  left_join(impute_round, by = c("year", "site", "block")) %>%
  mutate(round = if_else(is.na(round), round_new, round)) %>%
  select(-round_new) %>%
  # remove RTCs
  filter(treatment != "RTC") %>%
  # add missing block
  mutate(block = if_else(year == 2019 & site == "ARH" & is.na(block), 4,   block)) %>%
  # fix wrong blocks and duplicates
  mutate(block = if_else(year == 2015 & site == "ALR" & block == 4, 5, block),
         block = if_else(year == 2016 & site == "ALR" & block == 1 & name == "Olav", 2, block),
         block = if_else(year == 2017 & site == "ALR" & block == 1 & name == "Anja Petek", 2, block),
         block = if_else(year == 2019 & site == "HOG" & block == 3 & treatment == "F" & name == "PS", 4, block),
         block = if_else(year == 2019 & site == "ULV" & block %in% c(4, 5, 6) & name == "IA", 3, block),
         block = if_else(year == 2019 & site == "VES" & block == 3 & treatment == "FGB" & name == "PS", 4, block)) %>%
  # wrong treatment and removed_fg
  mutate(treatment = if_else(year == 2019 & site == "VIK" & block == 5 & biomass == 0.57 & name == "VG", "FB", treatment),
         removed_fg = if_else(year == 2019 & site == "VIK" & block == 2 & biomass == 1.77 & name == "sari", "F", removed_fg),
         removed_fg = if_else(year == 2019 & site == "GUD" & block == 12 & biomass == 0.56 & name == "PS", "G", removed_fg),
         removed_fg = if_else(year == 2019 & site == "GUD" & block == 12 & biomass == 0.17 & name == "PS", "B", removed_fg),
         removed_fg = if_else(year == 2019 & site == "GUD" & block == 12 & biomass == 0.89 & name == "PS", "G", removed_fg),
         treatment = if_else(year == 2019 & site == "SKJ" & block == 2 & biomass %in% c(0.43, 1.84) & name == "sari", "FB", treatment)) %>%
  # add missing dates
  left_join(missing_dates, by = c("year", "site")) %>%
  mutate(date = if_else(is.na(date), newdate, date)) %>%
  # change site names
  mutate(site = recode(site, "ULV" = "Ulvehaugen",
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
         # fix wrong block names in GUD and RAM
         block = if_else(year %in% c(2018, 2020, 2021) & site == "Rambera" & block == 7, 8, block),
         block = if_else(year %in% c(2019) & site == "Rambera" & block == 7, 6, block),
         block = if_else(year %in% c(2015) & site == "Gudmedalen" & block == 1, 5, block),
         block = if_else(year %in% c(2015) & site == "Gudmedalen" & block == 2, 12, block),
         block = if_else(year %in% c(2015) & site == "Gudmedalen" & block == 3, 13, block),
         block = if_else(year %in% c(2015) & site == "Gudmedalen" & block == 4, 15, block)
         ) %>%
  mutate(block = paste0(substr(site, 1, 3), block),
         plotID = paste0(block, treatment),
         treatment = recode(treatment, "FG" = "GF")
         ) %>%
  # remove NAs
  filter(!is.na(biomass)) %>%
  select(year, date, round, siteID = site, blockID = block, plotID, treatment, removed_fg, biomass, name, remark)

# dates for 2 round in 2016
date16 <- biomass %>%
  filter(year == 2016,
         round == "2") %>%
  distinct(siteID, date) %>%
  group_by(siteID) %>%
  slice(1)

### BIOMASS FROM EXTRA PLOTS ###

# Species level data

biomax_sp_raw <- read_excel("data/biomass/FunCaB_raw_extra_biomass_2016.xlsx", sheet = "forbs")

biomax_sp_wide <- biomax_sp_raw %>%
  clean_names() %>%
  rename(siteID = site_id, plotID = plot_id, biomass = dry_weight) %>%
  mutate(treatment = "XC",
         siteID = recode(siteID,
                         "Skjellinghaugen" = "Skjelingahaugen",
                         "Ovstedal" = "Ovstedalen",
                         "Ulvhaugen" = "Ulvehaugen"),
         treatment = "XC",
         blockID = str_remove(plotID, "XC"),
         blockID = paste0(substr(siteID, 1, 3), blockID),
         plotID = paste0(blockID, treatment)) %>%
  filter(plotID != "Ves5XC") %>%
  mutate(functional_group = "forb")

# get forb data
forbs <- biomax_sp_wide %>%
  group_by(year, siteID, blockID, plotID, treatment, functional_group) %>%
  summarise(biomass = sum(biomass)) %>%
  mutate(removed_fg = "F")

# other plant functional groups
biomax_raw <- read_excel("data/biomass/FunCaB_raw_extra_biomass_2016.xlsx",
                         sheet = "all other functional groups")

biomax <- biomax_raw %>%
  rename(functional_group = `functional group`, biomass = `dry weight`, comment = `...9`) %>%
  mutate(treatment = "XC",
         siteID = recode(siteID,
                         "Oustedal" = "Ovstedalen",
                         "Ovstedal" = "Ovstedalen"),
         blockID = str_remove(blockID, "XC"),
         blockID = paste0(substr(siteID, 1, 3), blockID),
         plotID = paste0(blockID, treatment),
         removed_fg = recode(functional_group, "graminoids" = "G",
                             "forbs" = "F",
                             "bryophytes" = "B",
                             "litter" = "L",
                             "lichens" = "LI",
                             "cryptograms" = "C",
                             "pteridophytes" = "P")) %>%
  # remove extra extra plot
  filter(blockID != "Ves5",
         # need to remove forbs because not complete
         functional_group != "forbs") %>%
  # get forbs from species level data
  bind_rows(forbs) %>%
  # add collection data
  left_join(date16, by = "siteID") %>%
  select(year, date, siteID, blockID, plotID, treatment, removed_fg, functional_group, biomass)

biomass <- biomass %>%
  bind_rows(biomax)

write_csv(biomass, file = "data/biomass/FunCaB_clean_biomass_2015-2021.csv")
#
# ggplot(biomax, aes(x = siteID, y = biomass, fill = functional_group)) +
#   geom_col() +
#   #scale_fill_manual(name = "Functional group", values = c("orange", "purple", "limegreen")) +
#   labs(x = "Removed functional group", y = "Biomass in g") +
#   theme_bw() +
#   theme(legend.position="top")





biomass_sp <- biomax_sp_wide %>%
  pivot_longer(-c(siteID:biomass, treatment, blockID), names_to = "species", values_to = "value") %>%
  filter(value == "x") %>%
  # fix species names
  mutate(species = str_to_title(species),
         species = str_replace(species, "_", "."),
         species = if_else(species %in% c("Remaining_biomass", "Not_selaginella"), "NID.herb", species),
         species = recode(species,
                          "Aci.mill" = "Ach.mil",
                          "Alch.sp" = "Alc.sp",
                          "Anagallis" = "Ana.sp",
                          "Bart.alp" = "Bar.alp",
                          "Bart.sp" = "Bar.sp",
                          "Dwarf.shrub" = "NID.herb",
                          "Emp" = "Emp.sp",
                          "Euph.sp" = "Eup.sp",
                          "Frag.ves" = "Fra.ves",
                          "Hyp.mac" = "Hype.mac",
                          "Pyrola.sp" = "Pyr.sp",
                          "Rhin.min" = "Rhi.min",
                          "Rhin.sp" = "Rhi.sp",
                          "Rubus" = "Rub.sp",
                          "Rum.ac_la" = "Rum.acl",
                          "Salix.sp" = "Sal.sp",
                          "Saus.alp" = "Sau.sp",
                          "Tarax" = "Tar.sp",
                          "NID.shrub" = "NID.herb",
                          "Not.selaginella" = "NID.herb",
                          "Remaining.biomass" = "NID.herb"

         )) %>%
  mutate(species = if_else(species == "Heo.sp" & blockID == "Ves4", "Leo.sp", species),
         species = if_else(species == "Heo.sp" & blockID == "Ram1", "Leo.sp", species)) %>%
  # sum biomass for species that merged or not available (Ves, Ovs, Ram)
  group_by(year, siteID, blockID, plotID, treatment, functional_group, species, sorted_by) %>%
  summarise(biomass = sum(biomass)) %>%
  relocate(sorted_by, .after = biomass) %>%
  ungroup()

write_csv(biomass_sp, file = "data/biomass/FunCaB_clean_species_biomass_2016.csv")

### DATA VALIDATION
# find duplicates
# rule <- validator(is_unique(year, site, block, treatment, removed_fg, round))
# out <- confront(biomass, rule)
# # showing 7 columns of output for readability
# summary(out)
# violating(biomass, out) %>% View()

# missing treatment or removed_fg
#biomass %>% count(year, site, block, round) %>% filter(n < 12) %>% View()

### missing data
#biomass %>% filter(is.na(biomass)) %>% View()
# 2016 round 1 /2 ALR 5 values missing
