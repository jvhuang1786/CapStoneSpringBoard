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




