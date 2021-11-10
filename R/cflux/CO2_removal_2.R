### FLUX DATA ###

# load libraries
source("R/load_packages.R")
library(ggthemes)
library(lattice)
library(broom)

#source functions for import/proces and calculation of CO2 flux
source("R/cflux/functions/import_process_CO2data_2017.R")
source("R/cflux/functions/CO2flux_calculation.R")
source("R/cflux/functions/CO2_plot.R")
source("R/cflux/functions/import_process_SQlogger_2017.R")

#give exact location of R functions.R file
#source("O:\\FunCab\\Data\\FunCaB\\Other\\R_functions\\Highstat_library.R")


#import all pre removal datafiles from 2017
sites.data.2017Li1400 <- read.sitefiles("data/cflux/Cflux data/datafiles_2017_Li1400.xlsx")#!Li1400 dataflagged outliers+new times
#"CO2/Data/Li1400files2017new.xlsx"
sites.data.2017SQ <- read.sitefiles.SQ("data/cflux/Cflux data/datafiles_2017_SQ.xlsx") #!SQ dataflagged outliers+new time
#"CO2/Data/SQfiles2017new.xlsx"

# check number of columns of metadata
#sapply(sites.data.2017Li1400, function(x) ncol(x$meta))
#sapply(sites.data.2017Li1400, function(x) (x$meta$NA == NULL))

# Run fluxcalculation on all datafiles of 2017
#fluxcalc(sites.data.2017Li1400[[1]]) #calculate flux 1 plot
CO2_Li1400_2017<-do.call(rbind, lapply(sites.data.2017Li1400, fluxcalc)) #calculate flux for all pre-removal data 2015
CO2_SQ_2017<-do.call(rbind, lapply(sites.data.2017SQ, fluxcalc)) #calculate flux for all data 2016
CO2_Li1400_2017$PAR_est<- as.numeric(CO2_Li1400_2017$PAR)
CO2_SQ_2017$PAR_est<- as.numeric(CO2_SQ_2017$PAR)
CO2_Li1400_2017$PAR<- NULL
CO2_SQ_2017$PAR<- NULL

# bind together 2015 and 2016 data
CO2_2017<- rbind(CO2_Li1400_2017, CO2_SQ_2017)

CO2_2017<- CO2_2017%>%
  mutate(ToD = format(starttime, format="%H"),
         soilT = as.numeric(gsub(",", ".", soilT)),
         site = recode(site, ULV = "Ulv", ALR = "Alr", FAU = "Fau", LAV = "Lav", HOG = "Hog", VIK = "Vik", GUD = "Gud", RAM = "Ram",
                       ARH = "Arh",  SKJ = "Skj", VES = "Ves", OVS = "Ovs")) %>%
  rename("Date"= "date", "Site"= "site", "Block"= "block", "Treatment" = "treatment")
CO2_2017$TurfID = paste0(CO2_2017$Site, CO2_2017$Block, CO2_2017$Treatment)

# add columns with precipitation and temperature level for 2015 data
tempV<-c("ALP","ALP","ALP","ALP","SUB","SUB","SUB","SUB","BOR","BOR","BOR","BOR")
names(tempV)<-c("Ulv","Lav","Gud","Skj","Alr","Hog","Ram","Ves","Fau","Vik","Arh","Ovs")
precL<-c("PL1","PL2","PL3","PL4","PL1","PL2","PL3","PL4","PL1","PL2","PL3","PL4")
names(precL)<-c("Ulv","Lav","Gud","Skj","Alr","Hog","Ram","Ves","Fau","Vik","Arh","Ovs")

#tempV[overviewsitesdata$site]
CO2_2017$Tlevel<-tempV[CO2_2017$Site]
CO2_2017$Tlevel = factor(CO2_2017$Tlevel, levels = c("ALP", "SUB", "BOR"))
CO2_2017$Plevel<-precL[CO2_2017$Site]
CO2_2017$Plevel = factor(CO2_2017$Plevel, levels = c("PL1", "PL2", "PL3", "PL4"))
CO2_2017$Treatment <- factor(CO2_2017$Treatment, levels=c("C","B", "G", "F", "GB", "FB", "GF", "FGB"))


# Correct PAR values for measurements when PAR sensor was broken with estimated value based on recorded PAR value in metadata: chamber 1 dates 03.07-06.07
# if cover = "L" & PAR > 200 then use PAR_est value, if cover D and high PAR, correct to estimated value
CO2_2017 <- CO2_2017 %>%
  select(-comment, -flag, -weather)%>%
  #mutate(PAR.correct = ifelse(PAR < 200 & cover == "L", PAR_est, ifelse(PAR > 100 & cover == "D", PAR_est,PAR)))%>%
  mutate(PAR.correct = ifelse(chamber == "1" & Site == "Alr" | chamber == "1" & Site == "Fau", PAR_est, PAR))%>%
  mutate(Block = as.character(Block))

#### load soilmoisture data 2017 ####
Soil_moisture<- read.table("\\\\eir.uib.no\\home6\\ial008\\FunCab\\Data\\soil moisture\\Soilmoisture2017.txt", header = TRUE, dec = ",")

Soil_moisture<- Soil_moisture %>%
  mutate(Site = recode(Site, ULV = "Ulv", ALR = "Alr", FAU = "Fau", LAV = "Lav", HOG = "Hog", VIK = "Vik", GUD = "Gud", RAM = "Ram", ARH =           "Arh", SKJ = "Skj", VES = "Ves", OVS = "Ovs"))%>%
  mutate(Moisture_mean =  rowMeans(subset(Soil_moisture, select = c(6, 7, 8, 9)), na.rm = TRUE)) %>%
  mutate(TurfID=paste0(Site, SCBlock, Treatment)) %>%
  select(Date, TurfID, Moisture_mean)%>%
  group_by(Date, TurfID)%>%
  summarise(Moisture_mean = mean(Moisture_mean, na.rm=TRUE))

CO2_2017<- left_join(CO2_2017, Soil_moisture, by = c("Date", "TurfID"))

##################### CO2 flux processing ##########################################################################
#seperate L and D measurements and merge them in new file with new column GPP, selecting data with r2>=.9
CO2_2017_NEE<-subset(CO2_2017, cover== "L" & rsqd>=.8 | cover== "L" & rsqd<=.2 )
CO2_2017_RECO<-subset(CO2_2017, cover== "D" & rsqd>=.8 | cover== "D" & rsqd<=.2 )
CO2_2017_RECO$Reco<-CO2_2017_RECO$nee*-1
CO2_2017_RECO$tempK<-CO2_2017_RECO$temp+273.15
CO2_2017_GPP<- inner_join(CO2_2017_NEE, CO2_2017_RECO, by=c("Date", "Site", "Block", "Treatment", "ToD", "Tlevel", "Plevel" ))
CO2_2017_GPP$GPP<-CO2_2017_GPP$nee.x- CO2_2017_GPP$nee.y #NEE-Reco
CO2_2017_GPP<-subset(CO2_2017_GPP, GPP>0 & PAR.correct.x >200)

#write.csv(CO2_2017_GPP, file = "O:\\FunCab\\Data\\FunCaB\\CO2\\CO2_GPP_Removal2017.csv")

#### Keep all measurements
CO2_2017_data<- CO2_2017_GPP%>%
  select(siteID = Site, blockID = Block, Treatment, turfID =TurfID.x, soilT = soilT.x, moisture = Moisture_mean.x, tempK, Reco, PAR =PAR.correct.x, GPP)

#!!!standardize flux measurements
#!!! Need to evaluate if GPP measured in block for similar PAR values
ggplot(CO2_2017_GPP, aes(x=Block, y=PAR.correct.x, fill= Treatment))+
  geom_boxplot()+
  facet_wrap(~Site)+
  theme_classic()

#ggplot(CO2_2017_GPP, aes(PAR.correct.x, GPP, col=Treatment))+
#  geom_point()+
#  geom_smooth(method = "nls", formula = GPP~ (A*B*PAR.correct.x)/(A*PAR.correct.x+B), method.args=list(c(A=0.01, B=2)), se=FALSE)

# Fit PAR model to each treatment and retrieve coefficients
GPPcoef <- CO2_2017_GPP %>%
  group_by(Treatment) %>%
  nest()%>%
  mutate(model = map(data, nls, formula= GPP~ (A*B*PAR.correct.x)/(A*PAR.correct.x+B), start=c(A=0.01, B=2)),
         coef = map(model, broom::tidy)) %>%
  unnest(coef)%>%
  select(Treatment, term, estimate)%>%
  spread(term, estimate)%>%
  rename(GPP_coefA = A, GPP_coefB = B)

CO2_2017_GPP <- left_join(CO2_2017_GPP, GPPcoef, by= "Treatment")%>%
  mutate(GPPfit = GPP/fitted(fit.GPP_ALL)*((coefA)*coefB*700)/(coefA*700+coefB))

##### Load vegetation data ###########################################################################################
#load("O:\\FunCab\\Data\\FunCaB2\\CO2\\Data\\funcabComp12052018.RData")
#load("O:\\FunCab\\Data\\FunCaB2\\CO2\\Data\\cleanedVegComp.RData")
#load("O:\\FunCab\\Data\\FunCaB2\\CO2\\Data\\vegData191104.RData")
load("O:\\FunCab\\Data\\FunCaB2\\CO2\\Data\\vegData191114.RData")

composition <- comp2 %>%
  select(-functionalGroup, -sumcover)%>%
  mutate(siteID = recode(siteID, Ulvhaugen = "Ulv",  Skjellingahaugen = "Skj", Alrust = "Alr", Hogsete = "Hog",  Veskre = "Ves", Fauske = "Fau", Vikesland = "Vik", Lavisdalen = "Lav", Ovstedal = "Ovs", Gudmedalen = "Gud", Rambera = "Ram", Arhelleren = "Arh"))%>%
  mutate(totalCov= rowSums(.[6:8], na.rm=TRUE))%>%  #calculate total cover of FG
  group_by(siteID, blockID, Treatment, turfID, Year, species)%>%
    distinct(turfID, .keep_all = TRUE)%>%
  spread(species, cover)%>%
  group_by(siteID, blockID, Treatment, turfID, Year)%>%
  summarise_all(~mean(., na.rm = TRUE)) %>%
  rename(bryophyteCov = mossCov)%>%
  ungroup()

# BryoCov of Ovs1C!!! goes from 100 in 2015/2016 to 10 in 2017, typo > take mean of 2016 and 2018
composition <- within(composition, bryophyteCov[turfID == 'Ovs1C'& Year == "2017"] <- 80)
# Fau2C gramCover missing in 2015, taken mean gramCover from 2017-2018
composition <- within(composition, graminoidCov[turfID == 'Fau2C'& Year == "2015"] <- 75)

#convert NaN from summarise all to NA
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
composition[is.nan(composition)] <- NA

# check for missing cover/Height data
#check<- composition %>%
#  filter(Treatment %in% c("G", "F", "GF", "C"))%>%
#  filter(is.na(bryophyteCov))%>%
#  filter(Year == "2017")

#check<- composition %>%
#  filter(Treatment %in% c("F", "GF", "G", "C"))%>%
#  filter(is.na(mossHeight))%>%
#  filter(Year == "2017")

# Select vegetation data of 2017, without Plevel 3
veg_comp<- composition %>%
  filter(!Year %in% c("2016", "2018"))%>%
  filter(!Treatment == "XC")%>%
  filter(!siteID %in% c("Ram", "Arh", "Gud"))%>%
  mutate(forbCov = ifelse(grepl("F", Treatment), 0, forbCov), #assign 0 to FGcover for FG removed instead of NA
         graminoidCov = ifelse(grepl("G", Treatment), 0, graminoidCov),
         bryophyteCov = ifelse(grepl("B", Treatment), 0, bryophyteCov))%>%
  select(siteID, Year, blockID, Treatment, turfID, bryophyteCov, forbCov, graminoidCov, totalCov, vegetationHeight, mossHeight)%>%
  ungroup()

# calculate mean mossHeight per block at site in 2017
mossheight.site<-veg_comp%>%
  group_by(siteID, blockID)%>%
  summarise(mossHeight = mean(mossHeight, na.rm=TRUE))%>%
  ungroup()

# dataframe with 2015 vegetation composition with mean mossHeight of sites in 2017 because of missing data in 2015
composition2015 <- composition%>%
  filter(Year == 2015)%>%
  left_join(., mossheight.site, by= c("siteID", "blockID"))%>%
  select(siteID, blockID, Treatment, turfID, gramCov2015 =graminoidCov, forbCov2015 = forbCov, bryoCov2015 = bryophyteCov, vegHeight2015 = vegetationHeight, mossHeight2015 = mossHeight.y, totalCov2015 = totalCov)%>%
  filter(!siteID %in% c("Ram", "Arh", "Gud"))

#### Biomass regression ###########################################################################################
#### Biomass regression based on 2015 removal data
#### load biomass removal data ####
Biomass_2015<- read_excel("\\\\eir.uib.no\\home6\\ial008\\FunCab\\Data\\Vegetation data\\biomass_removals_2015.xlsx")
Biomass_2015$Biomass_g<- as.numeric(Biomass_2015$Biomass_g)
Biomass_2015<-Biomass_2015%>%
  filter(!grepl("RTC", Treatment))%>%
  filter(!Site %in% c("Ram", "Gud", "Arh"))%>%
  spread(key = Func_group, value = Biomass_g)

biomass_cover <- left_join(Biomass_2015, composition2015, by= c("Treatment", "TurfID"="turfID"))%>%
  select(siteID, blockID, Treatment, TurfID, B, F, G, gramCov2015, forbCov2015, bryoCov2015, vegHeight2015)%>%
  mutate(siteID = recode(siteID, Ulvhaugen = "Ulv",  Skjellingahaugen = "Skj", Alrust = "Alr", Hogsete = "Hog",  Veskre = "Ves", Fauske = "Fau", Vikesland = "Vik", Lavisdalen = "Lav", Ovstedal = "Ovs", Gudmedalen = "Gud", Rambera = "Ram", Arhelleren = "Arh"))%>%
  filter(!siteID %in% c("Ram", "Gud", "Arh"))%>% # leave out; not part of this paper
  left_join(mossheight.site, by = c("siteID", "blockID"))

#### Biomass Regressions Removals; cover + height biomass estimates 2015 ####
#B_biomass.fit <-lm(B_g.m2 ~ 0 + B_Biomasspred , data=biomass_cover)
B_biomass.fit <-lm(B ~ 0 + bryoCov2015 + mossHeight , data=biomass_cover)
summary(B_biomass.fit)
#G_biomass.fit <-lm(G_g.m2 ~ 0 + G_Biomasspred , data=biomass_cover)
G_biomass.fit <-lm(G ~ 0 + gramCov2015 + vegHeight2015, data=biomass_cover)
summary(G_biomass.fit)
#F_biomass.fit <-lm(F_g.m2 ~ 0 + F_Biomasspred , data=biomass_cover)
F_biomass.fit <-lm(F ~ 0 + forbCov2015 + vegHeight2015 , data=biomass_cover)
summary(F_biomass.fit)

#### calculate FG biomass based on biomass regressions
veg_comp<- left_join(veg_comp, composition2015, by = c("siteID", "blockID", "Treatment", "turfID"))%>%
  mutate(T_level= recode(siteID, Ulv = "Alpine", Lav = "Alpine",  Skj = "Alpine", Alr = "Sub-alpine", Hog = "Sub-alpine", Ves = "Sub-alpine",Fau = "Boreal", Vik = "Boreal", Ovs = "Boreal"),
         P_level= recode(siteID, Ulv = "600mm", Alr = "600mm", Fau = "600mm", Lav = "1200mm", Hog = "1200mm", Vik = "1200mm", Skj = "2700mm", Ves = "2700mm", Ovs = "2700mm"))%>%
  mutate(mossHeight = ifelse(grepl("B", Treatment), 0, mossHeight),
         G.Height = ifelse(Treatment == "B" | Treatment == "F"| Treatment == "FB", vegetationHeight,0), #split up vegetation height for correct biomass calculation
         F.Height = ifelse(Treatment == "B" | Treatment == "G"| Treatment == "GB", vegetationHeight,0))%>%
  mutate(B.biomass = 0 + coef(B_biomass.fit)[1]*bryophyteCov + coef(B_biomass.fit)[2]*mossHeight,
         G.biomass = 0 + coef(G_biomass.fit)[1]*graminoidCov + coef(G_biomass.fit)[2]*G.Height,
         F.biomass = 0 + coef(F_biomass.fit)[1]*forbCov + coef(F_biomass.fit)[2]*F.Height,
         B.biomass2015 = 0 + coef(B_biomass.fit)[1]*bryoCov2015 + coef(B_biomass.fit)[2]*mossHeight2015,
         G.biomass2015 = 0 + coef(G_biomass.fit)[1]*gramCov2015 + coef(G_biomass.fit)[2]*vegHeight2015,
         F.biomass2015 = 0 + coef(F_biomass.fit)[1]*forbCov2015 + coef(F_biomass.fit)[2]*vegHeight2015)%>%
  mutate(F.removed = ifelse(grepl("F", Treatment), F.biomass2015, 0), #assign 0 to biomass that was not removed
         G.removed = ifelse(grepl("G", Treatment), G.biomass2015, 0),
         B.removed = ifelse(grepl("B", Treatment), B.biomass2015, 0),
         total.biomass2015 = F.biomass2015+ G.biomass2015+ B.biomass2015,
         perc.rem.biomass = (F.removed+ G.removed+ B.removed)/total.biomass2015*100)%>%
  mutate(removed.biomass = F.removed + G.removed + B.removed)%>% # calculate removed biomass in 2015
  filter(Year == 2017)

veg_comp$T_level <- factor(veg_comp$T_level,levels = c("Alpine", "Sub-alpine", "Boreal"))
veg_comp$P_level <- factor(veg_comp$P_level,levels = c("600mm", "1200mm", "2700mm"))
veg_comp$Treatment <- factor(veg_comp$Treatment, levels = c("C", "F", "G", "B", "FB", "GB", "GF", "FGB"))

#calculate standard error
se <- function(x) sd(x)/sqrt(length(x))

# mean amount of biomass for PFGs in different sites in 2015 before removal
FG_comp2015<- veg_comp%>%
  select(Year, T_level, P_level, siteID, blockID, Treatment,  B.biomass2015,  G.biomass2015,  F.biomass2015)%>%
  gather(PFG, biomass, B.biomass2015:F.biomass2015)%>%
  group_by(siteID, Treatment, PFG, T_level, P_level, Year)%>%
  summarise(Biomass.se = se(biomass),
            Biomass = mean(biomass, na.rm = TRUE))%>%
  ungroup()

# mean amount of biomass for PFGs in different sites in 2017 after 3 years of removal
FG_comp2017<- veg_comp%>%
  select(Year, T_level, P_level, siteID, blockID, Treatment, B.biomass,  G.biomass,  F.biomass)%>%
  gather(PFG, biomass, B.biomass:F.biomass)%>%
  group_by(siteID, Treatment, PFG, T_level, P_level, Year)%>%
  summarise(Biomass.se = se(biomass),
            Biomass = mean(biomass, na.rm = TRUE))%>%
  ungroup()

#Plot FG composion for treatment across sites in 2015 before removal
ggplot(FG_comp2015, aes(Treatment, Biomass, fill=PFG))+
  geom_bar(position=position_dodge(), stat = "identity")+
  geom_errorbar(position=position_dodge(width=0.9), aes(x= Treatment, ymin=Biomass-Biomass.se, ymax=Biomass+Biomass.se), width=0.3, colour="black", alpha=0.9)+
  scale_fill_manual(values= c("#999999", "#E69F00", "#009E73"),
                    name= "Plant Functional Group", labels =c("Bryophyte", "Forb", "Graminoid"))+
  scale_y_continuous(name="Biomass (g)", breaks=seq(0,20,2))+
  facet_grid(T_level~P_level)+
  theme(axis.title.x=element_text(size = 14), axis.text.x=element_text(size = 12), axis.title = element_text(size = 14), axis.text.y = element_text(size = 12), axis.title.y=element_text(size = 14), strip.background = element_rect(colour="black", fill="white"), panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA), strip.text.x = element_text(size=12), axis.line = element_line(colour = "black")) + theme(legend.position='bottom', legend.title=element_text(size=12), legend.text=element_text(size=11))

FG_comp_year<- veg_comp%>%
  mutate(total.biomass2017 = B.biomass + G.biomass + F.biomass)%>%
  select(siteID, T_level, P_level, Treatment, total.biomass2015, total.biomass2017)%>%
  gather(Year, biomass, total.biomass2015:total.biomass2017)%>%
  group_by(siteID, Year, Treatment, T_level, P_level)%>%
  summarise(biomass.se = se(biomass),
            biomass = mean(biomass, na.rm = TRUE))%>%
  ungroup()

# Total biomass of treatments across sites 2015 vs 2017
ggplot(FG_comp_year, aes(Treatment, biomass, fill = as.factor(Year)))+
  geom_bar(position=position_dodge(), stat = "identity")+
  geom_errorbar(position=position_dodge(width=0.9), aes(x= Treatment, ymin=biomass-biomass.se, ymax=biomass+biomass.se), width=0.3, colour="black", alpha=0.9)+
  scale_fill_manual(values = c("grey30", "grey80"),
                    name= "Year", labels = c("2015", "2017")) +
  scale_y_continuous(name="Biomass (g)", breaks=seq(0,30,5))+
  facet_grid(T_level~P_level)+
  theme(axis.title.x=element_text(size = 14), axis.text.x=element_text(size = 12), axis.title = element_text(size = 14), axis.text.y = element_text(size = 12), axis.title.y=element_text(size = 14), strip.background = element_rect(colour="black", fill="white"), panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA), strip.text.x = element_text(size=12), axis.line = element_line(colour = "black"))


#### Overview of biomass removed in different years
read_excel_allsheets <- function(filename, tibble = TRUE) {
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  #if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}
BiomassRemoval <- read_excel_allsheets( "C:\\Users\\ial008\\OneDrive - NORCE\\FunCab\\Data\\Vegetation data\\FunCaB_biomass_2015-2019.xlsx")
BiomassRemoval <- bind_rows(lapply(BiomassRemoval, function(dtt){mutate_all(dtt, as.character)}))

BiomassRemoval_years<- BiomassRemoval%>%
  #filter(!Year == "2018" | !Year == "2019")%>%
  filter(Round == "Round 1")%>%
  filter(!Treatment == "RTC")%>%
  #filter(!Site %in% c("RAM", "GUD", "ARH"))%>%
  drop_na(Biomass)%>%
  mutate(Biomass = as.numeric(Biomass))%>%
  #filter(Biomass<32.5)%>% # LAV B treatment in 2015 has outlier of 32.5, and SKJ B 41.31 in 2016
  filter(!grepl('cut', Remark))%>%
  mutate(T_level= recode(Site, ULV = "Alpine", LAV = "Alpine",  SKJ = "Alpine",  ALR = "Sub-alpine", HOG = "Sub-alpine", VES = "Sub-alpine",  FAU = "Boreal", VIK = "Boreal", OVS = "Boreal", GUD = "Alpine", RAM = "Sub-alpine", ARH= "Boreal"),
         P_level= recode(Site, ULV = "600mm", ALR = "600mm", FAU = "600mm", LAV = "1200mm", HOG = "1200mm", VIK = "1200mm", SKJ = "2700mm", VES = "2700mm", OVS = "2700mm", GUD = "2100mm", RAM = "2100mm", ARH= "2100mm" ))%>%
  group_by(Year, Site, T_level, P_level, Treatment, Block)%>%
  summarise(total.biomass = sum(Biomass))%>%
  group_by(Year, Site, T_level, P_level, Treatment)%>%
  summarise(biomass.se = se(total.biomass),
            biomass = mean(total.biomass))

ggplot(BiomassRemoval_years, aes(Treatment, biomass, fill = Year))+
  geom_bar(position=position_dodge(), stat = "identity")+
  geom_errorbar(position=position_dodge(width=0.9), aes(x=Treatment, ymin=biomass-biomass.se, ymax=biomass+biomass.se), width=0.3, colour="black", alpha=0.9)+
  facet_grid(T_level~P_level)


#############################################################################################################################################
### Combine flux and vegetation data
CO2veg_2017<- left_join(CO2_2017_data, veg_comp, by = c("siteID", "blockID", "Treatment", "turfID"))%>%
  filter(Year == "2017")%>%
  mutate(F.biomass = ifelse(grepl("F", Treatment), 0, F.biomass), #assign 0 to biomass compensation for FG removed
         G.biomass = ifelse(grepl("G", Treatment), 0, G.biomass),
         B.biomass = ifelse(grepl("B", Treatment), 0, B.biomass))%>% # make sure removed FG biomass is 0
  mutate(TotalBiomass2017 = F.biomass+ G.biomass+ B.biomass)%>%
  mutate(T_level= recode(siteID, Ulv ="Alpine", Lav = "Alpine",  Skj = "Alpine", Alr = "Sub-alpine", Hog = "Sub-alpine",  Ves = "Sub-alpine", Fau = "Boreal", Vik = "Boreal", Ovs = "Boreal"))%>%
  #mutate(T_level = ordered(T_level, levels = c("Alpine", "Sub-alpine", "Boreal")))%>%
  mutate(P_level = recode(siteID, Ulv = "600mm", Alr = "600mm", Fau = "600mm", Lav = "1200mm", Hog = "1200mm", Vik = "1200mm", Skj = "2700mm", Ves = "2700mm", Ovs = "2700mm"))%>%
  #mutate(P_level = ordered(P_level, levels = c("600mm", "1200mm", "2700")))%>%
  mutate(Temp.C = recode(siteID, Ulv = 6.17, Lav = 6.45,  Gud = 5.87, Skj = 6.58, Alr = 9.14, Hog = 9.17, Ram = 8.77,
                         Ves = 8.67, Fau = 10.3, Vik = 10.55, Arh = 10.6, Ovs = 10.78))%>%
  mutate(P.mm = recode(siteID, Ulv = 596, Alr = 789, Fau = 600, Lav = 1321, Hog = 1356, Vik = 1161, Gud = 1925,
                       Ram = 1848, Arh = 2044, Skj = 2725, Ves = 3029, Ovs = 2923))%>%
  ungroup()

CO2veg_2017$T_level <- factor(CO2veg_2017$T_level,levels = c("Alpine", "Sub-alpine", "Boreal"))
CO2veg_2017$P_level <- factor(CO2veg_2017$P_level,levels = c("600mm", "1200mm", "2700mm"))
CO2veg_2017$Treatment <- factor(CO2veg_2017$Treatment, levels = c("C","B", "G", "F","FB", "GB", "GF", "FGB"))

#########  Cflux ##########################################################################
# PAR, GPP values across Treatemnts at different sites
library(RColorBrewer)
ggplot(CO2veg_2017, aes(Treatment, GPP, fill = Treatment, col= PAR))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(size =1.5,  alpha = 0.8,  position = position_jitterdodge(jitter.width = 0.5)) +
  #geom_jitter(width = 0.1,  size =1.5,  alpha = 0.6, dodge)+
  #facet_grid(~T_level)+
  #scale_x_discrete(limits=c( "C", "B", "G", "F", "GB", "FB", "GF", "FGB"))+
  labs(y = "GPP ?mol/mol/s")+
  facet_grid(T_level~P_level)+
  theme_classic()+
  scale_colour_gradient(low = "lightblue", high = "darkred")+
  annotate("text", x=8.2, y=15, label= "b)", size =5)+
  theme(axis.title.x=element_text(size = 14), axis.text.x=element_text(size = 12), axis.title = element_text(size = 14), axis.text.y = element_text(size = 12), axis.title.y=element_text(size = 14), strip.background = element_rect(colour="black", fill="white"), panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA), strip.text.x = element_text(size=12, face="bold"),  axis.line = element_line(colour = "black"))

#### C- flux standardization #######################################################################################
#PAR correction with lasso ridge regression
library(nimble)
library(DHARMa)
library(ggplot2)
source("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\LASSOProductivityModel.R")
source("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\HierarchicalPARCorrectionModel.R")
source("C:\\Users\\ial008\\OneDrive - NORCE\\FunCab\\Data\\FunCaB2\\TraitCO2\\runGPPLightCurveCorrectionModel.R")
source("C:\\Users\\ial008\\OneDrive - NORCE\\FunCab\\Data\\FunCaB2\\TraitCO2\\mcmcInternals.R")

CO2veg_2017<- CO2veg_2017%>%
  filter(Reco>0)%>%
  mutate(F.biomass = ifelse(grepl("F", Treatment), 0, F.biomass), #assign 0 to biomass compensation for FG removed
         G.biomass = ifelse(grepl("G", Treatment), 0, G.biomass),
         B.biomass = ifelse(grepl("B", Treatment), 0, B.biomass)) # make sure removed FG biomass is 0

GPP.FGbiomass <- runGPPLightCurveCorrectionModel(
  data = CO2veg_2017,
  lightValues = "PAR",
  yAssymModel = GPP ~ Temp.C + P.mm + B.biomass + G.biomass + F.biomass,
  indirectComponents = list(),
  lightStandards = c(800))

GPP.Treatment <- runGPPLightCurveCorrectionModel(
  data = CO2veg_2017,
  lightValues = "PAR",
  yAssymModel = GPP ~ Temp.C + P.mm + Treatment,
  indirectComponents = list(),
  lightStandards = c(800))

GPPstandard800<- GPP.Treatment$standardisedValues$standard800

# Model text that was run in JAGS
cat(outvalues$modelText)
# Gelman-Rubin diagnostic plot to check for convergence
gelman.plot(GPPtreatment$mcmcSamples)
plot(GPPtreatment$coeffGrob)

###############################################################################################################################
# mixed effect model
library(lme4)
library(MASS)
library(car)
hist(CO2veg_2017$Reco) # rightskewed = not normally distributed
hist(CO2veg_2017$GPP) # rightskewed = not normally distributed
CO2veg_2017_model<- CO2veg_2017%>%
  filter(Reco>0)%>%
  mutate(Treatment= dplyr::recode(Treatment, "C" = "aC"))

gamma <- fitdistr(CO2veg_2017_model$Reco, "gamma")
qqp(CO2veg_2017_model$Reco, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])

Reco.PQL <- glmmPQL(Reco ~ Treatment * T_level , ~1 | siteID, family = Gamma(link = "log"),
                    data = CO2veg_2017_model, verbose = FALSE)
summary(Reco.PQL)


## normal or gamma distribution best fit
qqp(CO2veg_2017_model$GPP, "norm")
gamma <- fitdistr(CO2veg_2017_model$GPP, "gamma")
qqp(CO2veg_2017_model$GPP, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])

GPP.PQL <- glmmPQL(GPP ~ Treatment * T_level , ~1 | siteID, family = Gamma(link = "log"),
               data = CO2veg_2017_model, verbose = FALSE)
summary(GPP.PQL)


####################################################################################################################
#### CI calculation with biomass
#ED is % contribution by removed FG in intact community
#assumption that per-unit function is same in intact community as when FG is alone
# CI contributions
# 1. changes in biomass of remaining PFGs compared to control situation (gap-recruitment)
# 2. change in per unit function of remaining PFG
# 3. differences in per-unit functioning between removed and remaining PFG (difference in fluxrate)


CO2veg_2017controls<- CO2veg_2017%>%
  filter(Treatment == "C")%>%
  filter(graminoidCov > 0 , forbCov > 0, bryophyteCov > 0 )%>%
  group_by(siteID, blockID, Treatment, turfID, B.biomass, G.biomass, F.biomass)%>%
  summarize(Reco = median(Reco),
            GPP = median(GPP))

##!!!! ALR 5GF causes problems!!!
# !!!!! Calculate median specific flux per FG and Site????
CO2compensation_2017<- CO2veg_2017%>%
  filter(!turfID == "Alr2GF")%>% # only has 1% bryophytecover, so not good representation for bryophytes
  #filter(!turfID == "Alr5GF")%>% # ALR 5GF extreme CI values!!!!
  filter(Treatment != "C")%>%
  bind_rows(CO2veg_2017controls)

B.specificF <- CO2compensation_2017%>%
  gather(key= Cflux , value = flux, Reco, GPP)%>%
  group_by(siteID, blockID, Cflux)%>%
  left_join((.) %>% filter(Treatment == "C")%>% select(siteID, blockID, Cflux, control= flux))%>%
  group_by(siteID, Treatment)%>%
  mutate(presentFG = recode(Treatment, FGB = "zero", GF = "b", FB= "g", GB = "f", B= "gf", G = "fb", F = "gb"))%>%
  mutate(totalBiomass = B.biomass+G.biomass+F.biomass)%>%# calculate cover sum per plot
  filter(Treatment %in% c("GB" , "FB" , "GF"))%>% # filter for plots with single FG
  gather(key= FG, value= biomass, B.biomass, G.biomass, F.biomass )%>%
  filter((Treatment == "GB" & FG == "F.biomass") |(Treatment == "FB" & FG == "G.biomass") |(Treatment =="GF" & FG == "B.biomass"))%>%
  mutate(SpecificFlux = flux/ biomass)%>%
  ungroup()%>%
  select(siteID, blockID, FG, Cflux, SpecificFlux)%>%
  ungroup()

ggplot(B.specificF, aes(siteID, SpecificFlux, col = FG))+
  geom_boxplot()+
  geom_point(pch = 21, position = position_jitterdodge())+
  facet_grid(~Cflux)

# Calculate median specific flux per FG and Site? Should I use all flux measurement up to here?
#B.specificF <- B.specificF %>%
#  group_by(Site, FG, Cflux)%>%
#  summarise(SpecificFlux = median(SpecificFlux))

B.ED_calc <- CO2compensation_2017%>%
  gather(key= Cflux , value = flux,  Reco, GPP)%>%
  gather(key= FG, value= biomass, B.biomass, G.biomass, F.biomass )%>%
  left_join(., B.specificF, by = c("siteID", "blockID", "FG", "Cflux"))%>%
  group_by(siteID, blockID, Treatment, turfID, Cflux)%>%
  summarise(treatmentED = sum(biomass*SpecificFlux, na.rm = TRUE))%>%
  ungroup()%>%
  left_join((.) %>% filter(Treatment == "C") %>% select(siteID, blockID, Cflux, controlED = treatmentED))%>%
  mutate(ED = treatmentED / controlED *100)

B.OD_calc <- CO2compensation_2017%>%
  gather(key= Cflux , value = flux,  Reco, GPP)%>%
  left_join((.) %>% filter(Treatment == "C")%>% select(siteID, blockID, Cflux, controlflux= flux))%>%
  group_by(siteID, blockID, turfID, Cflux)%>%
  mutate( OD = (controlflux - flux)/controlflux *100)%>%
  ungroup()

B.flux_CI <- left_join(B.OD_calc, B.ED_calc, by = c("siteID", "blockID", "Treatment", "turfID", "Cflux"))%>%
  mutate(presentFG = recode(Treatment, FGB = "zero", GF = "b", FB= "g", GB = "f", B= "gf", G = "fb", F = "gb", C = "all"))%>%
  group_by(siteID, blockID, turfID, Cflux)%>%
  mutate(CI = (ED-OD)/ED)%>%
  mutate(T_level = recode(siteID, Ulv = "T1", Lav = "T1",  Gud = "T1", Skj = "T1", Alr = "T2", Hog = "T2", Ram = "T2", Ves = "T2", Fau = "T3", Vik = "T3", Arh = "T3", Ovs = "T3")) %>%
  mutate(P_level = recode(siteID, Ulv = "600mm", Alr = "600mm", Fau = "600mm", Lav = "1200mm", Hog = "1200mm", Vik = "1200mm", Gud = "2700mm", Ram = "2700mm", Arh = "2000mm", Skj = "2700mm", Ves = "2700mm", Ovs = "2700mm"))%>%
  ungroup()

#library(RColorBrewer)
#brewer.pal(n = 8, name = "Dark2") # "#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E" "#E6AB02" "#A6761D" "#666666"
#brewer.pal(n = 8, name = "Set2") # "#66C2A5" "#FC8D62" "#8DA0CB" "#E78AC3" "#A6D854" "#FFD92F" "#E5C494" "#B3B3B3"

# all treatments
ann_textB<- data.frame(estimate = -6, term = "B",lab=c("b)","c)"),
                       Cflux = factor(c("GPP","Reco"),levels = c("GPP","Reco")))
#outliers deleted from plot
B.flux_CI%>%
  filter(Treatment %in% c("B" , "F" , "G", "FB" , "GB" , "GF"))%>%
  filter(!CI %in% c("Inf", "-Inf"))%>%
  ggplot( aes(presentFG, CI, fill = presentFG, alpha= T_level))+
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "solid") +
  geom_boxplot()+
  #geom_point(size =1.5,  alpha = 0.6, position = position_jitterdodge(jitter.width = 0.1)  ) +
  scale_fill_manual(values =c("#A6D854", "#FC8D62", "#66C2A5" , "#D95F02","#1B9E77" , "#E6AB02" ),
                    name="Functional Group",
                    breaks=c("b", "f", "g", "fb", "gb", "gf"),
                    labels = c("B", "F", "G", "FB","GB", "GF"))+
  #scale_color_manual(values =c("grey80", "grey50", "grey20"),
  #                   name="Temperature level",
  #                   breaks=c("T1", "T2", "T3"),
  #                   labels = c("ALP", "SUB", "BOR"))+
  scale_alpha_manual(values=c(0.3, 0.6, 1),
                     name="Temperature level",
                     breaks=c("T1", "T2", "T3"),
                     labels = c("ALP", "SUB", "BOR"))+
  scale_x_discrete(limits=c("b", "f", "g", "fb", "gb", "gf"), labels = c("b"="B", "f"="F", "g"="G", "fb"="FB",
                                                                         "gb"="GB", "gf"="GF" ))+
  #coord_cartesian(ylim = c(-10, 5))+
  theme_classic()+
  facet_grid(Cflux~., scales = "free")+
  geom_text(data = ann_textB ,aes(x= 6.4, y= -7, label =lab), size= 5, inherit.aes = FALSE)+
  theme(axis.title.x=element_blank(), axis.text.x=element_text(size = 12), axis.title = element_text(size = 12),
        axis.text.y = element_text(size = 12), axis.title.y=element_text(size = 14),
        strip.background = element_rect(colour="black", fill="white"),
        panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA),
        strip.text.x = element_text(size=12, face="bold"),  axis.line = element_line(colour = "black"))
,
        legend.position = "none")


B.flux_CI%>%
  filter(Treatment %in% c("B" , "F" , "G", "FB" , "GB" , "GF"))%>%
  filter(!CI %in% c("Inf", "-Inf"))%>%
  group_by(Treatment, T_level, presentFG, Cflux)%>%
  summarise(CI.sd = sd(CI),
            CI = mean(CI))%>%
  ggplot( aes(presentFG, CI, fill = presentFG, group= T_level, shape= T_level))+
  geom_point(size= 5, position=position_dodge(width=0.5))+
  geom_errorbar(aes(x=presentFG, ymin=CI-CI.sd, ymax=CI+CI.sd), position=position_dodge(width=0.5) , colour="black", width = 0, alpha=0.9, size=0.5)+
    scale_fill_manual(values =c("#A6D854", "#FC8D62", "#66C2A5" , "#D95F02","#1B9E77" , "#E6AB02" ),
                    name="Functional Group",
                    breaks=c("b", "f", "g", "fb", "gb", "gf"),
                    labels = c("B", "F", "G", "FB","GB", "GF"))+
  scale_shape_manual(values=c(24, 21, 25),
                     name="Temperature level",
                     breaks=c("T1", "T2", "T3"),
                     labels = c("ALP", "SUB", "BOR"))+
  scale_x_discrete(limits=c("b", "f", "g", "fb", "gb", "gf"), labels = c("b"="B", "f"="F", "g"="G", "fb"="FB",
                                                                         "gb"="GB", "gf"="GF" ))+
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "solid") +
  coord_cartesian(ylim = c(-4, 3))+
  theme_classic()+
  facet_grid(Cflux~., scales = "free")+
  geom_text(data = ann_textB ,aes(x= 6.4, y= -3.5, label =lab), size= 5, inherit.aes = FALSE)+
  theme(axis.title.x=element_blank(), axis.text.x=element_text(size = 12), axis.title = element_text(size = 12),
        axis.text.y = element_text(size = 12), axis.title.y=element_text(size = 14),
        strip.background = element_rect(colour="black", fill="white"),
        panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA),
        strip.text.x = element_text(size=12, face="bold"),  axis.line = element_line(colour = "black"))

#        legend.position = "none")




#### Separating CI contributions
# 1. changes in biomass of remaining PFGs compared to control situation (gap-recruitment)
# R = removal community, I = intact community, i = removed species, j = remaining species
# MjR - MjI = delta Mj, when >0 biomass compensation.
# full compensation MiI = delta M, amount of gap recruitment biomass equals biomass lost through removal
# delta Mj/MiI * 100 % biomass compensation

### HAVE RICHARD CHECK THIS!!!
#### FG Cover compensation ####
### Now for all biomass, when only accounting for Vasc biomass use Vasc.biomass instead of Total.biomass!!
#### Calculate difference between total biomass in treatment and control
Biomass.compensation<- veg_comp%>%
  select(siteID, blockID, Treatment, turfID, bryophyteCov, graminoidCov, forbCov, vegetationHeight, mossHeight,
         B.biomass, G.biomass, F.biomass)%>%
  mutate(F.biomass = ifelse(grepl("F", Treatment), 0, F.biomass), #assign 0 to biomass compensation for FG removed
         G.biomass = ifelse(grepl("G", Treatment), 0, G.biomass),
         B.biomass = ifelse(grepl("B", Treatment), 0, B.biomass))%>% # make sure removed FG biomass is 0
  mutate(Total.biomass = B.biomass + G.biomass + F.biomass,
         Total.Vasc = G.biomass + F.biomass)%>%
  ungroup()
# ! B.biomass = 0
#need to calculate control biomass - biomass of FG that will be removed in Treatment (treatment based)

#BCI <- Biomass.compensation%>%
#  gather(key= FGbiomass, value =biomass, B.biomass, G.biomass, F.biomass)%>%
#    group_by(Site, Block, FGbiomass)%>%
#    left_join((.) %>% filter(Treatment == "C")%>% select(Site, Block, FGbiomass, control.biomass= Total.biomass))%>%
#    mutate(comp.biomass = (Total.biomass-control.biomass)/control.biomass)%>%
#    filter(!Treatment %in% c("C", "FGB"))%>%
#    mutate(T_level = recode(Site, Ulv = "1", Lav = "1",  Gud = "1", Skj = "1", Alr = "2", Hog = "2", Ram = "2",
#    Ves = "2", Fau = "3", Vik = "3", Arh = "3", Ovs = "3")) %>%
#    mutate(P_level = recode(Site, Ulv = "1", Alr = "1", Fau = "1", Lav = "2", Hog = "2", Vik = "2", Gud = "3",
#     Ram = "3", Arh = "3", Skj = "4", Ves = "4", Ovs = "4"))%>%
#    mutate(Temp.C = recode(Site, Ulv = 6.17, Lav = 6.45,  Gud = 5.87, Skj = 6.58, Alr = 9.14, Hog = 9.17,
#    Ram = 8.77, Ves = 8.67, Fau = 10.3, Vik = 10.55, Arh = 10.6, Ovs = 10.78))%>%
#    mutate(P.mm = recode(Site, Ulv = 596, Alr = 789, Fau = 600, Lav = 1321, Hog = 1356, Vik = 1161, Gud = 1925,
#                         Ram = 1848, Arh = 2044, Skj = 2725, Ves = 3029, Ovs = 2923))%>%
#    ungroup()


Biomass.Control <- Biomass.compensation%>%
  mutate(Total.Cbiomass = B.biomass + G.biomass + F.biomass,
         F = B.biomass + G.biomass,
         G = F.biomass + B.biomass,
         B = G.biomass + F.biomass,
         FB = G.biomass,
         GF = B.biomass,
         GB = F.biomass,
         FGB = 0)%>% # calculate biomass remaining for different combination of removals
  gather(key = "bTreatment", value = "Remain.biomass", F:FGB)%>%
  select(siteID, blockID, Treatment, bTreatment, B.biomass,  G.biomass, F.biomass , Remain.biomass, Total.Cbiomass)%>%
  filter(Treatment == "C")


BCI <- right_join(Biomass.compensation, Biomass.Control, by = c("siteID", "blockID", "Treatment" = "bTreatment"))%>%
  mutate(presentFG = recode(Treatment, FGB = "zero", GF = "B", FB= "G", GB = "F", B= "GF", G = "FB", F = "GB", C = "all"))%>%
  # need to subtract biomass of FG that will be removed from total biomass of control
  mutate(#ED = Remain.biomass *100,
    #OD = (Total.Cbiomass - Total.biomass) / Total.Cbiomass *100,
    #BCI = (ED-OD)/ED,
    #BCI2 = (Total.biomass- Remain.biomass )/ (Total.Cbiomass),
    BCI3 = ((Total.biomass- Remain.biomass )/ (Total.Cbiomass -Remain.biomass)))%>% #based on Adler &Bradford
  filter(!Treatment %in% c("C", "FGB"))%>%
  mutate(T_level = recode(siteID, Ulv = "T1", Lav = "T1",  Gud = "T1", Skj = "T1", Alr = "T2", Hog = "T2", Ram = "T2", Ves = "T2", Fau = "T3", Vik = "T3", Arh = "T3", Ovs = "T3")) %>%
  mutate(P_level = recode(siteID, Ulv = "600mm", Alr = "600mm", Fau = "600mm", Lav = "1200mm", Hog = "1200mm", Vik = "1200mm", Gud = "2700mm", Ram = "2700mm", Arh = "2000mm", Skj = "2700mm", Ves = "2700mm", Ovs = "2700mm"))%>%
  mutate(Temp.C = recode(siteID, Ulv = 6.17, Lav = 6.45,  Gud = 5.87, Skj = 6.58, Alr = 9.14, Hog = 9.17, Ram = 8.77,
                         Ves = 8.67, Fau = 10.3, Vik = 10.55, Arh = 10.6, Ovs = 10.78))%>%
  mutate(P.mm = recode(siteID, Ulv = 596, Alr = 789, Fau = 600, Lav = 1321, Hog = 1356, Vik = 1161, Gud = 1925,
                       Ram = 1848, Arh = 2044, Skj = 2725, Ves = 3029, Ovs = 2923))%>%
  ungroup()

ann_textA<- data.frame(estimate = -6, lab=c("a)"))
BCI%>%
  filter(Treatment %in% c("B" , "F" , "G", "FB" , "GB" , "GF"))%>%
  ggplot( aes(presentFG, BCI3, col = T_level , fill = presentFG, alpha = T_level))+
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "solid") +
  geom_boxplot(outlier.shape = NA)+
  geom_point(size =1.5,  alpha = 0.6, position = position_jitterdodge(jitter.width = 0.1)  ) +
  scale_fill_manual(values =c("#A6D854", "#FC8D62", "#D95F02", "#66C2A5" ,"#1B9E77" , "#E6AB02" ),
                    name="Functional Group",
                    breaks=c("B", "F", "G", "FB", "GB", "GF"),
                    labels = c("B", "F", "G", "FB","GB", "GF"))+
  scale_color_manual(values =c("grey80", "grey50", "grey20"),
                     name="Temperature level",
                     breaks=c("T1", "T2", "T3"),
                     labels = c("ALP", "SUB", "BOR"))+
  scale_alpha_manual(values=c(0.8, 0.9, 1),
                     name="Temperature level",
                     breaks=c("T1", "T2", "T3"),
                     labels = c("ALP", "SUB", "BOR"))+
  scale_x_discrete(limits=c("B", "F", "G", "FB", "GB", "GF"))+
  #coord_cartesian(ylim = c(-8, 10), breaks = seq(-8, 10, 1))+
  theme_classic()+
  ylab("Biomass Compensation")+
  geom_text(data = ann_textA ,aes(x= 6.4, y= -7, label =lab), size= 5, inherit.aes = FALSE)+
  theme(axis.title.x=element_blank(), axis.text.x=element_text(size = 12), axis.title = element_text(size = 12),
        axis.text.y = element_text(size = 12), axis.title.y=element_text(size = 14),
        strip.background = element_rect(colour="black", fill="white"),
        panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA),
        strip.text.x = element_text(size=12, face="bold"),  axis.line = element_line(colour = "black"))


# compare CI with B_CI to see if biomass compensation is the main driver of CI
# join CI data with B_CI data
CI_BCI_2 <- right_join(B.flux_CI, BCI, by= c("siteID", "blockID", "Treatment", "turfID"))
CI_BCI_2$Treatment <- factor(CI_BCI_2$Treatment, levels = c("G", "F", "B", "FB", "GB", "GF"))

library(RColorBrewer)
library(ggalt)
CI_BCI_2$P_level.x <- factor(CI_BCI_2$P_level.x, levels = c("600mm", "1200mm", "2700mm"))
CI_BCI_2$T_level.x <- factor(CI_BCI_2$T_level.x, levels = c("T1", "T2", "T3"))

# test effect for effect of temeperature and precipitation on CI/BCI
CI_model<- CI_BCI_2%>%
  filter(!CI %in% c(Inf, -Inf))%>%
  filter(Cflux == "GPP")
summary(lm(CI ~ Temp.C.x+P.mm.x, data = CI_model))
summary(lm(BCI3 ~ Temp.C.x*P.mm.x, data = CI_model)) # significant effect of P.mm and interaction


# use of statbin to draw line around points
#https://r.789695.n4.nabble.com/Adding-95-contours-around-scatterplot-points-with-ggplot2-td4656877.html

# facet by tempgradient, difference over temp gradient
CI_BCI_2%>%
  filter(Cflux == "GPP")%>%
  filter(presentFG.y %in% c("FB" ,"GF", "GB", "G", "B", "F" ))%>%
  ggplot(aes( BCI3, CI, color = presentFG.x, fill = presentFG.x))+
  geom_point(size= 2.5, alpha = 0.2)+
  #geom_encircle(expand=0, alpha = 0.3)+
  stat_density2d(bins=2, geom = "polygon", aes(color = presentFG.x, fill = presentFG.x, alpha = 0.2))+
  scale_color_manual(values =c("#A6D854", "#FC8D62", "#D95F02", "#66C2A5" ,"#1B9E77" , "#E6AB02" ),
                    name="Functional Group",
                    breaks=c("b", "f", "g", "fb", "gb", "gf"), labels =c("B", "F", "G", "FB", "GB", "GF"))+
  scale_fill_manual(values =c("#A6D854", "#FC8D62", "#D95F02", "#66C2A5" ,"#1B9E77" , "#E6AB02" ),
                    name="Functional Group",
                    breaks=c("b", "f", "g", "fb", "gb", "gf"), labels =c("B", "F", "G", "FB", "GB", "GF"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size= 1)+
  geom_hline(yintercept= 0, color = "grey")+
  geom_hline(yintercept= 1 , linetype="dotted", color = "blue")+
  geom_vline(xintercept = 0, color = "grey")+
  geom_vline(xintercept = 1, linetype= "dotted", color = "blue")+
  coord_cartesian(xlim = c(-3,3), ylim = c(-2, 2))+
  facet_wrap(~T_level.x, scales = "fixed")+
  guides(shape=guide_legend(title="Precipitation level"))+
  labs(Title= "Reco", x= "Biomass Compensation Index", y = "C flux Compensation Index")+
  theme(axis.title.x=element_text(size = 14), axis.text.x=element_text(size = 12), axis.title = element_text(size = 14),  axis.title.y=element_text(size = 14), axis.text.y = element_text(size = 12), strip.background = element_rect(colour="black", fill="white"), panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA), strip.text.x = element_text(size=12, face="bold"),  axis.line = element_line(colour = "black"))


# facet by FG, difference over temp gradient
CI_BCI_2%>%
  filter(Cflux == "GPP")%>%
  filter(presentFG.y %in% c("FB" ,"GF", "GB", "G", "B", "F" ))%>%
  ggplot(aes( BCI3, CI, color = T_level.x, fill = T_level.x))+
  geom_point(size= 2.5, alpha = 0.2)+
  #geom_encircle(expand=0, alpha = 0.3)+
  stat_density2d(bins=2, geom = "polygon", aes(color = T_level.x, fill = T_level.x, alpha = 0.3))+
  scale_shape_manual(values = c(24, 22, 25))+
  scale_color_manual(values =c("#4E84C4",  "#C4961A", "#FC4E07"), name = "Temperature",
                   breaks=c("T1", "T2", "T3"), labels = c("Alpine", "Sub-alpine", "Boreal"))+
  scale_fill_manual(values =c("#4E84C4",  "#C4961A", "#FC4E07"),, name = "Temperature",
                    breaks=c("T1", "T2", "T3"),  labels = c("Alpine", "Sub-alpine", "Boreal"))+
  #scale_color_brewer(palette = "Dark2", name = "FG present", labels = c("FB", "GB", "GF", "G", "F", "B"))+
  #scale_fill_brewer(palette = "Dark2", name = "FG present", labels = c("FB", "GB", "GF", "G", "F", "B"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size= 1)+
  geom_hline(yintercept= 0, color = "grey")+
  geom_hline(yintercept= 1 , linetype="dotted", color = "blue")+
  geom_vline(xintercept = 0, color = "grey")+
  geom_vline(xintercept = 1, linetype= "dotted", color = "blue")+
  coord_cartesian(xlim = c(-3,3), ylim = c(-2, 2))+
  facet_wrap(~presentFG.x, scales = "fixed")+
  guides(shape=guide_legend(title="Precipitation level"))+
  labs(Title= "Reco", x= "Biomass Compensation Index", y = "C flux Compensation Index")+
  theme(axis.title.x=element_text(size = 14), axis.text.x=element_text(size = 12), axis.title = element_text(size = 14),  axis.title.y=element_text(size = 14), axis.text.y = element_text(size = 12), strip.background = element_rect(colour="black", fill="white"), panel.background = element_rect(fill= "white"), panel.border = element_rect(colour = "black", fill=NA), strip.text.x = element_text(size=12, face="bold"),  axis.line = element_line(colour = "black"))


# using cartesian is cutting off a number of observations!!
CI_BCI_2%>%
  filter(Cflux == "GPP")%>%
    ggplot(aes(removed.biomass, BCI3, color = Treatment, fill = Treatment))+
    geom_point(size= 2.5, alpha = 0.2)



######## TRAITS ##########
###### What predicts compensation capacity
#load trait data
trait_C <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_C.csv", header =TRUE, sep = ";", dec = ",")%>%
  mutate(Species = paste0(Site, "_", Species))%>%
  select( Site, Species, predictValue, predictionSE) #, predictionSE
trait_N <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_N.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)
trait_CN <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_CN_ratio.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)
trait_SLA <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_SLA.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)
trait_Lth <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_Lth_ave.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)
trait_LDMC <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_LDMC.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)
trait_logLA <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_logLA.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)
trait_logHeight <- read.csv("O:\\FunCab\\Data\\FunCaB2\\TraitCO2\\speciesSitePredictions_logHeight.csv", header =TRUE, sep = ";", dec = ",")%>%
  select(predictValue, predictionSE)

Species_traits <-bind_cols(trait_C, trait_N, trait_CN, trait_SLA, trait_Lth, trait_LDMC, trait_logLA, trait_logHeight)%>%
  rename(C = predictValue, N = predictValue1, CN = predictValue2, SLA = predictValue3, Lth = predictValue4, LDMC = predictValue5, LA = predictValue6, Height = predictValue7)%>%
  group_by(Site, Species)%>%
  mutate_all(funs(ifelse(.==0, NA, .))) %>%
  select(Site, Species, C, N, CN, SLA, Lth, LDMC, LA, Height)
# Bot_lun, Gym_dry, Hup_sel, Sel_sel. Equ_arv are ferns, no traitdata, recode to NA instead of 0

#load community data
load("O:\\FunCab\\Data\\FunCaB2\\CO2\\Data\\cleanedVegComp.RData")

community2017 <- composition%>%
  filter(Year == 2017)%>%
  mutate(Site = substr(siteID, 0, 3),
         species = gsub("\\.", "_", species),
         Species =paste0(Site,"_", species))%>%
  select(Site, Species, cover)%>%
  ungroup()

library("FD")
community_FD <- left_join(community2017, Species_traits, by= c("Site", "Species"))%>%
  select(Site, turfID, Species, cover, C, N, CN, SLA, Lth, LDMC, LA, Height)%>%
  group_by(turfID, Site)%>%
  filter(!is.na(cover)) %>%
  mutate(richness = sum(n_distinct(Species))) %>%
  mutate(diversity = diversity(cover, index = "shannon")) %>%
  mutate(evenness = (diversity/log(richness)))%>%
  summarize(richness = mean(richness),
            diversity = mean(diversity),
            evenness = mean(evenness),
            Wmean_LDMC= weighted.mean(LDMC, cover, na.rm=TRUE),
            Wmean_Lth= weighted.mean(Lth, cover, na.rm=TRUE),
            Wmean_LA= weighted.mean(LA, cover, na.rm=TRUE),
            Wmean_SLA= weighted.mean(SLA, cover, na.rm=TRUE),
            Wmean_Height= weighted.mean(Height, cover, na.rm=TRUE),
            Wmean_CN = weighted.mean(CN, cover, na.rm=TRUE),
            Wmean_C = weighted.mean(C, cover, na.rm=TRUE),
            Wmean_N = weighted.mean(N, cover, na.rm=TRUE))%>%
  #gather(key= Trait, value= value, -c(turfID:Year))%>%
  ungroup()

CImodel<- CI_BCI_2%>%
  select(Site, Treatment, turfID, P.mm.x, Temp.C.x, T_level.x, P_level.x, B.biomass.x, G.biomass.x, F.biomass.x, CI, BCI3, flux)%>%
  filter(!CI %in% c("Inf", "-Inf"))

CImodel <- left_join(CImodel, community_FD, by= c("turfID", "Site"))%>%
  ungroup()%>%
  mutate(F.biomass.x = ifelse(grepl("F", Treatment), NA, F.biomass.x), #NA to biomass compensation for FG removed
         G.biomass.x = ifelse(grepl("G", Treatment), NA, G.biomass.x),
         B.biomass.x = ifelse(grepl("B", Treatment), NA, B.biomass.x))

library(corrplot)
library("Hmisc")

CImodelGPP <- CImodel%>%
  filter(Cflux == "GPP" & !Treatment =="GF")
cor_CI <- CImodelGPP %>%
  select(CI, BCI3, Temp.C.x, P.mm.x, B.biomass.x, G.biomass.x, F.biomass.x, Wmean_Height , Wmean_SLA , Wmean_N , Wmean_Lth, Wmean_LDMC, Wmean_CN, Wmean_C, Wmean_LA)
cor_CI <- rcorr(as.matrix(cor_CI))

corrplot(cor_CI$r, p.mat = cor_CI$P , sig.level = 0.01, method="color", insig = "blank",
         type = "upper", addCoef.col = "black", tl.col = "black", diag = FALSE)

ggplot(CImodelGPP, aes(F.biomass.x, Wmean_N))+
  geom_point()

CImodelReco <- CImodel%>%
  filter(Cflux == "Reco" & !Treatment =="GF")


library(lme4)
#GPP
summary(lm(CI~ Temp.C.x*scale(P.mm.x)*Treatment, CImodelGPP))
summary(lm(CI~ Temp.C.x*scale(P.mm.x) + B.biomass.x +G.biomass.x + F.biomass.x, CImodelGPP))
summary(lm(CI~ Wmean_N, CImodelGPP)) #Wmean_Height + Wmean_SLA + Wmean_Lth

CI_GPP0<-lmer(CI~ Temp.C.x*scale(P.mm.x)*Treatment + (1|Site) , CImodelGPP)
summary(CI_GPP0)
CI_GPPa<-lmer(CI~  B.biomass.x + G.biomass.x + F.biomass.x + (1|Site), CImodelGPP,  REML=FALSE)
summary(CI_GPPa)
CI_GPPb<-lmer(CI~ Wmean_Height + Wmean_SLA + Wmean_N + Wmean_Lth + (1|Site), CImodelGPP,  REML=FALSE)
summary(CI_GPPb)
CI_GPPc<-lmer(CI~  B.biomass.x + G.biomass.x + F.biomass.x + Wmean_N + (1|Site), CImodelGPP,  REML=FALSE)
summary(CI_GPPc)

anova(CI_GPPa, CI_GPPb)
anova(CI_GPPa, CI_GPPc)

summary(GPP.aov <- aov(flux ~ T_level.x+Treatment, data = CImodelGPP))
TukeyHSD(GPP.aov, "T_level.x", ordered = TRUE)
TukeyHSD(GPP.aov, "Treatment", ordered = FALSE)
plot(TukeyHSD(GPP.aov, "Treatment"))

summary(Reco.aov <- aov(flux ~ T_level.x, data = CImodelReco))
TukeyHSD(Reco.aov, "T_level.x", ordered = TRUE)
plot(TukeyHSD(Reco.aov, "T_level.x"))


