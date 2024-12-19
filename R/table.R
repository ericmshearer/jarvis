#' Frequency Table
#'
#' @param df Input data.frame
#' @param ... Variables you want to summarize. If one variable, returns n and percent. If 2 or more, uses tidyr::pivot_wider and only returns n.
#' @param scaled Is percent multiplied by 100 or returned as fraction.
#' @param digits Rounding for percent.
#' @param pivot Logical, pivot long to wide.
#'
#' @return Frequency tbl.
#' @export
#' @importFrom tidyr pivot_wider
tbl <- function(df, ..., scaled = TRUE, digits = 1, pivot = FALSE){
  df_class <- class(df)

  y <- collect_vars(...)
  df <- df[, y, drop = FALSE]
  init <- rip_count(df)

  names(init) <- c(y, "n")
  init[init > 0]

  if(length(y) > 1){
    if(pivot){
      out <- tidyr::pivot_wider(init, names_from = y[2], values_from = "n", values_fill = 0)
    } else {
      out <- init
    }
  } else {
    init$percent <- OCepi::add_percent(init$n, digits = digits, multiply = scaled)
    out <- init
  }
  class(out) <- df_class
  return(out)
}

#' Column Percentages
#'
#' @param df Input data, usually follows dplyr::count.
#' @param loc Either row or col. Where do you want the percentage to go.
#' @param digits For rounding.
#'
#' @return Table with cells as percentages of column.
#' @rdname tbl_percentage
#' @export
#' @importFrom utils head
#'
#' @examples
#' df <- data.frame(loc = c("A","B","C"), n = c(5,10,6))
#' tbl_percentage(df)
tbl_percentage <- function(df, loc = c("row","col"), digits = 1) {
  if(missing(loc)){
    loc <- "col"
  }

  loc <- match.arg(loc)

  if(loc == "col"){
    firstcol_lastrow <- rownames(df)[nrow(df)]

    check <- toString(df[firstcol_lastrow,1])

    if(check %in% c("Total","Sum")){
      df <- head(df, -1)
    }

    numeric_cols <- sapply(df, is.numeric)

    df[,numeric_cols] <- lapply(df[,numeric_cols, drop = FALSE], col_percentage, digits = 1)

    if(check %in% c("Total","Sum")){
      out <- jarvis::tbl_totals(df)
    } else {
      out <- df
    }

  } else {
    firstcol_lastrow <- rownames(df)[nrow(df)]

    check <- toString(df[firstcol_lastrow,1])

    if(check %in% c("Total","Sum")){
      df <- head(df, -1)
    }

    numeric_cols <- sapply(df, is.numeric)
    df[is.na(df)] <- 0
    row_sum <- rowSums(df[,numeric_cols])

    results <- round(sweep(df[,numeric_cols], 1, row_sum, FUN = "/") * 100, digits = digits)

    col_to_add <- setdiff(colnames(df), colnames(results))

    out <- cbind(df[,col_to_add], results)

    if(check %in% c("Total","Sum")){
      out <- jarvis::tbl_totals(out, loc = "row")
    } else {
      out
    }

  }
  return(out)
}

#' Column or Row Totals
#'
#' @param df Input data, usually follows dplyr::count.
#' @param loc Do you want to sum the row, column, or both.
#' @param name Name of summed celled. Defaults to total.
#'
#' @return Table with added totals.
#' @rdname tbl_totals
#' @export
#'
#' @examples
#' df <- data.frame(loc = c("A","B","C"), n = c(5,10,6))
#' tbl_totals(df)
tbl_totals <- function(df, loc = c("col","row","both"), name = "Total"){
  if(missing(loc)){
    loc <- "col"
  }

  loc = match.arg(loc)

  numeric_cols <- sapply(df, is.numeric)

  col_totals <- c(NA, colSums(df[, numeric_cols, drop = FALSE], na.rm = TRUE))
  row_totals <- rowSums(df[, numeric_cols, drop = FALSE], na.rm = TRUE)

  if(loc == "col"){
    df <- rbind(df, col_totals)
    df[nrow(df),1] <- name
  } else if(loc == "row"){
    df[[name]] <- row_totals
  } else {
    df[[name]] <- row_totals
    numeric_cols <- sapply(df, is.numeric)
    col_totals2 <- c(NA, colSums(df[, numeric_cols, drop = FALSE], na.rm = TRUE))
    df <- rbind(df, col_totals2)
    df[nrow(df),1] <- name
  }

  return(df)
}

#' Convert NA Numeric Cells to Zero
#'
#' @param df Input data frame, usually following dplyr::count.
#'
#' @return Data frame with NAs replaced with zero.
#' @rdname na_to_zero
#' @export
#'
#' @examples
#' df <- data.frame(loc = c("A","B","C"), n = c(5,NA,6))
#' na_to_zero(df)
na_to_zero <- function(df){
  numeric_cols <- sapply(df, is.numeric)
  df[numeric_cols] <- lapply(df[numeric_cols], function(x) {
    x[is.na(x)] <- 0
    return(x)
  })
  return(df)
}

#tbl helpers
col_percentage <- function(col, digits){
  col[is.na(col)] <- 0
  column_sum <- sum(col, na.rm = TRUE)
  col <- round((col / column_sum) * 100, digits = digits)
  return(col)
}

collect_vars <- function(...){
  sapply(substitute(...()), deparse)
}

rip_count <- function(df){
  as.data.frame(table(df), stringsAsFactors = FALSE)
}
