// -----------------------------------------------------------------------------
// edit .setup/cpp/000-forward-declarations.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>

Rcpp::List EStepNorm(const arma::mat& x, const arma::vec& mu,
                     const arma::mat& sigma, const arma::umat& obs,
                     const Rcpp::List& rows);

arma::mat IStepNorm(const arma::mat& x, const arma::vec& mu,
                    const arma::mat& sigma, const arma::umat& obs,
                    const Rcpp::List& rows);

Rcpp::List PStepNorm(const arma::mat& y, const double ridge_df,
                     const arma::vec& ridge_diag);
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
