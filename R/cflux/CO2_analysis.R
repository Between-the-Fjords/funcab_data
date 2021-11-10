### C flux data cleaing

source("R/load_packages.R")
library(lattice)

#source functions for import/proces and calculation of CO2 flux
source("R/cflux/functions/import_process_CO2data.R")
source("R/cflux/functions/CO2flux_calculation.R")
#source("R/cflux/functions/CO2flux_calculation2015.R")
source("R/cflux/functions/CO2_plot.R")
source("R/cflux/functions/import_process_SQlogger.R")


# get specific functions from plyr by using plyr::ldply
#====================================================================================================================
# importing single datafiles, process and set new start and end times.
#TEST DATASET for automated quality check
#temp.data<-read.ibutton("CO2/Data/Temperature_files_2016/20160607_FAU_CH1_TEMP.txt")
#log.data<-read.logger("CO2/Data/Fluxdata2016_Li1400/20160607_FAU_LI1400_CH1_1.txt")
#meta.data<-read.metadata("CO2/Data/metadata_2016/07062016_FAU_ch1_1.txt")
#combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)

#Set new start and stoptime for measurement, always indicate start and stop value with numbers otherwise inf as stoptime!
#TESTDATA<-setStartEndTimes(combine.data) # returns a list of which measurements to keep/ discard after setting new start/stoptime
#outlier.filter(combine.data)

#x$dat$keep = TRUE for newly set start and endtimes FALSE for ommited measurement points
# fluxcalc should use data for $dat$keep ==TRUE


#import all pre removal datafiles from 2015 and all datafiles of 2016
sites.data.2015<-read.sitefiles("data/cflux/Cflux data/data_files_2015_pre.xlsx")
#sites.data.2016<-read.sitefiles("CO2/Data/data_files_2016new.xlsx") #!Li1400 data
sites.data.2016Li1400<-read.sitefiles("data/cflux/Cflux data/datafiles_2016_cleaned.xlsx")#!Li1400 dataflagged outliers+new times
sites.data.2016SQ<- read.sitefiles.SQ("data/cflux/Cflux data/datafiles_2016_SQ.xlsx") #!SQ dataflagged outliers+new times

# Run fluxcalculation on all datafiles of 2015
#fluxcalc(sites.data.2015[[1]]) #calculate flux 1 plot
overviewsitesdata_2015<-do.call(rbind, lapply(sites.data.2015, fluxcalc2015)) #calculate flux for all pre-removal data 2015
overviewsitesdataLi1400_2016<-do.call(rbind, lapply(sites.data.2016Li1400, fluxcalc2015)) #calculate flux for all data 2016
overviewsitesdataSQ_2016<-do.call(rbind, lapply(sites.data.2016SQ, fluxcalc2015)) #calculate flux for all data 2016
overviewsitesdata_2015[,9:10]<- NA #recode airpress and vegbiomass to NA, because these columns will be changed to SoilT and vegHeight

# bind together 2016 from li1400 and SQ logger
overviewsitesdata_2016<- rbind(overviewsitesdataSQ_2016, overviewsitesdataLi1400_2016)
# bind together 2015 and 2016 data
CO2data_1516<- rbind(overviewsitesdata_2016, overviewsitesdata_2015)

### rename turfID Control plots of 2015/ 2016 data from FC coding to TTC coding if plot is a TTC control
CO2data_1516 <- CO2data_1516 %>%
  mutate(site = recode(site, ULV = "Ulv", ALR = "Alr", FAU = "Fau", LAV = "Lav", HOG = "Hog", VIK = "Vik", GUD = "Gud", RAM = "Ram", ARH = "Arh", SKJ = "Skj", VES = "Ves", OVS = "Ovs")) %>%
  mutate(turfID=paste0(site, block, treatment))
CO2data_1516$date<- as.Date(CO2data_1516$date, format="%d.%m.%Y") # change date format from character to Date
CO2data_1516$block<- as.character(CO2data_1516$block)
CO2data_1516$X<- seq.int(nrow(CO2data_1516))


##### Rename TTC plots
#dict_TTC <- read.table(header = TRUE, stringsAsFactors = FALSE, text =
                         "new old
                       51TTC Fau1C
                       57TTC Fau2C
                       68TTC Fau4C
                       73TTC Fau5C
                       29TTC Alr1C
                       31TTC Alr2C
                       134TTC Vik2C
                       140TTC Vik3C
                       141TTC Vik4C
                       146TTC Vik5C
                       101TTC Hog1C
                       110TTC Hog2C
                       115TTC Hog3C
                       286TTC Ovs1C
                       291TTC Ovs2C
                       297TTC Ovs3C
                       211TTC Arh1C
                       222TTC Arh3C
                       226TTC Arh4C
                       263TTC Ves1C
                       281TTC Ves5C
                       281TTC Ves4C
                       194TTC Ram4C
                       198TTC Ram5C
                       6TTC Ulv2C
                       11TTC Ulv3C
                       236TTC Skj1C
                       243TTC Skj2C
                       246TTC Skj3C
                       251TTC Skj4C
                       511TTC Gud12C
                       46TTC Alr4TTC
                       307TTC Ovs5TTC
                       216TTC Arh2TTC
                       61TTC Fau3TTC
                       78TTC  Lav1TTC
                       85TTC  Lav2TTC
                       87TTC  Lav3TTC
                       94TTC  Lav4TTC
                       99TTC  Lav5TTC")

#CO2data_1516 <- CO2data_1516 %>%
#  mutate(turfID = plyr::mapvalues(turfID, from = dict_TTC$old, to = dict_TTC$new))


# add mean soil moisture to each CO2flux measurement
Soilmoisture<- read_excel("C:\\Users\\ialt\\OneDrive - NORCE\\FunCab\\Data\\soil moisture\\Soilmoisture_2015-2016_clean.xlsx")
Soilmoisture$date<- as.Date(Soilmoisture$date, tz="", format="%Y-%m-%d")
Soilmoisture$Moisture<- as.numeric(Soilmoisture$Moisture)
#Soilmoisture$TurfID <- gsub('\\s+', '', Soilmoisture$TurfID)
Soilmoisture<- Soilmoisture %>%
  mutate(turfID=turfID_FC)

CO2data_1516<- left_join(CO2data_1516, Soilmoisture, by = c("date"= "date", "site"= "site", "treatment" = "removal", "block"= "block"))%>%
  distinct(X, .keep_all = TRUE)

CO2data_1516<- CO2data_1516 %>%
  select(-X, -treatment.y, -blockSD, -M1, -M2, -M3, -M4, -weather, -recorder, -comments, -turfID.y)
CO2data_1516<- CO2data_1516 %>%
  rename(turfID = turfID.x)

#missing_soilM <- CO2data_1516[is.na(CO2data_1516$Moisture),]
#unique(missing_soilM$turfID)

CO2data_1516$treatment<- as.factor(CO2data_1516$treatment) #change treatment to factor
CO2data_1516$date<- as.Date(CO2data_1516$date, format="%d.%m.%Y") # change date format from character to Date
CO2data_1516$ToD<-format(CO2data_1516$starttime, format="%H") #create new Time of Day column
CO2data_1516$cover<- as.factor(CO2data_1516$cover)
CO2data_1516$lightlevel<-CO2data_1516$cover
levels(CO2data_1516$cover)<- c("D", "L", "L", "L") # convert shade levels S1 and S2 to L

# Add column with year and change airpress and biomass column to numeric
CO2data_1516$year<- format(CO2data_1516$date, "%Y")
CO2data_1516$airpress<- as.numeric(sub(",", ".", CO2data_1516$airpress, fixed = TRUE)) # change to numeric
CO2data_1516$vegbiomass<- as.numeric(sub(",", ".", CO2data_1516$vegbiomass, fixed = TRUE)) # change to numeric
CO2data_1516<-plyr::rename(CO2data_1516, c("airpress"="soilT", "vegbiomass"="vegHeight")) # change column names to correct names

#add columns with precipitation and temperature level for 2015 data
tempV<-c("ALP","ALP","ALP","ALP","SUB","SUB","SUB","SUB","BOR","BOR","BOR","BOR")
names(tempV)<-c("Ulv","Lav","Gud","Skj","Alr","Hog","Ram","Ves","Fau","Vik","Arh","Ovs")
precL<-c("Prec1","Prec2","Prec3","Prec4","Prec1","Prec2","Prec3","Prec4","Prec1","Prec2","Prec3","Prec4")
names(precL)<-c("Ulv","Lav","Gud","Skj","Alr","Hog","Ram","Ves","Fau","Vik","Arh","Ovs")

CO2data_1516$templevel<-tempV[CO2data_1516$site]
CO2data_1516$templevel = factor(CO2data_1516$templevel, levels = c("ALP", "SUB", "BOR"))
CO2data_1516$preclevel<-precL[CO2data_1516$site]
CO2data_1516$preclevel = factor(CO2data_1516$preclevel, levels = c("Prec1", "Prec2", "Prec3", "Prec4"))
CO2data_1516<-CO2data_1516%>%
  mutate(Temp.C = recode(site, Ulv = 6.17, Lav = 6.45,  Gud = 5.87, Skj = 6.58, Alr = 9.14, Hog = 9.17, Ram = 8.77,
                       Ves = 8.67, Fau = 10.3, Vik = 10.55, Arh = 10.6, Ovs = 10.78))%>%
  mutate(P.mm = recode(site, Ulv = 596, Alr = 789, Fau = 600, Lav = 1321, Hog = 1356, Vik = 1161, Gud = 1925,
                       Ram = 1848, Arh = 2044, Skj = 2725, Ves = 3029, Ovs = 2923))


#CO2data_1516$Country <- "NO"
#write.csv(CO2data_1516, "O:\\PFTC_DataHarmony\\Cflux_NO_Gradient_2015-2016.csv")

#seperate L and D measurements and merge them in new file with new column GPP, selecting data with r2>=.8
CO2_NEE_1516<-subset(CO2data_1516, cover== "L" & rsqd>=.8 | cover== "L" & rsqd<=.2)
CO2_RECO_1516<-subset(CO2data_1516, cover== "D" & rsqd>=.8)
CO2_RECO_1516$Reco<-CO2_RECO_1516$nee*-1
CO2_RECO_1516$tempK<-CO2_RECO_1516$temp+273.15
CO2_GPP_1516<- inner_join(CO2_NEE_1516, CO2_RECO_1516, by=c( "chamber", "site", "block", "removal", "treatment", "date", "ToD", "year"))
CO2_GPP_1516$GPP<-CO2_GPP_1516$nee.x- CO2_GPP_1516$nee.y #NEE-Reco


##### Exploratory plots uncleaned data ################################################################################################
# Standardizing uncorrected data, Lloyd & Taylor 1994 , Thornley and Johnson (1990) Plant and Crop Modeling
ggplot(CO2_RECO_1516, aes(x=tempK, y=Reco, col=factor(year)))+
    geom_point(na.rm= TRUE)+
    geom_smooth(method = "nls", formula= y~A*exp(-308.56/I(x-227.13)), method.args = list(start=c(A=0)), se=FALSE, na.rm= TRUE)+
    theme_bw()

ggplot(CO2_GPP_1516, aes(x=PAR.x, y=GPP, col= factor(year)))+
    geom_point(na.rm= TRUE)+
    geom_smooth(method = "nls", formula= y~(A*B*x)/(A*x+B), method.args = list(start=c(A=0.01, B=2)), se=FALSE, na.rm= TRUE)+
    theme_bw()

###########  Data Cleaning  ##########################################################################################
# CLEAN GPP data from negative values and only take control (C), extra control (XC) and RTC (RTC) measurements
# C also contains all the before removal measurements of 2015!
CO2_GPP_1516_clean<- CO2_GPP_1516%>%
  #filter(PAR.x >200)%>% # set minimal PAR value threshold?
  filter(GPP>0) # CLEAN GPP data from negative values

# create dataset for Traits CO2 Analysis by removing graminoid removal plots (RTC) and non FunCaB controls (TTC)
CO2_GPP_1516Trait<-CO2_GPP_1516_clean%>%
  filter(!treatment %in% c("RTC", "TTC"))



write.csv(CO2_GPP_1516_clean, file = "C:\\Users\\ialt\\OneDrive - NORCE\\FunCab\\Data\\FunCaB2\\TraitCO2\\CO2_GPP_1516_cleaned_05112021.csv")

write.csv(CO2_GPP_1516Trait, file = "C:\\Users\\ialt\\OneDrive - NORCE\\FunCab\\Data\\FunCaB2\\TraitCO2\\CO2_GPP_1516Trait_05112021.csv")





###### DO NOT USE THIS CODE, BAYES MODEL INSTEAD!!!!
########### Standardization of fluxdata same equation all data   #####################################################

# recalculate Reco values to longterm summer temperature mean of each site for complete dataset
fit.Reco_ALL<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_RECO_1516Trait) #
#Recalculating Reco to 15C values taking in account heteroscedasticity
CO2_RECO_1516Trait$Reco15<-CO2_RECO_1516Trait$Reco/fitted(fit.Reco_ALL)*(coef(fit.Reco_ALL)*exp(-308.56/I((CO2_RECO_1516Trait$Temp.C+273.15)-227.13)))

#######!!!!!!!!
# recalculate Reco values to a standard temperature for combination of GPP and Reco dataset
fit.R_ALL<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_GPP_1516Trait) #
Reco_all.residual <- resid(fit.R_ALL)
plot(CO2_GPP_1516Trait$Reco, Reco_all.residual)+ abline(0,0)

#Recalculating Reco to 15C values taking in account heteroscedasticity
CO2_GPP_1516Trait$Reco15<-CO2_GPP_1516Trait$Reco/fitted(fit.R_ALL)*(coef(fit.R_ALL)*exp(-308.56/I((CO2_GPP_1516Trait$Temp.C+273.15)-227.13)))
#calculate temperature adjusted Reco by dividing measured Reco by equation with tempature of measurement
CO2_GPP_1516Trait$Reco.Tadj<-CO2_GPP_1516Trait$Reco/(coef(fit.R_ALL)*exp(-308.56/I((CO2_GPP_1516Trait$temp.y+273.15)-227.13)))


# recalculate GPP to standard PAR for GPP
fit.GPP_ALL<-nls((GPP~ (A*B*PAR.x)/(A*PAR.x+B)), start=c(A=0.01, B=2), data=CO2_GPP_1516Trait)
GPP_all.residual <- resid(fit.GPP_ALL)
plot(fitted(fit.GPP_ALL), GPP_all.residual)+ abline(0,0)



#Recalculating GPP values taking in account heteroscedasticity
CO2_GPP_1516Trait$GPP700<-CO2_GPP_1516Trait$GPP/fitted(fit.GPP_ALL)*(((coef(fit.GPP_ALL)[1])*(coef(fit.GPP_ALL)[2])*700)/((coef(fit.GPP_ALL)[1])*700+(coef(fit.GPP_ALL)[2])))
#calculate PAR adjusted GPP by dividing measured Reco by equation with PAR of measurement
CO2_GPP_1516Trait$GPP.PARadj<-CO2_GPP_1516Trait$GPP/(((coef(fit.GPP_ALL)[1])*(coef(fit.GPP_ALL)[2])*CO2_GPP_1516Trait$PAR.x)/((coef(fit.GPP_ALL)[1])*CO2_GPP_1516Trait$PAR.x+(coef(fit.GPP_ALL)[2])))

CO2_RECO_1516Trait$Reco15<- as.numeric(sub(",", ".", CO2_RECO_1516Trait$Reco15, fixed = TRUE))
CO2_GPP_1516Trait$Reco15<- as.numeric(sub(",", ".", CO2_GPP_1516Trait$Reco15, fixed = TRUE)) # change to numeric
CO2_GPP_1516Trait$GPP700<- as.numeric(sub(",", ".", CO2_GPP_1516Trait$GPP700, fixed = TRUE)) # change to numeric
CO2_GPP_1516Trait$Reco.Tadj<- as.numeric(sub(",", ".", CO2_GPP_1516Trait$Reco.Tadj, fixed = TRUE)) # change to numeric
CO2_GPP_1516Trait$GPP.PARadj<- as.numeric(sub(",", ".", CO2_GPP_1516Trait$GPP.PARadj, fixed = TRUE))

#save standardized CO2 data for trait analysis
#write.csv(CO2_GPP_1516Trait, file = "O:\\FunCab\\Data\\FunCaB2\\CO2\\CO2_GPP_1516Trait15012020.csv")
#write.csv(CO2_RECO_1516Trait, file = "O:\\FunCab\\Data\\FunCaB2\\CO2\\CO2_RECO_1516Trait15012020.csv")


#CO2_GPP_1516Trait & CO2_RECO_1516Trait
ggplot(CO2_RECO_1516Trait, aes(x=tempK, y=Reco, col=factor(templevel)))+
  geom_point(na.rm= TRUE)+
  geom_smooth(method = "nls", formula= y~A*exp(-308.56/I(x-227.13)), method.args = list(start=c(A=0)), se=FALSE, na.rm= TRUE)+
  facet_grid(~year)

ggplot(CO2_GPP_1516Trait, aes(x=PAR.x, y=GPP))+
  geom_point(na.rm= TRUE, shape = 1)+
  geom_smooth(method = "nls", formula= y~(A*B*x)/(A*x+B), method.args = list(start=c(A=0.01, B=2)), se=FALSE, na.rm= TRUE)+
  labs(x= expression(paste("PAR")), y = expression(paste("GPP")))+
  annotate("text", x=800, y=22, label= "GPP ~ 0.035*13.58*PAR/(0.035*PAR) + 13.58", size =4)+
  theme_classic()

ggplot(CO2_GPP_1516Trait, aes(x=tempK, y=Reco))+
  geom_point(na.rm= TRUE, shape = 1)+
  geom_smooth(method = "nls", formula= y~A*exp(-308.56/I(x-227.13)), method.args = list(start=c(A=0)), se=FALSE, na.rm= TRUE)+
  labs(x= expression(paste("Temperature (K)")), y = expression(paste("Reco")))+
  annotate("text", x=287, y=16, label= "Reco ~ 541.8*e^(-308.56/temp K)", size =4)+
  theme_classic()



ggplot(CO2_RECO_1516Trait, aes(preclevel, Reco15, col=factor(templevel)))+
  geom_boxplot()
ggplot(CO2_GPP_1516Trait, aes(preclevel, GPP700, col=factor(templevel)))+
  geom_boxplot()


############### Standardization of fluxdata equation per T-level #####################################################
# recalculate Reco values to a standard temperature for the seperate temperature levels
# divide dataset into seperate templevel
CO2_RECO_ALP<-subset(CO2_RECO_1516Trait, templevel == "ALP")
CO2_RECO_SUB<-subset(CO2_RECO_1516Trait, templevel == "SUB")
CO2_RECO_BOR<-subset(CO2_RECO_1516Trait, templevel == "BOR")

fit.Reco_ALP<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_RECO_ALP)
fit.Reco_SUB<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_RECO_SUB)
fit.Reco_BOR<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_RECO_BOR)

#Recalculating Reco to 15C values taking in account heteroscedasticity
CO2_RECO_ALP$Reco15<-CO2_RECO_ALP$Reco/fitted(fit.Reco_ALP)*(coef(fit.Reco_ALP)*exp(-308.56/I(288.15-227.13)))
CO2_RECO_SUB$Reco15<-CO2_RECO_SUB$Reco/fitted(fit.Reco_SUB)*(coef(fit.Reco_SUB)*exp(-308.56/I(288.15-227.13)))
CO2_RECO_BOR$Reco15<-CO2_RECO_BOR$Reco/fitted(fit.Reco_BOR)*(coef(fit.Reco_BOR)*exp(-308.56/I(288.15-227.13)))

# recalculate data to one Temp for Reco and to standard PAR for GPP
CO2_GPP_ALP<-subset(CO2_GPP_1516Trait, templevel == "ALP")
CO2_GPP_SUB<-subset(CO2_GPP_1516Trait, templevel == "SUB")
CO2_GPP_BOR<-subset(CO2_GPP_1516Trait, templevel == "BOR")

fit.GPP_ALP<-nls((GPP~ (A*B*PAR.x)/(A*PAR.x+B)), start=c(A=0.01, B=2), data=CO2_GPP_ALP)
fit.GPP_SUB<-nls((GPP~ (A*B*PAR.x)/(A*PAR.x+B)), start=c(A=0.01, B=2), data=CO2_GPP_SUB)
fit.GPP_BOR<-nls((GPP~ (A*B*PAR.x)/(A*PAR.x+B)), start=c(A=0.01, B=2), data=CO2_GPP_BOR)

fit.G.Reco_ALP<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_GPP_ALP)
fit.G.Reco_SUB<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_GPP_SUB)
fit.G.Reco_BOR<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_GPP_BOR)


#Recalculating GPP values taking in account heteroscedasticity
CO2_GPP_ALP$GPP1200<-CO2_GPP_ALP$GPP/fitted(fit.GPP_ALP)*(((coef(fit.GPP_ALP)[1])*(coef(fit.GPP_ALP)[2])*1200)/((coef(fit.GPP_ALP)[1])*1200+(coef(fit.GPP_ALP)[2])))
#plot(CO2_GPP_ALP$tempK, CO2_GPP_ALP$GPP1000)
CO2_GPP_SUB$GPP1200<-CO2_GPP_SUB$GPP/fitted(fit.GPP_SUB)*(((coef(fit.GPP_SUB)[1])*(coef(fit.GPP_SUB)[2])*1200)/((coef(fit.GPP_SUB)[1])*1200+(coef(fit.GPP_SUB)[2])))
CO2_GPP_BOR$GPP1200<-CO2_GPP_BOR$GPP/fitted(fit.GPP_BOR)*(((coef(fit.GPP_BOR)[1])*(coef(fit.GPP_BOR)[2])*1200)/((coef(fit.GPP_BOR)[1])*1200+(coef(fit.GPP_BOR)[2])))

CO2_GPP_ALP$Reco15<-CO2_GPP_ALP$Reco/fitted(fit.G.Reco_ALP)*(coef(fit.G.Reco_ALP)*exp(-308.56/I(288.15-227.13)))
CO2_GPP_SUB$Reco15<-CO2_GPP_SUB$Reco/fitted(fit.G.Reco_SUB)*(coef(fit.G.Reco_SUB)*exp(-308.56/I(288.15-227.13)))
CO2_GPP_BOR$Reco15<-CO2_GPP_BOR$Reco/fitted(fit.G.Reco_BOR)*(coef(fit.G.Reco_BOR)*exp(-308.56/I(288.15-227.13)))

# Bind back together all templevels with recalculated fluxes into one dataframe
RECO_Traitdata_1516<- rbind(CO2_RECO_BOR, CO2_RECO_SUB, CO2_RECO_ALP)
GPP_Traitdata_1516<- rbind(CO2_GPP_BOR, CO2_GPP_SUB, CO2_GPP_ALP)

RECO_Traitdata_1516$Reco15<- as.numeric(sub(",", ".", RECO_Traitdata_1516$Reco15, fixed = TRUE))
GPP_Traitdata_1516$Reco15<- as.numeric(sub(",", ".", GPP_Traitdata_1516$Reco15, fixed = TRUE)) # change to numeric
GPP_Traitdata_1516$GPP1200<- as.numeric(sub(",", ".", GPP_Traitdata_1516$GPP1200, fixed = TRUE)) # change to numeric

RECO_Traitdata_1516$year<- format(RECO_Traitdata_1516$date, "%Y")
GPP_Traitdata_1516$year<- format(GPP_Traitdata_1516$date, "%Y")

#save standardized CO2 data for trait analysis
#write.csv(GPP_Traitdata_1516, file = "O:\\FunCab\\Data\\FunCaB\\CO2\\CO2_GPP_1516Trait04122017.csv")
#write.csv(RECO_Traitdata_1516, file = "O:\\FunCab\\Data\\FunCaB\\CO2\\CO2_RECO_1516Trait04122017.csv")


########### filtering out TTC and RTC plots in 2016 #################################################

CO2_TTCvsRTC<- CO2data_1516 %>%
  filter(year == "2016")

ggplot(CO2_TTCvsRTC, aes(x=treatment, y= nee, col= cover))+
  geom_boxplot()+
  facet_wrap(~site)


########Explore data after normalizing ###############################################################################################

ggplot(RECO_Traitdata_1516, aes(factor(preclevel), Reco15, col=factor(year)))+
  geom_boxplot()+
  facet_grid(~templevel)

ggplot(RECO_Traitdata_1516, aes(factor(templevel), Reco15, col=factor(year)))+
  geom_boxplot()+
  facet_grid(~preclevel)

ggplot(GPP_Traitdata_1516, aes(factor(preclevel), GPP1000, col=factor(year)))+
  geom_boxplot()+
  facet_grid(~templevel)

ggplot(GPP_Traitdata_1516, aes(factor(templevel), GPP1000, col=factor(year)))+
  geom_boxplot()+
  facet_grid(~preclevel)




# Data spread per site
xyplot(Reco15 ~ tempK | factor(site), data = CO2_RECO_1516Trait,
         xlab = "Temp",ylab = "Reco" )

xyplot(GPP1500 ~ temp.x | factor(site), data = GPP_Traitdata_1516,
       xlab = "Temp", ylab = "GPP")

xyplot(GPP1500 ~ PAR.x  | factor(site), data = GPP_Traitdata_1516,
        xlab = "PAR", ylab = "GPP")

q<- ggplot(CO2_GPP_2016, aes(tempK, Reco, col=factor(site)))+
  geom_point(shape= 16, size= 3.5)+
  geom_smooth(method = "glm", se = FALSE)+
  labs(x= "Temperature (K)", y = "Reco (?mol/m^2/s)", col="Temperature")+
  #scale_colour_manual(labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#FF6633"))+
  facet_wrap(~site)+
  theme(axis.title.y = element_text(size = rel(2), angle = 90))+
  theme(axis.title.x = element_text(size = rel(2)))+
  theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
  theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.text= element_text(size= rel(1.5), colour = "black"))
  #theme(legend.position = c(.9, .15))
q


q<- ggplot(MergeLD, aes(PAR.x, GPP, col=factor(templevel.x)))+
    geom_point(shape= 16, size= 3.5)+
    labs(x= "PAR (?mol/m^2/s)", y = "GPP (?mol/m^2/s)", col="Temperature")+
    scale_colour_manual(labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#FF6633"))+
    theme(axis.title.y = element_text(size = rel(2), angle = 90))+
    theme(axis.title.x = element_text(size = rel(2)))+
    theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
    theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
    theme(legend.text= element_text(size= rel(1.5), colour = "black"))+
    theme(legend.position = c(.9, .15))
q

xyplot(Reco ~ starttime.y | factor(site), data = MergeLD, na.rm=TRUE,
       xlab = "date",ylab = "Reco", scales = list(x   = list(relation = "free"), y   = list(relation = "same")))

xyplot(temp.x ~ starttime.y | factor(site), data = MergeLD,
       xlab = "date",ylab = "TEMP", scales = list(x   = list(relation = "free"), y   = list(relation = "same")))

xyplot(GPP ~ starttime.x | factor(site), data = MergeLD,
       xlab = "date",ylab = "GPP", scales = list(x   = list(relation = "free"), y   = list(relation = "same")))


#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////# NORMALIZING FLUXDATA
#fit Arheniusequation from Loyd&Taylor 1994<- A*exp(E0/T-T0)
require(graphics)

fit.nls<-nls((Reco~A*exp(-308.56/I(tempK-227.13))), start=c(A=0 ), data=CO2_RECO_1516Trait)
  fit.nls #A=412.1  residual sum-of-squares: 5727
  summary(fit.nls)

E1 <- resid(fit.nls)   #better: E0 <- rstandard(M0)
F1 <- fitted(fit.nls)
  plot(x = F1,
       y = E1,
       xlab = "Fitted values",
       ylab = "Residuals",
       cex.lab = 1.5,
       col = as.numeric(CO2_RECO_1516Trait$preclevel),
       abline(h = 0, lty = 2))

boxplot(E1 ~ site, data = CO2_RECO_1516Trait) # heterogeneity
#Is the ratio of the largest and smalled variance > 4
tapply(E1, INDEX = CO2_RECO_1516Trait$site, FUN = var)

Recofit<-plot(Reco~tempK, data = CO2_RECO_1516Trait)
  #lines(sort(tempK), fitted(fit.nls)[order(tempK)], col="red") #rough fit
  newx<-seq(min(CO2_RECO_1516Trait$tempk), max(CO2_RECO_1516Trait$tempK), length=100) #create new x values for fitting line
  Reco.pred<-predict(fit.nls, newdata=data.frame(tempK=newx)) #predict line from newx values
  lines(newx, Reco.pred, col="blue")


#Recalculating flux values taking in account heteroscedasticity
recalcflux<-MergeLD$Reco/fitted(fit.nls)*(coef(fit.nls)*exp(-308.56/I(283.15-227.13)))
MergeLD$Reco15<-recalcflux
plot(MergeLD$tempK, MergeLD$Reco15)

#equation from longdoz et al 2000 based on lloyd and taylor 1994
#Ea<-12970*xtempK.9/(xtempK.9-227.13), Fs =Fs10 * exp {Ea *(Ts - 283.2)/(283.2 * R * Ts)}

fit.Reco.pre<-nls((Reco~A * exp (12970*tempK/(tempK-227.13) *(tempK - 283.2)/(283.2 * 8.314 * tempK))), start=c(A=0 ), data=SubsetD)
fit.Reco.pre

plot(Reco~tempK, data = SubsetD)
newx.new<-seq(min(SubsetD$tempK), max(SubsetD$tempK), length=100) #create new x values for fitting line
Reco.pred.new<-predict(fit.Reco.pre, newdata=data.frame(tempK=newx.new)) #predict line from newx values
lines(newx.new, Reco.pred.new, col="red")

# normalize Reco by dividing measured values by fitted values (measurement fitted all together/not site by site)
SubsetD$Reconorm<-SubsetD$Reco/fitted(fit.Reco.pre)
plot(SubsetD$Reconorm~SubsetD$tempK)

#splitting dataframe to per temperaturelevel and fitting equation to each Tlevel (alp, sub, low), plotting the fits
library(plyr)
site.norm.pre<-ddply(SubsetD, ~templevel, function(x){
  site.nls<-nls(Reco ~ A * exp (12970*tempK/(tempK-227.13) *(tempK - 283.2)/(283.2 * 8.314 * tempK)), start=c(A=0 ), data=x)
  x11() #plot fitted equation per site
  plot(Reco~tempK, data=x, main=x$templevel[1])
  newx<-seq(min(x$tempK), max(x$tempK), length=100)
  Reco.pred.site<-predict(site.nls, newdata=data.frame(tempK=newx))
  lines(newx, Reco.pred.site, col="blue")
  x$RecoTlevel<-x$Reco/fitted(site.nls)*(coef(fit.nls)*exp(-308.56/I(283.15-227.13)))
  x
})
plot(site.norm.pre$RecoTlevel~site.norm.pre$tempK)

# multiple linear regressiion
M1Reco <- lm(Reco15 ~ factor(templevel.x) + factor(preclevel.x) + block + treatment,
           data = MergeLD)

summary(M1Reco)
step(M1Reco)

M2Reco<-lm(formula = Reco15 ~ factor(templevel.x) + factor(preclevel.x), data = MergeLD)

drop1(M2Reco, test = "F")

#Graphs
p<- ggplot(MergeLD, aes(templevel.x, Reco15, colour= factor(preclevel.x)))
  p+geom_jitter()

p<- ggplot(SubsetD, aes(preclevel, Reco15, colour = factor(templevel)))
  p+geom_jitter()

p<- ggplot(MergeLD, aes(factor(preclevel.x), Reco15, fill= factor(templevel.x)))+
  geom_boxplot()+
  scale_fill_manual(name="Temperature",labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#E69F00"))+
  scale_x_discrete(labels=c("600", "1200", "2000", "2700"))+
  labs(list(x="precipation (mm/y)", y="Reco at 15?C"))+
  theme(axis.title.y = element_text(size = rel(2.5), angle = 90))+
  theme(axis.title.x = element_text(size = rel(2.5)))+
  theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
  theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.text= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.position = c(.9, .8))
p

p<- ggplot(MergeLD, aes(factor(templevel.x), Reco15))
  p+geom_boxplot()



# ====GPP===========================================================================================================

# fit exponential curve to GPP~temp
# rectangular hyperbola Thornley and Johnson (1990)  GPP = (aGPP?GPPmax ?PAR)/( aGPP?PAR + GPPmax)
#aGPP is the initial slope of the rectangular hyperbola, also called the 'apparent quantum yield of GPP', and GPPmax is the asymptotic approach to a maximum GPP at high light intensity.

p<- ggplot(MergeLD, aes(PAR.x, GPP, col=factor(templevel.x)))
  p+geom_point()
  # seems to be a difference in response to PAR between temp levels, or at least for ALP sites

fit.GPP<-nls((GPP~ (A*B*PAR.x)/(A*PAR.x+B)), start=c(A=0.001, B=2), data=MergeLD)
fit.GPP  #A 0.03755901  B 12.72741077

GPPfit<-plot(GPP~PAR.x, data = MergeLD)
  newPAR<-seq(min(MergeLD$PAR.x), max(MergeLD$PAR.x), length=100) #create new x values for fitting line
  GPP.pred<-predict(fit.GPP, newdata=data.frame(PAR.x=newPAR)) #predict line from newx values
  lines(newPAR, GPP.pred, col="blue")

#Recalculating flux values taking in account heteroscedasticity
recalcGPP<-MergeLD$GPP/fitted(fit.GPP)*(((coef(fit.GPP)[1])*(coef(fit.GPP)[2])*1500)/((coef(fit.GPP)[1])*1500+(coef(fit.GPP)[2])))
  MergeLD$GPPnew<-recalcGPP
  plot(MergeLD$temp.x, MergeLD$GPPnew)

q<- ggplot(MergeLD, aes(tempK, GPPnew, col=factor(templevel.x)))+
    geom_point(shape= 16, size= 3.5)+
    labs(x= "Temperature (K)", y = "GPP (?mol/m^2/s)", col="Temperature")+
    scale_colour_manual(labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#E69F00"))+
    theme(axis.title.y = element_text(size = rel(2), angle = 90))+
    theme(axis.title.x = element_text(size = rel(2)))+
    theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
    theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
    theme(legend.text= element_text(size= rel(1.5), colour = "black"))+
    theme(legend.position = c(.9, .15))
  q

q<- ggplot(MergeLD, aes(factor(preclevel.x), GPPnew, fill= factor(templevel.x)))+
    geom_boxplot()+
    scale_fill_manual(name="Temperature",labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#E69F00"))+
    scale_x_discrete(labels=c("600", "1200", "2000", "2700"))+
    labs(list(x="precipation (mm/y)", y="GPP at PAR 1500 (?mol/m^2/s)"))+
    theme(axis.title.y = element_text(size = rel(2), angle = 90))+
    theme(axis.title.x = element_text(size = rel(2.5)))+
    theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
    theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
    theme(legend.text= element_text(size= rel(1.5), colour = "black"))+
    theme(legend.position = c(.9, .8))
q


#splitting dataframe to per temperaturelevel and fitting equation to each Tlevel (alp, sub, low), plotting the fits
# probably not good to correct for Temperature on a categorical basis.
GPP.split<-ddply(MergeLD, ~templevel.x, function(x){
    GPP.nls<-nls((GPP~ (A*B*PAR.x)/(A*PAR.x+B)), start=c(A=0.001, B=2), data=x)
    print(coef(GPP.nls))
    A<-coef(fit.GPP)[1]
    B<-coef(fit.GPP)[2]
    x11() #plot fitted equation per site
    plot(GPP~PAR.x, data=x, main=x$templevel.x[1])
    newx<-seq(min(x$PAR.x), max(x$PAR.x), length=100)
    GPP.pred.new<-predict(GPP.nls, newdata=data.frame(PAR.x=newx))
    lines(newx, GPP.pred.new, col="blue")
    x$GPPTlevel<-x$GPP/fitted(GPP.nls)*((A*B*1500)/(A*1500+B))
    x
  })
plot(GPP.split$GPPTlevel~GPP.split$temp.x)


q<- ggplot(GPP.split, aes(factor(preclevel.x), GPPTlevel, fill= factor(templevel.x)))+
  geom_boxplot()+
  scale_fill_manual(name="Temperature",labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#E69F00"))+
  scale_x_discrete(labels=c("600", "1200", "2000", "2700"))+
  labs(list(x="precipation (mm/y)", y="GPP at PAR 1500 (?mol/m^2/s)"))+
  theme(axis.title.y = element_text(size = rel(2), angle = 90))+
  theme(axis.title.x = element_text(size = rel(2.5)))+
  theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
  theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.text= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.position = c(.9, .8))
q


q<- ggplot(GPP.split, aes(tempK, GPPTlevel, col=factor(templevel.x)))+
  geom_point(shape= 16, size= 3.5)+
  labs(x= "Temperature (K)", y = "GPP (?mol/m^2/s)", col="Temperature")+
  scale_colour_manual(labels=c("7.5?C","9.5?C","11.5?C"), values=c("#56B4E9","#009E73","#E69F00"))+
  theme(axis.title.y = element_text(size = rel(2), angle = 90))+
  theme(axis.title.x = element_text(size = rel(2)))+
  theme(axis.text = element_text(size= rel(1.5), colour = "black"))+
  theme(legend.title= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.text= element_text(size= rel(1.5), colour = "black"))+
  theme(legend.position = c(.9, .15))
q

p<- ggplot(GPP.split, aes(factor(preclevel.x), GPPTlevel, fill= factor(templevel.x)))
  p+geom_boxplot()






#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////#AFTER REMOVAL
#import datafiles after removal
read.sitefiles2<-function(file){
  require(readxl) #install package
  sites<-read_excel(file, sheet=1, col_names=TRUE, col_type= NULL) #read excel file
  sites$dates<- as.Date(sites$dates, format="%d.%m.%y")
  sites<-sites[!is.na(sites$site), ] # remove rows with no data
  #import data from files of site.files
  sites.data<-lapply(1:nrow(sites), function(i){
  r<-sites[i, ]
  #print(r)
  import.everything(metaFile = r$meta, loggerFile = r$logger, tempFile = r$temp)
  }) #process data from all files
  unlist(sites.data, recursive = FALSE) # make on big list of data from all sites, without sublists
}

after.data2015<-read.sitefiles2("\\\\eir.uib.no\\home6\\ial008\\FunCab\\Data\\CO2 flux\\RcodeCO2\\sitesfiles after2015.xlsx")

  fluxcalc(after.data2015[[1]]) #calculate flux 1 plot
  after.2015<-do.call(rbind, lapply(after.data2015,fluxcalc)) #calculate flux all plots in all sites.



#add columns with precipitation and temperature level
  tempV<-c(1,1,1,1,2,2,2,2,3,3,3,3)
  names(tempV)<-c("ULV","LAV","GUD","SKJ","ALR","HOG","RAM","VES","FAU","VIK","ARH","OVS")
  #tempV[overviewsitesdata$site]
  after.2015$templevel<-tempV[after.2015$site]

  precL<-c(1,2,3,4,1,2,3,4,1,2,3,4)
  names(precL)<-c("ULV","LAV","GUD","SKJ","ALR","HOG","RAM","VES","FAU","VIK","ARH","OVS")
  after.2015$preclevel<-precL[after.2015$site]

#calculate GPP
y<-format(after.2015$starttime, format="%y-%m-%d")
  after.2015$date<-y #make new date column

#seperate L and D measurements and merge them in new file with new column GPP
  subsetLafter<-subset(after.2015, cover== "L")    #& rsqd>=.8
  subsetDafter<-subset(after.2015, cover== "D" )   #& rsqd>=.8
  subsetDafter$Reco<-subsetDafter$nee*-1
  subsetDafter$tempK<-subsetDafter$temp+273.15
  mergeLDafter<- merge(subsetLafter, subsetDafter, by=c("site", "block", "treatment", "date"))
  mergeLDafter$GPP<-mergeLDafter$nee.x- mergeLDafter$nee.y #NEE-Reco

# boxplots for exploring spread of flux values within sites
  fluxboxplot<- ggplot(mergeLD, aes(site,Reco))
  fluxboxplot+geom_boxplot()+
  scale_x_discrete(limits=c("ULV","LAV","GUD","SKJ","ALR","HOG","RAM","VES","FAU","VIK","ARH","OVS"))

  fluxboxplot<- ggplot(mergeLD, aes(site,GPP))
  fluxboxplot+geom_boxplot()+
    scale_x_discrete(limits=c("ULV","LAV","GUD","SKJ","ALR","HOG","RAM","VES","FAU","VIK","ARH","OVS"))

#explore datapoints graphs to localize outliers
#Recoafter<-ggplot(subsetDafter, aes(temp, Reco, label=site))+
#  geom_point(aes(fill=factor(site)), shape=1)+
#  geom_text(size=4)+
 # scale_colour_hue(l=50)
 # Recoafter


# NORMALIZING FLUXDATA
fit.Reco.after<-nls((Reco~A * exp (12970*tempK/(tempK-227.13) *(tempK - 283.2)/(283.2 * 8.314 * tempK))), start=c(A=0 ), data=subsetDafter)
  fit.Reco.after

  plot(Reco~tempK, data = subsetDafter)
  newx.new<-seq(min(subsetDafter$tempK), max(subsetDafter$tempK), length=100) #create new x values for fitting line
  Reco.pred.after<-predict(fit.Reco.after, newdata=data.frame(tempK=newx.new)) #predict line from newx values
  lines(newx.new, Reco.pred.after, col="red")

# normalize Reco by dividing measured values by fitted values (measurement fitted all together/not site by site)
  subsetDafter$Reconorm<-subsetDafter$Reco/fitted(fit.Reco.after)
  plot(subsetDafter$Reconorm~subsetDafter$tempK)

  grid.prec.Reconorm<-ggplot(subsetDafter, aes(factor(preclevel), Reconorm))
  grid.prec.Reconorm+geom_boxplot(aes(fill=factor(templevel)))

  grid.temp.Reco<-ggplot(subsetDafter, aes(factor(templevel), Reconorm))
  grid.temp.Reco+geom_boxplot(aes(fill=factor(preclevel)))

#splitting dataframe to per site and fitting equation to each site, plotting the fits
library(plyr)
after.Reconorm<-ddply(mergeLDafter, ~site, function(x){
    Reco.nls<-nls(Reco ~ A * exp (12970*tempK/(tempK-227.13) *(tempK - 283.2)/(283.2 * 8.314 * tempK)), start=c(A=0 ), data=x)
    x11() #plot fitted equation per site
    plot(Reco~tempK, data=x, main=x$site[1])
    newx<-seq(min(x$tempK), max(x$tempK), length=100)
    Reco.pred.site<-predict(Reco.nls, newdata=data.frame(tempK=newx))
    lines(newx, Reco.pred.site, col="blue")
    x$Recosite<-x$Reco/fitted(Reco.nls)
    x
  })
plot(after.Reconorm$Recosite~after.Reconorm$tempK)

Reco.grid<-ggplot(after.Reconorm, aes(factor(site), Recosite))
Reco.grid+geom_boxplot(aes(fill=factor(treatment)))



