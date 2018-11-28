*** Mutz specifications, but whites only
 
preserve
keep if white == 1

regress t_warmer `mutz_vars_party' `mutz_vars_background'
est store wbase
margins, dydx(no_ba) post
est store wbasem

regress t_warmer `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
est store wecon
margins, dydx(no_ba) post
est store weconm

regress t_warmer `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
est store wthreat
margins, dydx(no_ba) post
est store wthreatm

logit t_best `mutz_vars_party' `mutz_vars_background'
est store bbase
margins, dydx(no_ba) post
est store bbasem

logit t_best `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
est store becon
margins, dydx(no_ba) post
est store beconm

logit t_best `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
est store bthreat
margins, dydx(no_ba) post
est store bthreatm

logit t_over_c `mutz_vars_party' `mutz_vars_background' `critic_vars_predisp'
est store obase
margins, dydx(no_ba) post
est store obasem

logit t_over_c `mutz_vars_party' `mutz_vars_background' `mutz_vars_econ_ind'
est store oecon
margins, dydx(no_ba) post
est store oeconm

logit t_over_c `mutz_vars_party' `mutz_vars_background' `mutz_vars_threat'
est store othreat
margins, dydx(no_ba) post
est store othreatm

outreg2 [*] using docs/mutz-table-s5-whites-only.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
estimates clear

*** Mutz specification, but whites only, and no party id

regress t_warmer  `mutz_vars_background'
est store wbase
margins, dydx(no_ba) post
est store wbasem

regress t_warmer `' `mutz_vars_background' `mutz_vars_econ_ind'
est store wecon
margins, dydx(no_ba) post
est store weconm

regress t_warmer `' `mutz_vars_background' `mutz_vars_threat'
est store wthreat
margins, dydx(no_ba) post
est store wthreatm

logit t_best `mutz_vars_background'
est store bbase
margins, dydx(no_ba) post
est store bbasem

logit t_best `mutz_vars_background' `mutz_vars_econ_ind'
est store becon
margins, dydx(no_ba) post
est store beconm

logit t_best `mutz_vars_background' `mutz_vars_threat'
est store bthreat
margins, dydx(no_ba) post
est store bthreatm

logit t_over_c `mutz_vars_background'
est store obase
margins, dydx(no_ba) post
est store obasem

logit t_over_c `mutz_vars_background' `mutz_vars_econ_ind'
est store oecon
margins, dydx(no_ba) post
est store oeconm

logit t_over_c `mutz_vars_background' `mutz_vars_threat'
est store othreat
margins, dydx(no_ba) post
est store othreatm

outreg2 [*] using docs/mutz-table-s5-whites-only-no-party.xls, noaster ///
  e(r2_p chi2 df_m) excel replace
estimates clear

restore



