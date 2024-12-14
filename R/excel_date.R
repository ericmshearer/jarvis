#' Convert Numeric Dates in Excel
#'
#' @param x Numeric date in Excel, class numeric.
#'
#' @return Date.
#' @export
#' @importFrom cli cli_abort
#'
#' @examples
#' excel_date(42564)
excel_date <- function(x){
  if(!inherits(x, "numeric")){
    cli::cli_abort("Excel date not in numeric format.")
  }
  out <- as.Date(floor(x), origin = "1899-12-30")
  return(out)
}
