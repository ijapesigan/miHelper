#' @export
MI2List.norm <- function(object) {
  stopifnot(object$method == "MCMC")
  out <- object$imp.list
  out <- stats::setNames(
    object = out,
    nm = seq_along(along.with = out)
  )
  out <- lapply(
    X = out,
    FUN = as.data.frame
  )
  out
}
