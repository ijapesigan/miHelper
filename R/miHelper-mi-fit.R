#' Model Fitting on Imputed Data Sets
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object.
#' @param fit Object.
#'   Output of the model fitting functions
#'   (e.g., [lm()], [lavaan::lavaan()], [lavaan::cfa()], [lavaan::sem()]).
#' @param M Positive integer.
#'   Number of imputations
#'   for `MIFit.data.frame()`.
#' @param fun Character string.
#'   Select function to use for multiple imputation
#'   for `MIFit.data.frame()`.
#'   Valid values include
#'   "mice" for [mice::mice()],
#'   "amelia" for [Amelia::amelia()], and
#'   "mcmcNorm" for the multivariate normal model:
#'   EM, then data augmentation (Schafer, 1997), in C++ in this package.
#' @param ... Additional arguments
#'   for `MIFit.data.frame()` to pass to `fun`.
#'   For "mcmcNorm": `iter`, the number of data augmentation cycles
#'   per imputation (default 1000);
#'   `prior`, `"noninformative"` (default) or `"ridge"`;
#'   and `ridge_df`, the degrees of freedom of the ridge prior
#'   (default 1).
#'
#' @return Returns an object of class `mifit`
#'   which is a list with the following elements:
#'   \describe{
#'     \item{`mi`}{Multiply imputed data sets.}
#'     \item{`fit`}{List of models fitted on each imputed data set.}
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
#'   Schafer, J. L. (1997).
#'   *Analysis of incomplete multivariate data*.
#'   Chapman & Hall/CRC.
#'   \doi{10.1201/9780367803025}
#'
#'   Rubin, D. B. (1987).
#'   *Multiple imputation for nonresponse in surveys*.
#'   John Wiley & Sons, Inc.
#'   \doi{10.1002/9780470316696}
#'
#' @examples
#' fit <- lm(Temp ~ ., data = airquality)
#'
#' # mice --------------------------------------
#' set.seed(42)
#' MIFit(
#'   x = airquality,
#'   fit = fit,
#'   fun = "mice",
#'   M = 3
#' )
#'
#' # list of imputed data sets -----------------
#' mids <- mice::mice(airquality, m = 3, print = FALSE)
#' MIFit(
#'   x = MI2List(mids),
#'   fit = fit
#' )
#'
#' @export
#' @family Multiple Imputation Helper Functions
#' @keywords miHelper fit
MIFit <- function(x,
                  ...) {
  UseMethod(generic = "MIFit")
}
