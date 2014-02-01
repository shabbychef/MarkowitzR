# Copyright 2014-2014 Steven E. Pav. All Rights Reserved.
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

ff.data <- read.csv('http://www.quandl.com/api/v1/datasets/KFRENCH/FACTORS_M.csv?&trim_start=1926-07-31&trim_end=2013-10-31&sort_order=asc', colClasses=c('Month'='Date'))

rownames(ff.data) <- ff.data$Month
ff.data <- ff.data[,! (colnames(ff.data) %in% c("Month"))]
ff.data <- 1e-2 * ff.data

save(ff.data,file='ff_data.rda',compress='bzip2')

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
