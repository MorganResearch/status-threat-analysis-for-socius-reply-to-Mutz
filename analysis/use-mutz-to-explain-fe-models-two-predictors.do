capture clear
capture log close
set more off
set linesize 120
cls

log using log/use-mutz-to-explain-fe-models-two-predictors.log, replace

********************************************************************************
*** This file carries on from use-mutz-to-explain-fe-models.do in order to 
***  demonstrate that the basic reasoning (with the slight exception of drift
***  complications) is the same for models with more than one predictor.
********************************************************************************

*** Select sample and variables

use data/explain-fe-models-long.dta, replace

local var1 sdo
local var2 trade_help_u

keep if valid_waves_`var1' == 2
keep if valid_waves_`var2' == 2

*** Estimate models

 ***************************************
 ***************************************
 *** Cross-sectional models
 ***************************************
 ***************************************
 
 preserve
 include analysis/reshape-in-loop-chunk-two-vars.do
  
 reg rep_warmer0 `var1'0 `var2'0
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel replace ///
  ctitle(N data, y0) ///
  addtext(2-wave-only, Yes, Changers, All) noaster
 
 reg rep_warmer1 `var1'1 `var2'1
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N data, y1) ///
  addtext(2-wave-only, Yes, Changers, All) noaster
 
 reg rep_warmer1 `var1'1 `var1'0 `var2'1 `var2'0
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N data, y1) ///
  addtext(2-wave-only, Yes, Changers, All) noaster
 
 reg rep_warmer1 rep_warmer0 `var1'1 `var2'1
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

 reg rep_warmer1 rep_warmer0 `var1'1 `var1'0 `var2'1 `var2'0
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N data, y1 with y0 lag) ///
  addtext(2-wave-only, Yes, Changers, All) noaster

 restore
 
 ***************************************
 ***************************************
 *** 2-wave only R's, one-way FE
 ***************************************
 ***************************************
 
 xtreg rep_warmer `var1' `var2', fe
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, All, Group, A) noaster

 xtreg rep_warmer `var1' `var2' if `var1'_change ~= 0 ////
  & `var2'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, A) noaster

 preserve
 include analysis/reshape-in-loop-chunk-two-vars.do
 
 reg rep_warmer_diff `var1'_diff `var2'_diff, nocons
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, A) noaster

 restore

 ***************************************
 ***************************************
 *** 2-wave only R's, two-way FE
 ***************************************
 ***************************************
 
 xtreg rep_warmer `var1' `var2' wave2016, fe
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, All, Group, B) noaster
 
 xtreg rep_warmer `var1' `var2' wave2016 if `var1'_change ~= 0 ///
  & `var2'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, C) noaster

 preserve
 include analysis/reshape-in-loop-chunk-two-vars.do
 
 reg rep_warmer_diff `var1'_diff `var2'_diff
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, B) noaster

 reg rep_warmer_diff `var1'_diff `var2'_diff if `var1'1 ~= `var1'0 ///
  & `var2'1 ~= `var2'0
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Changers, Group, C) noaster

 reg rep_warmer_diff `var1'_diff `var2'_diff ch_`var1' ch_`var2' ch_both
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, C) noaster

 restore

 ***************************************
 ***************************************
 *** 2-wave only R's, two-period models
 ***************************************
 ***************************************
 
 xtreg rep_warmer `var1' `var2' wave2016 `var1'_xw1 `var2'_xw1, fe
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, All, Group, F) noaster
  
 xtreg rep_warmer `var1' `var2' wave2016 `var1'_xw1 `var2'_xw1 ///
  if `var1'_change ~= 0 & `var2'_change ~= 0, fe
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
  ctitle(N x T data, FE) ///
  addtext(2-wave-only, Yes, Changers, Changers, Group, F) noaster

 preserve
 include analysis/reshape-in-loop-chunk-two-vars.do
    
 reg rep_warmer_diff `var1'_diff `var1'0 `var2'_diff `var2'0
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, All, Group, F) noaster

 reg rep_warmer_diff `var1'_diff `var1'0 `var2'_diff `var2'0 ///
  if `var1'1 ~= `var1'0 & `var2'1 ~= `var2'0
 outreg2 using docs/fe_explain_`var1'_`var2'.xls, excel append ///
   ctitle(N data, y1-y0) ///
   addtext(2-wave-only, Yes, Changers, Changers, Group, F) noaster
 
 restore

log close
