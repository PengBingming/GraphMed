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

deseq2: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/deseq2")
expr: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/expr")
geneID: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/geneID")

heatmap: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/heatmap")
limma: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/limma")

pca: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/pca")
reps: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/reps")
volcano: runGitHub("GraphMed", "PengBingming", subdir = "rnaseq/volcano")

go: runGitHub("GraphMed", "PengBingming", subdir = "enrich/go")
gseago: runGitHub("GraphMed", "PengBingming", subdir = "enrich/gseago")
gseakegg: runGitHub("GraphMed", "PengBingming", subdir = "enrich/gseakegg")
kegg: runGitHub("GraphMed", "PengBingming", subdir = "enrich/kegg")
ora: runGitHub("GraphMed", "PengBingming", subdir = "enrich/ora")
pathwaybubble: runGitHub("GraphMed", "PengBingming", subdir = "enrich/pathwaybubble")

anova: runGitHub("GraphMed", "PengBingming", subdir = "clinic/anova")
forestplot: runGitHub("GraphMed", "PengBingming", subdir = "clinic/forestplot")
lm: runGitHub("GraphMed", "PengBingming", subdir = "clinic/lm")
logistics: runGitHub("GraphMed", "PengBingming", subdir = "clinic/logistics")
map: runGitHub("GraphMed", "PengBingming", subdir = "clinic/map")
mutliroc: runGitHub("GraphMed", "PengBingming", subdir = "clinic/mutliroc")
provincemap: runGitHub("GraphMed", "PengBingming", subdir = "clinic/provincemap")
rose: runGitHub("GraphMed", "PengBingming", subdir = "clinic/rose")
surv: runGitHub("GraphMed", "PengBingming", subdir = "clinic/surv")
worldmap: runGitHub("GraphMed", "PengBingming", subdir = "clinic/worldmap")

ggbarplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggbarplot")
ggboxplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggboxplot")
ggdensity: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggdensity")
ggggdotplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggdotplot")
gghistogram: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/gghistogram")
ggggmerge: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggggmerge")
ggggscatter: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggscatter")
ggggviolin: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggviolin")
ggplot: runGitHub("GraphMed", "PengBingming", subdir = "ggplot2/ggplot")

elisa: runGitHub("GraphMed", "PengBingming", subdir = "lab/elisa")
qpcr: runGitHub("GraphMed", "PengBingming", subdir = "lab/qpcr")
