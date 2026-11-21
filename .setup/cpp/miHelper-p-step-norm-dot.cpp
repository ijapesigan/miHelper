// -----------------------------------------------------------------------------
// edit .setup/cpp/miHelper-p-step-norm-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' P-Step of Data Augmentation for the Multivariate Normal (C++)
//'
//' Draws \eqn{\Sigma} and \eqn{\mu} from their complete-data posterior
//' (Schafer, 1997, Chapter 5):
//' \eqn{\Sigma \mid Y \sim W^{-1} \left( n - 1 + \nu,
//' S + \nu D \right)} and
//' \eqn{\mu \mid \Sigma, Y \sim N \left( \bar{y}, \Sigma / n \right)},
//' where \eqn{S} is the matrix of centered sums of squares and products,
//' \eqn{\nu} is `ridge_df`, and \eqn{D} is `diag(ridge_diag)`.
//' With \eqn{\nu = 0} the prior is noninformative
//' (\eqn{\pi(\mu, \Sigma) \propto |\Sigma|^{-(p + 1) / 2}});
//' with \eqn{\nu > 0} it is the ridge prior,
//' which shrinks the correlations toward zero.
//' The inverse Wishart draw uses the Bartlett decomposition
//' and R's random number generator (`set.seed()`).
//'
//' @author Ivan Jacob Agaloos Pesigan
//'
//' @param y Numeric \eqn{n \times p} matrix. Completed data.
//' @param ridge_df Numeric. Prior degrees of freedom \eqn{\nu}.
//' @param ridge_diag Numeric vector of length \eqn{p}.
//'   Diagonal of \eqn{D}.
//'
//' @return List with `mu` (vector) and `sigma` (matrix).
//'
//' @noRd
// [[Rcpp::export(.PStepNorm)]]
Rcpp::List PStepNorm(const arma::mat& y, const double ridge_df,
                     const arma::vec& ridge_diag) {
  const arma::uword n = y.n_rows;
  const arma::uword p = y.n_cols;
  const arma::rowvec ybar = arma::mean(y, 0);
  const arma::mat yc = y.each_row() - ybar;
  arma::mat scale = yc.t() * yc;
  if (ridge_df > 0.0) {
    scale.diag() += ridge_df * ridge_diag;
  }
  const double df = static_cast<double>(n) - 1.0 + ridge_df;
  // W ~ Wishart(df, scale^{-1}) by the Bartlett decomposition: W = L A A' L'
  const arma::mat l =
      arma::chol(arma::inv_sympd(0.5 * (scale + scale.t())), "lower");
  arma::mat a(p, p, arma::fill::zeros);
  for (arma::uword i = 0; i < p; i++) {
    a(i, i) = std::sqrt(R::rchisq(df - static_cast<double>(i)));
    for (arma::uword j = 0; j < i; j++) {
      a(i, j) = R::norm_rand();
    }
  }
  const arma::mat la = l * a;
  const arma::mat w = la * la.t();
  arma::mat sigma = arma::inv_sympd(0.5 * (w + w.t()));
  sigma = 0.5 * (sigma + sigma.t());
  arma::vec z(p);
  for (arma::uword j = 0; j < p; j++) {
    z(j) = R::norm_rand();
  }
  const double root_n = std::sqrt(static_cast<double>(n));
  const arma::vec mu = ybar.t() + arma::chol(sigma, "lower") * z / root_n;
  return Rcpp::List::create(Rcpp::Named("mu") = mu,
                            Rcpp::Named("sigma") = sigma);
}
