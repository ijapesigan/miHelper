#' Degrees of Freedom of the Reference F Distribution (Reiter, 2007)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @details Denominator degrees of freedom
#'   of the F reference distribution
#'   for the multiparameter test
#'   with a small-sample adjustment for complete-data degrees of freedom.
#'
#' @param M Positive integer.
#'   Number of imputations.
#' @param k Positive integer.
#'   Number of parameters.
#' @param ariv Numeric.
#'   Average relative increase in variance.
#' @param df_complete Positive integer.
#'   Degrees of freedom in case of complete data.
#'
#' @return Returns a numeric vector of length one.
#'
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
#' @noRd
.Nu2Reiter <- function(M,
                       k,
                       ariv,
                       df_complete) {
  nustar_complete <- (
    (df_complete + 1) / (df_complete + 3)
  ) * df_complete
  q <- k * (M - 1)
  a <- (
    ariv * q
  ) / (
    q - 2
  )
  # common terms
  tmp1 <- 1 / (q - 4)
  tmp2 <- a^2
  tmp3 <- 1 + a
  tmp4 <- nustar_complete - 4 * (1 + a)
  tmp5 <- nustar_complete - 2 * (1 + a)
  z <- (
    1 / tmp4
  ) + (
    (
      tmp1
    ) * (
      (
        tmp2 * tmp5
      ) / (
        (
          tmp3^2
        ) * tmp4
      )
    )
  ) + (
    tmp1 * (
      (
        8 * tmp2 * tmp5
      ) / (
        tmp3 * tmp4^2
      ) + (
        (4 * tmp2) / (
          tmp3 * tmp4
        )
      )
    )
  ) + (
    tmp1 * (
      (
        (4 * tmp2) / (
          tmp4 * tmp5
        )
      ) + (
        (16 * tmp2 * tmp5) / (
          tmp3 * tmp4
        )
      )
    )
  ) + (
    tmp1 * (
      (8 * tmp2) / (
        tmp4^2
      )
    )
  )
  4 + (
    1 / z
  )
}
