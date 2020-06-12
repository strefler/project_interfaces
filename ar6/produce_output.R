require(data.table)
require(iamc)

## replace the model name with MODEL and produce output for all MIF files in directory
## based on the MAPPING
## the output file gets OUTPUT_PREFIX prepended to the file name.
## Warnings are appended to the given logfile.

MODEL <- "REMIND-MAgPIE 2.1-4.2"
MAPPING <- "mapping_r21m42_AR6DB.csv"
OUTPUT_PREFIX <- "AR6_"
LOGFILE <- "missing.log"

MIF_DIRECTORY <- "."
OUTPUT_DIRECTORY <- "AR6_output/"

set_model <- function(mif, model){
  dt <- fread(mif, header=T)
  dt[, Model := model]
  fwrite(dt, mif, sep=";")
}

flist <- list.files(MIF_DIRECTORY, "*.mif")
for(fl in flist){
  set_model(fl, MODEL)
  iamc::write.reportProject(fl, MAPPING,
                            file.path(OUTPUT_DIRECTORY, paste0(OUTPUT_PREFIX, fl)),
                            missing_log=LOGFILE)
}
