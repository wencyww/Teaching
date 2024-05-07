/****************************
Lab 1
Patrick Alcorn & Wenchen Wang
PA 5032
January 22, 2021
*****************************/

***do file headers
*Start with clear, then 'set more off', then set the directory and indicate what data file you are using 
clear
set more off


***PART B: CREATING A LOG FILE***
*Close open log files
cap log close /*cap means capture. If you only use "log close" when there was no log previously opened, stata will complain*/ 

*Create file directory (make sure to put your relevant directory between the quotation marks below)
cd "O:\alcor031\PA5032Lab_2021"
use lab1_psid.dta /*using just the name only works if the file is in the same folder referenced above - otherwise you need to have the full directory reference*/

*Create a name for the log file. Use "text replace" to save over old versions of log files every time you save.
log using lab1_statareview, text replace

***COMMENTING***

*To create a comment on one line, use an asterisk at the beginning of the line
*Comments will show up in green in your do-file, and Stata will recognize them as text rather than as commands

/*Now let's make a comment spanning multiple lines

I can create new paragraphs that will still show up as comments until I close the comment*/

/********Using more stars can make your comment stand out. 
Just end the comment with a forward slash like you did above***********/


***CLEANING DATA****

*With PSID Data, the variables will have a name that does not relate to what it is actually showing, but the labels will tell us what they are referring to. So our first step can be to “rename” the variables.
rename ER71426 family_income

*Other times, we may want to generate a dummy variable that subsets another variable in our data set. For example we may want to divide total family income between less than $100,000 and greater than or equal to $100,000. The first step would be to “generate” a new variable that is equal to our old variable.

generate family_incomeunder100k=family_income

*Then, we would recode our new total family income variable so that households with a family income of less than $100,000 are assigned a value of 1, and families with incomes of $100,000 or greater are assigned a value of 0.

recode family_incomeunder100k(0/99999=1)

recode family_incomeunder100k(100000/9999997=0)

sum family_incomeunder100k

***SUMMARIZING THE DATA****

*To see what is in our data, including number of observations, number and descriptions of variables
describe
d /* Many Stata codes can be abbreviated. Here 'describe' is shortened to 'd' */



*Summary of all variables
summarize
sum

*Looking at key variables: family_incomeunder100k (1=family income is under 100K)
sum family_incomeunder100k
tab family_incomeunder100k

*Create a crosstab looking at family_incomeunder100kincome and age_50 (1=reference person is 50 years or older)

tab family_incomeunder100k age_50

*Look at family income under a certain condition
tab family_incomeunder100k if age > 40 

*Examine a "row, column, cell" table with family_incomeunder100k and age_50
tab family_incomeunder100k age_50, row col cell

*For descriptives for age of reference person
sum reference_age,d 

*Total number of observations where age_50=0
count if age_50==0
count if age_50!=0

*Break down the summary for age_50 into two categories: those whose family income is less than $100,000, and those whose family income is greater than or equal to $100,000
tab family_incomeunder100k, sum(age_50)

*The help command can tell you what a command does or how to obtain a particular type of output
help
help scatterplot
help twoway scatter

twoway scatter house_value reference_age, color()

log close