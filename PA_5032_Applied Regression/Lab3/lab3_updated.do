clear
cd "/Users/wenchenwang/Documents/Teaching/PA_5032_Applied Regression/Lab3"

use cps_cleaned.dta

keep cpsidp year month age black nchild earnweek hourwage covidunaw
keep if year == 2020
keep if month > 4

save lab3_cps.dta

replace covidunaw = 0 if covidunaw == 1
replace covidunaw = 1 if covidunaw == 2

reg covidunaw earnweek hourwage

test earnweek = hourwage

reg covidunaw earnweek

corr covidunaw black

reg covidunaw earnweek black

reg union covidunaw

reg union covidunaw age nchild
