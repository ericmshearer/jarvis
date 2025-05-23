#' Find Columns that Contain String
#'
#' @param df Data.frame
#' @param contains Search terms, search multiple patterns using |.
#'
#' @returns Vector, charachter.
#' @export
contains_columns <- function(df, contains){
  search <- grepl(contains, colnames(df), ignore.case = TRUE)
  position <- which(search, colnames(df))
  out <- colnames(df)[position]
  return(out)
}
