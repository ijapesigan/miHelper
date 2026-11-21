// -----------------------------------------------------------------------------
// edit .setup/cpp/miHelper-i-step-norm-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

//' I-Step of Data Augmentation for the Multivariate Normal (C++)
//'
//' Draws the missing values of each row from their conditional normal
//' distribution given the observed values,
//' \eqn{N \left( \mu_m + \Sigma_{mo} \Sigma_{oo}^{-1} (x_o - \mu_o),
//' \Sigma_{mm} - \Sigma_{mo} \Sigma_{oo}^{-1} \Sigma_{om} \right)}
//' (Schafer, 1997, Chapter 5).
//' The draws use R's random number generator (`set.seed()`).
//' Observed values are returned unchanged.
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
//' @return Numeric \eqn{n \times p} matrix without missing values.
//'
//' @noRd
// [[Rcpp::export(.IStepNorm)]]
arma::mat IStepNorm(const arma::mat& x, const arma::vec& mu,
                    const arma::mat& sigma, const arma::umat& obs,
                    const Rcpp::List& rows) {
  arma::mat out = x;
  for (arma::uword g = 0; g < obs.n_rows; g++) {
    const arma::uvec m = arma::find(obs.row(g).t() == 0);
    if (m.n_elem == 0) {
      continue;
    }
    const arma::uvec idx = Rcpp::as<arma::uvec>(rows[g]);
    const arma::uvec o = arma::find(obs.row(g).t() == 1);
    arma::mat beta;
    arma::mat cmm;
    if (o.n_elem > 0) {
      beta =
          arma::solve(sigma(o, o), sigma(o, m), arma::solve_opts::likely_sympd);
      cmm = sigma(m, m) - sigma(m, o) * beta;
    } else {
      cmm = sigma(m, m);
    }
    // symmetric square root; works for a singular conditional covariance
    arma::vec eigval;
    arma::mat eigvec;
    arma::eig_sym(eigval, eigvec, 0.5 * (cmm + cmm.t()));
    const arma::vec root_val =
        arma::sqrt(arma::clamp(eigval, 0.0, arma::datum::inf));
    const arma::mat root = eigvec * arma::diagmat(root_val);
    for (arma::uword r = 0; r < idx.n_elem; r++) {
      const arma::vec xi = x.row(idx(r)).t();
      arma::vec cmean = mu(m);
      if (o.n_elem > 0) {
        cmean += beta.t() * (xi(o) - mu(o));
      }
      arma::vec z(m.n_elem);
      for (arma::uword j = 0; j < m.n_elem; j++) {
        z(j) = R::norm_rand();
      }
      const arma::vec draw = cmean + root * z;
      for (arma::uword j = 0; j < m.n_elem; j++) {
        out(idx(r), m(j)) = draw(j);
      }
    }
  }
  return out;
}
