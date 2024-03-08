/****************************
*** Lab 1
*** Wenchen Wang
*** PA 5033 Multvariate Techniques
*** March 18th, 2022
*****************************/



******** DO FILE HEADERS ********

	*Start with clear, then 'set more off', then set the directory and indicate what data file you are using 

	clear
	cls
	set more off

	*Create file directory (make sure to put YOUR relevant directory between the quotation marks below)

	cd "O:\wang6054\PA 5033 Spring 2022\Lab 1"	
	


******** CREATING A LOG FILE ********

	*Close open log files

	cap log close /*cap means capture. If you only use "log close" when there was no log previoulsy opened, stata will complain*/ 

	*Create a name for the log file. Use "text replace" to save over old versions of log files every time you save.
	
	log using lab1_log, text replace
	
	*using just the name only works if the file is in the same folder referenced above - otherwise you need to have the full directory reference*/

	use mus03data.dta
	
	
*********** COMMENTING ***********

	* To create a comment on one line, use an asterisk at the beginning of the line
	* Comments will show up in green in your do-file, and Stata will recognize them as text rather than as commands

	/* Now let's make a comment spanning multiple lines

	I can create new paragraphs that will still show up as comments until I close the comment */
	
	

	/********Using more stars can make your comment stand out. 
	Just end the comment with a forward slash like you did above********** */
	
	
	
********** SUMMARIZING THE DATA **********

	*To see what is in our data, including number of observations, number and descriptions of variables

	describe
	d

	*Summary of all variables
	
	summarize
	sum


	*looking at key variables: suppins (1=does have supplemental insurance)

	sum suppins
	
	*For descriptives for suppins
	
	sum suppins, d

	*Create a crosstab looking at gender and having supplemental insurance
	
	tab suppins 
	tab suppins female
	tab suppins if female == 1 
	tab suppins female, row col cell


	*Key variables: totexp (total expenditures on medical care)
	
	sum totexp,d 
	
	histogram totexp
	
	*Total number of observations where totexp=0

	count if totexp==0
	
	count if totexp > 500

	*Break down the summary for total expenditures into two categories: those who have supplemental insurance, and those who do not

	tab suppins, sum(totexp)

	*The help command can tell you what a command does or how to obtain a particular type of output
	
	help
	help scatterplot
	help twoway scatter

	twoway scatter totexp income
	
	
	
********* Simple Regression Reivew *********

*Let's say we want to find how income can have impact on total medical expenditures

	reg totexp income famsze educyr female age marry 

*How do we interpret the coefficients? What about the test statistics?



********* Making Regression Output Tables *********

	* estout

	ssc install estout


	*Running the  regression

	reg educyr famsze age

	*Store the regression result as m1

	est store m1, title(Model 1)

	*Regression result output

	estout m1, cells(b(star fmt(3)) se(par fmt(2))) ///
		replace starlevels(* 0.1 ** 0.05 *** 0.01)  ///
		legend label varlabels(_cons Constant) ///
		stats(r2  N)

	*Export more than one regression result
	
	reg totexp age famsze 
	est store m2, title(Model 2)

	reg retire age 
	est store m3, title(Model 3)

	estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2))) ///
		replace starlevels(* 0.1 ** 0.05 *** 0.01)  ///
		legend label varlabels(_cons Constant) ///
		stats(r2  N)
   

	/*b means point estimates, se is standard error, legend indicates 
		the significance level below the table, label is the variable names, 
		stats are additional rows other than coefficients */
		
	* outreg2
 
	ssc install outreg2
 
	*Running the regression
	
	reg educyr famsze age

	*Export the output

	outreg2 using reg1.doc, replace ctitle(Model 1)

	*Append more regression results together 

	reg totexp age famsze 

	outreg2 using reg1.doc, append ctitle(Model 2)

	*Getting separate table than reg1

	reg totexp age famsze 

	outreg2 using reg2.doc, replace ctitle(Model 3)
	
	
	
	
	
	

