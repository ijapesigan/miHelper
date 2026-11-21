#' @export
MI2List.amelia <- function(object) {
  out <- object$imputations
  out <- unclass(x = out)
  stats::setNames(
    object = out,
    nm = seq_along(along.with = out)
  )
}
