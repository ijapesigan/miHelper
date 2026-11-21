## ---- test-miHelper-em-norm-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "complete data: sample mean and MLE covariance"),
      code = {
        x <- as.matrix(x = datasets::mtcars[, 1:3])
        out <- miHelper:::.EMNorm(
          x = x,
          patterns = miHelper:::.NormPatterns(x = x)
        )
        n <- nrow(x = x)
        testthat::expect_equal(
          object = out$mu,
          expected = colMeans(x = x)
        )
        testthat::expect_equal(
          object = out$sigma,
          expected = stats::cov(x = x) * (n - 1) / n
        )
        testthat::expect_true(object = out$converged)
      }
    )
  },
  text = "test-miHelper-em-norm-dot"
)
