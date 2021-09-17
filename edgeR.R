library("edgeR")
library("R.utils")
library("tcpl")

#read in arguments (i.e. parse input)###########################################
args = commandArgs(trailingOnly=TRUE)

ft_count_table <- read.table(args[1], header = T, sep = '\t', row.names=1)

group_name_table <- read.table(args[2], header=F)
group_names <- unlist(group_name_table, use.names=FALSE)

contrast_list <- read.table(args[3], header=F)

output_path <- toString(args[4])
output_path

#run EdgeR########################################################################
d <- DGEList(counts=ft_count_table,group=group_names)

dt <- calcNormFactors(d,method="TMM")

design <- model.matrix(~0+group, data=d$samples)
colnames(design) <- levels(d$samples$group)

d2 <- estimateDisp(dt, design)

fit <- glmQLFit(d2,design)

#parse in contrasts
to_eval <- "my.contrasts <- makeContrasts("

for (num in (seq(1,dim(contrast_list)[1],by = 3))){
	to_eval <- paste(to_eval, contrast_list$V1[num], '=', contrast_list$V1[num+1], '-', contrast_list$V1[num+2], ',', sep = '')
}
to_eval <- paste(to_eval, 'levels=design)', sep = '')
eval(parse(text = to_eval))

#run contrasts
for (name in colnames(my.contrasts)){
  test <- glmQLFTest(fit, contrast=my.contrasts[,name])
  options("max.print"=1E9)
  options("width"=10000)
  sink(paste(output_path, name, '_out.txt', sep = ''))
  print(topTags(test,p.value=1, n= length(ft_count_table[,1])))
  sink()
  sink.reset()
}
