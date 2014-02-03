\name{marko_vcov}
\alias{marko_vcov}
\title{Estimate Markowitz Portfolio}
\usage{
marko_vcov(X,feat=NULL,vcov.func=vcov,fit.intercept=TRUE,weights=NULL,Jmat=NULL,Gmat=NULL)
}
\arguments{
  \item{X}{an \eqn{n \times p}{n x p} matrix of observed
  returns.}

  \item{feat}{an \eqn{n \times f}{n x f} matrix of observed
  features. defaults to none, in which case
  \code{fit.intercept} must be \code{TRUE}. If
  \code{fit.intercept} is true, ones will be prepended to
  the features.}

  \item{weights}{an optional \eqn{n} vector of the weights.
  The returns and features will be multiplied by the
  weights. Weights should be inverse volatility estimates.
  Defaults to homoskedasticity.}

  \item{Jmat}{an optional \eqn{p_j \times p}{pj x p} matrix
  of the subspace in which we constraint portfolios.
  Defaults essentially to the \eqn{p \times p}{p x p}
  identity matrix.}

  \item{Gmat}{an optional \eqn{p_g \times p}{pg x p} matrix
  of the subspace to which we constraint portfolios to have
  zero covariance. The rowspace of \code{Gmat} must be
  spanned by the rowspace of \code{Jmat}. Defaults
  essentially to the \eqn{0 \times p}{0 x p} empty matrix.}

  \item{vcov.func}{a function which takes an object of
  class \code{lm}, and computes a variance-covariance
  matrix. If equal to the string \code{"normal"}, we assume
  multivariate normal returns.}

  \item{fit.intercept}{a boolean controlling whether we add
  a column of ones to the data, or fit the raw uncentered
  second moment. For now, must be true when assuming normal
  returns.}
}
\value{
a list containing the following components:
\item{mu}{Letting \eqn{r = f + p + fit.intercept}, this is
a \eqn{q = (r)(r+1)/2} vector...} \item{Ohat}{The \eqn{q
\times q}{q x q} estimated variance covariance matrix of
\code{mu}.} \item{W}{The estimated Markowitz coefficient, a
\eqn{p \times (fit.intercept + f)}{p x (fit.intercept + f)}
matrix. The first column corresponds to the intercept term
if it is fit. Note that for convenience this function
performs the sign flip, which is not performed on
\code{mu}.} \item{What}{The estimated variance covariance
matrix of \code{vech(W)}. Letting \eqn{s = p(fit.intercept
+ f)}, this is a \eqn{s \times s}{s x s} matrix.}
\item{widxs}{The indices into \code{mu} giving \code{W},
and into \code{Ohat} giving \code{What}.} \item{n}{The
number of rows in \code{X}.} \item{ff}{The number of
features plus \code{as.numeric(fit.intercept)}.}
\item{p}{The number of assets.}
}
\description{
Estimates the Markowitz Portfolio or Markowitz Coefficient
subject to subspace and hedging constraints, and
heteroskedasticity.
}
\details{
Suppose that the expectation of \eqn{p}-vector \eqn{x} is
linear in the \eqn{f}-vector \eqn{f}, but the covariance of
\eqn{x} is stationary and independent of \eqn{f}. The
'Markowitz Coefficient' is the \eqn{p \times f}{p x f}
matrix \eqn{W} such that, conditional on observing \eqn{f},
the portfolio \eqn{Wf} maximizes Sharpe. When \eqn{f} is
the constant 1, the Markowitz Coefficient is the
traditional Markowitz Portfolio.

Given \eqn{n} observations of the returns and features,
given as matrices \eqn{X, F}, this code computes the
Markowitz Coefficient along with the variance-covariance
matrix of the Coefficient and the precision matrix.  One
may give optional weights, which are inverse conditional
volatility. One may also give optional matrix \eqn{J, G}
which define subspace and hedging constraints. Briefly,
they constrain the portfolio optimization problem to
portfolios in the row space of \eqn{J} and with zero
covariance with the rows of \eqn{G}. It must be the case
that the rows of \eqn{J} span the rows of \eqn{G}. \eqn{J}
defaults to the \eqn{p \times p}{p x p} identity matrix,
and \eqn{G} defaults to a null matrix.

One may use the default method for computing covariance,
via the \code{\link{vcov}} function, or via a 'fancy'
estimator, like \code{sandwich:vcovHAC},
\code{sandwich:vcovHC}, \emph{etc.}
}
\examples{
set.seed(1001)
X <- matrix(rnorm(1000*3),ncol=3)
ism <- marko_vcov(X,fit.intercept=TRUE)
walds <- ism$W / sqrt(diag(ism$What))

# generate data with given W, Sigma
Xgen <- function(W,Sigma,Feat) {
 Btrue <- Sigma \%*\% W
 Xmean <- Feat \%*\% t(Btrue)
 Shalf <- chol(Sigma)
 X <- Xmean + matrix(rnorm(prod(dim(Xmean))),ncol=dim(Xmean)[2]) \%*\% Shalf
}

n.feat <- 2
n.ret <- 8
n.obs <- 10000
set.seed(101)
Feat <- matrix(rnorm(n.obs * n.feat),ncol=n.feat)
Wtrue <- 10 * matrix(rnorm(n.feat * n.ret),ncol=n.feat)
Sigma <- cov(matrix(rnorm(100*n.ret),ncol=n.ret))
Sigma <- Sigma + diag(seq(from=1,to=3,length.out=n.ret))
X <- Xgen(Wtrue,Sigma,Feat)
ism <- marko_vcov(X,feat=Feat,fit.intercept=TRUE)
Wcomp <- cbind(0,Wtrue)
errs <- ism$W - Wcomp
dim(errs) <- c(length(errs),1)
Zerr <- solve(t(chol(ism$What)),errs)
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}
}
\references{
Pav, S. E. "Asymptotic Distribution of the Markowitz
Portfolio." 2013 \url{http://arxiv.org/abs/1312.0557}
}
\seealso{
\code{\link{theta_vcov}}, \code{\link{itheta_vcov}}
}
\keyword{univar}

