#' Extract Zip Code
#'
#' Extract five digit zip code from single line address.
#'
#' @param address Character
#' @param starts_with Numeric, starting number of local zip codes.
#'
#' @returns Character, length of five.
#' @export
#'
#' @examples
#' extract_zip("1234 Main Street, Santa Ana, CA 92706")
extract_zip <- function(address, starts_with = 9){
  address <- substr(address, nchar(address)-10, nchar(address))
  match <- regmatches(address, gregexpr(sprintf("\\b%s\\d{4}\\b", starts_with), address))
  out <- unlist(match)
  return(out)
}
