require(data.table)

## replace the model name and produce output for all MIF files in directory

MODEL <- "REMIND-EDGET 2.1"
MAPPING <- "~/git/project_interfaces/ar6/mapping_r21m42_AR6DB.csv"

set_model <- function(mif, model){
  dt <- fread(mif, header=T)
  dt[, Model := model]
  fwrite(dt, mif, sep=";")
}

flist <- list.files(".", "*.mif")
for(fl in flist){
  set_model(fl, MODEL)
  iamc::write.reportProject(fl, MAPPING, paste0("AR6_", fl))
}


