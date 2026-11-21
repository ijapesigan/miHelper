## ---- test-miHelper-nu-2-li-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "k * (M - 1) <= 4"),
      code = {
        # hand computation, x = 1: 4
        testthat::expect_equal(
          object = .Nu2Li(
            M = 2,
            k = 1,
            ariv = 1
          ),
          expected = 4,
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k * (M - 1) > 4"),
      code = {
        # hand computation, x = 5: 6.56
        testthat::expect_equal(
          object = .Nu2Li(
            M = 6,
            k = 1,
            ariv = 1
          ),
          expected = 6.56,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-nu-2-li-dot",
  tol = 1e-8
)
