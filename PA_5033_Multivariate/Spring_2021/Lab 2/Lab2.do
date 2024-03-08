********************************************************************************
* Lab 2 --> Ad-Hoc Distributed Lag and Dynamic Lag Models
* PA 5033 / Prof. Kleiner
* TA: Wenchen Wang
* Week of March 25, 2022
********************************************************************************


*********************************
* Set up / Header
*********************************

clear
cls
cap log close
set more off
cd "O:\wang6054\PA 5033 Spring 2022\Lab 2"
log using Lab2_log, text replace
ssc install outreg2

use PRtime_data.dta

*********************************************************************************************
***PART A: AD-HOC DISTRIBUTED LAG MODELS
*********************************************************************************************


******************************************
* 1. Standard Regression 
******************************************
* Look at the summary statistics for target variables
	sum prepop
	sum kaitz
	sum yrn
	
* Run basic regression
	regress prepop kaitz yrn
	
	* Q: How do we interpret the coefficient on kaitz?
	* A: With one kaitz index decrease in minimum wage, the proportion of the Puerto Rican population employed would decrease by around 24%. And this result is significant at 5% level.
	

**************************************************
* 2.: Creating Lagged & Lead Variables
**************************************************

* Tell Stata we're working with time seris data
	tsset yr

	
* Generate variables using L.# and [_n+#] codes
	gen kaitz_1 = L.kaitz
	gen kaitz_2 = L2.kaitz
	gen kaitz_3 = kaitz[_n+1]
	gen kaitz_4 = kaitz[_n+2]

	* Can consider naming so it's clear which are lagged/lead

		
		
***************************************************
* 3.: Model w/ Lagged & Lead Variables
***************************************************

* Run new regression
	reg prepop kaitz yrn kaitz_1 kaitz_2 kaitz_3 kaitz_4
	
	* Q: What happened to the coefficient on kaitz?
	* A: The magnitude of the coefficient decrease to around 13%, and the coefficient lost its significance. Before it is significant at 5% level, now it's not significant even at the 10% level. 

***************************************************
* 4.: Discussion Questions
***************************************************

	*Q: What are the benefits and costs of using leads and lags?
	*A: By using leads and lags, we can use past and future values of the independent variables to try to explain the current value of the dependent variable, which may increase the accuracy of our model. However, by using OLS with leads and lags, we can have severe multicollinearity, we can also have irregular declining patterns in the coefficients. Also, it can cause a decrease in the degrees of freedom, and cause us to have a smaller sample size.
	
	*Recall that the degrees of freedom in a multiple regression equals N-k-1, where k is the number of variables. The more variables you add, the more you erode your ability to test the model (e.g. your statistical power goes down).
	
	*Q: Which model is preferable here?
	
		
*********************************************************************************************
*** DYNAMIC LAG MODELS
*********************************************************************************************
		
**********************************
* Model 1 - no lags
**********************************

	reg prunemp usgnp
	
*How do we interpret the coefficient for usgnp (GNP measured in billions)?
	* As GNP goes up, proportion unemployed goes up
	* Note: Interpreting small coefficient
	*For 100 billion change in GNP, we see 0.2 % point increase in unemp

	outreg2 using Lab2_regressions.doc, replace ctitle(OLS)
	
	
	
******************************************
* Model 2 - distributed lags (2)
******************************************

	
* Create two new variables for lagged values of usgnp
	gen usgnp_1 = L.usgnp
	gen usgnp_2 = L2.usgnp
	
	
* Run the regression!
	reg prunemp usgnp usgnp_1 usgnp_2
		* For increase in this year's GNP...
		* For increase in last year's GNP...
		* For increase in GNP two years ago...

	outreg2 using Lab2_regressions.doc, append ctitle(Distributed)

		
	* Q: Why aren't the coefficients significant anymore?
	* A: Multicollinearity
		corr usgnp usgnp_1 usgnp_2
		vif
			* Shows strong multicollinearity (Values of VIF that exceed 10 are often regarded as indicating multicollinearity, but in weaker models values above 2.5 may be a cause for concern.)
			* Also, effect spread out over multiple variables now
			* Note, that here the effect is larger when farther away...
	
	
				
**********************************
* Model 3 - dynamic
**********************************

* lagged dependent already created (prunem_1)

* Run the regression
	reg prunemp usgnp prunem_1
	* Q: How do you interpret the coefficient on prunemp_1?  
	* A: So our coefficient value (lambda) is 0.85, and it is significant.
		* LAST year's employment is significant predictor, but...
		* The coefficient for GNP (beta) is NOT significant

	outreg2 using Lab2_regressions.doc, append ctitle(Dynamic)		
		
	* Q: What is the Long-run Multiplier?
	* A: beta / (1-lambda)
		dis 0.00000468 / (1-.8557)


	* Q: How to test for serial correlation in this model?
	* A: Request the DW statistic:
			dwstat
			*Note: The Durbin-Watson statistic will always have a value ranging between 0 and 4. A value of 2.0 indicates there is no autocorrelation detected in the sample. Values from 0 to less than 2 point to positive autocorrelation and values from 2 to 4 means negative autocorrelation
			* BUT: DW is not appropriate to be used for dynamic models!
		
		
***************************************************
* Dynamic Models --> Serial Correlation	
***************************************************

* Can't use DW for dynamic models because betas are biased!
	* Correlated errors --> errors are also correlated with Y_(t-1)
	* For distributed, this isn't a problem
	* Both distributed & dynamic suffer from issues with variances

	
* Test for Serial Correlation in dynamic models: Lagrange Multiplier

	* Step 1: get residuals from the regression
		qui reg prunemp usgnp prunem_1
		predict e, resid
		
	* Step 2: Create residuals lagged one period
		gen e_1 = L.e

	* Step 3: Regress residuals on explanatory & lagged residuals
		reg e usgnp prunem_1 e_1
		
	* Step 4: Calculate LM statistics
		* LM = N * R^2
			display 36 * 0.1000
		* 5% critical value with 1 d.f = 3.84

	* So no evidence to reject the null --> no serial correlation
	
	
	
	
************************************************
* Dynamic Models --> Stationarity
************************************************

graph twoway scatter usgnp yr


* First look: estimate autoregressive equation to find "gamma"
	reg usgnp usgnp_1
	* So gamma = 1.015
		* Hmm... this is significant. So perhaps non-stationary!

	
	
* Actual test: Dickey Fuller
	* Step 1: create first differences of USGNP
		gen usgnp_d = d.usgnp

	* Step 2: Run Dickey Fuller: regress difference on 1 lagged
		reg usgnp_d usgnp_1
		
	* So... gamma = 0.0152, and NOT significant
		* H0: coefficient = 0, which means NONSTATIONARY
		* Ha: coefficient != 0, which means STATIONARY
		
	* So, this null cannot be rejected --> NONSTATIONARY


* Solution for non-stationary series: use first differences

	* Step 1: Generate differences
		gen prunemp_d = d.prunemp
		gen prunemp_1_d = d.prunem_1
	
	* Step 2: Regress using differences, not levels
		reg prunemp_d usgnp_d prunemp_1_d
		* And now our coefficient on GNP is significant and negative!


	outreg2 using Lab2_regressions.doc, append ctitle(Differenced)










