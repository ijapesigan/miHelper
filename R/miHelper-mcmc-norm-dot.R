#' Data Augmentation for the Multivariate Normal (Internal)
#'
#' Runs `iter` cycles of data augmentation
#' (Schafer, 1997, Chapter 5) from `start`:
#' the I-step draws the missing values given the parameters
#' (`.IStepNorm()`), the P-step draws the parameters from their
#' complete-data posterior (`.PStepNorm()`).
#' With `prior = "noninformative"` the prior is
#' \eqn{\pi(\mu, \Sigma) \propto |\Sigma|^{-(p + 1) / 2}};
#' with `prior = "ridge"` it is the ridge prior with `ridge_df`
#' degrees of freedom and the variances of `start` on the diagonal,
#' which helps when the data barely identify the covariances.
#' The draws use R's random number generator (`set.seed()`).
#' No input checks: see `.CheckNorm()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Numeric matrix with missing values.
#' @param patterns List.
#'   Output of `.NormPatterns()`.
#' @param start List with `mu` and `sigma`,
#'   for example the output of `.EMNorm()`.
#' @param iter Positive integer.
#'   Number of cycles.
#' @param prior Character string.
#'   `"noninformative"` or `"ridge"`.
#' @param ridge_df Positive number.
#'   Degrees of freedom of the ridge prior.
#'
#' @return Returns a list with `mu` and `sigma`, the last draw.
#'
#' @references
#'   Schafer, J. L. (1997).
#'   *Analysis of incomplete multivariate data*.
#'   Chapman & Hall/CRC.
#'   \doi{10.1201/9780367803025}
#'
#' @examples
#' x <- as.matrix(airquality[, 1:4])
#' patterns <- .NormPatterns(x = x)
#' set.seed(42)
#' .MCMCNorm(
#'   x = x,
#'   patterns = patterns,
#'   start = .EMNorm(x = x, patterns = patterns),
#'   iter = 10
#' )
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper mi internal
#' @noRd
.MCMCNorm <- function(x,
                      patterns,
                      start,
                      iter = 1000L,
                      prior = "noninformative",
                      ridge_df = 1) {
  mu <- as.vector(x = start$mu)
  sigma <- unname(obj = start$sigma)
  if (prior == "ridge") {
    nu <- ridge_df
  } else {
    nu <- 0
  }
  ridge_diag <- diag(x = sigma)
  for (i in seq_len(length.out = iter)) {
    y <- .IStepNorm(
      x = x,
      mu = mu,
      sigma = sigma,
      obs = patterns$obs,
      rows = patterns$rows
    )
    theta <- .PStepNorm(
      y = y,
      ridge_df = nu,
      ridge_diag = ridge_diag
    )
    mu <- as.vector(x = theta$mu)
    sigma <- theta$sigma
  }
  names(x = mu) <- colnames(x = x)
  dimnames(x = sigma) <- list(colnames(x = x), colnames(x = x))
  list(
    mu = mu,
    sigma = sigma
  )
}
