
runExample("05_sliders")

####shiny套件所提供的Example
runExample("01_hello")



runExample("02_text") # 資料表格
runExample("03_reactivity") # 回應設計 + 資料表格
runExample("04_mpg") # 繪圖
runExample("05_sliders") # 側欄工具 + 表格
runExample("06_tabsets") # tab 頁面
runExample("07_widgets") # 行為按鈕
runExample("08_html") # 結合 html
runExample("09_upload") # 上傳檔案工具
runExample("10_download") # 下載檔案工具
runExample("11_timer") # 計時器


#####################################
# Shiny也提供網頁模版供開發者使用。
# Example("01_hello")例子中的圖使用的模版為pageWithSidebar，將網頁切割為以下三個部份： 
# - 標題，也就是 Hello Shiny! 
# - 控制面板(輸入)，左上角的灰色區塊 
# - 顯示面板(輸出)，右半邊的圖片

#####################################
# 最基本的 Shiny 專案包含了兩個部份
# ui.R — 前端程式碼，描述我們的專案網頁要怎樣呈現與排版，負責告訴 Shiny 我們的網頁前端要長什麼樣子。
# server.R — 後端程式碼，負責分析、計算與繪製圖表，並將結果傳遞給前端

ui <- fluidPage(
    titlePanel("titlePanel只能放一個"),
    titlePanel("大家好"),
    titlePanel("大家好"),
    navlistPanel("navlistPanel","導覽面01","導覽面板02"),
    tabPanel("tabPanel","頁籤面板01","頁籤面板02")
)
# sidebarLayout — 將頁面切成兩塊，包含 主內容 與 sidebar
# sidebarPanel — 在 sidebar 內使用的面版
# mainPanel — 主要呈現資料的面版
# navlistPanel — 導覽面板。
# tabPanel — 頁籤面板


#####################################
#以下是Example("01_hello")的ui.R
#直接看範例請執行runExample("01_hello")
#使用的模版為pageWithSidebar
# Define UI for application that plots random distributions 
ui <- pageWithSidebar(
    
    # Application title
    headerPanel("Hello Shiny!"),
    
    # Sidebar with a slider input for number of observations
    sidebarPanel(
        sliderInput("obs", 
                    "Number of observations:", 
                    min = 1,
                    max = 1000, 
                    value = 500)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("distPlot")
    )
)

#以下是Example("01_hello")的server.R
server <- function(input, output) {
    
    # Expression that generates a plot of the distribution. The expression
    # is wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should be automatically 
    #     re-executed when inputs change
    #  2) Its output type is a plot 
    #
    output$distPlot <- renderPlot({
        
        # generate an rnorm distribution and plot it
        dist <- rnorm(input$obs)
        hist(dist)
    })
}


#####################################
ui <- fluidPage(
    titlePanel("大家好"),
    sidebarLayout(
        sidebarPanel(
            radioButtons("radio", label = "Choices", choices = list("Choice 1" = 1, "Choice 2" = 2)),
            sliderInput("slider1", label = "Slider", min = 0, max = 100, value = 50)
        ),
        mainPanel("逮給厚，哇喜逮頑歐郎",plotOutput("distPlot"))
    )
)
# 使用的模版為fluidPage
# 使用 titlePanel 設定標題
# sidebarLayout 將畫面左右切分
# sidebarPanel 設定左方的面板，內含 Radio 與 Slider 控制項
# mainPanel 裡面只寫上「逮給厚，哇喜逮頑歐郎」等字。
# 如果有多個要顯示在mainPanel，要加在()裡面，不能寫兩個mainPanel

# 在 Shiny UI 的部份，它仍提供了一些
# 像是「h1」、「br」等常見的 HTML 對應元素，
# 但這個主要是為了提高 Shiny UI 的彈性；
# 大部份時候我們其實是可以直接利用現成模版快速兜出一個互動圖表的。

server <- function(input, output) {
    output$distPlot <- renderPlot({
        x <- faithful[, 2] # Old Faithful Geyser data
        # 不會與ui.R的程式碼互動，是固定的參數!!
        # bins <- seq(min(x), max(x), length.out = 10)
        # 與ui.R的程式碼互動方式
        bins <- seq(min(x), max(x), length.out = input$slider1 + 1)
        hist(x, breaks = bins, col = 'blue', border = 'white')
    })
}
# 將 R 內建的「老實忠泉」資料利用「hist」函式製作直方圖，
# 並透過 Shiny 的「renderPlot」函式將圖表回存至 「output$distPlot」 之中，
# 而這個 output$distPlot 便能在 ui.R 之中利用 plotOutput(“distPlot”) 取得。

# Shiny 本身並不包含圖表生成；
# 上例的直方圖函式「hist」為 R 的內建函式，
# 如果我們要製作其它不同類型的圖表，
# 可以搭配其它套件如「ggplot2」、「quantom」等，
# 這也大大的提升了 Shiny 的可用性，
# 而不會受限於單一套件所支援的圖表類型。



#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)


#Shiny缺點
# 需要更複雜客製化的時候， R 語言包裝的 HTML 會是場災難。
# 無法更即時的互動。圖片永遠由 server 端重新計算後產生。
# 視覺呈現受制於 R 套件，仍無法利用 D3.js 等更強大的視覺函式庫。





