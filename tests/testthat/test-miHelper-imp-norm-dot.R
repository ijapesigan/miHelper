## ---- test-miHelper-imp-norm-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "one complete data set; observed values kept"),
      code = {
        x <- datasets::airquality[, 1:4]
        set.seed(seed = 6)
        a <- miHelper:::.ImpNorm(x = x, iter = 20)
        set.seed(seed = 6)
        b <- miHelper:::.ImpNorm(x = x, iter = 20)
        testthat::expect_identical(object = a, expected = b)
        testthat::expect_equal(object = names(x = a), expected = names(x = x))
        testthat::expect_false(object = anyNA(x = a))
        obs <- !is.na(x = as.matrix(x = x))
        testthat::expect_equal(
          object = as.matrix(x = a)[obs],
          expected = as.matrix(x = x)[obs]
        )
      }
    )
  },
  text = "test-miHelper-imp-norm-dot"
)
