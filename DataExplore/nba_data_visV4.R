##loading packages
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(data.table)
library(ggrepel)
options(max.print = 999999999)
options(scipen=12)
#Set working directory 
getwd()
setwd("/users/justinvhuang/desktop/nba_stat_salaries")
getwd()

#loading in the data
data<-read.csv("2018_2000_data.csv")
data <- data[,-1]

#The trend of 3 point shots to 2 point shots and if it is affected by salary 
# Compute stats for salary
data %>%
  summarize(median(salary), mean(salary), sd(salary), var(salary),
            IQR(salary))
#checking the distribution for salary
ggplot(data, aes(salary)) +geom_density()
#compute stats for two 
data %>%
  summarize(median(two), mean(two), sd(two), var(two),
            IQR(two))
#checking the distribution for twos made
ggplot(data, aes(two)) +geom_density()
#compute stats for three 
data %>%
  summarize(median(three), mean(three), sd(three), var(three),
            IQR(three))
#checking the distribution for threes made
ggplot(data, aes(x= three))+ 
  geom_density()



#all seem to be right skewed.  Showing only a few players attemping more shots and getting more salary
#those must be the teams star players who are getting shots and money from the team

###see the amount of 2 point shots vs 3 point shots over the years 

shot_att <-data %>% group_by(PlayerYear) %>% summarize(two_att = mean(two_att), three_att = mean(three_att), 
                                                       two = mean(two), three =mean(three))
# number of 3point attempts have been increasing while number of 2 point attempts have been decreasing.

#plot it 

ggplot(shot_att, aes(x =PlayerYear)) +
  geom_point(aes(y= two_att), colour = "red") +
  geom_point(aes(y= three_att), colour = "blue") +
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018))
#You can see the mean shot attempts are increasing for 3's compared to 2's over the years 

#lets see what it really means by making more 2s and 3s 
##live or die by the three 
#what is the mean salary for players who took more than 3 threes a game
thr_sal<-data %>%  group_by(PlayerYear) %>% filter(three >= 3) %>% summarize(mean(salary), 
                                                                             median(salary),
                                                                             max(salary), 
                                                                             min(salary))
ggplot(thr_sal, aes(PlayerYear, `mean(salary)`)) + geom_line()

#should be interesting to see why there was a decrease then increase in 3 point salary

#Looking if more than three 3's gives more wins 

thr_win<-data %>%  group_by(PlayerYear) %>% filter(three >= 3) %>% summarize(meanW = mean(TeamWins,na.rm = T), 
                                                                             median(TeamWins,na.rm =T),
                                                                             max(TeamWins,na.rm = T), 
                                                                             min(TeamWins, na.rm = T))

ggplot(thr_win, aes(PlayerYear, meanW)) + geom_line()
#2015 point seems to be the turning point for increased number of wins if you have a team with players that
#took more than three 3's a game 
# now less than three threes a game
#salary
lessthr_sal<-data %>%  group_by(PlayerYear) %>% filter(three < 3) %>% summarize(mean(salary), 
                                                                                median(salary),
                                                                                max(salary), 
                                                                                min(salary))

ggplot(lessthr_sal, aes(PlayerYear, `mean(salary)`)) + geom_line()
#Still a general increase in salary.  Hence, the increase in salary cap might be affecting the increase
#in 3 points made over 3.  But as you can see the max and min salary is much lower as well.  


#wins 
thr_lose<-data %>%  group_by(PlayerYear) %>% filter(three < 3) %>% summarize(meanW = mean(TeamWins,na.rm = T), 
                                                                             median(TeamWins,na.rm =T),
                                                                             max(TeamWins,na.rm = T), 
                                                                             min(TeamWins, na.rm = T))
ggplot(thr_lose, aes(PlayerYear, meanW)) + geom_line()
#seems like later on attempting more 3's was beneficial.  From 2004 to 2008 not many people
#fully understood the 3 point shot and its value since a big man dominated league with little spacing
#if you took less than a mean of three 3's a game you would be an average team in the NBA

#for the two point shot mean salary
#look at the mean amount of 2 points made first
mean(data$two) 
mean(data$three)
two_w<-data %>% group_by(PlayerYear) %>% filter(two >=3) %>% summarize(mean(salary), median(salary),
                                                                       max(salary), min(salary))
ggplot(two_w, aes(PlayerYear, `mean(salary)`)) + geom_line()

#ppg and EFG can ppg be misleading for salary?  
#PPG
scorer <- data %>% group_by(PlayerYear) %>% summarize(mean(ppg), median(ppg),
                                                      max(ppg), min(ppg),
                                                      mean(salary), median(salary),
                                                      max(salary), min(salary))
ggplot(scorer, aes(x= PlayerYear, y = `mean(salary)`, colour = `mean(ppg)`)) + geom_jitter() +
  scale_colour_gradient(low = "red",high = "green")
#EFG
effective <- data %>% group_by(PlayerYear) %>% summarize(mean(EFG), median(EFG),
                                                         max(EFG), min(EFG),
                                                         mean(salary), median(salary),
                                                         max(salary), min(salary))
ggplot(effective, aes(x= PlayerYear, y = `mean(salary)`, colour = `mean(EFG)`)) + geom_jitter() +
  scale_colour_gradient(low = "red",high = "green")
#seems like players according to the mean are becoming more effective in their scoring with EFG increasing
#each year 

#Lets look at a 20 ppg scorer vs a 50 percent EFG players and see how their salaries compare. 
scorer20 <- data %>% group_by(PlayerYear) %>% filter(ppg >= 20) %>% summarize(mean(ppg), median(ppg),
                                                                              max(ppg), min(ppg),
                                                                              mean(salary), median(salary),
                                                                              max(salary), min(salary))
ggplot(scorer20, aes(x= PlayerYear, y = `mean(salary)`, colour = `mean(ppg)`)) + geom_jitter() +
  scale_colour_gradient(low = "red",high = "green")

#51 percent EFG
effective50 <- data %>% group_by(PlayerYear) %>% filter(EFG >= 0.51) %>% summarize(mean(EFG), median(EFG),
                                                                                   max(EFG), min(EFG),
                                                                                   mean(salary), median(salary),
                                                                                   max(salary), min(salary))
ggplot(effective50, aes(x= PlayerYear, y = `mean(salary)`, colour = `mean(EFG)`)) + geom_jitter() +
  scale_colour_gradient(low = "red",high = "green")

#looking at the data seems like having a high EFG didn't matter as much, but as we entered the 2014 year and above
#this statisic became more relevant 

#Schools with the biggest salary sum all the schools salary see which school earned the most


levels(data$school)
#249 schools (no school included for internationals if they played professionally outside the USA)


#ignoring none which could be highschool or internationals these are the top 10 schools being drafted from
school_tally <- data %>% group_by(school) %>% 
  summarise(count_school = n(), salary =sum(as.numeric(salary)))
school_tally %>% arrange(desc(count_school)) %>% head(n =11)
top_pay_school <- school_tally %>% arrange(desc(salary)) %>% head(n =11)
top_pay_school <- top_pay_school[-1,]
ggplot(top_pay_school, aes(school,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(top_pay_school$school))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
#Should be always looking at these schools for prospects looking at the total salary paid.  Seems to have best basketball programs

#but should look at the players who didn't have a school and see which players are these

IntandHigh <- data %>% subset(school == "None", select = c(name,salary,country,DraftYear,DraftNum)) %>% 
  arrange(desc(salary))



#Great out of highschool prospects Lebron James, Kobe Bryant, Kevin Garnett, Dwight Howard, Jermaine O'neal
#looking at the data mainly 5 out of 430 highschoolers or those who did not attend college made it to superstar level
#1.2 percent chance out of that subset 
#lets look at out of country

International <- IntandHigh %>% subset(country != "USA", c(name,salary,country,DraftYear,DraftNum)) %>% 
  arrange(desc(salary))

int_tally <- International %>% group_by(country) %>% 
  summarise(count_country = n(), salary =sum(as.numeric(salary)))

top_10_int<-int_tally %>% arrange(desc(salary)) %>% head(n =10)

#Looking at the top salaries would want to look into these countries in terms if finding talent or drafting in the future or free agents
#plot it
ggplot(top_10_int, aes(country,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(top_10_int$country))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# First pick vs 2nd round picks or undrafted had to make an all nba team 

#the number one draft picks
numberOne<-data %>% subset(DraftNum == 1, 
                           select = c(name, salary, EFG, ppg, country, school, team, PlayerYear,
                                      nba1,nba2,nba3,def1,def2))
starNumOne<-numberOne %>% subset(nba1 == "YES" | nba2 == "YES" | nba3 == "YES" | def1 == "YES" | def2 == "YES",
                                 select = c(name, salary, EFG, ppg, country, school, team, PlayerYear))
starNumOne_tally <- starNumOne %>% group_by(name) %>% 
  summarise(count_nba = n(), salary =sum(as.numeric(salary)))
ggplot(starNumOne_tally, aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(starNumOne_tally$name))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 



#anyone undrafted or in the 2nd round
notLottery <- data %>% subset(DraftRound != 1, 
                              select = c(name, salary, EFG, ppg, country, school, team, PlayerYear,
                                         nba1,nba2,nba3,def1,def2 ))
starNotLot<-notLottery %>% subset(nba1 == "YES" | nba2 == "YES" | nba3 == "YES" | def1 == "YES" | def2 == "YES",
                                  select = c(name, salary, EFG, ppg, country, school, team, PlayerYear))
rownames(starNotLot) <- NULL
starNotLot_tally <- starNotLot %>% group_by(name) %>% 
  summarise(count_nba = n(), salary =sum(as.numeric(salary)))
ggplot(starNotLot_tally, aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(starNotLot_tally$name))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#We can see that by not selecting the number one pick overall it yielded 4 more defensive players or nba team selections
#But we have to keep in mind other picks in the first round 

#find out highest paid player on each time and how much they take from their teams salary
#look at the 20 years for the best and worst team in each year

#2018
#most wins
win_18 <- data %>% subset(PlayerYear == 2018 & team == "HOU",
                          select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 


#least wins 
lose_18<-data %>% subset(PlayerYear == 2018 & team == "PHO",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 

#2017
#most wins
win_17<-data %>% subset(PlayerYear == 2017 & team == "GSW",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 

#least wins 
lose_17<-data %>% subset(PlayerYear == 2017 & team == "BRK",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins))

#2016
#most wins
win_16<-data %>% subset(PlayerYear == 2016 & team == "GSW",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_16<-data %>% subset(PlayerYear == 2016 & team == "PHI",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2015
#most wins
win_15<-data %>% subset(PlayerYear == 2015 & team == "GSW",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_15<-data %>% subset(PlayerYear == 2015 & team == "MIN",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2014
#most wins
win_14<-data %>% subset(PlayerYear == 2014 & team == "SAS",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_14<-data %>% subset(PlayerYear == 2014 & team == "MIL",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2013
#most wins
win_13<-data %>% subset(PlayerYear == 2013 & team == "MIA",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which.max(salary)],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_13<-data %>% subset(PlayerYear == 2013 & team == "ORL",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2012
#most wins
win_12S<-data %>% subset(PlayerYear == 2012 & team == "SAS",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
win_12C<-data %>% subset(PlayerYear == 2012 & team == "CHI",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins
lose_12<-data %>% subset(PlayerYear == 2012 & team == "CHO",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 

#2011
#most wins
win_11 <-data %>% subset(PlayerYear == 2011 & team == "CHI",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_11<-data %>% subset(PlayerYear == 2011 & team == "MIN",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2010
#most wins
win_10<-data %>% subset(PlayerYear == 2010 & team == "CLE",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_10<-data %>% subset(PlayerYear == 2010 & team == "BRK",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2009
#most wins
win_9<-data %>% subset(PlayerYear == 2009 & team == "CLE",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_9<-data %>% subset(PlayerYear == 2009 & team == "SAC",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2008
#most wins
win_8<-data %>% subset(PlayerYear == 2008 & team == "BOS",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_8<-data %>% subset(PlayerYear == 2008 & team == "MIA",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2007
#most wins
win_7<-data %>% subset(PlayerYear == 2007 & team == "DAL",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_7<-data %>% subset(PlayerYear == 2007 & team == "MEM",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2006
#most wins
win_6<-data %>% subset(PlayerYear == 2006 & team == "DET",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_6<-data %>% subset(PlayerYear == 2006 & team == "POR",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2005
#most wins
win_5<-data %>% subset(PlayerYear == 2005 & team == "PHO",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_5<-data %>% subset(PlayerYear == 2005 & team == "ATL",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2004
#most wins
win_4<-data %>% subset(PlayerYear == 2004 & team == "IND",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_4<-data %>% subset(PlayerYear == 2004 & team == "ORL",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2003
#most wins
win_3<-data %>% subset(PlayerYear == 2003 & team == "SAS",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_3C<-data %>% subset(PlayerYear == 2003 & team == "CLE",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
lose_3D<-data %>% subset(PlayerYear == 2003 & team == "DEN",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2002
#most wins
win_2<-data %>% subset(PlayerYear == 2002 & team == "SAC",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_2G<-data %>% subset(PlayerYear == 2002 & team == "GSW",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
lose_2C<-data %>% subset(PlayerYear == 2002 & team == "CHI",
                         select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2001
#most wins
win_1<-data %>% subset(PlayerYear == 2001 & team == "SAS",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 

#least wins 
lose_1<-data %>% subset(PlayerYear == 2001 & team == "CHI",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#2000
#most wins
win_0<-data %>% subset(PlayerYear == 2000 & team == "LAL",
                       select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#least wins 
lose_0<-data %>% subset(PlayerYear == 2000 & team == "LAC",
                        select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 

#lets look at the trend of winners and losers 
win00_18<-rbind(win_0,win_1,win_2,win_3,win_4,win_5,win_6,win_7,win_8,win_9,win_10,win_11,win_12S, win_12C,
                win_13,win_14,win_15,win_16,win_17,win_18)
win00_18["PlayerYear"]<- c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2012,2013,
                           2014,2015,2016,2017,2018)
#lets see how good teams are sticking with their salary cap
ggplot(win00_18,aes(x=PlayerYear)) +
  geom_line(aes(y = tmsalary), colour = "green") +
  geom_line(aes(y = salcap), colour = "red") +
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018))

#totally spending above the cap

##lets look at the losers now 

lose00_18<-rbind(lose_0,lose_1,lose_2C,lose_2G,lose_3C,lose_3D,lose_4,lose_5,lose_6,lose_7,
                 lose_8,lose_9,lose_10,lose_11,lose_12,
                 lose_13,lose_14,lose_15,lose_16,lose_17,lose_18)
lose00_18["PlayerYear"]<- c(2000,2001,2002,2002,2003,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,
                            2014,2015,2016,2017,2018)
#lets see how good teams are sticking with their salary cap
ggplot(lose00_18,aes(x=PlayerYear)) +
  geom_line(aes(y = tmsalary), colour = "green") +
  geom_line(aes(y = salcap), colour = "red") +
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018))
#looks like some teams overspend but other teams stick close to the salarycap just to fill the cap
win00_18["Type"] <- "Winner"
win00_18["team"]<- c("LAL","SAS","SAC","SAS","IND","PHO","DET","DAL","BOS","CLE","CLE",
                     "CHI","SAS","CHI","MIA","SAS","GSW","GSW","GSW","HOU")
lose00_18["Type"] <- "Loser"
lose00_18["team"] <- c("LAC","CHI","CHI","GSW","CLE","DEN","ORL","ATL","POR","MEM","MIA","SAC","BRK",
                       "MIN","CHO","ORL","MIL","NYK","PHI","BRK","PHO")
winvslose <- rbind(win00_18, lose00_18)

#Comparison of team spending Top vs worst team according to year 
ggplot(winvslose, aes(x = team, y = tmsalary, fill = Type)) +
  geom_bar(position = "stack", stat = "identity")  +
  facet_wrap( ~ PlayerYear, scale = "free")
#lets look at a comparison of their top player salary
ggplot(winvslose, aes(x = NameTopSal, y = TopPaid, fill = Type)) +
  geom_bar(position = "stack", stat = "identity")  +
  facet_wrap( ~ PlayerYear, scale = "free")
#Lets look at a comparison of their average salary 
ggplot(winvslose, aes(x=PlayerYear, y = AvgSal, fill = Type, color = wins)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")



##### Lets look at the most wins vs least wins through 2000-2019 Both same year 2012 CHO and 2016 GSW
####then look at biggest salary cap offender that has biggest number of wins vs 
#least number of wins with smalles overunder salary see if teams tank on purpose by signing cheap players
#first lets look at the trend of salary by year for both team salary and salary cap 
ggplot(data, aes(PlayerYear)) +
  geom_smooth(aes(y = SalCap),colour ="red")+
  geom_smooth(aes(y = tmsalary), colour ="green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018))

#----# Most sucessful NBA season 
data %>% subset(PlayerYear == 2016 & team == "GSW",
                select = name:SalCap) %>%
  ggplot(aes(x="", y=salary, fill=name))+
  geom_bar(width = 1, stat = "identity")

#Salary Spread
data %>% group_by(salary) %>% 
  subset(PlayerYear == 2016 & team == "GSW",
         select = c(name, salary, ppg, EFG, t_reb, PlusMinus)) %>% 
  arrange(desc(salary))
#Team Statistics  
data %>% subset(PlayerYear == 2016 & team == "GSW",
                select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#plot the salary spread 
goldenW <-data %>% subset(PlayerYear == 2016 & team == "GSW",
                          select = c(name,salary))

ggplot(goldenW,aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(goldenW$name))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(breaks=c(0,2500000,5000000,7500000,10000000, 
                              12500000, 15000000,17500000), limits =c(0,17500000))

#lets see how a 73 win team drafted
goldenCity<-data %>% subset(team == "GSW", select = c(name,salary, ppg, EFG,rook1,rook2))
goldenCity %>% subset(rook1 == "YES", rook2 =="YES", select = c(name,salary, ppg, EFG))
#also drafted Draymond Green 
#Least succesful NBA season 
bigL <- data %>% subset(PlayerYear == 2012 & team == "CHO",
                        select = name:SalCap) 


#Salary Spread
data %>% group_by(salary) %>% 
  subset(PlayerYear == 2012 & team == "CHO",
         select = c(name, salary, ppg, EFG, t_reb, PlusMinus)) %>% 
  arrange(desc(salary))
#Team Statistics  
data %>% subset(PlayerYear == 2012 & team == "CHO",
                select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#plot the salary spread 
ggplot(bigL,aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(bigL$name))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(breaks=c(0,2500000,5000000,7500000,10000000,12500000), 
                     limits =c(0,12500000))
WinnerGSW<-sum(as.numeric(goldenW$salary))
LoserCHO<-sum(as.numeric(bigL$salary))
#compare the biggest winner with the biggest loser
winVsloss <-data.frame(team = c("GSW", "CHO"), salary = c(WinnerGSW, LoserCHO))
ggplot(winVsloss,aes(team,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(compare$team))) 

####-----#### 
#max salary offender 
data %>% subset(tmsalary == max(tmsalary), select = c(team,PlayerYear)) 
bigMoney<-data %>% subset(PlayerYear == 2018 & team == "CLE",
                          select = name:SalCap) 

#Salary Spread
ggplot(bigMoney,aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(bigMoney$name))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(breaks=c(0,5000000, 10000000, 15000000,20000000,25000000,30000000,
                              35000000), limits =c(0,35000000))
rich<-sum(as.numeric(bigMoney$salary))


#Team Statistics  
data %>% subset(PlayerYear == 2018 & team == "CLE",
                select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 



#min salary offender want to see if tanking 
data %>% subset(tmsalary == min(tmsalary), select = c(team,PlayerYear))
noMoney <- data %>% subset(PlayerYear == 2000 & team == "LAC",
                           select = name:SalCap)
#Salary Spread
data %>% group_by(salary) %>% 
  subset(PlayerYear == 2000 & team == "LAC",
         select = c(name, salary, ppg, EFG, t_reb, PlusMinus)) %>% 
  arrange(desc(salary))

#plot salary spread 
ggplot(noMoney,aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(noMoney$name))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(breaks=c(0,500000, 1000000, 1500000,2000000,2500000,3000000,
                              3500000), limits =c(0,3500000))
poor<-sum(as.numeric(noMoney$salary))
#Team Statistics  
data %>% subset(PlayerYear == 2000 & team == "LAC",
                select = name:SalCap) %>% 
  summarize(total = sum(salary),TopPaid = max(salary),
            NameTopSal = name[which(salary == max(salary))],
            highscore = max(ppg), 
            NameTopPpg = name[which.max(ppg)],
            efficient = max(EFG),
            NameTopEFG = name[which.max(EFG)],
            HighPlusMinus = max(PlusMinus),
            NameTopPM = name[which.max(PlusMinus)],
            LeastPaid = min(salary), 
            NameLowSal = name[which.min(salary)],
            AvgSal = mean(salary), 
            tmsalary = median(tmsalary), salcap = median(SalCap),
            OverUnder = (median(tmsalary)/(median(SalCap))), 
            wins = median(TeamWins)) 
#lets see if they selected any good rookies from tanking 
Clippers<-data %>% subset(team == "LAC", select = c(name,salary, ppg, EFG,rook1,rook2))
Clippers %>% subset(rook1 == "YES"| rook2 =="YES", select = c(name,salary, ppg, EFG))
compare <-data.frame(team = c("CLE", "LAC"), salary = c(rich, poor))
ggplot(compare,aes(team,salary)) + 
  geom_bar(stat = "identity", position = "stack",fill = rainbow(n=length(compare$team))) 

#2018 average joe find the average joe for each year then rbind them 
AvgJoe_18<-data %>% filter(PlayerYear == 2018) %>% summarize(name = "AvgJoe_2018",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per = mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_17<-data %>% filter(PlayerYear == 2017) %>% summarize(name = "AvgJoe_2017",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_16<-data %>% filter(PlayerYear == 2016) %>% summarize(name = "AvgJoe_2016",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_15<-data %>% filter(PlayerYear == 2015) %>% summarize(name = "AvgJoe_2015",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_14<-data %>% filter(PlayerYear == 2014) %>% summarize(name = "AvgJoe_2014",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two/two_att),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_13<-data %>% filter(PlayerYear == 2013) %>% summarize(name = "AvgJoe_2013",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_12<-data %>% filter(PlayerYear == 2012) %>% summarize(name = "AvgJoe_2012",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_11<-data %>% filter(PlayerYear == 2011) %>% summarize(name = "AvgJoe_2011",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_10<-data %>% filter(PlayerYear == 2010) %>% summarize(name = "AvgJoe_2010",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_09<-data %>% filter(PlayerYear == 2009) %>% summarize(name = "AvgJoe_2009",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_08<-data %>% filter(PlayerYear == 2008) %>% summarize(name = "AvgJoe_2008",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_07<-data %>% filter(PlayerYear == 2007) %>% summarize(name = "AvgJoe_2007",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_06<-data %>% filter(PlayerYear == 2006) %>% summarize(name = "AvgJoe_2006",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_05<-data %>% filter(PlayerYear == 2005) %>% summarize(name = "AvgJoe_2005",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_04<-data %>% filter(PlayerYear == 2004) %>% summarize(name = "AvgJoe_2004",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_03<-data %>% filter(PlayerYear == 2003) %>% summarize(name = "AvgJoe_2003",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_02<-data %>% filter(PlayerYear == 2002) %>% summarize(name = "AvgJoe_2002",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_01<-data %>% filter(PlayerYear == 2001) %>% summarize(name = "AvgJoe_2001",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe_00<-data %>% filter(PlayerYear == 2000) %>% summarize(name = "AvgJoe_2000",height = mean(height_cm), weight =mean(weight_lb),
                                                             salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                             games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                             fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                             three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                             two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                             efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                             o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                             steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                             ppg =mean(ppg))
AvgJoe<-rbind(AvgJoe_00,AvgJoe_01,AvgJoe_02,AvgJoe_03,AvgJoe_04,AvgJoe_05,AvgJoe_06,
              AvgJoe_07,AvgJoe_08,AvgJoe_09,AvgJoe_10,AvgJoe_11,AvgJoe_12,AvgJoe_13,
              AvgJoe_14,AvgJoe_15,AvgJoe_16,AvgJoe_17,AvgJoe_18)

AvgJoe["PlayerYear"]<- c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,
                         2014,2015,2016,2017,2018)
AvgJoe <-AvgJoe[,-1]

ggplot(AvgJoe, aes(PlayerYear, salary, color = ppg)) + geom_line()  +
  scale_colour_gradient(low = "red",high = "green")
#number of points seems to dip after a bit maybe inefficient scoring 
ggplot(AvgJoe, aes(PlayerYear, salary, color = efg)) + geom_line()  +
  scale_colour_gradient(low = "red",high = "green")
#EFG wasn't really valuable in the early years but it slowly started gaining steam after 2015 


#the mean of the 19 seasons 

avgJoe19yrs<- AvgJoe %>%  summarize(name = "AvgJoe",height = mean(height), weight =mean(weight),
                                    salary = mean(salary), plusMinus =mean(plusMinus), age =mean(age),
                                    games = mean(games), start = mean(start), mins =mean(mins),
                                    fg=mean(fg), fg_att =mean(fg_att), fg_per =mean(fg_per),
                                    three =mean(three), three_att = mean(three_att), three_per =mean(three_per),
                                    two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                    efg=mean(efg), ft=mean(ft), ft_att =mean(ft_att), ft_per = mean(ft_per),
                                    o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                    steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                    ppg =mean(ppg))
AvgJoe["Type"] <- "Avg"


#### select 15 players who played more than 15 years to see the trend of a players salary
theVets <- data %>% subset(NumYears >= 15, select = c(PlayerYear:SalCap))
superVets <- theVets %>%  subset(nba1 == "YES" | def1 == "YES", select = c(PlayerYear:SalCap))
starVets <- theVets %>%  subset(nba2 == "YES" |nba3 == "YES" | def2 == "YES", select = c(PlayerYear:SalCap))
roleVets <- theVets %>%  subset(nba1 != "YES" | def1 != "YES",
                                nba2 == "YES" |nba3 == "YES" | def2 == "YES",
                                select = c(PlayerYear:SalCap))
#Top SuperStars 5
#Tim Duncan Kobe Bryant Lebron James Kevin Garnett Dirk Nowitzki 
fundamental <- data %>% subset(name == "Tim Duncan", select= c(PlayerYear:SalCap))
ggplot(fundamental, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe
fundamental[,"Type"] <- "Superstar"
timvsAvg<-fundamental %>% subset(Type == "Superstar", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                                 MinGames, ppg, EFG, Type))
Avgvs<-AvgJoe %>% subset(Type == "Avg", select = c(PlayerYear,salary,height,plusMinus, 
                                                   mins, ppg, efg, Type))
colnames(Avgvs)[1:8] <- c("PlayerYear", "salary", "height_cm", "PlusMinus", 
                          "MinGames", "ppg", "EFG", "Type")
timvsAv <- rbind(timvsAvg, Avgvs)

ggplot(timvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

mamba <- data %>% subset(name == "Kobe Bryant", select= c(PlayerYear:SalCap))
ggplot(mamba, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#lets see maybe the smallest player got taller and on average all nba players are the same height 

tall<-data %>% subset(height_cm >= 213, select = c(PlayerYear, name))
tall_tally <- tall %>% group_by(PlayerYear) %>% summarise(count_name = n())

ggplot(tall_tally, aes(PlayerYear, count_name)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(tall_tally$PlayerYear))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Number of 7ft players") + 
  ggtitle("7fters over 19 years")


#Compare to the average joe 
mamba[,"Type"] <- "Superstar"
kobevsAvg<-mamba %>% subset(Type == "Superstar", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                            MinGames, ppg, EFG, Type))

kobevsAv <- rbind(kobevsAvg, Avgvs)

ggplot(kobevsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

king <- data %>% subset(name == "LeBron James", select= c(PlayerYear:SalCap))
ggplot(king, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe
king[,"Type"] <- "Superstar"
lebrvsAvg<-king %>% subset(Type == "Superstar", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                           MinGames, ppg, EFG, Type))

lebrvsAv <- rbind(lebrvsAvg, Avgvs)

ggplot(lebrvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

ticket <- data %>% subset(name == "Kevin Garnett", select= c(PlayerYear:SalCap))
ggplot(ticket, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

#Compare to the average joe 
ticket[,"Type"] <- "Superstar"
kevinvsAvg<-ticket %>% subset(Type == "Superstar", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                              MinGames, ppg, EFG, Type))

kevinvsAv <- rbind(kevinvsAvg, Avgvs)

ggplot(kevinvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

wunderkid <- data %>% subset(name == "Dirk Nowitzki", select= c(PlayerYear:SalCap))
ggplot(wunderkid, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe 
wunderkid[,"Type"] <- "Superstar"
dirkvsAvg<-wunderkid %>% subset(Type == "Superstar", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                                MinGames, ppg, EFG, Type))

dirkvsAv <- rbind(dirkvsAvg, Avgvs)

ggplot(dirkvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

#Height comparison 
ggplot(data, aes(NumYears, height_cm, color = salary)) + 
  geom_smooth() +
  ggtitle("Height vs Number of Years in NBA")

#Stars 5
#Vince Carter Manu Ginobli Nash Carmelo Anthony Pau Gasol Tony Parker
higlight <- data %>% subset(name == "Vince Carter", select= c(PlayerYear:SalCap)) 
ggplot(higlight, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe 
higlight[,"Type"] <- "Star"
vincevsAvg<-higlight %>% subset(Type == "Star", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                           MinGames, ppg, EFG, Type))

vincevsAv <- rbind(vincevsAvg, Avgvs)

ggplot(vincevsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

ginob <- data %>% subset(name == "Manu Ginobili", select= c(PlayerYear:SalCap))
ggplot(ginob, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe 
ginob[,"Type"] <- "Star"
ginvsAvg<-ginob %>% subset(Type == "Star", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                      MinGames, ppg, EFG, Type))

ginvsAv <- rbind(ginvsAvg, Avgvs)

ggplot(ginvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
melo <- data %>% subset(name == "Carmelo Anthony", select= c(PlayerYear:SalCap))
ggplot(melo, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe
melo[,"Type"] <- "Star"
melovsAvg<-melo %>% subset(Type == "Star", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                      MinGames, ppg, EFG, Type))

melovsAv <- rbind(melovsAvg, Avgvs)

ggplot(melovsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

gasol<- data %>% subset(name == "Pau Gasol", select= c(PlayerYear:SalCap))
ggplot(gasol, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe
gasol[,"Type"] <- "Star"
gasolvsAvg<-gasol %>% subset(Type == "Star", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                        MinGames, ppg, EFG, Type))

gasolvsAv <- rbind(gasolvsAvg, Avgvs)

ggplot(gasolvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

parker <- data %>% subset(name == "Tony Parker", select= c(PlayerYear:SalCap))
ggplot(parker, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe 
parker[,"Type"] <- "Star"
parkervsAvg<-parker %>% subset(Type == "Star", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                          MinGames, ppg, EFG, Type))

parkervsAv <- rbind(parkervsAvg, Avgvs)

ggplot(parkervsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

#Role Player 5 
#Nene Hilario Mike Miller Kyle Korver Mike Dunleavy Jamal Crawford Derrik Fisher  
nene <- data %>% subset(name == "Nene Hilario", select= c(PlayerYear:SalCap)) 
#salary in relation to the age and mins per game 
ggplot(nene, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

#Compare to the average joe
nene[,"Type"] <- "Role"
nenevsAvg<-nene %>% subset(Type == "Role", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                      MinGames, ppg, EFG, Type))

nenevsAv <- rbind(nenevsAvg, Avgvs)

ggplot(nenevsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

mMiller <- data %>% subset(name == "Mike Miller", select= c(PlayerYear:SalCap)) 
#salary in relation to the age and mins per game 
ggplot(mMiller, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe 
mMiller[,"Type"] <- "Role"
mMillervsAvg<-mMiller %>% subset(Type == "Role", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                            MinGames, ppg, EFG, Type))

mMillervsAv <- rbind(mMillervsAvg, Avgvs)

ggplot(mMillervsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

dunleavy <- data %>% subset(name == "Mike Dunleavy", select= c(PlayerYear:SalCap)) 
#salary in relation to the age and mins per game 
ggplot(dunleavy, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

#Compare to the average joe 
dunleavy[,"Type"] <- "Role"
dunleavyvsAvg<-dunleavy %>% subset(Type == "Role", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                              MinGames, ppg, EFG, Type))

dunleavyvsAv <- rbind(dunleavyvsAvg, Avgvs)

ggplot(dunleavyvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

crawford <- data %>% subset(name == "Jamal Crawford", select= c(PlayerYear:SalCap)) 
#salary in relation to the age and mins per game 
ggplot(crawford, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")

#Compare to the average joe 
crawford[,"Type"] <- "Role"
crawfordvsAvg<-crawford %>% subset(Type == "Role", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                              MinGames, ppg, EFG, Type))

crawfordvsAv <- rbind(crawfordvsAvg, Avgvs)

ggplot(crawfordvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")


dfisher <- data %>% subset(name == "Derek Fisher", select= c(PlayerYear:SalCap)) 
#salary in relation to the age and mins per game 
ggplot(dfisher, aes(Age, salary, color = MinGames)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")
#Compare to the average joe 
dfisher[,"Type"] <- "Role"
dfishervsAvg<-dfisher %>% subset(Type == "Role", select = c(PlayerYear, salary, height_cm, PlusMinus,
                                                            MinGames, ppg, EFG, Type))

dfishervsAv <- rbind(dfishervsAvg, Avgvs)

ggplot(dfishervsAv, aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green") 







###MVP, DPOY, ROY, MIP, MAX salary trends and MIN salary trends Mid level exception trends 

#MVP
mvpdata<-data %>% subset(mvp == "YES", select =c(PlayerYear, salary, height_cm, PlusMinus,
                                                 MinGames, ppg, EFG))
mvpdata[,"Type"] <- "MVP"
mvpdatavsAv <- rbind(mvpdata, Avgvs)

ggplot(mvpdatavsAv, aes(x=PlayerYear, y = salary, fill = Type, color = PlusMinus)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 
#DPOY
dpoydata<-data %>% subset(dpoy == "YES", select =c(PlayerYear, salary, height_cm, PlusMinus,
                                                   MinGames, ppg, EFG))
dpoydata[,"Type"] <- "DPOY"
dpoydatavsAv <- rbind(dpoydata, Avgvs)

ggplot(dpoydatavsAv, aes(x=PlayerYear, y = salary, fill = Type, color = PlusMinus)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 

#ROY
roydata<-data %>% subset(roy == "YES", select =c(PlayerYear, salary, height_cm, PlusMinus,
                                                 MinGames, ppg, EFG))
roydata[,"Type"] <- "ROY"
roydatavsAv <- rbind(roydata, Avgvs)

ggplot(roydatavsAv, aes(x=PlayerYear, y = salary, fill = Type, color = PlusMinus)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 

#MIP
mipdata<-data %>% subset(mip == "YES", select =c(PlayerYear, salary, height_cm, PlusMinus,
                                                 MinGames, ppg, EFG))
mipdata[,"Type"] <- "MIP"
mipdatavsAv <- rbind(mipdata, Avgvs)

ggplot(mipdatavsAv, aes(x=PlayerYear, y = salary, fill = Type, color = PlusMinus)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 


mipdata1<-data %>% subset(mip == "YES", select =c(PlayerYear, salary, height_cm, PlusMinus,
                                                 MinGames, ppg, EFG, name))
#MAX

#############

max_2018 <- subset(data, PlayerYear==2018 & salary == max(salary),
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2017 <- data %>% filter(PlayerYear == 2017) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2016 <- data %>% filter(PlayerYear == 2016) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2015 <- data %>% filter(PlayerYear == 2015) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2014 <- data %>% filter(PlayerYear == 2014) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2013 <- data %>% filter(PlayerYear == 2013) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2012 <- data %>% filter(PlayerYear == 2012) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2011 <- data %>% filter(PlayerYear == 2011) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2010 <- data %>% filter(PlayerYear == 2010) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2009 <-data %>% filter(PlayerYear == 2009) %>% subset(salary == max(salary),
                                                          select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2008 <- data %>% filter(PlayerYear == 2008) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2007 <- data %>% filter(PlayerYear == 2007) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2006 <- data %>% filter(PlayerYear == 2006) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2005 <- data %>% filter(PlayerYear == 2005) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2004 <- data %>% filter(PlayerYear == 2004) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2003 <- data %>% filter(PlayerYear == 2003) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2002 <- data %>% filter(PlayerYear == 2002) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2001 <- data %>% filter(PlayerYear == 2001) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
max_2000 <- data %>% filter(PlayerYear == 2000) %>% subset(salary == max(salary),
                                                           select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG))
mr_max <-rbind(max_2018, max_2017, max_2016, max_2015, max_2014, max_2013,
               max_2012, max_2011, max_2010, max_2009, max_2008, max_2007,
               max_2006, max_2005, max_2004, max_2003, max_2002, max_2001, max_2000)

mr_max[,"Type"] <- "MAX"
mr_maxR<- mr_max[,-1]
mr_maxRvsAv <- rbind(mr_maxR, Avgvs)

ggplot(mr_maxRvsAv, aes(x=PlayerYear, y = salary, fill = Type, color = PlusMinus)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 

###################

#MIN

################

#the min player # go with the CBA min salary for each year for a player that has at least 1 year of playing experience

min_2018 <- subset(data, PlayerYear==2018 & salary <= 1312611,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2017 <- subset(data, PlayerYear==2017 & salary <= 874636,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2016 <- subset(data, PlayerYear==2016 & salary <= 845059,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2015 <- subset(data, PlayerYear==2015 & salary <= 816482,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2014 <- subset(data, PlayerYear==2014 & salary <= 788872,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2013 <- subset(data, PlayerYear==2013 & salary <= 762195,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2012 <- subset(data, PlayerYear==2012 & salary <= 762195,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2011 <- subset(data, PlayerYear==2011 & salary <= 762195,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2010 <- subset(data, PlayerYear==2010 & salary <= 736420,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2009 <-subset(data, PlayerYear==2009 & salary <= 711517,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
min_2008 <- subset(data, PlayerYear==2008 & salary <= 687456,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2007 <- subset(data, PlayerYear==2007 & salary <= 664209,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2006 <- subset(data, PlayerYear==2006 & salary <= 641748,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
min_2005 <-subset(data, PlayerYear==2005 & salary <= 620046,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
min_2004 <-subset(data, PlayerYear==2004 & salary <= 563679,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
min_2003 <-subset(data, PlayerYear==2003 & salary <= 512435,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
min_2002 <-subset(data, PlayerYear==2002 & salary <= 465850,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
min_2001 <-subset(data, PlayerYear==2001 & salary <= 423500,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
min_2000 <- subset(data, PlayerYear==2000 & salary <= 385000,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))


min_2018a<- min_2018 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2017a<- min_2017 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2016a<- min_2016 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2015a<- min_2015 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2014a<- min_2014 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2013a<- min_2013 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2012a<- min_2012 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2011a<- min_2011 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2010a<- min_2010 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2009a<- min_2009 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2008a<- min_2008 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2007a<- min_2007 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2006a<- min_2006 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2005a<- min_2005 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2004a<- min_2004 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2003a<- min_2003 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2002a<- min_2002 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2001a<- min_2001 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
min_2000a<- min_2000 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))

mr_min <-rbind(min_2018a, min_2017a, min_2016a, min_2015a, min_2014a, min_2013a,
               min_2012a, min_2011a, min_2010a, min_2009a, min_2008a, min_2007a,
               min_2006a, min_2005a, min_2004a, min_2003a, min_2002a, min_2001a, min_2000a)

mr_min[,"Type"] <- "MIN"
mr_minvsAv <- rbind(mr_min, Avgvs)

ggplot(mr_minvsAv, aes(x=PlayerYear, y = ppg, fill = Type, color = salary)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 

#Mid level exception 

# the med level exception lets go with if you are over the salarycap and are a taxpayer since we want to compete for a winning season
#for salaries lets go 25 percent under and over for negotiation skills 
#5,192,000
med_2018 <- subset(data, PlayerYear==2018 & salary <= 6490000 & salary >= 3894000 & DraftYear != 2018 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
#3,477,000
med_2017 <- subset(data, PlayerYear==2017 & salary <= 4346250 & salary >= 2607750 & DraftYear != 2017 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
#3,376,000
med_2016 <- subset(data, PlayerYear==2016 & salary <= 4220000 & salary >= 2532000 & DraftYear != 2016 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
#3,278,000
med_2015 <- subset(data, PlayerYear==2015 & salary <= 4097500 & salary >= 2458500 & DraftYear != 2015 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
#3,183,000
med_2014 <- subset(data, PlayerYear==2014 & salary <= 3978750 & salary >= 2387250 & DraftYear != 2014 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
#3,090,000
med_2013 <- subset(data, PlayerYear==2013 & salary <= 3862500 & salary >= 2317500 & DraftYear != 2013 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
#3,000,000
med_2012 <- subset(data, PlayerYear==2012 & salary <= 3750000 & salary >= 2250000 & DraftYear != 2012 & Age > 23 ,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
# Before the 2011 CBA, the MLE was equal to the average NBA salary for all teams over the cap
# mutate 

midexc2011<-subset(data, PlayerYear==2011 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2011$salary)

#4990128 
med_2011 <- subset(data, PlayerYear==2011 & salary <= 6237660 & salary >= 3742596 & DraftYear != 2011 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))


midexc2010<-subset(data, PlayerYear==2010 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2010$salary)

#5055895
med_2010 <- subset(data, PlayerYear==2010 & salary <= 6319868 & salary >= 3791921 & DraftYear != 2010 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))

midexc2009<-subset(data, PlayerYear==2009 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2009$salary)
#4927921
med_2009 <-subset(data, PlayerYear==2009 & salary <= 6159901 & salary >= 3695940 & DraftYear != 2009 & Age > 23,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
midexc2008<-subset(data, PlayerYear==2008 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2008$salary)
#4791522
med_2008 <- subset(data, PlayerYear==2008 & salary <= 5989402 & salary >= 3593641 & DraftYear != 2008 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
midexc2007<-subset(data, PlayerYear==2007 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2007$salary)
#4459748
med_2007 <- subset(data, PlayerYear==2007 & salary <= 5574685 & salary >= 3344811 & DraftYear != 2007 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
midexc2006<-subset(data, PlayerYear==2006 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2006$salary)
#4475003
med_2006 <- subset(data, PlayerYear==2006 & salary <= 5593753 & salary >= 3356252 & DraftYear != 2006 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))
midexc2005<-subset(data, PlayerYear==2005 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2005$salary)
#4297463
med_2005 <-subset(data, PlayerYear==2005 & salary <= 5371828 & salary >= 3223097 & DraftYear != 2005 & Age > 23,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
midexc2004<-subset(data, PlayerYear==2004 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2004$salary)
#4113290
med_2004 <-subset(data, PlayerYear==2004 & salary <= 5141612 & salary >= 3084967 & DraftYear != 2004 & Age > 23,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
midexc2003<-subset(data, PlayerYear==2003 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2003$salary)
#3844233
med_2003 <-subset(data, PlayerYear==2003 & salary <= 4805291 & salary >= 2883174 & DraftYear != 2003 & Age > 23,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
midexc2002<-subset(data, PlayerYear==2002 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2002$salary)
#3674357
med_2002 <-subset(data, PlayerYear==2002 & salary <= 4592946 & salary >= 2755767 & DraftYear != 2002 & Age > 23,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
midexc2001<-subset(data, PlayerYear==2001 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2001$salary)
#3642971
med_2001 <-subset(data, PlayerYear==2001 & salary <= 4553713 & salary >= 2732228 & DraftYear != 2001 & Age > 23,
                  select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                             started))
midexc2000<-subset(data, PlayerYear==2000 & overUnder > 1.05,
                   select = c(team, tmsalary, salary))
mean(midexc2000$salary)
#3084692
med_2000 <- subset(data, PlayerYear==2000 & salary <= 3855865 & salary >= 2313519 & DraftYear != 2000 & Age > 23,
                   select = c(name,PlayerYear,salary,height_cm,PlusMinus,MinGames, ppg, EFG, Games,
                              started))


mr_med <-rbind(med_2018, med_2017, med_2016, med_2015, med_2014, med_2013,
               med_2012, med_2011, med_2010, med_2009, med_2008, med_2007,
               med_2006, med_2005, med_2004, med_2003, med_2002, med_2001, med_2000)
notable_med<-mr_med %>% subset(ppg >= 10 & PlusMinus >= 5 & MinGames >= 15 & Games >= 40, 
                  select = c(name, ppg, PlusMinus, MinGames, Games, PlayerYear))
#these are some of the notable names that could have been signed for the mid level exception. 
#of course not that accurate because damian lilard and klay thompson shouldn't be on this list.

#lets look at the mean average of med exception players vs the average players over the years 

med_2018a<- med_2018 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2017a<- med_2017 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2016a<- med_2016 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2015a<- med_2015 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2014a<- med_2014 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2013a<- med_2013 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2012a<- med_2012 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2011a<- med_2011 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2010a<- med_2010 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2009a<- med_2009 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2008a<- med_2008 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2007a<- med_2007 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2006a<- med_2006 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2005a<- med_2005 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2004a<- med_2004 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2003a<- med_2003 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2002a<- med_2002 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2001a<- med_2001 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))
med_2000a<- med_2000 %>% summarize(PlayerYear=mean(PlayerYear), salary = mean(salary), height_cm = mean(height_cm),
                                   PlusMinus = mean(PlusMinus), MinGames = mean(MinGames), ppg = mean(ppg),
                                   EFG = mean(EFG))

mr_meda <-rbind(med_2018a, med_2017a, med_2016a, med_2015a, med_2014a, med_2013a,
               med_2012a, med_2011a, med_2010a, med_2009a, med_2008a, med_2007a,
               med_2006a, med_2005a, med_2004a, med_2003a, med_2002a, med_2001a, med_2000a)

mr_meda[,"Type"] <- "MED"
mr_medavsAv <- rbind(mr_meda, Avgvs)

ggplot(mr_medavsAv , aes(x=PlayerYear, y = salary, fill = Type, color = ppg)) +
  geom_line() +
  scale_colour_gradient(low = "red",high = "green")+
  scale_x_continuous(breaks=c(2000,2002,2004,2006,2008,2010,2012,2014,2016,2018), 
                     limits =c(2000,2018))+
  geom_dl(aes(label = Type), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Type), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) 