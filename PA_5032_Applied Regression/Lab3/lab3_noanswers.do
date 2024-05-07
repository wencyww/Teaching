clear
set more off
cap log close
cd "O:\alcor031\PA5032Lab_2021\week3_lab"
use lab3_data.dta
log using lab3_log, text replace


****LAB 3****
****February 5th, 2021****

***PART A. F-TEST
***Suppose we regress healthcare expenditures on family income, controlling for the income of the reference person.

reg healthcare_expenditure family_income  reference_income


****What does the f-statistic and related p-value of the regression output indicate? 





*** We’re a little suspicious that the effect of family income on healthcare expenditures may be the same as the effect of reference person income. What would be the null hypothesis of our F Test?





***Test your null hypothesis with an F Test. What do the results show?

test family_income = reference_income





***PART B. OMITTED AND IRRELEVANT VARIABLES***

***We’re interested in looking at the relationship between healthcare expenditures and family income. Let’s start with a simple regression with healthcare expenditures as our dependent variable and family income as the independent variable.

reg healthcare_expenditure family_income

*** Describe the STATA output. What’s the relationship between healthcare expenditures and family income?




** What might be wrong with our model?




pwcorr healthcare_expenditure race_black

** Now let's run the regression

reg healthcare_expenditure family_income race_black


***Let’s shift our attention to house_value. Start by regressing house_value on family_income.

reg house_value family_income

***Your colleague suggests that this model is too simple and thinks you should add reference_income and number_children as controls.
reg house_value family_income reference_income number_children

*Did the additional controls improve our model? Why or why not?





*** How can we address the shortcomings of this new model? 




***Let’s run our revised model and compare the results.
reg house_value family_income number_children