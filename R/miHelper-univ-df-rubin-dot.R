#' Rubin Degrees of Freedom (Univariate)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param rmi Numeric.
#'   Fraction of missing information.
#' @param M Positive integer.
#'   Number of imputations.
#'
#' @return Returns a numeric vector of length one.
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.DFRubin <- function(rmi,
                     M) {
  (
    M - 1
  ) * (
    rmi
  )^(-2)
}
