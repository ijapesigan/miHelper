## ---- test-miHelper-mi-combine-dot
lapply(
  X = 1,
  FUN = function(i,
                 text,
                 tol) {
    pieces <- .TestCoefs()
    testthat::test_that(
      desc = paste(text, "known values (M = 2, k = 2)"),
      code = {
        out <- .MICombine(
          coefs = pieces$coefs,
          vcovs = pieces$vcovs,
          M = 2,
          k = 2
        )
        testthat::expect_equal(
          object = out$M,
          expected = 2
        )
        testthat::expect_equal(
          object = out$est,
          expected = c(a = 2, b = 2),
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out$within),
          expected = 2 * diag(x = 2),
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out$between),
          expected = diag(x = c(2, 0)),
          tolerance = tol
        )
        # hand computation: the total is diag(5, 2)
        testthat::expect_equal(
          object = unname(obj = out$total),
          expected = diag(x = c(5, 2)),
          tolerance = tol
        )
        testthat::expect_identical(
          object = rownames(x = out$between),
          expected = c("a", "b")
        )
        testthat::expect_true(
          object = is.na(x = out$ariv) && is.na(x = out$total_adj)
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "adjustment"),
      code = {
        out <- .MICombine(
          coefs = pieces$coefs,
          vcovs = pieces$vcovs,
          M = 2,
          k = 2,
          adj = TRUE
        )
        # hand computation: 1.5 * 1 / 2 = 0.75
        testthat::expect_equal(
          object = out$ariv,
          expected = 0.75,
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out$total_adj),
          expected = 1.75 * 2 * diag(x = 2),
          tolerance = tol
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 1"),
      code = {
        out <- .MICombine(
          coefs = list(1, 3),
          vcovs = list(matrix(data = 1), matrix(data = 3)),
          M = 2,
          k = 1
        )
        testthat::expect_equal(
          object = unname(obj = out$est),
          expected = 2,
          tolerance = tol
        )
        # hand computation: the total is 5
        testthat::expect_equal(
          object = as.numeric(x = out$total),
          expected = 5,
          tolerance = tol
        )
      }
    )
  },
  text = "test-miHelper-mi-combine-dot",
  tol = 1e-8
)
