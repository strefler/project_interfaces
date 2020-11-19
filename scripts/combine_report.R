# combine REMIND and MAgPIE reports of last coupling iteration

# save this script to the REMIND main folder and execute it there by calling:
# Rscript combine_report.R runs=C_SSP2-Base,C_SSP2-NDC,...

library(magclass)
library(lucode2)

combine_report <- function(rdata_file) {

  load(rdata_file)
  
  cfg_rem$title <- paste0(runname,"-rem-5")
  
  outfolder_rem <- paste0("/output/",cfg_rem$title,"/")
  outfolder_mag <- paste0("/output/",runname,"-mag-4/")
  
  #BS: (un)comment here if you want to use the standard reporting without the policy costs w.r.t. the correct reference run
  report_rem <- paste0(path_remind,outfolder_rem,"/REMIND_generic_",cfg_rem$title,"_adjustedPolicyCosts.mif")
  # report_rem <- paste0(path_remind,outfolder_rem,"/REMIND_generic_",cfg_rem$title,".mif")
  report_mag <- paste0(path_magpie,outfolder_mag,"/report.mif")
  
  cat("Joining to a common reporting file:\n    ",report_rem,"\n    ",report_mag,"\n")
  tmp1 <- read.report(report_rem,as.list=FALSE)
  tmp2 <- read.report(report_mag,as.list=FALSE)[,getYears(tmp1),]
  # remove population from magpie reporting to avoid duplication (units "million" vs. "million people")
  tmp2 <- tmp2[,,"Population (million people)",invert=T]
  tmp3 <- mbind(tmp1,tmp2)
  getNames(tmp3,dim=1) <- gsub("-(rem|mag)-[0-9]{1,2}","",getNames(tmp3,dim=1)) # remove -rem-xx and mag-xx from scenario names
  # only harmonize model names to REMIND-MAgPIE, if there are no variable names that are identical across the models
  if (any(getNames(tmp3[,,"REMIND"],dim=3) %in% getNames(tmp3[,,"MAgPIE"],dim=3))) {
    msg <- "Cannot produce common REMIND-MAgPIE reporting because there are identical variable names in both models!\n"
    cat(msg)
    warning(msg)
  } else {
    # Replace REMIND and MAgPIE with REMIND-MAgPIE
    getNames(tmp3,dim=2) <- gsub("REMIND|MAgPIE","REMIND-MAGPIE",getNames(tmp3,dim=2))
    write.report(tmp3,file=paste0("output/bjoernAR6_",runname,".mif"))
  }
}

readArgs("runs")

if(!exists("runs")) stop("Please give the name of the run by providing the parameter 'runs=...' to the Rscript")

for(run in runs) {
  combine_report(paste0(run,".RData"))
}
