# GraphMed
A Shiny Web Application to Analyze and Visualize Medical Data

R shiny;

1. This application is free at website: https://shiny.chcmu.com.cn/graphmed/  
2. The main panel scripts are saved on   GraphMed/graphmed/
<img src="https://github.com/PengBingming/GraphMed/blob/main/graphmed/www/cover.jpg" width="50%">

3. All shiny tools are categorized into 3 components: Basic graphic, Clinic & Lab. tools and Omics data visualization. It's panel scripts are saved on ggplot2, clinic, lab, rnaseq and enrich.  
<img src="https://github.com/PengBingming/GraphMed/blob/main/graphmed/www/tools.jpg" width="50%">  

4. Mutil-language file is placed in the tool.path/lang/info/ directory.  
5. Demo data for each visualization function (files are placed in the tool.path/www/ directory).  
deseq2/exp.csv and group.csv for DESeq2  
heatmap/heatmap.csv for heatmap  
......

If you were ready for needed packages, You may now run each shiny app with just one command in R:

download the GraphMed files from github  
library("shiny")  
runApp("...path/app")

or  

library(shiny)

1、RNA-seq: 
>deseq2: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/deseq2")  
limma: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/limma")  
heatmap: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/heatmap")  
pca: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/pca")  
reps: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/reps")  
expr: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/expr")  
geneID: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/geneID")  
volcano: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/volcano")  

2、Enrichment
>kegg: runGitHub("GraphMed", "PengBingming", subdir = "enrich/kegg")  
gseakegg: runGitHub("GraphMed", "PengBingming", subdir = "enrich/gseakegg")  
go: runGitHub("GraphMed", "PengBingming", subdir = "enrich/go")  
gseago: runGitHub("GraphMed", "PengBingming", subdir = "enrich/gseago")  
ora: runGitHub("GraphMed", "PengBingming", subdir = "enrich/ora")  
pathwaybubble: runGitHub("GraphMed", "PengBingming", subdir = "enrich/pathwaybubble")  

3、Clinic
>anova: runGitHub("GraphMed", "PengBingming", subdir = "clinic/anova")  
lm: runGitHub("GraphMed", "PengBingming", subdir = "clinic/lm")  
logistics: runGitHub("GraphMed", "PengBingming", subdir = "clinic/logistics")  
forestplot: runGitHub("GraphMed", "PengBingming", subdir = "clinic/forestplot")  
mutliroc: runGitHub("GraphMed", "PengBingming", subdir = "clinic/mutliroc")  
surv: runGitHub("GraphMed", "PengBingming", subdir = "clinic/surv")  
rose: runGitHub("GraphMed", "PengBingming", subdir = "clinic/rose")  
map: runGitHub("GraphMed", "PengBingming", subdir = "clinic/map")  
provincemap: runGitHub("GraphMed", "PengBingming", subdir = "clinic/provincemap")  
worldmap: runGitHub("GraphMed", "PengBingming", subdir = "clinic/worldmap")  

4、Basic plot
>ggbarplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggbarplot")  
ggboxplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggboxplot")  
ggdensity: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggdensity")  
ggggdotplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggdotplot")  
gghistogram: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/gghistogram")  
ggggmerge: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggggmerge")  
ggggscatter: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggscatter")  
ggggviolin: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggviolin")  
ggplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggplot")  

5、Lab. tools
>elisa: runGitHub("GraphMed", "PengBingming", subdir = "lab/elisa")  
qpcr: runGitHub("GraphMed", "PengBingming", subdir = "lab/qpcr")  
