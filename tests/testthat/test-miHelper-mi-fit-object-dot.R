## ---- test-miHelper-mi-fit-object-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    testthat::skip_if_not_installed(pkg = "mice")
    data <- .TestMissing()
    mids <- mice::mice(
      data = data,
      m = 2,
      print = FALSE,
      seed = 42
    )
    fit <- stats::lm(
      formula = y ~ x1 + x2,
      data = data
    )
    out <- .MIFitObject(
      mi = mids,
      fit = fit
    )
    testthat::test_that(
      desc = paste(text, "structure"),
      code = {
        testthat::expect_named(
          object = out,
          expected = c("mi", "fit")
        )
        testthat::expect_length(
          object = out$mi,
          n = 2
        )
        testthat::expect_length(
          object = out$fit,
          n = 2
        )
        testthat::expect_s3_class(
          object = out$fit[[1]],
          class = "lm"
        )
      }
    )
  },
  text = "test-miHelper-mi-fit-object-dot"
)
