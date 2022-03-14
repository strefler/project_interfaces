library(data.table)

## generate the mapping file from the template that can contain metadata
## note that the

TEMPLATE <- "mapping_template.csv"
MAPPING <- "mapping_r30m44_AR6DB.csv"
REMIND_VAR <- "r30m44"
REMIND_UNIT <- "r30m44_unit"
AR6_VAR <- "Variable"
AR6_UNIT <- "Unit"
FACTOR_COL <- "r30m44_factor"
WEIGHT_COL <- NULL
SPATIAL_COL <- "r21m42_spatial"

generateMapping <- function(template, mapping,
                            remind_var, remind_unit,
                            ar6_var, ar6_unit,
                            factor_col, weight_col,
                            spatial_col){
  dt <- fread(template,sep = ';')

  ## remove TODOs and empty mappings
  dt[get(remind_var) == "TODO", (remind_var) := ""]
  dt <- dt[get(remind_var) != ""]
  ## factor defaults to 1
  dt[is.na(get(factor_col)), (factor_col) := 1]
  ## spatial defaults to "reg+glo"
  if(spatial_col %in% colnames(dt)){
    dt[get(spatial_col) == "", (spatial_col) := "reg+glo"]
  }else{
    dt[, (spatial_col) := "reg+glo"]
  }
  
  no_unit <- dt[get(remind_unit) == ""]
  if(nrow(no_unit)){
    warning(sprintf("No unit found for variables %s", paste(no_unit[[remind_var]], collapse=", ")))
  }

  dt <- dt[, c(remind_var, ar6_var, "factor", "weight", "spatial") :=
               list(
                 sprintf("%s (%s)", get(remind_var), get(remind_unit)),
                 sprintf("%s (%s)", get(ar6_var), get(ar6_unit)),
                 get(factor_col),
                 ifelse(is.null(weight_col), "NULL", get(weight_col)),
                 get(spatial_col)
                 )][
  , c(remind_var, ar6_var, "factor", "weight", "spatial"), with=FALSE]

  ## store mapping
  fwrite(dt, mapping, sep=";")

}

MODEL <- "REMIND-MAgPIE 3.0-4.4"
COMMENT_FILE <- "ar6-comments.csv"

storeComments <- function(template, remind_var, ar6_var){
  dt <- fread(template)
  dt[get(remind_var) == "TODO", (remind_var) := ""]
  dt <- dt[get(remind_var) != ""]

  comments <- dt[Comment != ""]
  comments <- comments[, .(
    "Model"=MODEL,
    "Scenario"="All",
    "Region"="All",
    "Variable"=get(AR6_VAR),
    "Year"="All",
    Comment)]

  fwrite(comments, COMMENT_FILE)
}

generateMapping(
  template=TEMPLATE,
  mapping=MAPPING,
  remind_var=REMIND_VAR,
  remind_unit=REMIND_UNIT,
  ar6_var=AR6_VAR,
  ar6_unit=AR6_UNIT,
  factor_col=FACTOR_COL,
  weight_col=WEIGHT_COL,
  spatial_col=SPATIAL_COL)

storeComments(
  template=TEMPLATE,
  remind_var=REMIND_VAR,
  ar6_var=AR6_VAR)
