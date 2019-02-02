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
age_2018 <- read.csv("2018_age.csv")
salary_2018 <- read.csv("hoops_hype_salary_2018.csv")
stat_2018 <- read.csv("2018_stats.csv")



#Stats have 664 observations, age has 550 observations, salary has 587 observations. 

# clean up stats

stat_2018

#remove rank column 

stat_2018 <- stat_2018[,-c(1)]

#Seperate player and player id 

stat_2018 <- stat_2018 %>% separate(Player, c("player_name", "player_id"),"\\\\")

##Clean up to remove . from stat_2018
grep("\\.", stat_2018$player_name, value = TRUE)
stat_2018$player_name<- gsub("\\.", "", stat_2018$player_name)
grep("\\.", stat_2018$player_name, value = TRUE)
names(stat_2018)
stat_2018$Age <- as.numeric(stat_2018$Age)
colnames(stat_2018)[30] <- "ppg"

##Clean up salary 

salary_2018 <- salary_2018[,-c(1,2)]

salary_2018 <- salary_2018[-1,]

colnames(salary_2018) <- c("player_name", "salary")

rownames(salary_2018) <- NULL

grep("\\.",salary_2018$player_name)
grep(".Jr$", salary_2018$player_name, value = TRUE) # 3 Jrs 

#remove columns from age data 

age_2018

age_2018 <- age_2018[,-c(11:14)]

#remove rows that have Player 

which(age_2018$PLAYER == "PLAYER")

age_2018 <- age_2018[-c(51,102,153,204,255,306,357,408,459,510),]

#Change PLAYER to player_name 
names(age_2018)[1]<-paste("player_name") 

#getting rid of periods in name 
grep("\\.",age_2018$player_name)
age_2018$player_name <- gsub("\\.","", age_2018$player_name)
grep(".Jr$", age_2018$player_name, value = TRUE) # 10 Jrs here.  
#[1] "Danuel House Jr"   "Dennis Smith Jr"   "Derrick Jones Jr"  "Derrick Walton Jr" "Kelly Oubre Jr"    "Larry Nance Jr"   
#[7] "Matt Williams Jr"  "Otto Porter Jr"    "Tim Hardaway Jr"   "Walter Lemon Jr"  

grep(".Jr$",stat_2018$player_name, value = TRUE) 
#[1] "Walt Lemon Jr"
#look through all stats for which one junior is missing for a total of 13 was missing in stats. 
grep(".Jr$", salary_2018$player_name, value = TRUE)
#[1] "Tim Hardaway Jr" "Larry Nance Jr"  "Walter Lemon Jr"


##### Filling all the juniors 
#testing stat 
grep("Danuel House", stat_2018$player_name, value = TRUE)
stat_2018$player_name<-gsub("Danuel House", "Danuel House Jr", stat_2018$player_name)
grep("Dennis Smith", stat_2018$player_name, value = TRUE)
stat_2018$player_name<-gsub("Dennis Smith", "Dennis Smith Jr", stat_2018$player_name)
grep("Derrick Jones", stat_2018$player_name, value = TRUE) # 3 derrik jones 
stat_2018$player_name<-gsub("Derrick Jones", "Derrick Jones Jr", stat_2018$player_name)

grep("Derrick Walton", stat_2018$player_name, value = TRUE)
stat_2018$player_name<-gsub("Derrick Walton", "Derrick Walton Jr", stat_2018$player_name)

grep("Kelly Oubre",stat_2018$player_name, value = TRUE)

stat_2018$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", stat_2018$player_name)

grep("Larry Nance", stat_2018$player_name, value = TRUE) #3 Larry Nance Jr trade 

stat_2018$player_name<-gsub("Larry Nance", "Larry Nance Jr", stat_2018$player_name)

grep("Matt Williams", stat_2018$player_name, value = TRUE)

stat_2018$player_name<-gsub("Matt Williams", "Matt Williams Jr", stat_2018$player_name)

grep("Otto Porter", stat_2018$player_name, value = TRUE)

stat_2018$player_name<-gsub("Otto Porter", "Otto Porter Jr", stat_2018$player_name)

grep("Tim Hardaway", stat_2018$player_name, value = TRUE)

stat_2018$player_name<-gsub("Tim Hardaway", "Tim Hardaway Jr", stat_2018$player_name)


grep("Walter Lemon", stat_2018$player_name) # missing #googled and was cut after a 3rd 10 day contract not worth keeping

#testing salary 
#[1] "Danuel House Jr"   "Dennis Smith Jr"   "Derrick Jones Jr"  "Derrick Walton Jr" "Kelly Oubre Jr"    "Larry Nance Jr"   
#[7] "Matt Williams Jr"  "Otto Porter Jr"    "Tim Hardaway Jr"   "Walter Lemon Jr"  
grep("Danuel House", salary_2018$player_name, value = TRUE)
salary_2018$player_name<-gsub("Danuel House", "Danuel House Jr", salary_2018$player_name)
grep("Dennis Smith", salary_2018$player_name, value = TRUE)
salary_2018$player_name<-gsub("Dennis Smith", "Dennis Smith Jr", salary_2018$player_name)
grep("Derrick Jones", salary_2018$player_name, value = TRUE) 
salary_2018$player_name<-gsub("Derrick Jones", "Derrick Jones Jr", salary_2018$player_name)
grep("Derrick Walton", salary_2018$player_name)
salary_2018$player_name<-gsub("Derrick Walton", "Derrick Walton Jr", salary_2018$player_name)
grep("Kelly Oubre", salary_2018$player_name)
salary_2018$player_name<-gsub("Kelly Oubre", "Kelly Oubre Jr", salary_2018$player_name)
grep("Larry Nance", salary_2018$player_name, value = T)
salary_2018$player_name<-gsub("Larry Nance Jr Jr", "Larry Nance Jr", salary_2018$player_name)
grep("Matt Williams", salary_2018$player_name, value = TRUE)
salary_2018$player_name<-gsub("Matt Williams", "Matt Williams Jr", salary_2018$player_name)
salary_2018$player_name<-gsub("Otto Porter", "Otto Porter Jr", salary_2018$player_name)
grep("Otto Porter", salary_2018$player_name, value = TRUE)

grep("Walter Lemon", salary_2018$player_name)
salary_2018 <- salary_2018[-506,]



#testing age # remove walter lemon 
grep("Walter Lemon", age_2018$player_name)
age_2018 <- age_2018[-521,]


#-------------------------
#nene hilario weird spelling 
grep("^Ne", stat_2018$player_name, value = TRUE)
grep("^Ne", age_2018$player_name, value = TRUE) # located in age 
grep("^Ne", age_2018$player_name)
age_2018$player_name[390] <- "Nene Hilario"
grep("^Nen", salary_2018$player_name, value = TRUE)
salary_2018$player_name <- gsub("Nenê", "Nene Hilario", salary_2018$player_name)


#multiple trade scenarios where a player ended up on different teams 
which(duplicated(stat_2018$player_name))
sum(duplicated(stat_2018$player_name))
stat_2018 %>% group_by(player_name) %>% filter(n() > 1)

#Will use last team played for when doing full join so remove duplicates 

stat_2018 <- stat_2018[-c(24,25,  28,  29,  45,  46,  59,  60,  68,  69,  70,  73,  74,  77,  78,  97,  98, 102, 103, 118, 119, 122, 123, 142, 143, 145, 146, 167, 168, 174,
                          175, 180, 181, 190, 191, 202, 203, 229, 230, 237, 238, 242, 243, 250, 251, 252, 259, 260, 266, 267, 276, 277, 288, 289, 299, 300, 306, 307, 314, 315,
                         319, 320, 328, 329, 331, 332, 341, 342, 343, 344, 368, 369, 386, 387, 401, 402, 419, 420, 425, 426, 427, 439, 440, 442, 443, 450, 451, 454, 455, 471,
                         472, 481, 482, 493, 494, 496, 497, 523, 524, 527, 528, 535, 536, 550, 551, 568, 569, 585, 586, 602, 603, 604, 606, 607, 610, 611, 623, 624, 642, 643,
                           650, 651, 660, 661),]



rownames(stat_2018) <- NULL 

#clean up unused columns 

stat_2018 <- stat_2018[,-5]

#clean up unnecessary rows in age

age_2018 <- age_2018[,-c(12:16)]
age_2018 <- age_2018[,-3]
#time to combine all of 2019 

data_2018 <- full_join(salary_2018, age_2018, by = "player_name")
data_2018 <- full_join(data_2018, stat_2018, by = "player_name")

#have to fill in the N/As now.  
colnames(data_2018)[2] <- "salary"
sum(is.na(data_2018$salary)) #24 missing
sum(is.na(data_2018$TEAM)) #70 missing
sum(is.na(data_2018$ppg)) #69 missing 


#find duplicated rows
which(duplicated(data_2018$player_name))


#change the height data so it's not in date format 
data_2018$HEIGHT <- gsub("Jun", "6", data_2018$HEIGHT, fixed=TRUE)
data_2018$HEIGHT <- gsub("Jul", "7", data_2018$HEIGHT, fixed=TRUE)
data_2018$HEIGHT <- gsub("May", "5", data_2018$HEIGHT, fixed=TRUE)


data_2018$HEIGHT[which(data_2018$HEIGHT == "11-6")] = '6-11"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "10-6")] = '6-10"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "9-6")] = '6-9"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "8-6")] = '6-8"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "7-6")] = '6-7"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "5-6")] = '6-5"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "4-6")] = '6-4"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "3-6")] = '6-3"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "2-6")] = '6-2"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "1-6")] = '6-1"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "6-00")] = '6-0"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "11-5")] = '5-11"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "10-5")] = '5-10"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "9-5")] = '5-9"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "8-5")] = '5-8"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "7-5")] = '5-7"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "1-7")] = '7-1"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "2-7")] = '7-2"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "3-7")] = '7-3"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "7-00")] = '7-0"'
data_2018$HEIGHT[which(data_2018$HEIGHT == "6'6")] = "6'6\""

#change the symbols - to 4'2"
data_2018$HEIGHT <- gsub("-", "'", data_2018$HEIGHT, fixed=TRUE)

grep("[I]", data_2018$player_name, value = TRUE)

miss_sal_2018<-read.csv("missing_salary_2018.csv", header = F)

colnames(miss_sal_2018)[1:39] <- c("player_name", "salary", "TEAM",  "HEIGHT", "WEIGHT", "COLLEGE", "COUNTRY", "DRAFT.YEAR",
                                  "DRAFT.ROUND", "DRAFT.NUMBER", "NETRTG", "player_id", "Pos", "Age", "G", "GS", "MP", "FG", "FGA",
                                  "FG.", "X3P", "X3PA", "X3P.", "X2P", "X2PA", "X2P.", "eFG.", "FT", "FTA", "FT.", "ORB", "DRB",
                                  "TRB", "AST", "STL", "BLK", "TOV", "PF", "ppg") 


data_2018 <- data_2018[-c(586:609),]
data_2018<-rbind(data_2018,miss_sal_2018)

grep("Dennis", data_2018$player_name, value = T) # different spelling problems 
grep("Dennis", data_2018$player_name)
#####-------------------------------#####

#removing player duplicates from salary 
grep("^Juan.", data_2018$player_name, value = TRUE)
grep("^Juan.", data_2018$player_name)
test_data_2019 <- test_data_2019[-323,]


grep(".II$", data_2018$player_name, value = TRUE)
grep("IV", data_2018$player_name, value = TRUE)
grep("IV", data_2018$player_name)
grep("Wade Baldwin", data_2018$player_name) # these will be removed when I remove duplicates from age and stats 


library(stringr)
data_2018$salary <- str_replace(data_2018$salary, "\\$", "")
data_2018$salary <- str_replace_all(data_2018$salary, ",", "")
data_2018$salary <- as.numeric(data_2018$salary)

#time to look at age and stats

which(is.na(data_2018$TEAM))
sum(is.na(data_2018$TEAM))
data_2018 %>% filter(is.na(TEAM))
options(max.print = 999999999)
#Chris Bosh blood clots remove
#Dennis Schroeder different spelling remove duplicate
#Brandon Knight did not play 
#Nikola Pekovic Did not play 
#Patrick mills duplicate
#Moe Harkless duplicate
#Louis Williams duplicate
#Matt barnes did not play
#Ishmael Smith duplicate
#Deron Williams did not play 
#Larry Sanders did not play
#Alexis Ajinca did not play
#Jose Juan Barea duplciate
#Paul Pierce retired
#Lavoy Allen did not play
#Seth Curry Did not play
#James Ennis is a dulicate
#andrew nicholson did no play
#Ronnie Price did not play
#Wade baldwin duplicate
#Monta Ellis did not play
#Juan Hernangomez duplicate
#Spencer Hawes did not play
#Harry Giles duplicate
#Mike Dunleavy duplicate
#Timothe Luwawu duplicate
#DeAndre Bembry duplicate
#Johnny 0'Bryant Duplicate
#Joseph Young duplicate
#Diamond Stone did not play
#Sheldon Mac did not play
#AJ Hamons did not play
#Chasson Randle did not play
#Livio Jean Charles did not play
#Wesley Iwundu is a duplicate
#CJ watson did not play
#Gerald Henderson did not play
#Festus Ezili did not play
#Justin Hamilton did not play
#Rade Zagorac did not play
#Jason Thompson did not play
#Frank Jackson did not play
#Michael Gbinije did not play
# Leandro Barbosa did not play
# Cameron Oliver did not play
# Naz Long played 1 game got cut
#Carrick Felix did not play
# Brandon Rush did not play 
# Ty Lawson did not play
# KJ McDaniels did not play 
# Jaylen Johnson did not play
# CJ Fair did not play
# Andrew White duplicate
#Yakuba Ouattara did not play
# James Webb dupliate
# Vince Hunter duplicate
# Amile Jefferson  did not play
#CJ Wilcox did not play
# Eric Griffin did not play
# Michael young duplicate
# Landry Nnoko did not play
# VJ beachem did not play
# Bronson Koenig did not play
# Daniel Ochefu did not play
# Marcus Thorton II did not play 



data_2018 <- data_2018[-c(15,  71,  88, 110, 115, 116, 161, 169, 180, 195, 207, 210, 234, 239, 243, 262, 263, 271, 288, 306, 309, 324, 326, 332, 349, 350, 354, 361, 373, 397, 399,
                         414, 418, 428, 435, 436, 437, 438, 439, 442, 444, 456, 471, 472, 479, 489, 497, 501, 502, 504, 507, 509, 512, 515, 517, 542, 549, 562, 569, 572, 577, 578,
                          579, 580, 581),]



rownames(data_2018) <- NULL 

##----Testing NAs in stat_2018 
which(is.na(data_2018$ppg))
data_2018 %>% filter(is.na(ppg))

grep("Taurean", data_2018$player_name) # duplicate
grep("Taurean", data_2018$player_name, value =T)
grep("Glenn Robinson", data_2018$player_name) #duplicate
grep("Glenn Robinson", data_2018$player_name, value = T)
grep("Larry Drew", data_2018$player_name) #duplicate
grep("Larry Drew", data_2018$player_name, value = T)
grep("Gary Payton", data_2018$player_name) #duplicate 
grep("Gary Payton", data_2018$player_name, value = T)
data_2018 <- data_2018[-c(271, 332, 436, 449),] 
rownames(data_2018) <- NULL 

#add in the II and III
data_2018$player_name <- gsub("Glenn Robinson", "Glenn Robinson III",data_2018$player_name)
data_2018$player_name <- gsub("Larry Drew", "Larry Drew II",data_2018$player_name)
data_2018$player_name <- gsub("Gary Payton", "Gary Payton II",data_2018$player_name)

#doublecheck if all nas are gone. 
which(is.na(data_2018$TEAM))
which(is.na(data_2018$ppg))
which(is.na(data_2018$salary))

#adding tax and inflation 
tax <- read.csv("state_income.csv")
data_2018<-full_join(data_2018, tax, by = "TEAM")


inflation <- read.csv("inflation.csv")
data_2018["inflation"] <- 2.1



#add in player id by the 2019 year
data_2018$player_id <- "2018"


# adding team wins

team_wins<-read.csv("team_wins.csv")
team_wins18 <- team_wins[,-c(2,4:21)]
colnames(team_wins18)[2] <- "wins"
data_2018<-full_join(data_2018, team_wins18, by = "TEAM")

data_2018 <- data_2018[-c(541:542),]

#time to add the awards from the year before 
#counting the number of times each player won the award nba first team

rapply(nba_1_team,function(x)length(unique(x)))
unique(nba_1_team$player_name)


# make a column if they won the awards the previous year.  #make columns for awards
test <- data_2018
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
test[2, 48] <- "YES"

#Kawhi Leonard
grep("Kawhi Leonard", test$player_name)

test[45, 48] <- "YES" 

#Anthony Davis

grep("Anthony Davis", test$player_name)

test[21, 48] <- "YES"

#Russell Westbrook 

grep("Russell Westbrook", test$player_name)

test[9,48] <- "YES"

#James Harden 

grep("James Harden", test$player_name)

test[8, 48] <- "YES" 

#NBA second team 

#Kevin Durant	
grep("Kevin Durant", test$player_name)

test[15, 49] <- "YES"

#Giannis Antetokounmpo	(Bucks)
grep("Giannis Antetokounmpo", test$player_name)

test[31, 49] <- "YES"

#Rudy Gobert 
grep("Rudy Gobert", test$player_name)
test[36, 49] <- "YES"
#Stephen Curry 
grep("Stephen Curry", test$player_name)
test[1, 49] <- "YES"
#Isaiah Thomas
grep("Isaiah Thomas", test$player_name)
test[167, 49] <- "YES"

#NBA third team 

#Jimmy Butler	(Timberwolves)
grep("Jimmy Butler", test$player_name)
test[46, 50] <- "YES"
#Draymond Green	(Warriors)
grep("Draymond Green", test$player_name)
test[65, 50] <- "YES"
#Paul George	(Thunder)
grep("DeAndre Jordan", test$player_name)
test[28, 50] <- "YES"
#Victor Oladipo	(Pacers)
grep("DeMar DeRozan", test$player_name)
test[10, 50] <- "YES"
#Karl-Anthony Towns	(Timberwolves)
grep("John Wall", test$player_name)
test[49, 50] <- "YES"

#All Rookie 1st team

#Malcolm Brogdon	(Bucks)
grep("Malcolm Brogdon", test$player_name)
test[381, 51] <- "YES"
#Dario Saric	(76ers)
grep("Dario Saric", test$player_name)
test[271, 51] <- "YES"
#Joel Embiid	(76ers)
grep("Joel Embiid", test$player_name)
test[170, 51] <- "YES"
#Buddy Hield	(Pelicans / Kings)
grep("Buddy Hield", test$player_name)
test[226, 51] <- "YES"
#Willy Hernangomez	(Knicks)
grep("Willy Hernangomez", test$player_name)
test[359, 51] <- "YES"


#All rookie Second Team
#Jamal Murray	(Nuggets)
grep("Jamal Murray", test$player_name)
test[233, 52] <- "YES"
#Jaylen Brown	(Celtics)
grep("Jaylen Brown", test$player_name)
test[199, 52] <- "YES"
#Marquese Chriss	(Suns)
grep("Marquese Chriss", test$player_name)
test[245, 52] <- "YES"
#Brandon Ingram	(Lakers)
grep("Brandon Ingram", test$player_name)
test[182, 52] <- "YES"
#Yogi Ferrell	(Nets / Mavericks)
grep("Yogi Ferrell", test$player_name)
test[372, 52] <- "YES"

#All defensive first team
#Rudy Gobert	(Jazz)
grep("Rudy Gobert", test$player_name)
test[36, 53] <- "YES"
#Kawhi Leonard	
grep("Kawhi Leonard", test$player_name)
test[45, 53] <- "YES"
#Draymond Green
grep("Draymond Green", test$player_name)
test[65, 53] <- "YES"
#Chris Paul
grep("Chris Paul", test$player_name)
test[17, 53] <- "YES"
#Victor Oladipo	(Pacers)
grep("Patrick Beverley", test$player_name)
test[184, 53] <- "YES"
#All defensive second team 

#Tony Allen
grep("Tony Allen", test$player_name)
test[337, 54] <- "YES"
#Danny Green
grep("Danny Green", test$player_name)
test[120, 54] <- "YES"
#Anthony Davis
grep("Anthony Davis", test$player_name)
test[21, 54] <- "YES"
#Andre Roberson 
grep("Andre Roberson", test$player_name)
test[127, 54] <- "YES"
#Giannis Antetokounmpo
grep("Giannis Antetokounmpo", test$player_name)
test[31, 54] <- "YES"

#MVP 43
grep("Russell Westbrook", test$player_name)
test[9, 43] <- "YES"
#MIP 44
grep("Giannis Antetokounmpo", test$player_name)
test[31, 44] <- "YES"
#6th man 45 
grep("Eric Gordon", test$player_name)
test[89, 45] <- "YES"
#DPOY 46
grep("Draymond Green", test$player_name)
test[65, 46] <- "YES"
#ROY 47
grep("Malcolm Brogdon", test$player_name)
test[381, 47] <- "YES"

test<-format(test, digits = 11)

write.csv(test, file = "2018_data.csv")