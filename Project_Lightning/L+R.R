getwd()
setwd("D:/NCCU/R_Study_Group/Project_Lightning/data/")

CG <- read.csv(file = "CSV/201612_CG.csv", header = T)

######################
library(ggmap)
library(mapproj)

map <- get_map(location = c(lat=25.044955, lon=121.335579 ), source = "stamen",
               zoom = 10, language = "zh-TW", maptype = "toner-lite")
ggmap(map, darken = c(0.2, "white"))+ 
    geom_point(aes(x = long, y = lat, size=kA), data = CG, color="red")


#目標：
#SHP FILE
#各種學長姊的畫圖
#R翻轉
#R另一個學習包
#一年的雷擊在地圖上顯示
#和雨量做疊圖

#sp包的over跟overlay函数
#https://cran.r-project.org/web/packages/sp/sp.pdf
#https://cran.r-project.org/web/packages/sp/vignettes/over.pdf
#http://chienhung0304.blogspot.tw/2015/12/r-twd97opendata.html
#https://blog.gtwang.org/r/r-leaflet-interactive-map-package-tutorial/2/
#https://blog.gtwang.org/r/r-ggmap-package-spatial-data-visualization/2/  
#https://www.ptt.cc/bbs/Statistics/M.1277714037.A.2CC.html
#http://pcchuang.pixnet.net/blog/post/172204407-%5Br%5D-ggmap-%E8%88%87-googlevis-%E6%96%BC%E7%B9%AA%E8%A3%BD%E5%9C%B0%E5%9C%96%E5%8A%9F%E8%83%BD%E4%B9%8B%E6%AF%94%E8%BC%83

