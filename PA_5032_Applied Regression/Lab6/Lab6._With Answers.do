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

*Answer: With 1% increase in annual earnings, the number of children would decrease by (-0.15/100) = -0.0015 unit.


*1. Eye-Ball Residuals*

*plotting residuals 1 (by hand)
predict res, resid
scatter res earn 

*plotting residuals 2
rvpplot lnearn

*How to eyeball the residual plot for heteroskedasticity?
*Answer: the degree of scattering should be the same/constant for all fitted values

*Breusch_pagan test 1 (by hand)
gen res2=res*res
reg res2 lnearn ed nonwhite age age2

*How do we interpret the results here? Do we reject or fail to reject the Null Hypothesis?
*Look at the significance of each individual independent varibale as well as the joint significant of all of the independent variables from the F-test. If any of them are statistically significant, we would reject the null of homoskedasticity and conclude that there exist heteroskedasticity.

*Breusch_pagan test 2
reg children lnearn ed nonwhite age age2
hettest, rhs
hettest lnearn

*Do we reject the null hypothesis for either of these tests?
*Answer: Since both of these test statistics are significant even at 1% level. We fail to reject the null hypothesis of constant variance and we conclude that there exist hetereoskedasticity in our functional form.


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
*Since both coefficients on children and children2 are significant, and the joint F-test is also significant, we reject the null of constant variance and conclude that there exist heteroskedasticity.

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
*Answer: The coefficients are all the same, the robust SEs are all larger than the regular SE, and the clustered SEs are even larger. This also tells us that usially the bias of SE from heteroskedasticity is downward, resulting in t-statistics that allow us to reject the null when we shouldn’t.



log close
