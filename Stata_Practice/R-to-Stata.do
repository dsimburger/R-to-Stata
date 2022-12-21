*BASIC COMMANDS*
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
*with the same name if it finds one. If we don't specify a file
*path, Stata will save the log to our current directory.

capture log close

log using "C:\Users\dsimb\Downloads\R-to-Stata\Stata_Practice\stata_practice.txt", replace t

*R uses several packages to simplify the coding process for several
*statistical procedures.

*library("car")       #used to recode variables efficiently
*library("MASS")      #used to compute studentized  residuals
*library("caret")     #used to assess overfitting
*library("skedastic") #used to assess homoskedasticity
*library("lmtest")    #used to assess/test for functional form

*In Stata, all of these simplified processes are already built in.

*With a working directory set, we can load data into Stata like so.
*All Stata data files have the extension .dta. Running clear at 
*the end tells R to clear out its current data to load the new set. 
*This is similar to the R commands:
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

*DESCRIPTIVE STATISTICS AND PRELIMINARY ANALYSIS*
*We can get descriptive statistics using the su command. The sep(0)
*at the end tells Stata to not put a line separator between every
*3 variables (makes things look nicer). This is similar to using
*summarize() in R on a data set/variable:

*for all variables:

su, sep(0)

*an alternative of su is sum:

sum, sep(0)

*for specific variables:

su age hsgpa cogpa, sep(0)

*for descriptives of a specfific group:

su age hsgpa cogpa if affil == 1, sep(0)

su age hsgpa cogpa if affil == 2, sep(0) 

*for descriptives of a specific student:

su if subject == 7, sep(0)

*The other command we'll use to do preliminary investigation of the data
*is tab. This command puts the frequencies of variable categories into
*a table. This is similar to passing a variable through table() in R:

*a single table:

tab sex

*a single table for a specific group:

tab sex if cogpa > 3.0

tab sex if affil == 2

*We can also cross-tabulate two variables similar to
*cross.table() in R:

tab sex affil

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

*we can save a copy of our subsetted data with the save command:
save students_veg.dta, replace

restore

*We can also look at group differences in means using tab and,
*alternatively, using tabstat (tabulates statistics of variables).
*This is similar to the following R command:

*#tapply(student.set$hsgpa, student.set$affil, mean, na.rm=TRUE)#*

*Look at the Total column for mean differences with this command:

tab affil hsgpa, summarize(hsgpa) mean

*Alternatively, tabstat can do the same thing but simplified:

tabstat hsgpa, by(affil) statistics(mean sd)

*We can create a distribution of a variable in Stata using the
*histogram command. This is similar to the R command:

*#barplot(table(student.set$abor),
        *main = "Views on Abortion",
        *xlab = "Supports Legal Abortion = 1, 
		*Does not Support Legal Abortion = 0")#*

*While we can't create a barplot in Stata, we can create a 
*histogram of the frequencies of each variable category:

hist abor, frequency title(Views on Abortion) xtitle("Does not Support Legal Abortion = 0, Supports Legal Abortion = 1")

*We can make box plots in Stata too similar to the R command:

*#boxplot(student.set$tv ~ student.set$affirm,
        *data = student.set,
        *names=c("Doesn't Support Affirmative Action", "Supports Affirmative Action"),
        *xlab = "Respondent's Support for Affirmative Action",
        *ylab = "Number of Hours Spent Watching TV",
        *main = "Tv by Support of Affirmative Action")#*

*If a line of code starts getting too long, we can tell Stata to continue 
*that code on the next line by putting '///' at the end of the first line.
 
graph box tv, over(affirm) title(TV by Support of Affirmative Action) ytitle(Hours Spent Watching TV) /// 
  subtitle((0 = No Support, 1 = Support))
 
*Stata can also make scatter plots like the following R command:

*#plot(student.set$sport,student.set$tv)#*

*IMPORTANT: In R, the variable on the x-axis goes first followed by the
*one on the y-axis. This is the reverse for Stata, the variable on the 
*y-axis goes first followed by the one on this x-axis.

scatter tv sport 

*We can calculate correlations in Stata like the following R command:

*#cor(student.set$sport,student.set$tv,use = "complete.obs")#*

corr tv sport

*Doing corr only will give the entire correlation matrix:

corr

*we can use pwcorr to see which correlations are statistically significant 
*similar to the R command:
*#cor.test(student.set$sport,student.set$tv,use = "complete.obs",conf.level=.95)#*

pwcorr, star(0.05)

*There are some things R can do very simply that Stata can't. For example, 
*Stata doesn't have easily understandable/basic commands to create data frames 
*like R with commands like this one:

*#my.data.frame <-list(continuous = seq(from=1.1,to=7.7,by=1.1),
                     *nominal = c("hello","goodbye"),
                     *binary = c(TRUE,FALSE,FALSE,TRUE))#*

*We can't do things like randomly sample a distribution of numbers or
*things like dice roll simulations like the following R commands:

*#dice <-c(1,2,3,4,5,6)#*
*#dice.rolling <- sample(dice,size = 56789,replace = TRUE)#*
*#barplot(table(dice.rolling))#*

*We could do visulatization and analysis of dice roll simulations, 
*but we would need a .dta file of randomly sampled numbers between 1-6 
*to produce our graphs and analyses. Stata doesn't excel at creating
*the necessary randomly sampled data like R does to do things like
*this.

*Simulating sampling distributions is also something we wouldn't be 
*able to do well in Stata as Stata does not handle sampling with replacement 
*very well. This refers to the following R commands:

*#hsgpa.samp.dist <-c()

*for (i in 1:10000) 
*{
  *samp<-sample(student.set$hsgpa,size = 45,replace = TRUE)
  *hsgpa.samp.dist[i]<-mean(samp)
*}
*mean(hsgpa.samp.dist) 
*sd(hsgpa.samp.dist) 

*(hsgpa.samp.dist[2999] - mean(hsgpa.samp.dist)) /sd(hsgpa.samp.dist) 

*range(hsgpa.samp.dist) 

*median(hsgpa.samp.dist)

*quantile(hsgpa.samp.dist,0.5)

*quantile(hsgpa.samp.dist,0.93)#*

*We can do for loops in Stata, but they're generally
*used for re-coding sets of similar variables (e.g., coding
*a large set of dummy variables).

*RECODING*
*Recoding variables is slightly different in Stata v. R
*but still very effective. The following R commands will 
*have their Stata equivalent ones underneath of them.

use Lapop_extra.dta, clear

*R COMMAND*

*#lapop$satisfied<-car::recode(lapop$ls4, "1 = 'Very Satisfied'; 
*2 = 'Somewhat Satisfied';3 = 'Somewhat Dissatisfied'; 4 = 'Very Dissatisfied'")#*

*make a new variable called 'satisfied' identical to 'ls4'

gen satisfied = ls4

*define labels for each variable category of ls4

label define satis 1 "Very Satisfied" 2 "Somewhat Satisfied" ///
3 "Somewhat Dissatisfied" 4 "Very Dissatisfied"

*apply the labels to the newly created variable 'satisfaction'

label val satisfied satis

*cross-tab the two variables to make sure nothing went wrong.

tab satisfied ls4

*R COMMAND*

*#lapop$age<-lapop$q3#*

*make a new variable called 'age' identical to 'q3'

gen age = q3

*R COMMAND*

*lapop$sex<-car::recode(lapop$t1, "1 = 'Male'; 2 = 'Female'")

*make a new variable called 'sex' identical to 't1'

gen sex = t1

*define labels for each variable category of t1

label define malefemale 1 "Male" 2 "Female"

*apply labels to new variable 'sex'

label val sex malefemale

*cross-tab to make sure nothing went wrong

tab sex t1

*R COMMAND*

*#lapop$tv<-car::recode(lapop$s1, "0 = 'No'; 1 = 'Yes'")#*

*new variable

gen tv = s1

*define labels

label define tvlab 0 "No" 1 "Yes"

*apply labels

label val tv tvlab

*cross-tab

tab tv s1

*R COMMAND*

*#lapop$satisfied_binary<-car::recode(lapop$ls4, "1:2 = 1; 3:4 = 0")#*

*make a new variable called satis_dummy and sort all values
*of 'ls4' less than 3 into the "1" category and put everything 
*else into the 0 category.

gen satis_dummy = ls4 < 3

*cross-tab to check if we're all good

tab satis_dummy ls4

*putting ', m' at the end of the tab command will also
*show missing values. Looks like we've sorted missing
*values into the "0" category. Let's fix that.

tab satis_dummy ls4, m

*Stata generally recognizes missing values as '.' but this data
*codes them as '.a'. This command is telling Stata to recode 
*the 0's of 'satis_dummy' to be '.a' if the variable 'ls4' is also
*equal to '.a'.

recode satis_dummy 0 = .a if ls4 == .a

*Looks like we're all good now.

tab satis_dummy ls4, m

*R COMMAND*

*#lapop$relatives_binary<-car::recode(lapop$q11c, "1:3 = 1; 4 =0")#*

*make a new variable called 'relative_dummy' and sort all observations
*of 'q11c' less than 4 into the "1" category and all other observations
*into the "0" category.

gen relative_dummy = q11c < 4

*Let's make sure our missing values stay coded properly

recode relative_dummy 0 = .a if q11c == .a

*cross-tab to check for errors

tab relative_dummy q11c, m

*R COMMAND*

*#lapop$country<-car::recode(lapop$c1, "0 = 'Colombia'; 1 = 'Ecuador';2 = 'Bolivia'; 3 = 'Peru'; 4 = 'Venezuela'")#*

gen country = c1

label define countries 0 "Colombia" 1 "Ecuador" 2 "Bolivia" 3 "Peru" 4 "Venezuela"

label val country countries

tab country c1, m

*R COMMANDS*

*#lapop$country.factor<-factor(lapop$country)#*
*#is.factor(lapop$country.factor)#*
*#is.factor(lapop$country)#*

*In Stata we can specify  a variable as factor v. continuous by putting 
*'i.' in front of variable names for factor variables and 'c.' for
*continuous variables. In analyses like regression, Stata generally
*treats all variables as continuous unless otherwise specified.

su country

su i.country

*Hypothesis tests in Stata are very similar to how they
*are performed in R.

*One-sample t-test
*R COMMAND*

*#t.test(lapop$age,mu=45, alternative="two.sided")#*

ttest age = 45

*One sample z-test (proportion test)
*R COMMANDs*

*#n.satisfied<-sum(lapop$satisfied_binary,na.rm = T)

*prop.test(                 
  *x=n.satisfied,
  *n=nrow(lapop),
  *p=.5,
  *conf.level = .95,
  *alternative="two.sided")#*

ztest satis_dummy = 0.5

*Two-sample t-test
*R COMMAND*

*#t.test(lapop$age ~ lapop$tv, 
       *data=lapop,
       *conf.level=0.95)#*

ttest age, by(tv)

*If we think the variances between our two samples are
*unequal:

ttest age, by(tv) unequal

*Chi-square test
*R COMMANDS*

*#cross.table<-table(lapop$satisfied_binary,lapop$relatives_binary)

*#chisq.test(cross.table)#*

tab satis_dummy relative_dummy, chi2

*REGRESSION*
*Stata is very much designed for regression analyses. While R
*is more versatile in the type of methods it can perform,
*Stata excels at all aspects of regression analyses.

*R COMMAND*

*#reg.1<-lm(Rate ~ Ownership, data=firearms)#*

use firearms.dta, clear

*To specify an OLS regression we use the reg command (or regress).
*The dependent variable is written after reg followed by the
*independent variables you want to include. Unlike R, we do not
*have to add plus signs between variables. Doing the reg command
*will automatically summarize the results of the regression.

reg rate ownership

*An alternative way to do the reg command is regress.

regress rate ownership

*If we don't want to have the regression bring up the summary
*statistics:

quietly reg rate ownership

*We can store the results of our regression using the est store
*command. 'est store' must come after the reg command. The only 
*thing we put after 'est store' is the name we want to give the
*model.

reg rate ownership

est store ratemodel

*R COMMAND*

*#firearms$resid.1 <- resid(reg.1)#*

*We can also store our residuals in a variable with the 
*predict command. 'predict' must also come after the reg
*command. In the following code, we are naming our variable
*'resids' with 'resid' after the comma telling the predict
*command to calculate residuals.

reg rate ownership

predict resids, resid

*R COMMAND*

*#firearms$stud.res<-abs(studres(reg.1))#*

*#hist(firearms$stud.res)#*

*We can also get studentized residuals.

reg rate ownership

predict sresid, rstudent

*putting 'normal' after the comma in the hist command
*will fit a normal curve on top of the histogram
*Stata makes.

hist sresid, normal

*R COMMANDS*

*plot(firearms$Ownership, firearms$Rate)
*abline(reg.1, col="red")
*range.x.1<-range(firearms$Ownership)
*conf_interval.1 <- predict(reg.1, newdata=data.frame(Ownership=range.x.1), 
                           *interval="confidence", level = 0.95)
*lines(range.x.1, conf_interval.1[,"lwr"], col="blue", lty=2)
*lines(range.x.1, conf_interval.1[,"upr"], col="blue", lty=2)#*

*We can plot our regression line as well.

quietly reg rate ownership

twoway lfitci rate ownership, stdf || scatter rate ownership

*OR, alternatively:

quietly reg rate ownership

*not putting an option after the comma tells predict to 
*calculate predicted values based off of the model
*specified in the previous reg command.

predict yhat

twoway (scatter rate ownership, msize(small)) ///
(line yhat ownership, lwidth(medthick) lpatt(solid)), ytitle(Rate) xtitle(Ownership)

*R COMMAND*

*#reg.1.no.out<-subset(firearms, stud.res < 2, select = c("Rate", "Ownership"))#*

*We can also subset data in Stata using the keep command.
*Remember, we can use preserve to save our data as it currently
*is and then restore to bring the saved version back after
*we are done subsetting. You may not need to do this all of the 
*time, though.

preserve

*Keep only these variables.

keep rate ownership sresid

*Keep only the observations that have tudentized residuals 
*less than 2.

keep if sresid < 2

restore

*Alternatively, we can accomplish the exact same thing using the 
*drop command except we'll flip our operations a bit.

*drop the variable state and keep all others

drop state

*drop observations with studentized residuals greater than 2

drop if sresid > 2

*We can then run another regression on our subsetted data to
*see if there are any changes.

reg rate ownership

*R COMMAND*

*#reg.2<-lm(turnout ~ candidate, data = blackturnout)#*

*#reg.3<-lm(turnout ~ candidate + CVAP, data = blackturnout)#*

*We can run nested regressions in Stata by putting 'nestreg:'
*before the reg command and specifying the groups of variables
*we want to introduce in parantheses.

use blackturnout.dta, clear

*Stata will, first, run a regression on 'turnout' using
*only 'candidate' as an independent variable and, second,
*run another regression with 'cvap' included along with
*'candidate'. It will then run an F-test to determine
*if adding the new variables from model to model
*significantly increases the variance explained 
*in the dependent variable by the independent variable.

nestreg: reg turnout (candidate) (cvap)

*Another, alternative way of comparing models to one another
*is to store their estimates and use est tab to compare
*the different estimates. We store model estimates by putting
*"est store 'var modelname'" after a reg command.

*Run models and store estimates.

reg turnout candidate

est store model1

reg turnout candidate cvap

est store model2

reg turnout candidate cvap year

est store model3

*Produces a table of the 3 different regression models and
*put stars for varying levels of significance.

est tab model1 model2 model3, star 

*R COMMANDS*

*#anova(reg.2, reg.3)#*

*#BIC(reg.2)-BIC(reg.3)#*

*We can compare models with F-tests and inspect BIC in Stata
*also

quietly reg turnout candidate cvap

*test if the variance added by the cvap coefficient is equal
*to 0 (i.e., should we keep it in the model?).

test cvap = 0

*test if variance added by both coefficients is equal to
*0.

test (cvap = 0) (candidate = 0)

quietly reg turnout candidate

*calculate AIC and BIC of the previous model ran by reg

estat ic

quietly reg turnout candidate cvap

*calculate AIC and BIC of the model with more variables
*added.

estat ic

*R COMMANDS*

*#over<-trainControl(method="cv", number = 5)
*overf<-train(turnout ~ candidate + CVAP, data = blackturnout,
             *method = "lm",
             *trControl = over)
			 
*#print(overf)#*

*Stata isn't very good with machine learning techniques
*for assessing model diagnostics. The best way to check
*for overfitting is to use AIC and/or BIC in Stata.
*However, alternatively, we can use the overfit package
*to help us out a bit. Stata has packages just like R.
*However, Stata packages are less available and, consequently, 
*they are used a bit less. The nice thing about Stata 
*packages is they don't need to be loaded with a
*command like library(); they're always ready to use. To
*do something similar to the above R command in Stata:

*ssc install overfit (remove '*' at beginning to run command
*and install package and remove this message)

overfit: reg turnout candidate

overfit: reg turnout candidate cvap

*The higher the percentages, the more evidence of overfitting

*R COMMAND*

*#vif(reg.3)#*

*To calculate the Variance Inflation Matrix (VIF) in Stata,
*we put vif after a reg command

quietly reg turnout candidate cvap

vif

*R COMMANDS*

*#bp.reg.3<-breusch_pagan(reg.3)
*bp.reg.3#*

*#w.reg.3<-white(reg.3)
*w.reg.3#*

*#resettest(reg.3, power = 3, 
          *type = "regressor", 
          *data = blackturnout)#*

*We can perform a Breusch-Pagan test by putting hettest
*after a reg command

quietly reg turnout candidate cvap

hettest

*We can perform a White's test for heteroskedasticity
*by putting imtest after a reg command. The row labeled
*'Heteroskedasticity' is the White's test. Alternatively,
*you can also put 'imtest, white' to report the White's
*test at the top of the output.

quietly reg turnout candidate cvap

imtest

imtest, white

*We can perform a Ramsey RESET test by putting 
*estat ovtest after a reg command

quietly reg turnout candidate cvap

estat ovtest

*R COMMANDS*

*#blackturnout$interact<-(blackturnout$candidate*blackturnout$CVAP)#*

*#reg.4<-lm(turnout ~ candidate + CVAP + interact, data = blackturnout)#*

*To do categorical-by-continuous interactions, we have to
*specify the interaction in the regression formula itself.

*We specify the interaction directly in the regression formula 
*by putting '##' between the two variables we want to interact. 
*We do not have to include the interacted variables in the equation 
*again because Stata will automatically put them in the formula for us.
*We specify 'candidate' as a categorical variable by putting 'i.' in
*front of it and 'cvap' as a continuous variable by putting 'c.'
*in front of it.

reg turnout i.year##c.cvap

*Sometimes, we want to specify categorical variables as continous
*in interactions since they might be ordinal. To do this we
*simply change the 'i.' in front of 'year' to 'c.'

reg turnout c.year##c.cvap

*IMPORTANT: Unless otherwise specified, Stata will treat the 
*two variables in the interaction you specify as factor (categorical)
*variables. If those variables contain non-integer (decimal) values
*then Stata will not run the model. To fix this, you can put 'c.'
*in front of the factor variable with non-integer values to have
*Stata treat the variable as continuous.

*IMPORTANT: Do not use '#' between two variables to interact them,
*only use '##'. Using '#' will include the interaction term
*but omit the interacted variable's and their main effects,
*which we almost never want to do (except when plotting
*interactions).

*An alternative way to specify an interaction in Stata 
*is to create the interaction as a new variable. Note,
*if we want to do categorical-by-continuous or
*categorical-by-categorical interactions and calculate the 
*interaction effect for each category, we have to specify the 
*interaction in the reg command using '##' and putting 'i.' in 
*front of the categorical variables. 

*Generate a new variable called 'candcvap' that is the product
*of the variable's 'candidate' and 'cvap'. Stata, by default, 
*treats the two interacted variables as continuous.

gen candcvap = candidate * cvap

*In the reg command, we include the interaction variable
*as well as the two variable's we initally interacted.

reg turnout candidate cvap candcvap

*Notice the difference in the following reg outputs 
*when we specify 'year' and 'cvap' as a categorical-by-continuous
*interaction in the reg command versus creating
*the interaction between 'year' and 'cvap' as a
*new variable

*Stata treats the interaction as categorical-by-continuous

reg turnout i.year##c.cvap

*Stata treats the interaction as continuous-by-continuous

gen yearcvap = year * cvap

reg turnout year cvap yearcvap

*It even does so if we specify 'year' to be categorical

reg turnout i.year cvap yearcvap

*THE MARGINS COMMAND*
*The final thing we'll cover is the margins command in Stata.
*Beyond the predict() function, R doesn't have something
*built in like this (but there's probably a package for it).
*The margins command in Stata lets us get predicted values
*for the dependent variable in a regression formula based
*off certain parameters of the independent variables. For example,
*if we had a regression with wages as the dependent variable and
*hours worked and years spent employed as two independent variables,
*we could use the margins command to see what the predicted wages
*are for an employee that worked 40 hours a week and had been
*employed for 10 years. Margins is also very useful for visualizing
*and giving context to interaction terms.

*We'll use a pre-loaded dataset that comes with Stata for these
*examples. This is data from the 1988 National Longitudinal
*Study of Workers on individual employees. 

sysuse nlsw88, clear

*Let's try and predict wages using hours and tenure

reg wage hours tenure

*we can use margins to look at the predicted value of wages at 
*different values of hours dependent variables. We'll look at what
*wages would look like at different values of hours worked and 
*years employed.

margins, at(hours=(10 20 30 40 50 60 70 80) tenure=(5 10 15 20 25))

*What we get is messy, but we can use marginsplot to visualize
*what we see in the initial output.

*putting noci after the comma here tells Stata not to put confidence
*intervals around each point estimate (graph looks nicer).

marginsplot, noci

*We can also use margins to contextualize and visualize interaction
*terms.

*This time we'll try and predict wages with an interaction between
*work experience and years employed.

*Our two independent variables contain non-integer (decimal) values,
*so we'll need to put 'c.' in front of them so Stata will treat
*them as continuous. If the values were whole numbers, we could run
*the interaction without the 'c.'s in front of our independent
*variables.

reg wage c.ttl_exp##c.tenure

margins, at(ttl_exp=(5 10 15 20 25 30) tenure=(5 10 15 20 25 30))

marginsplot, noci

*The plot helps us visualize how the effect of work experience on
*wages increses as an employee's tenure at a workplace increases.

*We can also calculate the predicted value of wages at the mean values
*of experience and tenure.

margins, atmeans

*We can also use margins to look at and visualize dichotomous
*interactions as well.

*Let's make a dummy variable for being white

gen white = race == 1

quietly reg wage union##white

*We specify the interaction here in front of the margins command 
*since it is a dichotomous-by-dichotomous interaction. Stata will 
*calculate the predicted wages for each combination of the 
*interaction term.

margins union#white

*we can also do the margins command quietly as well.

quietly margins union#white

marginsplot, noci

*The plot here helps visualize how union membership can help
*alleviate racial disparities in wages.

*Finally, let's look at an interaction with a categorical
*variable that contains only integer (whole number)
*values.

*Let's look at racial differences in wages by occupation.

quietly reg wage white##i.occupation

*We use '#' instead of '##' here because we only want to plot
*the main effect of the interaction. 

margins white#i.occupation

marginsplot, noci

*This plot helps visualize the difference in predicted
*wages for whites v. non-whites by occupation
