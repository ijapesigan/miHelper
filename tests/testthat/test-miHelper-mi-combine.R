## ---- test-miHelper-mi-combine
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    testthat::skip_on_cran()
    testthat::test_that(
      desc = paste(text, "pooled lm equals the average"),
      code = {
        imputed <- .TestImputed()
        d <- imputed[[1]]
        object <- stats::lm(
          formula = mpg ~ wt + hp,
          data = d
        )
        out <- MICombine(
          object = MIFit(
            x = imputed,
            fit = object
          )
        )
        coefs <- do.call(
          what = "rbind",
          args = lapply(
            X = imputed,
            FUN = function(d) {
              stats::coef(
                object = stats::lm(
                  formula = mpg ~ wt + hp,
                  data = d
                )
              )
            }
          )
        )
        testthat::expect_equal(
          object = out$est,
          expected = colMeans(x = coefs),
          tolerance = tol
        )
        testthat::expect_equal(
          object = out$M,
          expected = 3
        )
        testthat::expect_equal(
          object = dim(x = out$total),
          expected = c(3, 3)
        )
        testthat::expect_true(
          object = isSymmetric(object = unname(obj = out$total), tol = 1e-8)
        )
        testthat::expect_true(
          object = is.na(x = out$ariv)
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "adjustment"),
      code = {
        imputed <- .TestImputed()
        d <- imputed[[1]]
        object <- stats::lm(
          formula = mpg ~ wt + hp,
          data = d
        )
        out <- MICombine(
          object = MIFit(
            x = imputed,
            fit = object
          ),
          adj = TRUE
        )
        testthat::expect_true(
          object = out$ariv > 0
        )
        testthat::expect_equal(
          object = out$total_adj,
          expected = (1 + out$ariv) * out$within,
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "close to complete data (MCAR)"),
      code = {
        testthat::skip_if_not_installed(pkg = "mice")
        n <- 500L
        set.seed(seed = 42)
        x1 <- stats::rnorm(n = n)
        x2 <- stats::rnorm(n = n)
        y <- 0.5 * x1 + 0.5 * x2 + stats::rnorm(n = n)
        complete <- data.frame(y = y, x1 = x1, x2 = x2)
        x1[sample.int(n = n, size = 10)] <- NA
        x2[sample.int(n = n, size = 10)] <- NA
        missing <- data.frame(y = y, x1 = x1, x2 = x2)
        object <- stats::lm(
          formula = y ~ .,
          data = missing
        )
        mi <- MICombine(
          object = MIFit(
            x = missing,
            fit = object,
            M = 10,
            fun = "mice"
          ),
          adj = TRUE
        )
        object_complete <- stats::lm(
          formula = y ~ .,
          data = complete
        )
        testthat::expect_true(
          object = all(
            abs(x = mi$est - stats::coef(object = object_complete)) <= 0.05
          )
        )
        testthat::expect_true(
          object = all(
            abs(x = mi$total - stats::vcov(object = object_complete)) <= 0.01
          )
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "lavaan"),
      code = {
        imputed <- .TestImputed()
        d <- imputed[[1]]
        object <- lavaan::sem(
          model = "mpg ~ wt + hp",
          data = d
        )
        out <- MICombine(
          object = MIFit(
            x = imputed,
            fit = object
          )
        )
        testthat::expect_equal(
          object = out$M,
          expected = 3
        )
        testthat::expect_equal(
          object = length(x = out$est),
          expected = length(x = lavaan::coef(object = object))
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "requires an object of class mifit"),
      code = {
        testthat::expect_error(
          object = MICombine(object = list())
        )
      }
    )
  },
  text = "test-miHelper-mi-combine",
  tol = 1e-6
)
