********************************************************************************
* Lab 5 --> Forecasting Models
* PA 5033 / Prof. Kleiner
* TA: Wenchen Wang
* Week of April 15th, 2022
********************************************************************************

cls
clear
set more off
cap log close
cd "O:\wang6054\PA 5033 Spring 2022\Lab 5"
use PRtime_data.dta
log using Lab5, text replace


* Goal: predict value of prepop for 1986 & 1987
	* We will use THREE different strategies to do this:
		*1: Unconditional Forecast
		*2: Conditional Forecast
		*3: ARIMA Model

* Before doing anything, we need to tell Stata we are working with time series
	tsset yr

		
********************************************************************************
* Strategy 1: Unconditional Forecast
********************************************************************************

* Model 1: prepop = f( prgnp kaitz )
	* Uses KNOWN values of the independent variables


* Run the model on prior data (before 1986)
	reg prepop prgnp kaitz if yr < 86
		* The betas will be used in our forecast model

		
* Forecast Model 1: prepop = 0.508 + 0.0000119(prgnp) - 0.442(kaitz)
	

* Make predictions:

	list prgnp if yr == 86
	list kaitz if yr == 86
	list prepop if yr == 86
	
	* So, for 1986 --> use prgnp = 4281.6 & kaitz = 0.4265
	
	dis 0.508 + (0.0000119 * 4281.6) - (0.442 * 0.4265)
	
		* Predicted value of prepop in 1986 = .3704
		* actual value of prepop in 1986 = .351
	
	list prgnp if yr == 87
	list kaitz if yr == 87
	list prepop if yr == 87
	
	* For 1987 --> use prgnp = 4496.7 & kaitz = 0.4094
	
	dis 0.508 + (0.0000119 * 4496.7) - (0.442 * 0.4094)
	
		* Predicted value of prepop in 1987 = .3805
		* actual value of prepop in 1987 = .369
	
* Check forecasting error:
	dis .3704 - .351
	* 1986: predicted - actual = .3704-.351 =.0194

	dis .3805 - .369
	* 1987 = .3805 - .369 =.0115 (overestimate!)

	
********************************************************************************	
* Strategy 2: Conditional Forecast
********************************************************************************

* Model 2: prepop = f( prgnp kaitz )
	* But use PREDICTED values of independent variables (prgnp)
	* Basically, we need to predict prgnp in order to predict prepop
		* This assumes we know the value of kaitz...
		

* Run model to get original regression (note: only predicting 1987 here)
	reg prepop prgnp kaitz if yr < 87
		* This gives us our forecasting equation
		
*Forecast Model 2: prepop = 0.507 + 0.00000969(prgnp) - 0.422(kaitz)
	

		
* Assume prgnp is a function of usgnp (based on theory...)
	* Run regression to determine coefficients / relationship:
		reg prgnp usgnp if yr < 87

		
* We can estimate the value of prgnp using this forecasting equation:
	* prgnp = -1107.76 + 1.57(usgnp)
	
	list usgnp if yr == 87
	list prgnp if yr == 87
	
	dis -1107.76 + 1.569 *3819.6
	* So, we expect  prgnp in 1987 to be: -1107.76 + 1.569 (3819.6) = 4885.1924
	

* Then, we can sub in that predicted prgnp into our actual forecasting model

	list kaitz if yr == 87
	list prepop if yr == 87
	
	dis 0.507 +.000009688 * 4885.1924 - 0.422 * 0.40944
	
	* prepop = 0.507+.000009688(4885.1924)-0.422(0.40944)=.3815
		* Predicted prepop in 1987 = 0.3815
		* Actual prepop in 1987 = 0.3690
		* Error = 0.0125 (overestimate)
	
	
********************************************************************************	
* Strategy 3: ARIMA Forecast
********************************************************************************

/*

ARIMA Model Definition: ARIMA(AR, I, MA)	ARIMA(1,0,1)

*Autoregression (AR): refers to a model that shows a changing variable that regresses on its own lagged, or prior, values.

*Integrated (I): represents the differencing of raw observations to allow for the time series to become stationary (i.e., data values are replaced by the difference between the data values and the previous values).

*Moving average (MA):  incorporates the dependency between an observation and a residual error from a moving average model applied to lagged observations.

*/

* Model 3: prepop = f( prepop_1 residuals_1) **explained below

* ARIMA uses prior values of the dependent & prior values of the error term
	* Assumes we DON'T need theory, just last year's value and a "fudge" factor
	* No use of indpendent variables here... 
		* More "mathematical" than "theoretical" or "econometric"

		
* To develop an ARIMA, follow these steps:

	* Step 1: Create a lag of your dependent variable
		* This already exists in our dataset

	* Step 2: Estimate regression of dependent against lagged & save residuals
		reg prepop prepop_1 if yr < 87
		predict residuals, res
		* "e" is the variation that is not explained by the prior year

	* Step 3: Generate lagged residuals
		gen residuals_1 = L.residuals


	* Step 4: Regress dependent on lagged dependent and lagged residuals
		* This is an ARIMA (1,0,1)
		reg prepop prepop_1 residuals_1 if yr < 87


* Model is: prepop = 0.044 + 0.881 (prepop_1) + 0.197 (residuals_1)
	/* Essentially, we can predict prepop by looking at last year's
		value of prepop and the size of last year's error term*/

	list prepop_1 if yr == 87       /* can also do: list prepop if yr == 86 */
	list residuals_1 if yr == 87 /* list residual if yr == 86*/
	
	dis 0.044 + 0.881 * 0.351 + 0.197 * 0.017
	* For 1987, ARIMA predicts prepop = 0.044+ 0.881(0.351)+ 0.197(0.017)= 0.357
	* Error = predicted - actual = .357 -.369 = -0.012 (underestimate!)



