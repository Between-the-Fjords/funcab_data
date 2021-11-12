
# import temperature data from Ibutton
read.ibutton<-function(file){
  ibut<-read.csv(file, header=FALSE)
  names(ibut)<-c("datetime", "C", "temp", "temp2") #give names to columns
  ibut$temp<-ibut$temp+ibut$temp2/1000 # summing two temperature columns
  ibut$temp2<-NULL # setting temp2 column to null after it has been added to ibut$temp
  ibut$C<-NULL # setting C column to null
  ibut$datetime<- dmy_hms(ibut$datetime, tz = "Europe/Oslo") #right format for reading datetime

  ibut
}

#temp.data<-read.ibutton("O:\\FunCab\\Data\\2017TEMP\\01082017_LI14000T_ULV.txt")
#plot(temp.data)


# calc mean temp between start and stoptime
meantemp<-function(ibut, start, stop){
  temp<-approx(x=ibut$datetime, y=ibut$temp, xout = c(start, stop))$y
  mean(temp)
}

#meantemp(temp.data,start=temp.data$datetime[1],stop=temp.data$datetime[2])


# import CO2 and PAR data from datalogger
read.logger<-function(file){
  log<-read.table(file, header=FALSE, skip = 12, fill=TRUE, sep="\t", stringsAsFactors = FALSE, col.names=c("indicator", "datetime", "value", "flag"))
  log$value<-suppressWarnings(as.numeric(log$value))
  log<-log[!is.na(log$value),] #skips data is not numeric

  #  if(ncol(log)==3){
  #    names(log)<-c("indicator", "datetime", "value")
  #    log$flag<-""
  #  }else if(ncol(log)>3){
  #    log<-log[,1:4]
  #   names(log)<-c("indicator", "datetime", "value", "flag")
  #  }

  # leave out flagged values "x" (outliers) from
  log$flag[is.na(log$flag)]<-""
  log$keep<-log$flag!="x"

  log<-log[log$indicator%in%c(1,2,3),]
  datetime<- as.POSIXct(log$datetime, tz="", format="%Y-%m-%d %H:%M:%S")
  if(all(is.na(datetime))){
    datetime<- as.POSIXct(log$datetime, tz="", format="%d.%m.%Y %H:%M:%S")

  }
  log$datetime<-datetime
  log <- log[, 1:5]# remove junk

  list(CO2=log[log$indicator==2, -1], PAR=log[log$indicator==1, -1], H2O=log[log$indicator==3, -1])
}


#load logger file and assign log.data to different parameters
#log.data<-read.logger("O:\\FunCab\\Data\\2017Li1400\\01082017ULV_1.txt")
#CO2<-log.data$CO2
#PAR<-log.data$PAR
#H2O<-log.data$H2O

#plot(CO2$datetime, CO2$value)
#plot(PAR$datetime, PAR$value)
#plot(H2O$datetime, H2O$value)

#file <- "CO2/Data/CO2_metadata2017/01082017_ULV_ch1_1.txt"
# import metadata of site
read.metadata<-function(file){
  metdat<-read.table(file, header=TRUE, fill=TRUE, stringsAsFactors = FALSE)
  names(metdat)<-c("date", "site", "block", "treatment", "chamber", "starttime", "stoptime", "PAR", "cover", "soilT", "weather", "comment", "flag")
  #metdat<- metdat[-c(13)]
  metdat$starttime<- as.POSIXct(paste(metdat$date, metdat$starttime), tz="", format="%d.%m.%Y %H:%M:%S")
  metdat$stoptime<- as.POSIXct(paste(metdat$date, metdat$stoptime), tz="", format="%d.%m.%Y %H:%M:%S")
  #metdat$date<-NULL
  plot(metdat$starttime)#check
  points(metdat$stoptime, col=2)
  metdat
}

#meta.data<-read.metadata("O:\\FunCab\\Data\\CO2_metadata2017\\01082017_ULV_ch1_1.txt")


#look for start and stoptimes of each measurement in metadata file within logger.data and temp.data
process.data <- function(meta, logger, temp){
  cleaner<-lapply(1:nrow(meta), function( i){

    metdat<-meta[i,]
    if(!is.na(metdat$flag)&metdat$flag=="x" )return(NULL) # leave out measurements that are flagged "x"

    #linking start/stoptime from metadata to CO2, PAR and H2O data from logger
    startCO2<-which(logger$CO2$datetime==metdat$starttime)#or next
    if(length(startCO2)==0){
      dif<-logger$CO2$datetime-metdat$starttime
      startCO2<-which.max(dif>0)
    }

    stopCO2 <- which(logger$CO2$datetime == metdat$stoptime)#or most recent
    #stopifnot(length(stopCO2)>0,length(stopCO2)>0)
    if (length(stopCO2) == 0) {
      dif <- logger$CO2$datetime - metdat$stoptime
      stopCO2 <- which.max(!dif < 0) - 1
      warning("taking most recent CO2 value")
    }

    co2 <- logger$CO2[startCO2:stopCO2, ]
    co2$time <- unclass(co2$datetime - co2$datetime[1])
    co2 <- rename(co2, CO2 = value)

    # plot co2 against time and fit a loess trough data to identify outliers
    #co2.fit<- with(co2, loess.smooth(time, CO2), span= 2/3, family = "gaussian")
    #resid <- resid(co2.fit)
    #fitted <- fitted(co2.fit)

    #plot(fitted, resid)
    #abline(h = 0, col= 8)



    startpar<-which(logger$PAR$datetime==metdat$starttime)#or next
    if(length(startpar)==0){
      dif<-logger$PAR$datetime-metdat$starttime
      startpar<-which.max(dif>0)
    }
    stoppar<-which(logger$PAR$datetime==metdat$stoptime)#or most recent
    if(length(stoppar)==0){
      dif<-logger$PAR$datetime-metdat$stoptime
      if(all(dif < 0)){
        stoppar <- length(dif)
      }else{
        stoppar<- which.max(!dif<0)-1#-2
      }
      warning("taking most recent PAR value")
    }

    par<-logger$PAR[startpar:stoppar,]
    par <- rename(par, PAR = value)

    starth2o<-which(logger$H2O$datetime==metdat$starttime)#or next
    if(length(starth2o)==0){
      dif<-logger$H2O$datetime-metdat$starttime
      starth2o<-which.max(dif>0)
    }
    stoph2o<-which(logger$H2O$datetime==metdat$stoptime)#or most recent
    if(length(stoph2o)==0){
      dif<-logger$H2O$datetime-metdat$stoptime
      stoph2o<- which.max(!dif<0)-1
      warning("taking most recent H2O value")
    }

    if(length(starth2o) > 0 | length(stoph2o) > 0){
      h2o<-logger$H2O[starth2o:stoph2o,]
      h2o <- rename(h2o, H2O = value)
    } else {
      h2o <- data.frame(H20 = NA)
    }

    temp2<-meantemp(temp, metdat$starttime, metdat$stoptime)

    dat <- left_join(x = co2, y = select(par, datetime, PAR), by = c("datetime" = "datetime")) %>%
      mutate(H2O = mean(h2o$H2O), temp = temp2)

    list(dat = dat, meta=metdat)
  })
  cleaner[!vapply(cleaner, is.null, FUN.VALUE = TRUE)]
}

#select(par, datetime, PAR)
#specifying data used in function process.data
#plotme == TRUE will create plots for every measurement specified in proces.data by start and stoptime in meta.data
#combine.data<-process.data(meta=meta.data, logger=log.data, temp=temp.data)
#combine.data


# function to reset start and stoptime for CO2 measurement, default is startHappy and endHappy is FALSE
setStartEnd <- function(x){
  startHappy <- FALSE
  endHappy <- FALSE
  tstart <- 0 #default is 0, otherwise give other starttime
  tfinish <- Inf
  while(!(startHappy & endHappy)){
    layout(matrix(c(1,1,1,2,2,2,2,2,2), nrow = 3, ncol = 3, byrow = TRUE)) #plot PAR and CO2 in for measurement
    par(mar=c(4,5,2,2))
    plot.PAR(x)
    plot.CO2(x)


    tstart1 <- readline("Enter preferred start time for fitting. \n Round to nearest integer second. press 'return':")
    if(!grepl("^[0-9]+$", tstart1)){

      startHappy <- TRUE
    } else {
      tstart <- as.integer(tstart1)
      startHappy <- FALSE
    }


    tfinish1 <- readline("Enter preferred finish time for fitting. \n Round to nearest integer second. original endtime is preferred, press 'return':")
    if(!grepl("^[0-9]+$", tfinish1)){

      endHappy <- TRUE
    } else{
      tfinish <- as.integer(tfinish1)
      endHappy <- FALSE
    }
    x$dat$keep[x$dat$time < tstart | x$dat$time > tfinish] <- FALSE
    x$meta$tstart <- tstart
    x$meta$tfinish <- tfinish
  }

  x

}

#loop for setting new start and end times for all measurements in file
setStartEndTimes <- function(newtimes){
  lapply(newtimes, setStartEnd)
}



# function to check if start and stoptime of CO2 is within timeframe specified in metadata
check<-function(x){
  CO2<-sapply(x, function(r){
    all(r$CO2$datetime>=r$meta$starttime&r$CO2$datetime<=r$meta$stoptime)
  })

  CO2
}
#check(combine.data) #check if start and stop time is right


# importing combination of datafiles of specific day site time
import.everything<-function(metaFile, loggerFile, tempFile){
  meta.data<-read.metadata(metaFile)
  logger.data<-read.logger(loggerFile)
  temp.data<- read.ibutton(tempFile)
  process.data(meta=meta.data, logger=logger.data, temp=temp.data)
}


# file <- "CO2/Data/datafiles_2016_cleaned.xlsx"
# r <- sites[1,]
#importing all site file combination from a sitefile
read.sitefiles<-function(file){
  sites<-read_excel(file, sheet=1, col_names=TRUE, col_type= NULL) %>%
    mutate(across(ends_with(".data"), ~ paste0("data/cflux/", .x)))  #read excel file
  sites$dates<- as.Date(sites$dates, format="%d.%m.%y")
  sites<-sites[!is.na(sites$site), ] # remove rows with no data
  #import data from files of site.files
  sites.data<-lapply(1:nrow(sites), function(i){ print(i)
    r<-sites[i, ]
    #   print(r)
    import.everything(metaFile = r$meta.data, loggerFile = r$logger.data, tempFile = r$temp.data)
  }) #process data from all files
  unlist(sites.data, recursive = FALSE) # make on big list of data from all sites, without sublists
}


# find outliers based on lm and based on residuals
find.outlier<- function(x, outlier_threshold = 5){
  original.lm <- lm (CO2 ~ time, data = x$dat) # linear model for measurement including all datapoints
  x$dat$resid<- resid(original.lm)

  # Identify and print only metadata of outliers
  outliers <- x$dat[abs(x$dat$resid) > outlier_threshold, ]
  print(outliers)

  # check which measurements have outliers and compare that to outliers found manually!

  #create threshold for identifying outliers within measurement and remove them from measurment
  #if (x$data$resid > outlier_threshold) {
  #x$data$co2<-NA
  x
}



#loop for going through all measurements in one combination of datafiles
outlier.filter <- function(outlierremove){
  lapply(outlierremove, find.outlier)
}

#outlier.filter(outlier.testdata)

#use lm and loess to test if measurement follows linear model
# if not loess will be different from linear model; determine a certain threshold.
# fit linear model over certain period of time using function rollaplly?
#find a good testdataset from 2016 measurements that represent different types of not so linear measurements
# if measurements not linear plot it in R markdown for further inspection

#require(zoo)
# find best fit for measurement
#model.fit<- function(x){
# fit lm and loess model
#              original.lm <- lm (CO2 ~ time, data = x$dat) # linear model for measurement including all datapoints
#              original.loess<- loess.smooth(CO2 ~ time, data = x$dat, span = 3/3, degree = 2, family = "gaussian",
#                                            evaluation = count(time)) #evaluation should be equal to number of datapoint

#check linearity of measurement by comparing lm to loess fit, if not similar fit > further inspection
#              plot(fitted(test.lm), test.loess$y)
#              z<-lm(data.frame(fitted(test.lm), test.loess$y))
#              summary(z)$r.squared < 0.9 # if r2 less than 0.9, linear model not appropriate for complete measurement
#
#             check for flat line
#             if max(x$dat$CO2)- min(x$dat$CO2) <= 5 # accept linear model even with low r2
#
#              rolling regression with 13 datapoint
#              rollapply(x, width = 13 FUN= function(Z),
#                        {
#                          t = lm(CO2 ~ time, data = Z$dat, na.rm=T);
#                          return(t$r.squared)
#                        },
#                       )

# how to evaluate best fit? and use best fit in fluxcalc ?

#}
