#' Model Fitting on Imputed Data Sets
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class
#'   `mids` or `amelia`.
#' @param fit Object.
#'   Output of the model fitting functions
#'   (e.g., [lm()], [lavaan::lavaan()], [lavaan::cfa()], [lavaan::sem()]).
#'
#' @return Returns a list with the following elements:
#'   \describe{
#'     \item{`mi`}{Number of imputations..}
#'     \item{`fit`}{Combined estimates.}
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
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper fit
#' @noRd
.MIFitObject <- function(mi,
                         fit) {
  .MIFitList(
    x = MI2List(
      object = mi
    ),
    fit = fit
  )
}
