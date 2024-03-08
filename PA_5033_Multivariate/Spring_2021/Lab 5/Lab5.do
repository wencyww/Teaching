********************************************************************************
* Lab 5 --> Linear Dependent Variables
* PA 5033 / Prof. Kleiner
* TA: Wenchen Wang
* Week of April 16, 2021
********************************************************************************

cls
clear
set more off
cap log close
cd "O:\wang6054\PA5033_Spring2021\Lab 5"
use AgeGrp4_20data.dta
log using Lab4_log, text replace


********************************************************************************
*Part A: Linear Probability Model
********************************************************************************

* Run the model: fired = f(age, performance)
	reg fired age perf
*Interpretation of the coefficients:	
	* 1 unit change in perf, 1%pt /0.01 decrease in chance fired (age constant)
	* 1 year increase of age, 1.4%pt/0.014 increase in chance fired (perf. constant)
	
	
* How do we calculate the R^2p?
	* R^2p in this case is % of 0/1 predicted correctly...
	
	*Step 1: predict "fired" for each individual, and recode to 0 or 1 
		predict yhat
		rename yhat prob
		gen probr = prob
		replace probr = 0 if prob < 0.5
			* So, if your predicted is < 50%, you are considered not fired
		replace probr = 1 if prob >= 0.5
			* So, if your predicted is >= 50%, you are considered fired

	* Step 2: Count accurate predictions
		count if fired == 1 & probr == 1
			* Fired & model predicted fired
			
		count if fired == 0 & probr == 0
			* Not fired and model predicted not fired
	
	* Step 3: Count total fired and not fired
		count if fired == 1
		count if fired == 0
	
	* Step 4: Calculate R2p (kind of like an average correctness):
		dis [(0/140) + (860 / 860)] / 2
			* This tells us that R^2p = 0.50

*What does this result mean?
	* Model correctly predicts ALL of those not fired 
	* Model correctly preidcts NONE of those fired
	
	
********************************************************************************
*Part B: Logit Model
********************************************************************************

* Run the model with age and performance as regressors again
	logit fired age perf
	* Note: age and performance are both significant...
	
* How do we interpret logit output?
	
	* Marginal Effect of the Average
		margins, dydx (age perf) atmeans
		* At means (46.65 years, 4.03 perf.):
			* 1 unit change in age --> 0.97% pt increase in chance fired
				* Don't need to "hold perf constant" because already at mean
			* 1 unit change in perf --> 3.65% pt decrease in chance fired
				* Don't need to "hold age constant" because already at mean
				
	* Average Marginal Effect
		margins, dydx (age perf)
		* On average at all points (no longer just at means):
			* 1 unit change in age --> 1.33% pt increase in chance fired
				* Holding perf constant
			* 1 unit change in perf --> 5.01% pt decrease in chance fired
				* Holding age constant
			
* How do we calculate the R^2p?
	lstat
		* 86.6% correctly classified! Not an R2p... but useful.
	dis [(14/140) + (852 / 860)] /2
		* R^2p = 0.545
		* This is slightly better than the LPM

		
* Just for fun, here's a cool graphical representation...
	predict yhat
	rename yhat problogit
	gen problogitr = problogit
	replace problogitr = 0 if problogit < 0.5
	replace problogitr = 1 if problogit >= 0.5
	
	twoway (scatter age perf), by (problogitr fired )
	
	
********************************************************************************	
*Part C: Dummy Variables!
********************************************************************************

* Generate a dummy (newage) for being 50+ (the legal cutoff)
	gen newage = age
	replace newage = 0 if age < 50
	replace newage = 1 if age >= 50

	
* Rerun the logit model from above
	logit fired newage perf

	
* Calculate Marginal Effect on Average
	margins, dydx (newage perf) atmeans
		* At means, if 50+, 13.1% pt increase in chance fired
		
		
* Calculate Average Marginal Effect
	margins, dydx (newage perf)
		* Holding perf constant, being 50+ --> 16% pt more likely fired
		
		
* Calcualte R2p
	lstat
		* 86.0% correctly classified! Not an R2p...
	dis [(4/140) + (856 / 860)] /2
		* Not quite as good... (51.2%)
	
	
********************************************************************************
*Part D: I.V. of Performance Cleansed of Age...!
********************************************************************************

/* Perhaps we think there are some simultaneity problems with age and 
performance. If so, we can use 2SLS (like HW#2) to account for this. We will 
use the residuals from the model: perf = f(age) as our I.V. This works because 
we can think of the residuals as the part of performance that isn't accounted
for by age -- it's the part that isn't explained just by getting older in our
dataset. Below are the steps to get this and use it in 2SLS*/
	
* Generate the residuals from: perf = f(age)
	reg perf age
	predict res_1, residual
	
/* Model 1: Fired = f (age, res_1)*/

* Run Logit w/ Res_1 in place of performance
	logit fired age res_1
	
* Marginal Effect on Average?
	margins, dydx (age res_1) atmeans
		* 1 unit of age --> 1.19% pt increase in chance fired at mean (46.7 yrs)
		* 1 unit performance --> 3.66% pt decrease in chance fired at mean
	
* Average Marginal Effect?
	margins, dydx (age res_1)
		* +1 year of age --> 1.6% pt increase in chance fired (perf. constant)
	
* Calculate the R^2p
	lstat
	dis 0.5 * [14/140 + 852/860]
		* R2p = 0.545
	
/* Model 2: Fired = f (newage, res_1)*/

* Run Model with the I.V. and our age dummy (newage)
	logit fired newage res_1


* Marginal Effect on Average?
	margins, dydx (newage res_1) atmeans
	* At means, being 50+ --> 17.4% increase in chance fired
	* At means, +1 performance --> 2.3% decrease in chance fired

	
* Average Marginal Effects?
	margins, dydx (newage res_1)
	* Holding perf, being 50+ --> 19.7% increase in chance fired
	
* Calculate R2p
	lstat
	dis 0.5 * (0/140 + 860/860)
		* R2p = 0.5

*What would you choose for your final model?








	
	
	
	
	
	
