####函式庫####
library(stringr)

####清空Environment####
rm(list = ls())
getwd()
setwd("D:/NCCU/R_Study_Group/Data/")

####正則表示法，網站參考####
# http://yphuang.github.io/blog/2016/03/15/regular-expression-and-strings-processing-in-R/
#     http://rstudio-pubs-static.s3.amazonaws.com/13823_dbf87ac4114b44f8a4b4fbd2ea5ea162.html
# https://read01.com/zh-tw/aQNd7A.html#.WgmMhWhL82w
# http://ccckmit.wikidot.com/regularexpression
# https://atedev.wordpress.com/2007/11/23/%E6%AD%A3%E8%A6%8F%E8%A1%A8%E7%A4%BA%E5%BC%8F-regular-expression/

####CG的資料合併####
# 用正則表示法，找出要的檔案
# 用paste0把路徑黏貼上去
# 寫進一個packageIQR
# 再用rbind把資料結合起來

file.name.CG <- list.files(path="lightning_csv/",pattern = "2014.{3}C")
file.path.CG <- paste0("lightning_csv/",file.name.CG)
#class(file.name.CG) 是character
#class(file.path.CG) 是character
test <- data()
#class(test) 是packageIQR，這三小?
for(i in 1: length(file.path.CG)){
    test[[i]] <- read.csv(file.path.CG[i], header = T)
}
#class(test[1]) 是list
#class(test[[1]]) 是data.frame

data <- NULL
#class(data) 是NULL
for(i in 1: length(test)){
    data <- rbind(data,test[[i]])
}

data_CG <- data
write.csv(data_CG,"lightning_csv/2014CG.csv", row.names = F)

####IC的資料合併####
file.name.IC <- list.files(path="lightning_csv/",pattern = "2014.{3}I")
file.path.IC <- paste0("lightning_csv/",file.name.IC)
test <- data()
for(i in 1: length(file.path.IC)){
    test[[i]] <- read.csv(file.path.IC[i], header = T)
}

data <- NULL
for(i in 1: length(test)){
    data <- rbind(data,test[[i]])
}

data_IC <- data
write.csv(data_IC,"lightning_csv/2014IC.csv", row.names = F)

####所有的資料合併####
file.name <- list.files(path="lightning_csv/",pattern = "2014.{3}c")
file.path <- paste0("lightning_csv/",file.name)
test <- data()
for(i in 1: (length(file.path)-2)){
    test[[i]] <- read.csv(file.path[i], header = T) 
}
#(length(file.path)-2)
data <- NULL
for(i in 1: length(test)){
    data <- rbind(data,test[[i]])
}

data_total <- DDDDD
write.csv(data_total,"lightning_csv//2014Total.csv", row.names = F)



#####合併2014OO.csv問題的解決方法####
data_01 <- test[[1]]
data_02 <- test[[2]]
data_03 <- test[[3]]
data_04 <- test[[4]]
data_05 <- test[[5]]
data_06 <- test[[6]]
data_07 <- test[[7]]
data_08 <- test[[8]]
data_09 <- test[[9]]
data_10 <- test[[10]]
data_11 <- test[[11]]
data_12 <- test[[12]]

data_tail <- NULL
data_tail <- rbind(data_tail, data_12)
dim(data_tail)

data <- NULL
data <- rbind(data, data_08)
dim(data)

DDDDD <- rbind(data, data_tail)
