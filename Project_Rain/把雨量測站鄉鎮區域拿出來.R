
TEST <- read.csv("Rain_csv/final.csv", header = T)
#目前已經被汙染了
#要用YearRain_station_name.csv先跑一次!!


temp <- TEST$address
temp <- as.character(temp)
class(temp)

temp <- strsplit(temp,split="[鄉,鎮,市,區]")
temp[3890][[1]][[1]]
length(temp)

for(i in 1:length(temp)){
    temp[i] <- temp[i][[1]][[1]]
}
class(temp)
temp <- as.matrix(temp)

TEST <- cbind(TEST, "county"=temp)
head(TEST)

write.csv(TEST, "Rain_csv/Final.csv", row.names = F)
class(TEST)

class(TEST$county)
TEST$county <- as.character(TEST$county)
#start <- regexpr(c("鄉","鎮","市","區"), TEST$address) %>% as.numeric() +1
#會失敗，因為regexpr不會讀取向量的判斷條件。



