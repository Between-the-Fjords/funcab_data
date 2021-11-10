source("O:\\FunCab\\Data\\Rscript\\R functions2.R") #give exact location of R functions.R file

#site per site test of datafiles

#Alr 27-07-2015
Alrafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-07-27 ALR after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/27-7-15_Alrust after.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/27-7-15_Alrust.txt"
)

plot.data(Alrafter1[[1]])
plot.data(Alrafter1[[2]])

sapply(Alrafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Alrafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Alrafter1[[1]]) # running function fluxcalc on single entry in files imported in Alrafter1
overviewAlrafter1<-do.call(rbind, lapply(Alrafter1,fluxcalc)) #table overview of data from Alrafter1& results of 

#Alr 27-07-2015
Alrafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-07-27 ALR after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/27-7-15_Alrust after2_new.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/27-7-15_Alrust.txt"
)

plot.data(Alrafter2[[1]])
plot.data(Alrafter2[[2]])

sapply(Alrafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Alrafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Alrafter2[[1]]) 
overviewAlrafter2<-do.call(rbind, lapply(Alrafter2,fluxcalc)) 

#Fau 30-07-2015
Fauafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-07-30 FAU after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/30-7-15_Fauske after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/30-7-15_Fauske after.txt"
)

plot.data(Fauafter1[[1]])
plot.data(Fauafter1[[2]])

sapply(Fauafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Fauafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Fauafter1[[1]]) 
overviewFauafter1<-do.call(rbind, lapply(Fauafter1,fluxcalc))

#Fau 30-07-2015
Fauafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-07-30 FAU after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/30-7-15_Fauske after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/30-7-15_Fauske after.txt"
)

plot.data(Fauafter2[[1]])
plot.data(Fauafter2[[2]])

sapply(Fauafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Fauafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Fauafter2[[1]]) 
overviewFauafter2<-do.call(rbind, lapply(Fauafter2,fluxcalc))

#Fau 30-07-2015
Fauafter3<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-07-30 FAU after3.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/30-7-15_Fauske after3.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/30-7-15_Fauske after.txt"
)

plot.data(Fauafter3[[1]])
plot.data(Fauafter3[[2]])

sapply(Fauafter3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Fauafter3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Fauafter3[[1]]) 
overviewFauafter3<-do.call(rbind, lapply(Fauafter3,fluxcalc))

#Ovs 03-08-2015
Ovsafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-03 OVS after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/3-8-2015_Ovstedal after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/03-8-15_ovstedahl after.txt"
)

plot.data(Ovsafter1[[1]])
plot.data(Ovsafter1[[2]])

sapply(Ovsafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ovsafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ovsafter1[[1]]) 
overviewOvsafter1<-do.call(rbind, lapply(Ovsafter1,fluxcalc))

#Ovs 03-08-2015
Ovsafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-03 OVS after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/3-8-15_Ovstedahl2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/03-8-15_ovstedahl after.txt"
)

plot.data(Ovsafter2[[1]])
plot.data(Ovsafter2[[2]])

sapply(Ovsafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ovsafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ovsafter2[[1]]) 
overviewOvsafter2<-do.call(rbind, lapply(Ovsafter2,fluxcalc))

#Ovs 03-08-2015
Ovsafter3<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-03 OVS after3.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/03-8-15_ovstedahl3.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/03-8-15_ovstedahl after.txt"
)

plot.data(Ovsafter3[[1]])
plot.data(Ovsafter3[[2]])

sapply(Ovsafter3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ovsafter3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ovsafter3[[1]]) 
overviewOvsafter3<-do.call(rbind, lapply(Ovsafter3,fluxcalc))

#Vik 04-08-2015
Vikafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-04 VIK after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/04-8-15_vikesland after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/04-8-15_vikesland after.txt"
)

plot.data(Vikafter1[[1]])
plot.data(Vikafter1[[2]])

sapply(Vikafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikafter1[[1]]) 
overviewVikafter1<-do.call(rbind, lapply(Vikafter1,fluxcalc))

#Vik 05-08-2015
Vikafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-05 VIK after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/05-8-15_Vikesland after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/05-08-15_Hogsete&Vikesland after.txt"
)

plot.data(Vikafter2[[1]])
plot.data(Vikafter2[[2]])

sapply(Vikafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikafter2[[1]]) 
overviewVikafter2<-do.call(rbind, lapply(Vikafter2,fluxcalc))
                           
#Vik 05-08-2015
Vikafter3<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-05 VIK after3.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/05-08-15_Vikesland after3.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/05-08-15_Hogsete&Vikesland after.txt"
)

plot.data(Vikafter3[[1]])
plot.data(Vikafter3[[2]])

sapply(Vikafter3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikafter3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikafter3[[1]]) 
overviewVikafter3<-do.call(rbind, lapply(Vikafter3,fluxcalc))

#Hog 05-08-2015
Hogafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-05 HOG after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/05-08-15_Hogsete after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/05-08-15_Hogsete&Vikesland after.txt"
)

plot.data(Hogafter1[[1]])
plot.data(Hogafter1[[2]])

sapply(Hogafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Hogafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Hogafter1[[1]]) 
overviewHogafter1<-do.call(rbind, lapply(Hogafter1,fluxcalc))

#Hog 06-08-2015
Hogafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-06 HOG after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/06-08-15_Hogsete after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/06-08-15_hogsete after2&3.txt"
)

plot.data(Hogafter2[[1]])
plot.data(Hogafter2[[2]])

sapply(Hogafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Hogafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Hogafter2[[1]]) 
overviewHogafter2<-do.call(rbind, lapply(Hogafter2,fluxcalc))

#Hog 06-08-2015
Hogafter3<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-06 HOG after3.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/06-08-15_Hogsete after3.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/06-08-15_hogsete after2&3.txt"
)

plot.data(Hogafter3[[1]])
plot.data(Hogafter3[[2]])

sapply(Hogafter3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Hogafter3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Hogafter3[[1]]) 
overviewHogafter3<-do.call(rbind, lapply(Hogafter3,fluxcalc))

#Ves 12-08-2015
Vesafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-12 VES after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/12-8-15_veskre after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/12-08-15_Veskre&Rambera.txt"
)

plot.data(Vesafter1[[1]])
plot.data(Vesafter1[[2]])

sapply(Vesafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vesafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vesafter1[[1]]) 
overviewVesafter1<-do.call(rbind, lapply(Vesafter1,fluxcalc))

#Ves 12-08-2015
Vesafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-12 VES after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/12-8-15_Veskre after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/12-08-15_Veskre&Rambera.txt"
)

plot.data(Vesafter2[[1]])
plot.data(Vesafter2[[2]])

sapply(Vesafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vesafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vesafter2[[1]]) 
overviewVesafter2<-do.call(rbind, lapply(Vesafter2,fluxcalc))

#Arh 13-08-2015
Arhafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-13 ARH after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/13-8-15_Arhelleren after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/13-8-15_Arhelleren after.txt"
)

plot.data(Arhafter1[[1]])
plot.data(Arhafter1[[2]])

sapply(Arhafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Arhafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Arhafter1[[1]]) 
overviewArhafter1<-do.call(rbind, lapply(Arhafter1,fluxcalc))

#Arh 13-08-2015
Arhafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-13 ARH after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/13-8-15_Arhelleren after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/13-8-15_Arhelleren after.txt"
)

plot.data(Arhafter2[[1]])
plot.data(Arhafter2[[2]])

sapply(Arhafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Arhafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Arhafter2[[1]]) 
overviewArhafter2<-do.call(rbind, lapply(Arhafter2,fluxcalc))

#Ulv 14-08-2015
Ulvafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-14 ULV after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/14-8-15_Ulvhaugen.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/14-8-15_Ulvhaugen after.txt"
)

plot.data(Ulvafter1[[1]])
plot.data(Ulvafter1[[2]])

sapply(Ulvafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvafter1[[1]]) 
overviewUlvafter1<-do.call(rbind, lapply(Ulvafter1,fluxcalc))

#Ulv 14-08-2015
Ulvafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-14 ULV after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/14-08-15_ulvhaugen after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/14-8-15_Ulvhaugen after.txt"
)

plot.data(Ulvafter2[[1]])
plot.data(Ulvafter2[[2]])

sapply(Ulvafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvafter2[[1]]) 
overviewUlvafter2<-do.call(rbind, lapply(Ulvafter2,fluxcalc))

#Ulv 15-08-2015
Ulvafter3<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-15 ULV after3.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/15-08-15_Ulvhaugen after3.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/15-08-15_Ulvhaugen after3.txt"
)

plot.data(Ulvafter3[[1]])
plot.data(Ulvafter3[[2]])

sapply(Ulvafter3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvafter3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvafter3[[1]]) 
overviewUlvafter3<-do.call(rbind, lapply(Ulvafter3,fluxcalc))

#Gud 18-08-2015
Gudafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-18 GUD after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/18-08-15_Gudmedalen after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/18-08-15_Gudmedalen after.txt"
)

plot.data(Gudafter1[[1]])
plot.data(Gudafter1[[2]])

sapply(Gudafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Gudafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Gudafter1[[1]]) 
overviewGudafter1<-do.call(rbind, lapply(Gudafter1,fluxcalc))

#Gud 18-08-2015
Gudafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-18 GUD after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/18-08-15_Gudmedalen after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/18-08-15_Gudmedalen after.txt"
)

plot.data(Gudafter2[[1]])
plot.data(Gudafter2[[2]])

sapply(Gudafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Gudafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Gudafter2[[1]]) 
overviewGudafter2<-do.call(rbind, lapply(Gudafter2,fluxcalc))

#Lav 19-08-2015
Lavafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-19 LAV after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/19-08-15_Lavisdalen after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/19-08-15_Lavisdalen after.txt"
)

plot.data(Lavafter1[[1]])
plot.data(Lavafter1[[2]])

sapply(Lavafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Lavafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Lavafter1[[1]]) 
overviewLavafter1<-do.call(rbind, lapply(Lavafter1,fluxcalc))

#Lav 19-08-2015
Lavafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-19 LAV after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/19-08-15_Lavisdalen after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/19-08-15_Lavisdalen after.txt"
)

plot.data(Lavafter2[[1]])
plot.data(Lavafter2[[2]])

sapply(Lavafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Lavafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Lavafter2[[1]]) 
overviewLavafter2<-do.call(rbind, lapply(Lavafter2,fluxcalc))

#Lav 19-08-2015
Lavafter3<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-19 LAV after3.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/19-08-15_Lavisdalen after3.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/19-08-15_Lavisdalen after.txt"
)

plot.data(Lavafter3[[1]])
plot.data(Lavafter3[[2]])

sapply(Lavafter3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Lavafter3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Lavafter3[[1]]) 
overviewLavafter3<-do.call(rbind, lapply(Lavafter3,fluxcalc))

#Ram 20-08-2015
Ramafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-20 RAM after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/20-08-15_Rambera after1 block 1&4.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/20-08-15_Rambera after.txt"
)

plot.data(Ramafter1[[1]])
plot.data(Ramafter1[[2]])

sapply(Ramafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ramafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ramafter1[[1]]) 
overviewRamafter1<-do.call(rbind, lapply(Ramafter1,fluxcalc))

#Ram 20-08-2015
Ramafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-08-20 RAM after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/20-08-15_Rambera after2 block 5&2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/20-08-15_Rambera after.txt"
)

plot.data(Ramafter2[[1]])
plot.data(Ramafter2[[2]])

sapply(Ramafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ramafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ramafter2[[1]]) 
overviewRamafter2<-do.call(rbind, lapply(Ramafter2,fluxcalc))

#Skj 16-09-2015
Skjafter1<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-09-16 SKJ after1.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/16-09-15_skjelingenhaugen after1.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/16-09-15_skjelingenhaugen after.txt"
)

plot.data(Skjafter1[[1]])
plot.data(Skjafter1[[2]])

sapply(Skjafter1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Skjafter1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Skjafter1[[1]]) 
overviewSkjafter1<-do.call(rbind, lapply(Skjafter1,fluxcalc))

#Skj 16-09-2015
Skjafter2<-import.everything(
  meta="O://FunCab/Data/CO2 flux/liCOR/data files txt/after/2015-09-16 SKJ after2.txt",
  logger="O://FunCab/Data/CO2 flux/liCOR/16-09-15_skjelingenhaugen after2.txt",
  temp="O://FunCab/Data/CO2 flux/temperature CO2 flux/16-09-15_skjelingenhaugen after.txt"
)

plot.data(Skjafter2[[1]])
plot.data(Skjafter2[[2]])

sapply(Skjafter2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Skjafter2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Skjafter2[[1]]) 
overviewSkjafter2<-do.call(rbind, lapply(Skjafter2,fluxcalc))