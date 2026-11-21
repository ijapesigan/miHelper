## ---- test-miHelper-total-adj-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::test_that(
      desc = paste(text, "known value"),
      code = {
        within <- matrix(data = c(2, 1, 1, 2), nrow = 2)
        testthat::expect_equal(
          object = .TotalAdj(
            ariv = 0.5,
            within = within
          ),
          expected = 1.5 * within,
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "ariv = 0 returns within"),
      code = {
        within <- matrix(data = 4)
        testthat::expect_equal(
          object = .TotalAdj(
            ariv = 0,
            within = within
          ),
          expected = within,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-total-adj-dot",
  tol = 1e-8
)
