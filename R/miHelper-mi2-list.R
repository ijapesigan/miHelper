#' Multiple Imputation S3 Object to List of Multiply Imputed Data Sets
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class
#'   `mids` or `amelia`.
#'
#' @return Returns a list of data frames.
#'
#' @examples
#' # mice --------------------------------------
#' mids <- mice::mice(airquality, m = 5)
#' MI2List(mids)
#'
#' # amelia ------------------------------------
#' amelia <- Amelia::amelia(airquality, m = 5)
#' MI2List(amelia)
#'
#' @export
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper preprocess
MI2List <- function(object) {
  UseMethod(generic = "MI2List")
}
