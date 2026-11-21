#' @rdname MIFit
#' @name MIFit
#' @export
MIFit.norm <- function(x,
                       fit,
                       ...) {
  out <- .MIFitObject(
    mi = x,
    fit = fit
  )
  out <- structure(
    .Data = out,
    class = c(
      "mifit",
      class(x = out)
    )
  )
  out
}
