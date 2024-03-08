******************************
*LAB 6*
*PA_5032*
*Wenchen Wang & Patrick Alcorn*
*******************************

clear
cap log close

cd "O:\wang6054\PA5032_Spring2021\Lab6"
log using Lab_6.log, replace
use EITC2.dta /*make sure the dta file is in the folder above*/



*PART A: Detecting Heteroskedasticity*
reg children lnearn ed nonwhite age age2

*How can we interpret the coefficient on lnearn (Interpreting logged independent variable)?


*1. Eye-Ball Residuals*

*plotting residuals 1 (by hand)
predict res, resid
scatter res earn 

*plotting residuals 2
rvpplot lnearn

*How to eyeball the residual plot for heteroskedasticity?

*Breusch_pagan test 1 (by hand)
gen res2=res*res
reg res2 lnearn ed nonwhite age age2

*How do we interpret the results here? Do we reject or fail to reject the Null Hypothesis?

*Breusch_pagan test 2
reg children lnearn ed nonwhite age age2
hettest, rhs
hettest lnearn

*Do we reject the null hypothesis for either of these tests?


******************************************
/*Let's run our model with the unlogged version of earn to see if that helps
eliminate heteroskedasticity*/

reg earn children ed nonwhite age age2
predict Res, resid

*White test 1 (by hand)
gen Res2= Res*Res
gen children2=children*children
reg Res2 children children2

*Can we reject the null hypothesis of homoskedasticity?


*White test 2
reg children earn ed nonwhite age age2
imtest, white


*PART B: Correcting Heteroskedasticity*
ssc install outreg2 

reg earn children ed nonwhite age age2
outreg2 using Lab_6.doc, replace ctitle(regular SE) bdec(3) adjr

reg earn children ed nonwhite age age2, vce(robust)
outreg2 using Lab_6.doc, append ctitle(robust SE) bdec(3) adj

reg earn children ed nonwhite age age2, vce(cluster earn)
outreg2 using Lab_6.doc, append ctitle(cluster SE) bdec(3) adjr

*How do the three models compare? Did the coefficients change? What about the SEs and significance?



log close
