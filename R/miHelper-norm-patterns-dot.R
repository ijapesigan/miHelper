#' Missing-Data Patterns (Internal)
#'
#' Groups the rows of `x` by their missing-data pattern.
#' No input checks.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Numeric matrix with missing values.
#'
#' @return Returns a list with `obs`,
#'   an integer matrix with one row per pattern
#'   (1 for an observed and 0 for a missing variable),
#'   and `rows`, a list of the 0-based rows in each pattern.
#'
#' @examples
#' .NormPatterns(x = matrix(data = c(1, NA, 3, 4, 5, NA), nrow = 3))
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper mi internal
#' @noRd
.NormPatterns <- function(x) {
  obs <- 1L * !is.na(x = x)
  key <- apply(
    X = obs,
    MARGIN = 1,
    FUN = paste,
    collapse = ""
  )
  ukey <- unique(x = key)
  rows <- lapply(
    X = ukey,
    FUN = function(k) {
      which(x = key == k) - 1L
    }
  )
  list(
    obs = obs[match(x = ukey, table = key), , drop = FALSE],
    rows = rows
  )
}
