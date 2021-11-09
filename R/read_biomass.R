#############################################################
### READ IN FUNCTIONAL REMOVAL BIOMASS DATA - 2015 - 2021 ###
#############################################################

source("R/load_packages.R")

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
         block = if_else(year %in% c(2019) & site == "Rambera" & block == 7, 6, block)
         ) %>%
  mutate(block = paste0(substr(site, 1, 3), block),
         plotID = paste0(block, treatment)) %>%
  select(year, date, round, siteID = site, blockID = block, plotID, treatment, removed_fg, biomass, name, remark)


write_csv(biomass, file = "data/biomass/FunCaB_biomass_clean_2015-2021.csv")

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


# Data viz
biomass_plot <- biomass %>%
  mutate(treatment = factor(treatment, levels = c("B", "F", "G", "FB", "GB", "FG", "FGB")),
         biogeographic_zone = recode(siteID,
                             Ulvehaugen = "alpine",
                             Lavisdalen = "alpine",
                             Gudmedalen = "alpine",
                             Skjelingahaugen = "alpine",
                             Alrust = "sub.alpine",
                             Hogsete = "sub.alpine",
                             Rambera = "sub.alpine",
                             Veskre = "sub.alpine",
                             Fauske = "boreal",
                             Vikesland = "boreal",
                             Arhelleren = "boreal",
                             Ovstedalen = "boreal"),
        prep_level = recode(siteID,
                               Ulvehaugen = 1,
                               Lavisdalen = 2,
                               Gudmedalen = 3,
                               Skjelingahaugen = 4,
                               Alrust = 1,
                               Hogsete = 2,
                               Rambera = 3,
                               Veskre = 4,
                               Fauske = 1,
                               Vikesland = 2,
                               Arhelleren = 3,
                               Ovstedalen = 4),
        climate = paste0(biogeographic_zone, prep_level),
        climate = factor(climate, levels = c("boreal1", "boreal2", "boreal3", "boreal4", "sub.alpine1", "sub.alpine2", "sub.alpine3", "sub.alpine4", "alpine1", "alpine2", "alpine3", "alpine4"))) %>%
  ggplot(aes(x = treatment, y = biomass, fill = removed_fg)) +
  geom_col() +
  scale_fill_manual(name = "Functional group", values = c("orange", "purple", "limegreen")) +
  labs(x = "Removed functional group", y = "Biomass in g") +
  facet_grid(year ~ climate) +
  theme_bw() +
  theme(legend.position="top")

#ggsave("biomass_plot.jpeg", biomass_plot, dpi = 150, width = 15, height = 10)
