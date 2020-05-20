library(data.table)

TEMPLATE <- "shape_template.csv"
MAPPING <- "mapping_r21m42_AR6DB.csv"

generateMapping <- function(template, mapping){
  dt <- fread(template)

  ## remove TODOs and empty mappings
  dt[r21m42 == "TODO", r21m42 := ""]
  dt <- dt[r21m42 != ""]
  ## factor defaults to 1
  dt[is.na(factor), factor := 1]

  no_unit <- dt[r21m42_unit == ""]
  if(nrow(no_unit)){
    warning(sprintf("No unit found for variables %s", paste(no_unit$r21m42, collapse=", ")))
  }

  dt <- dt[, .(
    r21m42 = sprintf("%s (%s)", r21m42, r21m42_unit),
    AR6DB = sprintf("%s (%s)", Variable, Unit),
    factor)]

  ## store mapping
  fwrite(dt, mapping, sep=";")
  
}

generateMapping(TEMPLATE, MAPPING)
