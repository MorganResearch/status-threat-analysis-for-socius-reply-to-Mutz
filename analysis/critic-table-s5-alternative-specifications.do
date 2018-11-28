*** Critic specifications

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
est store wbase
margins, dydx(no_ba) post
est store wbasem

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'
est store wmat
margins, dydx(no_ba) post
est store wmatm

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
est store woth
margins, dydx(no_ba) post
est store wothm

regress t_warmer `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
est store wprej
margins, dydx(no_ba)  post
est store wprejm

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' 
est store bbase
margins, dydx(no_ba) post
est store bbasem

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
 `critic_vars_material'
est store bmat
margins, dydx(no_ba) post
est store bmatm

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
est store both
margins, dydx(no_ba) post
est store bothm

logit t_best `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
est store bprej
margins, dydx(no_ba) post
est store bprejm

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp'
est store obase
margins, dydx(no_ba) post
est store obasem

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material'  
est store omat
margins, dydx(no_ba) post
est store omatm

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_material' `critic_vars_other'
est store ooth
margins, dydx(no_ba) post
est store oothm

logit t_over_c `critic_vars_demog' `critic_vars_ses' `critic_vars_predisp' ///
  `critic_vars_prejudice'
est store oprej
margins, dydx(no_ba) post
est store oprejm
