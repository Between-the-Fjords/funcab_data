#test datafiles 2016

source("R/cflux/functions/import_process_CO2data_2017.R")
source("R/cflux/functions/import_process_SQlogger_2017.R")
source("R/cflux/functions/CO2flux_calculation.R")
source("R/cflux/functions/CO2_plot2017.R")#give exact location of R functions.R file
library(data.table)

# temp.data = file containing data from Ibutton
# log.data = file containing data of logger (Li1400/Squirrel)
# meta.data = file containing metadata of measurements
# combine.data combines the 3 files together and matches start/stop time of metadata file to times in temperature and datalogger files
# setStartEndTimes is a function for graphing CO2 and PAR data of single measurements and one can change the timeframe by entering new start and endtimes # write table of resulting dataframe based on SetStartEndTimes function

#ULV 01=08-2017_1
temp.data<-read.ibutton("C:\\Users\\ial008\\OneDrive - NORCE\\FunCab\\Data\\2017TEMP\\01082017_LI14000T_ULV.txt")
log.data<-read.logger("C:\\Users\\ial008\\OneDrive - NORCE\\FunCab\\Data\\2017Li1400\\01082017ULV_1.txt")
meta.data<-read.metadata("C:\\Users\\ial008\\OneDrive - NORCE\\FunCab\\Data\\CO2_metadata2017\\01082017_ULV_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ULV010817_1newTime<-setStartEndTimes(combine.data)

df<- as.data.frame(matrix(nrow = 62, ncol= 15))
for (i in 1:62){
  df[i,]<- ULV010817_1newTime[[i]]$meta
}
colnames(df) <- c("date", "site", "block", "treatment", "chamber","starttime", "stoptime", "PAR", "cover", "soilT", "weather", "comment", "flag", "tstart", "tfinish")


write.table(df, row.names = FALSE, file = "O:\\FunCab\\Data\\CO2_metadata2017\\25072017_ULV_ch2_1newtimes.txt")

#ULV 01=08-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\01082017_LI14000T_ULV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\01082017ULV_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\01082017_ULV_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ULV010817_2newTime<-setStartEndTimes(combine.data)

#ULV 01=08-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\01082017_LI14000T_ULV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\01082017ULV_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\01082017_ULV_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ULV010817_3newTime<-setStartEndTimes(combine.data)

#ALR 03-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\03072017_LI14000T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\03072017ALR_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\03072017_ALR_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ALR030717_1newTime<-setStartEndTimes(combine.data)

#ALR 03-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\03072017_LI14000T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\03072017ALR_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\03072017_ALR_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ALR030717_2newTime<-setStartEndTimes(combine.data)

#ALR 03-07-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\03072017_LI14000T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\03072017ALR_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\03072017_ALR_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ALR030717_3newTime<-setStartEndTimes(combine.data)

#ALR 04-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\04072017_LI14000T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\04072017ALR_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\04072017_ALR_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ALR040717_1newTime<-setStartEndTimes(combine.data)

#ALR 04-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\04072017_LI14000T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\04072017ALR_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\04072017_ALR_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ALR040717_2newTime<-setStartEndTimes(combine.data)

#ALR 04-07-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\04072017_LI14000T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\04072017ALR_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\04072017_ALR_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ALR040717_3newTime<-setStartEndTimes(combine.data)

#FAU 05-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\05072017_LI14000T_FAU.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\05072017FAU_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\05072017_FAU_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
FAU050717_1newTime<-setStartEndTimes(combine.data)

#FAU 05-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\05072017_LI14000T_FAU.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\05072017FAU_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\05072017_FAU_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
FAU050717_2newTime<-setStartEndTimes(combine.data)

#FAU 05-07-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\05072017_LI14000T_FAU.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\05072017FAU_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\05072017_FAU_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
FAU050717_3newTime<-setStartEndTimes(combine.data)

#FAU 06-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\06072017_LI14000T_FAU.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\06072017FAU_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\06072017_FAU_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
FAU060717_1newTime<-setStartEndTimes(combine.data)

#FAU 06-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\06072017_LI14000T_FAU.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\06072017FAU_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\06072017_FAU_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
FAU060717_2newTime<-setStartEndTimes(combine.data)

#OVS 11-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\11072017OVS_Li1400T.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\11072017OVS_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\11072017_OVS_ch1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
OVS110717_1newTime<-setStartEndTimes(combine.data)

#VES 12-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\12072017_LI14000T_VES.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\12072017VES_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\12072017_VES_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VES120717_1newTime<-setStartEndTimes(combine.data)

#VES 12-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\12072017_LI14000T_VES.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\12072017VES_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\12072017_VES_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VES120717_2newTime<-setStartEndTimes(combine.data)

#VES 13-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\13072017_LI14000T_VES.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\13072017VES_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\13072017_VES_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VES130717_1newTime<-setStartEndTimes(combine.data)

#VES 13-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\13072017_LI14000T_VES.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\13072017VES_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\13072017_VES_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VES130717_2newTime<-setStartEndTimes(combine.data)

#OVS 18-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\18072017_LI14000T_OVS.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\18072017OVS_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\18072017_OVS_ch1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
OVS180717_1newTime<-setStartEndTimes(combine.data)

#OVS 19-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\19072017_LI14000T_OVS.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\19072017OVS_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\19072017_OVS_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
OVS190717_1newTime<-setStartEndTimes(combine.data)

#OVS 19-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\19072017_LI14000T_OVS.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\19072017OVS_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\19072017_OVS_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
OVS190717_2newTime<-setStartEndTimes(combine.data)

#OVS 19-07-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\19072017_LI14000T_OVS.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\19072017OVS_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\19072017_OVS_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
OVS190717_3newTime<-setStartEndTimes(combine.data)

#LAV 20-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\20072017_LI14000T_LAV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\20072017LAV_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\20072017_LAV_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
LAV200717_1newTime<-setStartEndTimes(combine.data)

#LAV 20-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\20072017_LI14000T_LAV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\20072017LAV_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\20072017_LAV_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
LAV200717_2newTime<-setStartEndTimes(combine.data)

#LAV 20-07-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\20072017_LI14000T_LAV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\20072017LAV_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\20072017_LAV_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
LAV200717_3newTime<-setStartEndTimes(combine.data)

#SKJ 23-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\23072017_LI14000T_SKJ.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\23072017SKJ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\23072017_SKJ_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
SKJ230717_1newTime<-setStartEndTimes(combine.data)

#SKJ 23-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\23072017_LI14000T_SKJ.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\23072017SKJ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\23072017_SKJ_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
SKJ230717_2newTime<-setStartEndTimes(combine.data)

#SKJ 23-07-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\23072017_LI14000T_SKJ.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\23072017SKJ_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\23072017_SKJ_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
SKJ230717_3newTime<-setStartEndTimes(combine.data)

#ULV 25-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\25072017_LI14000T_ULV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\25072017ULV_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\25072017_ULV_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ULV250717_1newTime<-setStartEndTimes(combine.data)

#ULV 25-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\25072017_LI14000T_ULV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\25072017ULV_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\25072017_ULV_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
ULV250717_2newTime<-setStartEndTimes(combine.data)

#VIK 26-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\26062017VIK_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\26062017VIK_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\26062017_VIK_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VIK260617_1newTime<-setStartEndTimes(combine.data)

#VIK 26-06-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\26062017VIK_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\26062017VIK_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\26062017_VIK_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VIK260617_2newTime<-setStartEndTimes(combine.data)

#LAV 26-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\26072017_LI14000T_LAV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\26072017LAV_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\26072017_LAV_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
LAV260717_1newTime<-setStartEndTimes(combine.data)

#LAV 26-07-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\26072017_LI14000T_LAV.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\26072017LAV_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\26072017_LAV_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
LAV260717_2newTime<-setStartEndTimes(combine.data)

#HOG 27-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\27062017HOG_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\27062017HOG_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\27062017_HOG_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG270617_1newTime<-setStartEndTimes(combine.data)

#HOG 27-06-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\27062017HOG_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\27062017HOG_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\27062017_HOG_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG270617_2newTime<-setStartEndTimes(combine.data)

#HOG 28-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\28062017HOG_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\28062017HOG_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\28062017_HOG_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG280617_1newTime<-setStartEndTimes(combine.data)

#HOG 28-06-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\28062017HOG_LI1400_2.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\28062017HOG_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\28062017_HOG_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG280617_2newTime<-setStartEndTimes(combine.data)

#HOG 28-06-2017_3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\28062017HOG_LI1400_3.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\28062017HOG_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\28062017_HOG_ch1_3.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG280617_3newTime<-setStartEndTimes(combine.data)

#HOG 29-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\29062017HOG_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\29062017HOG_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\29062017_HOG_ch1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG290617_1newTime<-setStartEndTimes(combine.data)

#VIK 29-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\29062017VIK_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\29062017VIK_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\29062017_VIK_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VIK290617_1newTime<-setStartEndTimes(combine.data)

#VIK 29-06-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\29062017VIK_LI1400_2.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\29062017VIK_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\29062017_VIK_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VIK290617_2newTime<-setStartEndTimes(combine.data)

#HOG 30-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\30062017HOG_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\30062017HOG_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\30062017_HOG_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
HOG300617_1newTime<-setStartEndTimes(combine.data)

#VIK 30-06-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\30062017VIK_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\30062017VIK_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\30062017_VIK_ch1_1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VIK300617_1newTime<-setStartEndTimes(combine.data)

#VIK 30-06-2017_2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\30062017VIK_LI1400_1.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\30062017VIK_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\30062017_VIK_ch1_2.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
VIK300617_2newTime<-setStartEndTimes(combine.data)

#SKJ 29-07-2017_1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\29072017_LI14000T_SKJ.txt")
log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\29072017SKJ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\29072017_SKJ_ch1.txt")
combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
SKJ290717_1newTime<-setStartEndTimes(combine.data)

df<- as.data.frame(matrix(nrow = 60, ncol= 15))
for (i in 1:60){
  df[i,]<- SKJ290717_1newTime[[i]]$meta
}
colnames(df) <- c("date", "site", "block", "treatment", "chamber","starttime", "stoptime", "PAR", "cover", "soilT", "weather", "comment", "flag", "tstart", "tfinish")
write.table(df, row.names = FALSE, file = "O:\\FunCab\\Data\\CO2_metadata2017\\29072017_SKJ_ch1_1newtimes.txt")



######################################################################################################################################
##### SGlogger data
### First clean environment !!!!!!
source("CO2/R_functions/import_process_SQlogger_2017.R")
source("CO2/R_functions/CO2flux_calculation.R")
source("CO2/R_functions/CO2_plot2017.R")#give exact location of R functions.R file

#ALR 03-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\03072017_SQT.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\03072017ALR_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\03072017_ALR_ch2_1.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
ALR030717_SQ1newTime<-setStartEndTimes(combine.data)

#ALR 03-07-2017_SQ2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\03072017_SQT.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\03072017ALR_SQ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\03072017_ALR_ch2_2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
ALR030717_SQ2newTime<-setStartEndTimes(combine.data)

#ALR 04-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\04072017_SQT.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\04072017ALR_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\04072017_ALR_ch2_1.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
ALR040717_SQ1newTime<-setStartEndTimes(combine.data)

#ALR 04-07-2017_SQ2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\04072017_SQT.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\04072017ALR_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\04072017_ALR_ch2_2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
ALR040717_SQ2newTime<-setStartEndTimes(combine.data)

#FAU 05-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\05072017_SQT_FAU.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\05072017FAU_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\05072017_FAU_ch2_1.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
FAU050717_SQ1newTime<-setStartEndTimes(combine.data)

#FAU 05-07-2017_SQ2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\05072017_SQT_FAU.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\05072017FAU_SQ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\05072017_FAU_ch2_2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
FAU050717_SQ2newTime<-setStartEndTimes(combine.data)

#FAU 06-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\06072017_SQT_FAU.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\06072017FAU_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\06072017_FAU_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
FAU060717_SQ1newTime<-setStartEndTimes(combine.data)

#OVS 11-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\11072017OVS_SQT.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\11072017OVS_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\11072017_OVS_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
OVS110717_SQ1newTime<-setStartEndTimes(combine.data)

#VES 12-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\12072017_SQT.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\12072017VES_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\12072017_VES_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
VES120717_SQ1newTime<-setStartEndTimes(combine.data)

#VES 13-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\13072017_SQT_VES.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\13072017VES_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\13072017_VES_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
VES130717_SQ1newTime<-setStartEndTimes(combine.data)

#OVS 18-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\18072017_SQT_OVS.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\18072017OVS_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\18072017_OVS_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
OVS180717_SQ1newTime<-setStartEndTimes(combine.data)

#OVS 19-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\19072017_SQT_OVS.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\19072017OVS_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\19072017_OVS_ch2_1.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
OVS190717_SQ1newTime<-setStartEndTimes(combine.data)

#OVS 19-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\19072017_SQT_OVS.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\19072017OVS_SQ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\19072017_OVS_ch2_2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
OVS190717_SQ2newTime<-setStartEndTimes(combine.data)

#LAV 20-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\20072017_SQT_LAV.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\20072017LAV_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\20072017_LAV_ch2_1.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
LAV200717_SQ1newTime<-setStartEndTimes(combine.data)

#LAV 20-07-2017_SQ2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\20072017_SQT_LAV.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\20072017LAV_SQ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\20072017_LAV_ch2_2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
LAV200717_SQ2newTime<-setStartEndTimes(combine.data)

#LAV 20-07-2017_SQ3
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\20072017_SQT_LAV.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\20072017LAV_SQ_3.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\20072017_LAV_ch2_3.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
LAV200717_SQ3newTime<-setStartEndTimes(combine.data)

#LAV 26-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\26072017_SQT_LAV.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\26072017LAV_SQ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\26072017_LAV_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
LAV260717_SQ1newTime<-setStartEndTimes(combine.data)

#SKJ 23-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\23072017_SQT_SKJ.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\23072017SKJ_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\23072017_SKJ_ch2_1.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
SKJ230717_SQ1newTime<-setStartEndTimes(combine.data)

#SKJ 23-07-2017_SQ2
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\23072017_SQT_SKJ.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\23072017SKJ_SQ_2.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\23072017_SKJ_ch2_2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
SKJ230717_SQ2newTime<-setStartEndTimes(combine.data)

#ULV 25-07-2017_SQ1
temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\25072017_SQT_ULV.txt")
log.data<-read.SQlogger("O:\\FunCab\\Data\\2017SQ\\25072017ULV_SQ_1.txt")
meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\25072017_ULV_ch2.txt")
combine.data<-process.SQdata(meta=meta.data, logger=log.data, temp=temp.data)
ULV250717_SQ1newTime<-setStartEndTimes(combine.data)


