## ---- test-miHelper-univ-df-rubin-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "known value"),
      code = {
        testthat::expect_equal(
          object = .DFRubin(rmi = 0.5, M = 3),
          expected = 8,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-univ-df-rubin-dot",
  tol = 1e-8
)
