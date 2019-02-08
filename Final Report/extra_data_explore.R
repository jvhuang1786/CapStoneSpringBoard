library(PerformanceAnalytics)
library(psych)
library(dplyr)
library(tidyr)

setwd("/users/justinvhuang/desktop/nba_stat_salaries")
data<-read.csv("2000_2018_nba.csv")
data<- data[,-1]

pairs.panels(data[c("salary", "three","three_att", "three_per")])

cor(data$salary,data$three)
cor(data$salary,data$three_att)
cor(data$salary,data$three_per)

morethan3<-data %>% filter(three >= 3)
mean<-mean(morethan3$salary)
max<-max(morethan3$salary)
min<-min(morethan3$salary)
median<-median(morethan3$salary)
stdev<- sd(morethan3$salary)
dfmean3 <-data.frame()
dfmean3 <- cbind(rbind(mean,max,min,median,stdev))
colnames(dfmean3)[1] <- "Salary"
morethan3 %>% ggplot(aes(PlayerYear,salary, color = ppg)) + geom_smooth() +
  ggtitle("More than Three 3's a game Yearly Salary Trend")
morethan2<-data %>% filter(three >= 2)
tallPlayers<-data %>% filter(height_cm >= 210)



tallPlayers %>% ggplot(aes(PlayerYear, three_att)) + 
  geom_smooth() +
  ggtitle("7ft 3 point attempt Trend")

tallPlayers %>% ggplot(aes(PlayerYear, weight_lb)) + 
  geom_smooth() + 
  ggtitle("7ft Weight Trend")

tallPlayers %>% ggplot(aes(x = cut(PlayerYear, breaks = 19), salary)) + geom_boxplot() +
  ggtitle("7ft Salary Trend through 19 Seasons")+ 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Salary") +
  xlab("Year")
mean(tallPlayers$salary)
min(tallPlayers$salary)
max(tallPlayers$salary)
tall2018<-tallPlayers %>% filter(PlayerYear == 2018) 

tallPlayers %>% ggplot(aes(ppg, salary, color = t_reb)) + 
  geom_point() +
  scale_color_gradient(low = "green", high = "red")


tall2018 %>% ggplot(aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(tall2018$name))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_y_continuous(breaks=c(0,5000000,10000000,15000000,20000000,25000000),limits =c(0,25000000)) + 
  ggtitle("2018 7fter Salary Spread")

tall2018 %>% arrange(desc(salary)) %>% head(n = 10) %>% select(name, salary, ppg, three, t_reb, block)


top15Big<-tallPlayers %>% 
  select(PlayerYear,name,salary,height_cm,weight_lb,ppg) %>% 
  arrange(desc(salary)) %>% 
  head(n= 15)
top15Big

foreign <- data %>% filter(country != "USA")
foreign %>% ggplot(aes(PlayerYear,salary)) +
  geom_bar(stat = "identity", fill = rainbow(n=length(foreign$name))) +
ggtitle("Foreign Salary over the years")

foreign %>% ggplot(aes(ppg, salary, color = t_reb)) + 
  geom_point() + 
  scale_color_gradient(low = "blue", high = "red")
foreign %>% filter(salary > 20000000 & ppg <= 15) %>%  select(name,salary, ppg, t_reb, PlayerYear)
foreign %>% filter(salary <20000000 & ppg >= 25) %>% select(name,salary, ppg, t_reb, PlayerYear)
foreign %>% name[which.max(salary)]
min(foreign$salary)
max(foreign$salary)
mean(foreign$salary)
median(foreign$salary)
foreign %>% ggplot(aes(salary)) +geom_density()
awardforeign <- foreign %>% filter(nba1 =="YES"|nba2=="YES"|nba3 =="YES"|def1=="YES"|def2=="YES"|mvp=="YES"|
                                     dpoy=="YES"|mip=="YES"|rook1 =="YES"|rook2=="YES")
awardforeign %>% select(PlayerYear,name, salary, ppg, assist, t_reb)
awardforeign %>% ggplot(aes(PlayerYear, salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(awardforeign$name))) +
  ggtitle("Award Foreign Salary Scale over the Years")

### NBA

allnba<-data %>% filter(nba1 =="YES"|nba2=="YES"|nba3=="YES") 

#allnba %>% ggplot(aes(PlayerYear, salary)) + geom_smooth()+
  #scale_color_gradient(low = "green", high = "red")

allnba %>% ggplot(aes(ppg, salary, color = assist, size =2)) + geom_point() +  
  scale_color_gradient(low = "green", high = "red")

#allnba %>% filter(ppg>= 30 & assist >=9)
alldef <- data %>% filter(def1 == "YES" | def2 == "YES") 

alldef %>% ggplot(aes(PlayerYear, salary)) + geom_smooth()
alldef %>% ggplot(aes(t_reb, salary, color = steal, size = 3)) + geom_point()+
  scale_color_gradient(low = "green", high = "red") 



winning %>% ggplot(aes(PlayerYear, salary)) + geom_smooth() + 
  ggtitle("Salary on Avg for Players on Winning Teams")

losing %>% ggplot(aes(PlayerYear, salary)) + geom_smooth() +
  ggtitle("Salary on Avg for Players on Losing Teams")

str(data)
lm.all <- lm(salary~PlayerYear + height_cm + weight_lb +
               PlusMinus + Age + Games + started +
               MinGames + FG + FG_att + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
               +assist + steal + block + TO + fouls + ppg + infl +
               FG_per +two_per + EFG + three_per + FT_per + TeamWins + NumYears + tmsalary +SalCap + overUnder
             , data = data)

#removed overunder and salcap 
summary(lm.all)
lm.all1 <- lm(salary~PlayerYear + height_cm + weight_lb +
               PlusMinus + Age + Games + started +
               MinGames + FG + FG_att + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
               +assist + steal + block + TO + fouls + ppg + infl +
               FG_per +two_per + EFG + three_per + FT_per + TeamWins + NumYears + tmsalary
             , data = data)
summary(lm.all1)

#Teamwins remove 

lm.all2 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames + FG + FG_att + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG + three_per + FT_per  + NumYears + tmsalary
              , data = data)
summary(lm.all2)
#remove ft per
lm.all3 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames + FG + FG_att + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG + three_per  + NumYears + tmsalary
              , data = data)
summary(lm.all3)
#remove three point per 
lm.all4 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames + FG + FG_att + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all4)
#remove FG
lm.all5 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames +  FG_att + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all5)
#remove FG ATT
lm.all6 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames + three + three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all6)
#remove three 
lm.all7 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames +  three_att +two + two_att + FT + FT_att + o_reb + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all7)

#remove o_reb
lm.all8 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames +  three_att +two + two_att + FT + FT_att + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg + infl +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all8)
#remove inflation
lm.all9 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames +  three_att +two + two_att + FT + FT_att + d_reb + t_reb +
                +assist + steal + block + TO + fouls + ppg  +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all9)

#remove ppg
lm.all10 <- lm(salary~PlayerYear + height_cm + weight_lb +
                PlusMinus + Age + Games + started +
                MinGames +  three_att +two + two_att + FT + FT_att + d_reb + t_reb +
                +assist + steal + block + TO + fouls +
                FG_per +two_per + EFG  + NumYears + tmsalary
              , data = data)
summary(lm.all10)

vif(lm.all10)
#remove two

lm.all11 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                 MinGames +  three_att +two_att + FT + FT_att + d_reb + t_reb +
                 +assist + steal + block + TO + fouls +
                 FG_per +two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all11)

vif(lm.all11)
#removeFT ATT
lm.all12 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                 MinGames +  three_att +two_att + FT + d_reb + t_reb +
                 +assist + steal + block + TO + fouls +
                 FG_per +two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all12)
vif(lm.all12)
# remove total rebounds
lm.all13 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                 MinGames +  three_att +two_att + FT + d_reb +
                 +assist + steal + block + TO + fouls +
                 FG_per +two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all13)
vif(lm.all13)
#remove fg_per
lm.all14 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                 MinGames +  three_att +two_att + FT + d_reb +
                 +assist + steal + block + TO + fouls +
               two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all14)
vif(lm.all14)
#remove min games

lm.all15 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                   three_att +two_att + FT + d_reb +
                 +assist + steal + block + TO + fouls +
                 two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all15)
vif(lm.all15)
#remove turnovers
lm.all16 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                 three_att +two_att + FT + d_reb +
                 +assist + steal + block + fouls +
                 two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all16)
vif(lm.all16)
#remove two_att
lm.all17 <- lm(salary~PlayerYear + height_cm + weight_lb +
                 PlusMinus + Age + Games + started +
                 three_att + FT + d_reb +
                 +assist + steal + block + fouls +
                 two_per + EFG  + NumYears + tmsalary
               , data = data)
summary(lm.all17)
vif(lm.all17)


cor(data[c("salary","PlayerYear", "height_cm", "weight_lb", "PlusMinus", "Age", "Games", "started",
           "three_att", "FT", "d_reb", "assist", "steal", "block", "fouls", "two_per",
           "EFG", "NumYears", "tmsalary")])

plot(lm.all17)
bptest(lm.all17)
#heteroskedastic 



winning <- data %>% filter(TeamWins >= 43)
losing <- data %>% filter(TeamWins <= 42)
mean<-mean(winning$salary)
max<-max(winning$salary)
min<-min(winning$salary)
median<-median(winning$salary)
stdev<- sd(winning$salary)
dfwinning <-data.frame()
dfwinning<- cbind(rbind(mean,max,min,median,stdev))
colnames(dfwinning)[1] <- "Salary Win"
mean<-mean(losing$salary)
max<-max(losing$salary)
min<-min(losing$salary)
median<-median(losing$salary)
stdev<- sd(losing$salary)
dflosing<-data.frame()
dflosing<- cbind(rbind(mean,max,min,median,stdev))
colnames(dflosing)[1] <- "Salary Lose"
cbind(dfwinning,dflosing)