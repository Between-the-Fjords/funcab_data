source("O:\\FunCab\\Data\\Rscript\\R functions2.R") #give exact location of R functions.R file

#site per site test of datafiles

#Arh 05-07-2015
Arhpre1<-import.everything(
  meta="O:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-05 Arhelleren pre cleaned.txt",
  logger="O:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\05-07-15_arhelleren_cleaned.txt",
  temp="O:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\05-07-15_ovstedal&arhelleren.txt"
)

plot.data(Arhpre1[[1]])
plot.data(Arhpre1[[2]])

sapply(Arhpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Arhpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Arhpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewArhpre1<-do.call(rbind, lapply(Arhpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Arh 16-07-2015
Arhpre2<-import.everything(
  meta="O:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-16 Arhelleren pre cleaned.txt",
  logger="O:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\16-17-15_Arhelleren new_cleaned.txt",
  temp="O:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\16-07-15_Arhelleren.txt"
)

plot.data(Arhpre2[[1]])
plot.data(Arhpre2[[2]])

sapply(Arhpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Arhpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Arhpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewArhpre2<-do.call(rbind, lapply(Arhpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Arh 20-07-2015
Arhpre3<-import.everything(
  meta="O:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-20 Arhelleren pre cleaned.txt",
  logger="O:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\20-07-15_Arhelleren_cleaned.txt",
  temp="O:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\20-07-15_arhelleren&ovstedal.txt"
)

plot.data(Arhpre3[[1]])
plot.data(Arhpre3[[2]])

sapply(Arhpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Arhpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Arhpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewArhpre3<-do.call(rbind, lapply(Arhpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Faupre1 30-06-15      
Faupre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-06-30 Fauske pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\30-06-15_Fauske morning_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\30-06-2015_Fauske.txt"
)

plot.data(Faupre1[[1]])
plot.data(Faupre1[[2]])

sapply(Faupre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Faupre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Faupre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewFaupre1<-do.call(rbind, lapply(Faupre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Faupre2 30-06-15      
Faupre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-06-30 Fauske pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\30-06-15_afternoon_new.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\30-06-2015_Fauske.txt"
)          

plot.data(Faupre2[[1]])
plot.data(Faupre2[[2]])

sapply(Faupre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Faupre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Faupre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewFaupre2<-do.call(rbind, lapply(Faupre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Faupre3 10-07-15      
Faupre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-10 Fauske pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\10-07-15_Fauske pre1_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\10-07-15_Fauske.txt"
)

plot.data(Faupre3[[1]])
plot.data(Faupre3[[2]])

sapply(Faupre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Faupre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Faupre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewFaupre3<-do.call(rbind, lapply(Faupre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Faupre4 10-07-15      
Faupre4<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-10 Fauske pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\10-07-15_Fauske pre2_cleaned new2.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\10-07-15_Fauske.txt"
)

plot.data(Faupre4[[1]])
plot.data(Faupre4[[2]])

sapply(Faupre4, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Faupre4, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Faupre4[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewFaupre4<-do.call(rbind, lapply(Faupre4,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Alrpre1 01-07-15      
Alrpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-01 Alrust pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\01-07-15_alrust_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\01-07-15 Alrust pre new.txt"
)

plot.data(Alrpre1[[1]])
plot.data(Alrpre1[[2]])

sapply(Alrpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Alrpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Alrpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewAlrpre1<-do.call(rbind, lapply(Alrpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Alrpre2 09-07-15      
Alrpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-09 Alrust pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\09-07-15_Alrust morning_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\09-07-15_Alrust.txt"
)

plot.data(Alrpre2[[1]])
plot.data(Alrpre2[[2]])

sapply(Alrpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Alrpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Alrpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewAlrpre2<-do.call(rbind, lapply(Alrpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Alrpre3 09-07-15      
Alrpre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-09 Alrust pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\09-07-15_Alrust afternoon_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\09-07-15_Alrust.txt"
)

plot.data(Alrpre3[[1]])
plot.data(Alrpre3[[2]])

sapply(Alrpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Alrpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Alrpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewAlrpre3<-do.call(rbind, lapply(Alrpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

#Vikpre1 02-07-15      
Vikpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-02 Vikesland pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\02-07-15_Vikesland_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\02-07-15_hogsete&vikesland.txt"
)

plot.data(Vikpre1[[1]])
plot.data(Vikpre1[[2]])

sapply(Vikpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewVikpre1<-do.call(rbind, lapply(Vikpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Vikpre2 11-07-15
Vikpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-11 Vikesland pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\11-07-15_Vikesland_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\11-07-15_Hogsete&Vikesland.txt"
)

plot.data(Vikpre2[[1]])
plot.data(Vikpre2[[2]])

sapply(Vikpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewVikpre2<-do.call(rbind, lapply(Vikpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Vikpre3 15-07-15
Vikpre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-15 Vikesland pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\15-07-15_Vikesland new_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\15-07-15_Vikesland.txt"
)

plot.data(Vikpre3[[1]])
plot.data(Vikpre3[[2]])

sapply(Vikpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewVikpre3<-do.call(rbind, lapply(Vikpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Vikpre4 15-07-15/2
Vikpre4<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-15 Vikesland pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\15-07-15_Vikesland2 new_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\15-07-15_Vikesland.txt"
)

plot.data(Vikpre4[[1]])
plot.data(Vikpre4[[2]])

sapply(Vikpre4, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vikpre4, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vikpre4[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewVikpre4<-do.call(rbind, lapply(Vikpre4,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Hogpre1 02-07-15
Hogpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-02 Hogsete pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\02-07-15_Hogsete new_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\02-07-15_hogsete&vikesland.txt"
)

plot.data(Hogpre1[[1]])
plot.data(Hogpre1[[2]])

sapply(Hogpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Hogpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Hogpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewHogpre1<-do.call(rbind, lapply(Hogpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Hogpre2 11-07-15
Hogpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-11 Hogsete pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\11-07-15_Hogsete_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\11-07-15_Hogsete&Vikesland.txt"
)

plot.data(Hogpre2[[1]])
plot.data(Hogpre2[[2]])

sapply(Hogpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Hogpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Hogpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewHogpre2<-do.call(rbind, lapply(Hogpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Hogpre3 28-07-15
Hogpre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-28 HOG pre3.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\28-7-15_Hogsete_new.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\28-7-15_Hogsete.txt"
)

plot.data(Hogpre3[[1]])
plot.data(Hogpre3[[2]])

sapply(Hogpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Hogpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Hogpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewHogpre3<-do.call(rbind, lapply(Hogpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Ovspre1 05-07-15
Ovspre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-05 Ovstedahl pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\05-07-05_ovstedalen new_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\05-07-15_ovstedal&arhelleren.txt"
)

plot.data(Ovspre1[[1]])
plot.data(Ovspre1[[2]])

sapply(Ovspre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ovspre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ovspre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewOvspre1<-do.call(rbind, lapply(Ovspre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Ovspre2 20-07-15
Ovspre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-20 Ovstedahl pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\20-07-15_ovstedal_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\20-07-15_arhelleren&ovstedal.txt"
)

plot.data(Ovspre2[[1]])
plot.data(Ovspre2[[2]])

sapply(Ovspre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ovspre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ovspre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewOvspre2<-do.call(rbind, lapply(Ovspre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Ovspre3 25-07-15
Ovspre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-25 OVS pre.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\25-7-15_Ovstedal_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\25-7-15_ovstedal.txt"
)

plot.data(Ovspre3[[1]])
plot.data(Ovspre3[[2]])

sapply(Ovspre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ovspre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ovspre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewOvspre3<-do.call(rbind, lapply(Ovspre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Ulvpre1 17-07-15
Ulvpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-17 ulvhaugen pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\17-07-15_Ulvhaugen new_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\17-07-15_ Ulvhaugen.txt"
)

plot.data(Ulvpre1[[1]])
plot.data(Ulvpre1[[2]])

sapply(Ulvpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewUlvpre1<-do.call(rbind, lapply(Ulvpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Ulvpre2 17-07-15
Ulvpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-17 ulvhaugen pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\17-07-15_Ulvhaugen2_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\17-07-15_ Ulvhaugen.txt"
)

plot.data(Ulvpre2[[1]])
plot.data(Ulvpre2[[2]])

sapply(Ulvpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewUlvpre2<-do.call(rbind, lapply(Ulvpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Ulvpre3 31-07-15
Ulvpre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-31 Ulvhaugen pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\31-7-15_Ulvhaugen_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\31-7-15_Ulvhaugen.txt"
)

plot.data(Ulvpre3[[1]])
plot.data(Ulvpre3[[2]])

sapply(Ulvpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewUlvpre3<-do.call(rbind, lapply(Ulvpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Ulvpre4 31-07-15
Ulvpre4<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-31 Ulvhaugen pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\31-7-15_Ulvhaugen2_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\31-7-15_Ulvhaugen.txt"
)

plot.data(Ulvpre4[[1]])
plot.data(Ulvpre4[[2]])

sapply(Ulvpre4, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Ulvpre4, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Ulvpre4[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewUlvpre4<-do.call(rbind, lapply(Ulvpre4,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Vespre1 29-07-15
Vespre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-29 Veskre pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\29-7-15_Veskre1_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\29-7-15_veskre.txt"
)

plot.data(Vespre1[[1]])
plot.data(Vespre1[[2]])

sapply(Vespre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vespre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vespre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewVespre1<-do.call(rbind, lapply(Vespre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Vespre2 29-07-15
Vespre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-07-29 Veskre pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\29-7-15_Veskre2_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\29-7-15_veskre.txt"
)

plot.data(Vespre2[[1]])
plot.data(Vespre2[[2]])

sapply(Vespre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Vespre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Vespre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewVespre2<-do.call(rbind, lapply(Vespre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Lavpre1 07-08-15
Lavpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-07 lavisdalen pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\07-08-15_lavisdalen pre1 new_cleaned2.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\07-08-15_Lavisdalen pre1&2.txt"
)

plot.data(Lavpre1[[1]])
plot.data(Lavpre1[[2]])

sapply(Lavpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Lavpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Lavpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewLavpre1<-do.call(rbind, lapply(Lavpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Lavpre2 07-08-15
Lavpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-07 lavisdalen pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\07-08-15_Lavisdalen pre2_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\07-08-15_Lavisdalen pre1&2.txt"
)

plot.data(Lavpre2[[1]])
plot.data(Lavpre2[[2]])

sapply(Lavpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Lavpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Lavpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewLavpre2<-do.call(rbind, lapply(Lavpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Lavpre3 07-08-15
Lavpre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-08 Lavisdalen pre3 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\08-08-15_Lavisdalen pre3_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\08-08-15_Gudmedalen&Lavisdalen pre.txt"
)

plot.data(Lavpre3[[1]])
plot.data(Lavpre3[[2]])

sapply(Lavpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Lavpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Lavpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewLavpre3<-do.call(rbind, lapply(Lavpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Gudpre1 08-08-15
Gudpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-08 Gudmedalen pre cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\08-08-15_Gudmedalen pre1_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\08-08-15_Gudmedalen&Lavisdalen pre.txt"
)

plot.data(Gudpre1[[1]])
plot.data(Gudpre1[[2]])

sapply(Gudpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Gudpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Gudpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewGudpre1<-do.call(rbind, lapply(Gudpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Gudpre2 08-08-15
Gudpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-08 Gudmedalen pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\08-08-15_Gudmedalen pre2_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\08-08-15_Gudmedalen&Lavisdalen pre.txt"
)

plot.data(Gudpre2[[1]])
plot.data(Gudpre2[[2]])

sapply(Gudpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Gudpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Gudpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewGudpre2<-do.call(rbind, lapply(Gudpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Rampre1 11-08-15
Rampre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-11 Rambera pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\11-8-15 rambera pre1_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\11-08-15_Rambera pre.txt"
)

plot.data(Rampre1[[1]])
plot.data(Rampre1[[2]])

sapply(Rampre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Rampre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Rampre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewRampre1<-do.call(rbind, lapply(Rampre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Rampre2 11-08-15
Rampre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-11 Rambera pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\11-08-15_rambera pre2 new_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\11-08-15_Rambera pre.txt"
)

plot.data(Rampre2[[1]])
plot.data(Rampre2[[2]])

sapply(Rampre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Rampre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation

fluxcalc(Rampre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewRampre2<-do.call(rbind, lapply(Rampre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Rampre3 12-08-15
Rampre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-08-12 Rambera pre3 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\12-8-15_rambera pre3_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\12-08-15_Veskre&Rambera.txt"
)

plot.data(Rampre3[[1]])
plot.data(Rampre3[[2]])

sapply(Rampre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Rampre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Rampre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewRampre3<-do.call(rbind, lapply(Rampre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Skjpre1 06-09-15
Skjpre1<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-09-06 skjelingenhaugen pre1 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\06-09-15_skjellingahaugen pre1_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\06-09-15_Skjelingenhaugen pre.txt"
)

plot.data(Skjpre1[[1]])
plot.data(Skjpre1[[2]])

sapply(Skjpre1, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Skjpre1, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Skjpre1[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewSkjpre1<-do.call(rbind, lapply(Skjpre1,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Skjpre2 06-09-15
Skjpre2<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-09-06 skjelingenhaugen pre2 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\06-09-15_skjellingahaugen pre2_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\06-09-15_Skjelingenhaugen pre.txt"
)

plot.data(Skjpre2[[1]])
plot.data(Skjpre2[[2]])

sapply(Skjpre2, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Skjpre2, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Skjpre2[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewSkjpre2<-do.call(rbind, lapply(Skjpre2,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal


# Skjpre3 07-09-15
Skjpre3<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-09-07 skjelingenhaugen pre3 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\07-09-15_skjellingahaugen pre3_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\07-09-15_skjellingahaugen pre.txt"
)

plot.data(Skjpre3[[1]])
plot.data(Skjpre3[[2]])

sapply(Skjpre3, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Skjpre3, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Skjpre3[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewSkjpre3<-do.call(rbind, lapply(Skjpre3,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal

# Skjpre4 07-09-15
Skjpre4<-import.everything(
  meta="o:\\FunCab\\Data\\CO2 flux\\liCOR\\data files txt\\2015-09-07 skjelingenhaugen pre4 cleaned.txt",
  logger="o:\\FunCab\\Data\\CO2 flux\\liCOR\\processed\\07-09-15_skjellingahaugen pre4_cleaned.txt",
  temp="o:\\FunCab\\Data\\CO2 flux\\temperature CO2 flux\\07-09-15_skjellingahaugen pre.txt"
)

plot.data(Skjpre4[[1]])
plot.data(Skjpre4[[2]])

sapply(Skjpre4, function(i)coef(plot.data(i))[2])
x11(width=13, height=8)
par(mfrow=c(10,7), mar=c(.5,3,1,1), mgp=c(1.5,.5,0))
sapply(Skjpre4, function(i)coef(plot.data(i, xlab="", xaxt="n"))[2])
axis(1)

#flux calculation
fluxcalc(Skjpre4[[1]]) # running function fluxcalc on single entry in files imported in Arhpre1
overviewSkjpre4<-do.call(rbind, lapply(Skjpre4,fluxcalc)) #table overview of data from Arhpre1& results of fluxcal