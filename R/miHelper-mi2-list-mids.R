#' @export
MI2List.mids <- function(object) {
  out <- mice::complete(
    data = object,
    action = "all"
  )
  out <- unclass(x = out)
  stats::setNames(
    object = out,
    nm = seq_along(along.with = out)
  )
}
