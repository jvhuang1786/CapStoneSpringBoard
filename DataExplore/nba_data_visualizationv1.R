#Data visiualization 

##loading packages
library(dplyr)
library(ggplot2)
library(tidyr)
options(max.print = 999999999)

#loading in 2000 to 2018 data set for 19 seasons
df<-read.csv("data_2018_2000.csv")

rownames(df) <- NULL

#finding outliers this was an entry mistake 
which(df$ppg > 40 )

df[7162,16:35] <- c(77,76,28.7,4.0,8.9,1.5,3.2,
                    2.5,5.7,2.1,2.4,0.6,1.9,2.5,	
                    2.0,0.7,0.2,1.4,2.1,11.6)
df[7162,]

##changing PlayerYear to factor 

str(df)
df[,"PlayerYear"] <- factor(df[, "PlayerYear"])

#checking team names 
unique(df$team)
grepl("PHX", df$team)
grepl("PHO", df$team)
which(df$team == "PHO")
df$team <- gsub("PHX", "PHO", df$team)


#vancouver grizzlies were 2000 and 2001, 
df$team <- gsub("VAN", "MEM", df$team)
#Sonics was from 2008 to 2018, 
df$team <-gsub("SEA", "OKC", df$team)
#Nets moved to brooklyn in 2011
df$team <-gsub("NJN", "BRK", df$team)
df$team <-gsub("BKN", "BRK", df$team)
#Charlotte hornets 2000- 2002 then became the bobcats and got name back to be hornets again in 2014
which(df$team == "CHH") #charlote hornets
df[6817,]
df$team <-gsub("CHA", "CHO", df$team)
df$team <-gsub("CHH", "CHO", df$team)
#New Orlean Pelicans 
which(df$team == "NOK")
df[4790,] # is the hornets for new orleans 

df$team <-gsub("NOH", "NOP", df$team)
df$team <-gsub("NOK", "NOP", df$team)
unique(df$team)
#loading in team wins
teamwins<-read.csv("team_wins.csv")
teamwins<-teamwins[,-2]
colnames(teamwins)[1:20] <- c("team", 2018,2017,2016, 2015, 2014,
                              2013, 2012, 2011, 2010, 2009, 2008,
                              2007, 2006, 2005, 2004, 2003, 2002,
                              2001, 2000)
t_18<-df %>% filter(PlayerYear == "2018")
w_18<-teamwins[,1:2]
s_18<-full_join(t_18,w_18, by = "team")
colnames(s_18)[54] <- "TeamWins" 
t_17<-df %>% filter(PlayerYear == "2017")
w_17<-teamwins[,c(1,3)]
s_17<-full_join(t_17,w_17, by = "team")
colnames(s_17)[54] <- "TeamWins" 
t_16<-df %>% filter(PlayerYear == "2016")
w_16<-teamwins[,c(1,4)]
s_16<-full_join(t_16,w_16, by = "team")
colnames(s_16)[54] <- "TeamWins" 
t_15<-df %>% filter(PlayerYear == "2015")
w_15<-teamwins[,c(1,5)]
s_15<-full_join(t_15,w_15, by = "team")
colnames(s_15)[54] <- "TeamWins" 
t_14<-df %>% filter(PlayerYear == "2014")
w_14<-teamwins[,c(1,6)]
s_14<-full_join(t_14,w_14, by = "team")
colnames(s_14)[54] <- "TeamWins" 
t_13<-df %>% filter(PlayerYear == "2013")
w_13<-teamwins[,c(1,7)]
s_13<-full_join(t_13,w_13, by = "team")
colnames(s_13)[54] <- "TeamWins" 
t_12<-df %>% filter(PlayerYear == "2012")
w_12<-teamwins[,c(1,8)]
s_12<-full_join(t_12,w_12, by = "team")
colnames(s_12)[54] <- "TeamWins" 
t_11<-df %>% filter(PlayerYear == "2011")
w_11<-teamwins[,c(1,9)]
s_11<-full_join(t_11,w_11, by = "team")
colnames(s_11)[54] <- "TeamWins" 
t_10<-df %>% filter(PlayerYear == "2010")
w_10<-teamwins[,c(1,10)]
s_10<-full_join(t_10,w_10, by = "team")
colnames(s_10)[54] <- "TeamWins" 
t_09<-df %>% filter(PlayerYear == "2009")
w_09<-teamwins[,c(1,11)]
s_09<-full_join(t_09,w_09, by = "team")
colnames(s_09)[54] <- "TeamWins" 
t_08<-df %>% filter(PlayerYear == "2008")
w_08<-teamwins[,c(1,12)]
s_08<-full_join(t_08,w_08, by = "team")
colnames(s_08)[54] <- "TeamWins" 
t_07<-df %>% filter(PlayerYear == "2007")
w_07<-teamwins[,c(1,13)]
s_07<-full_join(t_07,w_07, by = "team")
colnames(s_07)[54] <- "TeamWins"
t_06<-df %>% filter(PlayerYear == "2006")
w_06<-teamwins[,c(1,14)]
s_06<-full_join(t_06,w_06, by = "team")
colnames(s_06)[54] <- "TeamWins"
t_05<-df %>% filter(PlayerYear == "2005")
w_05<-teamwins[,c(1,15)]
s_05<-full_join(t_05,w_05, by = "team")
colnames(s_05)[54] <- "TeamWins"
t_04<-df %>% filter(PlayerYear == "2004")
w_04<-teamwins[,c(1,16)]
s_04<-full_join(t_04,w_04, by = "team")
colnames(s_04)[54] <- "TeamWins"
t_03<-df %>% filter(PlayerYear == "2003")
w_03<-teamwins[,c(1,17)]
s_03<-full_join(t_03,w_03, by = "team")
colnames(s_03)[54] <- "TeamWins"
t_02<-df %>% filter(PlayerYear == "2002")
w_02<-teamwins[,c(1,18)]
s_02<-full_join(t_02,w_02, by = "team")
colnames(s_02)[54] <- "TeamWins"
t_01<-df %>% filter(PlayerYear == "2001")
w_01<-teamwins[,c(1,19)]
s_01<-full_join(t_01,w_01, by = "team")
colnames(s_01)[54] <- "TeamWins"
t_00<-df %>% filter(PlayerYear == "2000")
w_00<-teamwins[,c(1,20)]
s_00<-full_join(t_00,w_00, by = "team")
colnames(s_00)[54] <- "TeamWins"
data<- rbind(s_18,s_17,s_16,s_15,s_14,s_13,s_12,s_11,s_10,s_09,s_08,s_07,s_06,s_05,s_04,s_03,s_02,s_01,s_00)

a<-which(is.na(data$name))
data<- data[-a,]
which(is.na(data$name))

rownames(data) <- NULL 
write.csv(data, file = "data_2018_2000.csv")
#initial data exploration see number of countries 

unique(df$country)

#look at the mean,min, max and median pay for each country
country<-df %>% group_by(country) %>% summarize(mean(salary), median(salary), max(salary), min(salary))


#plot it 

df %>%
  ggplot(aes(x = country, y = salary)) +
  geom_boxplot()
# look at mean,min max and median for each year
year<-df %>% group_by(PlayerYear) %>% summarize(mean(salary), median(salary), max(salary), min(salary))

#plot it 
df %>% 
  ggplot(aes(salary)) +
  geom_histogram() + 
  facet_wrap(~PlayerYear)

# Compute stats for salary
df %>%
  summarize(median(salary),
            IQR(salary))

#look at the max salary for each year and how it changed over the years 

# Density plot of salary 
df %>%
  ggplot(aes(x = salary)) +
  geom_density()

#salary seems to be right skewed. 

# Transform the skewed salary variable
df <- df %>%
  mutate(log_salary = log(salary))

# Density plot of new variable
df %>%
  ggplot(aes(x = salary)) +
  geom_density()

#see the amount of 2 point shots vs 3 point shots over the years 

df %>% group_by(PlayerYear) %>% summarize(mean(two_att), mean(three_att), 
                                          mean(two), mean(three))
# number of 3point attempts have been increasing while number of 2 point attempts have been decreasing.

#plot it 

ggplot(df, aes(x =PlayerYear, y = two_att)) + geom_smooth()
ggplot(df, aes(x = PlayerYear, y = three_att)) + geom_smooth()

#confirms a rise of 3 point shots vs two point shots among players, will teams award 3 point shooting more now

#what is the mean salary for players who took more than 3 threes a game
df %>%  group_by(PlayerYear) %>% filter(three_att >= 3) %>% summarize(mean(salary), median(salary),
                                                          max(salary), min(salary))

# now less than three threes a game
df %>%  group_by(PlayerYear) %>% filter(three_att < 3) %>% summarize(mean(salary), median(salary),
                                                                      max(salary), min(salary))
#seems like attemping more threes is beneificial here 


#for the two point shot mean salary
df %>% group_by(two,two_att,two_per) %>% summarize(mean(salary), median(salary),
                                                   max(salary), min(salary))
#ppg and salary
ggplot(df, aes(x= PlayerYear, y = ppg, colour = salary)) + geom_jitter()

#MVP and salary
df %>% group_by(PlayerYear) %>% filter(mvp == "YES") %>% summarize(salary)
  
df %>% filter(mvp == "YES") %>% ggplot(aes(PlayerYear,salary)) + geom_line()

#did people who win mvp have a salary increase
df %>% group_by(name, salary) %>%  filter(mvp == "YES") 

#Tim Duncan salary
df %>% group_by(PlayerYear) %>%  filter(name == "Tim Duncan") %>% summarize(salary)

df %>% filter(name == "Tim Duncan") %>% ggplot(aes(PlayerYear, salary)) + geom_smooth()

#comparing top ppg scorers for salary

df %>%  filter(ppg >= 25) %>%  ggplot(aes(PlayerYear, salary, color = mvp)) + geom_jitter()
df %>%  filter(ppg >= 28) %>%  ggplot(aes(PlayerYear, salary, color = mvp)) + geom_jitter()
#looks as if MVP wasn't always the highest paid in those years 

#look at the the linear relationship between ppg and salary
ppg_salary <- lm(salary ~ ppg, df)
summary(ppg_salary)

#shows that it is significant 
#look at data for players that just played 10 years


#filter, count , create new column, count value by player name 

