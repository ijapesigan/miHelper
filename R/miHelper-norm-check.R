#' Check the Data for the Multivariate Normal Imputation
#'
#' Stops with an error when `x` is not a numeric matrix or data frame
#' with at least two observed values in every column,
#' or when the settings are not valid.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Numeric matrix or data frame with missing values.
#' @param iter Positive integer.
#'   Number of data augmentation cycles.
#' @param prior Character string.
#'   `"noninformative"` or `"ridge"`.
#' @param ridge_df Positive number.
#'   Degrees of freedom of the ridge prior.
#'
#' @return Returns the data as a numeric matrix.
#'
#' @examples
#' .CheckNorm(
#'   x = matrix(data = c(1, NA, 3, 4, 5, 6, 7, 8, NA), nrow = 3),
#'   iter = 10,
#'   prior = "noninformative",
#'   ridge_df = 1
#' )
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper mi internal
#' @noRd
.CheckNorm <- function(x,
                       iter,
                       prior,
                       ridge_df) {
  stopifnot(
    is.matrix(x = x) || is.data.frame(x = x)
  )
  x <- as.matrix(x = x)
  stopifnot(
    is.numeric(x = x),
    all(colSums(x = !is.na(x = x)) >= 2),
    is.numeric(x = iter),
    length(x = iter) == 1,
    iter >= 1,
    prior %in% c("noninformative", "ridge"),
    is.numeric(x = ridge_df),
    length(x = ridge_df) == 1,
    ridge_df > 0
  )
  x
}
