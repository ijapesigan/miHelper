## ---- test-miHelper-norm-check
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "valid input passes, invalid input stops"),
      code = {
        x <- matrix(data = c(1, NA, 3, 4, 5, 6, 7, 8, NA), nrow = 3)
        testthat::expect_equal(
          object = unname(
            obj = miHelper:::.CheckNorm(
              x = as.data.frame(x = x),
              iter = 1,
              prior = "ridge",
              ridge_df = 1
            )
          ),
          expected = x
        )
        testthat::expect_error(
          object = miHelper:::.CheckNorm(
            x = cbind(x, c(NA, NA, 1)),
            iter = 1,
            prior = "ridge",
            ridge_df = 1
          )
        )
        testthat::expect_error(
          object = miHelper:::.CheckNorm(
            x = x,
            iter = 1,
            prior = "flat",
            ridge_df = 1
          )
        )
      }
    )
  },
  text = "test-miHelper-norm-check"
)
