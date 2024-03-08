********************************************************************************
* Lab 6 --> Self-Selection Bias & Panel Data
* PA 5033 / Prof. Kleiner
* TAs: Wenchen Wang
* Week of April 23, 2021
********************************************************************************

clear
set more off
cap log close
cd "O:\wang6054\PA5033_Spring2021\Lab 6"
log using Lab6, text replace



********************************************************************************
*Part A: Self Selection Bias
********************************************************************************

/* We are interested in what effect unions have on a firm's profits. We
hypothesize that unions self-select into certain firms. This method helps us
account for that bias */

* Load data
	use Union_data.dta
		* union = presence (0 or 1)
		* gr = growth rate of firm
		* cr = concentration rate
		* age = age of firm
		* ipr = import penetration rate
		* logsale = amount of sales

* Regress profit = f(union, gr, ipr, logsales)
	reg profit union gr ipr logsale
	* Unions appear not to affect profits in this regression. Selection?
	
	
* Method: Heckman Correction
	* First regress union on predictors (gr cr age)
		reg union gr cr age
	
	* Save predicted union status (the union that IS explained by gr, cr, age)
		predict yhat
		rename yhat union_1
	
	* Subtract prediction from original to get lambda
		* Lambda is the selection correction coefficient
			gen lambda = union - union_1
			* Gets at part that ISNT predicted by other stuff (residuals)
		
		*Shortcut
		predict res, residual
		
	* Run original regression again and INCLUDE lambda
		reg profit union gr ipr logsale lambda
		
		* Interpret lambda: direction of selection effect
			* Those who select into unions tend to be less profitable
			* This is NOT causal - mainly just a control to look at the direct of selection
			
		* Interpret union: this is effect of union "cleansed" of selection
			* Appears that union has a positive, significant effect!
		
	*Note: When selecting for independent variables to explain the variation in union, there has to be at least one independent variable that is not in the final regression
	*Union = f(gr, cr, age)
	*Profit = f(Union, gr, ipr, logsale)
		
	reg union gr ipr
	predict lambda2, residual 
	reg profit union gr ipr logsale lambda2
	*We can see that lambda2 in this case is omitted.
	
********************************************************************************
*Part B: Panel Data (problem 16.4)
********************************************************************************

clear
use Problem_16-4.dta
	* State = state
	* Tax = 0 if no cigarette tax, 1 if imposed cigarette tax
	* Yr2000 = cig consumption in 2000
	* Yr2006 = cig consumption in 2006
	

* (a) Is this an RCT, a natural experiment, or panel data?

* (b) Impact of tax on consumption?
	
	* What do we know?
		* "Treatment group" = states with cigarette tax
		* "Control group" = states without cigarette taxes
		
	* We need to measure the change in consumption over time for each group
		* DIFFERENCE IN DIFFERENCE MODEL!
		* The model will be: change in consumption = f(tax)
			gen consumpchange = Yr2006 - Yr2000
			reg consumpchange Tax

	* So: tax reduces consumption by additional 0.73, but NOT significant!

	
* (c) Is this expected? What problems could exist?

clear
use 16.4-Panel.dta

	*Panel Data Setting 
	xtset ID Year
	
	*Random Effect
	xtreg Consumption Tax, re
	
	*Fxied Effect
	xtreg Consumption Tax, fe
	
	*Fixed Effect Bypass
	reg Consumption Tax i.Year i.ID, robust
		
		
	*Super simple dataset, adding more controls in reality.
		
		
		
