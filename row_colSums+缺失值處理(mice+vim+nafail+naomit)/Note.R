# vignette(package = "套件名稱")
# vignette("套件內的說明檔案")

####R對行或列求和####
data00 <- matrix(1:6, nrow = 2, byrow=T, 
                 dimnames = list(c("r1", "r2"), c("c1", "c2", "c3")))
# matrix(1:6, nrow = 2, ncol = 3, byrow=T) 效果相同，所以確定nrow或ncol即可。
# byrow=T表示數值的填入會將橫排先填滿，再往下填。
data00
#    c1 c2 c3
# r1  1  2  3
# r2  4  5  6

row_sum <- rowSums(data00)
# r1 r2 
# 6 15

col_sum <- colSums(data00)
# c1 c2 c3 
# 5  7  9 

####把結果合併####
temp <- cbind(data00, row_sum=row_sum)
temp
#    c1 c2 c3 row_sum
# r1  1  2  3       6
# r2  4  5  6      15

col_sum <- colSums(temp)
col_sum
# c1      c2      c3 row_sum 
# 5       7       9      21 

final <- rbind(temp, col_sum=col_sum)
final
#          c1 c2 c3 row_sum
# r1       1  2  3       6
# r2       4  5  6      15
# col_sum  5  7  9      21

str(final)
# num [1:3, 1:4] 1 4 5 2 5 7 3 6 9 6 ...
# - attr(*, "dimnames")=List of 2
# ..$ : chr [1:3] "r1" "r2" "col_sum"
# ..$ : chr [1:4] "c1" "c2" "c3" "row_sum"
class(final)
# [1] "matrix"

#缺失值的處理
####什麼是缺失值，NA與NULL的區別####

# (1)NA表示資料集中的該資料遺失、不存在。
# (續)在針對具有NA的資料集進行函數操作的時候，該NA不會被直接剔除。
# (續)如x<-c(1,2,3,NA,4)，取mean(x)，則結果為NA，
# (續)如果想去除NA的影響，需要顯式告知mean方法，如 mean(x,na.rm=T)；
# (續)NA是沒有自己的mode的，在vector中，它會“追隨”其他資料的類型，
# (續)比如剛剛的x，mode(x)為numeric，mode(x[4])亦然
library(dplyr)
x <- c(1,2,3,4,NA,4)
mean(x) #[1] NA
mean(x, na.rm = T) #[1] 2.8
mode(x) #[1] "numeric"
x[5] #[1] NA
x[5] %>% mode() #[1] "numeric"

# (2)NULL表示未知的狀態。
# (續)它不會在計算之中，如x<-c(1,2,3,NULL,4)，
# (續)取mean(x)，結果為2.5
# (續)。NULL是不算數的，length(c(NULL))為0，而length(c(NA))為1。
# (續)可見NA“占著”位置，它存在著，
# (續)而NULL沒有“占著”位置，或者說，“不知道”有沒有真正的資料。
y <- c(1,2,3,NULL,4)
mean(y) #[1] 2.5
mode(y) #[1] "numeric"
y[4] #[1] 4。所以會直接跳過NULL
y #[1] 1 2 3 4


####識別缺失值NA的位置-is.na####
# 在R語言中缺失值通常以NA表示，判斷是否缺失值的函數是is.na。
# is.na 功用01：列出元素是否為NA，傳回True/False
(temp <- c(1:3,NA) )
# [1]  1  2  3 NA
is.na(temp)
# [1] FALSE FALSE FALSE  TRUE

# is.na 功用02：為元素賦予值。
ttemp <- c(1,2,3,4)
is.na(ttemp) <- c(1,4)
ttemp #[1] NA  2  3 NA

ttemp[1,3] #這樣會是error
ttemp[c(1,3)] #[1] NA  3
ttemp[c(1,3)] <- 87
ttemp #[1] 87  2 87 NA
str(ttemp) #num [1:4] 87 2 87 NA
class(ttemp) #[1] "numeric"

ttemp[c(1,3)] <- "A"
ttemp #[1] "A" "2" "A" NA
str(ttemp) #chr [1:4] "A" "2" "A" NA
class(ttemp) #[1] "character"。改變部分值的型態，就會強迫改變所有值得型態。

####識別缺失值NA的位置-complete.cases####
# 另一個常用到的函數是complete.cases，
# 它對資料框進行分析，判斷某一觀測樣本是否完整。
# 下面我們讀取VIM包中的sleep資料作為例子，
# 它的樣本數為62，變數數為10，由complete.cases函數計算可知完整的樣本個數為42。
library(VIM)
data01 <- sleep
dim(data01) #[1] 62 10
data01_logi <- complete.cases(sleep)
data01_logi # [1] FALSE  TRUE FALSE FALSE  TRUE  TRUE  TRUE ...省略。
# 只要該橫排有數據是NA，就回傳FALSE。
str(data01_logi) #logi [1:62] FALSE TRUE FALSE FALSE TRUE TRUE ...
class(data01_logi) #[1] "logical"

data02 <- data01[data01_logi,]
data02
# 有NA值的就不會出現了。
# BodyWgt BrainWgt NonD Dream Sleep  Span  Gest Pred Exp Danger
# 2     1.000     6.60  6.3   2.0   8.3   4.5  42.0    3   1      3
# 5  2547.000  4603.00  2.1   1.8   3.9  69.0 624.0    3   5      4
# 6    10.550   179.50  9.1   0.7   9.8  27.0 180.0    4   4      4
# ...省略。

dim(data02) #[1] 42 10
# length(data02) #會出現有幾個直行!!
# ncol(data02) #同上
# nrow(data02) #會出現有幾個橫排!!
sum(data01_logi) #[1] 42。表示有多少筆沒有NA值的資料。

####VIM套件-圖形方式描述缺失資料####
#可以使用vim包的aggr函數，以圖形方式描述缺失資料。
aggr(sleep) 
# 會以propotion的方式呈現，因為參數的預設是propotion
# 上面的左圖顯示各變數缺失資料比例，
# 右圖顯示了各種缺失模式和對應的樣本數目
# ，顯示nond和dream經常同時出現缺失值。

aggr(sleep, prop=FALSE, numbers=TRUE)
# 圖表解釋：
# 可以看到，變數NonD有最大的缺失值數（14），
# 有2個哺乳動物缺失了NonD、Dream和Sleep的評分。
# 42個動物沒有缺失值。

aggr(sleep,prop=TRUE,numbers=TRUE)
# 將生成相同的圖形，但用比例代替了計算，
# 選項numbers=FALSE（預設）刪去了數值型標籤。
# 42/62 #[1] 0.6774194

matrixplot(sleep)
# matrixplot()函數可生成展示每個實例數據的圖形
# 此處，數值型數據被重新轉換到[0,1]區間，
# 並用灰度來表示大小：淺色表示值小，深色表示值大。
# 而預設缺失值為紅色，可以去改參數設定。


####處理缺失資料####
# 對於缺失資料通常有三種應付手段：
# (1)當缺失資料較少時直接刪除相應樣本
# 刪除缺失資料樣本，其前提是缺失資料的比例較少，
# 而且 缺失資料 是 隨機 出現的，這樣刪除缺失資料後對分析結果影響不大。
# Q：要怎麼知道缺失資料是隨機出現的呢?

# (2)對缺失資料進行插補
# 用變數均值或中位數來代替缺失值，
# 其優點在於不會減少樣本資訊，處理簡單。
# 但是缺點在於當缺失資料不是隨機出現時會產成偏誤。

# 補充知識-多重插補法(Multiple imputation)：
# 多重插補是通過變數間關係來預測缺失資料，
# 利用蒙特卡羅方法生成多個完整資料集，
# 再對這些資料集分別進行分析，最後對這些分析結果進行匯總處理。
# 在R語言中實現方法是使用mice套件中的mice函數。

# (3)使用對缺失資料不敏感的分析方法，例如決策樹。

# 總而言之，基本上對缺失資料處理的流程是
# 首先判斷其模式是否隨機，
# 然後找出缺失的原因，最後對缺失值進行處理。


####mice套件的介紹####
# 可以看到mice函數的方法請見：
# ?mice
# vignette(package = "mice")
# vignette("resources")

# 大致的步驟如下：
# step01:mice從 缺失資料集 開始
# step02:MCMC估計插補成數個完整資料集
# (續)(幾個可以由參數決定。蒙地卡羅馬可夫算法(Markov Chain Monte Carlo))
# (續)每個完整資料集，都是通過對原始缺失資料集作插補生成的。
# (續)插捕有隨機的成分，所以每個完整的資料集都略有不同。
# step03:每個完整資料集進行統計的建模(glm、lm模型)
# step04:將這些模型單獨的分析結果，整合到一起(pool)，對每個係數用平均的方式當作最終結果。
# step05:評價插補模型優劣(模型係數的t統計量)
# step06:輸出完整資料集(complete)

library(VIM)
library(mice)
imp=mice(sleep, m=5, method = "pmm", seed=1234)
fit=with(imp,lm(Dream~Span+Gest)) 
#m=多少，就是代表有幾個完整的資料集，所以fit就會有幾個結果。
pooled=pool(fit)
summary(pooled)
# 大致的解釋
# 生成多個完整資料集存在imp中，再對imp進行線性回歸，
# 最後用pool函數對回歸結果進行匯總，對每個係數用平均的方式當作最終結果。
# 匯總結果的前面部分和普通回歸結果相似，
# nmis表示了變數中的缺失資料個數，
# fmi表示fraction of missing information，即由缺失資料貢獻的變異。

imp
# Multiply imputed data set
# Call:
#     mice(data = sleep, m = 5, seed = 1234)
# Number of multiple imputations:  5 
# Missing cells per column:
#     BodyWgt BrainWgt     NonD    Dream    Sleep     Span     Gest     Pred      Exp   Danger 
# 0        0       14       12        4        4        4        0        0        0 
# Imputation methods:
#     BodyWgt BrainWgt     NonD    Dream    Sleep     Span     Gest     Pred      Exp   Danger 
# ""       ""    "pmm"    "pmm"    "pmm"    "pmm"    "pmm"       ""       ""       "" 
# VisitSequence:
# NonD Dream Sleep  Span  Gest 
#    3     4     5     6     7 
# PredictorMatrix:
#          BodyWgt BrainWgt NonD Dream Sleep Span Gest Pred Exp Danger
# BodyWgt        0        0    0     0     0    0    0    0   0      0
# BrainWgt       0        0    0     0     0    0    0    0   0      0
# NonD           1        1    0     1     1    1    1    1   1      1
# Dream          1        1    1     0     1    1    1    1   1      1
# Sleep          1        1    1     1     0    1    1    1   1      1
# Span           1        1    1     1     1    0    1    1   1      1
# Gest           1        1    1     1     1    1    0    1   1      1
# Pred           0        0    0     0     0    0    0    0   0      0
# Exp            0        0    0     0     0    0    0    0   0      0
# Danger         0        0    0     0     0    0    0    0   0      0
# Random generator seed value:  1234 


####mice函式參數比較詳細的解釋####
# (1)imp物件中，包含了
# -m=5指的是插補資料集的數量，5是預設值。
# -每個變數缺失值個數資訊
# -每個變數插補方法(PMM，Predictive mean matching，為預測均值匹配法)，
# (續)其他插補方法可以通過methods(mice)來查看。
# (續)例如有：貝葉斯線性回歸(norm)、基於bootstrap的線性回歸(norm.boot)、線性回歸預測值(norm.predict)、分類回歸樹(cart)、隨機森林(rf)
# (續)使用這些插補方法對資料有嚴格的要求，比如貝葉斯線性回歸等前三個模型都需要資料符合numeric格式，而PMM、cart、rf任意格式都行。
# -插補的變數有哪些，就是第幾個變數。
# -預測變數矩陣(在矩陣中，行代表插補變數，列代表那些變數是插補提供資訊的， 1和0分別表示使用和未使用)
# (續)比如說，看第4列(第4橫排)，要插補NonD，所以為1 1 0 1 1 1 1 1 1 1，
# -只有NonD不會使用到，其他為了差補NonD都會使用到。

# 使用以上模型遇見的問題有：
# -PMM相當於某一指標的平均值作為插補，會出現插補值重複的問題。
# -cart以及rf是挑選某指標中最大分類的那個數字，是指標中的某一個數字，未按照規律。
# -要使用norm.predict，必須先對資料進行格式轉換，這個過程中會出現一些錯誤。

# 在此需要被插捕的變數有 NonD Dream Sleep  Span  Gest
# 利用 imp$imp$被插補的變數，可以找到，
# (續)每個插補資料集缺失值位置的資料補齊具體數值是什麼。
imp$imp$Gest
#      1  2   3   4   5
# 13  52 19  46  60 120
# 19 252 28  28 151 150
# 20  12 28  21  28  12
# 56 120 60 100  42  25
# 因為m=5，所以重複插補5次。
# 這邊可以幫助檢查插補植是否合理!!
# (續)有時候該變相必須是正數，結果插補出現負數，就要換一下seed的數字


# (2)with函數。
# 插補模型可以多樣化，比如lm、glm都是可以直接應用進去，詳情可見《R語言實戰》第十五章。


# (3)pool函數。
# summary之後，會出現lm模型係數，可以如果出現係數不顯著，那麼則需要考慮換插補模型；


# (4)complete函數。
# 針對m個完整插補資料集，可以利用此函數觀察任何一個完整插補資料集。
data <- complete(imp, action = 4)
data[1:5,]
#    BodyWgt BrainWgt NonD Dream Sleep Span Gest Pred Exp Danger
# 1 6654.000   5712.0  3.2   0.5   3.3 38.6  645    3   5      3
# 2    1.000      6.6  6.3   2.0   8.3  4.5   42    3   1      3
# 3    3.385     44.5 10.8   1.8  12.5 14.0   60    1   1      1
# 4    0.920      5.7 15.2   1.2  16.5 28.0   25    5   2      3
# 5 2547.000   4603.0  2.1   1.8   3.9 69.0  624    3   5      4

# (5)with-pool函數的作用
# 使用Mice包的過程中會出現以下的疑惑：
# 已經有mice函數補齊了缺失值，可以直接用compete直接調出，
# 為什麼還要用with，pool?
# 這是因為針對mice函數中預設插補5個資料集，
# 那麼哪個資料集最好，值得選出？
# 
# 筆者認為with-pool的作用是用來選擇資料集的。
# with函數中有5個插補資料集的回歸模型，
# (續)然後做資料集T檢驗，看看某資料集是否合格；
# pool函數把5個回歸模型匯總，
# (續)然後彙總的資料集作F檢驗，看看整個方法是否合格。


####缺失資料的統計-輸出表格####
# 存在缺失資料情況下，需進一步判斷缺失資料的模式是否隨機。
# 在R中是利用mice包中的md.pattern函數。
library(mice)
md.pattern(sleep)
# 上表中的1表示沒有缺失資料，0表示存在缺失資料。
# 第一列第一行的42表示有42個樣本是完整的，
# 最後一列的第一行的1表示有一個樣本缺少了span、dream、nond三個變數，
# 最後一行表示各個變數缺失的樣本數合計。


####na.fail和na.omit####
# (1)na.fail(<向量a>):如果向量a內包括至少1個NA，則返回錯誤；
# 如果不包括任何NA，則返回原有向量a
# 
# (2)na.omit(<向量a>): 返回刪除NA後的向量a
# (3)attr(na.omit(<向量a>) ,”na.action”): 返回向量a中元素為NA的下標
# (4)is.na：判斷向量內的元素是否為NA
# 
# 函數na.fail和 na.omit 不僅可以應用于向量，也可以應用於矩陣和資料框。

data<-c(1,2,NA,2,4,2,10,NA,9)
data.na.omit<-na.omit(data)
data.na.omit
# [1]  1  2  2  4  2  10  9
# attr(,"na.action")
# [1] 3 8
# attr(,"class")
# [1] "omit"

attr(data.na.omit,"na.action")
# [1] 3 8
# attr(,"class")
# [1] "omit"

# 可以使用!x方式方便地刪除NA
a<-c(1,2,3,NA,NA,2,NA,5)
a1 <- a[!is.na(a)]
a1
# [1] 1 2 3 2 5
str(a1) #num [1:5] 1 2 3 2 5
class(a1) #[1] "numeric"

#na.omit也可以有類似的結果，但是型態上要做一些修正。
a2 <- na.omit(a) 
a2
# [1] 1 2 3 2 5
# attr(,"na.action")
# [1] 4 5 7
# attr(,"class")
# [1] "omit"
str(a2) 
# 和a1不同
# atomic [1:5] 1 2 3 2 5
# - attr(*, "na.action")=Class 'omit'  int [1:3] 4 5 7
class(a2) #[1] "numeric"
a2 <- as.numeric(a2)
str(a2) #num [1:5] 1 2 3 2 5
# 和a1相同
class(a2) #[1] "numeric"

####Example for na.omit####
data <- read.table(text="
a b c d e f
NA 2 1 1 1 1
3 0 3 3 3 3
1 1 NA 1 1 1
1 1 1 NA 1 1
1 1 1 1 NA 1
1 1 1 1 1 NA",header=T)
data
#    a b  c  d  e  f
# 1 NA 2  1  1  1  1
# 2  3 0  3  3  3  3
# 3  1 1 NA  1  1  1
# 4  1 1  1 NA  1  1
# 5  1 1  1  1 NA  1
# 6  1 1  1  1  1 NA

data <- na.omit(data)
data
#   a b c d e f
# 2 3 0 3 3 3 3
# 由此可知na.omit是刪除橫排。
str(data)
# 'data.frame':	1 obs. of  6 variables:
# $ a: int 3
# $ b: int 0
# $ c: int 3
# $ d: int 3
# $ e: int 3
# $ f: int 3
# - attr(*, "na.action")=Class 'omit'  Named int [1:5] 1 3 4 5 6
# .. ..- attr(*, "names")= chr [1:5] "1" "3" "4" "5" ...
class(data) #[1] "data.frame"


data <- read.table(text="
a b c d e f
NA 1 1 1 1 1
1 NA 1 1 1 1
1 1 NA 1 1 1
1 1 1 NA 1 1
1 1 1 1 NA 1
1 1 1 1 1 NA",header=T)
data <- na.omit(data)
data
# [1] a b c d e f
# <0 rows> (or 0-length row.names)

