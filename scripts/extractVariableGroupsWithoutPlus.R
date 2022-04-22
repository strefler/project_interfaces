extractVariableGroups2 <- function(x) {
  spltM<-function(y) {
    return(strsplit(y,"\\|"))
  }
  
  # find out how many levels of nested variables to expect
  prev<-1
  for (i in x) prev <- max(nchar(gsub("[^|]","",i))+1,prev)
  tmp <- sapply(x,spltM)
  out2 <- NULL
  for (k in prev:2) {
    for (i in which(sapply(tmp,length)==k)) {
      for (j in which(sapply(tmp,length)==k-1)) {
        if (all(tmp[[i]][1:k-1]==tmp[[j]])) {
          out2[[names(tmp[j])]] <- c(out2[[names(tmp[j])]],names(tmp[i]))
        }
      }
    }
  }
return(out2)  
}

.fM <- function(x) {
  out<-NULL
  for (i in x) {
    if (length(grep(i,x[!x==i],fixed = T))!=0) out[[i]]<-grep(i,x[!x==i],v=T,fixed = T)
  }
  return(out)
}
