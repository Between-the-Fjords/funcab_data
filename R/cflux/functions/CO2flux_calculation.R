#flux calculation for all measurements within specified datafile
fluxcalc<-function(input){
  
  # constants specification for chamber
  
  height= 0.4 #m
  area= 0.25*0.25 #m^2 plot area
  vol= area*height # m^3 chamber volume
  R= 8.31442 # J/mol/K
  
    # flux
  time<-input$dat$time
  #time<-time-time[1]
  #time<-unclass(time)
  co2<-input$dat$CO2 # umol/mol
  h2O<-input$H2O$value # mean H2O value for measurement mmol/mol
  PAR<-mean(input$dat$PAR, na.rm = TRUE)
  press<- 101 #input$meta$airpress # kPA estimated value based on altitude site
  temp<- input$dat$temp[1] # C 
  
# Jasoni et al 2005 Net ecosystem CO2 exchange in Mojavo desert shrublands during 8 year of exposure to elevated CO2
  #ambient
  cprime<-co2/(1-(h2O/1000))
  
  # linear Regression
  CO2.lm<- lm(cprime~time, subset= input$dat$keep)
  inter<- coef(CO2.lm)[1]
  dcdt<- coef(CO2.lm)[2]
  rsqd<- summary(CO2.lm)$r.sq
  nee<- -(vol*press*(1000-h2O)*dcdt)/ (R*area*(temp+273.15))# D(Reco)= negative L(NEE)=positive
  
  #	 Non-Linear, Exponential Regression (Leaky Fit Model) 
  #  cnot = cprime[3]#almost certainly wrong
  #  warning("cnot probably wrong")
  # uptake.fm <- nls(cprime ~ (cnot - A)*exp(-time/B) + A, start=list(A=375, B=40), subset=time>use[1] & time<use[2]) #(A=375, B=40)
  #  Css = summary(uptake.fm)$param[1]
  #  tau = summary(uptake.fm)$param[2]
  
  
  # nee_exp <- ((camb-Css)/(area*tau))*(vol*pav*(1000-wav)/(R*(tav + 273.15))) #equation 3 in Saleska 1999
  # temp4 <- (cnot-Css)*exp(-time/tau) + Css #equation 4 in Saleska 1999
  # lines(time,temp4, col=4)
  #	   nee_exp
  
  cbind(input$meta, time=max(time), PAR=PAR, temp=temp, nee=nee, rsqd=rsqd)
}
# make table of metadata and flux


