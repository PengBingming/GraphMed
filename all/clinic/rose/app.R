
library('shiny') 
library('bs4Dash')
library('shinyWidgets')
library('shinycssloaders')
library('shinyFiles')
library('rhandsontable')
library('DT')
library('shinyjs')
library('readxl')

library('ggplot2')     # 画图
library("ggpubr")

library("tidyr")
library("showtext") #中文问题
showtext_auto()

library('waiter')
library('shiny.i18n') # 语言切换
# 
source("./module/rose.R",encoding = "utf-8")
# source("./module/rose.R",encoding = "utf-8")

# File with translations
lang <- Translator$new(translation_csvs_path = "./lang/info/")

lang$set_translation_language("en") # here you select the default translation to display

ui <- bs4DashPage(
  preloader <- list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
  title = "GraphMed",
  fullscreen = T,
  header = bs4DashNavbar(
    shiny.i18n::usei18n(lang),
    column(width = 2, 
           materialSwitch(inputId = "lang",label = lang$t("中文"), 
                          status = "primary",value = F, right = T )
    ),
    title = dashboardBrand(
      title = lang$t("重医儿院"),
      color = "primary",
      href = "https://stu.chcmu.asia",
      image = "./logo_chcmu.png", 
      opacity=1
    ),
    disable = FALSE,
    skin = "light",
    status = "white",
    border = TRUE,
    sidebarIcon = icon("bars"),
    controlbarIcon = icon("table-cells"),
    fixed = FALSE
    # Dropdown menu for notifications
  ),
  ## Sidebar content
  sidebar = bs4DashSidebar(
    skin = "light",
    status = "primary",
    elevation = 3,
    bs4SidebarUserPanel(
      image = "./doupi.jpg", 
      name = "GraphMed"
    ),
    sidebarMenu(id="sidebar",
                sidebarHeader(title = lang$t("医学数据可视化") ),
                # menuItem(lang$t("使用说明"), tabName = "help", icon = ionicon(name="information-circle")),
                menuItem('Rose plot', tabName = "rose", icon = ionicon(name="bed") )
   
    )
  ),
  footer = dashboardFooter(
    left = a(
      href = "https://shiny.chcmu.com.cn/graphmed/",
      target = "_blank", "GraphMed |" ,a(
        href = "https://beian.miit.gov.cn/",
        target = "_blank", "渝ICP备2023006607号"
      ),
    ),
    right = "@2023"   
    
  ),
  controlbar = dashboardControlbar(),
  body  = dashboardBody(
    tabItems(
      tabItem(tabName= "rose",        roseUI("rose"))
    )
  )
)

server <- function(input, output, session) {
  waiter_hide()
  
  observeEvent(input$lang, {
    # observeEvent(input$selected_language, {
    if(input$lang==T){ 
      shiny.i18n::update_lang('cn' )
    }
    else{
      shiny.i18n::update_lang('en' )
    }
    
  })


  roseServer("rose")
  
}

shinyApp(ui, server)

