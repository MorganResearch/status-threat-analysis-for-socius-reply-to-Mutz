 keep if valid_waves_`var'==2
 keep MNO wave rep_warmer `var' 

 reshape wide rep_warmer `var', i(MNO) j(wave)

 gen rep_warmer_diff = rep_warmer1 - rep_warmer0
 gen `var'_diff = `var'1 - `var'0
 gen `var'_mean = (`var'1 + `var'0)/2

 gen ch_`var' = .
 replace ch_`var' = 0 if `var'1 == `var'0
 replace ch_`var' = 1 if `var'1 ~= `var'0
 
