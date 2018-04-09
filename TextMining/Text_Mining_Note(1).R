# R的字串處理

# R 的字串處理 ,
# 要小心注意 character , factor , numeric 這三種物件的誤轉換和混用
# factor 是一種很討厭的物件 ,
# 因為它在轉成數字和字串的時候 ,
# 常常會變成跟原本不一樣的東西 ,
# 建議資料處理的過程 ,
# 預設用 matrix 和 character 兩種而避免使用 data.frame

####1.字串黏合####
paste("A","B",sep="") # [1] "AB"

####2.字串切割####
strsplit("A.B",split=".",fixed=T)
# [[1]]
# [1] "A" "B"
strsplit("A.B",split=".",fixed=F)
# [[1]]
# [1] "" "" ""

####3.精確穩合####
x <- c("AB","AA")
x %in% "AB"
# [1]  TRUE FALSE

####4.部份吻合+(回傳 which)####
x <- c("AB","AA")
grep("B",x) #[1] 1
grep("A",x) #[1] 1 2
grep("B",x,value=T) #[1] "AB"
grep("B",x,value=T,invert=T) #[1] "AA"
grep("C",x) #integer(0)
#若目的是要找 index , 建議改用 grepl

####4-2.部份吻合+(回傳判斷式)####
x <- c("AB","AA")
grepl("B",x) #[1]  TRUE FALSE

####4-3.部份吻合 + (回傳位置) + (回傳有無找到)####
x <- c("BBB","AAA","CCB")
regexpr("B",x)
# [1]  1 -1  3 (第一次 "fit" 的位置)
# attr(,"match.length")
# [1]  1 -1  1 (有無 "fit")
# attr(,"useBytes")
# [1] TRUE

####5.子字串####
substr("human123456",start=1,stop=5)
# [1] "human"

####補充小知識-regexpr+substr####
# 在寫網頁Parser的時候很好用，regexpr 能定義出 start=多少
# 
# 所謂的網頁Parser，就是你去下載某些 html 檔案，
# 檢視原始碼，然後找出你需要的資料
# 再找出一些能 cut 的規則，
# 用 strsplit 搭配特殊的切割資串的字串，去切出你要的資料

####6.特定字元取代(1st fit)####
x <- "AABB"
sub("A",replacement="C",x) #[1] "CABB"

####6-2.全部特定字元取代(global hit)####
x <- "AABB"
gsub("A",replacement="C",x) #[1] "CCBB"

####7.計算字串長度####
# 盡量別用這個 fuction
x <- c("A","AAA","AAAAA")
nchar(x) #[1] 1 3 5

####8.多重字元(串)貼合(矩陣內)####
x <- matrix(letters[1:6],2,3)
#      [,1] [,2] [,3]
# [1,] "a"  "c"  "e" 
# [2,] "b"  "d"  "f"
apply(x,1,paste,collapse="") #[1] "ace" "bdf" 
apply(x,2,paste,collapse="") #[1] "ab" "cd" "ef"
# 簡言之，apply就是 列表的迭代。
# *apply系列只是用法稍有不同。
# *apply 系列的函數只會將列表或向量中的元素逐一取出，放在指定函數的第一個參數來執行。

####9. 字元反轉####
x <- c("A B","*.")
# [1] "A B" "*." 

strsplit(as.character(x), NULL)
# [[1]]
# [1] "A" " " "B"
# 
# [[2]]
# [1] "*" "."

lapply(strsplit(as.character(x), NULL), rev)
# [[1]]
# [1] "B" " " "A"
# 
# [[2]]
# [1] "." "*"

sapply(lapply(strsplit(as.character(x), NULL), rev), paste, collapse="")
# [1] "B A" ".*"


####10.字元檢查，看有幾種不同的文字####
x <- c("A B","*.","ABC")
# [1] "A B" "*."  "ABC"

strsplit(as.character(x),split="",fixed=T)
# [[1]]
# [1] "A" " " "B"
# 
# [[2]]
# [1] "*" "."
# 
# [[3]]
# [1] "A" "B" "C"

unlist(strsplit(as.character(x),split="",fixed=T))
# [1] "A" " " "B" "*" "." "A" "B" "C"

unique(unlist(strsplit(as.character(x),split="",fixed=T)))
# [1] "A" " " "B" "*" "." "C"


####Regular expression:字串模糊比對,或特定字母排列模式的抓取####

# 在R內
# 基本上分成3種
# Basic regular expression    (BRE)   --> extended = FALSE
# Extended regularexpression  (ERE)   --> extended = TRUE (預設)
# perl-like                   (perl)  --> perl     = TRUE

####通用部分，也就是BRE####
# *        :: {0, }   至少出現0次, 最多無限多次
# +        :: {1, }           1        無限多次
# ?        :: {0,1}           0            1

# [Aa]     :: A 或 a
# [^1-9]   :: not 1:9
# [1-9]    :: 1:9
# [a-z]    :: a b c ... z
# [A-Z]    :: A B C ... Z
# [a-zA-Z] :: 所有英文字母
# [W-z]    :: WXYZabc....z
# [w-Z]    :: 不可使用!

# (AB)     :: 括號一次收集多個字元  # 一種延伸字串的寫法
# 舉例 :
    
x <- c("company","companies")
# 可以用以下兩種寫法
grep("[company|companies]",x) #[1] 1 2
grep("compan(y|ies)",x) #[1] 1 2
# 第二種在大資料的時候會比較快

# $        :: 字尾限定
# ^        :: 字首限定

# |        :: "ABC|EFG" --> grep("ABC"or"DEF",x)
# .        :: 任意字元


####ERE, Extended regularexpression####
# digit (數字)
# \\d         :: [0-9]
# [[:digit:]]  :: 同上
# \\D         :: [^0-9]
# [^[:digit:]] :: 同上

# blank (空白)
# \\s         :: 能切開 " " 或 "\t"
# [[:blank:]]  :: 同上
# \\S         :: 切開非空白及 tab 的字元
# [^[:blank:]] :: 同上

# AlphaBet + Digit (正常字元)
# \\w         :: [0-9a-zA-Z]
# [[:alnum:]]  :: 同上
# \\W         :: [^0-9a-zA-Z]
# [^[:alnum:]] :: 同上

# AlphaBet (英文字元)
# [[:alpha:]]  :: 同上，[a-zA-Z]
# [^[:alpha:]] :: 同上，[^a-zA-Z]

# 特殊符號
# [[:punct:]]  :: ! " # $ % & ' ( ) * + , - .
#                 / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
# [^[:punct:]] :: 英文字 , 數字 (注意! , \t 和 \n 都會被切掉)
# 注意!!正斜線這個符號很容易與其他 regular expr 混淆
# 必須仔細檢查 "\" 存在的字串

# 可印符號
# [[:print]] :: 所有字元 (數字,字母,特殊符號,空白)
#               \n , \t , \001 除外

# 16進位字元
# [[:xdigit:]] :: 16進位有關英文或數字
#                 [0-9a-fA-F]

# 大小寫英文字元
# [[:upper:]]  :: 大寫英文字元 [A-Z]
# [^[:upper:]] :: 非大寫 [^A-Z]
# [[:lower:]]  :: 小寫 [a-z]
# [^[:lower:]] :: ^[a-z]
# 注意 "\t" 還是會被留下來

# 空白和換行等
# [[:space:]] :: " " , \t , \n , \f , \r
#               (\f : 換行但不回到行頭)
#               (\r : 回到行頭並消除此行內所有的文字)
#               P.S. 這兩種不常用,當小知識即可

# [[:graph:]] :: [A-Za-z0-9]再加[["punct"]]


####perl, perl-like####
# \\w :     [A-Za-z0-9_]
# \\W :     [^A-Za-z0-9_]
# \\s :     [\t\n\r\f]
# \\S :     [^\t\n\r\f]
# \\d :     [0-9]
# \\D :     [^0-9]


####參考資料####
# 本篇網址：https://www.ptt.cc/bbs/Statistics/M.1277714037.A.2CC.html
#           (續)後面有提套一些關於linux的指令，以及綁案太大R無法處理，必須先減肥的流程概念。
# 延伸參考：http://sites.stat.psu.edu/~drh20/R/html/base/html/regex.html
#           (續)有下載放在資料夾，html的檔案名稱為regex.html


####大小寫切換####
TRUTH <- c("Abc","ABC")
a <- gsub("(\\w)","\\L\\1",TRUTH,perl=TRUE) #[1] "abc" "abc"
b <- gsub("^(\\w)","\\U\\1",a,perl=TRUE) #[1] "Abc" "Abc"
c <- gsub("(\\w)","\\U\\1",a,perl=TRUE) #[1] "ABC" "ABC"

####消除多餘空白####
x <- "Hey! Apple           "
gsub(" {2,}","",x)
# [1] "Hey! Apple"
# 容忍一個空白 , 但兩個以上至無限大則消除

# 在處理混合字串與數字的資料矩陣的時候
# 常常需要在 data.frame 和 matrix 之間切換
# 有時候會字串會被一些預設的空白字元夾住
# ex:
DATA <- data.frame(" 1" , "15" , "333")
# 經過轉換以後
DATA <- as.matrix(DATA)
#      X..1. X.15. X.333.
# [1,] " 1"  "15"  "333" 
DATA <- gsub("^ *| *$", "", as.matrix(DATA) )
#      X..1. X.15. X.333.
# [1,] "1"   "15"  "333" 


####一些參考的pattern####
# "^\\d+$"                  #純數字的欄位
# "^ *| *$"                 #字首字尾的空白(搭配 gsub)
# "^[0][\\.]{0,1}[0]*$"     #"0" "0.0" "0.00" "0.000" "0.0000" ,
#                            bug 是 "0." "00"















