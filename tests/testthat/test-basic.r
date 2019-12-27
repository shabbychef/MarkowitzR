# Copyright 2014-2020 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav

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

# env var:
# nb: 
# see also:
# todo:
# changelog: 
#
# Created: 2014.05.19
# Copyright: Steven E. Pav, 2014-2020
# Author: Steven E. Pav
# Comments: Steven E. Pav

# just test if everything runs...

# helpers#FOLDUP
set.char.seed <- function(str) {
	set.seed(as.integer(charToRaw(str)))
}
THOROUGHNESS <- getOption('test.thoroughness',1.0)
#UNFOLD

context("test API")#FOLDUP
test_that("mp_vcov runs",{#FOLDUP
	ngen <- ceiling(THOROUGHNESS * 32)
	alpha.floor = 0.001 + 0.003 * (THOROUGHNESS / (1 + THOROUGHNESS))

	vcvs <- list(NULL,vcov,"normal")
	if (require(sandwich))
		vcvs <- c(vcvs,sandwich::vcovHAC)

	set.char.seed("0b144107-4de8-4e00-95f7-d746db3aef8e")
	ope <- 253
	for (vvv in seq_len(length(vcvs))) {
		vfunc <- vcvs[[vvv]]
		for (nyr in c(1,2)) {#FOLDUP
			nday <- ceiling(ope * nyr)
			for (nstock in c(3,5)) {
				X <- matrix(rnorm(nday * nstock),ncol=nstock)

				for (nfeat in c(0,2)) {
					if (nfeat < 1) {
						Feat <- NULL   # unconditional case
					} else {
						Feat <- matrix(rnorm(nday * nfeat),ncol=nfeat)  # conditioanl returns
					}

					# unweighted estimation#FOLDUP
					expect_error(asym <- MarkowitzR::mp_vcov(X,feat=Feat,vcov.func=vfunc,fit.intercept=TRUE),NA)

					for (psiz in c(1,2)) {
						Amat <- matrix(rnorm(1 * nstock),ncol=nstock)
						expect_error(asym <- MarkowitzR::mp_vcov(X,feat=Feat,vcov.func=vfunc,Jmat=Amat,
																										fit.intercept=TRUE),NA)
						expect_error(asym <- MarkowitzR::mp_vcov(X,feat=Feat,vcov.func=vfunc,Gmat=Amat,
																										fit.intercept=TRUE),NA)
					}
					#UNFOLD
					# weighted estimation#FOLDUP
					weights <- 1 + runif(nday)
					expect_error(asym <- MarkowitzR::mp_vcov(X,feat=Feat,vcov.func=vfunc,weights=weights,fit.intercept=TRUE),
											 NA)

					for (psiz in c(1,2)) {
						Amat <- matrix(rnorm(1 * nstock),ncol=nstock)
						expect_error(asym <- MarkowitzR::mp_vcov(X,feat=Feat,vcov.func=vfunc,Jmat=Amat,
																										weights=weights,fit.intercept=TRUE),
												 NA)
						expect_error(asym <- MarkowitzR::mp_vcov(X,feat=Feat,vcov.func=vfunc,Gmat=Amat,
																										weights=weights,fit.intercept=TRUE),
												 NA)
					}
					#UNFOLD
				}
			}
		}#UNFOLD
	}
})#UNFOLD
test_that("itheta_vcov runs",{#FOLDUP
	vcvs <- list(vcov)
	if (require(sandwich))
		vcvs <- c(vcvs,sandwich::vcovHAC)

	set.char.seed("6f0cd49e-c5e1-4f81-8266-a558c9ccf823")
	ope <- 253
	for (vvv in seq_len(length(vcvs))) {
		vfunc <- vcvs[[vvv]]
		for (nyr in c(1,2)) {#FOLDUP
			nday <- ceiling(ope * nyr)
			for (nstock in c(2,4)) {
				X <- matrix(rnorm(nday * nstock),ncol=nstock)

				expect_error(asym <- MarkowitzR::itheta_vcov(X,vcov.func=vfunc,fit.intercept=TRUE),
										 NA)
			}
		}#UNFOLD
	}
})#UNFOLD

#UNFOLD

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:

