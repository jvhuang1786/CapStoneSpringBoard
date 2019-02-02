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
age <- read.csv("2013_age.csv")
salary <- read.csv("hoops_hype_salary_2013.csv")
stat <- read.csv("2013_stats.csv")


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

age <- age[,-c(16:20)]
age <- age[,-c(11:14)]



#remove rows that have Player 

y<-which(age$PLAYER == "PLAYER")

age <- age[-c(y),]

#Change PLAYER to player_name 
names(age)[1]<-paste("player_name") 

#getting rid of periods in name 
grep("\\.",age$player_name)
age$player_name <- gsub("\\.","", age$player_name)
grep(".Jr$", age$player_name, value = TRUE) # 6 Jrs here.  
grep("Glen Rice", age$player_name, value = TRUE)
grep(".Jr$",stat$player_name, value = TRUE) 

#look through all stats for which one junior is missing for a total of 13 was missing in stats. 
grep(".Jr$", salary$player_name, value = TRUE)
#[1] "Tim Hardaway Jr" "Larry Nance Jr"  


##### Filling all the juniors 
#testing stat 
#Glen Rice Jr, Otto Porter Jr Tim Hardaway Jr Roger Mason Jr 

grep("Roger Mason",stat$player_name, value = TRUE)
stat$player_name<-gsub("Roger Mason", "Roger Mason Jr", stat$player_name)



#testing salary 




grep("Roger Mason",salary$player_name, value = TRUE)
salary$player_name<-gsub("Roger Mason", "Roger Mason Jr", salary$player_name)


#-------------------------
#nene hilario weird spelling 
grep("^Ne", stat$player_name, value = TRUE)
grep("^Nene", age$player_name, value = TRUE) # located in age 
grep("^Ne", age$player_name)
age$player_name <- gsub("Nene", "Nene Hilario", age$player_name) 
grep("^Nen", salary$player_name, value = TRUE)
salary$player_name <- gsub("Nenê", "Nene Hilario", salary$player_name)


#multiple trade scenarios where a player ended up on different teams 
which(duplicated(stat$player_name))
sum(duplicated(stat$player_name))
stat %>% group_by(player_name) %>% filter(n() > 1)
a<-which(duplicated(stat$player_name))
#Will use last team played for when doing full join so remove duplicates 

stat<- stat[-c(a),]



rownames(stat) <- NULL 

#clean up unused columns 

stat <- stat[,-5]

#clean up unnecessary rows in age

age <- age[,-c(3)]

#time to combine all of them 

data <- full_join(salary, age, by = "player_name")
data <- full_join(data, stat, by = "player_name")

#have to fill in the N/As now.  
colnames(data)[2] <- "salary"
sum(is.na(data$salary)) 
which(is.na(data$salary))
grep("Patty Mills", data)
sum(is.na(data$TEAM)) 
sum(is.na(data$ppg)) 


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
miss_sal<-read.csv("missing_salary_2013.csv", header = F)

colnames(miss_sal)[1:39] <- c("player_name", "salary", "TEAM",  "HEIGHT", "WEIGHT", "COLLEGE", "COUNTRY", "DRAFT.YEAR",
                              "DRAFT.ROUND", "DRAFT.NUMBER", "NETRTG", "player_id", "Pos", "Age", "G", "GS", "MP", "FG", "FGA",
                              "FG.", "X3P", "X3PA", "X3P.", "X2P", "X2PA", "X2P.", "eFG.", "FT", "FTA", "FT.", "ORB", "DRB",
                              "TRB", "AST", "STL", "BLK", "TOV", "PF", "ppg") 
x<-which(is.na(data$salary))

data <- data[-c(x),]
data<-rbind(data,miss_sal)

#Making salary into numeric 
data$salary <- str_replace(data$salary, "\\$", "")
data$salary <- str_replace_all(data$salary, ",", "")
data$salary <- as.numeric(data$salary)


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

#doublecheck if all nas are gone. 
which(is.na(data$TEAM))
which(is.na(data$ppg))
which(is.na(data$salary))

#adding tax and inflation 
tax <- read.csv("state_income.csv")
data<-full_join(data, tax, by = "TEAM")


inflation <- read.csv("inflation.csv")
data["inflation"] <- 2.1

#add in player id by the year
data$player_id <- "2013"


# adding team wins

team_wins<-read.csv("team_wins.csv")
team_wins <- team_wins[,-c(2:7,9:21)]
colnames(team_wins)[2] <- "wins"
data<-full_join(data, team_wins, by = "TEAM")

f<-which(is.na(data$player_name))
data <- data[-c(f),]

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

#----------------------#


#Nba first team

a1<-grep("LeBron James", test$player_name)
test[a1, 48] <- "YES"
a2<-grep("Kevin Durant", test$player_name)
test[a2, 48] <- "YES" 
a3<-grep("Kobe Bryant", test$player_name)
test[a3, 48] <- "YES"
a4<-grep("Chris Paul", test$player_name)
test[a4,48] <- "YES"
a5<-grep("Dwight Howard", test$player_name)
test[a5, 48] <- "YES" 

#NBA second team 

a6<-grep("Andrew Bynum", test$player_name)
test[a6, 49] <- "YES"
a7<-grep("Blake Griffin", test$player_name)
test[a7, 49] <- "YES"
a8<-grep("Tony Parker", test$player_name)
test[a8, 49] <- "YES"
a9<-grep("Russell Westbrook", test$player_name)
test[a9, 49] <- "YES"
a10<-grep("Kevin Love", test$player_name)
test[a10, 49] <- "YES"

#NBA third team 

a11<-grep("Carmelo Anthony", test$player_name)
test[a11, 50] <- "YES"
a12 <-grep("Dirk Nowitzki", test$player_name)
test[a12, 50] <- "YES"
a13 <-grep("Dwyane Wade", test$player_name)
test[a13, 50] <- "YES"
a14<-grep("Rajon Rondo", test$player_name)
test[a14, 50] <- "YES"
a15<-grep("Tyson Chandler", test$player_name)
test[a15, 50] <- "YES"

#All Rookie 1st team

r1<-grep("Kenneth Faried", test$player_name)
test[r1, 51] <- "YES"
r2<-grep("Kyrie Irving", test$player_name)
test[r2, 51] <- "YES"
r3<-grep("Ricky Rubio", test$player_name)
test[r3, 51] <- "YES"
r4<-grep("Klay Thompson", test$player_name)
test[r4, 51] <- "YES"
r5<-grep("Brandon Knight", test$player_name)
test[r5, 51] <- "YES"
r11<-grep("Kawhi Leonard", test$player_name)
test[r11, 51] <- "YES"
r12<-grep("Iman Shumpert", test$player_name)
test[r2, 51] <- "YES"

#All rookie Second Team

r6<-grep("MarShon Brooks", test$player_name)
test[r6, 52] <- "YES"
r7<-grep("Chandler Parsons", test$player_name)
test[r7, 52] <- "YES"
r8<-grep("Isaiah Thomas", test$player_name)
test[r8, 52] <- "YES"
r9<-grep("Tristan Thompson", test$player_name)
test[r9, 52] <- "YES"
r10<-grep("Derrick Williams", test$player_name)
test[r10, 52] <- "YES"

#All defensive first team

d1<-grep("LeBron James", test$player_name)
test[d1, 53] <- "YES"
d2<-grep("Serge Ibaka", test$player_name)
test[d2, 53] <- "YES"
d3<-grep("Dwight Howard", test$player_name)
test[d3, 53] <- "YES"
d4<-grep("Chris Paul", test$player_name)
test[d4, 53] <- "YES"
d5<-grep("Tony Allen", test$player_name)
test[d5, 53] <- "YES"
#All defensive second team 

d6<-grep("Kobe Bryant", test$player_name)
test[d6, 54] <- "YES"
d7<-grep("Tyson Chandler", test$player_name)
test[d7, 54] <- "YES"
d8<-grep("Luol Deng", test$player_name)
test[d8, 54] <- "YES"
d9<-grep("Kevin Garnett", test$player_name)
test[d9, 54] <- "YES"
d10<-grep("Rajon Rondo", test$player_name)
test[d10, 54] <- "YES"

#MVP 43
mvp<-grep("LeBron James", test$player_name)
test[mvp, 43] <- "YES"
#MIP 44
mip<-grep("Ryan Anderson", test$player_name)
test[mip, 44] <- "YES"
#6th man 45 
sixth<-grep("James Harden", test$player_name)
test[sixth, 45] <- "YES"
#DPOY 46
dpoy<-grep("Tyson Chandler", test$player_name)
test[dpoy, 46] <- "YES"
#ROY 47
roy<-grep("Kyrie Irving", test$player_name)
test[roy, 47] <- "YES"

test<-format(test, digits = 11)

write.csv(test, file = "2013_data.csv")