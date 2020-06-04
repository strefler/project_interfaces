library(data.table)

## generate the mapping file from the template that can contain metadata
## note that the

TEMPLATE <- "shape_template.csv"
MAPPING <- "mapping_r21m42_AR6DB.csv"
REMIND_VAR <- "r21m42"
REMIND_UNIT <- "r21m42_unit"
AR6_VAR <- "Variable"
AR6_UNIT <- "Unit"
FACTOR_COL <- "factor"
WEIGHT_COL <- NULL

generateMapping <- function(template, mapping,
                            remind_var, remind_unit,
                            ar6_var, ar6_unit,
                            factor_col, weight_col){
  dt <- fread(template)

  ## remove TODOs and empty mappings
  dt[get(remind_var) == "TODO", (remind_var) := ""]
  dt <- dt[get(remind_var) != ""]
  ## factor defaults to 1
  dt[is.na(get(factor_col)), (factor_col) := 1]

  no_unit <- dt[get(remind_unit) == ""]
  if(nrow(no_unit)){
    warning(sprintf("No unit found for variables %s", paste(no_unit[[remind_var]], collapse=", ")))
  }

  dt <- dt[, c(remind_var, ar6_var, factor_col) :=
               list(
                 sprintf("%s (%s)", get(remind_var), get(remind_unit)),
                 sprintf("%s (%s)", get(ar6_var), get(ar6_unit)),
                 get(factor_col))][, c(remind_var, ar6_var, factor_col), with=FALSE]

  if(!is.null(weight_col)){
    dt[, weight := get(weight_col)]
  }

  ## store mapping
  fwrite(dt, mapping, sep=";")
  
}

generateMapping(TEMPLATE, MAPPING,
                REMIND_VAR, REMIND_UNIT,
                AR6_VAR, AR6_UNIT,
                FACTOR_COL, WEIGHT_COL)
