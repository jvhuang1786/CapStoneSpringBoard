library(dplyr)
library(car)
library(ggplot2)
library(lmtest)
library(sandwich)
library(caret)

data<-read.csv("2000_2018_nba.csv")

nbaTrain<- data %>% subset(PlayerYear == 2000|PlayerYear == 2001|PlayerYear == 2002|PlayerYear == 2003|
                  PlayerYear == 2004|PlayerYear == 2005|PlayerYear == 2006|PlayerYear == 2007|
                  PlayerYear == 2008|PlayerYear == 2009 |PlayerYear == 2010 | PlayerYear == 2011|
                    PlayerYear == 2012| PlayerYear == 2013 | PlayerYear == 2014, select =c(PlayerYear, team, name, salary,
                                                                   height_cm, weight_lb, school,
                                                                   country,DraftYear, DraftRound,
                                                                   DraftNum, PlusMinus, Pos, Age,
                                                                   Games, started, MinGames,
                                                                   FG, FG_att, three, three_att,
                                                                   two, two_att, FT, FT_att,
                                                                   o_reb, d_reb, t_reb, assist,
                                                                   steal, block, TO, fouls, ppg,
                                                                   infl, mvp,mip,SixthMan,dpoy,
                                                                   roy, nba1, nba2, nba3, rook1, rook2,
                                                                   def1,def2, FG_per, two_per, EFG,
                                                                   three_per, FT_per, TeamWins, NumYears,
                                                                   tmsalary, SalCap, overUnder))
nbaTest <- data %>% subset(PlayerYear == 2015|PlayerYear == 2016| PlayerYear == 2017 | PlayerYear == 2018, 
                           select =c(PlayerYear:overUnder))
#First Model 

nbaMacModel1<- lm(salary~Age + t_reb + ppg + FG +Games + MinGames +NumYears +two, data=nbaTrain)
nbaMacModel1
summary(nbaMacModel1)

# remove insignficant variable two

nbaMacModel2 <- lm(salary~Age + t_reb + FG + ppg + Games + MinGames +NumYears, data=nbaTrain)
summary(nbaMacModel2)

#Adjusted R squared went from 0.5349 to 0.5349 no difference

SSE = sum(nbaMacModel2$residuals^2)
SSE
RMSE = sqrt(SSE/nrow(nbaTrain))
RMSE
mean(nbaTrain$salary)

#The Root mean squared error is way too high 2947038 with a mean salary of 4195077


#Looking for multicollinearity
myvars = c("Age","t_reb", "FG", "ppg", "Games", "MinGames", "NumYears")
dfTrain<-nbaTrain[myvars]
dfTrain

round(cor(dfTrain),2)

#scatterplot
plot(dfTrain)

#Variance inflation factor is calculated as 1/tolerance where tolearnce is an indication of the percent variance,
# in the predictor that cannot be accounted for by the other predictors.
#Assesses the relationship between each independednt variable and all the other variables 

#Looking VIF scores should be close to 1 but under 5.  Over 10 means variable is not needed and can be removed from the model.
vif(nbaMacModel2)

#FG is 56 lets remove that first 

nbaMacModel3 <- lm(salary~Age + t_reb +Games + ppg + NumYears + MinGames, data=nbaTrain)
summary(nbaMacModel3)


vif(nbaMacModel3) 

#remove Minutes per game 

nbaMacModel4 <- lm(salary~Age + t_reb +Games + ppg + NumYears, data=nbaTrain)
summary(nbaMacModel4)

vif(nbaMacModel4)


#all vif values are under 5 now 
#Histogram of standardised residuals to check the assumption of normality 

hist(resid(nbaMacModel4), main ="Histogram of Residuals", xlab = "Standardized Residuals", ylab = "Frequency")

#The residuals are approximately normally distributed. Assumption of normality is met. 

#Fitted values and residuals plot to check the assumption of homoscedasticity
plot(nbaMacModel4)
bptest(nbaMacModel4)
#heteroskedasticity
#Mean residuals don't change with fitted values but spread of residuals is 
#increasing as the fitted values changes.  The spread is not consant

#Lets test this with the Breusch- Pagan Test- involves using a variance function and using a chi squared test
#to test the null hyptohesis that heteroskedasticity is not present against the alternative hypothesis 
#Hetereoskedasticity is present


nbaTrain.ols <- lm(salary~Age + t_reb +Games + ppg + NumYears, data=nbaTrain)
nbaTrain$resi <- nbaTrain.ols$residuals

#According to the Breusch Pagan since our p-value is lower than 0.05 we reject the Ho and therefore, heteroskedasticity
#exists in this model 

#Resolving Heteroskedasticity
#regression with robust standard errors 
summary(nbaTrain.ols)

coeftest(nbaTrain.ols, vcov = vcovHC(nbaTrain.ols,"HC1")) #HC1 gives us the white standard errors 
#the standard errors are drastically different from the interecept to the explanining variables.  
#Least sqaured estimators might no longer be the best. 

#dealing with Heteroskedasticity
#Box-cox transformation of variable to make it approximae to a normal distribution. Will try to do transformation for
#y variable 

salaryBCMod <- BoxCoxTrans(nbaTrain$salary)
salaryBCMod
nbaTrain <- cbind(nbaTrain, sal_new = predict(salaryBCMod, nbaTrain$salary)) # append transformed variables to salary
head(nbaTrain)

nbaMacModel5 <- lm(sal_new~Age + t_reb + Games + ppg + NumYears, data=nbaTrain) 
summary(nbaMacModel5)

plot(nbaMacModel5)
#general Least squares with unkown form of variance 
nbaTrain.ols <- lm(salary~Age + t_reb + TO +Games + ppg + NumYears, data=nbaTrain) 
nbaTrain$resi<- nbaTrain.ols$residuals
varfunc.ols <- lm(log(resi^2) ~log(Age) + log(t_reb) + log(Games) + log(ppg) +log(NumYears), data = nbaTrain)
summary(varfunc.ols)
nbaTrain$varfunc <- exp(varfunc.ols$fitted.values)
nbaTrain.gls <- lm(salary~ Age + t_reb + TO +Games + ppg + NumYears, weights = 1/sqrt(varfunc), data = nbaTrain)

summary(nbaTrain.ols)
summary(nbaTrain.gls)
#comparing ordinary least sqaures and general least squares, gls r squared of 0.5069 and ols r squared of 0.5308
#Therefore, ols is better lower variances which results in a higher r squared 



# Assumptions 
#Y values are independent
# Y values  can be expressed as a linear function of the X variable 
# Variation of observations around the regression line(the residual SE) is constant (homoscedasticity)
# For given value of X, Y values ( or the error) are Normally distributed
par(mfrow = c(2,2))
plot(nbaMacModel4)
plot(nbaMacModel5)
plot(nbaTrain.gls)
plot(nbaTrain.ols)

SSEBC <- sum(nbaMacModel5$residuals^2)
SSEBC

RMSEBC <- sqrt(SSEBC/nrow(nbaTrain))
RMSEBC
mean(nbaTrain$sal_new)
#lets try model 5 if you look at the residual fitted the regression line looks most constant 
#ignoring heteroskedaticity 
salaryPrediction0 <- predict(nbaMacModel4, newdata = nbaTest)
SSEo <- sum((salaryPrediction - nbaTest$salary)^2)
SSTo = sum((mean(nbaTrain$salary) - nbaTest$salary)^2)
R20 = 1 - SSETest/SSTTest
R20
#using boxcoxtrans model 
salaryPrediction <- predict(nbaMacModel5, newdata = nbaTest)
salaryBCModT <- BoxCoxTrans(nbaTest$salary)
salaryBCModT
nbaTest <- cbind(nbaTest, sal_new = predict(salaryBCModT, nbaTest$salary)) 
SSETest <- sum((salaryPrediction - nbaTest$sal_new)^2)
SSTTest <- sum((mean(nbaTrain$sal_new) - nbaTest$sal_new)^2)
R2 = 1 - SSETest/SSTTest
R2

RMSEtest = sqrt(SSETest/nrow(nbaTest))
RMSEtest
#RMSE increased by a lot which means its much higher than before and the R squared was much lower originally it was
#0.5171 now it's 0.000929.  This can be expected as later data from 2015 and up had a huge salary increase mainly from the TV deal

lmsalcap <- lm(salary~ ppg + NumYears + Age + three_per + FT_per, data = nbaTrain)
summary(lmsalcap)
bptest(lmsalcap)
names(nbaTrain)
