#############################################################
### READ IN FUNCTIONAL REMOVAL BIOMASS DATA - 2015 - 2021 ###
#############################################################

source("R/load_packages.R")

#Download data from OSF
# run the code from L10-L13 if you need to download the data from OSF

# get_file(node = "4c5v2",
#          file = "FunCaB_raw_biomass_2015_2021.csv",
#          path = "data/biomass",
#          remote_path = "Vegetation data/Functional Group Biomass Removals")



path <- "data/biomass/FunCaB_raw_biomass.xlsx"

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


biomass <- biomass_raw %>%
  rename(year = Year, date = Date, site = Site, block = Block, treatment = Treatment, removed_fg = "Removed functional group", round = Round, biomass = Biomass, name = Name, remark = Remark) %>%
  select(year, date, site, block, treatment, removed_fg, round, biomass, name, remark) %>%
  mutate(site = recode(site, "OVSen" = "OVS"),
         round = str_sub(round, start = -1)) %>%
  # impute missing info on round
  left_join(impute_round, by = c("year", "site", "block")) %>%
  mutate(round = if_else(is.na(round), round_new, round)) %>%
  select(-round_new) %>%
  # remove RTCs
  filter(treatment != "RTC") %>%
  # add missing block
  mutate(block = if_else(year == 2019 & site == "ARH" & is.na(block), 4,   block))


# find duplicates
rule <- validator(is_unique(year, site, block, treatment, removed_fg, round))
out <- confront(biomass, rule)
# showing 7 columns of output for readability
summary(out)
violating(biomass, out) %>% View()
# FIX DUPLICATES!!! Needs checking of the raw data!


### missing data
# 2015 round 1 Arh RTC 4
# 2016 round 1 /2 ALR 5 values missing
# 2017 round 2 FAU, VIK, ARH missing data, probably not weighed. FOUND!!!
# 2017 missing biomass and other info from ALR 2 (FOUND!!!), HOG 2 (FOUND!!!), LAV 2, ULV 2, GUD 2
# 2018, 2020 some missing, but already indicated
# 2019 all data missing
# 2021 some sites missing

biomass %>% filter(is.na(biomass), !year %in% c(2021)) %>% View()

biomass %>%
  mutate(treatment = factor(treatment, levels = c("B", "F", "G", "FB", "GB", "FG", "FGB"))) %>%
  filter(year != 2019, removed_fg != "C") %>%
  ggplot(aes(x = treatment, y = biomass, fill = removed_fg)) +
  geom_col() +
  facet_grid(year ~ site) +
  theme_bw()

