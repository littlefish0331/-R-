getwd()
setwd("C:/Users/User/Desktop")

air.105<-read.csv("105年資料大全.csv",fileEncoding = "big5")
rain<-air.105 %>% filter(Measurement=="PM2.5"|Measurement=="RAINFALL") %>%
    gather(Time,Observation,X00:X23) %>% 
    spread(Measurement,Observation)


