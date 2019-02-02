#webscraping with rvest
library(rvest)
library(dplyr)
library(beepr)
#scraping html from static website

?html_nodes
?lapply

getwd()
setwd('/users/justinvhuang/desktop/nba_stat_salaries')


#MIP table scrape 
MIP <- "http://www.espn.com/nba/history/awards/_/id/36"

MIP_table <- MIP %>% read_html() %>% html_nodes("table") %>% html_table(fill=TRUE)

write.csv(MIP_table, file = "MIP.csv")

#sixth man


sixth <- "http://www.espn.com/nba/history/awards/_/id/40"

sixth_table <- sixth %>% read_html() %>% html_nodes("table") %>% html_table(fill=TRUE)

write.csv(sixth_table, file = "sixth.csv")   

#first team defense

defense1 <- "http://www.espn.com/nba/history/awards/_/id/49"

defense1_table <- defense1 %>%  read_html() %>%  html_nodes("table") %>% html_table(fill= TRUE)

defense1_table

write.csv(defense1_table, file = "defense1.csv")

#second team defense 

defense2 <- "http://www.espn.com/nba/history/awards/_/id/50"

defense2_table <- defense2 %>% read_html() %>%  html_nodes("table") %>% html_table(fill = TRUE)

defense2_table

write.csv(defense2_table, file = "defense2.csv")

#rookie first team

rookie1 <- "http://www.espn.com/nba/history/awards/_/id/47"

rookie1_table <- rookie1 %>% read_html() %>%  html_nodes("table") %>% html_table(fill = TRUE)

rookie1_table 

write.csv(rookie1_table, file = "rookie1.csv")

#rookie second team

rookie2<- "http://www.espn.com/nba/history/awards/_/id/48"

rookie2_table <- rookie2 %>% read_html() %>%  html_nodes("table") %>% html_table(fill = TRUE)

rookie2_table 

write.csv(rookie2_table, file = "rookie2.csv")

#all NBA first
nba1 <- "http://www.espn.com/nba/history/awards/_/id/44"

nba1_table <- nba1 %>%  read_html() %>% html_nodes("table") %>%  html_table(fill= TRUE)

nba1_table  

write.csv(nba1_table, file = "nba1.csv")

#all NBA second

nba2 <- "http://www.espn.com/nba/history/awards/_/id/45"

nba2_table <- nba2 %>%  read_html() %>% html_nodes("table") %>%  html_table(fill= TRUE)

nba2_table  

write.csv(nba2_table, file = "nba2.csv")

#all NBA third

nba3 <- "http://www.espn.com/nba/history/awards/_/id/46"

nba3_table <- nba3 %>%  read_html() %>% html_nodes("table") %>%  html_table(fill= TRUE)

nba3_table  

write.csv(nba3_table, file = "nba3.csv")

#webscrap done 

beep("mario")
