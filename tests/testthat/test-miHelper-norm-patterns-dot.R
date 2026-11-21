## ---- test-miHelper-norm-patterns-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "patterns and 0-based rows"),
      code = {
        x <- matrix(data = c(1, NA, 3, NA, 4, 5, NA, 7), nrow = 4)
        out <- miHelper:::.NormPatterns(x = x)
        testthat::expect_equal(
          object = out$obs,
          expected = matrix(data = c(1L, 0L, 1L, 1L, 1L, 0L), nrow = 3)
        )
        testthat::expect_equal(
          object = out$rows,
          expected = list(0L, c(1L, 3L), 2L)
        )
      }
    )
  },
  text = "test-miHelper-norm-patterns-dot"
)
