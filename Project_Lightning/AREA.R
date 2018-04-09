getwd()
setwd("C:/Users/User/Desktop/")

library(dplyr)
library(tidyr)

air.105<-read.csv("105年資料大全.csv",fileEncoding = "big5")
final<-air.105 %>% filter(Measurement=="RAINFALL") %>%
    gather(Time,Observation,X00:X23) %>% spread(Measurement,Observation) %>% 
    mutate(Rain=Rain)

ifelse(final$RAINFALL=="NA",0,1)


data <- read.csv("1100.csv", header = T)
data_ID <- data %>% select(FacilityID) 
ID <- data_ID[[1]] %>% substring(1,3)
data_Y <- data %>% select(ReportPeriod) 
YY <- data_Y[[1]] %>% substring(1,4)

data_fix <- merge(data,YY,ID)

head(ID)
head(YY)
head(data_ID)

str(ID)
str(data_ID)


