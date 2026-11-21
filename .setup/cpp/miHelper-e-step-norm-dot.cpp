// -----------------------------------------------------------------------------
// edit .setup/cpp/miHelper-e-step-norm-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' E-Step of EM for the Multivariate Normal with Missing Data (C++)
//'
//' Returns the expected complete-data sufficient statistics
//' \eqn{T_1 = \sum_i \hat{x}_i} and
//' \eqn{T_2 = \sum_i \left( \hat{x}_i \hat{x}_i^{\prime} + C_i \right)},
//' where \eqn{\hat{x}_i} fills the missing part of row \eqn{i}
//' with \eqn{\mu_m + \Sigma_{mo} \Sigma_{oo}^{-1} (x_o - \mu_o)}
//' and \eqn{C_i} holds
//' \eqn{\Sigma_{mm} - \Sigma_{mo} \Sigma_{oo}^{-1} \Sigma_{om}}
//' in the missing block (Schafer, 1997, Chapter 5).
//' The regression is computed once per missing-data pattern.
//'
//' @author Ivan Jacob Agaloos Pesigan
//'
//' @param x Numeric \eqn{n \times p} matrix with missing values.
//' @param mu Numeric vector of length \eqn{p}. Mean vector.
//' @param sigma Numeric \eqn{p \times p} matrix. Covariance matrix.
//' @param obs Integer matrix, one row per pattern,
//'   1 for an observed and 0 for a missing variable.
//' @param rows List of integer vectors.
//'   0-based rows of `x` in each pattern.
//'
//' @return List with `t1` (vector) and `t2` (matrix).
//'
//' @noRd
// [[Rcpp::export(.EStepNorm)]]
Rcpp::List EStepNorm(const arma::mat& x, const arma::vec& mu,
                     const arma::mat& sigma, const arma::umat& obs,
                     const Rcpp::List& rows) {
  const arma::uword p = x.n_cols;
  arma::vec t1(p, arma::fill::zeros);
  arma::mat t2(p, p, arma::fill::zeros);
  for (arma::uword g = 0; g < obs.n_rows; g++) {
    const arma::uvec idx = Rcpp::as<arma::uvec>(rows[g]);
    const arma::uvec o = arma::find(obs.row(g).t() == 1);
    const arma::uvec m = arma::find(obs.row(g).t() == 0);
    arma::mat beta;
    arma::mat cmm;
    if (m.n_elem > 0) {
      if (o.n_elem > 0) {
        // regression of the missing on the observed variables
        beta = arma::solve(sigma(o, o), sigma(o, m),
                           arma::solve_opts::likely_sympd);
        cmm = sigma(m, m) - sigma(m, o) * beta;
      } else {
        cmm = sigma(m, m);
      }
    }
    for (arma::uword r = 0; r < idx.n_elem; r++) {
      arma::vec xi = x.row(idx(r)).t();
      if (m.n_elem > 0) {
        if (o.n_elem > 0) {
          xi(m) = mu(m) + beta.t() * (xi(o) - mu(o));
        } else {
          xi(m) = mu(m);
        }
        t2(m, m) += cmm;
      }
      t1 += xi;
      t2 += xi * xi.t();
    }
  }
  return Rcpp::List::create(Rcpp::Named("t1") = t1, Rcpp::Named("t2") = t2);
}
