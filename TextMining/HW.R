getwd()
setwd("C:/Users/User/Documents/")
setwd("Learn/TextMining/prac_data/")

####練習01####
dir()
# dir("prac_data/") #看目錄底下有哪些文件。
# list.files() #功能同上
# list.files(path = ".", pattern = "file\\d{2}$") #"."為預設路徑。這樣寫會強制兩位數結尾。
filenames <- list.files(path = ".", pattern = "file\\d{3}$")
filenames #[1] "file236" "file443" "file556"
data00 <- sapply(filenames, function(x)(readLines(x, encoding = "UTF-8")))
# 不能再sapply裡面直接寫成sapply(filenames, readLines(encoding = "UTF-8"))
# (續)Rconsole會直接讀取錯誤。
# readLines的語法如下
# readLines(con = "file12", encoding = "UTF-8")
# 讀取編碼有時可以使用readBin
# readBin(con = "file12", what = "raw", n=3L) #3L或3皆可。

data00[[1]]
str(data00) 
# List of 3
# $ : chr [1:10]
# $ : chr [1:9]
# $ : chr [1:13]
class(data00) #[1] "list"

####練習02####
# grep(pattern = "【[0-9]{4}-[0-9]{2}-[0-9]{2}/聯合報/\\d{2}\\w/.*】", data00)
# ↑上面這樣寫不好的原因是，只知道是第1、2、3個list裡面有符合條件的字串
# (續)但是為list中哪一個字串，並無法精準掌握。
a1 <- sapply(data00, 
             function(x)(grep("【[0-9]{4}-[0-9]{2}-[0-9]{2}/聯合報/\\d{2}\\w/.*】", x)))
a1 #抓出有符合條件的字串位置，哪一個檔案，以及第幾個。

a2 <- sapply(data00, function(x)(gsub("【.*聯合報.*】", "", x)))
a2[[1]][10]
data00[[1]][10]
# check是不是真的被取代掉了！
# data00[[2]][9]
# a2[[2]][9]
# data00[[3]][13]
# a2[[3]][13]

####練習03-數字個數####
# 對單一文件做統計
QQ <- readLines("file236", encoding = "UTF-8")
library(dplyr)
temp <- QQ %>% gregexpr("[0-9]", .) %>% 
    sapply(., function(x) ifelse(x!="-1" , 1, 0) ) %>% 
    sapply(., sum ) %>% sum(.)

# 情況01
data00[[1]][10] <- "【17-07-21/聯合報/01版/】"
temp <- data00 %>% gregexpr("[0-9]", .) %>% 
    sapply(., function(x) ifelse(x!="-1" , 1, 0) ) %>% #因為自述不同，所以不會變成matrix
    sapply(., sum )
temp #[1]  8 10 10
# ↑如果文件中的字數不同，這樣做沒有問題。
# 數字出現在該list的位置
# file236 file443 file556 
# 10       9      13 

# 情況02
data00[[1]][10] <- "【2017-07-21/聯合報/01版/】"
temp <- data00 %>% gregexpr("[0-9]", .) %>% 
    sapply(., function(x) ifelse(x!="-1" , 1, 0) ) %>% 
    colSums(.)
temp #[1] 10 10 10

# 情況三，這個版本最好，保留文件名稱 以及 字數
data00[[1]][10] <- "【17-07-21/聯合報/01版/】"
ans03num <- data00 %>% sapply(., function(x){
    gregexpr("[0-9]", x) %>% 
        sapply(., function(x) ifelse(x!="-1" , 1, 0) ) %>% 
        sapply(., sum ) %>% sum(.)
} )
ans03num
# file236 file443 file556 
# 8      10      10 
str(ans03num)
# Named num [1:3] 8 10 10
# - attr(*, "names")= chr [1:3] "file236" "file443" "file556"
class(ans03num)
# [1] "numeric"

# 如果是對所有文件都做 數字個數 的統計
filenames <- list.files(path = ".", pattern = "file.*")
filenames #[1] "file236" "file443" "file556"
data00 <- sapply(filenames, function(x)(readLines(x, encoding = "UTF-8")))
temp <- data00 %>% sapply(., function(x){
    gregexpr("[0-9]", x) %>% 
        sapply(., function(x) ifelse(x!="-1" , 1, 0) ) %>% 
        sapply(., sum ) %>% sum(.)
} )
temp

####練習03-中文字個數####
"[\u4E00-\u9FA5]" #"[一-龥]的正規表示法。"

# 這是針對一個文件
QQ <- readLines(con = "file443", encoding = "UTF-8")
matches = gregexpr("[\u4E00-\u9FA5]", QQ)
sent <- regmatches(QQ, matches) %>% #挑出國字
    sapply(.,function(x) paste0(x, collapse = '')) %>%  #重複sapply內的動作
    sapply(., nchar) %>% #到這一步會帶有原本的文字，在attr之中。
    as.numeric(.) %>% #[1]  18   3 105 309 209 143 128 176 264   4
    sum(.)
sent #[1] 1359

ans03ch <- data00 %>% sapply(., function(x){
    matches = gregexpr("[\u4E00-\u9FA5]", x) %>% 
        regmatches(x, .) %>% #挑出國字，在每一個檔案下，每一list中這樣
        sapply(.,function(y) paste0(y, collapse = '')) %>%  #我的習慣是寫成function(y)
        sapply(., nchar) %>% #到這一步會帶有原本的文字，在attr之中。
        as.numeric(.) %>%
        sum(.)
})
ans03ch
# file236 file443 file556 
# 1359    1054    1524 

####練習03-標點符號個數####
ans03punct <- data00 %>% sapply(., function(x){
    matches = gregexpr("[[:punct:]]", x) %>% 
        regmatches(x, .) %>% #挑出國字，在每一個檔案下，每一list中這樣
        sapply(.,function(y) paste0(y, collapse = '')) %>%  #我的習慣是寫成function(y)
        sapply(., nchar) %>% #到這一步會帶有原本的文字，在attr之中。
        as.numeric(.) %>%
        sum(.)
})
ans03punct

####練習03的結果合併####
class(ans03num) #[1] "numeric"
str(ans03num)
# Named num [1:3] 10 10 10
# - attr(*, "names")= chr [1:3] "file236" "file443" "file556"

rbind(ans03num, ans03ch, ans03punct)


####交作業囉####
# 第一步抓檔案
filenames <- list.files(path = ".", pattern = "file\\d{3}$")
# filenames #[1] "file236" "file443" "file556"
data00 <- sapply(filenames, function(x)(readLines(x, encoding = "UTF-8")))

# 第二步取代文字
a2 <- sapply(data00, function(x)(gsub("【.*聯合報.*】", "", x)))
# check真的被取代掉↓
# data00[[1]][10]
# a2[[1]][10]

# 第三部統計數字、中文、標點符號字數
ans03num <- data00 %>% sapply(., function(x){
    gregexpr("[0-9]", x) %>% 
        sapply(., function(x) ifelse(x!="-1" , 1, 0) ) %>% 
        sapply(., sum ) %>% sum(.)
} )
ans03ch <- data00 %>% sapply(., function(x){
    matches = gregexpr("[\u4E00-\u9FA5]", x) %>% 
        regmatches(x, .) %>% #挑出國字，在每一個檔案下，每一list中這樣
        sapply(.,function(y) paste0(y, collapse = '')) %>%  #我的習慣是寫成function(y)
        sapply(., nchar) %>% #到這一步會帶有原本的文字，在attr之中。
        as.numeric(.) %>%
        sum(.)
})
ans03punct <- data00 %>% sapply(., function(x){
    matches = gregexpr("[[:punct:]]", x) %>% 
        regmatches(x, .) %>% #挑出國字，在每一個檔案下，每一list中這樣
        sapply(.,function(y) paste0(y, collapse = '')) %>%  #我的習慣是寫成function(y)
        sapply(., nchar) %>% #到這一步會帶有原本的文字，在attr之中。
        as.numeric(.) %>%
        sum(.)
})
rbind(ans03num, ans03ch, ans03punct)

