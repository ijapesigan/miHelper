#' @rdname MIFit
#' @name MIFit
#' @export
MIFit.data.frame <- function(x,
                             fit,
                             M = 5,
                             fun = "mice",
                             ...) {
  if (fun == "mice") {
    mi <- do.call(
      what = mice::mice,
      args = c(
        list(
          data = x,
          m = M,
          print = FALSE
        ),
        list(...)
      )
    )
  }
  if (fun == "amelia") {
    mi <- Amelia::amelia(
      x = x,
      m = M,
      p2s = 0,
      ...
    )
  }
  if (fun == "mcmcNorm") {
    # EM once (deterministic), then one data augmentation chain per imputation
    mat <- .CheckNorm(
      x = x,
      iter = 1,
      prior = "noninformative",
      ridge_df = 1
    )
    em <- .EMNorm(
      x = mat,
      patterns = .NormPatterns(x = mat)
    )
    x <- lapply(
      X = seq_len(length.out = M),
      FUN = function(i,
                     ...) {
        .ImpNorm(
          x = mat,
          em = em,
          ...
        )
      },
      ...
    )
  }
  if (fun == "mcmcNorm") {
    out <- .MIFitList(
      x = x,
      fit = fit
    )
  } else {
    out <- .MIFitObject(
      mi = mi,
      fit = fit
    )
  }
  out <- structure(
    .Data = out,
    class = c(
      "mifit",
      class(x = out)
    )
  )
  out
}
