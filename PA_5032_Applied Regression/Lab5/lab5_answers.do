/****************************
Lab 5
Patrick Alcorn & Wenchen Wang
PA 5032
February 19, 2021
*****************************/
clear
set more off
cap log close
cd "O:\alcor031\PA5032Lab_2021\week5_lab"
use "WAGE1"
log using PA5032_lab5_part1, text replace 

ssc install outreg2

****************************************
********PART A: MULTICOLLINEARITY*******
****************************************

* Let's see if there’s any multicollinearity present when we regress tenure on experience, controlling for experience^2, wage, and educ.

reg tenure exper expersq wage educ

*Check for multicollinearity

vif

pwcorr exper expersq

* How can we interpret the outcome of our VIF test? What can we do to alter our model?

* The VIF statistics on exper and expersq are both above 14, which is above the threshold statistic of 5. This indicates that the two variables are multicollinear. To adjust the model, we should drop one of the variables — expersq. 



* Adjust model

reg tenure exper wage educ
log close 

****************************************
**********LOAD EITC DATA****************
****************************************

clear
set more off
cap log close
cd "O:\alcor031\PA5032Lab_2021\week5_lab"
use "eitc"
log using PA5032_lab5_part2, text replace 


ssc install outreg2

****************************************
*********PART B: DUMMY VARIABLES********
****************************************

***1) Dummy Independent Variables ***
reg earn nonwhite


***2) Dummy Independent Variables***

reg work ed

***3) Dummy Categorical Variables***

/* Often continuous educational attainment variables are converted into categorical dummy variables. So instead of having each year of completed education coded as a value, different cutoffs are used to create Yes/No dummy variables. 

Why might this be done in theory?*/

* Each year of education most likely does not have the same effect. Instead, certain thresholds (HS, college, grad degrees) are more likely to be where impacts on earnings take place. 



*First, let's create a categorical variable out of the semi-continous "ed" variable
tab ed
egen educ=cut(ed), at(0,1,6,8,20)
tab educ
recode educ (6=2) (8=3)
tab educ

*It is always nice to label your new variable so you remember what your buckets are*
*Two Part command... label define, and then label values
label define educlabel 0 "NoSchool" 1 "LessThanMiddleSchool" 2 "MiddleSchoolGrad" 3 "MiddleSchool+"
label values educ educlabel



/** Now let's generate our dummy variables out of the new categorical education variable

There are multiple options to do this. Generate and manually recode them all, use a tab, or use an index in your regression.*/

*Tab Method*
tab educ, gen(dummy)



*Notice the dummy variables now show up in the variable list, and their past labels are still connected, which is nice.


***REMEMBER!! YOU MUST EXCLUDE A REFERENCE GROUP OR STATA WILL GET MAD AT YOU!***
reg earn age dummy1 dummy2 dummy3 dummy4
*IE: Automatically omit one of the groups due to perfect coliniearity.



reg earn age dummy2 dummy3 dummy4


*Index Method*
reg earn age i.educ


*By including the i. before the categorical variable, STATA knows to just create dummy variables, and will automatically omit the lowest valued dummy as the Reference group.


* Interpret the coefficient on LessThanMiddleSchool and MiddleSchool+.

*Answers:

*Women with less than a middle school degree earn $1,281 less on average than those with no reported years of schooling.

*Women with a middle school degree earn 1,234 dollars less on average than those without any education.



* Interpret the constant term.
*answer:
* Women who are 0 years old with zero years of schooling earn $8,280 dollars on average




****************************************
***PART B: QUADRATIC FUNCTIONAL FORMS***
****************************************
/*Sometimes the relationship between the variables in your model will be nonlinear. One way to check the nature of the relationship between your X and Y is to make a specialized scatterplot to see the graphical representation of your model.*/


*To take a peak at your data structure, you can run a special kind of scatterplot
lowess earn age



*Let's say we are skeptical of a linear fit, so decide to square our age variable
gen age2= age^2



*Then run both the original and newly squared model... you must include the regular age in the squared model as well.
reg earn age 
outreg2 using Lab4.doc, replace ctitle(Model 1) 


reg earn age age2
outreg2 using Lab4.doc, append ctitle(Model 2) 

/*What happens to the coefficient on age? Is the second model better at explaining the variation in income?
* The coefficient in the second model is negative. This means that there is an u-shaped parabola. As women get older, early in life the relationship is negative, but eventually becomes positive once they reach a certain age. */ 




****************************************
****** PART C: LOGARITHMIC MODELS ******
****************************************
/*There are three main types of log models, log dependent, log independent, and log-log models. In a log dependent model, only the Y variable is logged.  Let’s continue to explore the impact of education on earnings, but first we need to generate a logged income variable. Then we can run our model.*/



***Logged Dependent Variables***


*To create a logged variable, use the ln() command
gen lnearn=ln(earn)
replace lnearn=0 if earn<1

reg lnearn ed

*Practice interpreting the coefficient on ed.

*answer: For each additional year of education a women who receives EITC has, her earnings are expected to decrease by 3.3% on average.


***Logged Independent Variables***
regress children lnearn

*Practice interpreting the coefficient on lnearn.

* If a women's earnings increase by 100%, her total number of children is expected to decline by 0.06 kids on average.



***Log-Log Models***
*First we need to generate a second logged variable*
gen lnfinc=ln(finc)
replace lnfinc=0 if finc<1

reg lnfinc lnearn


*Interpret the coefficient on lnearn. Is it significant?

* If a women's earning increase by 100%, her total family income is expected to increase by 27.2% on average.

* OR if earnings increases by 1%, than family income increases by .27%.
