require(data.table)

## replace the model name with MODEL and produce output for all MIF files in directory
## based on the MAPPING
## the output file gets OUTPUT_PREFIX prepended to the file name.
## Warnings are appended to the given logfile.

MODEL <- "REMIND-EDGET 2.1"
MAPPING <- "~/git/project_interfaces/ar6/mapping_r21m42_AR6DB.csv"
OUTPUT_PREFIX <- "AR6_"
LOGFILE <- "warnings.txt"

## from https://stackoverflow.com/questions/4948361/how-do-i-save-warnings-and-errors-as-output-from-a-function
catchWarnings <- function(expr) {
  myWarnings <- NULL
  wHandler <- function(w) {
    myWarnings <<- c(myWarnings, w$message)
    invokeRestart("muffleWarning")
  }
  val <- withCallingHandlers(expr, warning = wHandler)
  myWarnings
}

set_model <- function(mif, model){
  dt <- fread(mif, header=T)
  dt[, Model := model]
  fwrite(dt, mif, sep=";")
}

flist <- list.files(".", "*.mif")
for(fl in flist){
  set_model(fl, MODEL)
  warns <- catchWarnings(iamc::write.reportProject(fl, MAPPING, paste0(OUTPUT_PREFIX, fl)))
  write(sprintf("%s: %s\n", fl, paste(warns, collapse="\n")), LOGFILE, ncolumns=1000, append = T)
}


