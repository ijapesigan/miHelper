## ---- test-miHelper-univ-df-barnard-rubin-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "known value"),
      code = {
        testthat::expect_equal(
          object = .DFBarnardRubin(df_complete = 1, df_rubin = 8, rmi = 0.5),
          expected = 1 / 4.125,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-univ-df-barnard-rubin-dot",
  tol = 1e-8
)
