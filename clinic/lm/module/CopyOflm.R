
library(readxl)
library(rhandsontable)
library(ggpubr)
library(ggplot2)
library(shinycssloaders) # 加载界面
library(showtext) # 解决画图中文乱码
showtext_auto()
library(shinyWidgets)

# # File with translations
lang <- Translator$new(translation_csvs_path = "./lang/info/")

dataUI <- function(id){
  ns <- NS(id)
  tagList(
  fluidRow(
    box(title=lang$t("输入数据"),width=9,solidHeader=TRUE,status='primary',background = "white" ,
        splitLayout(cellWidths = c("60%"), rHandsontableOutput(ns("table") ) ) ),
    box(width = 3,status="success",
        fileInput(ns("file1"), label = lang$t("输入文件"),multiple = FALSE ),
        h6(lang$t('格式：.csv .xlsx .xls')),
        actionBttn( inputId = ns("show"), label = "Show Data", 
                    style = "fill", color = "primary", size = "sm" ),hr(),
        dropdownButton( label = lang$t("参数设置"), circle = FALSE,width = NULL,br(),br(),
                        selectInput(ns("method"), label = lang$t('拟合方式'),selected = 'lm',
                                    choices = c('loess','lm','glm','gam') ),
                        selectInput(ns("plot"), label = lang$t('图形选择'),selected = "sn",choices = c("scatter"="s","fitting"="n", "merge"="sn")  ),
                        textInput(ns("formula"), label = lang$t('拟合方程'),value = "y~x" ),
                        selectInput(ns("se"),  label = lang$t('置信区间'),selected = 'T',choices = c('show'= 'T','hide'= 'F') ),
                        selectInput(ns("cor"), label = lang$t('相关性'),selected = "pearson",
                                    choices = c("pearson"="pearson", "kendall"="kendall", "spearman"="spearman","不计算"= F )
                        ) 
        ),br(),
        downloadButton(ns("downloadtable"),lang$t("参考数据") )  ) )
  )
}

plotUI <- function(id){
  ns <- NS(id)
  tagList(
    
  fluidRow(
    box(title=lang$t("拟合图形"),width=9,solidHeader=TRUE,status='primary',background = "white",
        splitLayout(cellWidths = c("100%"), 
                    shinycssloaders::withSpinner( plotOutput(ns("plot") ) )
                     ) ),
    box(width = 3,status="success",
        actionBttn( inputId = ns("submit"), label = "Analyze Data", 
                    style = "fill", color = "primary", size = "sm" ),hr(),
        selectInput(ns("color"), lang$t("点线颜色"), colors() , multiple = T , selected = c('black','blue','gray60','pink','red') ) ,
        selectInput(ns("fill") , lang$t("填充颜色") , colors() , multiple = T , selected = c('black','blue','gray60','pink','red') ),
        br(),
        dropdownButton( label = lang$t("图形参数"),icon = icon('image'),circle = FALSE,width = NULL,br(),br(),
                        column( width = 12, textInput(ns("title"), label = lang$t('标题'),value = ' Correlation') ),
                        column( width = 12, textInput(ns("group"), label = lang$t('分组'),value = 'group') ),
                        column( width = 12, textInput(ns("xlab"),  label = lang$t('x轴标签'),value = 'xlab') ),
                        column( width = 12, textInput(ns("ylab"),  label = lang$t('y轴标签'),value = 'ylab') ),
                        column( width = 12, selectInput(ns('theme'),lang$t('主题'),selected = 'bw',
                                                        choices =c('bw','classic','classic2',
                                                                   'cleveland','dark','light',
                                                                   'get', 'gray') ) ),
                        column( width = 12, selectInput(ns('face'),label = lang$t('是否分面'),
                                                        choices = c('Yes'=T, "No"=F),selected = T) )
        ),br(),
        dropdownButton(circle=FALSE, label=lang$t("下载图形"), status="success",icon = icon("download"),
                       br(),br() ,
                       numericInput(inputId = ns('w'),label = lang$t('下载图宽'),value = 20),
                       numericInput(inputId = ns('h'),label = lang$t('下载图高'),value = 10),
                       numericInput(inputId = ns('ppi'),label = lang$t('分辨率'),value = 150),
                       downloadBttn(outputId = ns("pdf") , label = "PDF" , size='sm', block=TRUE ),
                       downloadBttn(outputId = ns("png") , label = "PNG" , size='sm', block=TRUE ),
                       downloadBttn(outputId = ns("jpeg"), label = "JPEG", size='sm', block=TRUE ),
                       downloadBttn(outputId = ns("tiff"), label = "TIFF", size='sm', block=TRUE )
        )    )
  ) # fluidRow
  )
}

helpUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(box(width=12,title="使用说明",solidHeader=TRUE,status='primary',background = "white",height="100%",
                 tags$h2("使用说明"),
                 tags$hr(),
                 tags$h6(lang$t("1、参考数据中，列名均为小写，且需要保证一致。
                             x 为小写x，y为小写y，group为小写group，face为小写face。
                             group对应分组，face对应分面，列名不可改变，但对应列内容可自行编辑。")),
                 tags$h6(lang$t("2、R 与 P仅为直线相关性，对应拟合为 lm, y~x ，其他拟合方式的时候，恐不具有代表性。")),
                 tags$h6(lang$t("3、点线、填充颜色的“数量”需不小于 group列的分组数。")),
                 tags$h6(lang$t("4、方程中的x与y的对应关系有:")),
                 tags$h6(lang$t("y ~ x ")),
                 tags$h6(lang$t("y ~ poly(x, n)")),
                 tags$h6(lang$t("y ~ log(x)")),
                 tags$h6(lang$t("等。其中 y ~ poly(x, n) 为多项式关系，n为项数，为1、2、3等整数，
                             如 y ~ poly(x, 2) 表示二项式。"))
                 
    )
    ) )
  
}

lmUI <- function(id) {
  ns <- NS(id)
  tagList(
    bs4Dash::tabsetPanel(
      tabPanel(title = 'Data', dataUI("lm") ),
      tabPanel(title = 'Plot', plotUI("lm") ),
      tabPanel(title = lang$t("使用说明"), helpUI("lm"), icon = ionicon(name="information-circle") )
      )
  ) # NS(id)
} # function(id)

lmServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
     
      # init
      output$plot <- renderPlot({
        NULL
      })
      
      observeEvent(input$show, {

      # 读取文件 file
      df <- reactive({
        
        file1 <- input$file1
        if( is.null(file1) ){
          
          set.seed(1234) # 随机种子
          df <- data.frame( x = rep(1:50,4),  # 创建数据
                            y = (1:200/10 + rnorm(200, mean = 20, sd = 5)/10 )^3  ,
                            group = rep(c("G1", "G2","G3","G4"), each = 50),
                            face = c(rep("F1", each =100),rep( "F2", each = 100) ) )
          
        }
        else if( !is.null(file1) ){
          
          d <- tail( unlist(strsplit(file1$datapath,'[.]') ), 1) # 文件格式 csv xlsx xls
          
          if( d =='csv' ){
            df <- data.frame( read.csv(file1$datapath, fileEncoding = "GB18030") )
          } 
          else{
            df <- data.frame( read_excel(file1$datapath,1) ) 
          } 
        } 
        colnames(df) <-  tolower(colnames(df))
        return(df) # 输出文件
      })

      output$table <- renderRHandsontable(
        rhandsontable(df(), rowHeaderWidth = 22, width = 300, height = 360) %>% 
          hot_cols(columnSorting = TRUE) %>% 
          hot_col(c('x','y'), type = 'numeric' ) %>% 
          hot_col(c('group','face'), type = 'dropdown' )
      )
      
    
      
      observeEvent(input$submit, {

        observeEvent(input$table, {
          # 分析处理 ELISA数据
          
          plot <- reactive({
            
            df <- hot_to_r( input$table )
            df <- as.data.frame( df )
            df <- na.omit(df)
            if(input$plot=='s'){
              p <- ggplot( df, aes(x, y, fill= group, color = group ) ) + 
                geom_point()
            }
            else if(input$plot=='n'){
              
              if(input$method=='gam'){
                
                p <- ggplot( df, aes(x, y, fill= group, color = group ) ) + 
                  geom_smooth( method = input$method, show.legend = F,se = c(input$se=='T') )
                
              }else{
                p <- ggplot( df, aes(x, y, fill= group, color = group ) ) + 
                  geom_smooth( method = input$method, show.legend = F, 
                               formula = input$formula,se = c(input$se=='T') )
              }
              
            }
            else{
              if(input$method=='gam'){
                p <- ggplot( df, aes(x, y, fill= group, color = group ) ) + 
                  geom_point()+
                  geom_smooth( method = input$method, show.legend = F, 
                               se = c(input$se=='T') )
              } else{
                p <- ggplot( df, aes(x, y, fill= group, color = group ) ) + 
                  geom_point()+ 
                  geom_smooth( method = input$method, show.legend = F, 
                               formula = input$formula,se = c(input$se=='T') )
              }
            }
            
            
            
            p <- p +
              ggtitle(input$title)+ xlab(input$xlab) + ylab(input$ylab)  +
              scale_color_manual(name=input$group, values = input$color )+ # 自定义 颜色
              scale_fill_manual( name=input$group, values = input$fill ) # 自定义 填充颜色
            
            if(input$theme=='bw'){
              p <- p + theme_bw()
            }
            else if(input$theme=='classic'){
              p <- p + theme_classic()
            }
            else if(input$theme=='classic2'){
              p <- p + theme_classic2()
            }
            else if(input$theme=='cleveland'){
              p <- p + theme_cleveland()
            }
            else if(input$theme=='dark'){
              p <- p + theme_dark()
            }
            else if(input$theme=='light'){
              p <- p + theme_light()
            }
            else if(input$theme=='get'){
              p <- p + theme_get()
            }
            else if(input$theme=='gray'){
              p <- p + theme_gray()
            }
            
             p <- p+ theme(axis.title.x = element_text(size = 20, color = "black" ),
                    axis.text.x = element_text(size = 12, ),
                    axis.title.y = element_text(size = 20, color = "black"), # y 标签
                    axis.text.y = element_text(size = 12, color = "black" ), # y 坐标刻度
                    legend.title = element_text(size = 15) , # 图例
                    legend.text  = element_text(size = 12) , # 图例
                    plot.title = element_text(hjust = 0.5,size = 30), # 标题居中
                    axis.line = element_line(size = 0.5, colour = "black") # x y 轴
              )

            # 不分面
            if ( input$face== F ) {
              
              # 计算相关性系数 R 与 P
              if(!input$cor== F ){ 
                p <- p +  stat_cor(method = input$cor , size=6,  show.legend = F,
                                   data = df, p.accuracy = 0.001, r.accuracy = 0.01,na.rm = T ) 
              } # else 不计算 
              
            }
            # 分面 
            else if(input$face == T){    
              
              # 计算相关性系数 R 与 P
              if(!input$cor== F ){ 
                
                for (i in 1:length(unique(df$face) ) ) {
                  p <- p + # 自定义 填充颜色
                    stat_cor(method = input$cor , aes(x,y), size=5, show.legend = F,
                             data = subset(df,face== unique(df$face)[i] ),
                             p.accuracy = 0.001, r.accuracy = 0.01 ,na.rm = T)
                }
              } # else 不计算 
              p <- p + facet_wrap("~ face")
              
            }
            
            
            return(p)
          })
          
          
          # 4、拟合图像，网页呈现
          output$plot <-  renderPlot({
            return( plot() )
            
          })
          
          # 下载图形
          if(T){
            output$pdf <- downloadHandler(
              filename="cor.pdf",
              content = function(file){
                pdf(file,width=input$w,height=input$h)
                print( plot() )
                dev.off()
              }
            )
            output$png <- downloadHandler(
              filename="cor.png",
              content = function(file){
                png(file,width=input$w,height=input$h,units="in",res=input$ppi)
                print( plot() )
                dev.off()
              }
            )
            output$jpeg <- downloadHandler(
              filename="test.jpeg",
              content = function(file){
                jpeg(file,width=input$w,height=input$h,units="in",res=input$ppi)
                print( plot() )
                dev.off()
              }
            )
            output$tiff <- downloadHandler( 
              filename="cor.tiff",
              content = function(file){
                tiff(file,width=input$w,height=input$h,units="in",res=input$ppi)
                print( plot() )
                dev.off()
              }
            )
          }
          
          
        }) # observeEvent( input$table )
        
      }) # observeEvent(input$submit )
      
      })
      
      # 下载参考数据
      output$downloadtable <- downloadHandler(
        filename = function() {
          paste('cor.csv')
        },
        content = function(file) {
          
          if(is.null( input$table ) ){
            df <- df()
          }
          else{
            df <- hot_to_r( input$table )
          }
          write.csv(df, file,  row.names = F, fileEncoding = 'GB18030')
        } )
      
    } # function(input, output, session)
  ) # moduleServer
} # function(id)