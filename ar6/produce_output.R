require(data.table)

## replace the model name with MODEL and produce output for all MIF files in directory
## based on the MAPPING
## the output file gets OUTPUT_PREFIX prepended to the file name.

MODEL <- "REMIND-EDGET 2.1"
MAPPING <- "~/git/project_interfaces/ar6/mapping_r21m42_AR6DB.csv"
OUTPUT_PREFIX <- "AR6_"

set_model <- function(mif, model){
  dt <- fread(mif, header=T)
  dt[, Model := model]
  fwrite(dt, mif, sep=";")
}

flist <- list.files(".", "*.mif")
for(fl in flist){
  set_model(fl, MODEL)
  iamc::write.reportProject(fl, MAPPING, paste0(OUTPUT_PREFIX, fl))
}


