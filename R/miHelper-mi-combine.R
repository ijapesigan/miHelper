#' Combine Multiple Imputation Estimates and Sampling Covariance Matrix
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @details The pooled vector of parameter estimates is given by
#'   \deqn{
#'     \bar{\boldsymbol{\theta}}
#'     =
#'     M^{-1}
#'     \sum_{m = 1}^{M}
#'     \hat{\boldsymbol{\theta}}_{m}
#'   }
#'   where \eqn{M} is the number of imputations,
#'   \eqn{m = \left\{ 1, 2, \cdots, M \right\}},
#'   and
#'   \eqn{\hat{\boldsymbol{\theta}}_{m}}
#'   is the vector of parameter estimates for the
#'   \eqn{m^{\mathrm{th}}}
#'   imputation.
#'
#'   The pooled or total sampling variance-covariance matrix
#'   consists of combining between and within imputation variances
#'   given by
#'   \deqn{
#'     \boldsymbol{V}_{\mathrm{within}}
#'     =
#'     M^{-1}
#'     \sum_{m = 1}^{M}
#'     \operatorname{Var}
#'     \left(
#'     \hat{\boldsymbol{\theta}}_{m}
#'     \right)
#'   }
#'
#'   \deqn{
#'     \boldsymbol{V}_{\mathrm{between}}
#'     =
#'     \left(
#'     M - 1
#'     \right)^{-1}
#'     \sum_{m = 1}^{M}
#'     \left(
#'     \hat{\boldsymbol{\theta}}_{m}
#'     -
#'     \bar{\boldsymbol{\theta}}
#'     \right)
#'     \left(
#'     \hat{\boldsymbol{\theta}}_{m}
#'     -
#'     \bar{\boldsymbol{\theta}}
#'     \right)^{\prime}
#'   }
#'
#'   \deqn{
#'     \boldsymbol{V}_{\mathrm{total}}
#'     =
#'     \boldsymbol{V}_{\mathrm{within}}
#'     +
#'     \boldsymbol{V}_{\mathrm{between}}
#'     +
#'     M^{-1}
#'     \boldsymbol{V}_{\mathrm{between}} .
#'   }
#'
#'   An alternative total variance was introduced by
#'   Li, Raghunathan, and Rubin (1991)
#'   and is given by
#'   \deqn{
#'     \tilde{\boldsymbol{V}}_{\mathrm{total}}
#'     =
#'     \left( 1 + \operatorname{ARIV} \right)
#'     \boldsymbol{V}_{\mathrm{within}}
#'   }
#'   where \eqn{\operatorname{ARIV}} is given by
#'   \deqn{
#'     \operatorname{ARIV}
#'     =
#'     \frac{
#'       \left( 1 + M^{-1} \right)
#'       \operatorname{tr}
#'       \left(
#'          \boldsymbol{V}_{\mathrm{between}}
#'          \boldsymbol{V}_{\mathrm{within}}^{-1}
#'       \right)
#'     }{
#'       k
#'     } .
#'   }
#'
#' @param object Object of class `mifit`,
#'   that is, the output of the `MIFit()` function.
#' @param adj Logical.
#'   If `adj = TRUE`,
#'   use Li, Raghunathan, and Rubin (1991) adjustment.
#'
#' @return Returns a list with the following elements:
#'   \describe{
#'     \item{`M`}{
#'       Number of imputations
#'       \eqn{M}.
#'     }
#'     \item{`est`}{
#'       Vector of pooled coefficients/parameter estimates
#'       \eqn{\bar{\boldsymbol{\theta}}}.
#'     }
#'     \item{`within`}{
#'       Covariance within imputations
#'       \eqn{\boldsymbol{V}_{\mathrm{within}}}.
#'     }
#'     \item{`between`}{
#'       Covariance between imputations
#'       \eqn{\boldsymbol{V}_{\mathrm{between}}}.
#'     }
#'     \item{`total`}{
#'       Total covariance matrix
#'       \eqn{\boldsymbol{V}_{\mathrm{total}}}.
#'     }
#'     \item{`ariv`}{
#'       Average relative increase in variance (`NA` if `adj = FALSE`).
#'     }
#'     \item{`total_adj`}{
#'       Adjusted total covariance matrix
#'       \eqn{\tilde{\boldsymbol{V}}_{\mathrm{total}}}
#'       (`NA` if `adj = FALSE`).
#'     }
#'   }
#'
#' @references
#'   Li, K. H., Raghunathan, T. E., & Rubin, D. B. (1991).
#'   Large-sample significance levels from multiply imputed data
#'   using moment-based statistics and an F reference distribution.
#'   *Journal of the American Statistical Association*,
#'   86 (416), 1065--1073.
#'   \doi{10.1080/01621459.1991.10475152}
#'
#'   Rubin, D. B. (1987).
#'   *Multiple imputation for nonresponse in surveys*.
#'   John Wiley & Sons, Inc.
#'   \doi{10.1002/9780470316696}
#'
#' @examples
#' fit <- lm(Temp ~ ., data = airquality)
#' set.seed(42)
#' mifit <- MIFit(
#'   x = airquality,
#'   fit = fit,
#'   fun = "mice",
#'   M = 3
#' )
#' MICombine(mifit)
#' MICombine(mifit, adj = TRUE)
#'
#' @export
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper combine
MICombine <- function(object,
                      adj = FALSE) {
  stopifnot(
    methods::is(
      object = object,
      class2 = "mifit"
    )
  )
  mi <- .MIExtract(
    object = object
  )
  .MICombine(
    coefs = mi$coefs,
    vcovs = mi$vcovs,
    M = mi$M,
    k = mi$k,
    adj = adj
  )
}
