*input the data 
*keep only the variables and cases needed for the analysis 

use hsb.dta

*R Command:
***

*hsb <- merTools::hsb

***
keep schoolid mathach ses minority

keep if schoolid <= 1317 

*R Command:
***

*hsb <- subset(hsb, 
              *select = c(schid, minority, ses, mathach), 
              *schid <= 1317)

***
*get the needed descriptive statistics 

tab minority

*R Command:
***

*table(hsb$minority)

***

tabstat mathach ses minority, statistics(mean sd) 

*R Command:
***

*summary(hsb)

***

tabstat mathach ses minority, statistics(mean sd) by(schoolid)

*R Commands:
***

*aggregate(. ~ schid, 
          *hsb, 
          *function(x) c(mean = mean(x), sd = sd(x)))
		  
***

*OR

*tapply(hsb$minority, hsb$schid, summary)

*tapply(hsb$ses, hsb$schid, summary)

*tapply(hsb$mathach, hsb$schid, summary)

***
*obtain selected descriptive graphics 

hist mathach

*R Command:
***

*hist(hsb$mathach)

***
graph box mathach

*R Command:
***

*boxplot(hsb$mathach)

***
scatter mathach ses

*R Command:
***

*plot(hsb$ses, hsb$mathach)

***
scatter mathach ses, by(schoolid)

*R Commands:
***

*plot(hsb$ses, hsb$mathach, 
     *col = colors[factor(hsb$schid)],
     *pch = 0:4)

*legend("topleft", 
       *c("1224", "1288", "1296", "1308", "1317"),
       *col = colors,
       *lty = 4,
       *pch = 0:4)

*OR

*plot(hsb$ses, hsb$mathach, col = hsb$schid == 1224)

*plot(hsb$ses, hsb$mathach, col = hsb$schid == 1288)

*plot(hsb$ses, hsb$mathach, col = hsb$schid == 1296)

*plot(hsb$ses, hsb$mathach, col = hsb$schid == 1308)

*plot(hsb$ses, hsb$mathach, col = hsb$schid == 1317)

***
*perform bivariate regression
 
regress mathach ses

*R Command:
***

*summary(lm(mathach ~ ses, data = hsb))

***
*plot predicted values against ses (the independent variable) 

predict yhat

twoway (scatter mathach ses, msize(small)) ///
       (line yhat ses, lwidth(medthick) lpatt(solid)) ///
        ytitle(Math Achievement) xtitle(Socioeconomic Status)
		
*R Commands:
***

*plot(hsb$ses, hsb$mathach,
     *xlab = "Socioeconomic Status",
     *ylab = "Math Achievement")

*abline(lm(mathach ~ ses, data = hsb))

***
*create dummy variables for the remaining cases 	

gen s1=0;  replace s1=1 if schoolid==1224
gen s2=0;  replace s2=1 if schoolid==1288
gen s3=0;  replace s3=1 if schoolid==1296
gen s4=0;  replace s4=1 if schoolid==1308
gen s5=0;  replace s5=1 if schoolid==1317

/*==================
*alternate method of computing dummy variables 

drop s1-s5

tabulate schoolid, generate(s)

tab1 s1-s5

=====================*/

*R Commands:
***

*library(dplyr)

*hsb$s1 <- case_when(hsb$schid == 1224 ~ 1, 
                    *hsb$schid != 1224 ~ 0)

*hsb$s2 <- case_when(hsb$schid == 1288 ~ 1, 
                    *hsb$schid != 1288 ~ 0)

*hsb$s3 <- case_when(hsb$schid == 1296 ~ 1, 
                    *hsb$schid != 1296 ~ 0)

*hsb$s4 <- case_when(hsb$schid == 1308 ~ 1, 
                    *hsb$schid != 1308 ~ 0)

*hsb$s5 <- case_when(hsb$schid == 1317 ~ 1, 
                    *hsb$schid != 1317 ~ 0)

*get tables of each dummy to verify the were correctly defined 

tab schoolid s1
tab schoolid s2
tab schoolid s3
tab schoolid s4
tab schoolid s5

*R Commands:
***

*table(hsb$schid, hsb$s1) 

*table(hsb$schid, hsb$s2)

*table(hsb$schid, hsb$s3)

*table(hsb$schid, hsb$s4)

*table(hsb$schid, hsb$s5)

***
*compute regressions with dummies, with and without ses 

regress mathach ses s2-s5

regress mathach s2-s5

**R Commands:
***

*summary(lm(mathach ~ ses + s2 + s3 + s4 + s5, data = hsb))

*summary(lm(mathach ~ s2 + s3 + s4 + s5, data = hsb))

***
*include all dummies 

regress mathach s1-s5

*R Command:
***

*summary(lm(mathach ~ s1 + s2 + s3 + s4 + s5, data = hsb))

***
*include all dummies without intercept

regress mathach s1-s5, nocons

*storing estimates and doing linear hypothesis and likelihood-ratio tests
regress mathach ses s2-s5

est sto r1

test (s2=0)(s3=0)(s4=0)(s5=0)

*R COmmands:
***

*r1 <- lm(mathach ~ ses + s2 + s3 + s4 + s5, data = hsb)

*library(car)

*linearHypothesis(r1, c('s2 = 0',
                       *'s3 = 0', 
                       *'s4 = 0', 
                       *'s5 = 0'))
					   
***
regress mathach s2-s5

test (s2=0)(s3=0)(s4=0)(s5=0)

est sto r2

*R Commands:
***

*linearHypothesis(lm(mathach ~ s2 + s3 + s4 + s5, data = hsb),
                 *c('s2 = 0',
                   *'s3 = 0', 
                   *'s4 = 0', 
                   *'s5 = 0'))
				   
*r2 <- lm(mathach ~ s2 + s3 + s4 + s5, data = hsb)

***
lrtest r1 r2

*R Commands:
***

*library(lmtest)

*lrtest(r1, r2)

***
