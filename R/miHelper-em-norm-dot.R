#' EM for the Multivariate Normal with Missing Data (Internal)
#'
#' Maximum likelihood estimates of the mean vector and covariance matrix
#' of a multivariate normal distribution from data with missing values
#' (missing at random), by the EM algorithm (Schafer, 1997, Chapter 5).
#' The E-step is in C++ (`.EStepNorm()`), once per missing-data pattern.
#' Starts from the observed means and variances (no covariances)
#' and stops when the largest relative change of a parameter
#' is below `criterion`, or after `iter_max` iterations.
#' No input checks: see `.CheckNorm()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Numeric matrix with missing values.
#' @param patterns List.
#'   Output of `.NormPatterns()`.
#' @param iter_max Positive integer.
#'   Maximum number of iterations.
#' @param criterion Positive number.
#'   Convergence criterion: the largest
#'   \eqn{\left| \theta_{t + 1} - \theta_{t} \right| /
#'   \left( \left| \theta_{t} \right| + 10^{-10} \right)}.
#'
#' @return Returns a list with `mu`, `sigma`,
#'   `iter` (the number of iterations), and `converged`.
#'
#' @references
#'   Schafer, J. L. (1997).
#'   *Analysis of incomplete multivariate data*.
#'   Chapman & Hall/CRC.
#'   \doi{10.1201/9780367803025}
#'
#' @examples
#' x <- as.matrix(airquality[, 1:4])
#' .EMNorm(x = x, patterns = .NormPatterns(x = x))
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper mi internal
#' @noRd
.EMNorm <- function(x,
                    patterns,
                    iter_max = 1000L,
                    criterion = 1e-08) {
  n <- nrow(x = x)
  p <- ncol(x = x)
  mu <- colMeans(x = x, na.rm = TRUE)
  sigma <- diag(
    x = apply(
      X = x,
      MARGIN = 2,
      FUN = stats::var,
      na.rm = TRUE
    ),
    nrow = p
  )
  iter <- 0L
  converged <- FALSE
  while (!converged && iter < iter_max) {
    iter <- iter + 1L
    ss <- .EStepNorm(
      x = x,
      mu = mu,
      sigma = sigma,
      obs = patterns$obs,
      rows = patterns$rows
    )
    mu_new <- as.vector(x = ss$t1) / n
    sigma_new <- ss$t2 / n - tcrossprod(x = mu_new)
    sigma_new <- 0.5 * (sigma_new + t(x = sigma_new))
    old <- c(mu, sigma)
    change <- max(
      abs(x = c(mu_new, sigma_new) - old) / (abs(x = old) + 1e-10)
    )
    converged <- change < criterion
    mu <- mu_new
    sigma <- sigma_new
  }
  names(x = mu) <- colnames(x = x)
  dimnames(x = sigma) <- list(colnames(x = x), colnames(x = x))
  list(
    mu = mu,
    sigma = sigma,
    iter = iter,
    converged = converged
  )
}
