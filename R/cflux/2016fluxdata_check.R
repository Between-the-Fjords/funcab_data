source("R/load_packages.R")

# test datafiles 2016
source("R/cflux/functions/import_process_CO2data.R")
source("R/cflux/functions/CO2flux_calculation.R")
source("R/cflux/functions/CO2_plot.R")

#ULV 02-08-2016_1
ULV020816_1 <- import.everything(
  meta = "data/cflux/Metadata/Metadata_2016/RawData/02082016_ULV_ch1_1.txt
  O:\\FunCab\\Data\\co2flux2016\\metadata files\\02082016_ULV_ch1_1.txt",
  logger=
    "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160802_ULV_LI1400_CH1_1.txt",
  temp="O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160802_ULV_CH1_TEMP.txt"
)
ULV020816_1newTime<-setStartEndTimes(ULV020816_1)
fluxULV<-do.call(rbind, lapply(ULV020816_1,fluxcalc))

#ULV 02-08-2016_2
ULV020816_2<-import.everything(
  meta="O:\\FunCab\\Data\\co2flux2016\\metadata files\\02082016_ULV_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160802_ULV_LI1400_CH1_2.txt",
  temp="O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160802_ULV_CH1_TEMP.txt"
)
ULV020816_2newTime<-setStartEndTimes(ULV020816_2)

#LAV 03-08-2016_1
LAV030816_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\03082016_LAV_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160803_LAV_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160803_LAV_CH1_TEMP.txt"
)

#LAV 03-08-2016_2
LAV030816_2<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\03082016_LAV_ch1_2.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160803_LAV_LI1400_CH1_2.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160803_LAV_CH1_TEMP.txt"
)

#LAV 04-08-2016_1
LAV040816_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\04082016_LAV_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160804_LAV_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160804_LAV_CH1_TEMP.txt"
)
#LAV 04-08-2016_2
LAV040816_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\04082016_LAV_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160804_LAV_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160804_LAV_CH1_TEMP.txt"
)

#ARH 05-07-2016_1
ARH050716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\05072016_ARH_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160705_ARH_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160705_ARH_CH1_TEMP.txt"
)

#ARH 05-07-2016_2
ARH050716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\05072016_ARH_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160705_ARH_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160705_ARH_CH1_TEMP.txt"
)

#VIK 06-07-2016_1
VIK060716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\06072016_VIK_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160706_VIK_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160706_VIK_CH1_TEMP.txt"
)

#FAU 07-06-2016_1
FAU070616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\07062016_FAU_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160607_FAU_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160607_FAU_CH1_TEMP.txt"
)

#FAU 22-06-2016_1 # error
FAU220616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22062016_FAU_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160622_FAU_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160622_FAU_CH1_TEMP.txt"
)

#FAU 22-06-2016_2 # error
FAU220616_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22062016_FAU_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160622_FAU_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160622_FAU_CH1_TEMP.txt"
)

#OVS 06-07-2016_1
OVS060716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\06072016_OVS_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160706_OVS_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160706_OVS_CH1_TEMP.txt"
)

#HOG 07-07-2016_1
HOG070716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\07072016_HOG_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160707_HOG_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160707_HOG_CH1_TEMP.txt"
)

#HOG 07-07-2016_2
HOG070716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\07072016_HOG_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160707_HOG_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160707_HOG_CH1_TEMP.txt"
)

#VES 08-07-2016_1
VES080716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\08072016_VES_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160708_VES_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160708_VES_CH1_TEMP.txt"
)

#VES 08-07-2016_2
VES080716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\08072016_VES_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160708_VES_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160708_VES_CH1_TEMP.txt"
)

#FAU 13-06-2016_1
FAU130616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\13062016_FAU_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160613_FAU_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160613_FAU_CH1_TEMP.txt"
)

#FAU 13-06-2016_2
FAU130616_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\13062016_FAU_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160613_FAU_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160613_FAU_CH1_TEMP.txt"
)

#OVS 13-07-2016_1
OVS130716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\13072016_OVS_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160713_OVS_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160713_OVS_CH1_TEMP.txt"
)

#OVS 13-07-2016_2
OVS130716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\13072016_OVS_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160713_OVS_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160713_OVS_CH1_TEMP.txt"
)

#ALR 14-06-2016_1
ALR140616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\14062016_ALR_ch2_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160614_ALR_LI1400_CH2_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160614_ALR_CH2_TEMP.txt"
)

#OVS 14-07-2016_1 # error
OVS140716_1<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\14072016_OVS_ch1_1.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160714_OVS_LI1400_CH1_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160714_OVS_CH1_TEMP.txt"
)

#OVS 14-07-2016_2
OVS140716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\14072016_OVS_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160714_OVS_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160714_OVS_CH1_TEMP.txt"
)

#VIK 15-06-2016_1
VIK150616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\15062016_VIK_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160615_VIK_LI1400_CH1_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160616_VIK_CH1_TEMP.txt"
)

#VES 15-07-2016_1
VES150716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\15072016_VES_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160715_VES_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160715_VES_CH1_TEMP.txt"
)

#VES 15-07-2016_2
VES150716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\15072016_VES_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160715_VES_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160715_VES_CH1_TEMP.txt"
)

#ARH 16-06-2016_1
ARH160616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\16062016_ARH_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160616_ARH_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160616_ARH_CH1_TEMP.txt"
)

#VIK 18-07-2016_1
VIK180716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\18072016_VIK_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160718_VIK_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160718_VIK_CH1_TEMP.txt"
)

#VIK 18-07-2016_2
VIK180716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\18072016_VIK_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160718_VIK_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160718_VIK_CH1_TEMP.txt"
)

#RAM 20-07-2016_1
RAM200716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\20072016_RAM_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160720_RAM_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160720_RAM_CH1_TEMP.txt"
)

#RAM 20-07-2016_2
RAM200716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\20072016_RAM_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160720_RAM_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160720_RAM_CH1_TEMP.txt"
)

#RAM 20-07-2016_3
RAM200716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\20072016_RAM_ch1_3.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160720_RAM_LI1400_CH1_3.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160720_RAM_CH1_TEMP.txt"
)


#ALR 21-06-2016_1 #error
ALR210616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\21062016_ALR_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160621_ALR_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160621_ALR_CH1_TEMP.txt"
)

#ALR 21-06-2016_2_1
ALR210616_2_1<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\21062016_ALR_ch2_1.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160621_ALR_LI1400_CH2_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160621_ALR_CH2_TEMP.txt"
)

#ALR 21-06-2016_2_2 # error
ALR210616_2_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\21062016_ALR_ch2_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160621_RAM_LI1400_CH2_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160621_ALR_CH2_TEMP.txt"
)

#RAM 21-07-2016_1
RAM210716_1<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\21072016_RAM_ch1_1.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160721_RAM_LI1400_CH1_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160721_RAM_CH1_TEMP.txt"
)

#RAM 21-07-2016_2
RAM210716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\21072016_RAM_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160721_RAM_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160721_RAM_CH1_TEMP.txt"
)

#ARH 22-07-2016_1
ARH220716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22072016_ARH_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160722_ARH_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160722_ARH_CH1_TEMP.txt"
)

#ARH 22-07-2016_2
ARH220716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22072016_ARH_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160722_ARH_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160722_ARH_CH1_TEMP.txt"
)

#ARH 22-07-2016_3
ARH220716_3<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22072016_ARH_ch1_3.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160722_ARH_LI1400_CH1_3.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160722_ARH_CH1_TEMP.txt"
)


#GUD 22-08-2016_1
GUD220816_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22082016_GUD_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160822_GUD_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160822_GUD_CH1_TEMP.txt"
)

#GUD 22-08-2016_2
GUD220816_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\22082016_GUD_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160822_GUD_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160822_GUD_CH1_TEMP.txt"
)

#HOG 23-06-2016_1
HOG230616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23062016_HOG_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160623_HOG_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160623_HOG_CH1_TEMP.txt"
)

#HOG 23-06-2016_2
HOG230616_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23062016_HOG_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160623_HOG_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160623_HOG_CH1_TEMP.txt"
)

#HOG 23-06-2016_3
HOG230616_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23062016_HOG_ch1_3.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160623_HOG_LI1400_CH1_3.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160623_HOG_CH1_TEMP.txt"
)


#OVS 23-07-2016_1
OVS230716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23072016_OVS_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160723_OVS_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160723_OVS_CH1_TEMP.txt"
)

#OVS 23-07-2016_2 error
OVS230716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23072016_OVS_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160723_OVS_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160723_OVS_CH1_TEMP.txt"
)

#GUD 23-08-2016_1
GUD230816_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23082016_GUD_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160823_GUD_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160823_GUD_CH1_TEMP.txt"
)

#GUD 23-08-2016_2
GUD230816_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\23082016_GUD_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160823_GUD_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160823_GUD_CH1_TEMP.txt"
)

#VIK 23-06-2016_1
VIK230616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\24062016_VIK_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160624_VIK_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160624_VIK_CH1_TEMP.txt"
)


#VIK 28-06-2016_1
VIK280616_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\28062016_VIK_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160628_VIK_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160628_VIK_CH1_TEMP.txt"
)

#VIK 28-06-2016_2
VIK280616_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\28062016_VIK_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160628_VIK_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160628_VIK_CH1_TEMP.txt"
)

#ULV 26-07-2016_1
ULV260716_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\26072016_ULV_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160726_ULV_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160726_ULV_CH1_TEMP.txt"
)

#ULV 26-07-2016_2
ULV260716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\26072016_ULV_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160726_ULV_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160726_ULV_CH1_TEMP.txt"
)

#ULV 28-07-2016_1
ULV280716_1<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\28072016_ULV_ch1_1.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160728_ULV_LI1400_CH1_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160728_ULV_CH1_TEMP.txt"
)

#ULV 28-07-2016_2
ULV280716_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\28072016_ULV_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160728_ULV_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160728_ULV_CH1_TEMP.txt"
)

#SKJ 25-08-2016_1
SKJ250816_1<-import.everything(
 meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\25082016_SKJ_ch1_1.txt",
 logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160825_SKJ_LI1400_CH1_1.txt",
 temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160825_SKJ_CH1_TEMP.txt"
)

#SKJ 25-08-2016_2
SKJ250816_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\25082016_SKJ_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160825_SKJ_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160825_SKJ_CH1_TEMP.txt"
)

#SKJ 29-08-2016_1
SKJ290816_1<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\29082016_SKJ_ch1_1.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160829_SKJ_LI1400_CH1_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160829_SKJ_CH1_TEMP.txt"
)

#SKJ 29-08-2016_2
SKJ290816_2<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\29082016_SKJ_ch1_2.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160829_SKJ_LI1400_CH1_2.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160829_SKJ_CH1_TEMP.txt"
)

#SKJ 29-07-2016_1
SKJ290716_1<-import.everything(
  meta= "O:\\FunCab\\Data\\co2flux2016\\metadata files\\29072016_SKJ_ch1_1.txt",
  logger= "O:\\FunCab\\Data\\co2flux2016\\Flux2016 Li1400\\20160729_SKJ_LI1400_CH1_1.txt",
  temp= "O:\\FunCab\\Data\\co2flux2016\\Temperature files\\20160729_SKJ_CH1_TEMP.txt"
)


sapply(ULV020816_1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(ULV020816_1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(ULV020816_1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewULV020816_1<-do.call(rbind, lapply(ULV020816_1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal
