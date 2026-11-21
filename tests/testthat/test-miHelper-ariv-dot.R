## ---- test-miHelper-ariv-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "known value (k = 2)"),
      code = {
        # hand computation: the trace is 1, so ARIV is 2 * 1 / 2
        testthat::expect_equal(
          object = .ARIV(
            between = diag(x = 2),
            within = 2 * diag(x = 2),
            M = 1,
            k = 2
          ),
          expected = 1,
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "known value (k = 1)"),
      code = {
        # hand computation: 1.5 * 0.5 = 0.75
        testthat::expect_equal(
          object = .ARIV(
            between = matrix(data = 3),
            within = matrix(data = 6),
            M = 2,
            k = 1
          ),
          expected = 0.75,
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "no between-imputation variance"),
      code = {
        testthat::expect_equal(
          object = .ARIV(
            between = matrix(data = 0),
            within = matrix(data = 6),
            M = 5,
            k = 1
          ),
          expected = 0,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-ariv-dot",
  tol = 1e-8
)
