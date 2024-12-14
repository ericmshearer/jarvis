#' Add Percent to Y-Axis Labels
#'
#' @param x Input list, leave blank.
#' @param ... Other arguments from base::format.
#' @param scale Logical, default to TRUE. If FALSE, multiples labels by 100 to get percentage.
#'
#' @return Y-axis in ggplot2 formatted with percentage symbol.
#' @export
#' @rdname scale_percent
scale_percent <- function(x, ..., scale = TRUE){
  if(!scale){
    function(x) format(paste0(x*100, "%"), ...)
  } else {
    function(x) format(paste0(x, "%"), ...)
  }
}
