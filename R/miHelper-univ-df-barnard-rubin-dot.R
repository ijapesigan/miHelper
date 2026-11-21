#' Barnard and Rubin Degrees of Freedom (Univariate)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param df_complete Positive integer.
#'   Degrees of freedom in case of complete data.
#' @param df_rubin Numeric.
#'   Degrees of freedom of Rubin (1987), see `.DFRubin()`.
#' @param rmi Numeric.
#'   Fraction of missing information.
#'
#' @return Returns a numeric vector of length one.
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.DFBarnardRubin <- function(df_complete,
                            df_rubin,
                            rmi) {
  1 / (
    (
      1 / df_rubin
    ) + (
      1 / (
        (
          df_complete * (
            df_complete + 1
          ) * (
            1 - rmi
          )
        ) / (
          df_complete + 3
        )
      )
    )
  )
}
