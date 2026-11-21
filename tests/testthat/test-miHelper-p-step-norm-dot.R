## ---- test-miHelper-p-step-norm-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "posterior means of mu and sigma"),
      code = {
        set.seed(seed = 3)
        y <- as.matrix(x = datasets::mtcars[, c("mpg", "wt", "qsec")])
        n <- nrow(x = y)
        p <- ncol(x = y)
        draws <- replicate(
          n = 4000,
          expr = miHelper:::.PStepNorm(
            y = y,
            ridge_df = 0,
            ridge_diag = rep(x = 1, times = p)
          ),
          simplify = FALSE
        )
        s <- crossprod(x = scale(x = y, scale = FALSE))
        sigma_mean <- Reduce(
          f = `+`,
          x = lapply(X = draws, FUN = `[[`, "sigma")
        ) / length(x = draws)
        testthat::expect_equal(
          object = sigma_mean,
          expected = unname(obj = s / (n - 1 - p - 1)),
          tolerance = 0.05
        )
        mu_mean <- rowMeans(
          x = vapply(
            X = draws,
            FUN = function(d) {
              as.vector(x = d$mu)
            },
            FUN.VALUE = numeric(length = p)
          )
        )
        testthat::expect_equal(
          object = mu_mean,
          expected = unname(obj = colMeans(x = y)),
          tolerance = 0.01
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "the ridge prior shrinks the correlation"),
      code = {
        set.seed(seed = 4)
        y <- as.matrix(x = datasets::mtcars[1:8, c("mpg", "wt")])
        r <- function(nu) {
          mean(
            x = replicate(
              n = 2000,
              expr = stats::cov2cor(
                V = miHelper:::.PStepNorm(
                  y = y,
                  ridge_df = nu,
                  ridge_diag = apply(X = y, MARGIN = 2, FUN = stats::var)
                )$sigma
              )[1, 2]
            )
          )
        }
        testthat::expect_lt(
          object = abs(x = r(nu = 20)),
          expected = abs(x = r(nu = 0))
        )
      }
    )
  },
  text = "test-miHelper-p-step-norm-dot"
)
