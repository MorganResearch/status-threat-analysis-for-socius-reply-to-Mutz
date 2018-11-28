capture clear
capture log close
set more off
set linesize 120
cls

log using log/mutz-code-cross-edited-v2.log, replace

********************************************************************************
********************************************************************************
*** Compare Mutz cross-sectional data for 1st and 2nd release
********************************************************************************
********************************************************************************

use rawdata/mutz-cross-first-release.dta, clear 

desc
codebook, c

cf _all using rawdata/mutz-cross-second-release.dta, verbose

use rawdata/mutz-cross-second-release.dta, clear 

desc
codebook, c

********************************************************************************
********************************************************************************
*** Mutz Analysis
********************************************************************************
********************************************************************************

*** Mutz recodes

egen cutdifftherm= cut(thermdiffTC), group(20)

recode majorsex (-4=4)(-3=3)(-2=2) (-1=1)(0=0)(1=-1) ///
  (2=-2) (3=-3) (4=-4), gen(majorsexR) ///
  
generate majorindex=(majorsexR+majorrelig+majorrace)/3

********************************************************************************
*** Mutz Table S4, with some critic revisions
***   (Critic excludes unavailable "immediate economic context" variables, 
***    recodes with macros, and renames variables for readability)
********************************************************************************
 
     /*all analysis */
	 /* Table S4 results */

local s4_Mutz_orig_vars party3 noncollegegrad white GENDER AGE7 religion ///
  INCOME lookwork ecoworry perecoperc safetynet majorindex pt4r sdoindex ///
  prejudice isoindex china immigindex tradeindex natsupindex ecoperc ///
  terrorthreat

regress cutdifftherm `s4_Mutz_orig_vars'
logit trumppref `s4_Mutz_orig_vars'  
logit voterclintrump `s4_Mutz_orig_vars'

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

recode age 1 = 1 2/5 = 2 6/7 = 3, gen(age_3gr)

local s4_pred party3_dem no_ba white female age_cohort religiosity income ///
  look_work concern_fut_exp finances_better tax_for_safety_net ///
  disc_high_stat am_life_threat sdo outgroup_prej support_isol china_opp ///
  support_immig support_trade nat_super economy_better terror_threat

* Mutz specifications 

local mutz_vars_party party3_dem

local mutz_vars_background no_ba white female age_cohort religiosity

local mutz_vars_hardship income look_work concern_fut_exp finances_better ///
  tax_for_safety_net  

local mutz_vars_threat disc_high_stat am_life_threat sdo outgroup_prej ///
  support_isol china_opp support_immig support_trade nat_super  

local mutz_vars_other economy_better terror_threat

local mutz_s4_vars `mutz_vars_party' `mutz_vars_background' ///
  `mutz_vars_hardship' `mutz_vars_threat' `mutz_vars_other'

regress t_warmer `mutz_s4_vars'
logit t_best `mutz_s4_vars'  
logit t_over_c `mutz_s4_vars'

********************************************************************************
********************************************************************************
*** Critic Analysis
***   Variant of results for Table S4, with alternative specifications
********************************************************************************
********************************************************************************

include analysis/critic-table-s4-alternative-specifications.do

********************************************************************************
********************************************************************************
*** Mutz Analysis, Table S5 and Figure 3
********************************************************************************
********************************************************************************

*** For Table S5, income was moved from "economic hardship/anxiety" into 
***   "background."  The remaning variables became "economic indicators."
***   Also, "national superiority" is dropped from status threat.
***   And "national economy (better)" and "terrorist threat" are not used.
***   As a result, the macros need to be revised and declared again.

local mutz_vars_party party3_dem

local mutz_vars_background no_ba white female age_cohort religiosity income

local mutz_vars_econ_ind look_work concern_fut_exp finances_better ///
  tax_for_safety_net  

local mutz_vars_threat disc_high_stat am_life_threat sdo outgroup_prej ///
  support_isol china_opp support_immig support_trade  

local mutz_vars_other nat_super economy_better terror_threat

**** Original code but with economic context variables removed:

  /* analysis demonstrating what education represents */
  /* Figure 3 and Table S5 results */
	
regress cutdifftherm party3 noncollegegrad white GENDER AGE7 religion INCOME
regress cutdifftherm party3 noncollegegrad white GENDER AGE7 religion INCOME ///
 lookwork ecoworry perecoperc safetynet
regress cutdifftherm party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  majorindex pt4r sdoindex prejudice isoindex china immigindex tradeindex     

logit trumppref party3 noncollegegrad white GENDER AGE7 religion INCOME
logit trumppref party3 noncollegegrad white GENDER AGE7 religion INCOME ///
 lookwork ecoworry perecoperc safetynet 
logit trumppref party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  majorindex pt4r sdoindex prejudice isoindex china immigindex tradeindex      

logit voterclintrump party3 noncollegegrad white GENDER AGE7 religion INCOME
logit voterclintrump party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  lookwork ecoworry perecoperc safetynet
logit voterclintrump party3 noncollegegrad white GENDER AGE7 religion INCOME ///
  majorindex pt4r sdoindex prejudice isoindex china immigindex tradeindex      

*** Critic's version with macros substituted and dydx:

regress t_warmer `mutz_vars_party' `mutz_vars_background'
est store wbase
margins, dydx(no_ba white) post
est store wbasem

regress t_warmer `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
est store wecon
margins, dydx(no_ba white) post
est store weconm

regress t_warmer `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
est store wthreat
margins, dydx(no_ba white) post
est store wthreatm

logit t_best `mutz_vars_party' `mutz_vars_background'
est store bbase
margins, dydx(no_ba white) post
est store bbasem

logit t_best `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
est store becon
margins, dydx(no_ba white) post
est store beconm

logit t_best `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
est store bthreat
margins, dydx(no_ba white) post
est store bthreatm

logit t_over_c `mutz_vars_party' `mutz_vars_background'
est store obase
margins, dydx(no_ba white) post
est store obasem

logit t_over_c `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
est store oecon
margins, dydx(no_ba white) post
est store oeconm

logit t_over_c `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
est store othreat
margins, dydx(no_ba white) post
est store othreatm

outreg2 [*] using docs/mutz-table-s5.xls, noaster e(r2_p chi2 df_m) excel replace
estimates clear

/*
  This code is provided, but these models do not seem to be in the paper.  They
   do not match the panel analysis in Table S3.  They do not match the Table
   S5 results either.  They include the ecoperc variable, which is labeled 
   economy_better above:

  /* models with only economic hardship vars */
  /* Table S3 results */
  
regress cutdifftherm party3 AGE7 GENDER noncollegegrad religion white ///
 INCOME lookwork ecoworry perecoperc safetynet ecoperc /* prop_manuf medianincome ///
  prop_civlaborforce_unemp */

logit voterclintrump party3 AGE7 GENDER noncollegegrad religion white ///
 INCOME lookwork ecoworry perecoperc safetynet ecoperc /* prop_manuf medianincome ///
  prop_civlaborforce_unemp */

logit trumppref party3 AGE7 GENDER noncollegegrad religion white ///
 INCOME lookwork ecoworry perecoperc safetynet ecoperc /* prop_manuf medianincome ///
  prop_civlaborforce_unemp */
*/
  
********************************************************************************
********************************************************************************
*** Critic Analysis
***   Variants of Table S5 (and hence Figure 3)
********************************************************************************
********************************************************************************

*** Vary the Mutz specifications

include analysis/critic-table-s5-mutz-but-whites-no-party.do

*** Macro's for critics conditioning sets

local critic_vars_demog white female age_cohort

local critic_vars_ses no_ba income

local critic_vars_predisp religiosity

local critic_vars_material look_work concern_fut_exp finances_better ///
 tax_for_safety_net china_opp support_trade economy_better 

local critic_vars_prejudice disc_men disc_christ disc_white am_life_threat sdo ///
 outgroup_prej nat_super

local critic_vars_other support_isol support_immig terror_threat

*** Some descriptive analysis

corr white no_ba `critic_vars_material'
corr no_ba `critic_vars_material' if white == 1

corr white no_ba `critic_vars_prejudice'
corr no_ba `critic_vars_prejudice' if white == 1

foreach var in `critic_vars_material' `critic_vars_prejudice' {
  summ `var'
  table white no_ba, c(mean `var' semean `var' n `var') format(%9.3f)
}

**** Critic specifications (simple baseline, full sample and whites only)

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-simple.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
estimates clear

preserve

keep if white == 1

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-simple-whites-only.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
estimates clear

restore

*** Critic specifications (simple baseline, full sample and whites only, 
***  with party id)

local critic_vars_predisp religiosity party3_dem

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-simple-with-party-id.xls, ///
  noaster e(r2_p chi2 df_m) excel replace
estimates clear

preserve

keep if white == 1

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-simple-whites-only-with-party-id.xls, ///
  noaster e(r2_p chi2 df_m) excel replace
estimates clear

restore

*** Critic specifications (complex baseline, full sample and whites only)

local critic_vars_demog i.white##i.female i.female##b4.age_cohort

local critic_vars_ses no_ba b2.age_3gr#c.income

local critic_vars_predisp i.white##i.religiosity

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-complex.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
estimates clear

preserve

local critic_vars_demog i.female##b4.age_cohort b10.income

local critic_vars_ses no_ba b10.income

local critic_vars_predisp i.religiosity

keep if white == 1

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-complex-whites-only.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
estimates clear

restore

*** Critic specifications (complex baseline, full sample and whites only,
***  with party id)

local critic_vars_demog i.white##i.female##b4.age_cohort

local critic_vars_ses no_ba b10.income

local critic_vars_predisp i.white##i.religiosity i.white##i.party3_dem

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-complex-with-party-id.xls, ///
  noaster e(r2_p chi2 df_m) excel replace
estimates clear

preserve

local critic_vars_demog i.female##b4.age_cohort b10.income

local critic_vars_ses no_ba b10.income

local critic_vars_predisp i.religiosity i.party3_dem

keep if white == 1

include analysis/critic-table-s5-alternative-specifications.do

outreg2 [*] using docs/critic-table-s5-complex-white-only-with-party-id.xls, ///
  noaster e(r2_p chi2 df_m) excel replace
estimates clear

log close
