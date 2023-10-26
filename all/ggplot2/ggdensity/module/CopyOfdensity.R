
library('ggplot2')
library("ggsci")
library('ggpubr')

color_type <- c("npg","aaas","nejm","gsea","lancet", "rickandmorty","futurama", "tron",
                "startrek",  "uchicago","igv","locuszoom","d3", "ucscgb","jco","jama" )

theme_select <- c('bw','classic','classic','linedraw','cleveland','dark','grey','gray','get',
                  'light','replace','minimal','pubclean','void','test','update','transparent')

# File with translations
lang <- Translator$new(translation_csvs_path = "./lang/info/")

densityUI <- function(id) {
  ns <- NS(id)
  shiny.i18n::usei18n(lang)
  bs4Dash::tabsetPanel(
    tabPanel(title = 'Data',
             fluidRow(
               box(title=lang$t("输入数据"),width=9,solidHeader=TRUE,status='primary',background = "white",
                   splitLayout(cellWidths = c("100%"), rHandsontableOutput(ns("table") ) ) ),
               box(width = 3,status="success",
                   fileInput(ns("file1"), label = lang$t("输入文件"),multiple = FALSE ),
                   h6(lang$t('格式：.csv .xlsx .xls')),
                   actionBttn( inputId = ns("show"), label = "Show Data",
                               style = "fill", color = "primary", size = "sm" ),
                   hr(),
                   column(width = 12, selectInput(ns('factor'), lang$t("分类变量"), c("") ,multiple = T )),
                   column(width = 12, selectInput(ns('numeric'), lang$t("连续变量"), c(""),multiple = T )),
                   hr(),
                   downloadButton(ns("downloadSampleData"),lang$t("参考数据"))
                   
               )
             )
    ),
    tabPanel(title = 'Plot',
             fluidRow(
               box(title=lang$t("图形"),width=9,solidHeader=TRUE,status = "primary",background = "white",
                   splitLayout(cellWidths = c("100%"),plotOutput(ns("plot"),height = 600 ) ) ),
               box(width=3,status="success",
                   actionBttn( inputId = ns("submit"), label = lang$t("开始画图"),
                               style = "fill", color = "primary", size = "sm" ),hr(),
                   dropdownButton(circle=FALSE, label=lang$t('参数设置'), br(),br(),
                                  fluidRow(
                                    column(width = 6,selectInput(ns("x"), 'x', c("") ) ),
                                    column(width = 6,selectInput(ns("y"), 'y', c("") ) ),
                                    column(width = 6,selectInput(ns("color"), 'color', c("") )),
                                    column(width = 6,selectInput(ns("color_type"), 'color_type', color_type ) ),
                                    column(width = 6,selectInput(ns("fill"), 'fill', c("") ) ),
                                    column(width = 6,selectInput(ns("fill_type"), 'fill_type', color_type) ),
                                    column(width = 6,selectInput(ns('theme'),lang$t('主题'),selected = 'bw',choices = theme_select ))
                                    
                                  )
                   ),br(),
                   selectInput(ns("plotType"),  lang$t('图形选择'),selected = "density",
                               c("density"),multiple = T ),
                   
                   # density
                   if(T){
                     conditionalPanel(
                       condition = "input.plotType.includes('density')",ns = NS(id),
                       dropdownButton(circle=FALSE, label='density', br(),br(),
                                      fluidRow(
                                        # column(width = 6,selectInput(ns("x_density"), 'x', c("") ) ),
                                        # column(width = 6,selectInput(ns("color_density"), 'color', c("") ) ),
                                        # column(width = 6,selectInput(ns("fill_density"), 'fill', c("") ) ),
                                        column(width = 6,numericInput(ns("alpha_density"), 'alpha', value = 0.5 )),
                                        column(width = 6,numericInput(ns("adjust_density"), 'adjust', value = 0.5 )),
                                        column(width = 6,numericInput(ns("lwd_density"), 'lwd', value = 0.5 )),
                                        column(width = 6,numericInput(ns("size_density"), 'size', value = 1 )),
                                        column(width = 6,numericInput(ns("linetype_density"), 'linetype',value = 21)),
                                        column(width = 6,numericInput(ns("linewidth_density"), 'linewidth',value =1)),
                                        column(width = 6,selectInput(ns("show.legend_density"), 'show.legend', 
                                                                     c("T","F"),selected = 'T'  ) ),
                                        column(width = 6,numericInput(ns("weight_density"), 'weight',value =0.2))
                                      )
                                      
                       ) , br() ) }, 
                   
                   selectInput(ns("plotlabel"),  lang$t('图形标签'),selected = "title",multiple = T,
                               c("title","axis.title","axis.text","axis.ticks","legend.title","legend.text") ),
                   # title
                   if(T){
                     conditionalPanel(
                       condition = "input.plotlabel.includes('title')",ns = NS(id),
                       dropdownButton(circle=FALSE, label="title", br(),br(),
                                      fluidRow(
                                        column(width = 6,textInput(ns('title'), "title", value = "" )),
                                        column(width = 6,numericInput(ns('size_title'),  'size', value = 30 )),
                                        column(width = 6,selectInput(ns('color_title'),  "color",choices = colors(), selected = "black" )),
                                        column(width = 6,numericInput(ns('hjust_title'), "hjust",value = 0.5 )),
                                        column(width = 6,numericInput(ns('vjust_title'), 'vjust', value = 0 )),
                                        column(width = 6,numericInput(ns('angle_title'), 'angle', value = 0 ))
                                      )
                       ),br()  ) },
                   # axis.title
                   if(T){
                     conditionalPanel(
                       condition = "input.plotlabel.includes('axis.title')",ns = NS(id),
                       dropdownButton(circle=FALSE, label="axis.title", br(),br(),
                                      fluidRow(
                                        column(width = 6,textInput(ns('x.axis.title'), "x.title", value = "" )),
                                        column(width = 6,textInput(ns('y.axis.title'), "y.title", value = "" )),
                                        column(width = 6,numericInput(ns('size_axis.title'), 'size', value = 20 )),
                                        column(width = 6,selectInput(ns('color_axis.title'), "color",choices = colors(),  selected = "black" )),
                                        column(width = 6,numericInput(ns('hjust_axis.title'),"hjust",value = 0.5 )),
                                        column(width = 6,numericInput(ns('vjust_axis.title'), 'vjust', value = 0 )),
                                        column(width = 6,numericInput(ns('angle_axis.title'), 'angle', value = 0 ))
                                      )
                       ),br() ) },
                   # axis.text
                   if(T){
                     conditionalPanel(
                       condition = "input.plotlabel.includes('axis.text')",ns = NS(id),
                       dropdownButton(circle=FALSE, label="axis.text", br(),br(),
                                      fluidRow(
                                        column(width = 6,numericInput(ns('size_axis.text'), 'size', value = 20 )),
                                        column(width = 6,selectInput(ns('color_axis.text'), "color",choices = colors(), selected = "black" )),
                                        column(width = 6,numericInput(ns('hjust_axis.text'),"hjust",value = 0 )),
                                        column(width = 6,numericInput(ns('vjust_axis.text'), 'vjust', value = 0 )),
                                        column(width = 6,numericInput(ns('angle_axis.text'), 'angle', value = 0 ))
                                      )
                       ) ,br() ) },
                   # axis.ticks
                   if(T){
                     conditionalPanel(
                       condition = "input.plotlabel.includes('axis.ticks')",ns = NS(id),
                       dropdownButton(circle=FALSE, label="axis.ticks", br(),br(),
                                      fluidRow(
                                        column(width = 6,numericInput(ns('size_axis.ticks'), 'size', value = 0.5 )),
                                        column(width = 6,selectInput(ns('color_axis.ticks'), "color",choices = colors(), selected = "black" ))
                                      )
                       ) ,br() ) },
                   # legend.title
                   if(T){
                     conditionalPanel(
                       condition = "input.plotlabel.includes('legend.title')",ns = NS(id),
                       dropdownButton(circle=FALSE, label="legend.title", br(),br(),
                                      fluidRow(
                                        column(width = 6,numericInput(ns('size_legend.title'), 'size', value = 20 )),
                                        column(width = 6,selectInput(ns('color_legend.title'), "color",choices = colors(),  selected = "black" )),
                                        column(width = 6,numericInput(ns('hjust_legend.title'),"hjust",value = 0 )),
                                        column(width = 6,numericInput(ns('vjust_legend.title'), 'vjust', value = 0 )),
                                        column(width = 6,numericInput(ns('angle_legend.title'), 'angle', value = 0 ))
                                      )
                       ),br() ) },
                   # legend.text
                   if(T){
                     conditionalPanel(
                       condition = "input.plotlabel.includes('legend.text')",ns = NS(id),
                       dropdownButton(circle=FALSE, label="legend.text", br(),br(),
                                      fluidRow(
                                        column(width = 6,numericInput(ns('size_legend.text'), 'size', value = 20 )),
                                        column(width = 6,selectInput(ns('color_legend.text'), "color",choices = colors(),  selected = "black")),
                                        column(width = 6,numericInput(ns('hjust_legend.text'),"hjust",value = 0 )),
                                        column(width = 6,numericInput(ns('vjust_legend.text'), 'vjust', value = 0 )),
                                        column(width = 6,numericInput(ns('angle_legend.text'), 'angle', value = 0 ))
                                      )
                       ) ,br() ) },
                   
                   hr(),
                   dropdownButton(circle=FALSE, label=lang$t("下载图形"), status="success",icon = icon("download"),
                                  br(),br() ,
                                  numericInput(inputId = ns('w0'),label = lang$t('下载图宽'),value = 15),
                                  numericInput(inputId = ns('h0'),label = lang$t('下载图高'),value = 15),
                                  numericInput(inputId = ns('ppi0'),label = lang$t('分辨率'),value = 72),
                                  downloadBttn(outputId = ns("pdf0") , label = "PDF" , size='sm', block=TRUE ),
                                  downloadBttn(outputId = ns("png0") , label = "PNG" , size='sm', block=TRUE ),
                                  downloadBttn(outputId = ns("jpeg0"), label = "JPEG", size='sm', block=TRUE ),
                                  downloadBttn(outputId = ns("tiff0"), label = "TIFF", size='sm', block=TRUE ),
                                  downloadBttn(outputId = ns("rds0"),  label = "RDS",  size='sm', block=TRUE )
                   )
               )
             ) )
  ) }


densityServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      observeEvent(input$show, { 
        
        # Load the data # 读取数据
        df <- reactive({
          file1 <- input$file1
          if ( is.null(file1) ){
            df <- mtcars[,c("cyl","mpg","disp","wt") ]
            colnames(df)[1] <- 'group'
            
          } 
          else{
            d <- tail( unlist(strsplit(file1$datapath,'[.]') ), 1)
            if( d=='csv' ){
              df <- data.frame( read.csv(file1$datapath,header=T, stringsAsFactors = FALSE, fileEncoding = 'GB18030') )
            } else{
              df <- data.frame( read_excel(file1$datapath,1) )
            } 
          } # else
          return( df )
        })
        
        # 输入数据
        if(!is.null(df() ) ){
          output$table <- renderRHandsontable(
            rhandsontable(df(),rowHeaderWidth = 100,  height = 400) %>% 
              hot_cols(columnSorting = TRUE)
          )
        }
        
        observe({
          if(!is.null(input$table ) ){
            df <- as.data.frame(hot_to_r( input$table ) )
            
            # ggplot() 参数
            updateSelectInput(session, 'factor',lang$t("分类变量"), choices = colnames(df) ,
                              selected = colnames(df)[1] )
            updateSelectInput(session,"numeric", lang$t("连续变量") , choices = colnames(df) ,
                              selected = colnames(df)[2] )
            
            updateSelectInput(session, "x", label = 'x', choices = colnames(df) ,
                              selected = colnames(df)[2]  )
            updateSelectInput(session, "y", label = 'y', choices = colnames(df) ,
                              selected = ''  )
            updateSelectInput(session, "color", label = 'color', choices = colnames(df) ,
                              selected = colnames(df)[1]   )
            updateSelectInput(session, "fill", label = 'fill', choices = colnames(df) ,
                              selected = ''  )
            
            # 各种图形参数
            observe({
              
              if(length(input$numeric)>1){
                df[,input$numeric] <- apply(df[,input$numeric],2,as.numeric)
              }
              else if(length(input$numeric)==1){
                df[,input$numeric] <- as.numeric(df[,input$numeric])
              }
              
              if(length(input$factor)>1){
                df[,input$factor] <- apply(df[,input$factor],2,as.factor)
              }
              else if(length(input$factor)==1){
                df[,input$factor] <- as.factor(df[,input$factor])
              }
              
              
              
              observeEvent(input$submit, {
                
                plot <- reactive({
                  
                  if( 'density' %in% input$plotType ){
                    if(!input$x==''){
                      
                      expr <- paste0("ggplot(df,aes(x =", input$x,
                                     # ", y =", input$y ,
                                     ", group =", input$group, 
                                     ",color=",input$color,
                                     ",fill=",input$fill,")",
                                     " )")
                      
                      p <- eval( parse(text =expr ) )
                      
                      density <- paste0("geom_density(mapping = aes(x=",input$x,
                                        ",color=",input$color_density,
                                        ",fill=",input$fill_density,")",
                                        ",show.legend=",input$show.legend_density,
                                        ",alpha=",input$alpha_density,
                                        ",size=",input$size_density,
                                        ",adjust=",input$adjust_density,
                                        ",lwd=",input$lwd_density,
                                        ",linetype=",input$linetype_density,
                                        ",linewidth=",input$linewidth_density,
                                        ",weight=",input$weight_density,
                                        " )") 
                      p <- p+eval(parse(text = density ))
                    }
                    else if(input$x==''|!input$y==''){
                      expr <- paste0("ggplot(df,aes(y =", input$y,
                                     # ", x =", input$x ,
                                     ", group =", input$group, 
                                     ",color=",input$color,
                                     ",fill=",input$fill,")",
                                     " )")
                      
                      p <- eval( parse(text =expr ) )
                      
                      density <- paste0("geom_density(mapping = aes(y=",input$y,
                                        ",color=",input$color_density,
                                        ",fill=",input$fill_density,")",
                                        ",show.legend=",input$show.legend_density,
                                        ",alpha=",input$alpha_density,
                                        ",size=",input$size_density,
                                        ",adjust=",input$adjust_density,
                                        ",lwd=",input$lwd_density,
                                        ",linetype=",input$linetype_density,
                                        ",linewidth=",input$linewidth_density,
                                        ",weight=",input$weight_density,
                                        " )") 
                      p <- p+eval(parse(text = density ))
                    }
                    
                  }
                  
                  p <- p + eval(parse(text = paste0("theme_",input$theme,"()")))
                  
                  if(!input$title==''){
                    p <- p + ggtitle( input$title )
                  }
                  if(!input$x.axis.title==''){
                    p <- p + xlab( input$x.axis.title )
                  }
                  if(!input$y.axis.title==''){
                    p <- p + ylab( input$y.axis.title )
                  }
                  
                  p <- p +
                    theme(
                      plot.title   = element_text(size  = input$size_title,
                                                  hjust = input$hjust_title,
                                                  color = input$color_title,
                                                  vjust = input$vjust_title,
                                                  angle = input$angle_title
                      ),
                      axis.title   = element_text(size  = input$size_axis.title,
                                                  color = input$color_axis.title,
                                                  hjust = input$hjust_axis.title,
                                                  vjust = input$vjust_axis.title,
                                                  angle = input$angle_axis.title
                      ),
                      axis.text    = element_text(size  = input$size_axis.text,
                                                  color = input$color_axis.text,
                                                  hjust = input$hjust_axis.text,
                                                  vjust = input$vjust_axis.text,
                                                  angle = input$angle_axis.text
                      ),
                      axis.ticks   = element_line(size  = input$size_axis.ticks,
                                                  color = input$color_axis.ticks
                      ),
                      legend.title = element_text(size  = input$size_legend.title,
                                                  hjust = input$hjust_legend.title,
                                                  color = input$color_legend.title,
                                                  vjust = input$vjust_legend.title,
                                                  angle = input$angle_legend.title
                      ),
                      legend.text  = element_text(size  = input$size_legend.text,
                                                  hjust = input$hjust_legend.text,
                                                  color = input$color_legend.text,
                                                  vjust = input$vjust_legend.text,
                                                  angle = input$angle_legend.text
                      )
                      
                    )
                  
                  # 配色
                  p <- p + eval(parse(text = paste0("scale_color_",input$color_type,"()")))
                  p <- p + eval(parse(text = paste0("scale_fill_",input$fill_type,"()")))
                  
                  return(p)
                  
                })
                
                output$plot <- renderPlot({return( plot() ) })
                
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
                  output$rds0 <- downloadHandler( 
                    filename="plot.RDS",
                    content = function(file){
                      saveRDS( plot() ,file)
                    }  )
                  
                } # 下载图形
                
              } )
              
            }) # obersve
            
          }
          
        } ) # obersve
        
      })
      
      output$downloadSampleData <- downloadHandler(
        filename = function() {
          paste('sample.csv')
        } ,
        content = function(file) {
          dat <- mtcars[,c("cyl","mpg","disp","wt") ]
          colnames(dat)[1] <- 'group'
          write.csv(dat , file, row.names = F, fileEncoding = "GB18030")
        } )
      
    } ) }