require(data.table)
require(iamc)

## replace the model name with MODEL and produce output for all MIF files in directory
## based on the MAPPING
## the output file gets OUTPUT_PREFIX prepended to the file name.
## Warnings are appended to the given logfile.

MODEL <- "REMIND-Transport 2.1"
MAPPING <- "~/git/project_interfaces/ar6/mapping_r21m42_AR6DB.csv"
OUTPUT_PREFIX <- "AR6_"
LOGFILE <- "missing.log"

MIF_DIRECTORY <- "."
OUTPUT_DIRECTORY <- "AR6_output/"
REMOVE_FROM_SCEN <- NULL
ADD_TO_SCEN <- "Transport_"

if(!file.exists(OUTPUT_DIRECTORY)){
  dir.create(OUTPUT_DIRECTORY)
}

set_model_and_scenario <- function(mif, model, scen_remove = NULL, scen_add = NULL){
  dt <- fread(mif, header=T)
  dt[, Model := model]
  if (!is.null(scen_remove)) dt[, Scenario := gsub(scen_remove,"",Scenario)]
  if (!is.null(scen_add)) {
    if(grepl(scen_add, unique(dt$Scenario), fixed=TRUE)){
      print(sprintf("Prefix %s already found in scenario name in %s.", scen_add, mif))
    }else{
      dt[, Scenario := paste0(scen_add,Scenario)]
    }
  }
  fwrite(dt, mif, sep=";")
}

flist <- list.files(MIF_DIRECTORY, "*.mif")
for(fl in flist){
  set_model_and_scenario(fl, MODEL, REMOVE_FROM_SCEN, ADD_TO_SCEN)
  iamc::write.reportProject(fl, MAPPING,
                            file.path(OUTPUT_DIRECTORY, paste0(OUTPUT_PREFIX, fl)),
                            missing_log=LOGFILE)
}
