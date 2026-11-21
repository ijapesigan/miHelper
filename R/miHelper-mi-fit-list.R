#' @rdname MIFit
#' @name MIFit
#' @export
MIFit.list <- function(x,
                       fit,
                       ...) {
  out <- .MIFitList(
    x = x,
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
