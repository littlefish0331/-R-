# 此檔案為shiny的ui.R中
# sidebarLayout下sidebarPanel的各種模板
# 例如：文字、單選、多選、拉條...等
# 參考網站：http://shiny.rstudio.com/gallery/widget-gallery.html
library(shiny)
#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

#Slider range
ui <- fluidPage(
    fluidRow(
        column(4,
               
               # Copy the line below to make a slider bar 
               sliderInput("slider1", label = h3("Slider"), min = 0, 
                           max = 100, value = 50)#value為起始值
        ),
        column(4,
               # column後面第一個參數只能放1~12
               # Copy the line below to make a slider range 
               sliderInput("slider2", label = h3("Slider Range"), min = 0, 
                           max = 100, value = c(40, 60))#value為起始值
        )
    ),
    
    hr(),
    
    fluidRow(
        column(4, verbatimTextOutput("value")),
        column(4, verbatimTextOutput("range")) # verbatimTextOutput會有灰色底的區域。
    )
    
)

server <- function(input, output) {
    # You can access the value of the widget with input$slider1, e.g.
    output$value <- renderPrint({ input$slider1 })
    
    # You can access the values of the second widget with input$slider2, e.g.
    output$range <- renderPrint({ input$slider2 })
}


#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

# Date range
ui <- fluidPage(
    # Copy the line below to make a date range selector
    dateRangeInput("dates", label = h3("Date range")),
    
    hr(),
    fluidRow(column(4, verbatimTextOutput("value")))
)

server <- function(input, output) {
    # You can access the values of the widget (as a vector of Dates)
    # with input$dates, e.g.
    output$value <- renderPrint({ input$dates })
    
}

#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

# Checkbox group 多選方塊
ui <- fluidPage(
    # Copy the chunk below to make a group of checkboxes
    checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                       choices = list("Choice 1" = 100, "Choice 2" = 2, "Choice 3" = 3),
                       selected = 100),
    # select後面要放預設的數值之一，不然出來的畫面會是NULL
    
    hr(),
    fluidRow(column(3, verbatimTextOutput("value")))
)

server <- function(input, output) {
    # You can access the values of the widget (as a vector)
    # with input$checkGroup, e.g.
    output$value <- renderPrint({ input$checkGroup })
    
}



#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

# Radio buttons 單選
ui <- fluidPage(
    # Copy the line below to make a set of radio buttons
    radioButtons("radio", label = h3("Radio buttons"),
                 choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
                 selected = 1),
    
    hr(),
    fluidRow(column(3, verbatimTextOutput("value")))
    
)

server <- function(input, output) {
    # You can access the values of the widget (as a vector)
    # with input$radio, e.g.
    output$value <- renderPrint({ input$radio })
    
}


#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

# Select box 下拉式選單。改multiple參數可以變成是單選或多選
ui <- fluidPage(
    # Copy the line below to make a select box 
    selectInput("select", label = h3("Select box"), 
                choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
                selected = 2, multiple = F),
    
    hr(),
    fluidRow(column(3, verbatimTextOutput("value")))
    
)

server <- function(input, output) {
    # You can access the value of the widget with input$select, e.g.
    output$value <- renderPrint({ input$select })
    
}


#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

# Date input 選取日期
ui <- fluidPage(
    # Copy the line below to make a date selector 
    dateInput("date", label = h3("Date input"), value = "2017-12-25"),
    
    hr(),
    fluidRow(column(3, verbatimTextOutput("value")))
    
)

server <- function(input, output) {
    # You can access the value of the widget with input$date, e.g.
    output$value <- renderPrint({ input$date })
    
}


#####################################
#這邊是執行啦!!!
shinyApp(ui=ui, server=server)

# Numeric input 數字輸入

ui <- fluidPage(
    # Copy the line below to make a number input box into the UI.
    numericInput("num", label = h3("Numeric input"), value = 0, min=23),
    # numericInput(inputId, label, value, min = NA, max = NA, step = NA)
    # step為點選一次所增加的量，乾你老師就是公差啦!!但是第一步會有點怪怪的!!
    hr(),
    fluidRow(column(3, verbatimTextOutput("value")))
    
)

server <- function(input, output) {
    # You can access the value of the widget with input$num, e.g.
    output$value <- renderPrint({ input$num })
    
}





