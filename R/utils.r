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

require(gtools)
require(matrixcalc)

# set the colnames of X appropriately
set.coln <- gtools::defmacro(X,expr={
	if (is.null(colnames(X))) {
		colnames(X) <- paste0(deparse(substitute(X),nlines=1),1:(dim(X)[2]))
  }})

# inverse vech. 
# take a vector x, and replicate out to matrix X such that
# x = vech(X)
#
# why isn't this in matrixcalc?
ivech <- function(x) { 
	n <- length(x)
	p <- (-0.5 + sqrt(2*n + 0.25))
	if (abs(p - round(p)) > 1e-4) stop('wrong sized input')
	M <- matrix(0,ncol=p,nrow=p)
	islo <- row(M) >= col(M)
	M[islo] <- x
	M <- t(M)
	M[islo] <- x
	return(M)
}

.xkronx <- function(xX) {
	return(x %x% x)
}


.qform <- function(Sigma,x) {
	return(t(x) %*% (Sigma %*% x))
}
.qoform <- function(Sigma,x) {
	return(x %*% (Sigma %*% t(x)))
}
.Proj <- function(A,Sigma) {
	return(t(A) %*% solve(.qoform(Sigma,A),A))
}
# computes proj(M,Theta) and 
# (M'kronM') ((M Theta M')^-1 kron (M Theta M')^-1) (M kron M)
# except if M is null, we assume it is the identity matrix
# and so compute Theta^-1 and Theta^-1 kron Theta^-1
.theta_grinder <- function(Theta,M=null) {
	if (is.null(M)) {
		iT <- solve(Theta)
		iiT <- .xkronx(iT)
	} else {
		halfproj <- solve(.qoform(Sigma,M))
		iT <- .qform(halfproj,M)
		iiT <- .xkronx(t(M)) %*% (.xkronx(solve(halfproj)) %*% .xkronx(M))
	}
	retval <- list(iT=iT,iiT=iiT)
	return(retval)
}



#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
