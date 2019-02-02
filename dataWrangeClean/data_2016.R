#loading the data packages 
library(dplyr)
library(tidyr)
library(purrr)
library(stringr)

#seeing what directory I am in
getwd()

#setting the directory 

setwd("/users/justinvhuang/desktop/nba_stat_salaries")
getwd()

#Loading in 2018 data 
age <- read.csv("2016_age.csv")
salary <- read.csv("hoops_hype_salary_2016.csv")
stat <- read.csv("2016_stats.csv")



#Stats have 578 observations, age has 485 observations, salary has 501 observations. 

# clean up stats

stat

#remove rank column 

stat <- stat[,-c(1)]

#Seperate player and player id 

stat <- stat %>% separate(Player, c("player_name", "player_id"),"\\\\")

##Clean up to remove . from stat_2018
grep("\\.", stat$player_name, value = TRUE)
stat$player_name<- gsub("\\.", "", stat$player_name)
grep("\\.", stat$player_name, value = TRUE)
names(stat)
stat$Age <- as.numeric(stat$Age)
colnames(stat)[30] <- "ppg"

##Clean up salary 

salary <- salary[,-c(1,2)]

salary <- salary[-1,]

colnames(salary) <- c("player_name", "salary")

rownames(salary) <- NULL

grep("\\.",salary$player_name)
grep(".Jr$", salary$player_name, value = TRUE) # 3 Jrs 

#remove columns from age data 

age

age <- age[,-c(11:14)]

#remove rows that have Player 

which(age$PLAYER == "PLAYER")

age <- age[-c(51,102,153,204,255,306,357,408,459),]

#Change PLAYER to player_name 
names(age)[1]<-paste("player_name") 

#getting rid of periods in name 
grep("\\.",age$player_name)
age$player_name <- gsub("\\.","", age$player_name)
grep(".Jr$", age$player_name, value = TRUE) # 6 Jrs here.  

grep(".Jr$",stat$player_name, value = TRUE) 

#look through all stats for which one junior is missing for a total of 13 was missing in stats. 
grep(".Jr$", salary$player_name, value = TRUE)
#[1] "Tim Hardaway Jr" "Larry Nance Jr"  


##### Filling all the juniors 
#testing stat 
# "Danuel House Jr"  "Derrick Jones Jr" "Kelly Oubre Jr"   "Larry Nance Jr"   "Otto Porter Jr"   "Tim Hardaway Jr" 


grep("Kelly Oubre",stat$player_name, value = TRUE)
stat$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", stat$player_name)

grep("Larry Nance", stat$player_name, value = TRUE) 
stat$player_name<-gsub("Larry Nance", "Larry Nance Jr", stat$player_name)

grep("Tim Hardaway", stat$player_name, value = TRUE) 
stat$player_name<-gsub("Tim Hardaway", "Tim Hardaway Jr", stat$player_name)
grep("Otto Porter", stat$player_name, value = TRUE)
stat$player_name<-gsub("Otto Porter", "Otto Porter Jr", stat$player_name)


#testing salary 



grep("Kelly Oubre", salary$player_name, value = T)
salary$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", salary$player_name)


grep("Otto Porter", salary$player_name, value = TRUE)
salary$player_name<-gsub("Otto Porter", "Otto Porter Jr", salary$player_name)





#-------------------------
#nene hilario weird spelling 
grep("^Ne", stat$player_name, value = TRUE)
grep("^Nene", age$player_name, value = TRUE) # located in age 
grep("^Ne", age$player_name)
age$player_name <- gsub("Nene", "Nene Hilario", age$player_name) 
grep("^Nen", salary$player_name, value = TRUE)
salary$player_name <- gsub("Nenê", "Nene Hilario", salary$player_name)


#multiple trade scenarios where a player ended up on different teams 
a<-which(duplicated(stat$player_name))
sum(duplicated(stat$player_name))
stat %>% group_by(player_name) %>% filter(n() > 1)
a<-which(duplicated(stat$player_name))
#Will use last team played for when doing full join so remove duplicates 

stat<- stat[-c(a),]



rownames(stat) <- NULL 

#clean up unused columns 

stat <- stat[,-5]

#clean up unnecessary rows in age

age <- age[,-c(3,12:16)]

#time to combine all of them 

data <- full_join(salary, age, by = "player_name")
data <- full_join(data, stat, by = "player_name")

#have to fill in the N/As now.  
colnames(data)[2] <- "salary"
sum(is.na(data$salary)) #30 missing
which(is.na(data$salary))
grep("Patty Mills", data)
sum(is.na(data$TEAM)) #80 missing
sum(is.na(data$ppg)) #89 missing 


#find duplicated rows
which(duplicated(data$player_name))


#change the height data so it's not in date format 
data$HEIGHT <- gsub("Jun", "6", data$HEIGHT, fixed=TRUE)
data$HEIGHT <- gsub("Jul", "7", data$HEIGHT, fixed=TRUE)
data$HEIGHT <- gsub("May", "5", data$HEIGHT, fixed=TRUE)


data$HEIGHT[which(data$HEIGHT == "11-6")] = '6-11"'
data$HEIGHT[which(data$HEIGHT == "10-6")] = '6-10"'
data$HEIGHT[which(data$HEIGHT == "9-6")] = '6-9"'
data$HEIGHT[which(data$HEIGHT == "8-6")] = '6-8"'
data$HEIGHT[which(data$HEIGHT == "7-6")] = '6-7"'
data$HEIGHT[which(data$HEIGHT == "5-6")] = '6-5"'
data$HEIGHT[which(data$HEIGHT == "4-6")] = '6-4"'
data$HEIGHT[which(data$HEIGHT == "3-6")] = '6-3"'
data$HEIGHT[which(data$HEIGHT == "2-6")] = '6-2"'
data$HEIGHT[which(data$HEIGHT == "1-6")] = '6-1"'
data$HEIGHT[which(data$HEIGHT == "6-00")] = '6-0"'
data$HEIGHT[which(data$HEIGHT == "11-5")] = '5-11"'
data$HEIGHT[which(data$HEIGHT == "10-5")] = '5-10"'
data$HEIGHT[which(data$HEIGHT == "9-5")] = '5-9"'
data$HEIGHT[which(data$HEIGHT == "8-5")] = '5-8"'
data$HEIGHT[which(data$HEIGHT == "7-5")] = '5-7"'
data$HEIGHT[which(data$HEIGHT == "1-7")] = '7-1"'
data$HEIGHT[which(data$HEIGHT == "2-7")] = '7-2"'
data$HEIGHT[which(data$HEIGHT == "3-7")] = '7-3"'
data$HEIGHT[which(data$HEIGHT == "7-00")] = '7-0"'
data$HEIGHT[which(data$HEIGHT == "6'6")] = "6'6\""

#change the symbols - to 4'2"
data$HEIGHT <- gsub("-", "'", data$HEIGHT, fixed=TRUE)

grep("[I]", data$player_name, value = TRUE)

#--------------------------#
miss_sal<-read.csv("missing_salary_2016.csv", header = F)

colnames(miss_sal)[1:39] <- c("player_name", "salary", "TEAM",  "HEIGHT", "WEIGHT", "COLLEGE", "COUNTRY", "DRAFT.YEAR",
                              "DRAFT.ROUND", "DRAFT.NUMBER", "NETRTG", "player_id", "Pos", "Age", "G", "GS", "MP", "FG", "FGA",
                              "FG.", "X3P", "X3PA", "X3P.", "X2P", "X2PA", "X2P.", "eFG.", "FT", "FTA", "FT.", "ORB", "DRB",
                              "TRB", "AST", "STL", "BLK", "TOV", "PF", "ppg") 


data <- data[-c(501:517),]
data<-rbind(data,miss_sal)

grep("Dennis", data$player_name, value = T) # different spelling problems 
grep("Dennis", data$player_name)
#####-------------------------------#####

#removing player duplicates from salary 
grep("^Juan.", data$player_name, value = TRUE)
grep("^Juan.", data$player_name)


grep(".II$", data$player_name, value = TRUE)
grep("IV", data$player_name, value = TRUE)
grep("IV", data$player_name)
grep("Wade Baldwin", data$player_name) # these will be removed when I remove duplicates from age and stats 


library(stringr)
data$salary <- str_replace(data$salary, "\\$", "")
data$salary <- str_replace_all(data$salary, ",", "")
data$salary <- as.numeric(data$salary)

which(is.na(data$salary))
data <- data[-c(502),]
rownames(data) <- NULL 
#time to look at age and stats

which(is.na(data$TEAM))
sum(is.na(data$TEAM))
data %>% filter(is.na(TEAM))
options(max.print = 999999999)
b<-which(is.na(data$TEAM))



data <- data[-c(b),]



rownames(data) <- NULL 

##----Testing NAs in stat_2018 
which(is.na(data$ppg))
data %>% filter(is.na(ppg))
c<-which(is.na(data$ppg))
data <- data[-c(c),] 
rownames(data) <- NULL 

#add in the II and III
grep("Glenn Robinson", data$player_name, value = TRUE)
data$player_name <- gsub("Glenn Robinson", "Glenn Robinson III",data$player_name)


#doublecheck if all nas are gone. 
which(is.na(data$TEAM))
which(is.na(data$ppg))
which(is.na(data$salary))

#adding tax and inflation 
tax <- read.csv("state_income.csv")
data<-full_join(data, tax, by = "TEAM")


inflation <- read.csv("inflation.csv")
data["inflation"] <- 0.1



#add in player id by the year
data$player_id <- "2016"


# adding team wins

team_wins<-read.csv("team_wins.csv")
team_wins <- team_wins[,-c(2:4,6:21)]
colnames(team_wins)[2] <- "wins"
data<-full_join(data, team_wins, by = "TEAM")


data1 <- data[-c(478:479),]

#time to add the awards from the year before 
#counting the number of times each player won the award nba first team

rapply(nba_1_team,function(x)length(unique(x)))
unique(nba_1_team$player_name)


# make a column if they won the awards the previous year.  #make columns for awards
test <- data
test["MVP"] <- "NO"
test["MIP"] <- "NO"
test["Sixth_man"] <- "NO"
test["DPOY"] <- "NO"
test["ROY"] <- "NO"
test["NBA_1"] <- "NO"
test["NBA_2"] <- "NO"
test["NBA_3"] <- "NO"
test["Rookie_1"] <- "NO"
test["Rookie_2"] <- "NO"
test["Def_1"] <- "NO"
test["Def_2"] <- "NO"

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
#----------------------#


#Nba first team
grep("LeBron James", test$player_name)
test[2, 48] <- "YES"
grep("Anthony Davis", test$player_name)
test[109, 48] <- "YES" 
grep("Stephen Curry", test$player_name)
test[65, 48] <- "YES"
grep("Marc Gasol", test$player_name)
test[14,48] <- "YES"
grep("James Harden", test$player_name)
test[28, 48] <- "YES" 

#NBA second team 
grep("LaMarcus Aldridge", test$player_name)
test[15, 49] <- "YES"
grep("DeMarcus Cousins", test$player_name)
test[35, 49] <- "YES"
grep("Pau Gasol", test$player_name)
test[105, 49] <- "YES"
grep("Russell Westbrook", test$player_name)
test[20, 49] <- "YES"
grep("Chris Paul", test$player_name)
test[8, 49] <- "YES"

#NBA third team 
grep("Blake Griffin", test$player_name)
test[16, 50] <- "YES"
grep("Tim Duncan", test$player_name)
test[143, 50] <- "YES"
grep("DeAndre Jordan", test$player_name)
test[13, 50] <- "YES"
grep("Klay Thompson", test$player_name)
test[31, 50] <- "YES"
grep("Kyrie Irving", test$player_name)
test[22, 50] <- "YES"

#All Rookie 1st team
grep("Andrew Wiggins", test$player_name)
test[128, 51] <- "YES"
grep("Nikola Mirotic", test$player_name)
test[136, 51] <- "YES"
grep("Elfrid Payton", test$player_name)
test[243, 51] <- "YES"
grep("Jordan Clarkson", test$player_name)
test[396, 51] <- "YES"
grep("Nerlens Noel", test$player_name)
test[198, 51] <- "YES"


#All rookie Second Team
grep("Marcus Smart", test$player_name)
test[199, 52] <- "YES"
#D'Angelo Russell	(Celtics)
grep("Zach LaVine", test$player_name)
test[263, 52] <- "YES"
#Emmanuel Mudiay	(Suns)
grep("Bojan Bogdanovic", test$player_name)
test[201, 52] <- "YES"
#Myles Turner	(Lakers)
grep("Jusuf Nurkic", test$player_name)
test[281, 52] <- "YES"
#Willie Cauley-Stein	(Nets / Mavericks)
grep("Langston Galloway", test$player_name)
test[402, 52] <- "YES"

#All defensive first team
grep("DeAndre Jordan", test$player_name)
test[13, 53] <- "YES"
grep("Kawhi Leonard", test$player_name)
test[26, 53] <- "YES"
grep("Draymond Green", test$player_name)
test[38, 53] <- "YES"
grep("Chris Paul", test$player_name)
test[8, 53] <- "YES"
grep("Tony Allen", test$player_name)
test[155, 53] <- "YES"
#All defensive second team 
grep("Anthony Davis", test$player_name)
test[109, 54] <- "YES"
grep("Andrew Bogut", test$player_name)
test[60, 54] <- "YES"
grep("John Wall", test$player_name)
test[36, 54] <- "YES"
grep("Tim Duncan", test$player_name)
test[143, 54] <- "YES"
grep("Jimmy Butler", test$player_name)
test[21, 54] <- "YES"

#MVP 43
grep("Stephen Curry", test$player_name)
test[65, 43] <- "YES"
#MIP 44
grep("Jimmy Butler", test$player_name)
test[21, 44] <- "YES"
#6th man 45 
grep("Lou Williams", test$player_name)
test[471, 45] <- "YES"
#DPOY 46
grep("Kawhi Leonard", test$player_name)
test[26, 46] <- "YES"
#ROY 47
grep("Andrew Wiggins", test$player_name)
test[128, 47] <- "YES"

test<-format(test, digits = 11)

write.csv(test, file = "2016_data.csv")