
#function for plotting CO2 against time and adding regression line
plot.CO2<-function(x, ...){#browser()
  require("broom")
  with(x$dat, plot(time, CO2, main=paste(unlist(x$meta)[(5:8)], collapse = " "), pch = ifelse(keep, yes = 16, no = 1), ...)) #xlab="time (s)", ylab="CO2 (ppm)", cex.lab=1.5
  CO2cleaned.lm <- lm(CO2~time, data=x$dat, subset=keep)
  CO2raw.lm<- lm(CO2~time, data=x$dat)
  abline(CO2raw.lm, col="gray")
  abline(CO2cleaned.lm, col="blue")
  mtext(side = 3, line = 1, adj = 0, text = paste("r2:", round(glance(CO2cleaned.lm)$r.squared, 2)))
  CO2cleaned.lm
}


plot.PAR<-function(x, ...){#browser()
  #dat$time<-unclass(dat$datetime-x$PAR$datetime[1])
  plot(x$dat$time, x$dat$PAR, xaxt='n', ann=FALSE)
}