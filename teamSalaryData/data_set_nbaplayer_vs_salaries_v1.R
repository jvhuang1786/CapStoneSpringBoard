#loading the data packages 
library(dplyr)
library(tidyr)
library(purrr)

#seeing what directory I am in
getwd()

#setting the directory 

setwd("/users/justinvhuang/desktop/nba_stat_salaries")
getwd()

#Awards Section
# Need to clean up the awards section to only get the years I need.  2000 - 2019 Season 20 years of data. # can load the data better.  
#use simple functions list.files <- can use lapply funciton.  
##Loading in the data
sixth_man <- read.csv("sixth.csv")
rookie_1_team <- read.csv("rookie1.csv")
rookie_2_team <- read.csv("rookie2.csv")
rookie_of_year <- read.csv("rookie.csv")
nba_1_team <- read.csv("nba1.csv")
nba_2_team <- read.csv("nba2.csv")
nba_3_team <- read.csv("nba3.csv")
mvp <- read.csv("mvp.csv")
mip <- read.csv("MIP.csv")
defense_1 <- read.csv("defense1.csv")
defense_2 <- read.csv("defense2.csv")
def_player <- read.csv("def_player.csv")

#cleaning up sixth man of the year data

#removing unecssary rows only need 2000-2019
sixth_man <- sixth_man[-c(0:2, 22:38), ]
sixth_man
#remove unecessary columns need only year, name of player, position, team played for.  
sixth_man <- sixth_man[, -c(1,6:11)]
sixth_man

#renaming the column names
colnames(sixth_man) <- c("year", "player_name", "position", "team")

#row names = NULL
rownames(sixth_man) <- NULL
sixth_man
#rookie 1st team 

rookie_1_team <- read.csv("rookie1.csv")
rookie_1_team

#remove Columns 

rookie_1_team <- rookie_1_team[, -c(1,6:11)]

#remove rows 
rookie_1_team <- rookie_1_team[-c(1:2,101:288),]
rookie_1_team 

#renaming column names 
colnames(rookie_1_team) <- c("year", "player_name", "position", "team")
rookie_1_team

#setting row names to null 
rownames(rookie_1_team) <- NULL

rookie_1_team

#have to fill in missing blanks with the year for each player * For some reason the 2012 first rookie team had 7 selections 
# * 2007 also had 6 rookie in the first team 


#Blaines code  
#rookie_1_team %>% mutate(year = lookup_table[match(row_number(), lookup_table$row), "year"])
#where %>% and mutate are from dplyr, match is a base R function which finds the location of the first argument in the vector of the second argument, 
#then returns the value in the given column.  This is very much like a vlookup in Excel if you have ever used that.  
#The row_number is also a dplyr function, and as we are sending your data.frame (rookie_1_team) into the piple (the %>% is the pipe operator), 
#row_number() automatically applies to the data.frame.  
#So this matches row numbers of your data frame to the row column of the lookup table and returns the year column and puts it into the new column year in your data.frame.  
#You can look up the syntax of all these.


rookie_1_team$year[1:5] <- "2018"
rookie_1_team$year[6:10] <- "2017"
rookie_1_team$year[11:15] <- "2016"
rookie_1_team$year[16:20] <- "2015"
rookie_1_team$year[21:25] <- "2014"
rookie_1_team$year[26:30] <- "2013"
rookie_1_team$year[31:37] <- "2012"
rookie_1_team$year[38:42] <- "2011"
rookie_1_team$year[43:47] <- "2010"
rookie_1_team$year[48:52] <- "2009"
rookie_1_team$year[53:57] <- "2008"
rookie_1_team$year[58:63] <- "2007"
rookie_1_team$year[64:68] <- "2006"
rookie_1_team$year[69:73] <- "2005"
rookie_1_team$year[74:78] <- "2004"
rookie_1_team$year[79:83] <- "2003"
rookie_1_team$year[84:88] <- "2002"
rookie_1_team$year[89:93] <- "2001"
rookie_1_team$year[94:98] <- "2000"
#probably write a function for this is better * need to write the code later 
###
##
###

#rookie second team 
rookie_2_team <- read.csv("rookie2.csv")
rookie_2_team

#remove Columns 

rookie_2_team <- rookie_2_team[, -c(1,6:11)]

#remove rows 
rookie_2_team <- rookie_2_team[-c(1:2,102:157),]
rookie_2_team 

#renaming column names 
colnames(rookie_2_team) <- c("year", "player_name", "position", "team")
rookie_2_team

#setting row names to null 
rownames(rookie_2_team) <- NULL

#have to fill in missing blanks with the year for each player
# 2009 rudy fernadez tied with dj augustin in votes, 2007 had 7 players because of ties , 2002 had 6 players 
rookie_2_team$year[1:5] <- "2018"
rookie_2_team$year[6:10] <- "2017"
rookie_2_team$year[11:15] <- "2016"
rookie_2_team$year[16:20] <- "2015"
rookie_2_team$year[21:25] <- "2014"
rookie_2_team$year[26:30] <- "2013"
rookie_2_team$year[31:35] <- "2012"
rookie_2_team$year[36:40] <- "2011"
rookie_2_team$year[41:45] <- "2010"
rookie_2_team$year[46:51] <- "2009"
rookie_2_team$year[52:56] <- "2008"
rookie_2_team$year[57:63] <- "2007"
rookie_2_team$year[64:68] <- "2006"
rookie_2_team$year[69:73] <- "2005"
rookie_2_team$year[74:78] <- "2004"
rookie_2_team$year[79:83] <- "2003"
rookie_2_team$year[84:89] <- "2002"
rookie_2_team$year[90:94] <- "2001"
rookie_2_team$year[95:99] <- "2000"

#nba_1_team 
nba_1_team <- read.csv("nba1.csv")
nba_1_team

#get rid of columns not used
nba_1_team <- nba_1_team[, -c(1,6:11)]

#get rid of rows not needed only need 2000-2018
nba_1_team <- nba_1_team[-c(1:2,98:363),]

#renaming column names 
colnames(nba_1_team) <- c("year", "player_name", "position", "team")


#setting row names to null 
rownames(nba_1_team) <- NULL

#have to fill in missing blanks with the year for each player

nba_1_team$year[1:5] <- "2018"
nba_1_team$year[6:10] <- "2017"
nba_1_team$year[11:15] <- "2016"
nba_1_team$year[16:20] <- "2015"
nba_1_team$year[21:25] <- "2014"
nba_1_team$year[26:30] <- "2013"
nba_1_team$year[31:35] <- "2012"
nba_1_team$year[36:40] <- "2011"
nba_1_team$year[41:45] <- "2010"
nba_1_team$year[46:50] <- "2009"
nba_1_team$year[51:55] <- "2008"
nba_1_team$year[56:60] <- "2007"
nba_1_team$year[61:65] <- "2006"
nba_1_team$year[66:70] <- "2005"
nba_1_team$year[71:75] <- "2004"
nba_1_team$year[76:80] <- "2003"
nba_1_team$year[81:85] <- "2002"
nba_1_team$year[86:90] <- "2001"
nba_1_team$year[91:95] <- "2000"

#nba_2_team
nba_2_team <- read.csv("nba2.csv")
nba_2_team

#get rid of columns not used
nba_2_team <- nba_2_team[, -c(1,6:11)]

#get rid of rows not needed only need 2000-2018
nba_2_team <- nba_2_team[-c(1:2,98:361),]

#renaming column names 
colnames(nba_2_team) <- c("year", "player_name", "position", "team")


#setting row names to null 
rownames(nba_2_team) <- NULL

#have to fill in missing blanks with the year for each player

nba_2_team$year[1:5] <- "2018"
nba_2_team$year[6:10] <- "2017"
nba_2_team$year[11:15] <- "2016"
nba_2_team$year[16:20] <- "2015"
nba_2_team$year[21:25] <- "2014"
nba_2_team$year[26:30] <- "2013"
nba_2_team$year[31:35] <- "2012"
nba_2_team$year[36:40] <- "2011"
nba_2_team$year[41:45] <- "2010"
nba_2_team$year[46:50] <- "2009"
nba_2_team$year[51:55] <- "2008"
nba_2_team$year[56:60] <- "2007"
nba_2_team$year[61:65] <- "2006"
nba_2_team$year[66:70] <- "2005"
nba_2_team$year[71:75] <- "2004"
nba_2_team$year[76:80] <- "2003"
nba_2_team$year[81:85] <- "2002"
nba_2_team$year[86:90] <- "2001"
nba_2_team$year[91:95] <- "2000"


#nba_3_team 
nba_3_team <- read.csv("nba3.csv")
nba_3_team

#get rid of columns not used
nba_3_team <- nba_3_team[, -c(1,6:11)]

#get rid of rows not needed only need 2000-2018
nba_3_team <- nba_3_team[-c(1:2,98:152),]

#renaming column names 
colnames(nba_3_team) <- c("year", "player_name", "position", "team")


#setting row names to null 
rownames(nba_3_team) <- NULL

#have to fill in missing blanks with the year for each player

nba_3_team$year[1:5] <- "2018"
nba_3_team$year[6:10] <- "2017"
nba_3_team$year[11:15] <- "2016"
nba_3_team$year[16:20] <- "2015"
nba_3_team$year[21:25] <- "2014"
nba_3_team$year[26:30] <- "2013"
nba_3_team$year[31:35] <- "2012"
nba_3_team$year[36:40] <- "2011"
nba_3_team$year[41:45] <- "2010"
nba_3_team$year[46:50] <- "2009"
nba_3_team$year[51:55] <- "2008"
nba_3_team$year[56:60] <- "2007"
nba_3_team$year[61:65] <- "2006"
nba_3_team$year[66:70] <- "2005"
nba_3_team$year[71:75] <- "2004"
nba_3_team$year[76:80] <- "2003"
nba_3_team$year[81:85] <- "2002"
nba_3_team$year[86:90] <- "2001"
nba_3_team$year[91:95] <- "2000"



#defense team 1 One player changed his name metta world peace was ron artest 
defense_1 <- read.csv("defense1.csv")
defense_1

#remove columns 
defense_1 <- defense_1[, -c(1,6:11)]

#get rid of rows not needed only need 2000-2018
defense_1 <- defense_1[-c(1:2,100:259),]

#renaming column names 
colnames(defense_1) <- c("year", "player_name", "position", "team")


#setting row names to null 
rownames(defense_1) <- NULL

#have to fill in missing blanks with the year for each player, 2013 had 6 players so there was a tie, 2006 had 6 players, 2001 had 6 players 

defense_1$year[1:5] <- "2018"
defense_1$year[6:10] <- "2017"
defense_1$year[11:15] <- "2016"
defense_1$year[16:20] <- "2015"
defense_1$year[21:25] <- "2014"
defense_1$year[26:31] <- "2013"
defense_1$year[32:36] <- "2012"
defense_1$year[37:41] <- "2011"
defense_1$year[42:46] <- "2010"
defense_1$year[47:51] <- "2009"
defense_1$year[52:56] <- "2008"
defense_1$year[57:61] <- "2007"
defense_1$year[62:67] <- "2006"
defense_1$year[68:72] <- "2005"
defense_1$year[72:76] <- "2004"
defense_1$year[77:81] <- "2003"
defense_1$year[82:86] <- "2002"
defense_1$year[87:92] <- "2001"
defense_1$year[93:97] <- "2000"


#defense team 2
defense_2 <- read.csv("defense2.csv")
defense_2

#remove columns 
defense_2 <- defense_2[, -c(1,6:11)]

#get rid of rows not needed only need 2000-2018
defense_2 <- defense_2[-c(1:2,99:257),]

#renaming column names 
colnames(defense_2) <- c("year", "player_name", "position", "team")


#setting row names to null 
rownames(defense_2) <- NULL

#have to fill in missing blanks with the year for each player, 2005 had 6 players in defensive all team 2 

defense_2$year[1:5] <- "2018"
defense_2$year[6:10] <- "2017"
defense_2$year[11:15] <- "2016"
defense_2$year[16:20] <- "2015"
defense_2$year[21:25] <- "2014"
defense_2$year[26:30] <- "2013"
defense_2$year[31:35] <- "2012"
defense_2$year[36:40] <- "2011"
defense_2$year[41:45] <- "2010"
defense_2$year[46:50] <- "2009"
defense_2$year[51:55] <- "2008"
defense_2$year[56:60] <- "2007"
defense_2$year[61:65] <- "2006"
defense_2$year[66:71] <- "2005"
defense_2$year[72:76] <- "2004"
defense_2$year[77:81] <- "2003"
defense_2$year[82:86] <- "2002"
defense_2$year[87:91] <- "2001"
defense_2$year[92:96] <- "2000"

#clean up defensive player of year winner
def_player <- read.csv("def_player.csv")
def_player

#get rid of columns not used
def_player <- def_player[, -c(7:18)]

#get rid of rows not needed only need 2000-2018
def_player <- def_player[-c(21:37),]

#remove LG voting and age column 
def_player <- def_player[,-c(2, 4:5)]
#renaming column names 
colnames(def_player) <- c("year", "player_name", "team")

#remove first row
def_player <- def_player[-1,]

#setting row names to null 
rownames(def_player) <- NULL

#seperate column of player_name 

def_player %>% separate(player_name, c("player_name", "player_id"),"\\\\")

#clean up most improved player of the year winner



mip <- read.csv("MIP.csv")

mip

# remove unneeded columns 
mip <- mip[,-c(1,6:11)]

#remove unneeded rows
mip <- mip[-c(1:2, 22:35),]

#setting row names to null 
rownames(mip) <- NULL

#renaming column names 
colnames(mip) <- c("year", "player_name", "position", "team")

#clean up most valuable player data
mvp <- read.csv("mvp.csv")
mvp

# remove unneeded columns 
mvp <- mvp[,-c(2,4,5,7:18)]

#remove unneeded rows
mvp <- mvp[-c(1, 21:64),]

#renaming column names 
colnames(mvp) <- c("year", "player_name", "team")

#setting row names to null 
rownames(mvp) <- NULL

#seperate column of player_name 

mvp %>% separate(player_name, c("player_name", "player_id"),"\\\\")

#clean rookie of the year data 
rookie_of_year <- read.csv("rookie.csv")

rookie_of_year

# remove unneeded columns 
rookie_of_year <- rookie_of_year[,-c(2,4,5,7:18)]

#remove unneeded rows
rookie_of_year <- rookie_of_year[-c(1, 22:70),]

#renaming column names 
colnames(rookie_of_year) <- c("year", "player_name", "team")

#setting row names to null 
rownames(rookie_of_year) <- NULL

#seperate column of player_name 

rookie_of_year %>% separate(player_name, c("player_name", "player_id"),"\\\\")

#total number of wins in a season by each team in that year.  

team_wins<-read.csv("team_wins.csv")
team_wins
# remove number of rows
team_wins <- team_wins[-c(21:74),]

#remove columns 
team_wins <- team_wins[, -c(1,3)]

#flip rows and columns using transpose 
team_wins2 <- data.frame(t(team_wins[-1]))
colnames(team_wins2) <- team_wins[, 1]

#try to find in number of years in the league for that player and try to find player age for each year.  

#cleaning age data

age_2019 <- read.csv("2019_age.csv")
age_2018 <- read.csv("2018_age.csv")
age_2017 <- read.csv("2017_age.csv")
age_2016 <- read.csv("2016_age.csv")
age_2015 <- read.csv("2015_age.csv")
age_2014 <- read.csv("2014_age.csv")
age_2013 <- read.csv("2013_age.csv")
age_2012 <- read.csv("2012_age.csv")
age_2011 <- read.csv("2011_age.csv")
age_2010 <- read.csv("2010_age.csv")
age_2009 <- read.csv("2009_age.csv")
age_2008 <- read.csv("2008_age.csv")
age_2007 <- read.csv("2007_age.csv")
age_2006 <- read.csv("2006_age.csv")
age_2005 <- read.csv("2005_age.csv")
age_2004 <- read.csv("2004_age.csv")
age_2003 <- read.csv("2003_age.csv")
age_2002 <- read.csv("2002_age.csv")
age_2001 <- read.csv("2001_age.csv")
age_2000 <- read.csv("2000_age.csv")

### looking at the data have to fix the height column, also the extra rows 


#Load in the salaries
salary_2019 <- read.csv("hoops_hype_salary_2019.csv")
salary_2018 <- read.csv("hoops_hype_salary_2018.csv")
salary_2017 <- read.csv("hoops_hype_salary_2017.csv")
salary_2016 <- read.csv("hoops_hype_salary_2016.csv")
salary_2015 <- read.csv("hoops_hype_salary_2015.csv")
salary_2014 <- read.csv("hoops_hype_salary_2014.csv")
salary_2013 <- read.csv("hoops_hype_salary_2013.csv")
salary_2012 <- read.csv("hoops_hype_salary_2012.csv")
salary_2011 <- read.csv("hoops_hype_salary_2011.csv")
salary_2010 <- read.csv("hoops_hype_salary_2010.csv")
salary_2009 <- read.csv("hoops_hype_salary_2009.csv")
salary_2008 <- read.csv("hoops_hype_salary_2008.csv")
salary_2007 <- read.csv("hoops_hype_salary_2007.csv")
salary_2006 <- read.csv("hoops_hype_salary_2006.csv")
salary_2005 <- read.csv("hoops_hype_salary_2005.csv")
salary_2004 <- read.csv("hoops_hype_salary_2004.csv")
salary_2003 <- read.csv("hoops_hype_salary_2003.csv")
salary_2002 <- read.csv("hoops_hype_salary_2002.csv")
salary_2001 <- read.csv("hoops_hype_salary_2001.csv")
salary_2000 <- read.csv("hoops_hype_salary_2000.csv")



#load in the statistics 

stat_2019 <- read.csv("2019_stats.csv")
stat_2018 <- read.csv("2018_stats.csv")
stat_2017 <- read.csv("2017_stats.csv")
stat_2016 <- read.csv("2016_stats.csv")
stat_2015 <- read.csv("2015_stats.csv")
stat_2014 <- read.csv("2014_stats.csv")
stat_2013 <- read.csv("2013_stats.csv")
stat_2012 <- read.csv("2012_stats.csv")
stat_2011 <- read.csv("2011_stats.csv")
stat_2010 <- read.csv("2010_stats.csv")
stat_2009 <- read.csv("2009_stats.csv")
stat_2008 <- read.csv("2008_stats.csv")
stat_2007 <- read.csv("2007_stats.csv")
stat_2006 <- read.csv("2006_stats.csv")
stat_2005 <- read.csv("2005_stats.csv")
stat_2004 <- read.csv("2004_stats.csv")
stat_2003 <- read.csv("2003_stats.csv")
stat_2002 <- read.csv("2002_stats.csv")
stat_2001 <- read.csv("2001_stats.csv")
stat_2000 <- read.csv("2000_stats.csv")

#CBA contracts there are 3 different CBA contracts during that period

# looking through the CBA if there is any missing data.  

#sources use these as a reference if there is any missing salary data from 2000-2019 
#latest
#http://www.cbafaq.com/salarycap.htm#Q7
#2011
#http://www.cbafaq.com/salarycap11.htm
#2005
#http://www.cbafaq.com/salarycap05.htm
#1999
#http://www.cbafaq.com/salarycap99.htm


# Tax information of different areas 
#https://www.kiplinger.com/tool/taxes/T055-S001-kiplinger-tax-map/index.php

#https://www.reddit.com/r/nba/comments/3cb0os/nba_teams_arranged_by_state_income_tax
##jock tax
#https://www.bna.com/taxes-ballhog-majority-n73014470964/
  
tax <- read.csv("state_income.csv")

#inflation adjustment
#https://tradingeconomics.com/united-states/wage-growth

#https://www.usinflationcalculator.com

#https://www.usinflationcalculator.com/inflation/current-inflation-rates/
  
inflation <- read.csv("inflation.csv")



#############################
#combining all the data into one big table 

# match all the years 2019 stats, age and salary 

#Stats have 483 observations, age has 477 observations, salary has 522 observations. 

# clean up stats

stat_2019

#remove rank column 

stat_2019 <- stat_2019[,-c(1)]

#Seperate player and player id 

stat_2019 <- stat_2019 %>% separate(Player, c("player_name", "player_id"),"\\\\")

#remove columns from age data 

age_2019

age_2019 <- age_2019[,-c(11:14)]

#remove rows

age_2019 <- age_2019[-c(51,102,153,204,255,306,357,408,459),]

names(age_2019)[1]<-paste("player_name") 

#salary clean up

salary_2019 <- salary_2019[,-c(1,2,5,6,7,8)]
salary_2019 <- salary_2019[,-c(3)]


colnames(salary_2019) <- c("player_name", "year")

salary_2019 <- salary_2019[-1,]

rownames(salary_2019) <- NULL

#time to combine all of 2019 

data_2019 <- full_join(salary_2019, age_2019, by = "player_name")
data_2019 <- full_join(data_2019, stat_2019, by = "player_name")

#have to fill in the N/As now.  
colnames(data_2019)[2] <- "salary"
sum(is.na(data_2019$salary))
sum(is.na(data_2019$AGE))
sum(is.na(data_2019$PS.G))
#clearing the repetative data 
data_2019 <- data_2019[,-c(20,21)]
data_2019 <- data_2019[,-c(13,14)]
data_2019 <- data_2019[,-c(13,14,15)]

#find duplicated rows
which(duplicated(data_2019$player_name))
data_2019 <- data_2019[-c(49:50,57:58,96:97,126:127,141:142,150:151,179:180,218:219,296:297,308:309,484:486),]

#change player_id so it will be for that year
data_2019$player_id[1:577] <- "player_2019"

#change the height data so it's not in date format 
data_2019$HEIGHT <- gsub("Jun", "6", data_2019$HEIGHT, fixed=TRUE)
data_2019$HEIGHT <- gsub("Jul", "7", data_2019$HEIGHT, fixed=TRUE)
data_2019$HEIGHT <- gsub("May", "5", data_2019$HEIGHT, fixed=TRUE)


data_2019$HEIGHT[which(data_2019$HEIGHT == "11-6")] = '6-11"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "10-6")] = '6-10"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "9-6")] = '6-9"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "8-6")] = '6-8"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "7-6")] = '6-7"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "5-6")] = '6-5"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "4-6")] = '6-4"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "3-6")] = '6-3"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "2-6")] = '6-2"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "1-6")] = '6-1"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "6-00")] = '6-0"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "11-5")] = '5-11"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "10-5")] = '5-10"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "9-5")] = '5-9"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "8-5")] = '5-8"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "7-5")] = '5-7"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "1-7")] = '7-1"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "2-7")] = '7-2"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "3-7")] = '7-3"'
data_2019$HEIGHT[which(data_2019$HEIGHT == "7-00")] = '7-0"'

#change the symbols - to 4'2"
data_2019$HEIGHT <- gsub("-", "'", data_2019$HEIGHT, fixed=TRUE)




#now time to fill the missing NAs
## missing salary NAs

sum(is.na(data_2019$salary))
which(is.na(data_2019$salary))
View(data_2019$player_name[522:577])
#Checking if there wasn't a mistake or not looking at notables 
grep("^Dennis",data_2019$player_name)
grep("^Otto",data_2019$player_name)
grep("^Patty", data_2019$player_name)
grep("^Maurice", data_2019$player_name)
grep("^Tim", data_2019$player_name)
grep("^JJ", data_2019$player_name)

#problem with name the different data of age, stat and salary have different spellings 
##will have to look for duplicates later.  
look.for <- "Otto Porter"
data_2019[data_2019$player_name %in% look.for, ]

#had to google and fill in the salary online made a new csv file with the missing salaries
sal_mis_2019 <- read.csv("missing_values_2019_salary.csv")
##clean up
rownames(sal_mis_2019) <- NULL
#sal_mis_20192 <- sal_mis_2019[,-c(1)]
#data_2019$salary <-sal_mis_20192
#combine with data_2019
###library(data.table)
###test_data_2019 <- data_2019 %>% unite(player_name)
#rbindlist(list(data_2019, sal_mis_2019), fill=TRUE)[, c(3:39) :=
                                       #lapply(.SD, na.omit) , player_name, .SDcols=TEAM:PS.G][]

#test_data_2019 <- merge(data_2019, sal_mis_2019, all = TRUE)
test_data_2019 <- full_join(data_2019,sal_mis_2019, by = "player_name")
##row.names(test_data_2019)<-paste(test_data_2019[,"salary.x"],test_data_2019[,"salary.y"],sep="")

test_data_2019 <- test_data_2019 %>% unite(salary, c("salary.x", "salary.y"))
test_data_2019$salary <- gsub("^NA_", "", test_data_2019$salary)
test_data_2019$salary <- gsub("\\>_NA", "", test_data_2019$salary)
test_data_2019$salary <- gsub("^$", "", test_data_2019$salary)
# not working for some reason
library(stringr)
test_data_2019$salary <- str_replace(test_data_2019$salary, "_NA", "")
test_data_2019$salary <- str_replace(test_data_2019$salary, "\\$", "")
test_data_2019$salary <- str_replace_all(test_data_2019$salary, ",", "")
test_data_2019$salary <- as.numeric(test_data_2019$salary)

#probably have to change other data into numerics when doing data exploration to summarize them into other advanced statistics 
names(test_data_2019)
#test_data_2019$WEIGHT <- as.numeric(test_data_2019$WEIGHT)
test_data_2019$MP <- as.numeric(test_data_2019$MP)

#now time to fill in missing NAs for AGE
sum(is.na(data_2019$AGE))
View(data_2019$player_name & which(is.na(data_2019$AGE)))

#now time to fill in missing NAs for stats
sum(is.na(data_2019$PS.G))
which(is.na(data_2019$PS.G))
#Match 2018

#Match 2017

#Match 2016

#match 2015

#match 2014

#match 2013

#match 2012

#match 2011

#match 2010

#match 2009

#match 2008

#match 2007

#match 2006

#match 2005

#match 2004

#match 2003

#match 2002

#match 2001

#match 2000

