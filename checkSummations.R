library(quitte)
library(tidyverse)

checkSum <- function(name,x) {
  tmp <- x %>%
         group_by(model,scenario,region,period) %>%
         summarise(grsum=sum(value*factor),.groups="drop") %>%
    ungroup()
  tmp$variable <- name
  return(tmp)
}

# Add here the name of your .mif file
data_bu <- read.quitte("MYMIFFILE.mif")

tmp <- read.csv("summationGroups.csv",sep = ";",stringsAsFactors=FALSE)
data <- filter(data_bu,variable%in%unique(c(tmp$child,tmp$parent)))
check_variables <- list()
for (i in unique(tmp[,"parent"])) check_variables[[i]] <- tmp[which(tmp[,"parent"]==i),"child"]
tmp <- tmp %>% mutate(variable=child)
data <- left_join(data,tmp)
names(check_variables) <- gsub(" [1-9]$","",names(check_variables))
tmp2<-NULL
for (i in names(check_variables)) tmp2<-rbind(tmp2,checkSum(i,filter(data,parent==i,variable%in%check_variables[[i]])))

tmp2 <- left_join(tmp2,data,c("scenario","region","variable","period","model")) %>% mutate(    diff=abs(grsum-value)    ,reldiff=  100*abs((grsum-value)/value)     )

tmp2_tiny <- filter(tmp2,reldiff<1,diff<0.001)
tmp2 <- filter(tmp2,reldiff>=1,diff>=0.001)

write.table(arrange(tmp2,desc(reldiff)),sep=";",file = "checkSummations.log",quote = F,row.names = F)
write.table(arrange(tmp2_tiny,desc(reldiff)),sep=";",file = "checkSummations_tiny.log",quote = F,row.names = F)
