# # File with translations
lang <- Translator$new(translation_csvs_path = "./lang/info/")

contactUI <- function(id) {
  ns <- NS(id)
  shiny.i18n::usei18n(lang)
fluidRow(box(width=12,
             title="联系我们",solidHeader=TRUE,status='primary',background = "white",height=800,
             tags$h3("重庆医科大学附属儿童医院呼吸病学研究室(非官方)"),
             tags$a(href="http://stu.chcmu.asia", "Laboratory of Pediatric Respiratory Medicine,
                           Children's Hospital of Chongqing Medical University"),
             tags$hr(),
             tags$p("重庆医科大学附属儿童医院呼吸专业成立于80年代初，
                    1992年获重庆市儿童哮喘防治中心，
                    2005年成立重庆医科大学小儿过敏性疾病诊疗中心，
                    2007年成立重庆医科大学附属儿童医院呼吸中心，
                    2008年获重庆市医学专业重点学科，2011年获得卫生部临床重点专科。
                    目前正致力于建设成为西部一流、国内领先的小儿呼吸系统疾病
                    诊断、治疗、研究与培训中心。（官网摘抄！）"),
             tags$hr(),
             tags$a(href="https://shiny.chcmu.com.cn/graphmed","GraphMed"),
             tags$p("GraphMed 是由重医儿院研究生 彭炳明 同学编写的一个数据分析及可视化的网页工具，
                    旨在提供简便易用、实用性高的数据分析与可视化服务，降低相关技能学习成本，
                    使得研究人员可将精力集中于“科学问题”而非“技能学习”，帮助其更加便捷、快速地处理数据。
                    感兴趣者通过邮箱 2020111042@stu.cqmu.edu.cn 联系。")
)
)
}

faqUI <-  function(id) {
  ns <- NS(id)
fluidRow(box(width=12,
             title="常见问题",solidHeader=TRUE,status='primary',background = "white",height=800,
             tags$h2("常见问题"),
             tags$hr(),
             tags$p("1. 上传格式报错")
             
)
)

}

helpUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(box(width=12,title="使用说明",solidHeader=TRUE,status='primary',background = "white",height="100%",
                 tags$h2("使用说明"),
                 tags$hr(),
                 tags$h6(lang$t("1、下载参考数据或点击运行可查看参考数据。")),
                 tags$h6(lang$t("2、ID 列为基因名 ，不要改变列名“ID”。")),
                 tags$h6(lang$t("3、去重复的方法有取平均、最大值行和最小值行，可自行选择。"))

                 
    )
    ) )
  
}


