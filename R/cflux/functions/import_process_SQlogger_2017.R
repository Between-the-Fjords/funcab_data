# Import and process data from SQ logger

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

#temp.data<-read.ibutton("CO2/Data/Temperature_files_2016/20160607_FAU_CH1_TEMP.txt")
#plot(temp.data)

# calc mean temp between start and stoptime
meantemp<-function(ibut, start, stop){
  temp<-approx(x=ibut$datetime, y=ibut$temp, xout = c(start, stop))$y
  mean(temp)
}
#meantemp(temp.data,start=temp.data$datetime[1],stop=temp.data$datetime[2])

#file <- loggerFile
# import CO2 and PAR data from datalogger
read.SQlogger<-function(file){
  log<-read.table(file, header=TRUE,  sep="\t", dec=",", stringsAsFactors = FALSE, blank.lines.skip = TRUE, col.names=c("Date", "Time",	"Type",	"CO2_V",	"H20_V",	"Light_V",	"CO2_ppm",	"H20_ppt",	"PAR", "flag"))
  log$datetime<- as.POSIXct(paste(log$Date, log$Time), tz="", format="%d.%m.%Y %H:%M:%S")

  log$CO2_ppm<-suppressWarnings(as.numeric(log$CO2_ppm))
  log<-log[!is.na(log$CO2_ppm),] #skips data is not numeric

  # leave out flagged values "x" (outliers) from
  log$flag[is.na(log$flag)]<-""
  log$keep<-log$flag!="x"



  data.frame(datetime=log$datetime, CO2=log$CO2_ppm, PAR=log$PAR, H2O=log$H20_ppt, flag=log$flag, keep=log$keep)
}
#test<- read.SQlogger("CO2/Data/Flux2016_SQ/20160621_SQ_ALR1new.txt")


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

#meta.data<-read.metadata("CO2/Data/metadata_2016/07062016_FAU_ch1_1.txt")



process.SQdata <- function(meta, logger, temp){
  cleaner<-lapply(1:nrow(meta), function( i){

    metdat<-meta[i,]
    if(!is.na(metdat$flag)&metdat$flag=="x" )return(NULL) # leave out measurements that are flagged "x"

    #linking start/stoptime from metadata to CO2, PAR and H2O data from logger
    starttime<-which(logger$datetime==metdat$starttime)#or next
    if(length(starttime)==0){
      dif<-logger$datetime-metdat$starttime
      starttime<-which.max(dif>0)
    }

    stoptime <- which(logger$datetime == metdat$stoptime)#or most recent
    #stopifnot(length(stopCO2)>0,length(stopCO2)>0)
    if (length(stoptime) == 0) {
      dif <- logger$datetime - metdat$stoptime
      stoptime <- which.max(!dif < 0) - 1
      warning("taking most recent value")
    }

    dat <- logger[starttime:stoptime, ]

    time <- unclass(dat$datetime - dat$datetime[1])
    meanH2O<- mean(dat$H2O)
    temp2<-meantemp(temp, metdat$starttime, metdat$stoptime)

    dat$time <- time # add time column to logger data
    dat$H2O <- meanH2O # add mean H20 column to logger data
    dat$temp <- temp2 # link mean temp to logger data

    list(dat = dat, meta=metdat)
  })
  cleaner[!vapply(cleaner, is.null, FUN.VALUE = TRUE)]
}


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
checkSQ<-function(x){
  CO2<-sapply(x, function(r){
    all(r$CO2$datetime>=r$meta$starttime&r$CO2$datetime<=r$meta$stoptime)
  })

  CO2
}
#check(combine.data) #check if start and stop time is right


# importing combination of datafiles of specific day site time
import.everything.SQ<-function(metaFile, loggerFile, tempFile){
  meta.data<-read.metadata(metaFile)
  logger.data<-read.SQlogger(loggerFile)
  temp.data<- read.ibutton(tempFile)
  process.SQdata(meta=meta.data, logger=logger.data, temp=temp.data)
}


#file <- "data/cflux/Cflux data/SQfiles2017new.xlsx"
#r <- sites[1,]
#importing all site file combination from a sitefile
read.sitefiles.SQ<-function(file){
  sites<-read_excel(file, sheet=1, col_names=TRUE, col_type= NULL) %>%
    mutate(across(ends_with(".data"), ~ paste0("data/cflux/", .x))) #read excel file
  sites$dates<- as.Date(sites$dates, format="%d.%m.%y")
  sites<-sites[!is.na(sites$site), ] # remove rows with no data
  #import data from files of site.files
  sites.data<-lapply(1:nrow(sites), function(i){
    r<-sites[i, ]
    #   print(r)
    import.everything.SQ(metaFile = r$meta.data, loggerFile = r$logger.data, tempFile = r$temp.data)
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
