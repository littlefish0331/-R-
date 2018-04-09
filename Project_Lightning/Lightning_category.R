####程式說明####





####安裝套件####
library(dplyr)
library(tidyr)
library(plotly)
library(ggplot2)




####確認目錄路徑####
getwd()
setwd("D:/NCCU/R_Study_Group/Data/")




####確認資料編碼####
readBin("lightning_txt/201412.txt", "raw", n = 3L)
data <- readLines("lightning_txt/201412.txt", encoding = "UTF-8")
#head(data)
#str(data)

###########################################

####把txt資料轉成data.frame格式#####
# 把txt資料寫進matrix，叫做fix_data
# 再把matrix轉成data.frame，再存進fix_data
# 並設定colname的名字

column_count <-length(strsplit(data[1], ",")[[1]])
row_count <- length(data)
fix_data <- matrix(NA, nrow = row_count, ncol = column_count)

for(row in 1:row_count){
    for(col in 1:column_count) {
        fix_data[row,col] <- strsplit(data[row+1], ",")[[1]][col]
        # 執行 for loop 將資料塞入 fix_data
    }
}
#head(fix_data)
#tail(fix_data)

colnames(fix_data)<-c("日期時間","奈秒","經度","緯度","電流強度(kA)","雷擊型態")
fix_data <- fix_data %>% as.data.frame()
#head(fix_data)
#str(fix_data)
#class(fix_data)
#length(fix_data$緯度)

###########################################

####把資料存成csv檔案####
# 因為上一步的迴圈會有多一行NA值
# 所以要先刪減到再寫進迴圈裡面

fix_data <- fix_data[-length(fix_data$經度),]
#也可以用fix_data <- fix_data[1:row_count-1,]

write.csv(fix_data, file = "lightning_csv/201412.csv", row.names = FALSE)
csv_data <- read.csv("lightning_csv/201412.csv", header = T)
#head(csv_data)

###########################################

####把資料的年、月、日、小時拿出來####
times <- csv_data %>% select("日期時間")
as_ch_times <- as.character(times$日期時間)
#class(as_ch_times)
#head(as_ch_times)

yy <- (substring(as_ch_times, 1, 4))
mm <- (substring(as_ch_times, 6, 7))
dd <- (substring(as_ch_times, 9, 10))
time_hh <- (substring(as_ch_times, 12, 13))
time_mm <- (substring(as_ch_times, 15, 16))
time <- paste0("X",time_hh)

#head(times)
#class(times)
#head(times[[1]])
#class(times[[1]])
#也可以用這種寫法yy <- (substring(times[[1]], 1,4))

###########################################

#####把csv檔案多寫出年、月、日、小時欄位的資料#####
csv_data <- mutate(csv_data, year=yy, month=mm, date=dd, time=time)
csv_data <- csv_data %>% select("year", "month", "date", "time", "經度", "緯度", "電流強度.kA.","雷擊型態")
colnames(csv_data)<-c("year","month","date", "time", "lat","long","kA", "type")
write.csv(csv_data, file = "lightning_csv/201412.csv", row.names = FALSE)

###########################################

#####把csv檔案分成CG和IC檔案，並個別存檔#####
csv_data_CG <- filter(csv_data, type=="CG")
write.csv(csv_data_CG, file = "lightning_csv/201412_CG.csv", row.names = FALSE)

csv_data_IC <- filter(csv_data, type=="IC")
write.csv(csv_data_IC, file = "lightning_csv/201412_IC.csv", row.names = FALSE)

#確認切資料有無正確。
length(csv_data$year)==length(csv_data_CG$year)+length(csv_data_IC$year)

###########################################

