

capture clear
capture log close
set more off
set linesize 120
cls

log using log/additional-results-for-reply-to-Mutz.log, replace


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
*** Morgan Reanalysis Results
********************************************************************************
********************************************************************************

* temproary files

tempfile long_all_vars

save `long_all_vars'

tab voted2012 rep_over_dem if wave == 0, r col cell miss
tab voted2016 rep_over_dem if wave == 1, r col cell miss

tab voted2012 rep_over_dem if wave == 0 & release3 == 1, r col cell miss
tab voted2016 rep_over_dem if wave == 1 & release3 == 1, r col cell miss

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

gen romney = rep_over_dem2012
gen trump = rep_over_dem2016

tab voted20122012 romney, r col cell miss
tab voted20122016 romney, r col cell miss
tab voted20162016 trump, r col cell miss

tab voted20122016 romney if release32016 == 1, r col cell miss
tab voted20162016 trump if release32016 == 1, r col cell miss

gen vote_both=0
replace vote_both = 1 if voted20122016 == 1 & voted20162016 == 1
 
tab romney trump, r col cell miss
tab romney trump, r col cell
tab romney trump if release32016 == 1, r col cell
 
tab romney trump if voted20162016 == 1, r col cell miss
tab romney trump if voted20162016 == 1, r  col cell
tab romney trump if voted20162016 == 1 & release32016 == 1, r col cell

tab romney trump if vote_both == 1, r col cell miss
tab romney trump if vote_both == 1, r col cell
tab romney trump if vote_both == 1 & release32016 == 1, r col cell


/* 

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

*/

log close
