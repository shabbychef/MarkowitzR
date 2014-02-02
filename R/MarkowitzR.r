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

#' Inference on the Markowitz portfolio.
#' 
#' @section Markowitz Portfolio:
#'
#' 2FIX: fill this in...
#'
#' Suppose \eqn{x_i}{xi} are \eqn{n} independent draws of a normal random
#' variable with mean \eqn{\mu}{mu} and variance \eqn{\sigma^2}{sigma^2}.
#' Let \eqn{\bar{x}}{xbar} be the sample mean, and \eqn{s} be
#' the sample standard deviation (using Bessel's correction). Let \eqn{c_0}{c0}
#' be the 'risk free' or 'disastrous rate' of return.  Then
#' \deqn{z = \frac{\bar{x} - c_0}{s}}{z = (xbar - c0)/s} 
#' is the (sample) Sharpe ratio.
#' 
#' The units of \eqn{z} are \eqn{\mbox{time}^{-1/2}}{per root time}.
#' Typically the Sharpe ratio is \emph{annualized} by multiplying by
#' \eqn{\sqrt{d}}{sqrt(d)}, where \eqn{d} is the number of observations
#' per year (or whatever the target annualization epoch.) It is \emph{not}
#' common practice to include units when quoting Sharpe ratio, though
#' doing so could avoid confusion.
#'
#' The Sharpe ratio follows a rescaled non-central t distribution. That
#' is, \eqn{z/K} follows a non-central t-distribution
#' with \eqn{m} degrees of freedom and non-centrality parameter
#' \eqn{\zeta / K}, for some \eqn{K}, \eqn{m} and \eqn{\zeta}{zeta}.
#'
#' We can generalize Sharpe's model to APT, wherein we write
#' \deqn{x_i = \alpha + \sum_j \beta_j F_{j,i} + \epsilon_i,}{
#' x_i = alpha + sum_j beta_j F_j,i + epsilon_i,}
#' where the \eqn{F_{j,i}} are observed 'factor returns', and
#' the variance of the noise term is \eqn{\sigma^2}{sigma^2}.
#' Via linear regression, one can compute estimates \eqn{\hat{\alpha}}{alpha},
#' and \eqn{\hat{\sigma}}{sigma}, and then let the 'Sharpe ratio' be
#' \deqn{z = \frac{\hat{\alpha} - c_0}{\hat{\sigma}}.}{z = (alpha - c0)/sigma.}
#' As above, this Sharpe ratio follows a rescaled t-distribution
#' under normality, \emph{etc.}
#'
#' The parameters are encoded as follows:
#' \itemize{
#' \item \code{df} stands for the degrees of freedom, typically \eqn{n-1}, but
#' \eqn{n-J-1} in general.
#' \item \eqn{\zeta}{zeta} is denoted by \code{zeta}.
#' \item \eqn{d} is denoted by \code{ope}. ('Observations Per Year')
#' \item For the APT form of Sharpe, \code{K} stands for the
#' rescaling parameter.
#' }
#'
#' @section Legal Mumbo Jumbo:
#'
#' MarkowitzR is distributed in the hope that it will be useful,
#' but WITHOUT ANY WARRANTY; without even the implied warranty of
#' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#' GNU Lesser General Public License for more details.
#'
#' @template etc
#' @template ref-SEP13
#'
#' @references
#'
#' Britten-Jones, Mark. "The Sampling Error in Estimates of Mean-Variance 
#' Efficient Portfolio Weights." The Journal of Finance 54, no. 2 (1999):
#' 655--671. \url{http://www.jstor.org/stable/2697722}
#'
#' Bodnar, Taras and Okhrin, Yarema. "On the Product of Inverse Wishart
#' and Normal Distributions with Applications to Discriminant Analysis 
#' and Portfolio Theory." Scandinavian Journal of Statistics 38, no. 2 (2011):
#' 311--331. \url{http://dx.doi.org/10.1111/j.1467-9469.2011.00729.x}
#'
#' @name MarkowitzR
#' @rdname MarkowitzR
#' @docType package
#' @title statistics concerning the Markowitz portfolio
#' @keywords package
#' 
#' This package is maintained as a hobby. 
#'
NULL

#' @title News for package 'MarkowitzR':
#'
#' \newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}
#' \newcommand{\MarkowitzR}{\CRANpkg{MarkowitzR}}
#'
#' @section \MarkowitzR{} Initial Version 0.1402 (2014-02-02) :
#' \itemize{
#' \item put on CRAN
#' }
#'
#' @name MarkowitzR-NEWS
#' @rdname NEWS
NULL


#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
