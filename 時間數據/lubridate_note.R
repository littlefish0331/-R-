# 參考資料
# https://weitinglin.com/2017/03/20/使用r處理時間資料（datetimeclasses）的格式（lubricate-posixltposixlc）/
# http://www.tipdm.org/bdrace/ganhuofenxiang/20161103/852.html

# 給出R檔案的連結(例如"~連結~")，
# 按著shift+滑鼠點擊""內的地方，就可以開啟Rsricpt了。
# 另外，若想看任何function內部的結構，也是用一樣的方法。


# 電腦的時間介紹 ----------------------------------------------------------------
# 使用R處理時間資料(DateTimeClasses)的格式(lubricate, POSIXlt, POSIXlc)
# 
# 時間資料的處理，假如不借助現有的“時間類別”資料型態的話，
# (續)會頗麻煩，比如有兩個時間要比看看誰先誰晚，想知道兩個時間的間隔，
# (續)或是要進一步要篩選一堆時間資料根據某個特定的時間點，
# (續)要自己用numeric來實現會麻煩一點，
# (續)所以使用內建處理時間的函數像是as.POSIXlt, as.POSIXlc, as.Date會方便很多。
# (續)他們本身就可以實現時間的加減等，
# (續)另外，也可以使用lubricate軟件包，
# 這是一個更為方便用來處理時間資料轉換的工具。
# 
# 仔細研究會發現在電腦中的時間顯示也不是一件簡單的事，
# (續)可以搜尋Unix time(參考資料-Unix時間)，
# (續)最重要的觀念是理解POSIX和epoch這兩種時間表達的方式，
# (續)其中Epoch，所謂的reference time的目的，是可以幫助“時間值”彼此的加減運算，
# (續)等於把時間轉換成距離某個“參考時間點”幾小時、幾分或是幾秒，
# (續)那這樣就可以輕鬆地對兩組“時間值”彼此直接加減，不需要經過兩次換算，
# (續)但這邊也容易造成使用者混淆，
# (續)因為每個平台或是程式語言可能有彼此不一樣的epoch參照點，
# (續)像是R的參照時間就是1970/01/01，
# (續)所有的時間假如直接轉成數字的話，便是距離此時間點的天數(或是小時)，
# (續)端看時間裡所使用的最小單位。



# 專有名詞介紹 ------------------------------------------------------------------
# 
# 下面是當我們想要進一步瞭解後面細節遇到的名詞：
# # 1. POSIX(Portable Operating System Interface)
# # 這其實是IEEE的標準中為了讓各個操作系統能保持一致的，
# # 裡頭包含了許多系統底層的規範包括
# # Process, Signal, Memory violation, Pipe, C library, 
# # 當然timer也是其中的規範之一。
# # p.s.IEEE電機電子工程師學會(Institute of Electrical and Electronics Engineers)
# # POSIX是指一種表示時間的格式啦!!
# 
# # 2. Epoch(reference time)
# # Epoch是傳統年代表中用來參照的時間點，
# # 比如西元前和西元後中的epoch就是耶穌誕生日，
# # 而在計算機領域中不同的操作系統會有不同的epoch，
# # 像MATLAB就是以Jan 1, BC、GO則是用Jan 1, AC
# # ，Microsoft則是1990-1-0(真的是Jan 0)，
# # 大多數的系統和語言像是JAVA, PHP, Ruby, Javascript, Perl，unix系統等
# # 則是使用1970,1,1。
# 
# # 3.Unix時間戳記(Unix timestamp)，
# # 或稱Unix時間(Unix time)、POSIX時間(POSIX time)，
# # 是一種時間表示方式，
# # 定義為從格林威治時間1970年01月01日00時00分00秒起至現在的總秒數。
# 
# https://time.is/Unix
# 這個網站會告訴妳，從1970年1月1號0點0分0秒開始到現在
# 一共過了幾秒鐘
# 
# R系統中DataTimeClasses主要有兩個物件：POSIXct, POSIXlt
# 1. POSIXct代表的是總秒數從1970/1/1開始算起(R裡面的epoch)
# 2. POSIXlt則是一個列表，裡面有跟時間相關的數值(秒、分、時、日、月、年等)



# R基本的時間數字的處理和轉換 ----------------------------------------------------------
# 
# 可以將R內時間資料處理分成兩個大觀念來理解：資料格式和常用操作
# 
# 在資料格式上，R裡面有兩大類：Date和POSIXct/POSIXlt
# POSIXct/POSIXlt為承襲unix系統中處理時間的方式，
# 自由度較高，也較複雜，使用的函數為as.POSIXct/as.POSIXlt。
# Date為簡單版的時間資料格式，就是由1970/01/01作為epoch的，
# 使用的函數為as.Date。

# 在處理時間的資料上，觀念上其實只有兩類操作：
# 1. 時間“資料格式”轉換顯示方式(通常被忽視)
# 2. 非時間“資料格式”(為字串)轉換為時間”資料格式“
# 
# 但通常沒有區分開這兩類時，很容易會感到挫折，
# 因為會發現函數的表現跟自己預期不太一樣，或是搞不清楚文檔在說什麼。
# 當可以區分這兩類操作後，再來則是理解一點關於“電腦世界”制定時間的一些方法，
# 才不會被一堆名詞搞矇，
# 接者可以開始找一些不錯的函數包lubricate在處理一些時間資料的操作。

(AA <- "2017-12-31") #[1] "2017-12-31"
str(AA) #chr "2017-12-31"
class(AA) #[1] "character"

(A <- as.Date(AA)) #[1] "2017-12-31"
str(A) #Date[1:1], format: "2017-12-31"
class(A) #[1] "Date"

(A <- as.POSIXct(AA)) #[1] "2017-12-31 CST"
str(A) #POSIXct[1:1], format: "2017-12-31"
class(A) #[1] "POSIXct" "POSIXt"

(A <- as.POSIXlt(AA)) #[1] "2017-12-31 CST"
str(A) #POSIXlt[1:1], format: "2017-12-31"
class(A) #[1] "POSIXlt" "POSIXt"



# 時間資料轉換顯示格式 --------------------------------------------------------------
# 
# 第一類：本為時間資料格式，拿來轉換顯示格式
(temp <- Sys.time()) #[1] "2018-01-06 15:40:12 CST"
date() #[1] "Sat Jan 06 15:40:16 2018"

str(temp) # POSIXct[1:1], format: "2018-01-06 15:41:05"
class(temp) # [1] "POSIXct" "POSIXt"
str(date()) # chr "Sat Jan 06 15:57:26 2018"
class(date()) # [1] "character"

time <- Sys.time() # 下面system的地方可以放time。
format(Sys.time(), "%Y-%m-%d") # [1] "2018-01-06"
format(Sys.time(), "%Y-%d-%m") # [1] "2018-06-01"
format(Sys.time(), "%Y-%Y-%Y") # [1] "2018-2018-2018"


# 
# 第二類：本來是“字串”，要轉換成時間資料格式
time <- "2014-05-31"
str(time) #chr "2014-05-31"
class(time) #[1] "character"

ttime <- as.POSIXct("2014-05-31", format="%Y-%m-%d")
str(ttime) #POSIXct[1:1], format: "2014-05-31"
class(ttime) #[1] "POSIXct" "POSIXt"

# 或也可以使用lubricate函數來處理文字的轉換
temp <- ymd("20110531") #[1] "2011-05-31"
mdy("05-31-2011") #[1] "2011-05-31"
dmy("31/05/2011") #[1] "2011-05-31"
dym("31-11-05") #[1] "2011-05-31"

str(temp) #Date[1:1], format: "2011-05-31"
class(temp) #[1] "Date"


# 轉換成時間資料格式後，很多處理就變成很直覺性了，
# 你可以直接加上秒數，或是兩個時間相減或是相加
(AA <- Sys.time()) #[1] "2018-01-07 17:03:43 CST"
Sys.time() + 1000 #[1] "2018-01-07 17:20:24 CST"
AA+1000 #[1] "2018-01-07 17:20:23 CST"
str(AA) #POSIXct[1:1], format: "2018-01-07 17:03:43"

A <- as.Date(Sys.time()) #[1] "2018-01-07"
as.Date(Sys.time()) + 10 #[1] "2018-01-17"
as.Date(Sys.time()) + 15 #[1] "2018-01-22"
str(A) #Date[1:1], format: "2018-01-07"
class(A) #[1] "Date"



# lubridate套件處理時間數據 -------------------------------------------------------
# 
# lubridate包是由Garrett Grolemund 和 Hadley Wickham寫的，可以靈活地處理時間資料。
# lubridate包主要有兩類函數，一類是處理時點數據(time instants)，
# 另一類是處理時段資料(time spans)。

(AA <- date()) #[1] "Sun Jan 07 17:16:20 2018"
str(AA) # chr "Sat Jan 06 10:52:59 2018"
class(AA) # [1] "character"

library(lubridate)
# 時間點的處理-解析 ------------------------------------------------------------------
temp <- ymd("20150125") #[1] "2015-01-25"
class(temp) #[1] "Date"

ymd("201551") #[1] NA 格式不對
ymd("2015-5-1") #[1] "2015-05-01"
ymd("2015/12/08") #[1] "2015-12-08"
ymd("2015/12/8") #[1] "2015-12-08"
mdy("12/31/2017") #[1] "2017-12-31"
dmy("04/9/15") #[1] "2015-09-04"

?ymd_hms #Parse date-times with year, month, and day, hour, minute, and second components.
x <- c("2010-04-14-04-35-59", "2010-04-01-12-00-00")
ymd_hms(x) #[1] "2010-04-14 04:35:59 UTC" "2010-04-01 12:00:00 UTC"

# 關於UTC、CTS、GMT+8等等，可以GOOGLE一下!!
# 差別是測量時間的方式不同，一點點差別而已。



# 時間點的處理-抽取 ------------------------------------------------------------------
x <- as.POSIXct("2016-10-31 15:29:59")
x #[1] "2016-10-30 15:29:59 CST"
second(x) #[1] 59
minute(x) #[1] 29
hour(x) #[1] 15
date(x) #[1] "2016-10-30"
day(x) #[1] 30
month(x) #[1] 10
year(x) #[1] 2016
wday(x) #觀察星期幾
# [1] 2
wday(x, label = T)
# [1] 週一
# Levels: 週日 < 週一 < 週二 < 週三 < 週四 < 週五 < 週六
yday(x) #觀察x日期是一年中第幾天。
# [1] 305
week(x) #觀察x日期是一年中第幾個星期。
# [1] 44
days_in_month(x) #返回所屬月份的最大天數。
# Oct 
# 31

# 註解：as.POSIXct()會檢查日期正確與否!!但是時間不會檢查。
# 可是顯示的時候，若是錯誤時間，就不會顯示。
# 後面的時間是24小時制，只能是00~23(0~23)
x <- as.POSIXct("2016-11-31 12:29:00")
# Error in as.POSIXlt.character(x, tz, ...) : 
#     character string is not in a standard unambiguous format
x <- as.POSIXct("2016-10-31 24:12:00")
x #[1] "2016-10-31 CST"


# 時間點的處理-修改(四捨五入) ------------------------------------------------------------------
# 對時間四捨五入取整數
x <- as.POSIXct("2016-10-30 12:31:59") #[1] "2016-10-30 12:31:59 CST"
round_date(x, unit = "min") #[1] "2016-10-30 12:32:00 CST"
round_date(x, unit = "hour") #[1] "2016-10-30 13:00:00 CST"
round_date(x, unit = "day") #[1] "2016-10-31 CST"
round_date(x, unit = "month") #[1] "2016-11-01 CST"
round_date(x, unit = "year") #[1] "2017-01-01 CST"

# 向下取整數 [1] "2016-10-30 12:31:59 CST"
floor_date(x, unit = "min") #[1] "2016-10-30 12:31:00 CST"
floor_date(x, unit = "hour") #[1] "2016-10-30 12:00:00 CST"
floor_date(x, unit = "day") #[1] "2016-10-30 CST"
floor_date(x, unit = "month") #[1] "2016-10-01 CST"
floor_date(x, unit = "year") #[1] "2016-01-01 CST"

# 向上取整數 [1] "2016-10-30 12:31:59 CST"
ceiling_date(x, unit = "min") #[1] "2016-10-30 12:32:00 CST"
ceiling_date(x, unit = "hour") #[1] "2016-10-30 13:00:00 CST"
ceiling_date(x, unit = "day") #[1] "2016-10-31 CST"
ceiling_date(x, unit = "month") #[1] "2016-11-01 CST"
ceiling_date(x, unit = "year") #[1] "2017-01-01 CST"



# 時段類函數 -------------------------------------------------------------------
# 可以處理三類物件，分別是：
# interval：最簡單的時段物件，它由兩個時點數據構成。
# duration：去除了時間兩端的資訊，
#           純粹以秒為單位計算時段的長度，不考慮閏年和閏秒，
#           它同時也相容基本包中的difftime類型物件。
# period：以較長的時鐘週期來計算時段長度，
#       　它考慮了閏年和閏秒，適用於長期的時間計算。
#       　以2012年為例，duration計算的一年是標準不變的365天，
#       　而period計算的一年就會變成366天。




# interval ----------------------------------------------------------------
# 
# 有了時點和時段資料，就可以進行各種計算了。

meeting <- ymd_hms("2016-10-30 12-31-45", tz = "UTC")
meeting #[1] "2016-10-30 12:31:45 UTC"
?ymd_hms 
# Parse date-times with year, month, 
# and day, hour, minute, and second components.
# 其中tz的解釋：
# a character string that specifies 
# which time zone to parse the date with. 
# The string must be a time zone that is recognized by the user's OS.
# 一個字符串，指定哪個時區用於解析日期。 
# 該字符串必須是由用戶的操作系統識別的時區。
# 可以填GMT、UTC。簡單來說就是讀取時間數據的時區為何。

meetings <- meeting+weeks(0:3)
meetings
# [1] "2016-10-30 12:31:45 UTC"
# [2] "2016-11-06 12:31:45 UTC"
# [3] "2016-11-13 12:31:45 UTC"
# [4] "2016-11-20 12:31:45 UTC"

int <- interval(start = ymd(20160720, tz = "UTC"), end = ymd(20161115, tz = "UTC"))
int #[1] 2016-07-20 UTC--2016-11-15 UTC
int <- interval(start = ymd(20160720), end = ymd(20161115), tzone = "GMT") #tzone是預設"UTC"
int #[1] 2016-07-20 GMT--2016-11-15 GMT
meetings %within% int
# [1]  TRUE  TRUE  TRUE FALSE



# duration+%%+as.period ----------------------------------------------------------------
# 
# 從兩個時間點生成一個interval時段數據
now() #[1] "2018-01-07 19:45:33 CST"
x #[1] "2016-10-30 12:31:59 CST"
y <- new_interval(x, now())
# Warning message:
#     'new_interval' is deprecated; use 'interval' instead. 
#   　Deprecated in version '1.5.0'.
y <- interval(x, now()) #在此的tzone是預設"CST"
y #[1] 2016-10-30 12:31:59 CST--2018-01-07 19:45:46 CST
str(x) #POSIXct[1:1], format: "2016-10-30 12:31:59"
class(x) #[1] "POSIXct" "POSIXt"
str(y)
# Formal class 'Interval' [package "lubridate"] with 3 slots
# ..@ .Data: num 37523660
# ..@ start: POSIXct[1:1], format: "2016-10-30 12:31:59"
# ..@ tzone: chr ""
class(y)
# [1] "Interval"
# attr(,"package")
# [1] "lubridate"

# 從interval格式，轉為duration格式
as.duration(y) #[1] "37523659.9211171s (~1.19 years)"

# 時間點+時段，生成新的時間點
now()+as.duration(y) #[1] "2019-03-18 03:03:40 CST"

# 10天後的時間點
now()+ddays(10) #[1] "2018-01-17 19:49:58 CST"
as.duration(y)+ddays(10) #[1] "38387659.9211171s (~1.22 years)"

# duration相關的函式，不填數字的話預設為1。
dyears(15) #[1] "473040000s (~14.99 years)"
dyears(1) #[1] "31536000s (~52.14 weeks)"
ddays(10) #[1] "864000s (~1.43 weeks)"
dminutes(10) #[1] "600s (~10 minutes)"
dseconds(45) #[1] "45s"


arrive <- ymd_hms("2016-06-04 12:10:45", tz = "GMT")
leave <- ymd_hms("2016-08-10 15:25:15", tz = "GMT")
how_long <- interval(arrive, leave)
how_long #[1] 2016-06-04 12:10:45 GMT--2016-08-10 15:25:15 GMT
how_long%/%months(1) #[1] 2
how_long%%months(1) #[1] 2016-08-04 12:10:45 GMT--2016-08-10 15:25:15 GMT
# %/% Integer divide, binary
# %% Modulus, binary

as.period( how_long%%months(1) )
# [1] "6d 3H 14M 30S"
as.period( how_long )
# [1] "2m 6d 3H 14M 30S"



# period ------------------------------------------------------------------
# 
minutes(2) #必須是整數
# [1] "2M 0S"
years(1) #必須是整數
# [1] "1y 0m 0d 0H 0M 0S"

# regular year vs leap year 常年與閏年
leap_year(2011) #[1] FALSE
leap_year(2012) #[1] TRUE




# duration和period的差別 -------------------------------------------------------------
ymd("20120101") + dyears(1)
# [1] "2012-12-31"
ymd("20120101") + years(1)
# [1] "2013-01-01"




# 時區訊息 --------------------------------------------------------------------
# 
# tz：讀取時間資料要用的時區
# with_tz：將時間資料轉換為另一個時區的同一時間
# force_tz：將時間資料的時區強制轉換為另一個時區
time <- ymd_hms("2016-07-01 21:45:00", tz = "Pacific/Auckland")
time #[1] "2016-07-01 21:45:00 NZST"
with_tz(time, tzone = "America/Chicago")
# [1] "2016-07-01 04:45:00 CDT"
force_tz(time, tzone = "asia/shanghai")
# [1] "2016-07-01 21:45:00 CST"
# force_tz(time, tzone = "asia/taipei")
# [1] "2016-07-01 21:45:00 CST"


