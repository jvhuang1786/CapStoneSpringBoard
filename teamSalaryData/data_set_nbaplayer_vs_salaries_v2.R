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

##Clean up to remove . from stat_2019
grep("\\.", stat_2019$player_name, value = TRUE)
stat_2019$player_name<- gsub("\\.", "", stat_2019$player_name)
grep("\\.", stat_2019$player_name, value = TRUE)
names(stat_2019)
stat_2019$Age <- as.numeric(stat_2019$Age)
colnames(stat_2019)[30] <- "ppg"

grep(".JR$",stat_2019, value = TRUE) # no JR in this data set so will have to remove it in the other data sets or add it here.

#look through all stats for which one junior is missing for a total of 13 was missing in stats. 
grep(".Jr$", salary_2019$player_name, value = TRUE) # shows 3 here 1 unique from salary Walter Lemon 
grep(".Jr$", age_2019$player_name, value = TRUE) # shows 12 unique here

#testing stat 
grep("Danuel House", stat_2019$player_name, value = TRUE)
stat_2019$player_name<-gsub("Danuel House", "Danuel House Jr", stat_2019$player_name)
stat_2019$player_name<-gsub("Danuel House Jr Jr", "Danuel House Jr", stat_2019$player_name)
grep("Dennis Smith", stat_2019$player_name, value = TRUE)
stat_2019$player_name<-gsub("Dennis Smith", "Dennis Smith Jr", stat_2019$player_name)
stat_2019$player_name<-gsub("Dennis Smith Jr Jr", "Dennis Smith Jr", stat_2019$player_name)

grep("Derrick Jones", stat_2019$player_name, value = TRUE)
stat_2019$player_name<-gsub("Derrick Jones", "Derrick Jones Jr", stat_2019$player_name)
stat_2019$player_name<-gsub("Derrick Jones Jr Jr", "Derrick Jones Jr", stat_2019$player_name)
grep("Gary Trent", stat_2019$player_name, value = TRUE)
stat_2019$player_name<-gsub("Gary Trent", "Gary Trent Jr", stat_2019$player_name)
stat_2019$player_name<-gsub("Gary Trent Jr Jr", "Gary Trent Jr", stat_2019$player_name)
grep("Jaren Jackson", stat_2019$player_name, value = TRUE)
stat_2019$player_name<-gsub("Jaren Jackson", "Jaren Jackson Jr", stat_2019$player_name)

grep("Kelly Oubre",stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", stat_2019$player_name)

grep("Larry Nance", stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Larry Nance", "Larry Nance Jr", stat_2019$player_name)

grep("Melvin Frazier", stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Melvin Frazier", "Melvin Frazier Jr", stat_2019$player_name)

grep("Otto Porter", stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Otto Porter", "Otto Porter Jr", stat_2019$player_name)

grep("Tim Hardaway", stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Tim Hardaway", "Tim Hardaway Jr", stat_2019$player_name)

grep("Troy Brown", stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Troy Brown", "Troy Brown Jr", stat_2019$player_name)

grep("Wendell Carter", stat_2019$player_name, value = TRUE)

stat_2019$player_name<-gsub("Wendell Carter", "Wendell Carter Jr", stat_2019$player_name)

grep("Walter Lemon", stat_2019$player_name) # missing #googled and was cut after a 3rd 10 day contract not worth keeping

#testing salary 
grep("Danuel House", salary_2019$player_name, value = TRUE)
salary_2019$player_name<-gsub("Danuel House", "Danuel House Jr", salary_2019$player_name)

grep("Dennis Smith", salary_2019$player_name, value = TRUE)
salary_2019$player_name<-gsub("Dennis Smith", "Dennis Smith Jr", salary_2019$player_name)


grep("Derrick Jones", salary_2019$player_name, value = TRUE) 
salary_2019$player_name<-gsub("Derrick Jones", "Derrick Jones Jr", salary_2019$player_name)

grep("Gary Trent", salary_2019$player_name)
salary_2019$player_name<-gsub("Gary Trent", "Gary Trent Jr", salary_2019$player_name)

grep("Jaren Jackson", salary_2019$player_name)
salary_2019$player_name<-gsub("Jaren Jackson", "Jaren Jackson Jr", salary_2019$player_name)

grep("Kelly Oubre", salary_2019$player_name)
salary_2019$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", salary_2019$player_name)

grep("Larry Nance", salary_2019$player_name)
salary_2019$player_name<-gsub("Larry Nance", "Larry Nance Jr", salary_2019$player_name)

grep("Melvin Frazier", salary_2019$player_name)  
salary_2019$player_name<-gsub("Melvin Frazier", "Melvin Frazier Jr", salary_2019$player_name)

grep("Otto Porter", salary_2019$player_name)
salary_2019$player_name<-gsub("Otto Porter", "Otto Porter Jr", salary_2019$player_name)

grep("Tim Hardaway", salary_2019$player_name)
salary_2019$player_name<-gsub("Tim Hardaway", "Tim Hardaway Jr", salary_2019$player_name)

grep("Troy Brown", salary_2019$player_name, value = TRUE)
salary_2019$player_name<-gsub("Troy Brown", "Troy Brown Jr", salary_2019$player_name)

grep("Wendell Carter", salary_2019$player_name, value = TRUE)
salary_2019$player_name<-gsub("Wendell Carter", "Wendell Carter Jr", salary_2019$player_name)
grep("Walter Lemon", salary_2019$player_name)
grep("Walter Lemon", salary_2019$player_name, value = TRUE) # was cut so just remove the player 
salary_2019$player_name<-gsub("Walter Lemon Jr Jr", "Walter Lemon Jr", salary_2019$player_name)
salary_2019 <-salary_2019[-c(471),]
rownames(salary_2019) <- NULL 
#testing age 

grep("Danuel House", age_2019$player_name, value = TRUE)
grep("Dennis Smith", age_2019$player_name, value = TRUE)
grep("Derrick Jones", age_2019$player_name, value = TRUE) 
grep("Gary Trent", age_2019$player_name, value = TRUE)
grep("Jaren Jackson", age_2019$player_name, value = TRUE)
grep("Kelly Oubre", age_2019$player_name, value = TRUE)
grep("Larry Nance", age_2019$player_name, value = TRUE)
grep("Melvin Frazier", age_2019$player_name, value = TRUE)
grep("Otto Porter", age_2019$player_name, value = TRUE)
grep("Tim Hardaway", age_2019$player_name, value = TRUE)
grep("Troy Brown", age_2019$player_name, value = TRUE)
grep("Wendell Carter", age_2019$player_name, value = TRUE)
grep("Walter Lemon", age_2019$player_name, value = TRUE) # missing walter lemon 

#nene hilario weird spelling 
grep("^Ne", stat_2019$player_name, value = TRUE)
grep("^Ne", age_2019$player_name, value = TRUE)
grep("^Ne", age_2019$player_name)
age_2019$player_name[336] <- "Nene Hilario"
grep("^Nen", salary_2019$player_name, value = TRUE)
salary_2019$player_name <- gsub("Nen", "Nene Hilario", salary_2019$player_name)
salary_2019$player_name <- gsub("Nene Hilarioê", "Nene Hilario", salary_2019$player_name)


#multiple trade scenarios where a player ended up on different teams 
duplicated(stat_2019$player_name)
#alec burks CLE, Jimmy butler PHI, Tyson Chandler LAL, Robert Covington MIN, Sam Dekker WAS, Matthew Delly CLE, Andrew Harison CLE
#George Hill Mil, Kyle Korver Utah , Dario Saric MIN, will leave the last team they played for in the total column. 
grep("Alec ", stat_2019$player_name)
stat_2019 <- stat_2019[-c(73,74),]
grep("Jimmy", stat_2019$player_name)
grep("Tyson Chandler", stat_2019$player_name)
grep("Robert Covington", stat_2019$player_name)
grep("Sam Dekker", stat_2019$player_name)
grep("Matthew Del", stat_2019$player_name)
grep("Andrew Harrison", stat_2019$player_name)
grep("George Hill", stat_2019$player_name)
grep("Kyle Korver", stat_2019$player_name)
grep("Dario Saric", stat_2019$player_name)
grep("Jason Smith", stat_2019$player_name)
stat_2019 <- stat_2019[-c(75,76,88,89,102,103,117,118,120,121,196,197,198,211,212,265,266,397,398),]
rownames(stat_2019) <- NULL 
duplicated(stat_2019$player_name)

stat_2019 <- stat_2019[-c(397:398),]

#now to change TOT to the last team they played on  

#alec burks CLE, Jimmy butler PHI, Tyson Chandler LAL, Robert Covington MIN, Sam Dekker WAS, Matthew Delly CLE, Andrew Harison CLE
#George Hill Mil, Kyle Korver Utah , Dario Saric MIN, will leave the last team they played for in the total column. 
grep("Alec ", stat_2019$player_name)
grep("Jimmy", stat_2019$player_name)
grep("Tyson Chandler", stat_2019$player_name)
grep("Robert Covington", stat_2019$player_name)
grep("Sam Dekker", stat_2019$player_name)
grep("Matthew Del", stat_2019$player_name)
grep("Andrew Harrison", stat_2019$player_name)
grep("George Hill", stat_2019$player_name)
grep("Kyle Korver", stat_2019$player_name)
grep("Dario Saric", stat_2019$player_name)
grep("Jason Smith", stat_2019$player_name)

#remove columns from age data 

age_2019

age_2019 <- age_2019[,-c(11:14)]

#remove rows

age_2019 <- age_2019[-c(51,102,153,204,255,306,357,408,459),]

names(age_2019)[1]<-paste("player_name") 

grep("\\.",age_2019$player_name)
age_2019$player_name <- gsub("\\.","", age_2019$player_name)
grep(".Jr$", age_2019$player_name, value = TRUE)
#salary clean up

salary_2019 <- salary_2019[,-c(1,2,5,6,7,8)]
salary_2019 <- salary_2019[,-c(3)]


colnames(salary_2019) <- c("player_name", "year")

salary_2019 <- salary_2019[-1,]

rownames(salary_2019) <- NULL

grep("\\.",salary_2019$player_name)
grep(".Jr$", salary_2019$player_name, value = TRUE)

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
#data_2019 <- data_2019[-c(49:50,57:58,96:97,126:127,141:142,150:151,179:180,218:219,296:297,308:309,484:486),]

#change player_id so it will be for that year
#data_2019$player_id[1:577] <- "player_2019"

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
#### now only 31 missing salary data 
#View(data_2019$player_name[522:577])
#Checking if there wasn't a mistake or not looking at notables 
#grep("^Dennis",data_2019$player_name)
#grep("^Otto",data_2019$player_name)
#grep("^Patty", data_2019$player_name)
#grep("^Maurice", data_2019$player_name)
#grep("^Tim", data_2019$player_name)
grep("^JJ", data_2019$player_name, value = TRUE)
grep("^Dennis",data_2019$player_name, value = TRUE)
#grep("CJ", data_2019$player_name)
#rownames(data_2019) <- NULL 
#problem with name the different data of age, stat and salary have different spellings 
##will have to look for duplicates later.  
#look.for <- "Otto Porter"
#data_2019[data_2019$player_name %in% look.for, ]

#had to google and fill in the salary online made a new csv file with the missing salaries
#sal_mis_2019 <- read.csv("missing_values_2019_salary.csv")
##clean up
#rownames(sal_mis_2019) <- NULL
#sal_mis_20192 <- sal_mis_2019[,-c(1)]
#data_2019$salary <-sal_mis_20192
#combine with data_2019
###library(data.table)
###test_data_2019 <- data_2019 %>% unite(player_name)
#rbindlist(list(data_2019, sal_mis_2019), fill=TRUE)[, c(3:39) :=
                                       #lapply(.SD, na.omit) , player_name, .SDcols=TEAM:PS.G][]



###cleaned up data for new 2019
sal_mis_2019<-read.csv("missing_salary_data_2019.csv", header = FALSE)
names(data_2019)
colnames(sal_mis_2019)[1:39] <- c("player_name", "salary", "TEAM", "AGE", "HEIGHT", "WEIGHT", "COLLEGE", "COUNTRY", "DRAFT.YEAR",
                               "DRAFT.ROUND", "DRAFT.NUMBER", "NETRTG", "player_id", "Pos", "G", "GS", "MP", "FG", "FGA",
                               "FG.", "X3P", "X3PA", "X3P.", "X2P", "X2PA", "X2P.", "eFG.", "FT", "FTA", "FT.", "ORB", "DRB",
                               "TRB", "AST", "STL", "BLK", "TOV", "PF", "ppg") 
sal_mis_2019 <- sal_mis_2019[-32,]

#test_data_2019 <- merge(data_2019, sal_mis_2019, all = TRUE)
test_data_2019 <-data_2019
test_data_2019 <- test_data_2019[-c(521:551),]
test_data_2019 <- rbind(test_data_2019, sal_mis_2019)

#removing player duplicates from salary 
grep("^Juan.", test_data_2019$player_name, value = TRUE)
grep("^Juan.", test_data_2019$player_name)
test_data_2019 <- test_data_2019[-323,]


grep(".II$", test_data_2019$player_name, value = TRUE)
grep("III", test_data_2019$player_name, value = TRUE)
grep("Harry Giles", test_data_2019$player_name)
test_data_2019 <- test_data_2019[-319,]
grep("Glenn Robinson", test_data_2019$player_name)
test_data_2019 <- test_data_2019[-234,]
grep("James Ennis", test_data_2019$player_name)
test_data_2019 <- test_data_2019[-368,]
grep("Marvin Bagley", test_data_2019$player_name)
test_data_2019 <- test_data_2019[-170,]
grep("Robert Williams", test_data_2019$player_name)
test_data_2019 <- test_data_2019[-357,] 
grep("Glenn", test_data_2019$player_name)
rownames(test_data_2019) <- NULL 


#remove cut player from salary
grep("cut", test_data_2019$salary)
test_data_2019 <- test_data_2019[-531,]
# loading stringr library 
#library(stringr)
#test_data_2019$salary <- str_replace(test_data_2019$salary, "_NA", "")
#test_data_2019$salary <- str_replace(test_data_2019$salary, "\\$", "")
#test_data_2019$salary <- str_replace_all(test_data_2019$salary, ",", "")
#test_data_2019$salary <- as.numeric(test_data_2019$salary)

#time to look at age and stats

which(is.na(test_data_2019$TEAM))
sum(is.na(test_data_2019$TEAM))
#17 is chris bosh blood clots so remove
#63 Tim Hardaway Jr Jr coding error and duplicate so remove
#73 Mozgov didn't play at all this year so remove
#76 Different spelling of Dennis Scroeder so remove it's a duplicate
#84 Brandon Knight played 6 games with Hou need to find stats 
#101 Dion Waiters didn't play this season so remove
#117 zach randolph did not play so remove
#118Patrick Mills is a duplicate of Patty Mills so remove
#120 Omer Asik didn't play so remove
#124 Moe harkless is Maurice Harkless so remove this repetitive data
#130 did not play this season so remove Mirza Teletovic
#135 did not play injyury remove Andre roberson
#152 played 4 games Jerryd Bayless need to add
#160 Louis williams is lou williams so just remove duplicate
#167 Darrell arthur did not play so remove
#192 #Ishmael Smith is Ish smith remove duplicate
#196 Kristaps is injured so didn't play remove
#197 Deron Williams did not play this season so remove
#205 Demarcus cousins is injured so remove
#206 Josh smith is out of the league so remove
#207 Alexa Ajinca is out of the league remove
#234 Al Jefferson did not play so remove
#239 Jose Juan Barea is JJ barea so remove duplicate
#248 jodie meeks played 1 game so add back stats
#272 Michael porter Jr need to add his data in 
grep("Michael Porter", test_data_2019$player_name)
#273 Andrew nicholson is out of the league
#280 Justin Patton out of league so remove
#283 Was drafted but never signed remove
#286 Taureen Prince is a duplicate so remove 
#291 Manu Ginobli is retired so remove
#299Georgios Papagiannis did not play this season so remove
#311 Lonie Walker IV played only one game assigned to dleague so remove
#313 Denzel Valentine did not play this season 
#314 Larry Nance Jr is a duplicate so remove
#316 Monta Ellis out of league so remove
#328  Isaih Thomas Denver signed him as a mentor to do player development so remove
#329 Spencer Hawes out of the league so remove
#331 Cole Aldrich out of league so remove
#337 different spelling timothe Luwawu-cabarrot, so remove duplicate
grep("Timothe Luwawu-Cabarrot", test_data_2019$player_name)
#354 Tony Bradley sent to dleague after 1 game so remove
#356 Not in league so remove kyle singler 
#360 Nick Young no longer playing so remove
#363 Another different spelling, duplicate so remove deandre bembry 
grep("DeAndre' Bembry", test_data_2019$player_name)
#379 Dejounte Murray injured in preseason so remove
#390 not in NBA but in d league so remove
#398 Sviatoslav Mykhailiuk in G league south bay lakers so remove
#413 Dakari Johnson G leauge so remove
#414 Rade Zagorac Boston still has his rights but playing in euro league so remove
#422 Jabari Bird not in league so remove
#433 Eric Moreland got traded and is no longer in league so remove
#436 Justin Hamilton not in league so remove
#437 Devonte Graham another weird spelling, already have so remove duplicate 
grep("Devonte' Graham", test_data_2019$player_name)
#439 Jason Thompson no longer in leageu so remove
#441 Raymond spalding different spelling so remove duplicate
#442 Not playing in NBA Jarred Vanderbilt so remove 
#451 Duplicate data Gary Trent Jr so remove
#459 Cut after a few days so remove data Ben Moore
#461 Chason Randle need to add data back playing with wizards
#466 Alan Williams playing in dleague so remove
#467 	Joe Chealey dleauge so remove
#468 JP Macura no longer in league so remove
#469 Rawle Alkins dleauge so remove
#474 Billy Preston is in dleague remove
#475 Kostas Antetokounmpo dleague so remove
#479 Keenan Evans dleague so remove
#483 Vincent Edwards duplicate so remove
#485 Angel Delgado d league so remove
#486 Johnathan Motley add in data
#487 Alex Caruso dleague so remove
#490 Yante Maten add in data
#492 Trevon Duval no longer in league so remove
#496 Trevon Bluiett d league so remove
#497 Isaiah Hicks add in data
#501 dleauge Troy Caupain remove 
#502 Amile Jefferson dleague remove
#508 	Tyler Cavanaugh add in data
#509 Naz Long dleague remove
#512 	Wenyen Gabriel add in data
#513 Brandon Goodwin remove
#514 Nuni Omot no longer in league so remove 

test_data_2019 <- test_data_2019[-c(17,63,73,76, 84,101, 117, 118, 120, 124, 130, 135, 160, 167, 192, 197, 205, 206, 207,
                                    234, 239, 248, 273, 280, 283, 286, 291, 299, 311, 313, 314, 316, 328, 329, 331, 337, 
                                    354, 356, 360, 363, 379, 390, 398, 413, 414, 422, 433, 436, 437, 439, 441, 442, 451, 459,
                                    466, 467, 468, 474, 475, 479, 483, 485, 487, 492, 496, 501, 502, 509, 513, 514),]

rownames(test_data_2019) <- NULL 
which(is.na(test_data_2019$ppg))
#remove Kristap 181 
#remove Dirk he did not play this season 194
# add in mo bamba ORL remove this data point already have 197
grep("Bamba", test_data_2019$player_name)
# remove 412 Rawle Alkins 
test_data_2019 <- test_data_2019[-c(181,194,197,412), ]
rownames(test_data_2019) <- NULL 
sum(is.na(test_data_2019$ppg))
  #152 played 4 games Jerryd Bayless need to add
grep("Bayless", test_data_2019$player_name, value = TRUE)
grep("Bayless", test_data_2019$player_name)
  #272 Michael porter Jr need to add his data in
grep("Porter",test_data_2019$player_name, value = TRUE) # only played 1 game then dleague remove
grep("Porter", test_data_2019$player_name)
#247
  #461 Chason Randle need to add data back playing with wizards
grep("Randle",test_data_2019$player_name, value = TRUE)
  #486 Johnathan Motley add in data
grep("Motley",test_data_2019$player_name, value = TRUE)
  #490 Yante Maten add in data
grep("Maten",test_data_2019$player_name, value = TRUE) # dleagur so remove
grep("Maten",test_data_2019$player_name)
#423
  #497 Isaiah Hicks add in data
grep("Hicks",test_data_2019$player_name, value = TRUE)
  #508 	Tyler Cavanaugh add in data
grep("Cavanaugh",test_data_2019$player_name, value = TRUE)
  #512 	Wenyen Gabriel add in data
grep("Gabriel",test_data_2019$player_name, value = TRUE) #dleaguer so remove
grep("Gabriel",test_data_2019$player_name)
#440
test_data_2019 <- test_data_2019[-c(247,423,440)]



stat_age_missing<-read.csv("stats_age_missing_stats.csv",header = F)
stat_age_missing<-stat_age_missing[-c(6:8),]
colnames(stat_age_missing)[1:39] <- c("player_name", "salary", "TEAM", "AGE", "HEIGHT", "WEIGHT", "COLLEGE", "COUNTRY", "DRAFT.YEAR",
                                  "DRAFT.ROUND", "DRAFT.NUMBER", "NETRTG", "player_id", "Pos", "G", "GS", "MP", "FG", "FGA",
                                  "FG.", "X3P", "X3PA", "X3P.", "X2P", "X2PA", "X2P.", "eFG.", "FT", "FTA", "FT.", "ORB", "DRB",
                                  "TRB", "AST", "STL", "BLK", "TOV", "PF", "ppg") 

test_data_2019<-rbind(test_data_2019, stat_age_missing)

#remove duplicates after rbind
grep("Bayless", test_data_2019$player_name)
grep("Chasson Randle",test_data_2019$player_name)
grep("Motley",test_data_2019$player_name)
grep("Hicks",test_data_2019$player_name)
grep("Cavanaugh",test_data_2019$player_name)

test_data_2019 <- test_data_2019[-c(140,404,420,428,437),]
rownames(test_data_2019) <- NULL
sum(is.na(test_data_2019$ppg))
which(is.na(test_data_2019$ppg))

test_data_2019 <- test_data_2019[-c(246, 420, 435),]
#checkin if i changed the tot 
grep("Jimmy", test_data_2019$player_name)

#adding tax and inflation 
tax <- read.csv("state_income.csv")
test_data_2019<-full_join(test_data_2019, tax, by = "TEAM")


inflation <- read.csv("inflation.csv")
test_data_2019["inflation"] <- 2.5
#add in player id by the 2019 year
test_data_2019$player_id <- "2019"

#change salary to numeric 

library(stringr)
test_data_2019$salary <- str_replace(test_data_2019$salary, "\\$", "")
test_data_2019$salary <- str_replace_all(test_data_2019$salary, ",", "")
test_data_2019$salary <- as.numeric(test_data_2019$salary)

test_data_2019$HEIGHT[which(test_data_2019$HEIGHT == "6'6")] = "6'5\""

# adding team wins

team_wins<-read.csv("team_wins.csv")
team_wins19 <- team_wins[,-c(3:21)]
colnames(team_wins19)[2] <- "wins"
test2<-full_join(test_data_2019, team_wins19, by = "TEAM")

test2 <- test2[-c(468:470),]

#time to add the awards from the year before 
#counting the number of times each player won the award nba first team

rapply(nba_1_team,function(x)length(unique(x)))
unique(nba_1_team$player_name)

# problem with this is I'll have to collect data dating perhaps 15 years back from 2000 to get the all nba teams for the 2000 players 
sum(nba_1_team$player_name == "LeBron James")
sum(nba_1_team$player_name == "Kevin Durant")
sum(nba_1_team$player_name == "James Harden")
sum(nba_1_team$player_name == "Anthony Davis")
sum(nba_1_team$player_name == "Damian Lillard")
sum(nba_1_team$player_name == "Russell Westbrook")
sum(nba_1_team$player_name == "Kawhi Leonard")
sum(nba_1_team$player_name == "DeAndre Jordan")
sum(nba_1_team$player_name == "Stephen Curry")
sum(nba_1_team$player_name == "Marc Gasol")
sum(nba_1_team$player_name == "Chris Paul")
sum(nba_1_team$player_name == "Joakim Noah")
sum(nba_1_team$player_name == "Kobe Bryant")
sum(nba_1_team$player_name == "Tim Duncan")
sum(nba_1_team$player_name == "Dwight Howard")
sum(nba_1_team$player_name == "Derrick Rose")
sum(nba_1_team$player_name == "Dwyane Wade")
sum(nba_1_team$player_name == "Dirk Nowitzki")
sum(nba_1_team$player_name == "Kevin Garnett")
sum(nba_1_team$player_name == "Steve Nash")
sum(nba_1_team$player_name == "Amar'e Stoudemire")
sum(nba_1_team$player_name == "Shaquille O'Neal")
sum(nba_1_team$player_name == "Allen Iverson")
sum(nba_1_team$player_name == "Jason Kidd")
sum(nba_1_team$player_name == "Tracy McGrady")
sum(nba_1_team$player_name == "Chris Webber")
sum(nba_1_team$player_name == "Gary Payton")

# make a column if they won the awards the previous year.  #make columns for awards
test <- test2
test2<-test
test2["MVP"] <- "NO"
test2["MIP"] <- "NO"
test2["Sixth_man"] <- "NO"
test2["DPOY"] <- "NO"
test2["ROY"] <- "NO"
test2["NBA_1"] <- "NO"
test2["NBA_2"] <- "NO"
test2["NBA_3"] <- "NO"
test2["Rookie_1"] <- "NO"
test2["Rookie_2"] <- "NO"
test2["Def_1"] <- "NO"
test2["Def_2"] <- "NO"

#now to change it to yes if they ever won one of these categories.  
rapply(nba_1_team,function(x)length(unique(x)))
unique(nba_1_team$player_name)

rapply(nba_2_team,function(x)length(unique(x)))
unique(nba_2_team$player_name)

rapply(nba_3_team,function(x)length(unique(x)))
unique(nba_3_team$player_name)

rapply(sixth_man,function(x)length(unique(x)))
unique(sixth_man$player_name)

rapply(rookie_of_year,function(x)length(unique(x)))
unique(rookie_of_year$player_name)

rapply(rookie_1_team,function(x)length(unique(x)))
unique(rookie_1_team$player_name)

rapply(rookie_2_team,function(x)length(unique(x)))
unique(rookie_2_team$player_name)

rapply(mip,function(x)length(unique(x)))
unique(mip$player_name)

rapply(mvp,function(x)length(unique(x)))
unique(mvp$player_name)

rapply(def_player,function(x)length(unique(x)))
unique(def_player$player_name)

rapply(defense_1,function(x)length(unique(x)))
unique(defense_1$player_name)

rapply(defense_2,function(x)length(unique(x)))
unique(defense_2$player_name)

#Nba first team
#Lebron james 
test2[4, 48] <- "YES"

#Anthony Davis
grep("Anthony Davis", test2$player_name)

test2[4, 48] <- "YES" 

#Kevin Durant

grep("Kevin Durant", test2$player_name)

test2[11, 48] <- "YES"

#Damien Lilard 

grep("Damian Lillard", test2$player_name)

test2[14,48] <- "YES"

#James Harden 

grep("James Harden", test2$player_name)

test2[8, 48] <- "YES" 

#NBA second team 

#LaMarcus Aldridge	(Spurs)
grep("LaMarcus Aldridge", test2$player_name)

test2[38, 49] <- "YES"

#Giannis Antetokounmpo	(Bucks)
grep("Giannis Antetokounmpo", test2$player_name)

test2[28, 49] <- "YES"

#DeMar DeRozan	(Raptors)
grep("DeMar DeRozan", test2$player_name)
test2[16, 49] <- "YES"
#Joel Embiid	(76ers)
grep("Joel Embiid", test2$player_name)
test2[21, 49] <- "YES"
#Russell Westbrook	(Thunder)
grep("Russell Westbrook", test2$player_name)
test2[2, 49] <- "YES"

#NBA third team 

#Jimmy Butler	(Timberwolves)
grep("Jimmy Butler", test2$player_name)
test2[47, 50] <- "YES"
#Stephen Curry	(Warriors)
grep("Stephen Curry", test2$player_name)
test2[1, 50] <- "YES"
#Paul George	(Thunder)
grep("Paul George", test2$player_name)
test2[9, 50] <- "YES"
#Victor Oladipo	(Pacers)
grep("Victor Oladipo", test2$player_name)
test2[42, 50] <- "YES"
#Karl-Anthony Towns	(Timberwolves)
grep("Karl-Anthony Towns", test2$player_name)
test2[151, 50] <- "YES"

#All Rookie 1st team
#Kyle Kuzma	(Lakers)
grep("Kyle Kuzma", test2$player_name)
test2[312, 51] <- "YES"
#Lauri Markkanen	(Bulls)
grep("Lauri Markkanen", test2$player_name)
test2[198, 51] <- "YES"
#Donovan Mitchell	(Jazz)
grep("Donovan Mitchell", test2$player_name)
test2[239, 51] <- "YES"
#Ben Simmons	(76ers)
grep("Ben Simmons", test2$player_name)
test2[168, 51] <- "YES"
#Jayson Tatum	(Celtics)
grep("Jayson Tatum", test2$player_name)
test2[164, 51] <- "YES"

#All rookie 2nd team 

#Lonzo Ball	(Lakers)
grep("Lonzo Ball", test2$player_name)
test2[153, 52] <- "YES"
#Bogdan Bogdanovic	(Kings)
grep("Bogdan Bogdanovic", test2$player_name)
test2[132, 52] <- "YES"
#John Collins	(Hawks)
grep("John Collins", test2$player_name)
test2[278, 52] <- "YES"
#Josh Jackson	(Suns)
grep("Josh Jackson", test2$player_name)
test2[174, 52] <- "YES"
#Dennis Smith Jr.	(Mavericks)
grep("Dennis Smith Jr", test2$player_name)
test2[213, 52] <- "YES"

#All defensive first team
#Rudy Gobert	(Jazz)
grep("Rudy Gobert", test2$player_name)
test2[37, 53] <- "YES"
#Anthony Davis	(Pelicans)
grep("Anthony Davis", test2$player_name)
test2[23, 53] <- "YES"
#Robert Covington	(76ers)
grep("Robert Covington", test2$player_name)
test2[121, 53] <- "YES"
#Jrue Holiday	(Pelicans)
grep("Jrue Holiday", test2$player_name)
test2[17, 53] <- "YES"
#Victor Oladipo	(Pacers)
grep("Victor Oladipo", test2$player_name)
test2[42, 53] <- "YES"
#All defensive second team 

#Jimmy Butler	(Timberwolves)
grep("Jimmy Butler", test2$player_name)
test2[47, 54] <- "YES"
#Joel Embiid	(76ers)
grep("Joel Embiid", test2$player_name)
test2[21, 54] <- "YES"
#Draymond Green	(Warriors)
grep("Draymond Green", test2$player_name)
test2[61, 54] <- "YES"
#Al Horford	(Celtics)
grep("Al Horford", test2$player_name)
test2[13, 54] <- "YES"
#Dejounte Murray	(Spurs)
#grep("Dejounte Murray", test2$player_name, value = TRUE) #Injured player so was removed 
#test2[213, 54] <- "YES"

#MVP 43 
grep("James Harden", test$player_name)
test2[8, 43] <- "YES"
#MIP 44
grep("Victor Oladipo", test$player_name)
test2[42, 44] <- "YES"
#6th man 45 
grep("Lou Williams", test$player_name)
test2[446, 45] <- "YES"
#DPOY 46
grep("Rudy Gobert", test$player_name)
test2[37, 46] <- "YES"
#ROY 47
grep("Ben Simmons", test$player_name)
test2[168, 47] <- "YES"

test3<-format(test2, digits = 11)

write.csv(test3, file = "2019_data.csv")
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

