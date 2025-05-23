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

#' Add Length to X Scale
#'
#' @param x Numeric, how much to add to x-scale. Depends on what class x-scale is e.g. date, continuous.
#'
#' @return X-scale expanded to the right by x.
#' @export
#' @importFrom ggplot2 expansion
expand_x <- function(x){
  ggplot2::expansion(add = c(0,x))
}
