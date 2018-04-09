# 參考網站：https://blog.gtwang.org/r/r-advanced-loops/
# 
# 這裡介紹 R 的幾種進階迴圈使用方式，善用這些 R 特有的迴圈技巧可以讓程式碼更簡潔。
# R 語言除了提供一般性的 repeat、while 與 for 迴圈之外，
# 還有許多進階的迴圈使用方式，
# 它可以讓您將特定的函數套用至『列表、向量或陣列』中的『每一個』元素，
# 進行特定的運算後，傳回所有元素個別運算的結果。


# replicate 函數 ------------------------------------------------------------
# 
# replicate 函數跟 rep 函數類似，
# 但 rep 只是單純將 輸入的值 重複指定的次數，
# 而 replicate 則是會對 指定的運算式 重複執行指定的次數。
# 在大多數的情況之下，這兩個函數的作用是相同的：
rep(1.2, 3)
# [1] 1.2 1.2 1.2
replicate(3, 1.2)
# [1] 1.2 1.2 1.2

# 但如果遇到含有隨機變數的運算式時，就會有很大的差異，例如：
rep(rnorm(1), 3) 
# 結果會是三個相同的值，隨機從常態(0,1)抽出來
# [1] 1.074459 1.074459 1.074459
replicate(3, rnorm(1))
# 三個會是不一樣的值。
# [1] -0.3142720 -0.7496301 -0.8621983

# replicate 函數主要用於
# 固定計算次數的蒙地卡羅（Monte Carlo）運算，
# 也就是每一次的迭代運算都是完全獨立的狀況。


# 範例 1 --------------------------------------------------------------------
# 以下是一個模擬通車時間的小程式，
# 我們使用不同的隨機變數分佈，模擬搭乘不同交通工具所需要的時間。

traffic.time <- function() {
    # 選擇交通工具
    transportation <- sample(
        c("car", "bus", "train", "bike"),
        size = 1,
        prob = c(0.2, 0.3, 0.3, 0.2)
    )
    # 模擬通車時間
    time <- switch(
        transportation,
        car = rlnorm(1, log(30), 0.5),
        bus = rlnorm(1, log(40), 0.5),
        train = rnorm(1, 30, 10),
        bike = rnorm(1, 70, 5)
    )
    names(time) <- transportation
    time
}

# 這樣的程式結構中因為含有 switch 判斷式，
# 所以比較難使用一般的向量化寫法，
# 也就是說我們每一次要模擬通車時間的時候，
# 就需要執行一次 traffic.time 函數，
# 這樣的情況就可以使用 replicate 函數來進行模擬：

AA <- replicate(6, traffic.time())
#     bike    train    train      bus      bus ...省略
# 78.55316 30.41833 35.37580 17.69590 16.89275 ...省略
str(AA) #Named num [1:10]
class(AA) #[1] "numeric"

A <- as.numeric(AA)
str(A) #num [1:10] 78.6 30.4 35.4 17.7 16.9 ...
class(A) #[1] "numeric"

# 幾個常處理資料的方法
A <- as.matrix(AA, ncol = 1)
#          [,1]
# bus  59.26889
# car  21.18252
# bus  29.88413
# bike 72.20111
# car  31.31110
# bike 68.16875
A <- t(A)
#           bus      car      bus     bike     car     bike
# [1,] 59.26889 21.18252 29.88413 72.20111 31.3111 68.16875

A <- as.data.frame(AA)
#         AA
# 1 59.26889
# 2 21.18252
# 3 29.88413
# 4 72.20111
# 5 31.31110
# 6 68.16875

# 但比較想要的形式為
A <- as.matrix(AA, ncol = 1)
A <- t(A)
A <- as.data.frame(A)
#        bus      car      bus     bike     car     bike
# 1 59.26889 21.18252 29.88413 72.20111 31.3111 68.16875



# 範例 2 --------------------------------------------------------------------
# 以下是另外一個簡單的 bootstrap 範例，
# 使用重複的抽樣來計算母體平均數的 95% 的信賴區間模擬值，
# 首先產生常態分配的樣本：
rn <- rnorm(n = 1000, mean = 10, sd = 1)

# 接著使用 replicate 函數重複取樣，
# 然後計算母體平均數的 95% 的信賴區間的模擬值：
quantile(replicate(1000, 
                   mean(sample(rn, replace = TRUE))
                   ),
         probs = c(0.025, 0.975)
         )
#     2.5%     97.5% 
# 9.949636 10.072916

# 我們可以拿標準的 95% 的信賴區間來跟模擬值比較：
t.test(rn)
# One Sample t-test
# 
# data:  rn
# t = 316.09, df = 999, p-value < 2.2e-16
# alternative hypothesis: true mean is not equal to 0
# 95 percent  confidence interval:
#    9.947519 10.071804
# sample estimates:
# mean of x 
# 10.00966 

t.test(rn)$conf.int
# [1]  9.947519 10.071804
# attr(,"conf.level")
# [1] 0.95



# 列表的迭代 -------------------------------------------------------------------
# 以 R 語言撰寫程式時，
# 應該盡可能使用向量化運算的方式來處理各種重複性的運算，
# 這樣除了可讓程式碼更容易閱讀之外，執行速度也會比一般性的迴圈高出許多。
# 
# 然而並非所有的程式邏輯都可以很直接的使用向量化運算來處理，
# 若遇到無法修改成向量化程式碼的情況時，
# 可以改用 *apply 系列的函數，
# 使用這類的函數雖然在執行效能上不會改變，但是至少可以讓程式碼比較整潔。
# 
# 一般 R 語言的向量化運算是屬於 C 語言層級迴圈，
# 執行速度較快，而 *apply 系列的函數是屬於 R 語言層級的迴圈，
# 執行速度接近一般的 R 迴圈。


# lapply ------------------------------------------------------------------
# 
# 在 *apply 系列的函數中，
# 最常被使用的就是 lapply 函數(list apply)，
# 它可以接受 一個列表變數 以及 一個函數，
# 然後將列表變數中的每個元素一一交給該函數處理，
# 最後傳回所有的結果所組成的列表。

# 假設我們有一個列表的資料如下：
# 產生資料
x.list <- list(
    a = rgeom(6, prob = 0.1),
    b = rgeom(6, prob = 0.4),
    c = rgeom(6, prob = 0.7)
)
x.list
# $a
# [1] 12  1  3 17 12  6
# $b
# [1]  2  0  1  0 11  0
# $c
# [1] 0 1 0 1 0 0

# 若想要將此列表中每個元素都交由 unique 處理，
# 刪除重複的數值，使用一般迴圈的做法會類似下面這樣：
# 初始化 x.uniq
x.uniq <- vector("list", length(x.list))
# [[1]]
# NULL
# [[2]]
# NULL
# [[3]]
# NULL

for ( i in seq_along(x.list) ) {
    # 對 x.list 的每個元素進行 unique 運算
    x.uniq[[i]] <- unique(x.list[[i]])
}
# [[1]]
# [1] 12  1  3 17  6
# [[2]]
# [1]  2  0  1 11
# [[3]]
# [1] 0 1
# 設定 x.uniq 的元素名稱

names(x.uniq) <- names(x.list)
x.uniq
# $a
# [1] 12  1  3 17  6
# $b
# [1]  2  0  1 11
# $c
# [1] 0 1

# 像這樣的動作無法直接使用向量化的寫法來處理，
# 不過我們可以改用 lapply，讓程式碼比較乾淨一些：
# 改用 lapply
A <- lapply(x.list, unique)
# $a
# [1] 12  1  3 17  6
# $b
# [1]  2  0  1 11
# $c
# [1] 0 1
str(A)
# List of 3
# $ a: int [1:5] 12 1 3 17 6
# $ b: int [1:4] 2 0 1 11
# $ c: int [1:2] 0 1
class(A) #[1] "list"



# vapply ------------------------------------------------------------------
# 
# 如果每個元素的計算結果都是長度相同的向量，
# 可以使用 vapply 函數，它的功能跟 lapply 相同，
# 只是會以向量的方式傳回結果：
A <- vapply(x.list, length, numeric(1))
# a b c 
# 6 6 6 
# 這裡的第三個參數是傳回值的樣板，vapply 會將計算的結果依照這個樣板傳回。
str(A)
# Named num [1:3] 6 6 6
# - attr(*, "names")= chr [1:3] "a" "b" "c"
class(A)
# [1] "numeric"

# 以下是使用 fivenum 計算每個元素的 Tukey’s five number summary：
A <- vapply(x.list, fivenum,
       c("Min." = 0, "1st Qu." = 0, "Median" = 0,
         "3rd Qu." = 0, "Max." = 0))
#          a    b c
# Min.     1  0.0 0
# 1st Qu.  3  0.0 0
# Median   9  0.5 0
# 3rd Qu. 12  2.0 1
# Max.    17 11.0 1
str(A)
# num [1:5, 1:3] 1 3 9 12 17 0 0 0.5 2 11 ...
# - attr(*, "dimnames")=List of 2
# ..$ : chr [1:5] "Min." "1st Qu." "Median" "3rd Qu." ...
# ..$ : chr [1:3] "a" "b" "c"
class(A)
# [1] "matrix"


# sapply ------------------------------------------------------------------
# 
# 另外還有一個 sapply 函數，
# 它介於 lapply 與 vapply 之間，其使用的方式跟 lapply 相同：

A <- sapply(x.list, unique)
# $a
# [1] 12  1  3 17  6
# $b
# [1]  2  0  1 11
# $c
# [1] 0 1

str(A)
# List of 3
# $ a: int [1:5] 12 1 3 17 6
# $ b: int [1:4] 2 0 1 11
# $ c: int [1:2] 0 1
class(A)
# [1] "list"

# sapply 會嘗試簡化傳回的變數，
# 在情況許可時會自動將結果轉為向量的形式傳回：
# (這其實有點討厭XD)
A <- sapply(x.list, length)
# a b c 
# 6 6 6 
str(A)
# Named int [1:3] 6 6 6
# - attr(*, "names")= chr [1:3] "a" "b" "c
class(A)
# [1] "integer"

# 對於較高維度的資料，sapply 也可以自動處理：
sapply(x.list, summary)
#             a         b         c
# Min.     1.00  0.000000 0.0000000
# 1st Qu.  3.75  0.000000 0.0000000
# Median   9.00  0.500000 0.0000000
# Mean     8.50  2.333333 0.3333333
# 3rd Qu. 12.00  1.750000 0.7500000
# Max.    17.00 11.000000 1.0000000

# 對於使用互動式操作來使用 R 的狀況來說，
# 使用 sapply 函數會比較方便，
# 就算使用者不確定執行結果會是什麼，它通常都可以自動將結果以最適合的方式呈現。


# 向量的迭代 -------------------------------------------------------------------
# 
# 雖然 *apply 系列的函數主要是用來處理列表變數的，
# 但它也可以接受一般的向量，而其對於向量的處理方式也是跟列表類似，
# 逐一將元素交給指定的函數來處理。

# source 這個函數可以從檔案中載入 R 的程式碼並且執行，
# 但這個函數沒有支援向量化的運算，
# 如果要一次載入多個 .R 指令稿，可以配合 lapply 一起使用：
getwd()
setwd("C:/Users/User/Documents/Learn/TextMining/")
dir()
r.files <- dir(pattern = "\\.R$")
r.files
lapply(r.files, source, echo=T, encoding="UTF-8")
# source函數會失敗，因為檔案中有中文字!!
# 解決方法：source(file = "R檔案", echo = T, encoding = "UTF-8")
# 但要小心他會直接執行
# 這裡我們使用 dir 指令加上正規表示法，
# 取得所有檔名為 .R 結尾的指令稿，接著使用 lapply 逐一載入每個指令稿。


# 進階使用 --------------------------------------------------------------------
# 
# 使用 *apply 系列的函數時，
# 若需要傳遞一些額外的參數給指定的函數，
# 可以將具名參數放在最後面，這樣該參數就會自動被傳入：

lapply(x.list, quantile, probs = 1:3/4)
# $a
# 25%   50%   75% 
# 2.25 10.00 15.50 
# $b
# 25% 50% 75% 
# 0.0 0.5 1.0 
# $c
# 25%  50%  75% 
# 0.00 0.00 0.75 

# 由於 *apply 系列的函數只會將列表或向量中的元素逐一取出，
# 放在指定函數的第一個參數來執行，
# 若遇到指定函數的輸入資料不是放在第一個參數時，就要改以自訂函數的方式處理：
x <- 1:3
my.seq <- function(by) seq(2, 10, by = by)
lapply(x, my.seq)
# [[1]]
# [1]  2  3  4  5  6  7  8  9 10
# [[2]]
# [1]  2  4  6  8 10
# [[3]]
# [1] 2 5 8

# 也可以使用匿名函數的寫法：
lapply(x, function(by) seq(2, 10, by = by))
# [[1]]
# [1]  2  3  4  5  6  7  8  9 10
# [[2]]
# [1]  2  4  6  8 10
# [[3]]
# [1] 2 5 8



# eapply ------------------------------------------------------------------
# 
# 如果需要對環境空間中的每一個變數做處理時，可以使用 eapply 函數：
my.env <- new.env()
my.env$foo <- 1:5
my.env$larry <- runif(8)
eapply(my.env, length)
# $foo
# [1] 5
# $larry
# [1] 8



# 陣列的迭代 -------------------------------------------------------------------
# 使用套件matlab
# 
# lapply、vapply 以及 sapply 
# 這幾個函數也可以用在 矩陣與陣列 的迭代上，
# 不過這樣使用的結果通常不如使用者所預期，
# 它會將矩陣或陣列直接視為一般的向量，將每個元素逐一交給指定的函數來處理。

x.mat <- matrix(1:9, 3, 3)
#   [,1] [,2] [,3]
# [1,]    1    4    7
# [2,]    2    5    8
# [3,]    3    6    9
lapply(x.mat, sum)
# [[1]]
# [1] 1
# [[2]]
# [1] 2
# [[3]]
# [1] 3
# ...省略

# 若要對矩陣的一整個行（column）或列（row）來處理，
# 可以使用 matlab 這個套件：
# install.packages("matlab")
library(matlab)
# R 的 matlab 套件中包含一些運作方式類似 Matlab 的函數，
# 而該套件在載入之後，
# 會將 base、stats 與 utils 內建套件中的一些函數覆蓋掉，
# 在使用完畢之後，若要讓這些函數恢復，
# 可以執行 detach("package:matlab") 將 matlab 卸載即可。


# apply -------------------------------------------------------------------
# 
# matlab 套件所提供的 apply 函數其功能類似 lapply，
# 不過它可以允許對矩陣的行或列進行指定的運算，
# 例如計算矩陣每個列的總和：
apply(x.mat, 1, sum)
# [1] 12 15 18
# apply 的第一個參數是輸入的矩陣或陣列，
# 第二個參數是指定如何迭代矩陣或陣列中的資料，
# 若指定為 1 則代表以列（row）的方式迭代，
# 而若指定為 2 則代表以行（column）的方式迭代。
# 而上面這行效果就等同於 rowSums：
rowSums(x.mat)
# [1] 12 15 18

apply(x.mat, 2, summary)
#         [,1] [,2] [,3]
# Min.     1.0  4.0  7.0
# 1st Qu.  1.5  4.5  7.5
# Median   2.0  5.0  8.0
# Mean     2.0  5.0  8.0
# 3rd Qu.  2.5  5.5  8.5
# Max.     3.0  6.0  9.0

# apply 也可以套用在 data frame 上：
(x.df <- data.frame(
    name = c("foo", "bar", "foo.bar"),
    value = c(1.2, 6.9, 2.4)
))
#      name value
# 1     foo   1.2
# 2     bar   6.9
# 3 foo.bar   2.4

apply(x.df, 1, toString)
# [1] "foo, 1.2"     "bar, 6.9"     "foo.bar, 2.4"
apply(x.df, 2, toString)
#                name               value 
# "foo, bar, foo.bar"     "1.2, 6.9, 2.4" 

# 當 apply 以行的方式迭代時，
# 其作用會跟 sapply 相同
# (data frame 可以視為一種巢狀的列表，而其每個列表元素的長度都相等)：
sapply(x.df, toString)
#                name               value 
# "foo, bar, foo.bar"     "1.2, 6.9, 2.4"


# mapply 函數 ---------------------------------------------------
# 
# lapply 有一個缺點就是它一次只能對一個列表變數的元素做迭代處理，
# 另外在指定的處理函數當中，也無法獲取每個列表元素的名稱。
# 
# mapply 是一個可以同時處理多個列表變數迭代的函數，
# 而若需要取得列表元素的名稱，也可以透過第二個參數把名稱傳入。

x.list <- list(
    foo = 12,
    bar = 34
)
my.fun <- function(name, value) {
    paste(name, "is", value)
}
mapply(my.fun, names(x.list), x.list)
#         foo         bar 
# "foo is 12" "bar is 34"

# mapply 預設會跟 sapply 函數一樣將傳回值簡化，
# 若要改變這個行為，可以加上 SIMPLIFY = FALSE 參數。


#  Vectorize 函數------------------------------------------------------------
# 
# Vectorize 是一個
# 可以將非向量化函數轉換為向量化寫法的函數(但效能不會特別的改善)，
# 假設我們有一個無法以向量化表示的函數：
scalar.fun <- function(x) {
    switch(x, foo = "FOO", bar = "BAR", "Other")
}

# 這個函數若直接傳入一個向量參數，會產生錯誤：
input <- c("foo", "bar", "foo.bar")
scalar.fun(input)
# Error in switch(x, foo = "FOO", bar = "BAR", "Other") : 
#     EXPR must be a length 1 vector
# Error in switch(x, foo = "FOO", bar = "BAR", "Other") : 
#     EXPR 必須是長度為 1 的向量

# 這種狀況就可以使用 Vectorize 將其包裝成可以處理向量的形式：
vectorize.fun <- Vectorize(scalar.fun)
vectorize.fun(input)
#   foo     bar foo.bar 
# "FOO"   "BAR" "Other" 



# 資料分組與迭代 -----------------------------------------------------------------
# 方法一：with+lapply/sapply
# 方法二：with+tapply
# 
# 在審視資料時，時常會需要將資料先分組後再計算各組的某些統計量，
# 以 iris 資料為例：
head(iris)
#   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# ...省略

# 假設我們要依據 Species 來分組，
# 計算 Sepal.Length 的平均，首先將資料分組：
colnames(iris)
# [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species" 
(group.data <- with(iris, split(Sepal.Length, Species)))
# split(x, f, drop = FALSE, ...) Divide into Groups and Reassemble
# split函數內的變數順序要想清楚。
# $setosa
# [1] 5.1 4.9 4.7 ...省略
# $versicolor
# [1] 7.0 6.4 6.9 ...省略
# $virginica
# [1] 6.3 5.8 7.1 ...省略

# 接著再以 mean 配合 lapply 來處理：
lapply(group.data, mean)
# $setosa
# [1] 5.006
# $versicolor
# [1] 5.936
# $virginica
# [1] 6.588

# 或是使用 sapply 等函數亦可：
sapply(group.data, mean)
# setosa versicolor  virginica 
#  5.006      5.936      6.588


# tapply ------------------------------------------------------------------
# 
# 像這樣典型的資料分組與迭代的動作，可以使用 tapply 函數來處理：
with(iris, tapply(Sepal.Length, Species, mean))
# setosa versicolor  virginica 
#  5.006      5.936      6.588


# plyr 套件 -----------------------------------------------------------------
# 
# R 內建的 *apply 函數對於許多的迭代問題而言是一個很好用的工具，
# 不過它們還是有一些小缺點，
# 像函數的名稱並沒有清楚表明其作用
# (例如 tapply 的 t 到底代表什麼意思我們也不是很清楚)，
# 而不同函數的參數順序也沒有一致性，
# 另外其傳回值的變數型態並沒有很彈性，造成有時候在使用上會不太方便。
# 
# plyr 套件提供了一系列完整的 **ply 函數，不僅參數格式統一，
# 輸入與輸出的變數型態也很齊全，它的函數名稱有一定的規則，
# 第一個字母代表輸入的變數型態，而第二個字幕則代表輸出的變數型態，



# llply -------------------------------------------------------------------
# 
# 例如 llply 函數就是輸入與輸出都是列表變數（list），
# 所以它可以直接用來替代 lapply 函數：
library(plyr)
x.list <- list(
    a = rgeom(6, prob = 0.1),
    b = rgeom(6, prob = 0.4),
    c = rgeom(6, prob = 0.7)
)
llply(x.list, unique)
# $a
# [1] 29  2  5  3  7
# $b
# [1] 0 1 2
# $c
# [1] 0 3 1



# aply --------------------------------------------------------------------
# 
# laply 則代表輸入變數為列表，而輸出為向量：
laply(x.list, length)
# [1] 6 6 6


# raply、rlply、rdply、r_ply-------------------------------------------------------------------
# 
# raply 是 replicate 的一個替代函數，
# 傳回值是一般的向量，
# 而 rlply 與 rdply 函數則可以將重複的結果以列表或 data frame 的形式傳回，
# 另外 r_ply 會直接將結果丟棄，不傳回任何東西（適用於繪圖等情況）。
raply(3, rnorm(1)) 
#[1]  0.08807394 -1.17962037  2.76096399

rlply(3, rnorm(1))
# [[1]]
# [1] -1.242925
# [[2]]
# [1] 0.3688085
# [[3]]
# [1] 0.6099664

rdply(3, rnorm(1))
#   .n         V1
# 1  1 -1.1418979
# 2  2  0.7144829
# 3  3  0.5833727

A <- r_ply(3, rnorm(1))
str(A) #NULL



# ddply -------------------------------------------------------------------
# 
# ddply 的輸入與輸出都是 data frame 變數，
# 而且可以同時處理多個欄位的資料，可以用來替代 tapply 函數。
# 假設我們要將 iris 這個 data frame 的所有資料都依照 Species 分組後計算平均值，
# 可以這樣做：

ddply(iris, # 輸入的 data frame 
    .(Species), # 依據 Species 分組
    colwise(mean) # 對每個行（column）執行 mean 計算平均值
    )
#      Species Sepal.Length Sepal.Width Petal.Length Petal.Width
# 1     setosa        5.006       3.428        1.462       0.246
# 2 versicolor        5.936       2.770        4.260       1.326
# 3  virginica        6.588       2.974        5.552       2.026
# 
# 這裡使用 colwise 會自動對每一個欄位(除了第二個參數有指定的欄位之外)
# 做指定的運算，不過它的限制就是每個欄位的計算方式都相同!!。
# 
# 第二個參數中所使用的句點函數(.)
# 是 plyr 套件中所定義的一個特殊函數，
# 其作用類似 ~，是為了取得變數名稱而設計的，沒有特別的含義，
# 以下幾種寫法的作用都是相同的：
ddply(iris, .(Species), colwise(mean))
ddply(iris, "Species", colwise(mean))
ddply(iris, ~ Species, colwise(mean))

# 我們也可以使用 summarize 的方式，
# 自行指定要計算的欄位以及各欄位的計算方式：
# 
ddply(iris, # 輸入的 data frame 
    .(Species), # 依據 Species 分組
    summarize, # 自行指定每個欄位的計算方式
    SL.Mean = mean(Sepal.Length), # Sepal.Length 的平均值
    PL.Max = max(Petal.Length) # Petal.Length 的最大值
)
#      Species SL.Mean PL.Max
# 1     setosa   5.006    1.9
# 2 versicolor   5.936    5.1
# 3  virginica   6.588    6.9










