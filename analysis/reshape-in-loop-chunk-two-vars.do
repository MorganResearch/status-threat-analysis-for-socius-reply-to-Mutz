 keep MNO wave rep_warmer `var1' `var2' 

 reshape wide rep_warmer `var1' `var2', i(MNO) j(wave)

 gen rep_warmer_diff = rep_warmer1 - rep_warmer0
 
 gen `var1'_diff = `var1'1 - `var1'0
 gen `var1'_mean = (`var1'1 + `var1'0)/2
 
 gen `var2'_diff = `var2'1 - `var2'0
 gen `var2'_mean = (`var2'1 + `var2'0)/2

 gen ch_`var1' = .
 replace ch_`var1' = 0 if `var1'1 == `var1'0
 replace ch_`var1' = 1 if `var1'1 ~= `var1'0
 
 gen ch_`var2' = .
 replace ch_`var2' = 0 if `var2'1 == `var2'0
 replace ch_`var2' = 1 if `var2'1 ~= `var2'0
 
 gen ch_both = ch_`var1' * ch_`var2'
 
