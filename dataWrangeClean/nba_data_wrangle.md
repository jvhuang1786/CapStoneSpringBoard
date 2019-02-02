---
title: "data_wrangling"
author: "Justin Huang"
date: "1/17/2019"
output:
  html_document:
    keep_md: yes
---

**Source**

The data was collected from 6 sources. 

* [BasketBall Reference]{https://www.basketball-reference.com}
* [Hoops Hype]{https://hoopshype.com}
* [NBA STATs]{https://stats.nba.com}
* [Patricia Bender]{https://www.eskimo.com/~pbender/}
* [Land of Basketball]{https://www.landofbasketball.com}
* [CBA Agreements]{http://www.cbafaq.com/salarycap.htm}

*How the Data was collected*

* For the Hoops Hype data it was collected by webscraping the data from the website.


```r
salary_2018 <- read_html("https://hoopshype.com/salaries/players/2017-2018/") %>%
  html_nodes("table") %>%  html_table
```

This code was used to collect the salary data from 2001 to 2018.  The last part of the data for the year 2000 was collected directly from Patrcia Benders website.  

* The salaries were fact checked through buisnessinsdier. [Steph Curry Contract]{https://www.businessinsider.com/stephen-curry-salary-taxes-nba-2017-9}

* NBA Stats provided data for the college, weight and the age.  This was directly taken from their website.  

* NBA player statistics was collected through Basketball Reference.  The website provided a csv file.  

* Land of Basketball provided the awards and team wins information. 

* CBA FAQ provided data for the last 4 CBAs to understand the contract structure of NBA players. 

*Cleaning up the data*

* Loaded in the packages used to clean the data


```r
loading the data packages 
library(dplyr)
library(tidyr)
library(stringr)
```

Loading in the data and setting the directory 


```r
getwd()
setwd("/users/justinvhuang/desktop/nba_stat_salaries")
getwd()
age <- read.csv("2000_age.csv")
salary <- read.csv("2000_salary.csv")
stat <- read.csv("2000_stats.csv")
```

Cleaned up the stats, salary and age data by removing unnecessary columns that weren’t going to be used.  Also made sure when doing a full join changed the names column to player name for all 3. 


```r
# clean up stats
#remove rank column 
stat <- stat[,-c(1,5)]
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
salary <- salary[,-c(3)]
#salary <- salary[-1,]
colnames(salary) <- c("player_name", "salary")
rownames(salary) <- NULL
grep("\\.",salary$player_name)
grep(".Jr$", salary$player_name, value = TRUE) # 3 Jrs 
#remove columns from age data 
age <- age[,-c(3,11:14,16:20)]
#remove rows that have Player 
y<-which(age$PLAYER == "PLAYER")
age <- age[-c(y),]
#Change PLAYER to player_name 
names(age)[1]<-paste("player_name") 
```

There were some problems when doing an initial full join.  Had to clean up names to remove “-“, “*”, “,” from the name column for each one. Each website also had different spellings for some of the players.  They also would include Jr or III after the name. Used grep and gsub to find and replace these names so they would all be matching.  

```r
#getting rid of periods in name 
grep("\\*",age$player_name, value = T)
grep("\\*",stat$player_name, value = T)
stat$player_name <- gsub("\\*","",stat$player_name)
grep("Ray Allen",stat$player_name, value =T)
grep("\\*",salary$player_name, value = T)
grep("\\.",age$player_name)
age$player_name <- gsub("\\.","", age$player_name)
grep(".Jr$", age$player_name, value = TRUE) # 6 Jrs here.  
grep("Glen Rice", age$player_name, value = TRUE)
grep(".Jr$",stat$player_name, value = TRUE) 
#look through all stats for which one junior is missing for a total of 13 was missing in stats. 
grep(".Jr$", salary$player_name, value = TRUE)
##### Filling all the juniors 
#stat
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
#Weird Spelling 
grep("Amare Stoudemire", salary$player_name)
salary$player_name<-gsub("Amare Stoudemire", "Amar'e Stoudemire",salary$player_name)
grep("Amar'e Stoudemire", salary$player_name)
grep("Mbenga", salary$player_name, value = TRUE)
salary$player_name<-gsub("Didier Ilunga-Mbenga", "DJ Mbenga", salary$player_name) 
stat$player_name<-gsub("Didier Ilunga-Mbenga", "DJ Mbenga", stat$player_name) 
grep("Sweetney", salary$player_name, value = TRUE)
salary$player_name<-gsub("Mike Sweetney", "Michael Sweetney", salary$player_name) 
grep("Sweetney", stat$player_name, value = TRUE)
stat$player_name<-gsub("Mike Sweetney", "Michael Sweetney", stat$player_name) 
grep("Medvedenko", salary$player_name, value = TRUE)
salary$player_name<-gsub("Stanislav Medvedenko", "Slava Medvedenko", salary$player_name) 
grep("Medvedenko", stat$player_name, value = TRUE)
stat$player_name<-gsub("Stanislav Medvedenko", "Slava Medvedenko", stat$player_name) 
grep("Tsakalidis", salary$player_name, value = TRUE)
salary$player_name<-gsub("Iakovos Tsakalidis", "Jake Tsakalidis", salary$player_name) 
grep("Ronald Murray", salary$player_name)
salary$player_name<-gsub("Ronald Murray", "Flip Murray", salary$player_name)
stat$player_name<-gsub("Ronald Murray", "Flip Murray", stat$player_name)
salary$player_name<-gsub("John Lucas", "John Lucas III", salary$player_name)
grep("Turkoglu", salary$player_name, value = T)
salary$player_name <- gsub("Hidayet Turkoglu", "Hedo Turkoglu", salary$player_name)
grep("Mamadou N'diaye",salary$player_name)
salary$player_name <- gsub("Mamadou N'diaye", "Mamadou N'Diaye", salary$player_name)
grep("Mamadou N'diaye",age$player_name) 
age$player_name <- gsub("Mamadou N'diaye", "Mamadou N'Diaye", age$player_name)
grep("Alexander",salary$player_name, value = TRUE)
salary$player_name<- gsub("Courtney Alexander", "Cory Alexander", salary$player_name)
age$player_name <- gsub("Cory Alexander", "Courtney Alexander", age$player_name)
stat$player_name<-gsub("Cory Alexander", "Courtney Alexander", stat$player_name)
grep("Weatherspoon", salary$player_name, value = T)
stat$player_name<-gsub("Clar Weatherspoon", "Clarence Weatherspoon", stat$player_name)
age$player_name <- gsub("Clar Weatherspoon", "Clarence Weatherspoon", age$player_name)
grep("Barea", salary$player_name, value = T)
salary$player_name <- gsub("Jose Juan Barea", "JJ Barea", salary$player_name)
grep("Louis Williams", salary$player_name, value = T)
salary$player_name <- gsub("Louis Williams", "Lou Williams", salary$player_name)
grep("Maurice Williams", salary$player_name, value = T)
salary$player_name <- gsub("Maurice Williams", "Mo Williams", salary$player_name)
grep("Sene", salary$player_name)
salary$player_name <- gsub("Saer Sene", "Mouhamed Sene", salary$player_name)
grep("Stojakovic", salary$player_name, value =T)
salary$player_name <- gsub("Predrag Stojakovic", "Peja Stojakovic", salary$player_name)
grep("Nesterovic",salary$player_name, value =T)
salary$player_name <- gsub("Radoslav Nesterovic", "Rasho Nesterovic", salary$player_name)
grep("Pavlovic",salary$player_name, value =T)
salary$player_name <- gsub("Aleksandar Pavlovic", "Sasha Pavlovic", salary$player_name)
```

There were also issues of having duplicate names due to player trades and movement.  Used which and duplicate to remove the duplicate rows and kept the total.  When doing the full join(age will have the team column) it will keep the last team they played on for the season.  


```r
#multiple trade scenarios where a player ended up on different teams 
which(duplicated(stat$player_name))
sum(duplicated(stat$player_name))
stat %>% group_by(player_name) %>% filter(n() > 1)
a<-which(duplicated(stat$player_name))
#Will use last team played for when doing full join so remove duplicates 
stat<- stat[-c(a),]
rownames(stat) <- NULL 
```

After the full join.  Changed the height column so that it would not be a date like June 6th which should be 6’6”.  Used gsub and which to change this.   (Later on changed the height to cm during the data exploration phase.)


```r
#time to combine all of them 
data <- full_join(salary, age, by = "player_name")
data <- full_join(data, stat, by = "player_name")

#have to fill in the N/As now.  
colnames(data)[2] <- "salary"
colnames(data)[39] <- "ppg"
sum(is.na(data$salary)) 
which(is.na(data$salary))
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
```

After there was still some NA’s for salary for several rows.  Had to create another csv file and go through hoopshype.com and https://www.eskimo.com/~pbender/misc/salaries09.txt. To fill in the missing salary and missing NA columns.  Loaded in the data removed the old NA’s and rbinded the data to this data set..  


```r
miss_sal<-read.csv("missing_salary_2000.csv", header = F)

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
rownames(data) <- NULL 

#doublecheck if all nas are gone. 
which(is.na(data$TEAM))
which(is.na(data$ppg))
which(is.na(data$salary))
```

Used the stringr package to make sure the format of the salary column was correct and changed to a numeric.  
Then looked through the rest of the NAs in the stats criteria and age criteria columns.  Did a google search on most of the players to see if they played that season.  If they were waived, injured, did not play that season they were removed from the data.  

For each year set player_id for that year.  Loaded in tax and set in the location tax for each team, loaded in team wins and inflation for each year. (There was later a problem with team wins with the shortened season for the Bobcats. Loaded the right information during the DEA phase.) All included by full_join().  


```r
#adding tax and inflation 
tax <- read.csv("state_income.csv")
data<-full_join(data, tax, by = "TEAM")
inflation <- read.csv("inflation.csv")
data["inflation"] <- 2.2

#add in player id by the year
data$player_id <- "2000"

# adding team wins
team_wins<-read.csv("team_wins.csv")
team_wins <- team_wins[,-c(2:20)]
colnames(team_wins)[2] <- "wins"
data<-full_join(data, team_wins, by = "TEAM")
f<-which(is.na(data$player_name))
data <- data[-c(f),]
```

For the award section I used previous year data.  The reason why is I wanted to see if the awards would affect the players performance or salary the following year after receiving the award.    

Created a new column for each award such as MVP, NBA first team, sixth_man, etc… 

Filled all the data with NO first.  Used land of basketball for this section.  
To fill in the “NO” as “YES” if the player for the 2019 data received an award for that criteria.  Used grep to find the player and filled it into a value which located and put “YES” if they won the award.  


```r
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

a1<-grep("Tim Duncan", test$player_name)
test[a1, 48] <- "YES"
a2<-grep("Karl Malone", test$player_name)
test[a2, 48] <- "YES" 
a3<-grep("Allen Iverson", test$player_name)
test[a3, 48] <- "YES"
a4<-grep("Jason Kidd", test$player_name)
test[a4,48] <- "YES"
a5<-grep("Alonzo Mourning", test$player_name)
test[a5, 48] <- "YES" 

#NBA second team 

a6<-grep("Grant Hill", test$player_name)
test[a6, 49] <- "YES"
a7<-grep("Chris Webber", test$player_name)
test[a7, 49] <- "YES"
a8<-grep("Tim Hardaway", test$player_name)
test[a8, 49] <- "YES"
a9<-grep("Gary Payton", test$player_name)
test[a9, 49] <- "YES"
a10<-grep("Shaquille O'Neal", test$player_name)
test[a10, 49] <- "YES"

#NBA third team 

a11<-grep("Kevin Garnett", test$player_name)
test[a11, 50] <- "YES"
a12 <-grep("Antonio McDyess", test$player_name)
test[a12, 50] <- "YES"
a13 <-grep("Kobe Bryant", test$player_name)
test[a13, 50] <- "YES"
a14<-grep("John Stockton", test$player_name)
test[a14, 50] <- "YES"
a15<-grep("Hakeem Olajuwon", test$player_name)
test[a15, 50] <- "YES"

#All Rookie 1st team

r1<-grep("Mike Bibby", test$player_name)
test[r1, 51] <- "YES"
r2<-grep("Vince Carter", test$player_name)
test[r2, 51] <- "YES"
r3<-grep("Matt Harpring", test$player_name)
test[r3, 51] <- "YES"
r4<-grep("Paul Pierce", test$player_name)
test[r4, 51] <- "YES"
r5<-grep("Jason Williams", test$player_name)
test[r5, 51] <- "YES"
#r11<-grep("Brandon Roy", test$player_name)
#test[r11, 51] <- "YES"
#r12<-grep("Iman Shumpert", test$player_name)
#test[r12, 51] <- "YES"

#All rookie Second Team

r6<-grep("Michael Dickerson", test$player_name)
test[r6, 52] <- "YES"
r7<-grep("Michael Doleac", test$player_name)
test[r7, 52] <- "YES"
r8<-grep("Michael Olowokandi", test$player_name)
test[r8, 52] <- "YES"
r9<-grep("Antawn Jamison", test$player_name)
test[r9, 52] <- "YES"
r10<-grep("Cuttino Mobley", test$player_name)
test[r10, 52] <- "YES"
r11<-grep("Michael Olowokandi", test$player_name)
test[r11, 52] <- "YES"
#All defensive first team

d1<-grep("Tim Duncan", test$player_name)
test[d1, 53] <- "YES"
d2<-grep("Alonzo Mourning", test$player_name)
test[d2, 53] <- "YES"
d3<-grep("Jason Kidd", test$player_name)
test[d3, 53] <- "YES"
d4<-grep("Gary Payton", test$player_name)
test[d4, 53] <- "YES"
d5<-grep("Karl Malone", test$player_name)
test[d5, 53] <- "YES"
d11<-grep("Scottie Pippen", test$player_name)
test[d11, 53] <- "YES"
#All defensive second team 

d6<-grep("Mookie Blaylock", test$player_name)
test[d6, 54] <- "YES"
d7<-grep("Theo Ratliff", test$player_name)
test[d7, 54] <- "YES"
d8<-grep("PJ Brown", test$player_name)
test[d8, 54] <- "YES"
d9<-grep("Dikembe Mutombo", test$player_name)
test[d9, 54] <- "YES"
d10<-grep("Eddie Jones", test$player_name)
test[d10, 54] <- "YES"
#d11<-grep("Theo Ratliff", test$player_name)
#test[d11, 54] <- "YES"
#MVP 43
mvp<-grep("Karl Malone", test$player_name)
test[mvp, 43] <- "YES"
#MIP 44
mip<-grep("Darrell Armstrong", test$player_name)
test[mip, 44] <- "YES"
#6th man 45 
sixth<-grep("Darrell Armstrong", test$player_name)
test[sixth, 45] <- "YES"
#DPOY 46
dpoy<-grep("Alonzo Mourning", test$player_name)
test[dpoy, 46] <- "YES"
#ROY 47
roy<-grep("Vince Carter", test$player_name)
test[roy, 47] <- "YES"
test<-format(test, digits = 11)
```

Then wrote the csv.  

This process is repeated for 2000-2018.  Then was loaded into another R script to rbind all the data. 


```r
write.csv(test, file = "2000_data.csv")
```

Then all the data was loaded into one R file then rbinded together.  


```r
data_2018<-read.csv("2018_data.csv")
data_2017<-read.csv("2017_data.csv")
data_2016<-read.csv("2016_data.csv")
data_2015<-read.csv("2015_data.csv")
data_2014<-read.csv("2014_data.csv")
data_2013<-read.csv("2013_data.csv")
data_2012<-read.csv("2012_data.csv")
data_2011<-read.csv("2011_data.csv")
data_2010<-read.csv("2010_data.csv")
data_2009<-read.csv("2009_data.csv")
data_2008<-read.csv("2008_data.csv")
data_2007<-read.csv("2007_data.csv")
data_2006<-read.csv("2006_data.csv")
data_2005<-read.csv("2005_data.csv")
data_2004<-read.csv("2004_data.csv")
data_2003<-read.csv("2003_data.csv")
data_2002<-read.csv("2002_data.csv")
data_2001<-read.csv("2001_data.csv")
data_2000<-read.csv("2000_data.csv")


data<-rbind(data_2019,data_2018,data_2017,data_2016,data_2015,data_2014,data_2013,data_2012,data_2011,data_2010, data_2009,
            data_2008, data_2007, data_2006, data_2005, data_2004, data_2003, data_2002, data_2001, data_2000)
#Error in match.names(clabs, names(xi)) : 
#names do not match previous names
colnames(data_2019) == colnames(data_2000)
names(data)
```

The data columns were renamed.  Then I looked for missing data in the data set.  I looked to replace the data set if the player was relevant for the season. 


```r
data<-data[,-1]

colnames(data)[1:54] <- c("name", "salary", "team", "height(ft)", "weight(lb)", "school", "country", "draft_year",
                          "draft_round", "draft_number", "+/-", "player_year", "position", "age", "games", "started",
                          "mins/game", "field_goal", "field_goal_attempt", "field_goal_per", "3_game", "3_att",
                          "3_point_per", "2_game", "2_att", "2_point_per", "effective_field_per", "freethrows",
                          "free_throw_attempt","free_throw_percent", "o_rebound", "d_rebound", "t_rebound", "assist", "steal", "block", "turnover",
                          "fouls", "ppg", "tax", "infl", "wins", "mvp", "mip", "6_man", "dpoy", "roy", "nba1", "nba2", "nba3",
                          "rook1", "rook2", "def1", "def2")

data$tax <- str_replace(data$tax, "\\%", "")
data$tax <- as.numeric(data$tax)
data$`weight(lb)` <- as.numeric(data$`weight(lb)`)
#data <- data %>% mutate((tax/100))
data$salary <- as.numeric(data$salary)
#data[,17:40] <- as.numeric(data[,17:40])
data$`mins/game` <-as.numeric(data$`mins/game`)
a<-which(is.na(data$name))
data<-data[-c(a),]
rownames(data) <- NULL 
which(is.na(data$salary))
data$salary[8669]<- 2812500
which(is.na(data$salary))

which(is.na(data$team))
data[342,]
data$team[342] <- "POR"
data[342,4:11] <- c("6'4\"", 200, "Vanderbilt", "USA", 2016, 1, 17, -4.0)
data[369,]
data$team[369] <- "ORL"
data[369,4:11] <- c("6'7\"", 195, "Kansas State", "USA", 2017, 2, 33, -2.3)

which(is.na(data$`height(ft)`))
c<-!grepl("[567]", data$`height(ft)`)
xy<-which(c == TRUE)
data$name[xy]


data[1489,]
data[1489,4] <- "6'6\"" 
data[1490,]
data[1490,4] <- "6'8\"" 
data[2290,]
data[2290,4:5] <- c("6'7\"", 245) 
data[2407,]
data[2407,4:5] <- c("6'5\"", 190) 
data[2413,]
data[2413,4:5] <- c("6'0\"", 185) 
data[7484,]
data[7484,4:5] <- c("6'3\"", 192) 
data[7682,]
data[7682,4:5] <- c("6'11\"", 240) 
data[7710,]
data[7710,4:5] <- c("6'6\"", 210) 
data[7713,]
data[7713,4:5] <- c("6'1\"", 185)   
data[7775,]
data[7775,4:5] <- c("7'0\"", 243)   
data[7803,]
data[7803,4:5] <- c("6'6\"",205)

data[7911,]
data[7911,4:5] <- c("6'10\"",220)
data[7939,]
data[7939,4:5] <- c("6'4\"",185)
data[7961,]
data[7961,4:5] <- c("6'11\"",240)

data[7990,]
data[7990,4:5] <- c("6'2\"",197)
data[7994,]
data[7994,4:5] <- c("6'10\"",215)
data[7995,]
data[7995,4:5] <- c("6'3\"",190)

data[8020,]
data[8020,c(2,4:5)] <- c(1000000,"6'1\"",185)

data[8027,]
data[8027,4:5] <- c("6'7\"",212)

data[8055,]
data[8055,4:5] <- c("6'11\"",225)

data[8070,]
data[8070,4:5] <- c("6'10\"",250)

data[8116,]
data[8116,4:5] <- c("7'1\"",260)

data[8136,]
data[8136,4:5] <- c("6'7\"",220)

data[8137,]
data[8137,4:5] <- c("6'5\"",215)

data[8142,]
data[8142,4:5] <- c("6'9\"",248)

data[8178,]
data[8178,4:5] <- c("6'5\"",215)

data[8218,]
data[8218,4:5] <- c("7'2\"",265)

data[8229,]
data[8229,4:5] <- c("7'1\"",240)

data[8244,]
data[8244,4:5] <- c("6'6\"",200)

data[8274,]
data[8274,4:5] <-  c("6'6\"",200)

data[8294,]
data[8294,4:5] <- c("6'10\"",235)

data[8331,]
data[8331,4:5] <- c("6'10\"",230)

data[8355,]
data[8331,4:5] <- c("6'9\"",255)

data[8379,]
data[8379,4:5] <- c("6'8\"",220)

data[8390,]
data[8390,4:5] <- c("6'2\"",180)

data[8396,]
data[8396,4:5] <- c("6'4\"",190)



data[8415,]
data[8415,4:5] <- c("6'3\"",185)

data[8432,]
data[8432,4:5] <- c("6'9\"",215) 

data[8436,]
data[8436,4:5] <- c("6'0\"",180) 

data[8440,]
data[8440,4:5] <- c("6'9\"",220) 

data[8445,]
data[8445,4:5] <- c("6'7\"",215) 

data[8448,]
data[8448,4:5] <- c("6'9\"",210) 

data[8452,]
data[8452,4:5] <- c("6'6\"",210) 

data[8455,]
data[8455,4:5] <- c("6'8\"",221) 

data[8475,]
data[8475,4:5] <- c("6'7\"",212) 

data[8476,]
data[8476,4:5] <- c("6'4\"",215) 

data[8483,]
data[8483,4:5] <- c("6'5\"",215) 

data[8484,]
data[8484,4:5] <- c("6'6\"",188) 

data[8494,]
data[8494,4:5] <- c("6'3\"",180) 

data[8495,]
data[8495,4:5] <- c("6'11\"",255) 

data[8509,]
data[8509,4:5] <- c("6'9\"",220) 

data[8517,]
data[8517,4:5] <- c("6'9\"",230) 

#-----#
data[8521,]
data[8521,4:5] <- c("6'0\"",178) 

data[8522,]
data[8522,4:5] <- c("6'9\"",277) 

data[8535,]
data[8535,4:5] <- c("6'7\"",215) 

data[8538,]
data[8538,4:5] <- c("5'10\"",200) 

data[8553,]
data[8553,4:5] <- c("6'4\"",195) 

data[8556,]
data[8556,4:5] <- c("6'9\"",245) 

data[8562,]
data[8562,4:5] <- c("6'7\"",212) 

data[8594,]
data[8594,4:5] <- c("6'6\"",216) 

data[8710,]
data[8710,4:5] <- c("6'6\"",216) 


which(is.na(data$`weight(lb)`))
data[463,]
data[463,4:5] <- c("6'3\"",200)
data[7804,]
data[7804,4:5] <- c("6'6\"",215)
data[7805,4:5] <- c("6'0\"",180)
data[8355,]
data[8355,4:5] <- c("6'9\"",255) 
str(data)
names(data)
sapply(data, class)
cols.num <- c("weight(lb)", "+/-", "field_goal", "field_goal_attempt", "field_goal_per", "3_game", "3_att", "3_point_per",
              "2_game", "2_att", "2_point_per", "effective_field_per", "freethrows", "free_throw_attempt", "free_throw_percent",
              "o_rebound", "d_rebound", "t_rebound", "assist", "steal", "block", "turnover", "fouls", "ppg", "age", "games", "started", "mins/game")
data[cols.num] <- sapply(data[cols.num],as.numeric)
sapply(data, class)
data$`height(ft)`<-as.character(data$`height(ft)`)
data$salary <- as.numeric(data$salary)
data$infl <-as.numeric(data$infl)

which(is.na(data$ppg))
which(is.na(data$`height(ft)`))
which(is.na(data$`weight(lb)`))
which(data$team =="")
which(data$position == "")

str(data)
data[7612,] # didn't play many games
data<-data[-7612,]
data[8397,]
data[8397,4:5] <- c("5'3\"",136) # problem with 5 ft 3
data[8593,]
data<- data[-c(8593,8709),]
which(is.na(data$team))
rownames(data) <- NULL 

nocountry<-which(data$country == "")

data[nocountry, c("name", "school")]
internationals<-which(data$school == "None" & data$country == "")
data[internationals, "name"]
sebs <- which(data$name == "Sebastian Telfair")
data[sebs, "country"] <- "USA"
yij <- which(data$name == "Yi Jianlian")
data[yij, "country"] <- "China"
djm <- which(data$name == "DJ Mbenga")
data[djm, "country"] <- "Congo"
data[883, "country"] <- "USA"
data[4233, "country"] <- "France"
data[5526, "country"] <- "Spain"
data[c(6394,6878), "country"] <- "Croatia"
data[8121, "country"] <- "Greece"

usaplay<- which(data$country == "")
data[usaplay, "country"] <- "USA"
#Juan Carlos Navarro, Yi Jianlian, DJ Mbenga, Papa Sy, antonis fotsis 
unlist(lapply(data, function(x) any(is.na(x))))
which(is.na(data$`+/-`))
data[4279, "+/-"] <- 3.6

which(is.na(data$position))
data[8564,]
data[8564,c("position", "age", "games", "started", "mins/game", "field_goal", "field_goal_attempt", "field_goal_per",
            "3_game", "3_att", "3_point_per", "2_game", "2_att", "2_point_per", "effective_field_per", "freethrows",
            "free_throw_attempt", "free_throw_percent", "o_rebound", "d_rebound", "t_rebound", "assist",
            "steal", "block", "turnover", "fouls", "ppg")] <-
  c("SG", 32, 77, 76, 28.7, 4.0, 8.9, .455, 1.5,	3.2,	.472,	2.5,	5.7,	.445,	.540,	2.1,	2.4,	.878,	0.6,	1.9,
    2.5,	2.0,	0.7,	0.2,	1.4,	2.1,	11.6)
data[8564,"team"] <- "SAS"
data[8564, "wins"] <- 60
rownames(data) <- NULL 
unlist(lapply(data, function(x) any(is.na(x))))
which(is.na(data$wins))
data[43,]
data[9005,]
unique(data$team)
# 37 team problem team wins might be repeativie and is more of a team pursuit than individual so will remove the columns
##should be taken care of plus/minus
#teamwins<-read.csv("team_wins.csv")
data<-data[,-42]
unlist(lapply(data, function(x) any(is.na(x))))
which(is.na(data$age))
data[c(342,369),c("name", "player_year")]
data[342, "age"] <- 22
data[369, "age"] <- 24
which(is.na(data$tax))
data[5380, "team"]
#tax level will depend on different incomes ranging from 10k -> 30 mil will be different and thus inaccurate if including jock tax as well as using an avg tax for all players in that state
data <- data[, -40]
miss_field<-which(is.na(data$field_goal_per))
data[miss_field, c("name","field_goal_per", "2_point_per", "effective_field_per", "player_year") ]
data[3422, c("field_goal_per", "2_point_per", "effective_field_per")] <- c(.679,.683,.679)
data[3490, "field_goal_per"] <- .380
data[3560, "field_goal_per"] <- .618
```

Then removed players who did not play more than 5 mins a game, or did not attempt a 2 point shot.  Also decided to remove the 2019 data set since it wasn't complete. Also, created another column for the shot percentages because some reason it did not load for some players.  Used mutate. 


```r
data<-data %>% mutate(fg_per = field_goal/field_goal_attempt)
data<-data %>% mutate(two_per = `2_game`/`2_att`)
#  (FG + 0.5 * 3P) / FGA  efg calculation
data<-data %>% mutate(efg = (field_goal + 0.5 * `3_game`)/ field_goal_attempt)
str(data)
which(is.na(data$`2_point_per`))
which(is.na(data$effective_field_per))
data <- data[,-c(20,23,26,27,30)]
data<-data %>% mutate(three_per = `3_game`/`3_att`)
data<-data %>% mutate(free_per = freethrows/free_throw_attempt)
unlist(lapply(data, function(x) any(is.na(x))))
which(is.na(data$two_per))
didnotplay <-which(is.na(data$two_per))
#if the player did not even attempt enough 2 point field goals not necessary to keep
data <- data[-didnotplay,]
data[8950,] #most big men and traditional players in the 2000s did not even attempt 3s so it should be okay

#free throw data should also be the same 
```

Formated the data csv to make sure the salary numbers would be displayed then finally wrote the data set out. Renamed the column names again. 


```r
data<-format(data, digits = 11)
grep("e",data$salary)
write.csv(data, file = "data_2019_2000.csv")
names(df)
colnames(data)[1:52] <- c("name", "salary", "team", "height_ft", "weight_lb", 
                          "school", "country", "DraftYear", "DraftRound", "DraftNum", 
                          "PlusMinus", "PlayerYear", "Pos", "Age", "Games", 
                          "started", "MinGames", "FG", "FG_att","three", 
                          "three_att", "two", "two_att", "FT", "FT_att", 
                          "o_reb", "d_reb", "t_reb", "assist", "steal", 
                          "block", "TO", "fouls", "ppg", "infl", 
                          "mvp", "mip", "SixthMan", "dpoy", "roy", 
                          "nba1", "nba2", "nba3", "rook1", "rook2", 
                          "def1", "def2", "FG_per", "two_per", "EFG",
                          "three_per", "FT_per")
```



