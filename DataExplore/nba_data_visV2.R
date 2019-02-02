#Data visiualization 

##loading packages
library(dplyr)
library(ggplot2)
library(tidyr)
options(max.print = 999999999)

#loading in 2000 to 2018 data set for 19 seasons
df<-read.csv("data_2018_2000.csv")
str(df)
as.numeric(levels(df$DraftYear))[df$DraftYear]

df[7958,] #undrafted problem 

#want to change height to cm to calculate average joe data
df$height_ft<-gsub("7'6\"", 229, df$height_ft)
df$height_ft<-gsub("7'5\"", 226, df$height_ft)
df$height_ft<-gsub("7'4\"", 224, df$height_ft)
df$height_ft<-gsub("7'3\"", 221, df$height_ft)
df$height_ft<-gsub("7'2\"", 219, df$height_ft)
df$height_ft<-gsub("7'1\"", 216, df$height_ft)
df$height_ft<-gsub("7'0\"", 214, df$height_ft)
df$height_ft<-gsub("6'11\"", 211, df$height_ft)
df$height_ft<-gsub("6'10\"", 208, df$height_ft)
df$height_ft<-gsub("6'9\"", 206, df$height_ft)
df$height_ft<-gsub("6'8\"", 203, df$height_ft)
df$height_ft<-gsub("6'7\"", 201, df$height_ft)
df$height_ft<-gsub("6'6\"", 198, df$height_ft)
df$height_ft<-gsub("6'6", 198, df$height_ft)
df$height_ft<-gsub("6'5\"", 196, df$height_ft)
df$height_ft<-gsub("6'4\"", 193, df$height_ft)
df$height_ft<-gsub("6'3\"", 191, df$height_ft)
df$height_ft<-gsub("6'2\"", 188, df$height_ft)
df$height_ft<-gsub("6'1\"", 186, df$height_ft)
df$height_ft<-gsub("6'0\"", 183, df$height_ft)
df$height_ft<-gsub("5'11\"", 180, df$height_ft)
df$height_ft<-gsub("5'10\"", 178, df$height_ft)
df$height_ft<-gsub("5'9\"", 175, df$height_ft)
df$height_ft<-gsub("5'8\"", 173, df$height_ft)
df$height_ft<-gsub("5'7\"", 170, df$height_ft)
df$height_ft<-gsub("5'6\"", 168, df$height_ft)
df$height_ft<-gsub("5'5\"", 165, df$height_ft)
df$height_ft<-gsub("5'4\"", 163, df$height_ft)
df$height_ft<-gsub("5'3\"", 160, df$height_ft)
df <-df[,-c(1:2)]
colnames(df)[4] <- "height_cm"
str(df)
df$height_cm <- as.numeric(df$height_cm)
height_na<-which(is.na(df$height_cm))

df[height_na,c(1,4)]

df$height_cm[df$height_cm == 'Earl Boykins'] <- 165
df$height_cm[df$height_cm == 'Yao Ming'] <- 229
df$height_cm[df$height_cm == 'Shawn Bradley'] <- 229
df$height_cm[df$height_cm == 'Gheorghe Muresan'] <- 232
df$height_cm[df$height_cm == 'Rik Smits'] <- 224
df$height_cm[df$height_cm == 'Muggsy Bogues'] <- 160

df[c(3423,3857,4725,4947,5375,5780,6173,6634,7089,7515,7834),4] <-165
df[c(3966,4368,4777,5277,5719,6129,6520), 4] <- 229
df[c(5729,6141,6513,6877,7209,7629),4] <- 229
df[7709,4] <- 224
df[7800,4] <-232
df[7925,4] <- 160
df[7209,]
df[6520,]

which(is.na(df$height_cm))

#adding number of years for each played at the start of 2000 to 2018
year_count<-df %>% group_by(name) %>% tally()
colnames(year_count)[2] <- "NumYears"
df<-full_join(df, year_count, by = "name")
str(df)

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

#shows that it is significant however the r value is extremely low 



#look at 10 years need to be careful so only draft year from 2000 
ten_year<-df %>% group_by(name, DraftYear, ppg, PlayerYear) %>% 
  filter(NumYears == 10) %>% 
  summarize(salary = median(salary))

#plot it
ten_year %>% ggplot(aes(salary)) +geom_histogram() 
ten_year %>% ggplot(aes(ppg, salary)) + geom_smooth() #higher ppg the more the salary 
#one years
one_year<-df %>% group_by(name, DraftYear, ppg, PlayerYear) %>% 
  filter(NumYears == 1) %>% 
  summarize(salary = median(salary))

one_year %>% ggplot(aes(salary)) +geom_histogram() 
one_year %>% ggplot(aes(ppg, salary)) + geom_smooth() #interesting for one years that curve will decrease 

#3 years for the veteran minimum 

vet_min <-df %>% group_by(name, DraftYear, ppg, PlayerYear) %>% 
  filter(NumYears == 3) %>% 
  summarize(salary = median(salary))

vet_min %>%  
  ggplot(aes(salary)) +geom_histogram() 

vet_min %>% ggplot(aes(ppg, salary)) + geom_smooth()

#does paying the most in a year equate to more number of wins during the regular season 
gsw<-df %>%  group_by(name) %>% filter(PlayerYear == 2018 & team == "GSW") %>% summarize(salary =sum(salary), teamwins =median(TeamWins))
sum(gsw$salary)
#df <- df[,-c(1:2)]
#rownames(df) <- NULL
#write.csv(df, file ="2018_2000_nba.csv")
#filter, count , create new column, count value by player name 

#find mr average joe 
#2018 average joe find the average joe for each year then rbind them 
AvgJoe_18<-df %>% filter(PlayerYear == 2018) %>% summarize(name = "AvgJoe_2018",height = mean(height_cm), weight =mean(weight_lb),
                                                salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                three =mean(three), three_att = mean(three_att), three_per = mean(three/three_att),
                                                two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                ppg =mean(ppg))
AvgJoe_17<-df %>% filter(PlayerYear == 2017) %>% summarize(name = "AvgJoe_2017",height = mean(height_cm), weight =mean(weight_lb),
                                                               salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                               games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                               fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                               three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                               two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                               efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                               o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                               steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                               ppg =mean(ppg))
AvgJoe_16<-df %>% filter(PlayerYear == 2016) %>% summarize(name = "AvgJoe_2016",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_15<-df %>% filter(PlayerYear == 2015) %>% summarize(name = "AvgJoe_2015",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_14<-df %>% filter(PlayerYear == 2014) %>% summarize(name = "AvgJoe_2014",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two/two_att),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_13<-df %>% filter(PlayerYear == 2013) %>% summarize(name = "AvgJoe_2013",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_12<-df %>% filter(PlayerYear == 2012) %>% summarize(name = "AvgJoe_2012",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_11<-df %>% filter(PlayerYear == 2011) %>% summarize(name = "AvgJoe_2011",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_10<-df %>% filter(PlayerYear == 2010) %>% summarize(name = "AvgJoe_2010",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_09<-df %>% filter(PlayerYear == 2009) %>% summarize(name = "AvgJoe_2009",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_08<-df %>% filter(PlayerYear == 2008) %>% summarize(name = "AvgJoe_2008",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_07<-df %>% filter(PlayerYear == 2007) %>% summarize(name = "AvgJoe_2007",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_06<-df %>% filter(PlayerYear == 2006) %>% summarize(name = "AvgJoe_2006",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_05<-df %>% filter(PlayerYear == 2005) %>% summarize(name = "AvgJoe_2005",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_04<-df %>% filter(PlayerYear == 2004) %>% summarize(name = "AvgJoe_2004",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_03<-df %>% filter(PlayerYear == 2003) %>% summarize(name = "AvgJoe_2003",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_02<-df %>% filter(PlayerYear == 2002) %>% summarize(name = "AvgJoe_2002",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_01<-df %>% filter(PlayerYear == 2001) %>% summarize(name = "AvgJoe_2001",height = mean(height_cm), weight =mean(weight_lb),
                                                           salary = mean(salary/((100+infl)/100)), plusMinus =mean(PlusMinus), age =mean(Age),
                                                           games = mean(Games), start = mean(started), mins =mean(MinGames),
                                                           fg=mean(FG), fg_att =mean(FG_att), fg_per =mean(FG_per),
                                                           three =mean(three), three_att = mean(three_att), three_per =mean(three/three_att),
                                                           two = mean(two), two_att=mean(two_att), two_per =mean(two_per),
                                                           efg=mean(EFG), ft=mean(FT), ft_att =mean(FT_att), ft_per = mean(ft/ft_att),
                                                           o_reb =mean(o_reb), d_reb =mean(d_reb), t_reb =mean(t_reb), assist =mean(assist),
                                                           steal =mean(steal), block =mean(block), TO =mean(TO), fouls=mean(fouls),
                                                           ppg =mean(ppg))
AvgJoe_00<-df %>% filter(PlayerYear == 2000) %>% summarize(name = "AvgJoe_2000",height = mean(height_cm), weight =mean(weight_lb),
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

ggplot(AvgJoe, aes(ppg, salary)) + geom_line() #number of points seems to dip after a bit maybe inefficient scoring 
ggplot(AvgJoe, aes(efg, salary)) + geom_line() # more of a relation between efg than ppg
options(scipen=12)
ggplot(AvgJoe, aes(name, salary, color = efg)) + geom_jitter() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_colour_gradient(low = "red",high = "green")

#lets see the max player, mvp, dpoy and min player compare to avgjoe 
max_2018 <- subset(df, PlayerYear==2018 & salary == max(salary),
                  select=name:TeamWins)
max_2017 <- df %>% filter(PlayerYear == 2017) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2016 <- df %>% filter(PlayerYear == 2016) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2015 <- df %>% filter(PlayerYear == 2015) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2014 <- df %>% filter(PlayerYear == 2014) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2013 <- df %>% filter(PlayerYear == 2013) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2012 <- df %>% filter(PlayerYear == 2012) %>% subset(salary == max(salary),
                                                        select= name:TeamWins)
max_2011 <- df %>% filter(PlayerYear == 2011) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2010 <- df %>% filter(PlayerYear == 2010) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2009 <-df %>% filter(PlayerYear == 2009) %>% subset(salary == max(salary),
                                                        select= name:TeamWins)
max_2008 <- df %>% filter(PlayerYear == 2008) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2007 <- df %>% filter(PlayerYear == 2007) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2006 <- df %>% filter(PlayerYear == 2006) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2005 <- df %>% filter(PlayerYear == 2005) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2004 <- df %>% filter(PlayerYear == 2004) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2003 <- df %>% filter(PlayerYear == 2003) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2002 <- df %>% filter(PlayerYear == 2002) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2001 <- df %>% filter(PlayerYear == 2001) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
max_2000 <- df %>% filter(PlayerYear == 2000) %>% subset(salary == max(salary),
                                                         select= name:TeamWins)
mr_max <-rbind(max_2018, max_2017, max_2016, max_2015, max_2014, max_2013,
               max_2012, max_2011, max_2010, max_2009, max_2008, max_2007,
               max_2006, max_2005, max_2004, max_2003, max_2002, max_2001, max_2000)

ggplot(mr_max, aes(PlayerYear, salary, color = EFG)) + geom_jitter() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_colour_gradient(low = "red",high = "green")

#MVP 
mvp_2018 <- df %>% filter(PlayerYear == 2018) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2017 <- df %>% filter(PlayerYear == 2017) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2016 <- df %>% filter(PlayerYear == 2016) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2015 <- df %>% filter(PlayerYear == 2015) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2014 <- df %>% filter(PlayerYear == 2014) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2013 <- df %>% filter(PlayerYear == 2013) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2012 <- df %>% filter(PlayerYear == 2012) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2011 <- df %>% filter(PlayerYear == 2011) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2010 <- df %>% filter(PlayerYear == 2010) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2009 <-df %>% filter(PlayerYear == 2009) %>% subset(mvp == "YES",
                                                        select= name:TeamWins)
mvp_2008 <- df %>% filter(PlayerYear == 2008) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2007 <- df %>% filter(PlayerYear == 2007) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2006 <- df %>% filter(PlayerYear == 2006) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2005 <- df %>% filter(PlayerYear == 2005) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2004 <- df %>% filter(PlayerYear == 2004) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2003 <- df %>% filter(PlayerYear == 2003) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2002 <- df %>% filter(PlayerYear == 2002) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mvp_2001 <- df %>% filter(PlayerYear == 2001) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
df[7165,]
df[7165,"mvp"] <- "YES"
mvp_2000 <- df %>% filter(PlayerYear == 2000) %>% subset(mvp == "YES",
                                                         select= name:TeamWins)
mr_mvp <-rbind(mvp_2018, mvp_2017, mvp_2016, mvp_2015, mvp_2014, mvp_2013,
               mvp_2012, mvp_2011, mvp_2010, mvp_2009, mvp_2008, mvp_2007,
               mvp_2006, mvp_2005, mvp_2004, mvp_2003, mvp_2002, mvp_2001, mvp_2000)
ggplot(mr_mvp, aes(PlayerYear, salary, color = EFG)) + geom_jitter() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_colour_gradient(low = "red",high = "green")

#dpoy 
dpoy_2018 <- df %>% filter(PlayerYear == 2018) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2017 <- df %>% filter(PlayerYear == 2017) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2016 <- df %>% filter(PlayerYear == 2016) %>% subset(dpoy== "YES",
                                                         select= name:TeamWins)
dpoy_2015 <- df %>% filter(PlayerYear == 2015) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2014 <- df %>% filter(PlayerYear == 2014) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2013 <- df %>% filter(PlayerYear == 2013) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2012 <- df %>% filter(PlayerYear == 2012) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2011 <- df %>% filter(PlayerYear == 2011) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2010 <- df %>% filter(PlayerYear == 2010) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2009 <-df %>% filter(PlayerYear == 2009) %>% subset(dpoy == "YES",
                                                        select= name:TeamWins)
dpoy_2008 <- df %>% filter(PlayerYear == 2008) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2007 <- df %>% filter(PlayerYear == 2007) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2006 <- df %>% filter(PlayerYear == 2006) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2005 <- df %>% filter(PlayerYear == 2005) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2004 <- df %>% filter(PlayerYear == 2004) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2003 <- df %>% filter(PlayerYear == 2003) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2002 <- df %>% filter(PlayerYear == 2002) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)
dpoy_2001 <- df %>% filter(PlayerYear == 2001) %>% subset(dpoy == "YES",
                                                         select= name:TeamWins)

dpoy_2000 <- df %>% filter(PlayerYear == 2000) %>% subset(dpoy== "YES",
                                                         select= name:TeamWins)
mr_dpoy <-rbind(dpoy_2018, dpoy_2017, dpoy_2016, dpoy_2015, dpoy_2014, dpoy_2013,
                dpoy_2012, dpoy_2011, dpoy_2010, dpoy_2009, dpoy_2008, dpoy_2007,
                dpoy_2006, dpoy_2005, dpoy_2004, dpoy_2003, dpoy_2002, dpoy_2001, dpoy_2000)
ggplot(mr_dpoy, aes(PlayerYear, salary, color = EFG)) + geom_jitter() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_colour_gradient(low = "red",high = "green")
#the min player
min_2018 <- subset(df, PlayerYear==2018 & salary == min(salary),
                   select=name:TeamWins)
min_2017 <- df %>% filter(PlayerYear == 2017) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2016 <- df %>% filter(PlayerYear == 2016) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2015 <- df %>% filter(PlayerYear == 2015) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2014 <- df %>% filter(PlayerYear == 2014) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2013 <- df %>% filter(PlayerYear == 2013) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2012 <- df %>% filter(PlayerYear == 2012) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2011 <- df %>% filter(PlayerYear == 2011) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2010 <- df %>% filter(PlayerYear == 2010) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2009 <-df %>% filter(PlayerYear == 2009) %>% subset(salary == min(salary),
                                                        select= name:TeamWins)
min_2008 <- df %>% filter(PlayerYear == 2008) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2007 <- df %>% filter(PlayerYear == 2007) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2006 <- df %>% filter(PlayerYear == 2006) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2005 <- df %>% filter(PlayerYear == 2005) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2004 <- df %>% filter(PlayerYear == 2004) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2003 <- df %>% filter(PlayerYear == 2003) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2002 <- df %>% filter(PlayerYear == 2002) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2001 <- df %>% filter(PlayerYear == 2001) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
min_2000 <- df %>% filter(PlayerYear == 2000) %>% subset(salary == min(salary),
                                                         select= name:TeamWins)
mr_min <-rbind(min_2018, min_2017, min_2016, min_2015, min_2014, min_2013,
               min_2012, min_2011, min_2010, min_2009, min_2008, min_2007,
               min_2006, min_2005, min_2004, min_2003, min_2002, min_2001, min_2000)

ggplot(mr_min, aes(PlayerYear, salary, color = EFG)) + geom_jitter() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_colour_gradient(low = "red",high = "green")

#load in team salary want to see how much each player salary takes from total team salary 
#see if they are worth it. #2004 changed to 30 teams 
tmSal_18<-read.csv("hoops_hype_salaryt_2018.csv",header = F)
tmSal_18 <- tmSal_18[-c(1:2),-c(1:2,5)]
tmSal_18["PlayerYear"] <- 2018 
colnames(tmSal_18)[1:2]<- c("team","tmsalary")
rownames(tmSal_18) <- NULL 
tmSal_17<-read.csv("hoops_hype_salaryt_2017.csv",header = F)
tmSal_17 <- tmSal_17[-c(1:2),-c(1:2,5)]
tmSal_17["PlayerYear"] <- 2017 
colnames(tmSal_17)[1:2]<- c("team","tmsalary")
rownames(tmSal_17) <- NULL 
tmSal_16<-read.csv("hoops_hype_salaryt_2016.csv",header = F)
tmSal_16 <- tmSal_16[-c(1:2),-c(1:2,5)]
tmSal_16["PlayerYear"] <- 2016 
colnames(tmSal_16)[1:2]<- c("team","tmsalary")
rownames(tmSal_16) <- NULL 
tmSal_15<-read.csv("hoops_hype_salaryt_2015.csv",header = F)
tmSal_15 <- tmSal_15[-c(1:2),-c(1:2,5)]
tmSal_15["PlayerYear"] <- 2015 
colnames(tmSal_15)[1:2]<- c("team","tmsalary")
rownames(tmSal_15) <- NULL 
tmSal_14<-read.csv("hoops_hype_salaryt_2014.csv",header = F)
tmSal_14 <- tmSal_14[-c(1:2),-c(1:2,5)]
tmSal_14["PlayerYear"] <- 2014 
colnames(tmSal_14)[1:2]<- c("team","tmsalary")
rownames(tmSal_14) <- NULL 
tmSal_13<-read.csv("hoops_hype_salaryt_2013.csv",header = F)
tmSal_13 <- tmSal_13[-c(1:2),-c(1:2,5)]
tmSal_13["PlayerYear"] <- 2013 
colnames(tmSal_13)[1:2]<- c("team","tmsalary")
rownames(tmSal_13) <- NULL 
tmSal_12<-read.csv("hoops_hype_salaryt_2012.csv",header = F)
tmSal_12 <- tmSal_12[-c(1:2),-c(1:2,5)]
tmSal_12["PlayerYear"] <- 2012 
colnames(tmSal_12)[1:2]<- c("team","tmsalary")
rownames(tmSal_12) <- NULL 
tmSal_11<-read.csv("hoops_hype_salaryt_2011.csv",header = F)
tmSal_11 <- tmSal_11[-c(1:2),-c(1:2,5)]
tmSal_11["PlayerYear"] <- 2011 
colnames(tmSal_11)[1:2]<- c("team","tmsalary")
rownames(tmSal_11) <- NULL 
tmSal_10<-read.csv("hoops_hype_salaryt_2010.csv",header = F)
tmSal_10 <- tmSal_10[-c(1:2),-c(1:2,5)]
tmSal_10["PlayerYear"] <- 2010 
colnames(tmSal_10)[1:2]<- c("team","tmsalary")
rownames(tmSal_10) <- NULL 
tmSal_09<-read.csv("hoops_hype_salaryt_2009.csv",header = F)
tmSal_09 <- tmSal_09[-c(1:2),-c(1:2,5)]
tmSal_09["PlayerYear"] <- 2009 
colnames(tmSal_09)[1:2]<- c("team","tmsalary")
rownames(tmSal_09) <- NULL 
tmSal_08<-read.csv("hoops_hype_salaryt_2008.csv",header = F)
tmSal_08 <- tmSal_08[-c(1:2),-c(1:2,5)]
tmSal_08["PlayerYear"] <- 2008 
colnames(tmSal_08)[1:2]<- c("team","tmsalary")
rownames(tmSal_08) <- NULL 
tmSal_07<-read.csv("hoops_hype_salaryt_2007.csv",header = F)
tmSal_07 <- tmSal_07[-c(1:2),-c(1:2,5)]
tmSal_07["PlayerYear"] <- 2007 
colnames(tmSal_07)[1:2]<- c("team","tmsalary")
rownames(tmSal_07) <- NULL 
tmSal_06<-read.csv("hoops_hype_salaryt_2006.csv",header = F)
tmSal_06 <- tmSal_06[-c(1:2),-c(1:2,5)]
tmSal_06["PlayerYear"] <- 2006 
colnames(tmSal_06)[1:2]<- c("team","tmsalary")
rownames(tmSal_06) <- NULL 
tmSal_05<-read.csv("hoops_hype_salaryt_2005.csv",header = F)
tmSal_05 <- tmSal_05[-c(1:2),-c(1:2,5)]
tmSal_05["PlayerYear"] <- 2005 
colnames(tmSal_05)[1:2]<- c("team","tmsalary")
rownames(tmSal_05) <- NULL 
tmSal_04<-read.csv("hoops_hype_salaryt_2004.csv",header = F)
tmSal_04 <- tmSal_04[-c(1:2),-c(1:2,5)]
tmSal_04["PlayerYear"] <- 2004 
colnames(tmSal_04)[1:2]<- c("team","tmsalary")
rownames(tmSal_04) <- NULL 
tmSal_03<-read.csv("hoops_hype_salaryt_2003.csv",header = F)
tmSal_03 <- tmSal_03[-c(1:2),-c(1:2,5)]
tmSal_03["PlayerYear"] <- 2003 
colnames(tmSal_03)[1:2]<- c("team","tmsalary")
rownames(tmSal_03) <- NULL 
tmSal_02<-read.csv("hoops_hype_salaryt_2002.csv",header = F)
tmSal_02 <- tmSal_02[-c(1:2),-c(1:2,5)]
tmSal_02["PlayerYear"] <- 2002 
colnames(tmSal_02)[1:2]<- c("team","tmsalary")
rownames(tmSal_02) <- NULL 
tmSal_01<-read.csv("hoops_hype_salaryt_2001.csv",header = F)
tmSal_01 <- tmSal_01[-c(1:2),-c(1:2,5)]
tmSal_01["PlayerYear"] <- 2001 
colnames(tmSal_01)[1:2]<- c("team","tmsalary")
rownames(tmSal_01) <- NULL 
tmSal_00<-read.csv("hoops_hype_salaryt_2000.csv",header = F)
tmSal_00 <- tmSal_00[-c(1),]
colnames(tmSal_00)[1:2]<- c("team","tmsalary")
tmSal_00["PlayerYear"] <- 2000 
colnames(tmSal_00)[1:2]<- c("team","tmsalary")
rownames(tmSal_00) <- NULL 
tmSal <- rbind(tmSal_00,tmSal_01, tmSal_02, tmSal_03, tmSal_04, tmSal_05,
               tmSal_06, tmSal_07, tmSal_08, tmSal_09, tmSal_10,
               tmSal_11, tmSal_12, tmSal_13, tmSal_14, tmSal_15,
               tmSal_16, tmSal_17, tmSal_18)

tmSal$team<-gsub("Portland Trailblazers", "POR", tmSal$team)
tmSal$team<-gsub("Portland", "POR", tmSal$team)
tmSal$team<-gsub("New York Knicks", "NYK", tmSal$team)
tmSal$team<-gsub("New York", "NYK", tmSal$team)
tmSal$team<-gsub("Indiana Pacers", "IND", tmSal$team)
tmSal$team<-gsub("Indiana", "IND", tmSal$team)
tmSal$team<-gsub("Los Angeles Lakers", "LAL", tmSal$team)
tmSal$team<-gsub("LA Lakers", "LAL", tmSal$team)
tmSal$team<-gsub("New Jersey Nets", "BRK", tmSal$team)
tmSal$team<-gsub("Brooklyn", "BRK", tmSal$team)
tmSal$team<-gsub("Washington Wizards", "WAS", tmSal$team)
tmSal$team<-gsub("Washington", "WAS", tmSal$team)
tmSal$team<-gsub("Houston Rockets", "HOU", tmSal$team)
tmSal$team<-gsub("Houston", "HOU", tmSal$team)
tmSal$team<-gsub("Miami Heat", "MIA", tmSal$team)
tmSal$team<-gsub("Miami", "MIA", tmSal$team)
tmSal$team<-gsub("Utah Jazz", "UTA", tmSal$team)
tmSal$team<-gsub("Utah", "UTA", tmSal$team)
tmSal$team<-gsub("Cleveland Cavaliers", "CLE", tmSal$team)
tmSal$team<-gsub("Cleveland", "CLE", tmSal$team)
tmSal$team<-gsub("Phoenix Suns", "PHO", tmSal$team)
tmSal$team<-gsub("Phoenix", "PHO", tmSal$team)
tmSal$team<-gsub("Boston Celtics", "BOS", tmSal$team)
tmSal$team<-gsub("Boston", "BOS", tmSal$team)
tmSal$team<-gsub("Milwaukee Bucks", "MIL", tmSal$team)
tmSal$team<-gsub("Milwaukee", "MIL", tmSal$team)
tmSal$team<-gsub("Denver Nuggets", "DEN", tmSal$team)
tmSal$team<-gsub("Denver", "DEN", tmSal$team)
tmSal$team<-gsub("Atlanta Hawks", "ATL", tmSal$team)
tmSal$team<-gsub("Atlanta", "ATL", tmSal$team)
tmSal$team<-gsub("San Antonio Spurs", "SAS", tmSal$team)
tmSal$team<-gsub("San Antonio", "SAS", tmSal$team)
tmSal$team<-gsub("Philadelphia 76ers", "PHI", tmSal$team)
tmSal$team<-gsub("Philadelphia", "PHI", tmSal$team)
tmSal$team<-gsub("Minnesota Timberwolves", "MIN", tmSal$team)
tmSal$team<-gsub("Minnesota", "MIN", tmSal$team)
tmSal$team<-gsub("Detroit Pistons", "DET", tmSal$team)
tmSal$team<-gsub("Detroit", "DET", tmSal$team)
tmSal$team<-gsub("Orlando Magic", "ORL", tmSal$team)
tmSal$team<-gsub("Orlando", "ORL", tmSal$team)
tmSal$team<-gsub("Sacramento Kings", "SAC", tmSal$team)
tmSal$team<-gsub("Sacramento", "SAC", tmSal$team)
tmSal$team<-gsub("Dallas Mavericks", "DAL", tmSal$team)
tmSal$team<-gsub("Dallas", "DAL", tmSal$team)
tmSal$team<-gsub("Golden State Warriors", "GSW", tmSal$team)
tmSal$team<-gsub("Golden State", "GSW", tmSal$team)
tmSal$team<-gsub("Toronto Raptors", "TOR", tmSal$team)
tmSal$team<-gsub("Toronto", "TOR", tmSal$team)
tmSal$team<-gsub("Chicago Bulls", "CHI", tmSal$team)
tmSal$team<-gsub("Chicago", "CHI", tmSal$team)
tmSal$team<-gsub("Los Angeles Clipper", "LAC", tmSal$team)
tmSal$team<-gsub("Los Angeles", "LAC", tmSal$team)
tmSal$team<-gsub("LACs", "LAC", tmSal$team)

tmSal$team<-gsub("LA Clippers", "LAC", tmSal$team)
tmSal$team<-gsub("Vancouver Grizzlies", "MEM", tmSal$team)
tmSal$team<-gsub("Memphis", "MEM", tmSal$team)
tmSal$team<-gsub("Seattle Sonics", "OKC", tmSal$team)
tmSal$team<-gsub("Oklahoma City", "OKC", tmSal$team)
tmSal$team<-gsub("Charlotte Hornets", "CHO", tmSal$team)
tmSal$team<-gsub("Charlotte", "CHO", tmSal$team)
tmSal$team<-gsub("New Orleans", "NOP", tmSal$team)


#joining df with tmSal
#data<-merge(df, tmSal, by=c("team","PlayerYear"))
#write.csv(data,file ="2018_2000_data.csv")
data<-merge(df, tmSal, by=c("team","PlayerYear"))
str(df)
data<-df[,-55]
View(data)

#now to compare how much each player takes up their teams salary and see if they are worth it. 
#compare the max and min player to avg joe 

#compare mvp and dpoy to avg joe 