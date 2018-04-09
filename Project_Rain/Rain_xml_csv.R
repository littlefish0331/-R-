####安裝套件，啟動套件####
#install.packages("XML")
#install.packages("XML2")
library(XML)
library(methods)

getwd()
setwd("D:/NCCU/R_Study_Group/Data/")

####讀取XML檔案####
#readBin("C-B0025-001.xml", "raw", n = 3L)
data_xml <- xmlParse(file = "Rain_xml/dy_Report_2015.xml")

xml.root <- xmlRoot(data_xml)
# 取出根目錄，或是叫根節點，或是叫根節點
# xmlName(rootNode) #可以知道根目錄的名字
# names(rootNode) #在這個根目錄下面有那些子節點
xmlSize(xml.root) # 查看子節點數量

xml.leaf <- names(xml.root[["dataset"]]) #也可以寫xml.leaf <- names(xml.root[[8]])
names(xml.leaf)

##########################################
print(xml.root)
xmlSize(xml.root)
names(xml.root)
#8個子節點

print(xml.root[[8]])
xmlSize(xml.root[[8]])
names(xml.root[[8]])
#34個location

print(xml.root[[8]][[1]])
xmlSize(xml.root[[8]][[1]])
names(xml.root[[8]][[1]])
#location下面有3個子節點

print(xml.root[[8]][[1]][[1]])
xmlSize(xml.root[[8]][[1]][[1]])
names(xml.root[[8]][[1]][[1]])
#location下面有locationName的節點

print(xml.root[[8]][[1]][[1]][[1]])
print(xml.root[[8]][[2]][[1]][[1]])
#要取出不同的測站名稱，請去改34個location的位置
#此能使用length
xmlSize(xml.root[[8]])
site_size <- as.numeric(xmlSize(xml.root[[8]]))

print(xml.root[[8]][[1]][[2]][[1]])
print(xml.root[[8]][[2]][[2]][[1]])
#這是設站編號，我不需要。

print(xml.root[[8]][[1]][[3]])
xmlSize(xml.root[[8]][[1]][[3]])
#location節點下面第3個節點是weather，有378個資訊，365+1+12
print(xml.root[[8]][[1]][[3]][[1]]) #這是標題
print(xml.root[[8]][[1]][[3]][[33]]) #每個月會有total，此為一月
print(xml.root[[8]][[1]][[3]][[62]]) #每個月會有total，此為二月

####測站名稱抓出####
xml.root[[8]][[33]][[1]][[1]]
class(xml.root[[8]][[34]][[1]][[1]])

site_name <- NULL
for(i in 1: site_size){
    site_name <- rbind(site_name, as(xml.root[[8]][[i]][[1]][[1]],"character"))
}
colnames(site_name)<-c("site_name")

####各測站，每日的雨量抓出####
print(xml.root[[8]][[1]][[3]][[1]]) #這是標題
print(xml.root[[8]][[1]][[3]][[33]]) #每個月會有total，此為一月
print(xml.root[[8]][[1]][[3]][[62]]) #每個月會有total，此為二月

####月份處理####
month_day <- c(0,31,28,31,30,31,30,31,31,30,31,30,31)
sum(month_day[1:2])
for(i in 1:13){
    month_day[i] <- (month_day[i]+1)
}
sum(month_day)
month_day
cum_mon_day <- NULL
for(i in 1:13){
    cum_mon_day[i] <- sum(month_day[1:i])
}
cum_mon_day

####錯誤月份處理####
month_day <- c(0,31,28,31,30,27,-1,26,31,30,31,30,31)
sum(month_day[1:2])
for(i in 1:13){
    month_day[i] <- (month_day[i]+1)
}
sum(month_day)
month_day
cum_mon_day <- NULL
for(i in 1:13){
    cum_mon_day[i] <- sum(month_day[1:i])
}
cum_mon_day
site_01_M06 <- NULL
site_01_M06_dailyrain <- NULL

###################

YearRain_site <- NULL
j <- 33
for(j in 1:32){
    ####site_01_M01####
    xml.root[[8]][[j]][[3]][[2]][[1]][[1]]
    class(xml.root[[8]][[j]][[3]][[62]][[1]][[1]])
    site_01_M01 <- NULL
    for(i in (cum_mon_day[1]+1): cum_mon_day[2]){
        site_01_M01 <- rbind(site_01_M01, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M01)<-c("site_01_M01")
    
    ####site_01_M02####
    site_01_M02 <- NULL
    for(i in (cum_mon_day[2]+1): cum_mon_day[3]){
        site_01_M02 <- rbind(site_01_M02, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M02)<-c("site_01_M02")
    
    
    ####site_01_M03####
    site_01_M03 <- NULL
    for(i in (cum_mon_day[3]+1): cum_mon_day[4]){
        site_01_M03 <- rbind(site_01_M03, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M03)<-c("site_01_M03")
    
    
    
    ####site_01_M04####
    site_01_M04 <- NULL
    for(i in (cum_mon_day[4]+1): cum_mon_day[5]){
        site_01_M04 <- rbind(site_01_M04, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M04)<-c("site_01_M04")
    
    
    
    
    ####site_01_M05####
    site_01_M05 <- NULL
    for(i in (cum_mon_day[5]+1): cum_mon_day[6]){
        site_01_M05 <- rbind(site_01_M05, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M05)<-c("site_01_M05")
    
    
    ####site_01_M06####
    site_01_M06 <- NULL
    for(i in (cum_mon_day[6]+1): cum_mon_day[7]){
        site_01_M06 <- rbind(site_01_M06, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M06)<-c("site_01_M06")
    
    
    
    
    ####site_01_M07####
    site_01_M07 <- NULL
    for(i in (cum_mon_day[7]+1): cum_mon_day[8]){
        site_01_M07 <- rbind(site_01_M07, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M07)<-c("site_01_M07")
    
    
    
    
    ####site_01_M08####
    site_01_M08 <- NULL
    for(i in (cum_mon_day[8]+1): cum_mon_day[9]){
        site_01_M08 <- rbind(site_01_M08, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M08)<-c("site_01_M08")
    
    
    
    
    ####site_01_M09####
    site_01_M09 <- NULL
    for(i in (cum_mon_day[9]+1): cum_mon_day[10]){
        site_01_M09 <- rbind(site_01_M09, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M09)<-c("site_01_M09")
    
    
    
    
    ####site_01_M10####
    site_01_M10 <- NULL
    for(i in (cum_mon_day[10]+1): cum_mon_day[11]){
        site_01_M10 <- rbind(site_01_M10, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M10)<-c("site_01_M10")
    
    
    
    
    ####site_01_M11####
    site_01_M11 <- NULL
    for(i in (cum_mon_day[11]+1): cum_mon_day[12]){
        site_01_M11 <- rbind(site_01_M11, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M11)<-c("site_01_M11")
    length(site_01_M05)
    
    
    
    ####site_01_M12####
    site_01_M12 <- NULL
    for(i in (cum_mon_day[12]+1): cum_mon_day[13]){
        site_01_M12 <- rbind(site_01_M12, as(xml.root[[8]][[j]][[3]][[i]][[1]][[1]],"character"))
    }
    colnames(site_01_M12)<-c("site_01_M12")
    
    
    
    
    ####site_01_M01_dailyrain####
    xml.root[[8]][[j]][[3]][[31]]
    site_01_M01_dailyrain <- NULL
    for(i in (cum_mon_day[1]+1): cum_mon_day[2]){
        site_01_M01_dailyrain <- rbind(site_01_M01_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M01_dailyrain)<-c("site_01_M01_dailyrain")
    site_01_M01_dailyrain <- rbind(site_01_M01_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    
    ####site_01_M02_dailyrain####
    site_01_M02_dailyrain <- NULL
    for(i in (cum_mon_day[2]+1): cum_mon_day[3]){
        site_01_M02_dailyrain <- rbind(site_01_M02_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M02_dailyrain)<-c("site_01_M02_dailyrain")
    site_01_M02_dailyrain <- rbind(site_01_M02_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    
    ####site_01_M03_dailyrain####
    site_01_M03_dailyrain <- NULL
    for(i in (cum_mon_day[3]+1): cum_mon_day[4]){
        site_01_M03_dailyrain <- rbind(site_01_M03_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M03_dailyrain)<-c("site_01_M03_dailyrain")
    site_01_M03_dailyrain <- rbind(site_01_M03_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    ####site_01_M04_dailyrain####
    site_01_M04_dailyrain <- NULL
    for(i in (cum_mon_day[4]+1): cum_mon_day[5]){
        site_01_M04_dailyrain <- rbind(site_01_M04_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M04_dailyrain)<-c("site_01_M04_dailyrain")
    site_01_M04_dailyrain <- rbind(site_01_M04_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    ####site_01_M05_dailyrain####
    site_01_M05_dailyrain <- NULL
    for(i in (cum_mon_day[5]+1): cum_mon_day[6]){
        site_01_M05_dailyrain <- rbind(site_01_M05_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M05_dailyrain)<-c("site_01_M05_dailyrain")
    site_01_M05_dailyrain <- rbind(site_01_M05_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    ####site_01_M06_dailyrain####
    site_01_M06_dailyrain <- NULL
    for(i in (cum_mon_day[6]+1): cum_mon_day[7]){
        site_01_M06_dailyrain <- rbind(site_01_M06_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M06_dailyrain)<-c("site_01_M06_dailyrain")
    site_01_M06_dailyrain <- rbind(site_01_M06_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    
    ####site_01_M07_dailyrain####
    site_01_M07_dailyrain <- NULL
    for(i in (cum_mon_day[7]+1): cum_mon_day[8]){
        site_01_M07_dailyrain <- rbind(site_01_M07_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M07_dailyrain)<-c("site_01_M07_dailyrain")
    site_01_M07_dailyrain <- rbind(site_01_M07_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    ####site_01_M08_dailyrain####
    site_01_M08_dailyrain <- NULL
    for(i in (cum_mon_day[8]+1): cum_mon_day[9]){
        site_01_M08_dailyrain <- rbind(site_01_M08_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M08_dailyrain)<-c("site_01_M08_dailyrain")
    site_01_M08_dailyrain <- rbind(site_01_M08_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    ####site_01_M09_dailyrain####
    site_01_M09_dailyrain <- NULL
    for(i in (cum_mon_day[9]+1): cum_mon_day[10]){
        site_01_M09_dailyrain <- rbind(site_01_M09_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M09_dailyrain)<-c("site_01_M09_dailyrain")
    site_01_M09_dailyrain <- rbind(site_01_M09_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    ####site_01_M10_dailyrain####
    site_01_M10_dailyrain <- NULL
    for(i in (cum_mon_day[10]+1): cum_mon_day[11]){
        site_01_M10_dailyrain <- rbind(site_01_M10_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M10_dailyrain)<-c("site_01_M10_dailyrain")
    site_01_M10_dailyrain <- rbind(site_01_M10_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    
    
    ####site_01_M11_dailyrain####
    site_01_M11_dailyrain <- NULL
    for(i in (cum_mon_day[11]+1): cum_mon_day[12]){
        site_01_M11_dailyrain <- rbind(site_01_M11_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M11_dailyrain)<-c("site_01_M11_dailyrain")
    site_01_M11_dailyrain <- rbind(site_01_M11_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    
    ####site_01_M12_dailyrain####
    site_01_M12_dailyrain <- NULL
    for(i in (cum_mon_day[12]+1): cum_mon_day[13]){
        site_01_M12_dailyrain <- rbind(site_01_M12_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]][[1]],"character"))
    }
    colnames(site_01_M12_dailyrain)<-c("site_01_M12_dailyrain")
    site_01_M12_dailyrain <- rbind(site_01_M12_dailyrain, as(xml.root[[8]][[j]][[3]][[i]][[2]][[1]],"character"))
    
    
    ###############
    date <- c(site_01_M01, site_01_M02, site_01_M03, site_01_M04
              ,site_01_M05, site_01_M06, site_01_M07, site_01_M08
              ,site_01_M09, site_01_M10, site_01_M11, site_01_M12)
    length(date)
    
    rain <- c(site_01_M01_dailyrain, site_01_M02_dailyrain, site_01_M03_dailyrain, site_01_M04_dailyrain
              ,site_01_M05_dailyrain, site_01_M06_dailyrain, site_01_M07_dailyrain, site_01_M08_dailyrain
              ,site_01_M09_dailyrain, site_01_M10_dailyrain, site_01_M11_dailyrain, site_01_M12_dailyrain)
    length(rain)
    
    
    YearRain_site[[j]] <- data.frame(date,rain)
    
}

data <- NULL
#class(data) 是NULL
for(i in 1: length(YearRain_site)){
    data <- rbind(data,YearRain_site[[i]])
}

#####最後測站加入處理####
write.csv(data,"Rain_csv/YearRain.csv", row.names = F)
str(YearRain_site)

AA <- c(rep(377,32), 337, 377)
length(AA)
name <- NULL
for(i in 1:length(AA)){
    name <- c(name,rep(site_name[i], AA[i]))
}

data <- cbind(name, data)
write.csv(data,"Rain_csv/YearRain.csv", row.names = F)



