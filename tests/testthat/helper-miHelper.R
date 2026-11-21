# Shared test helpers (testthat sources helper-*.R before the tests).
# rProject writes this file once; it is yours after that.

# Slow tests: run on CI and on request, skipped in local builds and on CRAN.
.SkipSlow <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not(
    condition = Sys.getenv(x = "CI") == "true" ||
      Sys.getenv(x = "RPROJECT_SLOW_TESTS") == "true",
    message = "set RPROJECT_SLOW_TESTS=true to run slow tests"
  )
}

# Proprietary software: never on CI or CRAN, and only where it is found.
.SkipIfMissing <- function(program) {
  testthat::skip_on_cran()
  testthat::skip_on_ci()
  testthat::skip_if(
    condition = Sys.which(names = program) == "",
    message = paste0(program, " is not installed")
  )
}

# Three complete data sets: mtcars with a fixed, deterministic shift of mpg.
.TestImputed <- function() {
  lapply(
    X = 0:2,
    FUN = function(i) {
      data <- datasets::mtcars[, c("mpg", "wt", "hp")]
      data$mpg <- data$mpg + i * cos(x = seq_len(length.out = nrow(x = data)))
      data
    }
  )
}

# A small missing data set (MCAR), deterministic.
.TestMissing <- function(n = 200L) {
  set.seed(seed = 42)
  x1 <- stats::rnorm(n = n)
  x2 <- stats::rnorm(n = n)
  y <- 0.5 * x1 + 0.5 * x2 + stats::rnorm(n = n)
  x1[sample.int(n = n, size = 10)] <- NA
  x2[sample.int(n = n, size = 10)] <- NA
  data.frame(
    y = y,
    x1 = x1,
    x2 = x2
  )
}

# A hand-made list of coefficients and sampling covariance matrices
# (M = 2, k = 2): est = (2, 2), within = 2 I, between = diag(2, 0).
.TestCoefs <- function() {
  nm <- c("a", "b")
  list(
    coefs = list(
      c(a = 1, b = 2),
      c(a = 3, b = 2)
    ),
    vcovs = list(
      matrix(data = c(1, 0, 0, 1), nrow = 2, dimnames = list(nm, nm)),
      matrix(data = c(3, 0, 0, 3), nrow = 2, dimnames = list(nm, nm))
    )
  )
}

# a stand-in for a norm2 "norm" object (norm2 is archived on CRAN)
.TestNormObject <- function(data,
                            method = "MCMC") {
  imp <- if (method == "MCMC") {
    lapply(
      X = 1:2,
      FUN = function(i) {
        as.matrix(x = miHelper:::.ImpNorm(x = data, iter = 5))
      }
    )
  } else {
    NULL
  }
  structure(
    .Data = list(method = method, imp.list = imp),
    class = "norm"
  )
}
