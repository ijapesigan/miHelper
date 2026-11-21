## ---- test-miHelper-mi-extract-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::skip_on_cran()
    data <- .TestImputed()
    testthat::test_that(
      desc = paste(text, "lm"),
      code = {
        fits <- lapply(
          X = data,
          FUN = function(d) {
            stats::lm(
              formula = mpg ~ wt + hp,
              data = d
            )
          }
        )
        out <- .MIExtract(
          object = list(fit = fits)
        )
        testthat::expect_equal(
          object = out$M,
          expected = 3
        )
        testthat::expect_equal(
          object = out$k,
          expected = 3
        )
        testthat::expect_equal(
          object = out$coefs[[2]],
          expected = stats::coef(object = fits[[2]]),
          tolerance = tol
        )
        testthat::expect_equal(
          object = out$vcovs[[3]],
          expected = stats::vcov(object = fits[[3]]),
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "lavaan"),
      code = {
        fits <- lapply(
          X = data[1:2],
          FUN = function(d) {
            lavaan::sem(
              model = "mpg ~ wt + hp",
              data = d
            )
          }
        )
        out <- .MIExtract(
          object = list(fit = fits)
        )
        testthat::expect_equal(
          object = out$M,
          expected = 2
        )
        testthat::expect_equal(
          object = out$k,
          expected = length(x = lavaan::coef(object = fits[[1]]))
        )
        testthat::expect_equal(
          object = out$coefs[[1]],
          expected = lavaan::coef(object = fits[[1]]),
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-mi-extract-dot",
  tol = 1e-6
)
