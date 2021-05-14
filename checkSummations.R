library(quitte)
library(dplyr)

# Include here the name of your .mif file
data <- read.quitte("MYMIFFILE.mif")

tmp <- read.csv("summationGroups.csv",sep = ";")
check_variables <- list()
for (i in unique(tmp[,"parent"])) check_variables[[i]] <- tmp[which(tmp[,"parent"]==i),"child"]
names(check_variables) <- gsub(" [1-9]$","",names(check_variables))
tmp2<-NULL
for (i in names(check_variables)) tmp2<-rbind(tmp2,check_quitte(data,check_variables[i]))
tmp2$diff<-abs(tmp2$sum.value-tmp2$value)
write.table(arrange(tmp2,desc(diff)),sep=";",file = "checkSummations.log",quote = F,row.names = F)
