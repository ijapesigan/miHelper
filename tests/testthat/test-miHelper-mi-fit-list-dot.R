## ---- test-miHelper-mi-fit-list-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::skip_on_cran()
    data <- .TestImputed()
    d <- data[[1]]
    fit <- stats::lm(
      formula = mpg ~ wt + hp,
      data = d
    )
    out <- .MIFitList(
      x = data,
      fit = fit
    )
    testthat::test_that(
      desc = paste(text, "structure"),
      code = {
        testthat::expect_named(
          object = out,
          expected = c("mi", "fit")
        )
        testthat::expect_identical(
          object = out$mi,
          expected = data
        )
        testthat::expect_length(
          object = out$fit,
          n = 3
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "the model is refitted on each data set"),
      code = {
        lapply(
          X = seq_along(along.with = data),
          FUN = function(j,
                         tol) {
            testthat::expect_equal(
              object = stats::coef(object = out$fit[[j]]),
              expected = stats::coef(
                object = stats::lm(
                  formula = mpg ~ wt + hp,
                  data = data[[j]]
                )
              ),
              tolerance = tol
            )
          },
          tol = tol
        )
      }
    )
  },
  text = "test-miHelper-mi-fit-list-dot",
  tol = 1e-8
)
