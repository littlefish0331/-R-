# 參考網站：http://azaleasays.com/2008/02/06/r-remove-row-column-all-na-value/
# 本文的Reference: http://www.mail-archive.com/r-help@stat.math.ethz.ch/msg92261.html
# 
# 刪除matrix中全是缺失值(NA)的行或列 --------------------------------------------------
# 
# 我們已經知道，用na.omit()命令可以刪除NA。
# 但是我們希望，只有在某行或某列全是NA時才刪除，
# 而na.omit()所做的事是，只要出現NA值，就把所在行全部刪除。
# 例如：

testmatrix <- matrix(nrow=6, ncol=4)
#   [,1] [,2] [,3] [,4]
# [1,]   NA   NA   NA   NA
# [2,]   NA   NA   NA   NA
# [3,]   NA   NA   NA   NA
# [4,]   NA   NA   NA   NA
# [5,]   NA   NA   NA   NA
# [6,]   NA   NA   NA   NA

testmatrix[2:5,2:3] <- seq(2)
seq(2)
# [1] 1 2
testmatrix
#      [,1] [,2] [,3] [,4]
# [1,]   NA   NA   NA   NA
# [2,]   NA    1    1   NA
# [3,]   NA    2    2   NA
# [4,]   NA    1    1   NA
# [5,]   NA    2    2   NA
# [6,]   NA   NA   NA   NA


# 我們希望得到：testmatrix
#      [,1] [,2] 
# [1,]    1    1 
# [2,]    2    2 
# [3,]    1    1 
# [4,]    2    2 

# 作法如下：
tm1<-testmatrix[, -which( apply( testmatrix,2,function(x)all(is.na(x) ) ) ) ] 
tm2<-tm1[-which(apply(testmatrix,1,function(x)all(is.na(x) ) ) ) , ]
# apply 的第一個參數是輸入的矩陣或陣列，
# 第二個參數是指定如何迭代矩陣或陣列中的資料，
# 若指定為 1 則代表以列（row）的方式迭代，
# 而若指定為 2 則代表以行（column）的方式迭代。
tm1
#      [,1] [,2]
# [1,]   NA   NA
# [2,]    1    1
# [3,]    2    2
# [4,]    1    1
# [5,]    2    2
# [6,]   NA   NA
tm2
#      [,1] [,2]
# [1,]    1    1
# [2,]    2    2
# [3,]    1    1
# [4,]    2    2

# 把上面兩部合併成一步。
testmatrix[-which(apply(testmatrix,1,function(x)all(is.na(x)))), 
           -which(apply(testmatrix,2,function(x)all(is.na(x))))]
#      [,1] [,2]
# [1,]    1    1
# [2,]    2    2
# [3,]    1    1
# [4,]    2    2


# 範例 ----------------------------------------------------------------------
testmatrix <- matrix(nrow=6, ncol=4)
testmatrix[2:5,2:3] <- seq(2)
testmatrix
testmatrix[4:5,4] <- c(5,5)
#      [,1] [,2] [,3] [,4]
# [1,]   NA   NA   NA   NA
# [2,]   NA    1    1   NA
# [3,]   NA    2    2   NA
# [4,]   NA    1    1    5
# [5,]   NA    2    2    5
# [6,]   NA   NA   NA   NA

testmatrix[-which(apply(testmatrix,1,function(x)all(is.na(x)))), 
           -which(apply(testmatrix,2,function(x)all(is.na(x))))]
#      [,1] [,2] [,3]
# [1,]    1    1   NA
# [2,]    2    2   NA
# [3,]    1    1    5
# [4,]    2    2    5




