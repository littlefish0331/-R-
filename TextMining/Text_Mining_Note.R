# 按著alt 方便選取。

####Example for function####
address <- c("臺北市文山區指南路二段91~120號",
             "臺北市大同區重慶北路一段61~90號",
             "臺北市文山區指南路三段1~30號",
             "臺北市文山區指南路二段45巷31~60號",
             "臺北市內湖區民權東路六段90巷6弄1~30號",
             "臺北市文山區興隆路四段1~30號")
# 練習function
# (1)算總字數、中文字字數、數字字數
# (2)將個地址的 區、路 取出來
# (3)算文字的幾種(i,e,幾種不同的文字)
# (4)針對 大同區or指南路 的地址，將他們的地址中的數字取代成 X

####function introduction####
str(address) #chr[1:6]
class(address) #character
address
# [1] "臺北市文山區指南路二段91~120號"        "臺北市大同區重慶北路一段61~90號"      
# [3] "臺北市文山區指南路三段1~30號"          "臺北市文山區指南路二段45巷31~60號"    
# [5] "臺北市內湖區民權東路六段90巷6弄1~30號" "臺北市文山區興隆路四段1~30號" 

####nchar####
# 計算字串長度，包含文字與符號。
nchar(address) #[1] 18 18 16 20 22 16
nchar(address[1]) #[1] 18

####grep####
# grep第一個參數是pattern, 第二個是data,
# output為有符合這個pattern是第幾筆資料
grep(pattern = "文山區", x = address) #[1] 1 3 4 6
address %>% grep(pattern="文山區") #要library(dplyr)才可以使用
address %>% grep(pattern="文山區",.)
grep("指南路", address) #[1] 1 3 4

library(dplyr) #為了使用 %>% 
address
a <- grep("指南路二段", address)
address[a] #這樣就可以show出找到符合條件的字串
address %>% grep("指南路二段",.) %>% address[] #這樣會失敗
address %>% grep("指南路二段",.) %>% address[.] 
#這樣成功，建議使用 %>% 時還是要用.去表示資料參數放置的位置。

####grepl####
# 與grep用法相似,差異在於其output是TRUE/FALSE
grepl(pattern = "文山區", x = address) #[1]  TRUE FALSE  TRUE  TRUE FALSE  TRUE
grepl("指南路", address) #[1]  TRUE FALSE  TRUE  TRUE FALSE FALSE
# 如果要使用多個條件，並且聯集的話，或的尋找概念。類似的寫法在grep也可以成功。
address
grepl(c("指南路|二段"), address) #[1]  TRUE FALSE  TRUE  TRUE FALSE FALSE
grepl("指南路|二段", address)
grepl("[指南路|二段]", address) #這樣的寫法在會失敗
# 更多條件也是相同概念
grepl(c("指南路|二段|東路"), address) #[1]  TRUE FALSE  TRUE  TRUE  TRUE FALSE
# 在條件較長，大資料時，可以考慮這種寫法
x <- c("company_abc", "company_xbz", "abc")
grep("comp", x)
grep("company_a", x)
grep("company_abc|company_xyz",x)
grep("company_(a|x)", x) #當條件的部分相同時，可以這樣濃縮條件
grep("company_(a|x)bc", x)
grep("(company_|.*)abc",x) #[1] 1 3 。*代表前面至少放0次
grep("(company_|)abc",x) #上面效果相同。
grep("(company_|.+)abc",x) #[1] 1 。+代表前面至少放一次

address
a <- grepl("指南路二段", address)
address[a] #這樣就可以show出找到符合條件的字串
address %>% grepl("指南路二段",.) %>% address[] #這樣會失敗
address %>% grepl("指南路二段",.) %>% address[.] 
#這樣成功，建議使用 %>% 時還是要用.去表示資料參數放置的位置。

# grep 和 grepl 若找不符合條件的字串，會回傳integer(0)

####regexpr####
# 找出『第一個』符合pattern的字串在哪個位置及長度,
# 如果不符合pattern,會顯示-1
address
regexpr(pattern = "指", text = address)
# [1]  7 -1  7  7 -1 -1
# attr(,"match.length")
# [1]  1 -1  1  1 -1 -1
address %>% regexpr("指",.)

regexpr(pattern = "指南路", text = address)
# [1]  7 -1  7  7 -1 -1
# attr(,"match.length")
# [1]  3 -1  3  3 -1 -1

regexpr("指南路二段", address)
# [1]  7 -1 -1  7 -1 -1
# attr(,"match.length")
# [1]  5 -1 -1  5 -1 -1 #顯示條件的長度

regexpr("號", address)
# [1] 18 18 16 20 22 16 #顯示位置
# attr(,"match.length")
# [1] 1 1 1 1 1 1

regexpr("[0-9]", address) #[0-9]為正規表示法，也可以[0-4]。也可以
# [1] 12 13 12 12 13 12
# attr(,"match.length")
# [1] 1 1 1 1 1 1

regexpr("0|1|2", address)
address %>% regexpr("0|1|2",.) %>% .[1:6] #[1] 13 14 12 16 14 12

####gregexpr####
# 找出『所有』符合pattern的字串在哪個位置及長度
address
gregexpr("[0-9]", address)
# 當你用gregexpr的結果去做條件判斷時，
# (續)電腦是用相對應的attr去做判斷!!
# [[1]]
# [1] 12 13 15 16 17
# attr(,"match.length")
# [1] 1 1 1 1 1
# 
# [[2]]
# [1] 13 14 16 17
# attr(,"match.length")
# [1] 1 1 1 1
# ...省略。

"[\u4E00-\u9FA5]" #"[一-龥]的正規表示法。"
matches = gregexpr("[\u4E00-\u9FA5]", address)
sent <- regmatches(address, matches) %>% #挑出國字
    sapply(., function(x) paste0(x, collapse = '')) #重複sapply內的動作
# sent <- regmatches(address, matches) %>% 
#     sapply(function(.) paste0(., collapse = '')) #用點點也可以
# 記得function()括弧內的參數，要和裡面對應。
# 這樣再用nchar就知道中文長度了

sent
(sent <- regmatches(address, matches) %>% #挑出國字
    sapply(function(x) paste0(x, collapse = ''))) 
#最外面多加一個括弧，是要顯示的意思。

####sub####
# sub指substitute,
# 把每個字串中『第一個』符合pattern的內容取代
sub(pattern = "指南路", replacement = "AAA", x = address)
# [1] "臺北市文山區AAA二段91~120號"           "臺北市大同區重慶北路一段61~90號"      
# [3] "臺北市文山區AAA三段1~30號"             "臺北市文山區AAA二段45巷31~60號"       
# [5] "臺北市內湖區民權東路六段90巷6弄1~30號" "臺北市文山區興隆路四段1~30號"
sub("[0-9]", "X", address)
# [1] "臺北市文山區指南路二段X1~120號"        "臺北市大同區重慶北路一段X1~90號"      
# [3] "臺北市文山區指南路三段X~30號"          "臺北市文山區指南路二段X5巷31~60號"    
# [5] "臺北市內湖區民權東路六段X0巷6弄1~30號" "臺北市文山區興隆路四段X~30號"

####gsub####
# 把『每個』字串中所有符合pattern的內容取代
gsub(pattern = "指南路", replacement = "AAA", x = address)
# 這個效果一樣，因為中文是一起的。
# [1] "臺北市文山區AAA二段91~120號"           "臺北市大同區重慶北路一段61~90號"      
# [3] "臺北市文山區AAA三段1~30號"             "臺北市文山區AAA二段45巷31~60號"       
# [5] "臺北市內湖區民權東路六段90巷6弄1~30號" "臺北市文山區興隆路四段1~30號"    
gsub("[0-9]", "X", address)
# [1] "臺北市文山區指南路二段XX~XXX號"        "臺北市大同區重慶北路一段XX~XX號"      
# [3] "臺北市文山區指南路三段X~XX號"          "臺北市文山區指南路二段XX巷XX~XX號"    
# [5] "臺北市內湖區民權東路六段XX巷X弄X~XX號" "臺北市文山區興隆路四段X~XX號" 

####substr####
# 擷取字串，給予起始點和終點。
address
# 如果只想要地址中的 『行政區＋路段』
substr(address, start = 4, stop = 12)
# [1] "文山區指南路二段9"  "大同區重慶北路一段" "文山區指南路三段1"  "文山區指南路二段4" 
# [5] "內湖區民權東路六段" "文山區興隆路四段1" 
# 這個結果不夠好，要怎麼改善XD

# 結合regexpr
(a1 <- regexpr("[0-9]", address))
# [1] 12 13 12 12 13 12
# attr(,"match.length")
# [1] 1 1 1 1 1 1
(a2 <- regexpr("號", address))
# [1] 18 18 16 20 22 16
# attr(,"match.length")
# [1] 1 1 1 1 1 1

substr(address, start = a1, stop = a2)
# [1] "91~120號"      "61~90號"       "1~30號"        "45巷31~60號"   "90巷6弄1~30號" "1~30號" 
substr(address, start = 4, stop = a1)
# [1] "文山區指南路二段9"   "大同區重慶北路一段6" "文山區指南路三段1"   "文山區指南路二段4"  
# [5] "內湖區民權東路六段9" "文山區興隆路四段1"  
substr(address, start = 4, stop = a1-1)
# [1] "文山區指南路二段"   "大同區重慶北路一段" "文山區指南路三段"   "文山區指南路二段"  
# [5] "內湖區民權東路六段" "文山區興隆路四段" 

####paste####
# 字串的剪貼
temp <- paste("台北市", 
      substr(address, start = 4, stop = a1-1),
      substr(address, start = a1, stop = a2) )
temp
# [1] "台北市 文山區指南路二段 91~120號"        "台北市 大同區重慶北路一段 61~90號"      
# [3] "台北市 文山區指南路三段 1~30號"          "台北市 文山區指南路二段 45巷31~60號"    
# [5] "台北市 內湖區民權東路六段 90巷6弄1~30號" "台北市 文山區興隆路四段 1~30號" 
# 在此可以再用空格的方式切開，這樣就不會有字不見了!!
strsplit(temp, " ")
# [[1]]
# [1] "台北市"           "文山區指南路二段" "91~120號" 
# ...省略。

paste("台北市", 
      substr(address, start = 4, stop = a1-1),
      substr(address, start = a1, stop = a2),
      sep = "")
# [1] "台北市文山區指南路二段91~120號"        "台北市大同區重慶北路一段61~90號"      
# [3] "台北市文山區指南路三段1~30號"          "台北市文山區指南路二段45巷31~60號"    
# [5] "台北市內湖區民權東路六段90巷6弄1~30號" "台北市文山區興隆路四段1~30號" 
# paste(..., sep="") 相當於 paste0(...)

####strsplit####
# 字串的切割
strsplit(address, "市")
# [[1]]
# [1] "臺北"                     "文山區指南路二段91~120號"
# 
# [[2]]
# [1] "臺北"                      "大同區重慶北路一段61~90號"
# ...省略。

a <- strsplit(address, "市")
str(a) #List of 6。chr [1:2]
class(a) #[1] "list"
a[1]
a[2]
a[[1]]
a[[2]]
a[[1]][1]
paste(a[[1]][1],a[[1]][2], sep="市")
# paste(a[[1]][1],a[[1]][2], sep="")和上面效果相同。
# paste0(a[[1]][1],"市",a[[1]][2])和上面效果相同。

# 更快的做法!因為這已經是挑出國字了，所以再用regmatches
(sent <- a %>% sapply(function(x) paste0(x, collapse = "市"))) 

####正規表示法####
# Q：什麼是「正規化表示」？
# Wiki : 正規表示式使用單個字串來描述、符合一系列符合某個句法規則的字串。
# (續)在很多文字編輯器裡，正則運算式通常被用來檢索、替換那些符合某個模式的文字。
# 培軒 : 跨程式的語言"規則" 、 以更精簡的方式描述語言
set.seed(2) # 設定亂數種子。 
data = NULL
for(i in 1:10){
    tem = sample(letters[1:3], 20, replace = T) %>% paste0(collapse = '')
    # sample(letters[4:6], 20, replace = T) 
    # letter是英文字母，20表示娶幾個，replace代表要不要取後放回。
    data = c(data, tem)
    }
data %>% head(3)
# [1] "acbaccacbbbacabccaba" "bbcabbabcaaaccbbcaca" "caaacccbbcaaccacccbc"

####正規化常見指令####
# 正規劃通常是用在「檢查」、「搜尋」文字字串上
gsub("[[:punct:]]", "", "政大統研8+9") #將標點符號取代掉
# [[:punct:]]代表puncuation
# (續)代表標點符號，數字不算。
# [1] "政大統研89"

gsub("[[:digit:]]","", "政大統研8+9")
# [[:digit:]]代表數字。
# [1] "政大統研+"

#檢查字串裡是否有 a
pattern = "a"
data[grep(pattern, data)]
#但是若要檢查多個連續出現的a，要一直改很麻煩，所以使用正規
pattern = "a{3,}" # 表示三次以上。{,}裡面放條件出現次數從多少到多少。
data[grep(pattern, data)]

#檢查字串開頭是否有 a
pattern="^a"
data[grep(pattern, data)]

#檢查字串是否a開頭，a結尾
pattern="^a(.)*a$" 
# .代表任意文字、數字、空白也包含。
# *表示0次以上。
# pattern="^a.*a$" 效果一樣
# ^a.a$的功用和^a(.)a$和^a.{1,1}a$
data[grep(pattern, data)]

#*,+,? 的應用
# '*' : 匹配0次至無限次
# '+' : 匹配1次至無限次
# '?' : 匹配0次至一次

#[ ]的用途
# '[]' : 將要檢查的字元放在中括號內，
# (續)只要在裡面的字串都會被檢查出來, 
# (續)e.g. [0-9] 是要檢查字串中是否有 0 ~ 9 的元素。
# (續)在中括號裡的 ^ 是「非」的意思
gsub(pattern = "[a-e]", "X", "bacon")
gsub(pattern = "[^a]", "X", "bacon")
grepl(pattern = "r\\wg", "r妳gex")
# \\w代表『只有』一個文字，中英文皆可。若要多了就\\w*，或是用{,}去限制次數。
grepl(pattern = "r\\sg", "r gex")
# \\s代表『只有』一個空格。

gsub(pattern = "[a-z]","A", "test.i.ng")
# [1] "AAAA.A.AA"
gsub(pattern = "[a-z]+","A", "test.i.ng")
# [1] "A.A.A"
gsub(pattern = "[a-z.]+","A", "test.i.ng")
# [.]這個點只有"點"的意思
# [1] "A"

####正規表示法的範例####
library(stringr)
files = c("block010_dplyr-end-single-table.rmd",
          "testing.txt", "vlock02_spd.rmd")
pattern <- "^block\\d{3}_.*dplyr-(.*)\\.rmd$" #規定d結尾
# pattern <- "^block\\d{3}_.*dplyr-(.*)\\.(rmd)$" 規定rmd結尾
# 搜尋條件分開來看"^block \\d{3} _ .* dplyr- (.*)\\.rmd$"
# 搜尋的條件為"block"+"三個數字"+"_"+"任意字元"+"dplyr-"+"任意字元"+".rmd$"
# \\.是為了避免程式把"點"視為"任意字元"，而是應該解讀為"點"

str(files) #chr [1:3]
class(files) #[1] "character"

str_match(files, pattern) # str_match 尋找符合條件的字串
# [,1]                                  [,2]              
# [1,] "block010_dplyr-end-single-table.rmd" "end-single-table"
# [2,] NA                                    NA                
# [3,] NA                                    NA   
# 結果解釋：pattern中有(.*)，所以它會隔離出來
# (續)所以str_match除了就會顯示兩個部分
# (續)而字串的第二個和第三個都不合條件，所以為NA

(na.omit(str_match(files, pattern)))
# [,1]                                  [,2]              
# [1,] "block010_dplyr-end-single-table.rmd" "end-single-table"
# attr(,"na.action") ←表示有NA的地方是第二與第三列。
# [1] 2 3
# attr(,"class")
# [1] "omit"

# pattern <- "^block\\d{3}_.*dplyr-(.*)\\.rmd$" 這是之前的搜尋條件，改一下
pattern <- "^block\\d{3}_.*dplyr-(.{3}).*\\.rmd$" 
str_match(files, pattern)
(na.omit(str_match(files, pattern)))
# 如此一來多提取出來的部分，就是end了!

####Answer for Example(1)####
address <- c("臺北市文山區指南路二段91~120號",
             "臺北市大同區重慶北路一段61~90號",
             "臺北市文山區指南路三段1~30號",
             "臺北市文山區指南路二段45巷31~60號",
             "臺北市內湖區民權東路六段90巷6弄1~30號",
             "臺北市文山區興隆路四段1~30號")
# (1)算總字數、中文字字數、數字字數
ans01_01 <- nchar(address)
ans01_01

"[\u4E00-\u9FA5]" #"[一-龥]的正規表示法。"
matches = gregexpr("[\u4E00-\u9FA5]", address)
ans01_02 <- regmatches(address, matches) %>% #挑出國字
    sapply(function(x) paste0(x, collapse = '')) %>% #重複sapply內的動作
    nchar(.)
ans01_02

matches <- gregexpr("[0-9]", address)
ans01_03 <- regmatches(address, matches) %>% 
    sapply(function(x) paste0(x, collapse = '')) %>% nchar(.)
ans01_03

temp <- gregexpr("[0-9]", address) %>% .[[1]] %>% length(.)
temp #只能看字串的其中一個數字長度，所以可以用迴圈解決。
for(i in 1:length(address)){
    temp <- gregexpr("[0-9]", address) %>% .[[i]] %>% length(.)
    cat(temp,"") #""裡面可以放\n、\t。
}

# nchar()是看裡面每一個的長度。
# length()是看整個結構的長度。

####Answer for Example(2)####
# (2)將個地址的 區、路 取出來
address

# 做法01
a1 <- regexpr("市", address)
a2 <- regexpr("[0-9]", address)
ans02_a <- substr(x = address, start = a1+1, stop = a2-1)
ans02_a

# # 做法02
temp <- strsplit(address, ".*市|\\d.*")
temp
ans02_b <- temp %>% sapply(function(x) paste0(x, collapse = ""))
ans02_b

# 做法03
temp <- strsplit(address, ".*市|區|\\d.*")
temp
temp <- temp %>% sapply(function(x) paste0(x, collapse = "區 "))
a1 <- regexpr("區", temp)
a2 <- nchar(temp)
ans02_c <- substr(x = temp, start = a1+2, stop=a2)
ans02_c

# 做法04
library(stringr)
pattern <- ".*(.{2}區.*段).*號$" 
# 或者是".*(.{2}區.*段).*"就可以了

temp <- str_match(address, pattern) # str_match 尋找符合條件的字串
str(temp) #chr [1:6, 1:2]
class(temp) #[1] "matrix"
(ans02_d <- temp %>% .[,2])

# 做法05
# 細微調整
pattern <- "(.*市)(.{2}區)(.*段).*號$" 
temp <- str_match(address, pattern)
(ans02_5 <- temp %>% .[,-1])
address

####Answer for Example(3)####
# (3)算文字的幾種(i,e,幾種不同的文字)
address

# 作法01
temp <- gsub("[[:punct:]|[:digit:]]", "", address) #把數字取代掉。
class(temp) #[1] "character"
str(temp)
#chr [1:6] "臺北市文山區指南路二段號" "臺北市大同區重慶北路一段號" ...省略。

matches = gregexpr("[\u4E00-\u9FA5]", temp)
(a1 <- regmatches(temp, matches))
temp <- lapply(a1, unique) #對每一個list做unique
temp <- lapply(temp, length) #對每一個list做length
ans03_a <- unlist(temp) 
ans03_a #這就是每個地址中，有多少不同的中文字

# 作法02
temp <- gsub("[[:punct:]|[:digit:]]", "", address) #把數字取代掉。
class(temp) #[1] "character"
str(temp)

matches = gregexpr("[\u4E00-\u9FA5]", temp)
(a1 <- regmatches(temp, matches))
ans03_b <- lapply(a1, unique)
temp <- ans03_b %>% sapply(function(x) paste0(x, collapse = ""))
(ans03_b <- nchar(temp))

####Answer for Example(4)####
# (4)針對 大同區or指南路 的地址，將他們的地址中的數字取代成 X
address

temp <- grep(pattern = "大同區|指南路", x = address)
str(temp) #int [1:4] 1 2 3 4
class(temp) #[1] "integer"
gsub(pattern = "[0-9]", replacement = "X", x = address[temp])

# 把上面作化簡。
ans04_a <- address %>% grep(pattern = "大同區|指南路", .) %>% 
    gsub(pattern = "[0-9]", replacement = "X", x = address[.])
ans04_a
# address %>% grep(pattern = "大同區|指南路", .) %>% 
#     gsub(pattern = "[0-9]+", replacement = "X", x = address[.])
# ↑效果不一樣。
# 這樣的寫法不夠好，因為正常的東西，無法顯現!!請看下面。

temp <- grep(pattern = "文山區", x = address)
str(temp) #int [1:4] 1 3 4 6
class(temp) #[1] "integer"
QQ <- address
QQ[temp] <- gsub(pattern = "[0-9]", replacement = "X", x = QQ[temp])
QQ
# 這樣一來，即使不是篩選條件的字串也可以正常顯現。

temp <- grep(pattern = "大同區|指南路", x = address)
str(temp) #int [1:4] 1 3 4 6
class(temp) #[1] "integer"
QQ <- address
QQ[temp] <- gsub(pattern = "[0-9]", replacement = "X", x = QQ[temp])
(ans04_b <- QQ)

WTF <- address %>% sapply(function(x) 
    ifelse(grepl("文山區", x), gsub("[0-9]", "X", x), x)
) %>% as.character()
# 不加 %>% as.character()的話，字串會附帶一個attr動作的東西。
# ifelse語法格式
# ifelse('條件', '條件若成立：做A', '條件若不成立：做B')

# WTF <- address %>% sapply(function(x) 
#     ifelse(grepl("文山區", x), gsub("[0-9]", "X", x), x)
# )
# str(WTF)
# Named chr [1:2] "臺北市文山區指南路二段XX~XXX號"...省略
# - attr(*, "names")= chr [1:2] "臺北市文山區指南路二段91~120號"...省略
# class(WTF) #[1] "character"

####結束啦!後面是補充####

####文字處理實作####
# 蔡英文總統520就職演說（中英文全文）
# http://www.thinkingtaiwan.com/content/5478
# 先另存為Tsai.txt，並指留下中文的部分
dir()
temp <- readLines("Tasi.txt", encoding = "UTF-8")
# 位元組順序記號（英語：byte-order mark，BOM）
# (續)是位於碼點U+FEFF的統一碼字元的名稱。
head(temp)
# [1] "各位友邦的元首與貴賓、各國駐台使節及代表、現場的好朋友，全體國人同胞，大家好"                                                                                                                                                                                                                      
# [2] ""                                                                                                                                                                                                                                                                                                  
# [3] "感謝與承擔"                                                                                                                                                                                                                                                                                        
# [4] "" 

# install.packages("tm") #安裝套件
library(tm)
# 刪除標點符號與數字 的指令
# removePunctuation() #中文會失敗。英文才OK。
# removeNumbers() #成功，可以試第122行。

readBin("Tasi.txt", what = "raw", n = 3L) #[1] ef bb bf 這編碼是UTF-8
G <- readLines("Tasi.txt", encoding = "UTF-8")
G[1:6]
str(G) #chr [1:141]

#刪除標點符號
G1 <- gsub("[[:punct:]]", "", G)
G1[1]

#刪除數字
G2 <- removeNumbers(G1)
G1[122]
G2[122]

#計算列數
(row=length(G2)) #[1] 141

#將所有段落連在一起
(G_toge <-  paste(G2[1:row],collapse = ""))

#將所有的空白格移除掉
library(dplyr)
# grepl(pattern = " ", G2) %>% G[.]
# 知道哪裡有空格
(G_final <- gsub(" ","",G_toge))

####切字####
#先宣告一個空向量
word = NULL

#計算就職演說總字數
(n=nchar(G_final))

#每兩個字兩個字做字串剪貼（12,23,34,45,...） 
for(i in 1:n-1){ 
    word <- c(word, substr(G_final,i,i+1)) 
}
word[1:6]
# [1] "?"     "?各"   "各位" "位友" "友邦" "邦的"
# substr(G_final,1,1) #[1] "?"←意思是中間有個東西，所以才會站一個位置。
# (續)應該是標示字串開頭。或是NA值被轉成character，並編譯為UTF-8。
# substr(G_final,2,2) #[1] "各"
# substr(G_final,5357,5357) [1] ""
str(word) #chr [1:5357] "<U+FEFF>" "<U+FEFF>各" "各位"
class(word) #[1] "character"

wordtable_i <- table(word)
wordtable_i[1:10]
# word
# 各  CE  CO  EP  OP  PP  PR P巴 P等 
# 1   1   1   1   1   1   1   1   1   1 

wordtable <- sort(wordtable_i, decreasing = T)
wordtable[1:10]
# 我們 台灣 政府 國家 一個 新政 經濟 這個 民主 社會 
# 86   41   37   32   29   27   27   25   24   22
str(wordtable)
# 'table' int [1:3295(1d)] 86 41 37 32 29 27 27 25 24 22 ...
# - attr(*, "dimnames")=List of 1
# ..$ word: chr [1:3295] "我們" "台灣" "政府" "國家" ...
class(wordtable) #[1] "table"

####文字雲####
# install.packages("wordcloud")
library(wordcloud)
d <- data.frame(word = names(wordtable), freq = as.numeric(wordtable))
d[1:6,]
# word freq
# 1 我們   86
# 2 台灣   41
# 3 政府   37
# 4 國家   32
# 5 一個   29
# 6 新政   27

# 這是wordcloud的語法↓
wordcloud(words,freq,scale=c(4,.5), min.freq=3,max.words=Inf, 
          random.order=TRUE, random.color=FALSE, rot.per=.1, 
          colors="black",ordered.colors=FALSE,use.r.layout=FALSE, 
          fixed.asp=TRUE, ...)
# words : 文字
# freq : 出現次數
# min.freq : 最小出現次數，若低於此值，則不會畫在圖上
# max.words : 最多畫幾組文字
# random.order : 是不是要隨機順序來畫圖
# colors : 顏色選取ColorBrewer #http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
# … 其餘參數設定請參考  ?wordcloud  or  help(wordcloud)

wordcloud(d$word, d$freq, scale=c(8,.2),min.freq=3,
          max.words=Inf, random.order=FALSE, 
          colors=c("#7F7F7F", "#5F9EA0", "#FF8C69"))
# 如果random.order=False，就是出現比較多次的在中間。
# (續)如果random.order=T，則不一定。
