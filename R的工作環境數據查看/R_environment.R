# 參考資料：
# https://brucezhaor.github.io/blog/2015/12/02/first-blog/

# 查看系統的資訊 ---------------------------------------------------------------
# 
# 時區
Sys.timezone()
# [1] "Asia/Taipei"


sessionInfo()
# R version 3.4.2 (2017-09-28)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows >= 8 x64 (build 9200)
# 
# Matrix products: default
# 
# locale:
# [1] LC_COLLATE=Chinese (Traditional)_Taiwan.950  LC_CTYPE=Chinese (Traditional)_Taiwan.950   
# [3] LC_MONETARY=Chinese (Traditional)_Taiwan.950 LC_NUMERIC=C                                
# [5] LC_TIME=Chinese (Traditional)_Taiwan.950    
# 
# attached base packages:
# [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
# [1] lubridate_1.7.1
# 
# loaded via a namespace (and not attached):
# [1] compiler_3.4.2 magrittr_1.5   tools_3.4.2    Rcpp_0.12.13   stringi_1.1.5  stringr_1.2.0 
# 

devtools::session_info()
# Session info --------------------------------------------------------------------------------------
# setting  value                           
# version  R version 3.4.2 (2017-09-28)    
# system   x86_64, mingw32                 
# ui       RStudio (1.0.136)               
# language (EN)                            
# collate  Chinese (Traditional)_Taiwan.950
# tz       Asia/Taipei                     
# date     2018-01-07                      
# 
# Packages(有啟動的) ------------------------------------------------------------------------------------------
# package   * version    date       source                          
# base      * 3.4.2      2017-09-28 local                           
# compiler    3.4.2      2017-09-28 local                           
# datasets  * 3.4.2      2017-09-28 local                           
# devtools    1.13.3     2017-08-02 CRAN (R 3.4.2)                  
# digest      0.6.12     2017-01-27 CRAN (R 3.4.2)                  
# graphics  * 3.4.2      2017-09-28 local                           
# grDevices * 3.4.2      2017-09-28 local                           
# lubridate * 1.7.1      2017-11-03 CRAN (R 3.4.3)                  
# magrittr    1.5        2014-11-22 CRAN (R 3.4.2)                  
# memoise     1.1.0      2017-04-21 CRAN (R 3.4.2)                  
# methods   * 3.4.2      2017-09-28 local                           
# Rcpp        0.12.13    2017-09-28 CRAN (R 3.4.2)                  
# stats     * 3.4.2      2017-09-28 local                           
# stringi     1.1.5      2017-04-07 CRAN (R 3.4.1)                  
# stringr     1.2.0      2017-02-18 CRAN (R 3.4.2)                  
# tools       3.4.2      2017-09-28 local                           
# utils     * 3.4.2      2017-09-28 local                           
# withr       2.1.0.9000 2017-11-05 Github (jimhester/withr@a9ebeb3)



# 如何永久性更改工作環境 -------------------------------------------------------------
# 設置R中的時區，以及讓R每次打開都自動配置好工作環境
# 
# Sys.setenv(TZ="Asia/Taipei")
# 上面的命名只是一次性的，
# 當你關掉R再打開，輸入Sys.timezone()又是Asia/Taipei，
# 非常討厭 ~~所以一勞永逸的方法是：
# 
# 在R.home裡面找到Rprofile檔，在裡面加入命名就行了，
# 以後每一次打開首先運行裡面的代碼~
# R.3.2.2\etc\Rprofile.site 加入 Sys.setenv(TZ="Asia/Shanghai")






# R內設置的顏色名稱 ---------------------------------------------------------------
"C:/Program Files/R/R-3.4.2/etc/rgb.txt"
# 按住alt + 滑鼠左鍵點擊上面的檔案地址，就可以開啟txt檔了!!








