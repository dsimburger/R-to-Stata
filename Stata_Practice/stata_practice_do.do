*We'll first tell Stata to clear out its environments of any 
*data it currently has loaded. This is similar to the R command:
*#rm(list=ls())#*

clear
 
clear matrix

*We'll then set our working directory. This is similar to
*the R command:
*#setwd("C:/Users/dsimb/Downloads/R-to-Stata/Stata_Data")#*

*IMPORTANT: R uses forward slashes to recognize directory
*separation while Stata uses backslashes

cd "C:\Users\dsimb\Downloads\R-to-Stata\Stata_Data"

*We'll want to log our session in a .txt file. But first,
*we have to close any logs Stata might have open already.
*We'll then tell Stata to open a new log and replace a file
*with the same name if it finds one:

capture log close

log using stata_practice.txt, replace t

*R uses several packages to simplify the coding process for several
*statistical procedures.

*library("car")       #used to recode variables efficiently
*library("MASS")      #used to compute studentized  residuals
*library("caret")     #used to assess overfitting
*library("skedastic") #used to assess homoskedasticity
*library("lmtest")    #used to assess/test for functional form

*In Stata, all of these simplified processes are already built in.

*With a working directory set, we can load data into R like so. 
*Running clear at the end tells R to clear out its current data to 
*load the new set. This is similar to the R commands:
*#student.set <-read.csv("students.csv", stringsAsFactors = FALSE)#*

*#lapop<-read.csv("Lapop_extra.csv", na.strings = c("NA",".a",".b",".c"), stringsAsFactors = F)#*

*#firearms<-read.csv("firearms.csv", stringsAsFactors = F)#*

*#blackturnout<-read.csv("blackturnout.csv")#*

use blackturnout.dta, clear

use firearms.dta, clear

use Lapop_extra.dta, clear

use students.dta, clear

*Alternatively, we can also feed Stata the file path and skip setting
*a working directory:

use "C:\Users\dsimb\Downloads\R-to-Stata\Stata_Data\blackturnout.dta", clear

use "C:\Users\dsimb\Downloads\R-to-Stata\Stata_Data\firearms.dta", clear

use "C:\Users\dsimb\Downloads\R-to-Stata\Stata_Data\Lapop_extra.dta", clear

use "C:\Users\dsimb\Downloads\R-to-Stata\Stata_Data\students.dta", clear
 
*We can look at the number of observations, variables, and data type 
*using this command:

describe

*We can get descriptive statistics using the su command. The sep(0)
*at the end tells Stata to not put a line separator between every
*3 variables (makes things look nicer):

*for all variables:

su, sep(0)

*for specific variables:

su age hsgpa cogpa, sep(0)

*for descriptives of a specfific group:

su age hsgpa cogpa if affil == 1, sep(0)

su age hsgpa cogpa if affil == 2, sep(0) 

*for descriptives of a specific student:

su if subject == 7, sep(0)

*The other command we'll use to do preliminary investigation of the data
*is tab. This command puts the frequencies of variable categories into
*a table:

*a single table:

tab sex

*a single table for a specific group:

tab sex if cogpa > 3.0

tab sex if affil == 2

*We can also cross-tabulate two variables:

tab sex affil

*run a chi-sq test on the cross-tab:

tab sex affil, chi2

*if we want to tab multiple single-variable tables at the same time, 
*we can use tab1:

tab1 age hsgpa cogpa

*Give descriptives of another variable based off of the tabulated
*variable's categories:

tab1 age hsgpa cogpa, summarize(sex)

*We can subset data in Stata as well but its an annoying process.
*We first need to preserve our data as is, create our subset using
*the keep command, doing our analyses, and then restoring our data
*to its preserved state. This is similar to the following R code:

*Create a subset of the data that ONLY includes students that are vegetarian. 
*#vegetarian <-subset(student.set,student.set$veg==1)#*

*How many vegetarians are female?
*#sum(vegetarian$sex==1)#*

*What is the mean college GPA of vegetarians?
*#mean(vegetarian$cogpa)#*

preserve

keep if veg == 1

su sex if sex == 1
*OR
tab sex

su cogpa

restore

*We can also look at group differences in means using tab and,
*alternatively, using tabstat (tabulates statistics of variables).
*This is similar to the following R command:
*#tapply(student.set$hsgpa, student.set$affil, mean, na.rm=TRUE)#*

*Look at the Total column for mean differences with this command:

tab affil hsgpa, summarize(hsgpa) mean

*Alternatively, tabstat can do the same thing but simplified:

tabstat hsgpa, by(affil) statistics(mean sd)

*We can create a bar graph of a variable in Stata using the
*graph bar command. This is similar to the R command:
*#barplot(table(student.set$abor),
        *main = "Views on Abortion",
        *xlab = "Supports Legal Abortion = 1, 
		*Does not Support Legal Abortion = 0")#*

*We can't create a barplot in Stata, but we can create a 
*histogram of the frequencies of each variable category:

hist abor, frequency title(Views on Abortion) xtitle("Does not Support Legal Abortion = 0, Supports Legal Abortion = 1")






