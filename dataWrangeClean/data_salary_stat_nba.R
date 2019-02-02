library(dplyr)
data_2019<-read.csv("2019_data.csv")
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
data<-format(data, digits = 11)
grep("e",data$salary)
write.csv(data, file = "data_2019_2000.csv")
