##Statisical Testing
#Loading in the library
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(data.table)
library(ggrepel)
library(directlabels)
library(gridExtra)
options(max.print = 999999999)
options(scipen=12)

#loading the data 
#set directory 
getwd()
setwd("/users/justinvhuang/desktop/nba_stat_salaries")
getwd()

#loading in the data
data<-read.csv("2018_2000_nba.csv")
data <- data[,-1]

# looking at the data
glimpse(data)
head(data)
names(data)
summary(data)
str(data)

#Stastical Analysis 

  #Can you count something interesting?
  #top schools for NBA teams and their salaries 

school_tally <- data %>% group_by(school) %>% 
  summarise(count_school = n(), salary =sum(as.numeric(salary)))
school_tally %>% arrange(desc(count_school)) %>% head(n =11)
top_pay_school <- school_tally %>% arrange(desc(salary)) %>% head(n =11)
top_pay_school <- top_pay_school[-1,]
ggplot(top_pay_school, aes(school,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(top_pay_school$school))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Top Paying Schools") +
  scale_y_continuous(breaks=c(0,250000000,500000000,750000000,1000000000,1250000000))

#Lets see the top 3 Colleges what positions they provide the most
top3colleges<-data %>% 
  filter(school == "Kentucky"|school == "Duke"|school =="North Carolina") %>% 
  group_by(Pos,height_cm,salary,name,school)

#which team drafted the most from these colleges 
top3TeamTally <- top3colleges %>% 
  group_by(team) %>% 
  summarize(count_team = n())
mostpicks<-top3TeamTally %>% arrange(desc(count_team)) %>% head(n=10)
mostpicks
#which position got drafted the most 
top3PosTally <- top3colleges %>% 
  group_by(Pos) %>% 
  summarize(count_pos = n())
mostPos<- top3PosTally %>% arrange(desc(count_pos)) %>% head(n =5)
mostPos
#top paid players from these schools 
lotpicks<-top3colleges %>% 
  filter(DraftRound ==1) %>% 
  group_by(DraftRound,DraftNum,name,salary,school) %>% 
  summarize(count_draftround = n())
schoolpick <-lotpicks %>% arrange(desc(count_draftround)) %>% head(n = 10)
lotpickpaid<-lotpicks %>% arrange(desc(salary)) %>%  head(n = 10)
lotpickpaid


#  Can you find some trends (high, low, increase, decrease, anomalies)?
  #Look at increase in salary over the years focus on salary cap
#Looking at the correlations
cor(data[, sapply(data, is.numeric)],
    use = "complete.obs", method = "pearson")

#intresting correlations to look at that stand out 
#height and weight
cor(data$height_cm,data$weight_lb)
ggplot(data, aes(height_cm,weight_lb)) + geom_point()
#age and salary
cor(data$Age,data$salary)
ggplot(data,aes(Age,salary)) + geom_point()
#d_reb and salary
cor(data$d_reb,data$salary)
ggplot(data,aes(d_reb,salary)) +geom_point()
#FG and salary
cor(data$FG, data$salary)
ggplot(data,aes(FG,salary)) +geom_point()
#height and rebound
cor(data$height_cm, data$t_reb)
ggplot(data, aes(height_cm,t_reb)) +geom_point()
#weight and rebound
cor(data$weight_lb, data$t_reb)
ggplot(data, aes(weight_lb, t_reb)) +geom_point()
#To and salary
cor(data$TO,data$salary)
ggplot(data, aes(TO, salary)) + geom_point()
#ppg and salary
cor(data$ppg, data$salary)
ggplot(data, aes(ppg,salary)) +geom_point()
#FG and salary
cor(data$FG,data$salary)
ggplot(data,aes(FG,salary)) +geom_point()
#started more twos and threes
cor(data$started,data$two)
ggplot(data,aes(started,two)) +geom_point()
cor(data$started,data$three)
ggplot(data,aes(started,three)) +geom_point()
#more mins twos and threes 
cor(data$MinGames,data$three)
ggplot(data, aes(MinGames,three)) +geom_point()
data %>% filter(three >=5) #When stephen curry broke the 3 point record for 3's in a season 
cor(data$MinGames,data$two)
ggplot(data,aes(MinGames,two)) +geom_point()
#TO mins per game
cor(data$TO,data$MinGames)
ggplot(data, aes(TO, MinGames)) +geom_point()
#FG TO top scorers make more turnovers since they hold the ball more often 
cor(data$FG, data$TO)
ggplot(data, aes(FG, TO)) +geom_point()
#Player Year Team Salary
cor(data$PlayerYear, data$tmsalary)
ggplot(data, aes(PlayerYear, tmsalary)) +geom_point()
#PlusMinus TeamWins
cor(data$PlusMinus, data$TeamWins)
ggplot(data, aes(PlusMinus,TeamWins)) +geom_point()
#TeamSal and Salcap 
cor(data$tmsalary, data$SalCap)
ggplot(data,aes(SalCap, tmsalary)) + geom_point()

#player year and sal cap
cor(data$PlayerYear, data$SalCap)
data %>% ggplot(aes(PlayerYear, SalCap)) + geom_point()

data %>% ggplot(aes(PlayerYear, tmsalary)) + geom_point()  

data %>% ggplot(aes(PlayerYear)) +
  geom_smooth(aes(y= two_att), colour = "red") +
  geom_smooth(aes(y= three_att), colour = "green")
    
    
 ##---### Can you make a bar plot or a histogram?##--##
  
#boxplot
##Three point shots
ggplot(data, aes(x = cut(three, breaks = 5), y = salary)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Salary") +
  xlab("Threes Made")
##PPG
ggplot(data, aes(x = cut(ppg, breaks = 10), y = salary)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Salary") +
  xlab("ppg")
##EFG
ggplot(data, aes(x = cut(EFG, breaks = 5), y = salary)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Salary") +
  xlab("EFG")

##Total Rebounds
ggplot(data, aes(x = cut(t_reb, breaks = 5), y = salary)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Salary") +
  xlab("total rebounds")
## PlayerYear
ggplot(data, aes(x = cut(PlayerYear, breaks = 19), y = salary)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Salary") +
  xlab("Player Year")

##ALL NBA TEAM
data %>% 
  filter(nba1 =="YES" | nba2 =="YES"| nba3 == "YES") %>% 
  ggplot(aes(salary, fill =..x..)) +
  geom_histogram(col = "black", bins = 10) +
  scale_fill_gradient(low='blue', high='yellow') +
  labs(fill = "salary")+
  scale_x_continuous(breaks = round(seq(min(data$salary), max(data$salary), by = 5000000),1))
##All Defensive Team 
data %>% 
  filter(def1 =="YES" | def2 =="YES") %>% 
  ggplot(aes(salary, fill =..x..)) +
  geom_histogram(col = "black", bins = 10) +
  scale_fill_gradient(low='blue', high='yellow') +
  labs(fill = "salary")+
  scale_x_continuous(breaks = round(seq(min(data$salary), max(data$salary), by = 5000000),1))

data %>% 
  filter(def1 =="YES" | def2 =="YES") %>% 
  group_by(salary, PlayerYear) %>% 
  summarize(name = name[which.min(salary)])
#MVP
data %>% 
  filter(mvp =="YES") %>% 
  ggplot(aes(salary, fill =..x..)) +
  geom_histogram(col = "black", bins = 8) +
  scale_fill_gradient(low='blue', high='yellow') +
  labs(fill = "salary")+
  scale_x_continuous(breaks = round(seq(min(data$salary), max(data$salary), by = 5000000),1))
#DPOY
data %>% 
  filter(dpoy =="YES") %>% 
  ggplot(aes(salary, fill =..x..)) +
  geom_histogram(col = "black", bins = 8) +
  scale_fill_gradient(low='blue', high='yellow') +
  labs(fill = "salary")+
  scale_x_continuous(breaks = round(seq(min(data$salary), max(data$salary), by = 5000000),1))
#All Rookie Team
data %>% 
  filter(rook1 =="YES" | rook2 =="YES") %>% 
  ggplot(aes(salary, fill =..x..)) +
  geom_histogram(col = "black", bins = 8) +
  scale_fill_gradient(low='blue', high='yellow') +
  labs(fill = "salary")+
  scale_x_continuous(breaks = round(seq(min(data$salary), max(data$salary), by = 1000000),1))

#density plot
#three distribution
ggplot(data, aes(x = three)) + 
  geom_density(col = 'black', fill = 'red') 
#PlusMinus distribution
ggplot(data, aes(x = PlusMinus)) + 
  geom_density(col = 'black', fill = 'red') 
#Twos distribution
ggplot(data, aes(x = two)) + 
  geom_density(col = 'black', fill = 'red')
#salary
ggplot(data, aes(x = salary)) + 
  geom_density(col = 'black', fill = 'green')
#total rebounds
ggplot(data, aes(x = t_reb)) + 
  geom_density(col = 'black', fill = 'blue')
#points per game
ggplot(data, aes(x = ppg)) + 
  geom_density(col = 'black', fill = 'pink')
#EFG
ggplot(data, aes(x = EFG)) + 
  geom_density(col = 'black', fill = 'yellow')
#All rookie team 
data %>% filter(rook1 =="YES" | rook2 =="YES") %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'yellow')
#All NBA team
data %>% 
  filter(nba1 =="YES" | nba2 =="YES"| nba3 == "YES") %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'yellow')
#All Defense team
data %>% 
  filter(def1 =="YES" | def2 =="YES") %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'yellow')
#salary for internationals
data %>% 
  filter(country != "USA") %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'blue')
#salary for highschoolers 
data %>% 
  filter(country == "USA" & school == "None") %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'blue')
#salary for first round draft picks 
data %>% 
  filter(DraftNum == 1) %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'blue')
#salary for lottery picks 
data %>% 
  filter(DraftRound == 1) %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'blue')

data %>% 
  filter(DraftRound == 2) %>% 
  ggplot(aes(x = salary)) + 
  geom_density(col = 'black', fill = 'blue')
  


