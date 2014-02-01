# Copyright 2014-2014 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav
#
# This file is part of MarkowitzR.
#
# MarkowitzR is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MarkowitzR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with MarkowitzR.  If not, see <http://www.gnu.org/licenses/>.

# Created: 2014.01.31
# Copyright: Steven E. Pav, 2014
# Author: Steven E. Pav
# Comments: Steven E. Pav



#' @title Estimate Markowitz Portfolio
#'
#' @description
#'
#' Estimates the Markowitz Portfolio or Markowitz Coefficient subject
#' to subspace and hedging constraints, and heteroskedasticity.
#'
#' @details
#'
#' Suppose that the expectation of \eqn{p}-vector \eqn{x} is linear
#' in the \eqn{f}-vector \eqn{f}, but the covariance of \eqn{x} is
#' stationary and independent of \eqn{f}. The 'Markowitz Coefficient' 
#' is the \eqn{p \times f}{p x f} matrix \eqn{W} such that, 
#' conditional on observing \eqn{f}, the portfolio \eqn{Wf} maximizes
#' Sharpe. When \eqn{f} is the constant 1, the Markowitz Coefficient
#' is the traditional Markowitz Portfolio.
#'
#' Given \eqn{n} observations of the returns and features, given
#' as matrices \eqn{X, F}, this code computes the Markowitz Coefficient
#' along with the variance-covariance matrix of the Coefficient and the
#' precision matrix.  One may give optional weights, which are inverse
#' conditional volatility. One may also give optional matrix \eqn{J, G}
#' which define subspace and hedging constraints. Briefly, they constrain
#' the portfolio optimization problem to portfolios in the row space of
#' \eqn{J} and with zero covariance with the rows of \eqn{G}. It must 
#' be the case that the rows of \eqn{J} span the rows of \eqn{G}. 
#' \eqn{J} defaults to the \eqn{p \times p}{p x p} identity matrix, 
#' and \eqn{G} defaults to a null matrix.
#' 
#' One may use the default method for computing covariance,
#' via the \code{\link{vcov}} function, or via a 'fancy' estimator,
#' like \code{sandwich:vcovHAC}, \code{sandwich:vcovHC}, \emph{etc.}
#'
#' @usage
#'
#' marko_vcov(X,feat=null,vcov.func=vcov,fit.intercept=TRUE,weights=null,Jmat=null,Gmat=null)
#'
#' @param X an \eqn{n \times p}{n x p} matrix of observed returns.
#' @param feat an \eqn{n \times f}{n x f} matrix of observed features.
#' defaults to none, in which case \code{fit.intercept} must be
#' \code{TRUE}. If \code{fit.intercept} is true, ones will be prepended
#' to the features.
#' @param weights an optional \eqn{n} vector of the weights. The returns
#' and features will be multiplied by the weights. Weights should be
#' inverse volatility estimates. Defaults to homoskedasticity.
#' @param Jmat an optional \eqn{p_j \times p}{pj x p} matrix of the
#' subspace in which we constraint portfolios. Defaults essentially to the
#' \eqn{p \times p}{p x p} identity matrix.
#' @param Gmat an optional \eqn{p_g \times p}{pg x p} matrix of the
#' subspace to which we constraint portfolios to have zero covariance. 
#' The rowspace of \code{Gmat} must be spanned by the rowspace of \code{Jmat}.
#' Defaults essentially to the \eqn{0 \times p}{0 x p} empty matrix.
#'
#' @inheritParams theta_vcov
#' @keywords univar 
#'
#' @return a list containing the following components:
#' \item{mu}{Letting \eqn{r = f + p + fit.intercept}, this is a 
#' \eqn{q = (r)(r+1)/2} vector...}
#' \item{Ohat}{the \eqn{q \times q}{q x q} estimated variance covariance 
#' matrix of \code{mu}.}
#' \item{W}{The estimated Markowitz coefficient, a 
#' \eqn{(f+fit.intercept) \times p}{(f+fit.intercept) x p} matrix.}
#' \item{What}{the estimated variance covariance matrix of \code{vech(W)}.}
#' \item{n}{the number of rows in \code{X}.}
#' \item{ff}{the number of features plus \code{as.numeric(fit.intercept)}.}
#' \item{p}{the number of assets.}
#'
#' @seealso \code{\link{itheta_vcov}}, \code{\link{theta_vcov}}
#' @rdname theta_vcov
#' @export 
#' @template etc
#' @template ref-SEP13
#'
#' @examples 
#' X <- matrix(rnorm(1000*3),ncol=3)
#' ism <- marko_vcov(X,fit.intercept=TRUE)
#' walds <- ism$W / sqrt(diag(ism$What))
#'
marko_vcov <- function(X,feat=null,vcov.func=vcov,fit.intercept=TRUE,
											 weights=null,Jmat=null,Gmat=null) {
	set.coln(rets)

	if (!is.null(feat)) {
		set.coln(feat)
		if (!is.null(weights)) {
			# assume recycling will do this correctly!
			feat <- feat * weights
		}
		f <- dim(feats)[2]
	} else {
		f <- 0
	}
	p <- dim(rets)[2]
	ff <- f + as.numeric(fit.intercept)

	twidlize <- function(M) { rbind(cbind(diag(ff),0),cbind(0,M)) }

	if (!is.null(Jmat)) 
		Jtwid <- twidlize(Jmat) 
	else
		Jtwid <- null

	# compute second moment and variance/covariance;
	XY <- cbind(as.matrix(feats),-as.matrix(rets))
	XY <- na.omit(XY)
	asymv <- itheta_vcov(XY,fit.intercept=fit.intercept,
											 vcov.func=vcov.func)

	# interpret
	pp <- asymv$pp
	Theta <- ivech(asymv$mu)

	up.t <- .theta_grinder(Theta,M=Jtwid)
	PTheta <- up.t$iT
	preH <- up.t$iiT

	if (!is.null(Gmat)) {
		# 2FIX: check that G is spanned by J?
		Gtwid <- twidlize(Gmat)
		down.t <- .theta_grinder(Theta,M=Gtwid)
		PTheta <- PTheta - down.t$iT
		preH <- preH - down.t$iiT
	}
	mu <- matrixcalc::vech(PTheta)

	elim.idx <- lower.tri(Theta,diag=TRUE)
	dim(elim.idx) <- c(length(elim.idx),1)
	Dupp <- matrixcalc::duplication.matrix(pp)

	H.mat <- - preH[elim.idx,] %*% Dupp
	Ohat <- (H.mat) %*% asymv$Ohat %*% t(H.mat)

  # figure out indices of interest and then subselect!
	botidx <- 0:(ff-1) * p + sapply(0:(ff-1),function(n)sum((ff-n):ff))
	pidxs <- outer(1:p,botidx,"+") 
	dim(pidxs) <- c(length(pidxs),1)

	W <- mu[pidxs]
	dim(W) <- c(p,ff)
	rownames(W) <- colnames(rets)
	colnames(W)[(1:f) + as.numeric(fit.intercept)] <- colnames(feats)
	if (fit.intercept)
		colnames(W)[1] <- "Intercept"
	W <- t(W)

	What <- Ohat[pidxs,pidxs]

	retval <- list(mu=diag(PTheta),
								 Ohat=Ohat,
								 W=W,
								 What=What,
								 n=asymv$n,
								 p=p,
								 ff=ff)

	return(retval)

}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
