********Lab 4*******
***Feb 12th, 2021***
****Wenchen Wang****
***Patrick Alcorn***

*Preparation Procedure*
clear
cap log close
cd "O:\wang6054\PA5032_Spring2021\Lab4"
log using Lab_4
use WAGE1.DTA


***PART A. COMPARE MODELS***

/*What are the factors that might affect wages?*/


*Let's think about the relationship between wages and education
ssc install outreg2

reg wage educ exper tenure
outreg2 using lab4_reg.doc, replace ctitle(Model 1)

*Let's run a couple of regressions to confirm our hypothesis.

reg wage educ nonwhite female
outreg2 using lab4_reg.doc, append ctitle(Model 2)

/*Which one is a better model?*/



***PART B. INTERACTION TERMS***

*Interaction terms allow us to test for whether slopes are different for different groups

*Let's make a few tables to get a sense of the data*

*Differences in educational attainment between men and women*
table educ female

*Now let's incorporate average wages into the table*
table educ femal, c(mean wage)

/*What can you find from the table?*/


*First, let's estimate using a continuous variable for education*
gen f_educ = female*educ
reg wage female educ exper tenure f_educ

/*Can we reject our null hypothesis for the interaction term?*/


/*How do we interpret the interaction term?*/



