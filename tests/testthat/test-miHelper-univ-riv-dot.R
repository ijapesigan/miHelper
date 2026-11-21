## ---- test-miHelper-univ-riv-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "known value"),
      code = {
        testthat::expect_equal(
          object = .UnivRIV(between = 2, within = 4, M = 1),
          expected = 1,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-univ-riv-dot",
  tol = 1e-8
)
