#' Degrees of Freedom of the Reference F Distribution (Li et al., 1991)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @details Denominator degrees of freedom
#'   of the F reference distribution
#'   for the multiparameter test
#'   of Li, Raghunathan, and Rubin (1991).
#'
#' @param M Positive integer.
#'   Number of imputations.
#' @param k Positive integer.
#'   Number of parameters.
#' @param ariv Numeric.
#'   Average relative increase in variance.
#'
#' @return Returns a numeric vector of length one.
#'
#' @references
#'   Li, K. H., Raghunathan, T. E., & Rubin, D. B. (1991).
#'   Large-sample significance levels from multiply imputed data
#'   using moment-based statistics and an F reference distribution.
#'   *Journal of the American Statistical Association*,
#'   86 (416), 1065--1073.
#'   \doi{10.1080/01621459.1991.10475152}
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.Nu2Li <- function(M,
                   k,
                   ariv) {
  x <- k * M - k
  if (x <= 4) {
    out <- (
      x * (
        1 + (1 / k)
      ) * (
        1 + (1 / ariv)
      )^2
    ) / 2
  } else {
    out <- 4 + (x - 4) * (
      1 + (
        1 - (2 / x)
      ) * (
        1 / ariv
      )
    )^2
  }
  out
}
