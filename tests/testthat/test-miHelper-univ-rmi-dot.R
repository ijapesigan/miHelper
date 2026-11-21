## ---- test-miHelper-univ-rmi-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "known value"),
      code = {
        testthat::expect_equal(
          object = .UnivRMI(riv = 1),
          expected = 0.5,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-univ-rmi-dot",
  tol = 1e-8
)
