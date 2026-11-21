## ---- test-miHelper-i-step-norm-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    x <- as.matrix(x = datasets::airquality[, 1:4])
    pat <- miHelper:::.NormPatterns(x = x)
    em <- miHelper:::.EMNorm(x = x, patterns = pat)
    testthat::test_that(
      desc = paste(text, "fills only the missing values; set.seed repeats"),
      code = {
        set.seed(seed = 1)
        a <- miHelper:::.IStepNorm(
          x = x,
          mu = unname(obj = em$mu),
          sigma = unname(obj = em$sigma),
          obs = pat$obs,
          rows = pat$rows
        )
        set.seed(seed = 1)
        b <- miHelper:::.IStepNorm(
          x = x,
          mu = unname(obj = em$mu),
          sigma = unname(obj = em$sigma),
          obs = pat$obs,
          rows = pat$rows
        )
        testthat::expect_identical(object = a, expected = b)
        testthat::expect_false(object = anyNA(x = a))
        testthat::expect_equal(
          object = a[!is.na(x = x)],
          expected = unname(obj = x[!is.na(x = x)])
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "draws have the conditional mean and variance"),
      code = {
        set.seed(seed = 2)
        sigma <- matrix(data = c(1, 0.5, 0.5, 2), nrow = 2)
        y <- matrix(data = c(1, NA), nrow = 1)[rep(x = 1, times = 20000), ]
        pat_y <- miHelper:::.NormPatterns(x = y)
        draws <- miHelper:::.IStepNorm(
          x = y,
          mu = c(0, 0),
          sigma = sigma,
          obs = pat_y$obs,
          rows = pat_y$rows
        )[, 2]
        testthat::expect_equal(
          object = mean(x = draws),
          expected = 0.5,
          tolerance = 0.03
        )
        testthat::expect_equal(
          object = stats::var(x = draws),
          expected = 2 - 0.25,
          tolerance = 0.03
        )
      }
    )
  },
  text = "test-miHelper-i-step-norm-dot"
)
