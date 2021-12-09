############################
 #### MAKE DARWIN CORE ####
############################


# Install the Living Norway package from the Git repository
#devtools::install_github("https://github.com/LivingNorway/LivingNorwayR")
# Import the tools into R
library(LivingNorwayR)


#import all datasets
read_csv(file = "")


# event core
# Parent event core is site, block, plot, time combinations
# Child event is different measurements on the plots

# extention tables
# https://tools.gbif.org/dwca-validator/extensions.do

# Occurence table = species composition data

# https://tools.gbif.org/dwca-validator/extension.do?id=http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact
# measurements or fact tables: soil temp, soil moisture and other measruements

# occurrence table
# https://rs.gbif.org/extension/gbif/1.0/releve_2016-05-10.xml

# relationships - species interactions
# https://rs.gbif.org/extension/dwc/resource_relation.xml

# make uuid for event ID
# https://cran.r-project.org/web/packages/uuid/index.html
