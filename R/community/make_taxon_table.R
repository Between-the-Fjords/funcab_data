# load required packages
source("R/load_packages.R")

library(DBI)
library(RSQLite)

# Make taxon table

community <- read_csv("data/community/FunCaB_clean_composition_2015-2019.csv")

biomass_sp <- read_csv("data/biomass/FunCaB_clean_species_biomass_2016.csv")

seedlings <- read_csv("data/recruitment/FunCaB_clean_recruitment_2018-2019.csv")

# connect to database
con <- src_sqlite(path = "data/community/raw/seedclim.sqlite", create = FALSE)

full_taxon <- tbl(con, "taxon") %>%
  select(species, species_name, family) %>%
  collect()

missing_family <- tribble(
  ~species, ~species_name_new, ~family_new, ~functional_group,
  "Are.sp", "Arenaria sp.", "Caryophyllaceae", "forb",
  "Ana.sp", "Anagallis sp.", "Primulaceae", "forb",
  "Cre.sp", "Crepis sp.", "Asteraceae", "forb",
  "Bar.sp", "Bartsia sp.", "Orobanchaceae", "forb",
  "Cre.tec", "Crepis tectorum", "Asteraceae", "forb",
  "Cam.sp", "Campanula sp.", "Campanulaceae", "forb",
  "Hyp.sp", "Hypericum sp.", "Hypericaceae", "forb",
  "Dac.mac", "Dactylorhiza maculata", "Orchidaceae", "forb",
  "Mai.sp", "Maianthemum sp", "Asparagaceae", "forb",
  "Gal.sp", "Galium sp.", "Rubiaceae", "forb",
  "Myo.sp", "Myosotis sp.", "Boraginaceae", "forb",
  "Ped.sp", "Pedicularis sp.", "Orobanchaceae", "forb",
  "Leu.sp", "Leucanthemum sp.", "Asteraceae", "forb",
  "Pil.sp", "Pilosella sp.", "Asteraceae" , "forb",
  "Pol.viv", "Bistorta vivipara", "Polygonaceae", "forb",
  "Pri.sp", "Primula sp.", "Primulaceae", "forb",
  "Pot.sp", "Potentilla sp.", "Rosaceae", "forb",
  "Ran.pyg", "Ranunculus pygmaeus", "Ranunculaceae", "forb",
  "Ran.sp", "Ranunculus sp.", "Ranunculaceae", "forb",
  "Rhi.sp", "Rhinanthus minor", "Orobanchaceae", "forb",
  "Ste.als", "Stellaria alsine", "Caryophyllaceae", "forb",
  "Rub.sp", "Rubus sp.", "Rosaceae", "forb",
  "Ste.sp","Stellaria sp.", "Caryophyllaceae", "forb",
  "Sag.pro", "Sagina procumbens", "Caryophyllaceae", "forb",
  "Aco.sp", "Aconitum sp.", "Poaceae", "graminoid",
  "Sau.sp", "Saussurea alpina", "Asteraceae", "forb",
  "Car.atro", "Carex atrofusca", "Cyperaceae", "graminoid",
  "Car.dem", "Carex demissa", "Cyperaceae", "graminoid",
  "Jun.sp", "Juncus sp.", "Juncaceae", "graminoid",
  "Luz.tri", "Juncus triglumis", "Juncaceae", "graminoid",
  "Phl.sp", "Phleum sp.", "Poaceae", "graminoid",
  "Juni.sp", "Juniperus sp.", "Cupressaceae", "forb",
  "Sal.rep", "Salix repens", "Salicaceae", "forb",
  "Min.sp", "Minuartia sp.", "Caryophyllaceae", "forb",
  "Emp.sp", "Empetrum sp.", "Ericaceae", "forb",
  "Bet.sp", "Betula sp.", "Betulaceae", "forb",
  "Ane.sp", "Anemone sp.", "Ranunculaceae", "forb",
  "Ant.sp", "Antennaria sp.", "Asteraceae", "forb",
  "Bel.sp", "Bellis sp.", "Asteraceae", "forb",
  "Hype.sp", "Hypericum sp.", "Hypericaceae", "forb",
  "Leo.sp", "Leontodon sp.", "Asteraceae", "forb",
  "Oma.sp", "Omalotheca sp.", "Asteraceae", "forb",
  "Rum.sp", "Rumex sp.", "Polygonaceae", "forb"
  )



taxon_table <- bind_rows(
  community = community %>%
    filter(!species %in% c("NID.gram", "NID.herb", "NID.seedling")) %>%
    filter(!is.na(species)),
  biomass = biomass_sp %>%
    filter(!species == "NID.herb"),
  seedlings = seedlings %>%
    filter(!species == "NID.seedling"),
  .id = "dataset") %>%
  distinct(dataset, functional_group, species) %>%
  left_join(full_taxon, by = "species") %>%
  left_join(missing_family, by = c("species", "functional_group")) %>%
  mutate(species_name = if_else(is.na(species_name), species_name_new, species_name),
         family = if_else(is.na(family), family_new, family)) %>%
  mutate(x = "x") %>%
  pivot_wider(names_from = dataset, values_from = x) %>%
  select(functional_group, family, species_name, species, biomass, community, seedlings) %>%
  arrange(functional_group, family, species)

write_csv(taxon_table, "data/community/FunCaB_taxon_table.csv")

