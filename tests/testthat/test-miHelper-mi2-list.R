## ---- test-miHelper-mi2-list
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    data <- .TestMissing()
    testthat::test_that(
      desc = paste(text, "mids"),
      code = {
        testthat::skip_if_not_installed(pkg = "mice")
        mids <- mice::mice(
          data = data,
          m = 3,
          print = FALSE,
          seed = 42
        )
        out <- MI2List(object = mids)
        testthat::expect_type(
          object = out,
          type = "list"
        )
        testthat::expect_named(
          object = out,
          expected = c("1", "2", "3")
        )
        testthat::expect_identical(
          object = out[[2]],
          expected = mice::complete(
            data = mids,
            action = 2
          )
        )
        testthat::expect_false(
          object = anyNA(x = out[[1]])
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "amelia"),
      code = {
        testthat::skip_if_not_installed(pkg = "Amelia")
        amelia <- Amelia::amelia(
          x = data,
          m = 2,
          p2s = 0
        )
        out <- MI2List(object = amelia)
        testthat::expect_named(
          object = out,
          expected = c("1", "2")
        )
        testthat::expect_false(
          object = anyNA(x = out[[1]])
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "norm"),
      code = {
        norm <- .TestNormObject(data = data)
        out <- MI2List(object = norm)
        testthat::expect_length(
          object = out,
          n = 2
        )
        testthat::expect_s3_class(
          object = out[[1]],
          class = "data.frame"
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "norm requires MCMC"),
      code = {
        em <- .TestNormObject(data = data, method = "EM")
        testthat::expect_error(
          object = MI2List(object = em)
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "unsupported input"),
      code = {
        testthat::expect_error(
          object = MI2List(object = 1),
          regexp = "not supported"
        )
      }
    )
  },
  text = "test-miHelper-mi2-list"
)
