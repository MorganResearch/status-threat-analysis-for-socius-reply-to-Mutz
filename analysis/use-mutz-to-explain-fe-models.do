capture clear
capture log close
set more off
set linesize 120
cls

log using log/use-mutz-to-explain-fe-models.log, replace

********************************************************************************
*** This file takes the do file mutz-code-panel-edited-v2.do from May 2018,  
***   which was posted to GitHub with the July 2018 article published in Socius,
***   and uses the same setup.  That setup is based on  Mutz's original
***   code that she released, along with additional code chunks for the critic.
***   The current file includes a second set of additional code chunks for   
***   subsequent work in order to explain a wider range of models than appeared 
***   in the Socius article.  This analysis was prepared when the Socius Reply
***   was in production. As a result, all new chunks are labeled below as 
***   "CHUNK for SociusReply." 
***     [Many parts of this do file were, however, written in advance of the  
***      July 2, 2018 lecture at Rostock, slides for which are posted at 
***      https://osf.io/fjr7e/ .] 
*** In addition, an intermediate file mutz-code-panel-edited-v2-sdo-problems.do 
***   exists that updates mutz-code-panel-edited-v2.do in order to consider the
***   sdo mismatch problem clarified in October and November 2018 when tidying 
***   up this file for distribution. 
*** The results of the Socius article and the Rostock lecture are not  
***   affected by the sdo mismatch, since the "pre" sdo measure was not used for
***   either set of analyses.  However, in order to be consistent with the 
***   methodology literature in providing correct explanations, I need to have
***   consistently measured variables.  The relevant changes identified and
***   suggested by the analysis in mutz-code-panel-edited-v2-sdo-problems.do 
***   are carried forward and implemented in the current file.  
***    [Additional notes: 
***     1.  Some of the code that generates results in 
***     mutz-code-panel-edited-v2.do is commented out in this file.  It is the
***     same code and there is no reason to regenerate the results and write
***     over the existing outreg files.  It is re-run already in  
***     the intermediate file mutz-code-panel-edited-v2-sdo-problems.do.
***     2.  Some deprecated code is aso present below, as it is the vestige
***     of the original Rostock-lecture code.  This code is for additional 
***     fe models that cluttter the explanations and outreg files.  They are 
***     commented out in this version, but could be restored, perhaps with 
***     some minor editing.]
********************************************************************************

********************************************************************************
*** Load merged data created by 
***    mk-mutz-panel-merged-releases.do
********************************************************************************

use data/mutz-panel-merged-releases.dta, clear 

* drop from merged data because recreated with this Mutz's code below

drop difftherm prexparty3wave preincomewave cutdifftherm

********************************************************************************
********************************************************************************
*** Mutz Analysis (Setup)
********************************************************************************
********************************************************************************

generate difftherm=reptherm-demtherm
egen cutdifftherm= cut(difftherm), group(20)

  /* by wave interactions */

generate pretradeselfwave=pretradeself*wave
generate prelookingforworkwave=prelookingforwork*wave
generate prepersonecowave=prepersoneco*wave
generate preproimmselfwave=preproimmself*wave
generate prechinaselfwave=prechinaself*wave
generate preeconomywave=preeconomy*wave
generate presdowave=sdoscale10*wave
generate pretradediffdemwave =pretradediffdem*wave
generate preimmdiffdemwave=preimmdiffdem*wave
generate prechinadiffdemwave=prechinadiffdem*wave
generate pretradediffrepwave =pretradediffrep*wave
generate preimmdiffrepwave=preimmdiffrep*wave
generate prechinadiffrepwave=prechinadiffrep*wave
* generate newacs_medianinc=acs_medianinc/1000
* generate acsincomewave =newacs_medianinc*wave
* generate acsunemplwave = acs_unemploy*wave
* generate acsmfgwave = acs_mfg*wave
generate pretradeperwave=pretradeper*wave
generate prexparty3wave=prexparty3*wave
generate preincomewave=preincome*wave

********************************************************************************
********************************************************************************
*** Critic Analysis (Setup)
********************************************************************************
********************************************************************************

*** create education variables

rename ppeducat education
tab education, gen(ed_lev)
recode education 1/2=2, gen(educ3)
tab education educ3	 
summ ed*

*** Determine pattern for self, rep, dem, and diff vars, as well as wave

summ healthself demhealth healthdiffdem rephealth healthdiffrep ///
     chinaself chinadem chinadiffdem chinarep chinadiffrep ///
     proimmself proimmdems immdiffdem proimmreps immdiffrep /// 
     tradeself tradedem tradediffdem traderep tradediffrep 

 * Note: The difference variables are the absolute values of the differences.
 *       These will be given the "ad" prefix below, and new "dd" variables
 *         will be created for signed differences.

bysort wave: summ traderep tradedem tradeself 
bysort wave: summ traderep tradedem tradeself if voted2016==1

 * Note: The comparison of these values to Mutz's Figure 1 confrims the wave
 *       dummy is for the year 2016.

*** Create clones for readability **********************************************

*** outcome vars

clonevar rep_warmer = cutdifftherm
clonevar rep_over_dem = demrepvote

clonevar rep_warm = reptherm
clonevar dem_warm = demtherm

*** time-varying vars

clonevar wave2016 = wave
clonevar party3_dem = xparty3 
*clonevar income = income
clonevar look_work = lookingforwork 
clonevar finances_better = personeco
clonevar trade_help_u = tradeper
clonevar more_trade = tradeself
clonevar more_imm = proimmself
clonevar china_opp = chinaself
clonevar add_more_trade = tradediffdem
clonevar add_more_imm = immdiffdem
clonevar add_china_opp = chinadiffdem
clonevar adr_more_trade = tradediffrep
clonevar adr_more_imm = immdiffrep
clonevar adr_china_opp = chinadiffrep
*clonevar sdo = sdo
clonevar economy_better = economy

* first wave variables copied into both waves as constants

clonevar party3_dem_c = prexparty3 
clonevar income_c = preincome
clonevar look_work_c = prelookingforwork 
clonevar finances_better_c = prepersoneco
clonevar trade_help_u_c = pretradeper
clonevar more_trade_c = pretradeself
clonevar more_imm_c = preproimmself
clonevar china_opp_c = prechinaself
clonevar add_more_trade_c = pretradediffdem
clonevar add_more_imm_c = preimmdiffdem
clonevar add_china_opp_c = prechinadiffdem
clonevar adr_more_trade_c = pretradediffrep
clonevar adr_more_imm_c = preimmdiffrep
clonevar adr_china_opp_c = prechinadiffrep
clonevar sdo_c = sdoscale10
clonevar economy_better_c = preeconomy

* first wave constant variables multiplied by wave dummy

clonevar party3_dem_xw1 = prexparty3wave 
clonevar income_xw1 = preincomewave
clonevar look_work_xw1 = prelookingforworkwave 
clonevar finances_better_xw1 = prepersonecowave
clonevar trade_help_u_xw1 = pretradeperwave
clonevar more_trade_xw1 = pretradeselfwave
clonevar more_imm_xw1 = preproimmselfwave
clonevar china_opp_xw1 = prechinaselfwave
clonevar add_more_trade_xw1 = pretradediffdemwave
clonevar add_more_imm_xw1 = preimmdiffdemwave
clonevar add_china_opp_xw1 = prechinadiffdemwave
clonevar adr_more_trade_xw1 = pretradediffrepwave
clonevar adr_more_imm_xw1 = preimmdiffrepwave
clonevar adr_china_opp_xw1 = prechinadiffrepwave
clonevar sdo_xw1 = presdowave
clonevar economy_better_xw1 = preeconomywave

*** BEGIN ***********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

*** Create a constant sdo variable based on sdo
***   Based on Mutz's writeup, and what is released with her data, it is 
***   unclear what the variable sdoscale10 is.  The following analysis will show 
***   that it isn't the first wave values for sdo, like her other pre variables.

tempfile reply_tmp_1
tempfile reply_tmp_2

save `reply_tmp_1'

keep MNO wave sdo sdoscale10
sort MNO wave
tab wave, miss
drop if wave==.
tab wave, miss

drop if wave ==1 /* wave 1, in Mutz, is the second period */
rename sdo sdo_w0
save `reply_tmp_2'

use `reply_tmp_1', replace

merge m:1 MNO using `reply_tmp_2'
drop _merge

summ MNO wave sdo*

clonevar sdo_c_v2 = sdo_w0
gen sdo_xw1_v2 = sdo_w0*wave

*** List cases to see the pattern for Mutz's sdoscale10 and sdo, in order to
***   compare with my constructed "pre" variable sdo_w0 created directly from
***   Mutz's variable sdo.

list MNO wave sdoscale10 sdo sdo_w0 in 1/100
list MNO wave sdoscale10 sdo sdo_w0 if sdo_w0 == . & sdoscale10 != .

*** Given these results show an odd pattern for sdoscale10, compare the 
***   variables within wave.

bys wave: summ sdo sdoscale
bys wave: compare sdo sdoscale10
bys wave: pwcorr sdo sdoscale, obs
regress sdoscale10 c.sdo##i.wave

*** Conclusion:  sdoscale10 is not a simple rescaling of sdo in wave0.  It is 
***  present for many individuals in wave0 when sdo is missing.  Its correlation
***  with sdo is less than 0.6 in both waves, among cases where both are valid.

*** In view of this, check  other variables to make sure they don't have 
***   this pattern.

local check_vars ///
  party3_dem prexparty3 ///
  income preincome ///
  look_work prelookingforwork ///
  finances_better prepersoneco ///
  trade_help_u pretradeper ///
  more_trade pretradeself ///
  more_imm preproimmself ///
  china_opp prechinaself ///
  sdo sdoscale10 ///
  economy_better preeconomy

bys wave: summ `check_vars'

*** Conclusion:  N's, means, and SD all match in wave0 and don't generally match
***  in wave1. Sdo and sdoscale10 are the only mismatch.  Thus, all other 
***  variables are as expected, and only the sdo variables are inconsistent.

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

*** Create candidate and difference variables **********************************

clonevar gov_health = healthself

clonevar d_more_trade = tradedem
clonevar d_more_imm   = proimmdems
clonevar d_china_opp  = chinadem
clonevar d_gov_health = demhealth
clonevar r_more_trade = traderep
clonevar r_more_imm   = proimmreps
clonevar r_china_opp  = chinarep
clonevar r_gov_health = rephealth

gen dd_more_trade = more_trade - d_more_trade 
gen dd_more_imm   = more_imm - d_more_imm 
gen dd_china_opp  = china_opp - d_china_opp 
gen dd_gov_health = gov_health - d_gov_health 
gen dr_more_trade = more_trade - r_more_trade 
gen dr_more_imm   = more_imm - r_more_imm 
gen dr_china_opp  = china_opp - r_china_opp 
gen dr_gov_health = gov_health - r_gov_health 

gen add_gov_health = abs(dd_gov_health)
gen adr_gov_health = abs(dr_gov_health)

********************************************************************************
********************************************************************************
*** Mutz Analysis (Table 1)
********************************************************************************
********************************************************************************

xtset MNO wave

*** Note first that Mutz's third release of the data files is a slightly
***  different sample.  

tab wave release3, miss
table wave release3, c(mean cutdifftherm mean demrepvote n MNO)

***  The results are very slightly different, and both are produced
***  below by Mutz's code, with a further if statement added
***  for the third release of the dataset.  (See below for an anslysis of
***  release 3.)

 /*Table 1 analyses*/

/*
xtreg cutdifftherm xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
  	tradediffrep immdiffrep chinadiffrep ///
   	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave  /* acsunemplwave acsmfgwave acsincomewave */ ///
    wave , fe 
est store mutztherm

*drop if voted2016==0  /* replaced by an if statement instead below */
logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave  /* acsunemplwave acsmfgwave acsincomewave */ ///
    wave if voted2016==1, cluster(MNO) 
est store mutzvote

xtreg cutdifftherm xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
  	tradediffrep immdiffrep chinadiffrep ///
   	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave  /* acsunemplwave acsmfgwave acsincomewave */ ///
    wave if release3 == 1, fe 
est store mutzthermr3

*drop if voted2016==0  /* replaced by an if statement instead below */
logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave  /* acsunemplwave acsmfgwave acsincomewave */ ///
    wave if voted2016==1 & release3 == 1, cluster(MNO) 
est store mutzvoter3

outreg2 [mutztherm mutzvote mutzthermr3 mutzvoter3] ///
  using docs/mutz-table-1-from-mutz-code.xls, ///
  e(r2_p chi2 df_m) excel replace
*/
estimates clear

********************************************************************************
********************************************************************************
*** Critic Analysis (Consider patterns of outcome vars and release 3)
********************************************************************************
********************************************************************************

* temproary files

tempfile long_all_vars

save `long_all_vars'

* reshape with subset, and  then consider patterns

use `long_all_vars', replace

keep MNO wave education income sdo voted2016 voted2012 party7 release3 ///
  ed_lev1-economy_better gov_health-adr_gov_health

order _all, alphabetic
order MNO wave* release3 rep_* dem_* ed* income part*
order d_* r_* ad* dd* dr*, last

drop if wave==.
drop wave2016
recode wave 0=2012 1=2016

reshape wide release3 rep_over_dem-dr_more_trade, i(MNO) j(wave)

*** Analyze release 3

*    These tables show that release 3 drops individuals with 2016 income in 
*    categories 20 and 21, which are presumably greater than 175K, based on
*    comparisons with 2012 incomes.  The implication is that these 24 
*    individuals can be recoded as 19's and kept in the models.

tab income2012 release32012
tab income2016 release32016
tab income2012 if release32016 == 0

summ income2012 income2016
summ income2012 income2016 if release32016 == 1

corr income2012 income2016
corr income2012 income2016 if release32016 == 1

tab income2012 release32016, nol
tab income2016 release32016, nol

*** Examine votes

*    These results show that, at most, only 51 individuals did not stick
*    with their party across both elections.  And 5 of these individuals
*    were high income individuals who were dropped from the analysis, 
*    apparently, because they were not included in release 3.  All 5 voted
*    for Romney in 2012 but Clinton in 2016.

gen romney = rep_over_dem2012
gen trump = rep_over_dem2016

gen vote_both=0
replace vote_both = 1 if voted20122016 == 1 & voted20162016 == 1
 
tab romney trump if vote_both == 0, r miss
tab romney trump if vote_both == 1, r miss
tab romney trump if vote_both == 1, r cell
tab romney trump if vote_both == 1 & release32016 == 1 , r cell

*** Examine thermometer ratings

*    These results show that there is plenty of variance in differences in 
*    thermometer ratings.  They also show that switches in party id are, as
*    expected, related to thermometer ratings, suggesting that party id
*    is indeed endoengous to vote choice.

sum *warm*
corr rep_warm2012 rep_warm2016 rep_warmer2012 rep_warmer2016
corr dem_warm2012 dem_warm2016 rep_warmer2012 rep_warmer2016


table party72012, c(mean rep_warm2012 mean rep_warm2016 n MNO)
table party72012, c(mean dem_warm2012 mean dem_warm2016 n MNO)

table party72012 party72016, c(mean rep_warm2012 mean rep_warm2016 n MNO)
table party72012 party72016, c(mean dem_warm2012 mean dem_warm2016 n MNO)

table party3_dem2012 party3_dem2016, c(mean rep_warm2012 mean rep_warm2016 n MNO)
table party3_dem2012 party3_dem2016, c(mean dem_warm2012 mean dem_warm2016 n MNO)

gen warmdiff = rep_warmer2016 - rep_warmer2012
tab warmdiff
recode warmdiff min/-1=-1 1/max=1, gen(warmdiff3)
tab warmdiff3
tab warmdiff3 vote_both, r col

* Examine predictors

local vars_for_descriptives party3_dem ///
  income look_work finances_better trade_help_u ///
  more_trade more_imm china_opp sdo economy_better

tab income2012
tab income2016

tab income2012 income2016 if vote_both == 1

foreach var in `vars_for_descriptives' {
  summ `var'2012 `var'2016
  gen `var'_change = `var'2016 - `var'2012
  table romney trump if vote_both == 1, c(mean `var'2012 semean `var'2012 ///
    n `var'2012) format(%9.2f)
  table romney trump if vote_both == 1, c(mean `var'2016 semean `var'2016 ///
    n `var'2016) format(%9.2f)
  table romney trump if vote_both == 1, c(mean `var'_change semean ///
    `var'_change n `var'_change) format(%9.2f)
}

*** BEGIN ***********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

keep MNO *_change
summ

tempfile change_vars 
save `change_vars'

use `long_all_vars', replace
merge m:1 MNO using `change_vars'
tab _merge
drop _merge
save `long_all_vars', replace

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

use `long_all_vars', replace

********************************************************************************
********************************************************************************
*** Critic Analysis (Figure 1, with change by education level)
********************************************************************************
********************************************************************************

/*
local self_and_candidate ///
 more_trade d_more_trade r_more_trade ///
 more_imm d_more_imm r_more_imm ///
 china_opp d_china_opp r_china_opp ///
 gov_health d_gov_health r_gov_health
	 
foreach var in more_trade more_imm china_opp gov_health {
  tab dd_`var' add_`var', miss
  tab dr_`var' adr_`var', miss
  corr dd_`var' add_`var' dr_`var' adr_`var'
}

foreach var in `self_and_candidate' {
  regress `var' i.wave
  est store `var'1
  regress `var' i.educ3##i.wave
  est store `var'2
  regress `var' i.wave if voted2016==1
  est store `var'4
  regress `var' i.educ3##i.wave if voted2016==1
  est store `var'5
  table educ3 wave, c(mean `var' semean `var' n `var') format(%9.2f)
  table educ3 wave if voted2016==1, c(mean `var' semean `var' n `var') ///
    format(%9.2f)
}

outreg2 [*] ///
  using docs/critic-fig-1-results-by-education.xls, ///
  excel replace
estimates clear
*/

********************************************************************************
********************************************************************************
*** Critic Analysis (Table 1, with basic variations)
********************************************************************************
********************************************************************************

xtset MNO wave

*** Macros for Mutz specifications

local mutz_time_varying party3_dem ///
  income look_work finances_better trade_help_u ///
  more_trade more_imm china_opp ///
  add_more_trade add_more_imm add_china_opp ///
  adr_more_trade adr_more_imm adr_china_opp ///
  sdo economy_better
 
local mutz_wave0_as_constants party3_dem_c ///
  income_c look_work_c finances_better_c trade_help_u_c ///
  more_trade_c more_imm_c china_opp_c ///
  add_more_trade_c add_more_imm_c add_china_opp_c ///
  adr_more_trade_c adr_more_imm_c adr_china_opp_c ///
  sdo_c economy_better_c

local mutz_wave0_vars_in_wave1 party3_dem_xw1 ///
  income_xw1 look_work_xw1 finances_better_xw1 trade_help_u_xw1 ///
  more_trade_xw1 more_imm_xw1 china_opp_xw1 ///
  add_more_trade_xw1 add_more_imm_xw1 add_china_opp_xw1 ///
  adr_more_trade_xw1 adr_more_imm_xw1 adr_china_opp_xw1 ///
  sdo_xw1 economy_better_xw1

*** BEGIN **********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

*** Macros for Mutz specifications, but with sdo_same

local mutz_wave0_as_constants_v2 party3_dem_c ///
  income_c look_work_c finances_better_c trade_help_u_c ///
  more_trade_c more_imm_c china_opp_c ///
  add_more_trade_c add_more_imm_c add_china_opp_c ///
  adr_more_trade_c adr_more_imm_c adr_china_opp_c ///
  sdo_c_v2 economy_better_c

local mutz_wave0_vars_in_wave1_v2 party3_dem_xw1 ///
  income_xw1 look_work_xw1 finances_better_xw1 trade_help_u_xw1 ///
  more_trade_xw1 more_imm_xw1 china_opp_xw1 ///
  add_more_trade_xw1 add_more_imm_xw1 add_china_opp_xw1 ///
  adr_more_trade_xw1 adr_more_imm_xw1 adr_china_opp_xw1 ///
  sdo_xw1_v2 economy_better_xw1

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

*** Basic replications

* Note:
*  1.  High income individuals excluded from release 3 can be included.
*  2.  The logit is fit, rather than xtlogit, becuase xtlogit does not converge.

/*
xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if release3 == 1, fe

xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave, fe
*/

*** BEGIN **********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

*** With sdo same

/*
xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1_v2' wave ///
  if release3 == 1, fe

xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1_v2' wave, fe

xtreg rep_warmer sdo sdo_xw1 wave ///
  if release3 == 1, fe

xtreg rep_warmer sdo sdo_xw1_v2  wave, fe
*/

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

recode income 20 21=19

/*
xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave, fe
est store mutzwarm
*/

*** BEGIN **********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

*** With sdo same

/*
xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1_v2' wave, fe
est store mutzwarm_v2

xtreg rep_warmer sdo sdo_xw1_v2 wave ///
  if release3 == 1, fe

xtreg rep_warmer sdo sdo_xw1_v2  wave, fe
*/

*** CONCLUSION:  Aligning the sdo variable does change the results

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

/*
logit rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if voted2016 == 1, cluster(MNO)
est store mutzoverlogit

xtlogit rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if voted2016 == 1, fe iter(50)
est store mutzoverxtlogit50

xtlogit rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if voted2016 == 1, fe iter(150)
est store mutzoverxtlogit150

xtreg rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
 if voted2016 == 1, fe
est store mutzoverlp
*/

*** BEGIN **********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

/*
outreg2 [mutzwarm mutzwarm_v2 mutzoverlogit mutzoverxtlogit* mutzoverlp] ///
  using docs/mutz-table-1.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
*/

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

estimates clear

* Macros for additional specifications 

local remove party3_dem
local mutz_time_varying_nop : list mutz_time_varying - remove

local time_varying_exog ///
  income look_work finances_better trade_help_u ///
  more_trade more_imm china_opp ///
  sdo economy_better

local time_varying_material ///
  income look_work finances_better trade_help_u ///
  more_trade china_opp ///
  economy_better

local time_varying_other ///
  more_imm sdo

*** BEGIN **********************************************************************
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **

*** Based on conclusions above for the comparison of Mutz's sdo variable
***  and her sdoscale10 variable, replace the sdoscale10 variable by wave 
***  varables sdo_xw1 with the alternative one derived from sdo, which is
***  sdo_xw1_v2.  This is dropped in to replace sdo_xw1 and renamed to be
***  to take its place.

drop sdo_xw1
rename sdo_xw1_v2 sdo_xw1

*** Estimate models

foreach var in party3_dem `time_varying_exog' {
 
 di "_________________________________________________________________________ "
 di "Determine pattern of valid observations for a bivariate FE model of"
 di "   Republican thermometer advantage on `var'"
 di " "
 di "  Note:  Stata will include one-wave-only observations in the model, but"
 di "          these observations do not contribute information to the primary"
 di "          bivariate association, which use only two-wave information."
 di " "
 
 *** sort and present valid sample
 
 quietly xtreg rep_warmer `var', fe
 
 gen in_model = 1 if e(sample) == 1
 egen valid_waves_`var' = total(in_model), by(MNO)
 tab valid_waves_`var' in_model, miss
 drop in_model
 
 egen `var'_mean = mean(`var'), by(MNO)
 gen `var'_dfm = `var' - `var'_mean

 bys `var'_mean: tab `var' wave2016 if valid_waves_`var'==2, miss
 bys `var'_mean: tab `var'_dfm wave2016 if valid_waves_`var'==2, miss
 
 ***************************************
 ***************************************
 *** Cross-sectional models
 ***************************************
 ***************************************
 
 local k 0
 
 preserve
 include analysis/reshape-in-loop-chunk.do
 
 di " "
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer0 `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel replace ///
  ctitle(N data, y0) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 `var'1
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1) ///
  addtext(2-wave-only, Yes, Changers, All) noaster
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 `var'1 `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1) ///
  addtext(2-wave-only, Yes, Changers, All) noaster
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 rep_warmer0 `var'1
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 rep_warmer0 `var'1 `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

 /*
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 `var'1 if `var'1 == `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1) ///
  addtext(2-wave-only, Yes, Changers, Stable) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 rep_warmer0 `var'1 if `var'1 == `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, Stable) noaster
  
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 `var'_diff `var'_mean
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1) ///
   addtext(2-wave-only, Yes, Changers, All) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 rep_warmer0 `var'_diff `var'_mean
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

  di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 `var'_diff
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer1 rep_warmer0 `var'_diff
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, All) noaster
*/
 restore
 
 ***************************************
 ***************************************
 *** 2-wave only R's, one-way FE
 ***************************************
 ***************************************
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' if valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, All, Group, A) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' if `var'_change ~= 0 & valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, A) noaster

 preserve
 include analysis/reshape-in-loop-chunk.do
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer_diff `var'_diff, nocons
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, A) noaster

 restore

 ***************************************
 ***************************************
 *** 2-wave only R's, two-way FE
 ***************************************
 ***************************************
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 if valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, All, Group, B) noaster
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 if `var'_change ~= 0 & valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, C) noaster

 preserve
 include analysis/reshape-in-loop-chunk.do
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer_diff `var'_diff 
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, B) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'" 
 di " "
 reg rep_warmer_diff `var'_diff if `var'1 ~= `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Changers, Group, C) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'" 
 di " "
 reg rep_warmer_diff `var'_diff ch_`var'
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, C) noaster

 restore
 
 /* 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer wave2016 if `var'_change ~= 0 & valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, G) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer `var' if `var'_change == 0 & valid_waves_`var'==2, cluster(MNO)
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, Pooled) ///
  addtext(2-wave-only, Yes, Changers, Stable, Group, D) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer `var' wave2016 if `var'_change == 0 & valid_waves_`var'==2, ///
  cluster(MNO)
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, Pooled) ///
  addtext(2-wave-only, Yes, Changers, Stable, Group, D) noaster
 */

 ***************************************
 ***************************************
 *** 2-wave only R's, two-period models
 ***************************************
 ***************************************
 
 /*
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer `var' wave2016 `var'_xw1 if `var'_change == 0 & ///
   valid_waves_`var'==2, cluster(MNO)
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, Pooled) ///
  addtext(2-wave-only, Yes, Changers, Stable, Group, E) noaster
  
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 `var'_xw1 if `var'_change == 0 & ///
  valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Stable, Group, E) noaster
 */

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 `var'_xw1 if valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, All, Group, F) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 `var'_xw1 if `var'_change ~= 0 ///
  & valid_waves_`var'==2, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, F) noaster
  
/*
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer wave2016 `var'_dfm `var'_mean if valid_waves_`var'==2
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, RE Hybrid) ///
  addtext(2-wave-only, Yes, Changers, All, Group, B) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer wave2016 `var'_dfm `var'_mean if `var'_change == 0 & ///
 valid_waves_`var'==2
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, RE Hybrid) ///
  addtext(2-wave-only, Yes, Changers, Stable, Group, D) noaster
 */

 preserve
 include analysis/reshape-in-loop-chunk.do
 
 /*
 di " "
 local ++k
 di "Model `k' for predictor `var'" 
 di " "
 reg rep_warmer_diff `var'_diff if `var'1 ~= `var'0, nocons
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Changers, Group, A) noaster
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer_diff `var'_diff if `var'1 == `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Stable, Group, D) noaster
 */
   
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer_diff `var'_diff `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, F) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer_diff `var'_diff `var'0 if `var'1 ~= `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Changers, Group, F) noaster
 
 /*
 di " "
 local ++k
 di "Model `k' for predictor `var'" 
 di " "
 reg rep_warmer_diff if `var'1 ~= `var'0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Changers, Group, G) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer_diff `var'_diff `var'_mean
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, F-Alt) noaster
 */
 
 restore

 ***************************************
 ***************************************
 *** Full sample models of various types
 ***************************************
 ***************************************
 
 /*
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var', fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, All, Group, A) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' if `var'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, Changers, Group, A) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, All, Group, B) noaster
 
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 if `var'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, Changers, Group, C) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer wave2016 if `var'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, Changers, Group, G) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer `var' if `var'_change == 0, cluster(MNO)
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, Pooled) ///
  addtext(2-wave-only, No, Changers, Stable, Group, D-Alt) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer `var' wave2016 if `var'_change == 0, cluster(MNO)
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, Pooled) ///
  addtext(2-wave-only, No, Changers, Stable, Group, D-Alt) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 reg rep_warmer `var' wave2016 `var'_xw1 if `var'_change == 0, cluster(MNO)
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, Pooled) ///
  addtext(2-wave-only, No, Changers, Stable, Group, E-Alt) noaster
  
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 `var'_xw1 if `var'_change == 0, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, Stable, Group, E) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 `var'_xw1, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, No, Changers, All, Group, F) noaster

  di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer `var' wave2016 `var'_xw1 if `var'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, F) noaster

 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer wave2016 `var'_dfm `var'_mean
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, RE Hybrid) ///
  addtext(2-wave-only, No, Changers, All, Group, B-Alt) noaster
  
 di " "
 local ++k
 di "Model `k' for predictor `var'"
 di " "
 xtreg rep_warmer wave2016 `var'_dfm `var'_mean if `var'_change == 0
 outreg2 using docs/fe_explain_`var'.xls, excel append ///
  ctitle(N x T data, RE Hybrid) ///
  addtext(2-wave-only, No, Changers, Stable, Group, D-Alt) noaster
 */

}

save data/explain-fe-models-long.dta, replace

keep MNO wave rep_warmer rep_warm dem_warm difftherm party3_dem education ///
 `time_varying_exog' valid*
drop if wave == .

reshape wide rep_warmer rep_warm dem_warm difftherm party3_dem education ///
 `time_varying_exog' valid*, ///
 i(MNO) j(wave)

gen rep_warmer_diff = rep_warmer1 - rep_warmer0

foreach var in party3_dem `time_varying_exog' { 
 gen `var'_diff = `var'1 - `var'0
 gen `var'_mean = (`var'1 + `var'0)/2
}
 
save data/explain-fe-models-wide.dta, replace

*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** CHUNK for SociusReply *** CHUNK for SociusReply *** CHUNK for SociusReply **
*** END ************************************************************************

log close

********************************************************************************
***  The rest of the file is (the remainder of 
***  (pnas-mutz-code-panel-edited-v2.do) is omitted.
********************************************************************************
