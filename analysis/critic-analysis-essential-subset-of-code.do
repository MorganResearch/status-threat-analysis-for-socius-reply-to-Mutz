

capture clear
capture log close
set more off
set linesize 120
cls

log using log/critic-analysis-essential-subset-of-code.log, replace

********************************************************************************
********************************************************************************
*** Cross-sectional Analysis (Tables 1 and 3)
********************************************************************************
********************************************************************************

********************************************************************************
*** Compare Mutz cross-sectional data for 1st and 2nd release
********************************************************************************

use rawdata/mutz-cross-first-release.dta, clear 

desc
codebook, c

cf _all using rawdata/mutz-cross-second-release.dta, verbose

use rawdata/mutz-cross-second-release.dta, clear 

desc
codebook, c

********************************************************************************
*** Set up
********************************************************************************

*** Mutz recodes (her code)

egen cutdifftherm= cut(thermdiffTC), group(20)

recode majorsex (-4=4)(-3=3)(-2=2) (-1=1)(0=0)(1=-1) ///
  (2=-2) (3=-3) (4=-4), gen(majorsexR) ///
  
generate majorindex=(majorsexR+majorrelig+majorrace)/3

*** Create clones for readability

clonevar t_warmer = cutdifftherm
clonevar t_best = trumppref
clonevar t_over_c = voterclintrump

clonevar party3_dem = party3 
clonevar no_ba = noncollegegrad  
clonevar female = GENDER 
clonevar age_cohort = AGE7 
clonevar religiosity = religion
clonevar income = INCOME 
clonevar look_work = lookwork 
clonevar concern_fut_exp = ecoworry 
clonevar finances_better = perecoperc  
clonevar tax_for_safety_net = safetynet
clonevar disc_high_stat = majorindex 
clonevar am_life_threat = pt4r  
clonevar sdo = sdoindex 
clonevar outgroup_prej = prejudice
clonevar support_isol = isoindex 
clonevar china_opp = china 
clonevar support_immig = immigindex
clonevar support_trade = tradeindex
clonevar nat_super = natsupindex
clonevar economy_better = ecoperc
clonevar terror_threat = terrorthreat

clonevar disc_men = majorsexR
clonevar disc_christ = majorrelig
clonevar disc_white = majorrace

********************************************************************************
*** Mutz Analysis, Table S5 and Figure 3, Recreated for Critic Table 1
********************************************************************************

*** Mutz's specifications stored as macros

local mutz_vars_party party3_dem

local mutz_vars_background no_ba white female age_cohort religiosity income

local mutz_vars_econ_ind look_work concern_fut_exp finances_better ///
  tax_for_safety_net  

local mutz_vars_threat disc_high_stat am_life_threat sdo outgroup_prej ///
  support_isol china_opp support_immig support_trade  

local mutz_vars_other nat_super economy_better terror_threat

*** Mutz's original code but with economic context variables removed:

 /* analysis demonstrating what education represents */
 /* Figure 3 and Table S5 results */
	
regress cutdifftherm party3 noncollegegrad white GENDER AGE7 religion INCOME
regress cutdifftherm party3 noncollegegrad white GENDER AGE7 religion INCOME ///
 lookwork ecoworry perecoperc safetynet
regress cutdifftherm party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  majorindex pt4r sdoindex prejudice isoindex china immigindex tradeindex     

logit voterclintrump party3 noncollegegrad white GENDER AGE7 religion INCOME
logit voterclintrump party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  lookwork ecoworry perecoperc safetynet
logit voterclintrump party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  majorindex pt4r sdoindex prejudice isoindex china immigindex tradeindex
  
logit trumppref party3 noncollegegrad white GENDER AGE7 religion INCOME
logit trumppref party3 noncollegegrad white GENDER AGE7 religion INCOME ///
 lookwork ecoworry perecoperc safetynet 
logit trumppref party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  majorindex pt4r sdoindex prejudice isoindex china immigindex tradeindex      

*** Critic's version with macros substituted and dydx added:

regress t_warmer `mutz_vars_party' `mutz_vars_background'
margins, dydx(no_ba)

regress t_warmer `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
margins, dydx(no_ba)

regress t_warmer `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
margins, dydx(no_ba)

logit t_over_c `mutz_vars_party' `mutz_vars_background'
margins, dydx(no_ba)

logit t_over_c `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
margins, dydx(no_ba)

logit t_over_c `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
margins, dydx(no_ba)

* Supplemental, not in Table 1:

logit t_best `mutz_vars_party' `mutz_vars_background'
margins, dydx(no_ba)

logit t_best `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
margins, dydx(no_ba)

logit t_best `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
margins, dydx(no_ba)

********************************************************************************
*** Critic Analysis, Table 3
********************************************************************************

*** Macros for critic's conditioning sets (ignoring party id for now)

local critic_vars_demog white female age_cohort

local critic_vars_ses no_ba income

local critic_vars_predisp religiosity

local critic_vars_material look_work concern_fut_exp finances_better ///
  tax_for_safety_net china_opp support_trade economy_better
 
local critic_vars_prejudice disc_men disc_christ disc_white am_life_threat ///
  sdo outgroup_prej nat_super
 
local critic_vars_other support_isol support_immig terror_threat

*** Critic specifications (whites only, no party id in baseline)

preserve

keep if white == 1

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'  
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

* Supplemental, not in Table 3:

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' 
est store bbase
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
 `critic_vars_material'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

restore

*** Critic specifications (full sample, no party id in baseline)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'  
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

* Supplemental, not in Table 3:

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' 
est store bbase
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
 `critic_vars_material'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

***  Add party id to baseline variables ****************************************

local critic_vars_predisp religiosity party3_dem

*** Critic specifications (whites only, with party id in baseline)

preserve

keep if white == 1

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'  
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

* Supplemental, not in Table 3:

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' 
est store bbase
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
 `critic_vars_material'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

restore

*** Critic specifications (full sample, with party id in baseline)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'  
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

* Supplemental, not in Table 3:

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' 
est store bbase
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
 `critic_vars_material'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
margins, dydx(no_ba)

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
margins, dydx(no_ba)

********************************************************************************
********************************************************************************
*** Panel-Data Analysis (Tables 4, A1, and A2)
********************************************************************************
********************************************************************************

********************************************************************************
*** Load merged data created by 
***    mk-mutz-panel-merged-releases.do
********************************************************************************

use data/mutz-panel-merged-releases.dta, clear 

* drop from merged data because recreated with this Mutz's code below

drop difftherm prexparty3wave preincomewave cutdifftherm

********************************************************************************
*** Set up
********************************************************************************

* Original Mutz code:

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
* Need to comment out these lines because zip code variables were not provided:
*   generate newacs_medianinc=acs_medianinc/1000
*   generate acsincomewave =newacs_medianinc*wave
*   generate acsunemplwave = acs_unemploy*wave
*   generate acsmfgwave = acs_mfg*wave
generate pretradeperwave=pretradeper*wave
generate prexparty3wave=prexparty3*wave
generate preincomewave=preincome*wave

*** Critic set up

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

*** Create clones for readability 

* Outcome vars

clonevar rep_warmer = cutdifftherm
clonevar rep_over_dem = demrepvote

clonevar rep_warm = reptherm
clonevar dem_warm = demtherm

* Time-varying vars

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

* First wave variables copied into both waves as constants

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

* First wave constant variables multiplied by wave dummy

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

* Create candidate and difference variables 

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
*** Recreate Mutz's analysis for her Table 1
********************************************************************************

xtset MNO wave

*** Note first that Mutz's third release of the data files is a slightly
***  different sample.  

tab wave release3, miss
table wave release3, c(mean cutdifftherm mean demrepvote n MNO)

***  The results are very slightly different, and both are produced
***  below by Mutz's code, with a further if statement added
***  for the third release of the dataset.  (See below for an anslysis of
***  release 3.)  Also, the N's and coefficients difference slightly than for
***  her Table 1 because the (non-varying) economic context variables are not
**   in the released dataset(s).
 
xtreg cutdifftherm xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
  	tradediffrep immdiffrep chinadiffrep ///
   	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave ///
    wave , fe 

logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave ///
    wave if voted2016==1, cluster(MNO) 

xtreg cutdifftherm xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
  	tradediffrep immdiffrep chinadiffrep ///
   	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave ///
    wave if release3 == 1, fe 

logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave  ///
    wave if voted2016==1 & release3 == 1, cluster(MNO) 

********************************************************************************
*** Critic Analysis 
***   Consider patterns of outcome vars and release 3)
***   Calculate results for Table A2
********************************************************************************

* temporary files

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

* Results for Table A2:

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

use `long_all_vars', replace

********************************************************************************
********************************************************************************
*** Critic Analysis (Figure 1, with change by education level)
***   Calculate results for Table A2
********************************************************************************

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
  regress `var' i.educ3##i.wave
  regress `var' i.wave if voted2016==1
  regress `var' i.educ3##i.wave if voted2016==1
  table educ3 wave, c(mean `var' semean `var' n `var') format(%9.2f)
  table educ3 wave if voted2016==1, c(mean `var' semean `var' n `var') ///
    format(%9.2f)
}

********************************************************************************
********************************************************************************
*** Critic Analysis 
***   Examine variation in Mutz's panel results in her Table 1
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

*** Basic replications

* Notes:
*  1.  High income individuals excluded from release 3 can be included, recoding
*        to 19.
*  2.  The logit is fit, rather than xtlogit, becuase xtlogit does not converge.
*        Results below show parameter chaos when iterations are stopped at 50
*        and 150 for xtlogit.  Final models shows that a fixed-effect linear 
*        probability model can be estimated.

xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if release3 == 1, fe

xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave, fe

recode income 20 21 = 19

xtreg rep_warmer `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave, fe

logit rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if voted2016 == 1, cluster(MNO)

xtlogit rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if voted2016 == 1, fe iter(50)

xtlogit rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
  if voted2016 == 1, fe iter(150)

xtreg rep_over_dem `mutz_time_varying' `mutz_wave0_vars_in_wave1' wave ///
 if voted2016 == 1, fe

********************************************************************************
********************************************************************************
*** Critic Analysis 
***   Results for Table 4
********************************************************************************
********************************************************************************

*** Macros for additional specifications 

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

* Bivariate regression

foreach var in party3_dem `time_varying_exog' {
 xtreg rep_warmer `var', fe
}

foreach var in party3_dem `time_varying_exog' {
 xtreg rep_warmer `var' wave2016, fe
}

* Multiple regression

xtreg rep_warmer `time_varying_material', fe

xtreg rep_warmer `time_varying_other', fe

xtreg rep_warmer `time_varying_exog', fe

log close
