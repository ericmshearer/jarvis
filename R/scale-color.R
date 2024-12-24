palettes <- list(
  Bright = c("#4477AA","#EE6677","#228833","#CCBB44","#66CCEE","#AA3377","#BBBBBB"),
  Muted = c("#CC6677","#332288","#DDCC77","#117733","#88CCEE","#882255","#44AA99","#999933","#AA4499","#DDDDDD"),
  `Okabe Ito` = c("#000000","#E69F00","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7","#999999")
)

apollo_palette <- function(name, n, reverse = FALSE, type = c("discrete","continuous")){
  type <- match.arg(type)

  pal <- palettes[[name]]

  if(is.null(pal)){
    stop("Palette not found/specified.")
  }

  if(missing(n)) {
    n <- length(pal)
  }

  if(type == "discrete" && n > length(pal)) {
    stop("Number of requested colors greater than what palette can offer.")
  }

  if(reverse){
    pal <- rev(pal)
  }

  out <- switch(type,
                continuous = grDevices::colorRampPalette(pal)(n),
                discrete = pal[1:n]
  )
  structure(out, class = "apollo_palette", name = name)
}

#' Apollo Color Scale
#'
#' @param name Current options - Bright, Muted, Oktabe Ito.
#' @param n Number of colors needed.
#' @param reverse Logical, default set to FALSE.
#' @param ... Other arguments for ggplot2::discrete_scale.
#'
#' @return Color scale.
#' @export
#' @rdname scale_color_apollo
#' @importFrom ggplot2 discrete_scale
#' @importFrom grDevices colorRampPalette
scale_color_apollo <- function(name, n, reverse = FALSE, ...){
  discrete_scale(aesthetics = "colour", palette = function(n) apollo_palette(name = name, n = n, reverse = reverse, type = "discrete"), ...)
}
