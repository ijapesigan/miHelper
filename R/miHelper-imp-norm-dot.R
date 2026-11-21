#' Impute Under the Multivariate Normal Model (Internal)
#'
#' Returns one imputed data set:
#' the EM estimates (`.EMNorm()`),
#' `iter` cycles of data augmentation from them (`.MCMCNorm()`),
#' and an I-step draw (`.IStepNorm()`) from the last parameters.
#' This replaces norm2's `impNorm(mcmcNorm(emNorm(x)))`.
#' Observed values are unchanged.
#' The draws use R's random number generator (`set.seed()`).
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
#' @param em Optional list.
#'   Output of `.EMNorm()`, to reuse across imputations.
#'
#' @return Returns a data frame with the names of `x`.
#'
#' @examples
#' set.seed(42)
#' head(x = .ImpNorm(x = airquality[, 1:4], iter = 10))
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper mi internal
#' @noRd
.ImpNorm <- function(x,
                     iter = 1000L,
                     prior = "noninformative",
                     ridge_df = 1,
                     em = NULL) {
  mat <- .CheckNorm(
    x = x,
    iter = iter,
    prior = prior,
    ridge_df = ridge_df
  )
  patterns <- .NormPatterns(x = mat)
  if (is.null(x = em)) {
    em <- .EMNorm(
      x = mat,
      patterns = patterns
    )
  }
  theta <- .MCMCNorm(
    x = mat,
    patterns = patterns,
    start = em,
    iter = iter,
    prior = prior,
    ridge_df = ridge_df
  )
  y <- .IStepNorm(
    x = mat,
    mu = unname(obj = theta$mu),
    sigma = unname(obj = theta$sigma),
    obs = patterns$obs,
    rows = patterns$rows
  )
  colnames(x = y) <- colnames(x = mat)
  as.data.frame(x = y)
}
