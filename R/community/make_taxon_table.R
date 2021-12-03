# load required packages
source("R/load_packages.R")

library(DBI)
library(RSQLite)

# Make taxon table

community <- read_csv("data/community/FunCaB_clean_composition_2015-2019.csv")

# connect to database
con <- src_sqlite(path = "data/community/raw/seedclim.sqlite", create = FALSE)

full_taxon <- tbl(con, "taxon") %>%
  select(species, species_name, family) %>%
  collect()

missing_family <- tribble(
  ~species, ~species_name_new, ~family_new, ~functional_group,
  "Are.sp", "Arenaria sp", "Caryophyllaceae", "forb",
  "Cre.sp", "Crepis sp.", "Asteraceae", "forb",
  "Cre.tec", "Crepis tectorum", "Asteraceae", "forb",
  "Hyp.sp", "Hypericum sp.", "Hypericaceae", "forb",
  "Mai.sp", "Maianthemum sp", "Asparagaceae", "forb",
  "Myo.sp", "Myosotis sp.", "Boraginaceae", "forb",
  "Ped.sp", "Pedicularis sp.", "Orobanchaceae", "forb",
  "Pil.sp",    "Pilosella sp.", "Asteraceae" , "forb",
  "Pri.sp", "Primula sp.", "Primulaceae", "forb",
  "Ran.pyg", "Ranunculus pygmaeus", "Ranunculaceae", "forb",
  "Ran.sp", "Ranunculus sp.", "Ranunculaceae", "forb",
  "Ste.als", "Stellaria alsine", "Caryophyllaceae", "forb",
  "Ste.sp","Stellaria sp.", "Caryophyllaceae", "forb",
  "Aco.sp", "Aconitum sp.", "Poaceae", "graminoid",
  "Car.atro", "Carex atrofusca", "Cyperaceae", "graminoid",
  "Car.dem", "Carex demissa", "Cyperaceae", "graminoid",
  "Jun.sp", "Juncus sp.", "Juncaceae", "graminoid",
  "Luz.tri", "Juncus triglumis", "Juncaceae", "graminoid",
  "Phl.sp", "Phleum sp.", "Poaceae", "graminoid",
  "Juni.sp", "Juniperus sp.", "Cupressaceae", "shrub",
  "Sal.rep", "Salix repens", "Salicaceae", "shrub")


taxon_table <- community %>%
  filter(!species %in% c("NID.gram", "NID.herb", "NID.seedling")) %>%
  filter(!is.na(species)) %>%
  distinct(species, functional_group) %>%
  left_join(full_taxon, by = "species") %>%
  left_join(missing_family, by = c("species", "functional_group")) %>%
  mutate(species_name = if_else(is.na(species_name), species_name_new, species_name),
         family = if_else(is.na(family), family_new, family)) %>%
  arrange(functional_group, family, species) %>%
  select(species, species_name, family, functional_group)

write_csv(taxon_table, "data/community/FunCaB_taxon_table.csv")

