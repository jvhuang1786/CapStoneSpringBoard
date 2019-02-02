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
age <- read.csv("2017_age.csv")
salary <- read.csv("hoops_hype_salary_2017.csv")
stat <- read.csv("2017_stats.csv")



#Stats have 595 observations, age has 495 observations, salary has 546 observations. 

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

age_2018 <- age[-c(51,102,153,204,255,306,357,408,459),]

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
grep("Danuel House", stat$player_name, value = TRUE)
stat$player_name<-gsub("Danuel House", "Danuel House Jr", stat$player_name)

grep("Derrick Jones", stat$player_name, value = TRUE) # 3 derrik jones 
stat$player_name<-gsub("Derrick Jones", "Derrick Jones Jr", stat$player_name)

grep("Kelly Oubre",stat$player_name, value = TRUE)
stat$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", stat$player_name)

grep("Larry Nance", stat$player_name, value = TRUE) 
stat$player_name<-gsub("Larry Nance", "Larry Nance Jr", stat$player_name)

grep("Tim Hardaway", stat$player_name, value = TRUE) 
stat$player_name<-gsub("Tim Hardaway", "Tim Hardaway Jr", stat$player_name)
grep("Otto Porter", stat$player_name, value = TRUE)
stat$player_name<-gsub("Otto Porter", "Otto Porter Jr", stat$player_name)


#testing salary 

grep("Danuel House", salary$player_name, value = TRUE)
salary$player_name<-gsub("Danuel House", "Danuel House Jr", salary$player_name)

grep("Derrick Jones", salary$player_name, value = TRUE) 
salary$player_name<-gsub("Derrick Jones", "Derrick Jones Jr", salary$player_name)

grep("Kelly Oubre", salary$player_name, value = T)
salary$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", salary$player_name)
grep("Larry Nance", salary$player_name, value = T)
salary$player_name<-gsub("Larry Nance Jr Jr", "Larry Nance Jr", salary$player_name)

grep("Otto Porter", salary$player_name, value = TRUE)
salary$player_name<-gsub("Otto Porter", "Otto Porter Jr", salary$player_name)



#testing age # remove walter lemon 



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

#Will use last team played for when doing full join so remove duplicates 

stat<- stat[-c(3 ,  4,  16,  17,  34,  35,  57,  58,  60,  61,  67,  68,  72,  73,  83,  84,  92,  93,  94, 109, 110, 112, 113, 141, 142, 152, 153, 155, 156, 165,
                            166, 175, 176, 187, 188, 192, 193, 199, 200, 224, 225, 233, 234, 236, 237, 256, 257, 260, 261, 262, 275, 276, 291, 292, 303, 304, 311, 312, 324, 325,
                            351, 352, 354, 355, 357, 358, 379, 380, 396, 397, 400, 401, 406, 407, 410, 411, 430, 431, 437, 438, 440, 441, 452, 453, 469, 470, 485, 486, 502, 503,
                          504, 510, 511, 520, 521, 528, 529, 532, 533, 556, 557, 567, 568, 570, 571, 573, 574, 578, 579),]



rownames(stat) <- NULL 

#clean up unused columns 

stat <- stat[,-5]

#clean up unnecessary rows in age

age <- age[,-c(3,12:16)]

#time to combine all of 2019 

data <- full_join(salary, age, by = "player_name")
data <- full_join(data, stat, by = "player_name")

#have to fill in the N/As now.  
colnames(data)[2] <- "salary"
sum(is.na(data$salary)) #30 missing
which(data$player_name == "PLAYER")
data <- data[-c(546, 547,552,561,564,566,568,570),]
rownames(data) <- NULL 
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
miss_sal<-read.csv("missing_salary_2017.csv", header = F)

colnames(miss_sal)[1:39] <- c("player_name", "salary", "TEAM",  "HEIGHT", "WEIGHT", "COLLEGE", "COUNTRY", "DRAFT.YEAR",
                                   "DRAFT.ROUND", "DRAFT.NUMBER", "NETRTG", "player_id", "Pos", "Age", "G", "GS", "MP", "FG", "FGA",
                                   "FG.", "X3P", "X3PA", "X3P.", "X2P", "X2PA", "X2P.", "eFG.", "FT", "FTA", "FT.", "ORB", "DRB",
                                   "TRB", "AST", "STL", "BLK", "TOV", "PF", "ppg") 


data <- data[-c(546:567),]
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
data <- data[-c(549,557,563),]
rownames(data) <- NULL 
#time to look at age and stats

which(is.na(data$TEAM))
sum(is.na(data$TEAM))
data %>% filter(is.na(TEAM))
options(max.print = 999999999)


data <- data[-c(11,  83, 119, 131, 141, 147, 151, 166, 171, 178, 188, 220, 234, 246, 255, 271, 276, 279, 288, 307, 317, 324, 345, 347, 350, 351, 367, 368, 375, 386, 392,
                 395, 411, 414, 418, 421, 427, 454, 482, 489, 490, 496, 498, 503, 504, 507, 508, 509, 510, 514, 515, 516, 517, 518, 519, 523, 524, 525, 526, 527, 528, 529,
                 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544),]



rownames(data) <- NULL 

##----Testing NAs in stat_2018 
which(is.na(data$ppg))
data %>% filter(is.na(ppg))

grep("Taurean", data$player_name) # duplicate
grep("Taurean", data$player_name, value =T)
grep("Glenn Robinson", data$player_name) #duplicate
grep("Glenn Robinson", data$player_name, value = T)
grep("Gary Payton", data$player_name) #duplicate 
grep("Gary Payton", data$player_name, value = T)
data <- data[-c(279, 366, 417),] 
rownames(data) <- NULL 

#add in the II and III
data$player_name <- gsub("Glenn Robinson", "Glenn Robinson III",data$player_name)
data$player_name <- gsub("Gary Payton", "Gary Payton II",data$player_name)

#doublecheck if all nas are gone. 
which(is.na(data$TEAM))
which(is.na(data$ppg))
which(is.na(data$salary))

#adding tax and inflation 
tax <- read.csv("state_income.csv")
data<-full_join(data, tax, by = "TEAM")


inflation <- read.csv("inflation.csv")
data["inflation"] <- 1.3



#add in player id by the year
data$player_id <- "2017"


# adding team wins

team_wins<-read.csv("team_wins.csv")
team_wins <- team_wins[,-c(2,3,5:21)]
colnames(team_wins)[2] <- "wins"
data<-full_join(data, team_wins, by = "TEAM")

data <- data[-c(484:485),]

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

#Nba first team
#Lebron james 
grep("LeBron James", test$player_name)
test[1, 48] <- "YES"

#Kawhi Leonard
grep("Kawhi Leonard", test$player_name)

test[34, 48] <- "YES" 

#Stephen Curry

grep("Stephen Curry", test$player_name)

test[81, 48] <- "YES"

#Russell Westbrook 

grep("Russell Westbrook", test$player_name)

test[6,48] <- "YES"

#DeAndre Jordan 

grep("DeAndre Jordan", test$player_name)

test[23, 48] <- "YES" 

#NBA second team 

#Kevin Durant	
grep("Kevin Durant", test$player_name)

test[3, 49] <- "YES"

#Draymond Green 
grep("Draymond Green", test$player_name)

test[54, 49] <- "YES"

#DeMarcus Cousins
grep("DeMarcus Cousins", test$player_name)
test[49, 49] <- "YES"
#Chris Paul
grep("Chris Paul", test$player_name)
test[13, 49] <- "YES"
#Damian Lillard
grep("Damian Lillard", test$player_name)
test[10, 49] <- "YES"

#NBA third team 

#Paul George
grep("Paul George", test$player_name)
test[31, 50] <- "YES"
#LaMarcus Aldridge
grep("LaMarcus Aldridge", test$player_name)
test[26, 50] <- "YES"
#Andre Drummond
grep("Andre Drummond", test$player_name)
test[15, 50] <- "YES"
#Klay Thompson
grep("Klay Thompson", test$player_name)
test[43, 50] <- "YES"
#Kyle Lowry
grep("Kyle Lowry", test$player_name)
test[86, 50] <- "YES"

#All Rookie 1st team


#Karl-Anthony Towns
grep("Karl-Anthony Towns", test$player_name)
test[162, 51] <- "YES"
#Kristaps Porzingis
grep("Kristaps Porzingis", test$player_name)
test[205, 51] <- "YES"
#Devin Booker	
grep("Devin Booker", test$player_name)
test[284, 51] <- "YES"
#Jahlil Okafor
grep("Jahlil Okafor", test$player_name)
test[197, 51] <- "YES"
#Nikola Jokic	(Knicks)
grep("Nikola Jokic", test$player_name)
test[337, 51] <- "YES"


#All rookie Second Team
#Justise Winslow	(Nuggets)
grep("Justise Winslow", test$player_name)
test[265, 52] <- "YES"
#D'Angelo Russell	(Celtics)
grep("D'Angelo Russell", test$player_name)
test[177, 52] <- "YES"
#Emmanuel Mudiay	(Suns)
grep("Emmanuel Mudiay", test$player_name)
test[238, 52] <- "YES"
#Myles Turner	(Lakers)
grep("Myles Turner", test$player_name)
test[273, 52] <- "YES"
#Willie Cauley-Stein	(Nets / Mavericks)
grep("Willie Cauley-Stein", test$player_name)
test[224, 52] <- "YES"

#All defensive first team


#DeAndre Jordan
grep("DeAndre Jordan", test$player_name)
test[23, 53] <- "YES"
#Kawhi Leonard	
grep("Kawhi Leonard", test$player_name)
test[34, 53] <- "YES"
#Draymond Green
grep("Draymond Green", test$player_name)
test[54, 53] <- "YES"
#Chris Paul
grep("Chris Paul", test$player_name)
test[13, 53] <- "YES"
#Avery Bradley
grep("Avery Bradley", test$player_name)
test[122, 53] <- "YES"
#All defensive second team 


#Paul Millsap
grep("Paul Millsap", test$player_name)
test[28, 54] <- "YES"
#Paul George
grep("Paul George", test$player_name)
test[31, 54] <- "YES"
#Hassan Whiteside
grep("Hassan Whiteside", test$player_name)
test[17, 54] <- "YES"
#Tony Allen
grep("Tony Allen", test$player_name)
test[189, 54] <- "YES"
#Jimmy Butler
grep("Jimmy Butler", test$player_name)
test[35, 54] <- "YES"

#MVP 43
grep("Stephen Curry", test$player_name)
test[81, 43] <- "YES"
#MIP 44
grep("CJ McCollum", test$player_name)
test[239, 44] <- "YES"
#6th man 45 
grep("Jamal Crawford", test$player_name)
test[68, 45] <- "YES"
#DPOY 46
grep("Kawhi Leonard", test$player_name)
test[34, 46] <- "YES"
#ROY 47
grep("Karl-Anthony Towns", test$player_name)
test[162, 47] <- "YES"

test<-format(test, digits = 11)

write.csv(test, file = "2017_data.csv")