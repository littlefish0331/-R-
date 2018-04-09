getwd()

data <-read.csv("Rain_csv/YearRain.csv", header = T) 
head(data)
class(data)
data$date <- as.character(data$date)
#data$date[32] <- as.character("01_total")
#data$date[12778]

####月份處理####
month_day <- c(31,28,31,30,31,30,31,31,30,31,30,31)
sum(month_day[1:2])
for(i in 1:12){
    month_day[i] <- (month_day[i]+1)
}
sum(month_day)
month_day
temp <- rep(month_day, 32)
length(temp)

AA <- c(31,28,31,30,27,-1,26,31,30,31,30,31)
for(i in 1:12){
    AA[i] <- (AA[i]+1)
}
sum(AA)
AA

month_day <- c(temp, AA, month_day)
length(month_day)
#12*34=408

cum_mon_day <- NULL
for(i in 1:(12*34)){
    cum_mon_day[i] <- sum(month_day[1:i])
}
cum_mon_day
length(cum_mon_day)


####更改每月總雨量的名稱####

for(i in 1:408){
    if(i%%12==1){
        data$date[cum_mon_day[i]] <- as.character("01_total")
    }else if(i%%12==2){
        data$date[cum_mon_day[i]] <- as.character("02_total")
    }else if(i%%12==3){
        data$date[cum_mon_day[i]] <- as.character("03_total")
    }else if(i%%12==4){
        data$date[cum_mon_day[i]] <- as.character("04_total")
    }else if(i%%12==5){
        data$date[cum_mon_day[i]] <- as.character("05_total")
    }else if(i%%12==6){
        data$date[cum_mon_day[i]] <- as.character("06_total")
    }else if(i%%12==7){
        data$date[cum_mon_day[i]] <- as.character("07_total")
    }else if(i%%12==8){
        data$date[cum_mon_day[i]] <- as.character("08_total")
    }else if(i%%12==9){
        data$date[cum_mon_day[i]] <- as.character("09_total")
    }else if(i%%12==10){
        data$date[cum_mon_day[i]] <- as.character("10_total")
    }else if(i%%12==11){
        data$date[cum_mon_day[i]] <- as.character("11_total")
    }else if(i%%12==0){
        data$date[cum_mon_day[i]] <- as.character("12_total")
    }
    
}




write.csv(data, "Rain_csv/YearRain.csv", row.names = F)
