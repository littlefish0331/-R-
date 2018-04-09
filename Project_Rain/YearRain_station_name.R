getwd()
setwd("D:/NCCU/R_Study_Group/Data/")

library(dplyr)
library(tidyr)

living_station <- read.csv("Rain_csv/living_station.csv", header = T)
colnames(living_station)
length(colnames(living_station))
living_station <- living_station[,-13]

data <- living_station %>% select("站名", "經度", "緯度", "城市", "地址")
colnames(data) <- c("name", "long", "lat", "city", "address")
colnames(data)
write.csv(data, "Rain_csv/Station.csv", row.names = F)



start <- regexpr(",", site_name[,1]) %>% as.numeric() +1
end <- nchar(site_name[,1])
temp <- substr(site_name[,1] , start,end)
class(temp)


data_01 <- read.csv("Rain_csv/YearRain.csv", header = T)
head(data_01)


AA <- c(rep(377,32),337,377)
fix_name <- NULL
for(i in 1:34){
    fix_name <- c(fix_name,rep(temp[i], AA[i]))
}


length(fix_name)
nrow(data_01)
data_01 <- cbind(data_01, fix_name)
head(data_01)
data_01 <- data_01 %>% select("date", "fix_name", "rain")
colnames(data_01) <- c("date", "name", "rain")

data_02 <- data
head(data_02)


data_combi <- merge(data_01, data_02, "name")
temp <- data_combi %>% arrange(date) %>% arrange(name)
head(temp)
write.csv(temp, "Rain_csv/final.csv", row.names = F)

