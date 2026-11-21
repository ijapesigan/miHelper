#' Fraction of Missing Information (Univariate)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param riv Numeric.
#'   Relative increase in variance.
#'
#' @return Returns a numeric vector of length one.
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.UnivRMI <- function(riv) {
  riv / (
    riv + 1
  )
}
