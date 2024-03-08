********************************************************************************
* Lab 3 --- IV & 2-Stage Least Squares
* PA 5033 / Prof. Kleiner
* TAs: Wenchen Wang
* Week of April 1st, 2022
********************************************************************************

********************************************************************************
* Set up / Header
********************************************************************************

cls
clear
set more off
cap log close
cd "O:\wang6054\PA 5033 Spring 2022\Lab 3"
log using Lab3_log, text replace
ssc install outreg2

use PRtime.dta

********************************************************************************
* PART A: TWO-STAGE LEASE SQUARES
********************************************************************************	
********************************************************************************	
* 1. OLS & Simultaneity Bias
********************************************************************************

/* We want to understand the impact of wages on employment, as well as the
impact of employment on wages. Because they are "simultaneously determined" - 
meaning they affect each other and the direction of causality is unclear - we 
shouldn't just use basic OLS. If we do, we run the risk of having biased betas
as well as SEs that are two low.

We can see that there is potential simultaneity bias when we look at the 
structural equations below, as prepop and average wage show up as regressors for
each other. */
	
	* Equation 1 --> prepop = avewage, prgnp_1, usgnp, yr
	* Equation 2 --> avewage = prepop, prgnp
	
	* Endogenous: prepop & avewage
		* Meaning simultaneously determined in the current time period
	* Predetermined: prgnp, prgnp_1, usgnp, yr
		* Meaning not simultaneously determined.

/* We can still use OLS on the structral equations, but we should know that 
there is likely bias and shouldn't be taken too seriously! However, you can't
really tell by looking at them that there is a problem. */

* Set up time series
	tsset yr
	
* Generate prgnp lagged
	gen prgnp_1 = L.prgnp	
	
* Run OLS (basic) on Equation 1
	reg prepop avewage prgnp_1 usgnp yr
	outreg2 using Lab3_regressions.doc, replace ctitle(OLS 1)
	
* Run OLS (basic) on Equation 2
	reg avewage prepop prgnp
	outreg2 using Lab3_regressions.doc, append ctitle(OLS 2)

*Q: How do you interpret the coefficients on the main independent variables in these two equations? Do they meet your assumption?

*Q: What might be wrong with this model?		

	
********************************************************************************
* 2. Run 2SLS (two-stage least squares)
********************************************************************************

*** To do this we need:

* Structural equations (from above)
	* Equation 1 --> prepop = avewage, prgnp_1, usgnp, yr
	* Equation 2 --> avewage = prepop, prgnp
	
* And Reduced Form Equations (using all exogenous variables)
	* Equation 1 --> prepop = prgnp, prgnp_1, usgnp, yr
	* Equation 2 --> avewage = prgnp, prgnp_1, usgnp, yr
		** Note: these are the SAME
		
	
***A: STEP 1 Part I: So we first create an instrument to replace prepop
	reg prepop prgnp prgnp_1 usgnp yr
	qui reg prepop prgnp prgnp_1 usgnp yr
	
	* Is this a good instrument?
		test prgnp_1 usgnp yr
		* Exclude prgnp because not in structural equation!
			* Strip endogenous of endogeneity, because exp. by exogenous
		* Note: F-values is 21.09 (definitly > 10)
		* This means it is a GOOD instrument!
	
	* This mean we CAN use this regression as an I.V.
		predict yhat
			* And yhat is our instrument!
			* Going to rename it:
		rename yhat prepop_IV

	
***B: STEP 1 Part II: Create an I.V. for avewage!
	reg avewage prgnp prgnp_1 usgnp yr
	
	* Good instrument?
		test prgnp
		* Only use prgnp because only one in structural
		* Note: F-value is 35.96 > 10
		* This is a good I.V.
		
	* Create the I.V.
		predict yhat
		rename yhat avewage_IV
	
	
*** Step 2: Use the IVs in your structurals!

*** We use the IVs to correct for simultaneity
	* Equation 1 --> prepop = avewage_IV, prgnp_1, usgnp, yr
	* Equation 2 --> avewage = prepop_IV, prgnp
	
	* Equation 1 Model
		reg prepop avewage_IV prgnp_1 usgnp yr
		outreg2 using Lab3_regressions.doc, append ctitle(2SLS 1)
		
	* Equation 2 Model
		reg avewage prepop_IV prgnp
		outreg2 using Lab3_regressions.doc, append ctitle(2SLS 2)

*Q: How do the results change compared with OLS equations?		

	
	
********************************************************************************	
* 5. 2SLS STATA Short Cut
********************************************************************************

*** This is how you run it:

ivreg prepop prgnp_1 usgnp yr (avewage = prgnp prgnp_1 usgnp yr)
	* Dependent first
	* Then the equations from structural equation for dependent variable
	* Followed by the IV you want to include
		* With ALL predetermined variables included!
		* Do not write the instrumental variable twice in the regression, such as: ivreg avewage prepop prgnp_1 usgnp yr (avewage = prgnp prgnp_1 usgnp yr)
	
ivreg avewage prgnp (prepop = prgnp prgnp_1 usgnp yr)


ivreg prepop prgnp_1 usgnp yr (avewage = prgnp prgnp_1 usgnp yr), first
	* Adding , first gives you both stages
	
********************************************************************************	
* 6. The Order Condition
********************************************************************************

ivreg prepop prgnp_1 usgnp yr (avewage = prgnp_1 usgnp yr)

*Q: Why won't STATA run this regression?


/*** if the instrumental variable (prgnp below) is not in the full equation, 
you don't need to worry about the order condition ***/

ivreg prepop prgnp_1 usgnp yr (avewage = prgnp)





 










	
	
	
