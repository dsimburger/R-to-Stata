#clear memory
rm(list=ls())

#set working directory
setwd("C:/Users/diego/Dropbox/DLeal/Arizona/teaching/DATA")

library("car")       #used to recode variables efficiently
library("MASS")      #used to compute studentized  residuals
library("caret")     #used to assess overfitting
library("skedastic") #used to assess homoskedasticity
library("lmtest")    #used to assess/test for functional form


##################
# BASIC COMMANDS #
##################

#Open different data sets
student.set <-read.csv("students.csv", stringsAsFactors = FALSE)
lapop<-read.csv("Lapop_extra.csv", na.strings = c("NA",".a",".b",".c"), stringsAsFactors = F)
firearms<-read.csv("firearms.csv", stringsAsFactors = F)
blackturnout<-read.csv("blackturnout.csv")

#Number of observations
nrow(student.set) # 60

#Number of columns
ncol(student.set) # 18

# Type of data (double, integer, character, or logical) 
typeof(student.set$subject) #integer

#Mean age of students
mean(student.set$age) #29.16667

#Number of students that are Republican
sum(student.set$affil==2) #15

#How many people does student 7 know who have died from AIDS or who are HIV+?
student.set$aids[7] #2

#Create a subset of the data that ONLY includes students that are vegetarian. 
vegetarian <-subset(student.set,student.set$veg==1)

#How many vegetarians are female?
sum(vegetarian$sex==1) #6

#What is the mean college GPA of vegetarians?
mean(vegetarian$cogpa) #3.388889

#What is the difference between the mean high school GPA of Republicans and 
#the mean high school GPA of Democrats?
tapply(student.set$hsgpa, student.set$affil, mean, na.rm=TRUE) #0.031428

#Create a bar plot for the variable abortion.
barplot(table(student.set$abor),
        main = "Views on Abortion",
        xlab = "Supports Legal Abortion = 1, Does not Support Legal Abortion = 0")


#Using a box plot, report the median number of hours students spend watching TV 
#stratified by their beliefs in affirmative action.
boxplot(student.set$tv ~ student.set$affirm,
        data = student.set,
        names=c("Doesn't Support Affirmative Action", "Supports Affirmative Action"),
        xlab = "Respondent's Support for Affirmative Action",
        ylab = "Number of Hours Spent Watching TV",
        main = "Tv by Support of Affirmative Action")

#Using a scatter plot, plot the association between number of hours spend watching 
#TV and number of hours participating in sports and other physical activities. 
plot(student.set$sport,student.set$tv)

#compute a pearson correlation, excluding missing values
cor(student.set$sport,student.set$tv,use = "complete.obs") 

#compute the same correlation while reporting statistical significance
cor.test(student.set$sport,student.set$tv,use = "complete.obs",conf.level=.95) 


##### create a data frame ###################
my.data.frame <-list(continuous = seq(from=1.1,to=7.7,by=1.1),
                     nominal = c("hello","goodbye"),
                     binary = c(TRUE,FALSE,FALSE,TRUE))



#Simulate the rolling of a die 56789 times, then plot results
dice <-c(1,2,3,4,5,6)
dice.rolling <- sample(dice,size = 56789,replace = TRUE)
barplot(table(dice.rolling))


#Using the sample function, approximate the sampling distribution of mean high school GPA using a 
#sample size of 45 across 10000 different samples 

hsgpa.samp.dist <-c()

for (i in 1:10000) 
{
  samp<-sample(student.set$hsgpa,size = 45,replace = TRUE)
  hsgpa.samp.dist[i]<-mean(samp)
}
mean(hsgpa.samp.dist) 
sd(hsgpa.samp.dist) 

#calculate the z-score of the 2999th observation in hsgpa.samp.dist
(hsgpa.samp.dist[2999] - mean(hsgpa.samp.dist)) /sd(hsgpa.samp.dist) 

#what's the rage of values
range(hsgpa.samp.dist) 

#what's the median
median(hsgpa.samp.dist)

#.5 quantile (aka the median)
quantile(hsgpa.samp.dist,0.5)

#.93 quantile
quantile(hsgpa.samp.dist,0.93)


#####################
#   RECODING        #
#####################

####diffrent types of recoding and renaming


lapop$satisfied<-car::recode(lapop$ls4, "1 = 'Very Satisfied'; 2 = 'Somewhat Satisfied';3 = 'Somewhat Dissatisfied'; 4 = 'Very Dissatisfied'")
lapop$age<-lapop$q3
lapop$sex<-car::recode(lapop$t1, "1 = 'Male'; 2 = 'Female'")
lapop$tv<-car::recode(lapop$s1, "0 = 'No'; 1 = 'Yes'")
lapop$satisfied_binary<-car::recode(lapop$ls4, "1:2 = 1; 3:4 = 0")
lapop$relatives_binary<-car::recode(lapop$q11c, "1:3 = 1; 4 =0")
lapop$country<-car::recode(lapop$c1, "0 = 'Colombia'; 1 = 'Ecuador';2 = 'Bolivia'; 3 = 'Peru'; 4 = 'Venezuela'")
lapop$country.factor<-factor(lapop$country)
is.factor(lapop$country.factor) #TRUE
is.factor(lapop$country) #FALSE

####################
# hypotheses testing
###################

#one-sample t-test: is mean age = 45?
t.test(lapop$age,mu=45, alternative="two.sided") #null is rejected

#one-sample proportion test: is the proportion satisfied with life =.5?
n.satisfied<-sum(lapop$satisfied_binary,na.rm = T)

prop.test(                 #null is rejected
  x=n.satisfied,
  n=nrow(lapop),
  p=.5,
  conf.level = .95,
  alternative="two.sided"
)

#two-sample t-test. null hyp: no age difference by those who have and don't have tv?
t.test(lapop$age ~ lapop$tv,  #reject null
       data=lapop,
       conf.level=0.95)


#create a table to run a chi-square test
cross.table<-table(lapop$satisfied_binary,lapop$relatives_binary)

#check the table
cross.table

#chi-square test: null hyp: no  association between life satisfaction and 
#having relatives abroad:
chisq.test(cross.table) # fail to reject the null

####################
#Regression 
####################

#Run a bivariate linear regression between the percentage of people who 
#report owning a gun ('Ownership') and annual number of deaths per 
#100,000 population ('Rate')
reg.1<-lm(Rate ~ Ownership, data=firearms)

#summarize results
summary(reg.1)

#store residuals
firearms$resid.1 <- resid(reg.1)

#compute studentized residuals
firearms$stud.res<-abs(studres(reg.1))
hist(firearms$stud.res)

#fit the regression line with 95%CI
plot(firearms$Ownership, firearms$Rate)
abline(reg.1, col="red")
range.x.1<-range(firearms$Ownership)
conf_interval.1 <- predict(reg.1, newdata=data.frame(Ownership=range.x.1), 
                           interval="confidence", level = 0.95)
lines(range.x.1, conf_interval.1[,"lwr"], col="blue", lty=2)
lines(range.x.1, conf_interval.1[,"upr"], col="blue", lty=2)


#subsetting the data to take out outliers
reg.1.no.out<-subset(firearms, stud.res < 2, select = c("Rate", "Ownership"))

#running regression agin
reg.1.no.out<-lm(Rate ~ Ownership, data=reg.1.no.out)

#summarize results
summary(reg.1.no.out)

#run a couple of nested regressions
reg.2<-lm(turnout ~ candidate, data = blackturnout)
reg.3<-lm(turnout ~ candidate + CVAP, data = blackturnout)

#compare models through an F-test and BIC
anova(reg.2, reg.3)
BIC(reg.2)-BIC(reg.3) 

#testing for overfitting
over<-trainControl(method="cv", number = 5)
overf<-train(turnout ~ candidate + CVAP, data = blackturnout,
             method = "lm",
             trControl = over)
print(overf)

#testing for multicollinearity
vif(reg.3)

#testing for homoskedasticity
#Breusch-Pagan test
bp.reg.3<-breusch_pagan(reg.3)
bp.reg.3 

#White test
w.reg.3<-white(reg.3)
w.reg.3 

#test for functional form
resettest(reg.3, power = 3, 
          type = "regressor", 
          data = blackturnout) 

#do a continuous by categorical interaction
blackturnout$interact<-(blackturnout$candidate*blackturnout$CVAP)

#run a regression with the interaction
reg.4<-lm(turnout ~ candidate + CVAP + interact, data = blackturnout)


