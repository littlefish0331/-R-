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
#            file236 file443 file556
# ans03num        10      10      10
# ans03ch       1359    1054    1524
# ans03punct     182     116     165
