#' Extract Parameter Estimates and Sampling Covariance Matrix
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object.
#'   Output of `.MIFitList()`, `.MIFitObject()`, or `MIFit()`
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.MIExtract <- function(object) {
  if (
    methods::is(
      object = object$fit[[1]],
      class2 = "lavaan"
    )
  ) {
    coefs <- lapply(
      X = object$fit,
      FUN = lavaan::coef
    )
    vcovs <- lapply(
      X = object$fit,
      FUN = lavaan::vcov
    )
  } else {
    coefs <- lapply(
      X = object$fit,
      FUN = stats::coef
    )
    vcovs <- lapply(
      X = object$fit,
      FUN = stats::vcov
    )
  }
  M <- length(x = coefs)
  k <- length(x = coefs[[1]])
  list(
    M = M,
    k = k,
    coefs = coefs,
    vcovs = vcovs
  )
}
