library(dplyr)
getwd()
setwd("prac_data/")

## 第二題
text_file = list.files(pattern = "file\\d{3}")
File = NULL
for(i in 1:length(text_file)){
  File = c(File, readLines(text_file[i], encoding = "UTF-8") %>% paste0(collapse = ""))
}
str(File) #chr [1:3]
class(File) #[1] "character"

## 第三題
# 如果執行 File[1] 發現有部分資訊沒有顯現出來，有truncate的情形
# 請參考 https://stackoverflow.com/questions/36800475/avoid-string-printed-to-console-getting-truncated-in-rstudio
# paste(1:300, letters, collapse=" ")
# 最後會有... <truncated>
# 請去Tools→Golbal Options→Code→Display
# →Console下的Limit length of line display in console to :0
# 這樣更改即可。

File %>% sapply(function(x) gsub("【\\d{4}.*聯合報.*】", "", x)) %>% 
  as.character() -> File_process
str(File_process) #chr [1:3]
class(File_process) #[1] "character"
# File %>% sapply(function(x) gsub("【\\d{4}.*聯合報.*】", "", x)) -> File_process
# str(File_process) #Named chr [1:3]
# class(File_process) #[1] "character"


## 第四題，刪除上述pattern文字後，剩下的字數統計。
# 中文字數
matches = gregexpr("[\u4E00-\u9FA5]", File_process)
sent <- regmatches(File_process, matches) %>% sapply(function(x) paste0(x, collapse = ""))
nchar(sent)

# 標點符號
matches = gregexpr("[[:punct:]]", File_process)
sent <- regmatches(File_process, matches) %>% sapply(function(x) paste0(x, collapse = ""))
nchar(sent)

# 數字
matches = gregexpr("[[:digit:]]", File_process)
sent <- regmatches(File_process, matches) %>% sapply(function(x) paste0(x, collapse = ""))
nchar(sent)





