require(data.table)
require(iamc)

## replace the model name with MODEL and produce output for all MIF files in directory
## based on the MAPPING
## the output file gets OUTPUT_PREFIX prepended to the file name.
## Warnings are appended to the given logfile.

MODEL <- "REMIND-Transport 2.1"
MAPPING <- "~/git/project_interfaces/ar6/mapping_r21m42_AR6DB.csv"
OUTPUT_PREFIX <- "AR6_"
LOGFILE <- "~/remind/testruns/lca_paper/AR6_output/missing.log"

MIF_DIRECTORY <- "~/remind/testruns/lca_paper"
OUTPUT_DIRECTORY <- "~/remind/testruns/lca_paper/AR6_output/"
REMOVE_FROM_SCEN <- NULL
ADD_TO_SCEN <- "Transport_"

GENERATE_SINGLE_OUTPUT = TRUE
OUTPUT_FILENAME = "~/remind/testruns/lca_paper/AR6_output/AR6_data.mif"

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
  fl_path <- file.path(MIF_DIRECTORY, fl)
  set_model_and_scenario(
    fl_path, MODEL, REMOVE_FROM_SCEN, ADD_TO_SCEN)
  if(GENERATE_SINGLE_OUTPUT){
    iamc::write.reportProject(
            fl_path, MAPPING,
            OUTPUT_FILENAME,
            append=TRUE,
            missing_log=LOGFILE)
  }else{
    iamc::write.reportProject(
            fl_path, MAPPING,
            file.path(OUTPUT_DIRECTORY, paste0(OUTPUT_PREFIX, fl)),
            missing_log=LOGFILE)
  }
}
