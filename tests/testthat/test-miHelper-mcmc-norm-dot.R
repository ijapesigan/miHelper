## ---- test-miHelper-mcmc-norm-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "set.seed repeats; the draws center on EM"),
      code = {
        x <- as.matrix(x = datasets::airquality[, 1:4])
        pat <- miHelper:::.NormPatterns(x = x)
        em <- miHelper:::.EMNorm(x = x, patterns = pat)
        set.seed(seed = 5)
        a <- miHelper:::.MCMCNorm(x = x, patterns = pat, start = em, iter = 50)
        set.seed(seed = 5)
        b <- miHelper:::.MCMCNorm(x = x, patterns = pat, start = em, iter = 50)
        testthat::expect_identical(object = a, expected = b)
        testthat::expect_equal(
          object = names(x = a$mu),
          expected = colnames(x = x)
        )
        draws <- vapply(
          X = 1:200,
          FUN = function(i) {
            miHelper:::.MCMCNorm(
              x = x,
              patterns = pat,
              start = em,
              iter = 2
            )$mu
          },
          FUN.VALUE = numeric(length = 4)
        )
        testthat::expect_equal(
          object = unname(obj = rowMeans(x = draws)),
          expected = unname(obj = em$mu),
          tolerance = 0.02
        )
        testthat::expect_no_error(
          object = miHelper:::.MCMCNorm(
            x = x,
            patterns = pat,
            start = em,
            iter = 5,
            prior = "ridge",
            ridge_df = 2
          )
        )
      }
    )
  },
  text = "test-miHelper-mcmc-norm-dot"
)
