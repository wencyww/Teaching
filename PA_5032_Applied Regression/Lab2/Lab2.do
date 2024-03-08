/****************************
Lab 2
Wenchen Wang & Patrick Alcorn
PA 5032
January 29, 2021
*****************************/

***Preparation Procedure***
clear
set more off
cap log close 
cd "O:\wang6054\PA5032_Spring2021\Lab2"
use Lab2_Data.dta 
log using lab2, text replace


***CLEANING DATA****

*We may want to generate a dummy variable that subsets another variable in our data set. For example we may want to divide total family income between less than $100,000 and greater than or equal to $100,000. The first step would be to “generate” a new variable that is equal to our old variable.
sum family_income

drop if family_income < 0

generate family_incomeunder100k = family_income

*Then, we would recode our new total family income variable so that households with a family income of less than $100,000 are assigned a value of 1, and families with incomes of $100,000 or greater are assigned a value of 0.
recode family_incomeunder100k(0/99999=1)
recode family_incomeunder100k(100000/9999997=0)
sum family_incomeunder100k


***PART A. SINGLE-VARIABLE REGRESSION
regress family_income age_reference

reg family_income reference_age


***PART B. HYPOTHESIS TESTING
**T-Test
ttest age_reference==29

ttest age_reference, by(family_incomeunder100k)

reg family_income age_reference 

**F-Test
reg healthcare_expenditure family_income reference_income

reg family_income age_reference number_children


***PART C: REGRESSION OUTPUT TABLES

*OUTREG2*
	ssc install outreg2
	reg family_income age_reference
	outreg2 using lab2_reg.doc, replace ctitle(Model 1)

*To append, or add a second model, run your next regression, and then use the same .doc file name and just do, append and change the ctitle

	reg family_income age_reference number_children
	outreg2 using lab2_reg.doc, append ctitle(Model 2)

*ESTOUT*
	ssc install estout
	reg family_income age_reference
	est store m1, title(Model 1) 
	estout m1, cells(b(star fmt(3)) se(par fmt(2))) replace starlevels(* 0.1 ** 0.05 *** 0.01) legend label varlabels(_cons Constant)stats(r2 N) 
 
 *To add a second model to the same table, store using est, and then add whatever your stored to your estout command.
	reg family_income age_reference number_children
	est store m2, title(Model 2)
	estout m1 m2, cells(b(star fmt(3)) se(par fmt(2))) replace starlevels(* 0.1 ** 0.05 *** 0.01) legend label varlabels(_cons Constant)stats(r2 N) 
	
log close

