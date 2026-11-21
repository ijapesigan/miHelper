## ---- test-miHelper-nu-2-reiter-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::test_that(
      desc = paste(text, "finite and above four"),
      code = {
        out <- .Nu2Reiter(
          M = 10,
          k = 2,
          ariv = 0.5,
          df_complete = 100
        )
        testthat::expect_length(
          object = out,
          n = 1
        )
        testthat::expect_true(
          object = is.finite(x = out) && out > 4
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "increases with the complete-data degrees of freedom"),
      code = {
        small <- .Nu2Reiter(
          M = 10,
          k = 2,
          ariv = 0.5,
          df_complete = 50
        )
        large <- .Nu2Reiter(
          M = 10,
          k = 2,
          ariv = 0.5,
          df_complete = 500
        )
        testthat::expect_true(
          object = large > small
        )
      }
    )
  },
  text = "test-miHelper-nu-2-reiter-dot"
)
