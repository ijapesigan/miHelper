## ---- test-miHelper-mi-fit
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::skip_on_cran()
    data <- .TestMissing()
    fit <- stats::lm(
      formula = y ~ x1 + x2,
      data = data
    )
    testthat::test_that(
      desc = paste(text, "list"),
      code = {
        imputed <- .TestImputed()
        d <- imputed[[1]]
        object <- stats::lm(
          formula = mpg ~ wt + hp,
          data = d
        )
        out <- MIFit(
          x = imputed,
          fit = object
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_length(
          object = out$fit,
          n = 3
        )
        testthat::expect_equal(
          object = stats::coef(object = out$fit[[3]]),
          expected = stats::coef(
            object = stats::lm(
              formula = mpg ~ wt + hp,
              data = imputed[[3]]
            )
          ),
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "data.frame, mice"),
      code = {
        testthat::skip_if_not_installed(pkg = "mice")
        out <- MIFit(
          x = data,
          fit = fit,
          M = 3,
          fun = "mice"
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_length(
          object = out$fit,
          n = 3
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "data.frame, amelia"),
      code = {
        testthat::skip_if_not_installed(pkg = "Amelia")
        out <- MIFit(
          x = data,
          fit = fit,
          M = 2,
          fun = "amelia"
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_length(
          object = out$fit,
          n = 2
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "data.frame, mcmcNorm"),
      code = {
        out <- MIFit(
          x = data,
          fit = fit,
          M = 2,
          fun = "mcmcNorm"
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_length(
          object = out$fit,
          n = 2
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "mids"),
      code = {
        testthat::skip_if_not_installed(pkg = "mice")
        mids <- mice::mice(
          data = data,
          m = 2,
          print = FALSE,
          seed = 42
        )
        out <- MIFit(
          x = mids,
          fit = fit
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_equal(
          object = stats::coef(object = out$fit[[1]]),
          expected = stats::coef(
            object = stats::lm(
              formula = y ~ x1 + x2,
              data = mice::complete(
                data = mids,
                action = 1
              )
            )
          ),
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "amelia object"),
      code = {
        testthat::skip_if_not_installed(pkg = "Amelia")
        amelia <- Amelia::amelia(
          x = data,
          m = 2,
          p2s = 0
        )
        out <- MIFit(
          x = amelia,
          fit = fit
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_length(
          object = out$fit,
          n = 2
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "norm object"),
      code = {
        norm <- .TestNormObject(data = data)
        out <- MIFit(
          x = norm,
          fit = fit
        )
        testthat::expect_s3_class(
          object = out,
          class = "mifit"
        )
        testthat::expect_length(
          object = out$fit,
          n = 2
        )
      }
    )
  },
  text = "test-miHelper-mi-fit",
  tol = 1e-6
)
