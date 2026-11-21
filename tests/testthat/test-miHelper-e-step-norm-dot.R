## ---- test-miHelper-e-step-norm-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "complete data: sums and cross products"),
      code = {
        x <- as.matrix(x = datasets::mtcars[, 1:3])
        pat <- miHelper:::.NormPatterns(x = x)
        out <- miHelper:::.EStepNorm(
          x = x,
          mu = colMeans(x = x),
          sigma = stats::cov(x = x),
          obs = pat$obs,
          rows = pat$rows
        )
        testthat::expect_equal(
          object = as.vector(x = out$t1),
          expected = unname(obj = colSums(x = x))
        )
        testthat::expect_equal(
          object = out$t2,
          expected = unname(obj = crossprod(x = x))
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "one missing value: conditional mean and variance"),
      code = {
        x <- matrix(data = c(1, NA), nrow = 1)
        mu <- c(0, 0)
        sigma <- matrix(data = c(1, 0.5, 0.5, 2), nrow = 2)
        pat <- miHelper:::.NormPatterns(x = x)
        out <- miHelper:::.EStepNorm(
          x = x,
          mu = mu,
          sigma = sigma,
          obs = pat$obs,
          rows = pat$rows
        )
        testthat::expect_equal(
          object = as.vector(x = out$t1),
          expected = c(1, 0.5)
        )
        testthat::expect_equal(
          object = out$t2[2, 2],
          expected = 0.5^2 + (2 - 0.5^2)
        )
      }
    )
  },
  text = "test-miHelper-e-step-norm-dot"
)
