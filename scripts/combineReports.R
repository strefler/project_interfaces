# Combine REMIND and MAgPIE reports to a singele file for each coupled run
# Created by David 11.6.2020

library(lucode)
library(magclass)

# set paths
path_remind <- paste0(getwd(),"/")   # provide path to REMIND. Default: the actual path which the script is started from
path_magpie <- "/p/projects/piam/SDP_runs/SDP_round1/magpie_SDP/"

remindpath <- paste0(path_remind,"output")
magpiepath <- paste0(path_magpie,"output")

# find scenario names of coupled runs, e.g. "SSP1-PkBudg900"
runs <- findCoupledruns(resultsfolder=remindpath)

# for each scenario: find last remind and last magpie iteration, read the respective reports and combine them to a single new file
for (r in runs) {
  # find last remind iteration
  rem  <- findIterations(r,modelpath=c(remindpath),latest=TRUE)
  load(paste0(rem,"/config.Rdata"))
  # find last magpie iteration
  mag  <- findIterations(r,modelpath=c(magpiepath),latest=TRUE)

  # define names if reports
  report_rem <- paste0(rem,"/REMIND_generic_",cfg$title,"_adjustedPolicyCosts.mif")
  report_mag <- paste0(mag,"/report.mif")

  #BS: jump over files where manual reporting with Policy Costs isn't there
  if (!file.exists(report_rem)){
    cat("skipping scenario:\n    ",cfg$title,"\n")
    next
  }

  cat("Joining to a common reporting file:\n    ",report_rem,"\n    ",report_mag,"\n")
  tmp1 <- read.report(report_rem,as.list=FALSE)
  tmp2 <- read.report(report_mag,as.list=FALSE)[,getYears(tmp1),]
  tmp3 <- mbind(tmp1,tmp2)

  # remove -rem-xx and mag-xx from scenario names
  getNames(tmp3,dim=1) <- gsub("-(rem|mag)-[0-9]{1,2}","",getNames(tmp3,dim=1))

  # only harmonize model names to REMIND-MAgPIE, if there are no variable names that are identical across the models
  if (any(getNames(tmp3[,,"REMIND"],dim=3) %in% getNames(tmp3[,,"MAgPIE"],dim=3))) {
    msg <- "Cannot produce common REMIND-MAgPIE reporting because there are identical variable names in both models!\n"
    cat(msg)
    warning(msg)
  } else {
    # Replace REMIND and MAgPIE with REMIND-MAgPIE
    gsub("REMIND|MAgPIE","REMIND-MAgPIE",getNames(tmp3,dim=2))
    write.report(tmp3,file=paste0("output/bjoernAR6-",r,".mif"))
  }
}
