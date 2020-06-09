require(data.table)
require(devtools)
load_all("~/git/iamc")

## replace the model name with MODEL and produce output for all MIF files in directory
## based on the MAPPING
## the output file gets OUTPUT_PREFIX prepended to the file name.
## Warnings are appended to the given logfile.

MODEL <- "REMIND-EDGE-Transport 2.1"
MAPPING <- "~/git/project_interfaces/ar6/mapping_r21m42_AR6DB.csv"
OUTPUT_PREFIX <- "AR6_"
LOGFILE <- "missing.log"

MIF_DIRECTORY <- "."

set_model <- function(mif, model){
  dt <- fread(mif, header=T)
  dt[, Model := model]
  fwrite(dt, mif, sep=";")
}

flist <- list.files(MIF_DIRECTORY, "*.mif")
for(fl in flist){
  set_model(fl, MODEL)
  iamc::write.reportProject(fl, MAPPING, paste0(OUTPUT_PREFIX, fl), warning_log=LOGFILE)
}


