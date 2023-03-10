my_log <- file("C:/Users/dsimb/Downloads/R-to-Stata/hsb_basics_ch1/R_files/hsb_basics_ch1.txt") # File name of output log

sink(my_log, append = TRUE, type = "output") # Writing console output to log file
sink(my_log, append = TRUE, type = "message")

cat(readChar(rstudioapi::getSourceEditorContext()$path, # Writing currently opened R script to file
             file.info(rstudioapi::getSourceEditorContext()$path)$size))

1:10 + 1:5   # Some R code returning warnings
x <- "my string" # Some data objects
x
#input the data

#use hsb.dta

#We can get the hsb dataset from the 'merTools' package
#install.packages("merTools")

hsb <- merTools::hsb

#keep only the variables and cases needed for the analysis 
#keep schoolid mathach ses minority;
#keep if schoolid <= 1317 

hsb$schid <- as.numeric(hsb$schid)

hsb <- subset(hsb, 
              select = c(schid, minority, ses, mathach), 
              schid <= 1317)

#tab minority

table(hsb$minority)

#tabstat mathach ses minority, statistics(mean sd)

summary(hsb)

#tabstat mathach ses minority, statistics(mean sd) by(schoolid)

aggregate(. ~ schid, 
          hsb, 
          function(x) c(mean = mean(x), sd = sd(x)))

#OR, alternatively:

tapply(hsb$minority, hsb$schid, summary)

tapply(hsb$ses, hsb$schid, summary)

tapply(hsb$mathach, hsb$schid, summary)

#Obtain selected descriptive graphics 
#hist mathach

hist(hsb$mathach)

#graph box mathach

boxplot(hsb$mathach)

#scatter mathach ses
#IMPORTANT: IN R, THE VARIABLE ON THE X-AXIS GOES FIRST FOLLOWED
#BY THE VARIABLE ON THE Y-AXIS. THIS IS THE REVERSE FOR STATA 
#(VARIABLE ON THE Y-AXIS GOES FIRST FOLLOWED BY THE VARIABLE ON THE 
#X-AXIS)

plot(hsb$ses, hsb$mathach)

#scatter mathach ses, by(schoolid)

colors <- c("red", "blue", "green", "black", "dark gray")

plot(hsb$ses, hsb$mathach, 
     col = colors[factor(hsb$schid)],
     pch = 0:4)

legend("topleft", 
       c("1224", "1288", "1296", "1308", "1317"),
       col = colors,
       lty = 4,
       pch = 0:4)

#OR, alternatively, to inspect each school individually:

plot(hsb$ses, hsb$mathach, col = hsb$schid == 1224)

plot(hsb$ses, hsb$mathach, col = hsb$schid == 1288)

plot(hsb$ses, hsb$mathach, col = hsb$schid == 1296)

plot(hsb$ses, hsb$mathach, col = hsb$schid == 1308)

plot(hsb$ses, hsb$mathach, col = hsb$schid == 1317)

#Perform bivariate regression
#regress mathach ses

summary(lm(mathach ~ ses, data = hsb))

#Plot predicted values against ses (the independent variable) ;
#predict yhat, xb;
#twoway (scatter mathach ses, msize(small))
#(line yhat ses, lwidth(medthick) lpatt(solid)),
#ytitle(Math Achievement) xtitle(Socioeconomic Status)

plot(hsb$ses, hsb$mathach,
     xlab = "Socioeconomic Status",
     ylab = "Math Achievement")

abline(lm(mathach ~ ses, data = hsb))

#create dummy variables for the remaining cases 

#gen s1=0;  replace s1=1 if schoolid==1224
#gen s2=0;  replace s2=1 if schoolid==1288
#gen s3=0;  replace s3=1 if schoolid==1296
#gen s4=0;  replace s4=1 if schoolid==1308
#gen s5=0;  replace s5=1 if schoolid==1317

#We'll use the 'dplyr' package and it's case_when function to make 
#dummy variables

#install.packages("dplyr")

library(dplyr)

hsb$s1 <- case_when(hsb$schid == 1224 ~ 1, 
                    hsb$schid != 1224 ~ 0)

hsb$s2 <- case_when(hsb$schid == 1288 ~ 1, 
                    hsb$schid != 1288 ~ 0)

hsb$s3 <- case_when(hsb$schid == 1296 ~ 1, 
                    hsb$schid != 1296 ~ 0)

hsb$s4 <- case_when(hsb$schid == 1308 ~ 1, 
                    hsb$schid != 1308 ~ 0)

hsb$s5 <- case_when(hsb$schid == 1317 ~ 1, 
                    hsb$schid != 1317 ~ 0)

table(hsb$schid, hsb$s1) 

table(hsb$schid, hsb$s2)

table(hsb$schid, hsb$s3)

table(hsb$schid, hsb$s4)

table(hsb$schid, hsb$s5)

#compute regressions with dummies, with and without ses
#regress mathach ses s2-s5

summary(lm(mathach ~ ses + s2 + s3 + s4 + s5, data = hsb))

#regress mathach s2-s5

summary(lm(mathach ~ s2 + s3 + s4 + s5, data = hsb))

#regress mathach s1-s5; include all dummies (R will kick one out) 

summary(lm(mathach ~ s1 + s2 + s3 + s4 + s5, data = hsb))

#regress mathach s1-s5, nocons;  
#include all dummies without intercept

summary(lm(mathach ~ 0 + s1 + s2 + s3 + s4 + s5, data = hsb))

#regress mathach ses s2-s5;
#est sto r1

r1 <- lm(mathach ~ ses + s2 + s3 + s4 + s5, data = hsb)

#test (s2=0)(s3=0)(s4=0)(s5=0)
#We need the 'car' package to do Linear Hypothesis tests in R
#install.packages("car")

library(car)

linearHypothesis(r1, c('s2 = 0',
                       's3 = 0', 
                       's4 = 0', 
                       's5 = 0'))

#regress mathach s2-s5;
#test (s2=0)(s3=0)(s4=0)(s5=0)

linearHypothesis(lm(mathach ~ s2 + s3 + s4 + s5, data = hsb),
                 c('s2 = 0',
                   's3 = 0', 
                   's4 = 0', 
                   's5 = 0'))
#est sto r2

r2 <- lm(mathach ~ s2 + s3 + s4 + s5, data = hsb)

#lrtest r1 r2
#We need the 'lmtest' package to do likelihood-ratio tests in R
#install.packages("lmtest")

library(lmtest)

#The model with MORE variables in it goes first

lrtest(r1, r2)
closeAllConnections()