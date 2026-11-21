## ---- test-external-miHelper-em-norm
# Run by hand: needs norm2 (archived on CRAN), for example in .library.
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    message(text)
    testthat::test_that(
      desc = paste(text, "agrees with norm2::emNorm()"),
      code = {
        testthat::skip_if_not_installed(pkg = "norm2")
        set.seed(seed = 42)
        n <- 300
        z <- matrix(data = stats::rnorm(n = n * 3), ncol = 3)
        x <- z %*% chol(
          x = matrix(
            data = c(1, 0.5, 0.3, 0.5, 1, 0.4, 0.3, 0.4, 1),
            nrow = 3
          )
        )
        x[stats::runif(n = n) < 0.2, 2] <- NA
        x[x[, 1] > 0.8, 3] <- NA
        colnames(x = x) <- c("a", "b", "c")
        for (y in list(x, as.matrix(x = datasets::airquality[, 1:4]))) {
          ours <- miHelper:::.EMNorm(
            x = y,
            patterns = miHelper:::.NormPatterns(x = y),
            criterion = 1e-10
          )
          theirs <- norm2::emNorm(
            obj = y,
            iter.max = 10000,
            criterion = 1e-10
          )
          testthat::expect_equal(
            object = unname(obj = ours$mu),
            expected = unname(obj = as.vector(x = theirs$param$beta)),
            tolerance = 1e-6
          )
          testthat::expect_equal(
            object = unname(obj = ours$sigma),
            expected = unname(obj = theirs$param$sigma),
            tolerance = 1e-6
          )
        }
      }
    )
  },
  text = "test-external-miHelper-em-norm"
)
