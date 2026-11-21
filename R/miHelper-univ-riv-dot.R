#' Relative Increase in Variance (Univariate)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param between Numeric.
#'   Variance between imputations.
#' @param within Numeric.
#'   Variance within imputations.
#' @param M Positive integer.
#'   Number of imputations.
#'
#' @return Returns a numeric vector of length one.
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.UnivRIV <- function(between,
                     within,
                     M) {
  (
    (
      1 + (
        1 / M
      )
    ) * between
  ) / within
}
