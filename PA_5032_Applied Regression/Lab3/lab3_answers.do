clear
set more off
cap log close
cd "O:\alcor031\PA5032Lab_2021\week3_lab"
use lab3_data.dta
log using lab3_log, text replace

****************************
*******  LAB 3  ************
****************************


****February 5th, 2021****

***PART A. F-TEST
***Suppose we regress healthcare expenditures on family income, controlling for the income of the reference person.

reg healthcare_expenditure family_income  reference_income


****What does the f-statistic and related p-value of the regression output indicate? 




***************************************************************************************
*Answer: The independent variables of our model explains significantly more variation in healthcare expenditures than the mean.
***************************************************************************************

*** We’re a little suspicious that the effect of family income on healthcare expenditures may be the same as the effect of reference person income. What would be the null hypothesis of our F Test?




***************************************************************************************
*Answer: There is not a statistically significant difference between the effect of family income on healthcare expenditures and the effect of the reference person income on healthcare expenditures.
***************************************************************************************

***Test your null hypothesis with an F Test. What do the results show?

test family_income = reference_income




***************************************************************************************
*Answer: The F statistic indicates that we can reject the null hypothesis. Family income and reference income have unique effects. 
***************************************************************************************

***PART B. OMITTED AND IRRELEVANT VARIABLES***

***We’re interested in looking at the relationship between healthcare expenditures and family income. Let’s start with a simple regression with healthcare expenditures as our dependent variable and family income as the independent variable.

reg healthcare_expenditure family_income

*** Describe the STATA output. What’s the relationship between healthcare expenditures and family income?




***************************************************************************************
*Answer: Our STATA output estimates a positive relationship between family income and health care expenditures. On average, a one dollar increase in family income is associated with a .02 dollar increase in healthcare expenditures (you may want to convert this into hundreds or thousands of dollars for a more meaningful interpretation). 
***************************************************************************************

** What might be wrong with our model?




pwcorr healthcare_expenditure race_black
***************************************************************************************
*Answer: In order to determine the bias of our omitted variable (race_blac), we need to determine the direction of that variable’s relationship with both our dependent variable and our key independent variable.

*The correlation matrix below indicates that race_black and healthcare_expenditures (our dependent variable) have a negative relationship. Furthermore, due to historic and contemporary systemic racism, we also can expect a negative relationship between race_black and family_income. Our last step is to multiply the direction of those two relationships together. Since a negative and a negative equal a positive, we can determine that our original coefficient was upwardly biased, due to the omission of race_black.
***************************************************************************************

** Now let's run the regression

reg healthcare_expenditure family_income race_black


***Let’s shift our attention to house_value. Start by regressing house_value on family_income.

reg house_value family_income

***Your colleague suggests that this model is too simple and thinks you should add reference_income and number_children as controls.
reg house_value family_income reference_income number_children

*Did the additional controls improve our model? Why or why not?




***************************************************************************************
*Answer: In some ways, the model has improved. Our adjusted R-squared has improved, indicating that we can explain more of the variation in house_value. However, the t-statistic on reference income indicates that it may not belong in the model. In addition, the addition of two new control variables increased our standard errors.
***************************************************************************************

*** How can we address the shortcomings of this new model? 




***************************************************************************************
*Answer: You should drop the irrelevant variable, reference_income.
***************************************************************************************

***Let’s run our revised model and compare the results.
reg house_value family_income number_children