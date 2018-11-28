*** Macros

local remove party3_dem
local mutz_s4_vars_nop : list mutz_s4_vars - remove

local remove party3_dem disc_high_stat
local mutz_s4_vars_nop_nod : list mutz_s4_vars - remove
	 
local disc_subscales disc_men disc_christ disc_white

*** Remove party

regress t_warmer `mutz_s4_vars_nop' 
logit t_best `mutz_s4_vars_nop'  
logit t_over_c `mutz_s4_vars_nop'

*** Remove party, white only

regress t_warmer `mutz_s4_vars_nop' if white == 1
logit t_best `mutz_s4_vars_nop'  if white == 1 
logit t_over_c `mutz_s4_vars_nop'  if white == 1

*** Remove party, separate high status discrimination to three subscales

regress t_warmer `mutz_s4_vars_nop_nod' `disc_subscales'
logit t_best `mutz_s4_vars_nop_nod'  `disc_subscales'
logit t_over_c `mutz_s4_vars_nop_nod'  `disc_subscales'

*** Remove party, white only, separate high status discrimination to three subscales

regress t_warmer `mutz_s4_vars_nop_nod' `disc_subscales' if white == 1
logit t_best `mutz_s4_vars_nop_nod'  `disc_subscales' if white == 1 
logit t_over_c `mutz_s4_vars_nop_nod' `disc_subscales' if white == 1
