#' Unite Checkbox Variables in REDCap
#'
#' While useful for data collection, checkbox variables may need to be merged/united into a singular variable for analysis. REDCap internally labels checkbox variables are "prefix___1", with the number matchin the number response in the checkbox variable. Warning: if REDCap ever changes this format, this function will stop working.
#'
#' @param df Data.frame or tibble.
#' @param prefix Character, prefix of checkbox variable to be combined. If left blank or unspecified, all checkbox variables will be impacted.
#' @param sep Character, delimiter to separate multiple values.
#' @param drop_cols Logical, option to drop united columns after transformation. Default set to FALSE.
#'
#' @returns Data.frame or tibble with united colums using prefix.
#' @export
combine_redcap_checkboxes <- function(df, prefix = NULL, sep = ", ", drop_cols = FALSE){
  if(!is.null(prefix)){
    if(length(prefix) > 0){
      prefix <- paste(paste0(prefix, "___"), collapse = "|")
    }
  } else {
    checkbox_vars <- show_cols(df, "___")
  }

  unique_names <- unique(gsub("___.*", "", checkbox_vars))

  big_drop <- c()

  for(name in unique_names){
    dat <- df[,show_cols(df, paste0(name, "___")), drop = FALSE]

    combined_dat <- apply(dat, MARGIN = 1, FUN = function(x){
      non_na_values <- x[!is.na(x)]

      if(length(non_na_values) == 0){
        return(NA_character_)
      } else {
        get_non_na <- paste(non_na_values, collapse = sep)
        return(as.character(get_non_na))
      }
    })

    cols_to_drop <- colnames(dat)
    big_drop <- append(big_drop, cols_to_drop)
    col_positions <- get_indices(df, name)[1]
    df[[name]] <- combined_dat
    df <- move_column(df, name, Position = col_positions)
  }

  if(drop_cols){
    df <- df[!colnames(df) %in% big_drop]
  }
  return(df)
}

show_cols <- function(df, contains, ignore.case = FALSE){
  search <- grepl(contains, colnames(df), ignore.case = ignore.case)
  position <- which(search, colnames(df))
  out <- colnames(df)[position]
  return(out)
  }

get_indices <- function(df, prefix){
  col_names <- names(df)
  matching <- which(startsWith(col_names, paste0(prefix, "___")))
  return(matching)
  }

move_column <- function(df, column, Position = 1){
  d <- ncol(df)
  col_names <- names(df)

  for(i in column){
    x <- i == col_names
    if(all(!x)){
      warning(paste('Column \"', i, '"\ not found.'))
    } else {
      d1 <- seq(d)
      d1[x] <- Position - 0.5
      df <- df[order(d1)]
    }
  }
  return(df)
  }
