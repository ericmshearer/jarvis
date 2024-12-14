#' Column Percentages
#'
#' @param df Input data, usually follows dplyr::count.
#' @param where Either row or col. Where do you want the percentage to go.
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
tbl_percentage <- function(df, where = c("row","col"), digits = 1) {
  if(missing(where)){
    where <- "col"
  }

  if(where == "col"){
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
      out <- jarvis::tbl_totals(out, where = "row")
    } else {
      out
    }

  }
  return(out)
}

#' Column or Row Totals
#'
#' @param df Input data, usually follows dplyr::count.
#' @param where Do you want to sum the row or column
#' @param name Name of summed celled. Defaults to total.
#'
#' @return Table with added totals.
#' @rdname tbl_totals
#' @export
#'
#' @examples
#' df <- data.frame(loc = c("A","B","C"), n = c(5,10,6))
#' tbl_totals(df)
tbl_totals <- function(df, where = c("row","col"), name = "Total"){
  numeric_cols <- sapply(df, is.numeric)

  if(missing(where) | is.null(where)){
    where <- "col"
  }

  if(where == "col"){
    totals <- colSums(df[, numeric_cols, drop = FALSE], na.rm = TRUE)

    totals_row <- rep(NA, ncol(df))
    totals_row[numeric_cols] <- totals

    out <- rbind(df, totals_row)

    spot <- rownames(out)[nrow(out)]

    out[spot,1] <- name
  } else {
    out <- df
    totals <- rowSums(df[, numeric_cols, drop = FALSE], na.rm = TRUE)
    out[[name]] <- totals
  }

  return(out)
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

col_percentage <- function(col, digits){
  col[is.na(col)] <- 0
  column_sum <- sum(col, na.rm = TRUE)
  col <- round((col / column_sum) * 100, digits = digits)
  return(col)
  }
