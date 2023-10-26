
library(ggplot2)

library(RColorBrewer)
library(rhandsontable)

library(showtext)
showtext_auto() 

# # File with translations
lang <- Translator$new(translation_csvs_path = "./lang/info/")

roseUI <- function(id) {
  ns <- NS(id)
  shiny.i18n::usei18n(lang)
  tagList(
    bs4Dash::tabsetPanel(
      tabPanel(title = 'Data',
               fluidRow(
                 box(title=lang$t("输入数据"),width=9,solidHeader=TRUE,status='primary',background = "white",
                     splitLayout(cellWidths = c("100%"),rHandsontableOutput(ns("mydata") ) ) ) ,
                 box(width=3,status="success",
                     fileInput(ns("file1"), label = lang$t("输入文件"),multiple = FALSE ),
                     h6(lang$t('格式：.csv .xlsx .xls')),
                     actionBttn( inputId = ns("show"), label = "Show Data",
                                 style = "fill", color = "primary", size = "sm" ),
                     hr(),
                     downloadButton(ns("downloadSampleData"), lang$t("参考数据"))
                  )
                )
             ),
      tabPanel(title = 'Plot',
               fluidRow(
                 box(title=lang$t("玫瑰图"),width=9,solidHeader=TRUE,status = "primary",background = "white",
                     splitLayout(cellWidths = c("100%"),plotOutput(ns("plot"),height=500) ) ),
                 box(width=3,status="success",
                     actionBttn( inputId = ns("submit1"), label = "Analyze Data",
                                 style = "fill", color = "primary", size = "sm" ),hr(),
                     
                     fluidRow(
                       column(width = 6,textInput(inputId = ns('title'),label = lang$t('标题'), value = 'rose map' ) ),
                       column(width = 6,selectInput(ns('theme'),lang$t('主题'),selected = 'bw',
                                                    choices =c('void','classic','classic2','cleveland','dark','light', 'get', 'gray','void') )),
                       column(width = 6,selectInput(inputId = ns("label_color"), lang$t("标签颜色"), colors() , selected = "black"   )),
                       column(width = 6,numericInput(inputId = ns('size'),label = lang$t('标签字号'),value = 5     ) ),
                       column(width = 6,selectInput(inputId = ns("low") , lang$t("低值颜色"), colors() , selected = "peachpuff1" ) ),
                       column(width = 6,selectInput(inputId = ns("high"), lang$t("高值颜色"), colors() , selected = "red"   )),
                       column(width = 6,selectInput(inputId = ns("line"), lang$t("界线颜色"), colors() , selected = "white"   ) )
                     ),
                     
                     dropdownButton(circle=FALSE, label=lang$t("下载图形"), status="success",icon = icon("download"),
                                    br(),br() ,
                                    numericInput(inputId = ns('w0'),label = lang$t('下载图宽'),value = 15),
                                    numericInput(inputId = ns('h0'),label = lang$t('下载图高'),value = 15),
                                    numericInput(inputId = ns('ppi0'),label = lang$t('分辨率'),value = 72),
                                    downloadBttn(outputId = ns("pdf0") , label = "PDF" , size='sm', block=TRUE ),
                                    downloadBttn(outputId = ns("png0") , label = "PNG" , size='sm', block=TRUE ),
                                    downloadBttn(outputId = ns("jpeg0"), label = "JPEG", size='sm', block=TRUE ),
                                    downloadBttn(outputId = ns("tiff0"), label = "TIFF", size='sm', block=TRUE )
                                    ) 
                     )
                 )
               )
      )
    ) }

roseServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      observeEvent(input$show, { 
        
        # Load the data
        # 读取数据
        mydata <- reactive({
          file1 <- input$file1
          
          if ( is.null(file1) ){
            mydata <- data.frame(var =c("hsa","mmu","rat",'cat',"dog","pig",'rabbit','monkey') ,
                                 value = c(8,10,6,5,3,4,4,2) ,
                                 label = c(8,10,6,5,3,4,4,'a') )
            
          }
          else{
            d <- tail( unlist(strsplit(file1$datapath,'[.]') ), 1)
            if( d=='csv' ){
              mydata <- data.frame( read.csv(file1$datapath,header=T, stringsAsFactors = FALSE, fileEncoding = 'GB18030') )
            } else{
              mydata <- data.frame( read_excel(file1$datapath,1) )
            } 
          } # else
          
          return( mydata )
        })
        
        
        if(!is.null(mydata()) ){
          output$mydata <- renderRHandsontable(
            rhandsontable( mydata() ,rowHeaderWidth = 50, height = 410) %>% 
              hot_cols(columnSorting = TRUE) %>% 
              hot_col("value",type = 'numeric') %>% 
              hot_col(c("var","label"),type = 'dropdown')
          )
        }
      
        observeEvent(input$submit1, {
          
          if(is.null( input$mydata )){return(NULL)}

          plot <- reactive({      
            
            mydata <- as.data.frame( hot_to_r(input$mydata) )

            n <- which(is.na(mydata$var) )
            if(length(n)>0){ mydata <- mydata[-n,] }
           
            
            mydata <- mydata[order(mydata$value),]
            mydata$var <- factor(mydata$var,levels = mydata$var )
            
            library(ggplot2)
           p <- ggplot(mydata,aes(x=var,y=value,fill= value )) +
              geom_bar(width=1, stat = "identity", 
                       colour=input$line ) + # 分割线颜色
              scale_fill_gradient(low = input$low, high = input$high) + # 填充渐变颜色
              # 数值标签、颜色、字号
              geom_text(aes(y= value , label= label ),
                        color=input$label_color, size= input$size) +
              coord_polar(theta = "x",start=0)
              
            p <- eval( parse( text=paste0("p + theme_",input$theme,"()") ) ) # 主题
              
            p <- p + ggtitle(input$title) +
              theme(plot.title   = element_text(hjust = 0.5,size = 30),
                    axis.text.x  = element_text( size=20, colour="black", angle= 0 ),
                    axis.title   = element_text(size = 25),
                    axis.title.y = element_text(angle = 90, vjust = 0.5),
                    axis.ticks.y = element_blank(),
                    axis.text.y  = element_blank(),
                    panel.border = element_blank()
              )
            
            return( p )
            
          })
          
          output$plot <- renderPlot({
            return( plot() )
          })
          
          # 下载图形
          if(T){
            output$pdf0 <- downloadHandler(
              filename="plot.pdf",
              content = function(file){
                pdf(file,width=input$w0,height=input$h0)
                print( plot() )
                dev.off()
              }
            )
            output$png0 <- downloadHandler(
              filename="plot.png",
              content = function(file){
                png(file,width=input$w0,height=input$h0,units="in",res=input$ppi0)
                print( plot() )
                dev.off()
              }
            )
            output$jpeg0 <- downloadHandler(
              filename="plot.jpeg",
              content = function(file){
                jpeg(file,width=input$w0,height=input$h0,units="in",res=input$ppi0)
                print(plot() )
                dev.off()
              }
            )
            output$tiff0 <- downloadHandler( 
              filename="plot.tiff",
              content = function(file){
                tiff(file,width=input$w0,height=input$h0,units="in",res=input$ppi0)
                print(plot() )
                dev.off()
              }  )
          } # 下载图形
          
          })
        

        }) #  show
      # 2、下载参考数据
      output$downloadSampleData <- downloadHandler(
        
        filename = function() {
          paste('rose.csv')
        },
        content = function(file) {
          mydata <- data.frame(var =c("hsa","mmu","rat",'cat',"dog","pig",'rabbit','monkey'),
                               value = c(8,10,6,5,3,4,4,2) ,
                               label = c(8,10,6,5,3,4,4,2) )
          
          write.csv( mydata , file , row.names = F, fileEncoding = 'GB18030') 
        } ) 
    }
    
  ) }
      


