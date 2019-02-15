setwd("/users/justinvhuang/desktop/nba_stat_salaries")
data<-read.csv("2000_2018_nba.csv")
data<- data[,-1]
library(dplyr)
library(ggplot2)

data %>% filter(three >= 1 & t_reb >= 7 & ppg >= 15 & block >=1 & height_cm >= 208 & three_per >= 0.35) %>% 
  select(name, PlayerYear, t_reb, three, ppg, block, salary, Games) %>% head(n = 30)

mean(data$three_per, na.rm=TRUE)

data %>% filter(name == "Anthony Davis")

data %>% filter(def1 == "YES"|def2 =="YES") %>% filter(ppg <= 10 & steal <= 1 & t_reb <= 5) %>% 
  select(name, PlayerYear, salary, ppg, block, t_reb, steal)

hou2018<-data %>% filter(team == "HOU" & PlayerYear == 2018)

hou2018 %>% ggplot(aes(name,salary)) + 
  geom_bar(stat = "identity", fill = rainbow(n=length(hou2018$name))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("2018 Houston Rocket Salary Spread")


  