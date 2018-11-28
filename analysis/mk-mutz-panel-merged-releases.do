capture clear
capture log close
set more off
set linesize 120
cls

log using log/mk-mutz-panel-merged-releases.log, replace


********************************************************************************
********************************************************************************
*** Compare Mutz panel data for 1st and 2nd releases
********************************************************************************
********************************************************************************

* sort and subset for comparison
tempfile panel1
tempfile panel1subset
tempfile panel2
tempfile panel2subset
tempfile panel3
tempfile panel3subset

use rawdata/mutz-panel-first-release.dta, clear 
sort MNO wave
save `panel1'
desc, s
*** the following variables were deleted for the second release
drop healthself demhealth rephealth healthdiffrep healthdiffdem party7 w0party3
save `panel1subset'
desc, s

use rawdata/mutz-panel-second-release.dta, clear 
sort MNO wave
save `panel2'
desc, s
*** the following variables were not in the first release
drop demrepvote ppeducat sdoscale10 income voted2012 _merge difftherm ///
 cutdifftherm prexparty3wave preincomewave
save `panel2subset'
desc, s

use rawdata/mutz-panel-third-release.dta, clear 
sort MNO wave
gen release3 = 1 /* file is simply a subset of r's; see table below */
drop _merge
save `panel3'
desc, s

* compare
use `panel1subset', clear 
cf _all using `panel2', verbose

use `panel2subset', clear 
cf _all using `panel1', verbose

*  Conclusion:  
*   The subets of variables are the same, and so the two datasets can be merged

use `panel2', clear
drop _merge
merge 1:1 MNO wave using `panel1'
tab _merge
drop _merge
 
merge 1:1 MNO wave using `panel3'
tab _merge
drop _merge

desc, s
codebook, c

recode release3 .=0

tab release3 wave, m

/* 
   Command above yields table below, showing that release3 exlucdes those with 
   wave missing and 24 r's from wave1
   
           |               wave
  release3 |         0          1          . |     Total
-----------+---------------------------------+----------
         0 |         0         24      1,244 |     1,268 
         1 |     1,227      1,203          0 |     2,430 
-----------+---------------------------------+----------
     Total |     1,227      1,227      1,244 |     3,698 
*/
	 
save data/mutz-panel-merged-releases.dta, replace 

log close
