#webscraping with rvest
library(rvest)
library(dplyr)
library(beepr)

options(max.print=1000000) 

team_2018 <- read_html("https://hoopshype.com/salaries/2017-2018/") %>%
  html_nodes("table") %>%  html_table

team_2017 <- read_html("https://hoopshype.com/salaries/2016-2017/") %>%
  html_nodes("table") %>%  html_table

team_2016 <- read_html("https://hoopshype.com/salaries/2015-2016/") %>%
  html_nodes("table") %>%  html_table

team_2015 <- read_html("https://hoopshype.com/salaries/2014-2015/") %>%
  html_nodes("table") %>%  html_table

team_2014 <- read_html("https://hoopshype.com/salaries/2013-2014/") %>%
  html_nodes("table") %>%  html_table

team_2013 <- read_html("https://hoopshype.com/salaries/2012-2013/") %>%
  html_nodes("table") %>%  html_table

team_2012 <- read_html("https://hoopshype.com/salaries/2011-2012/") %>%
  html_nodes("table") %>%  html_table

team_2011 <- read_html("https://hoopshype.com/salaries/2010-2011/") %>%
  html_nodes("table") %>%  html_table

team_2010 <- read_html("https://hoopshype.com/salaries/2009-2010/") %>%
  html_nodes("table") %>%  html_table

team_2009 <- read_html("https://hoopshype.com/salaries/2008-2009/") %>%
  html_nodes("table") %>%  html_table

team_2008 <- read_html("https://hoopshype.com/salaries/2007-2008/") %>%
  html_nodes("table") %>%  html_table


team_2007 <- read_html("https://hoopshype.com/salaries/2006-2007/") %>%
  html_nodes("table") %>%  html_table


team_2006 <- read_html("https://hoopshype.com/salaries/2005-2006/") %>%
  html_nodes("table") %>%  html_table


team_2005 <- read_html("https://hoopshype.com/salaries/2004-2005/") %>%
  html_nodes("table") %>%  html_table


team_2004 <- read_html("https://hoopshype.com/salaries/2003-2004/") %>%
  html_nodes("table") %>%  html_table(fill = T)


team_2003 <- read_html("https://hoopshype.com/salaries/2002-2003/") %>%
  html_nodes("table") %>%  html_table(fill = T)


team_2002 <- read_html("https://hoopshype.com/salaries/2001-2002/") %>%
  html_nodes("table") %>%  html_table(fill = T)


team_2001 <- read_html("https://hoopshype.com/salaries/2000-2001/") %>%
  html_nodes("table") %>%  html_table(fill = T)


team_2000 <- read_html("https://hoopshype.com/salaries/1999-2000/") %>%
  html_nodes("table") %>%  html_table

beep("mario")


write.csv(team_2000, file = "hoops_hype_salaryt_2000.csv")
write.csv(team_2001, file = "hoops_hype_salaryt_2001.csv")
write.csv(team_2002, file = "hoops_hype_salaryt_2002.csv")
write.csv(team_2003, file = "hoops_hype_salaryt_2003.csv")
write.csv(team_2004, file = "hoops_hype_salaryt_2004.csv")
write.csv(team_2005, file = "hoops_hype_salaryt_2005.csv")
write.csv(team_2006, file = "hoops_hype_salaryt_2006.csv")
write.csv(team_2007, file = "hoops_hype_salaryt_2007.csv")
write.csv(team_2008, file = "hoops_hype_salaryt_2008.csv")
write.csv(team_2009, file = "hoops_hype_salaryt_2009.csv")
write.csv(team_2010, file = "hoops_hype_salaryt_2010.csv")
write.csv(team_2011, file = "hoops_hype_salaryt_2011.csv")
write.csv(team_2012, file = "hoops_hype_salaryt_2012.csv")
write.csv(team_2013, file = "hoops_hype_salaryt_2013.csv")
write.csv(team_2014, file = "hoops_hype_salaryt_2014.csv")
write.csv(team_2015, file = "hoops_hype_salaryt_2015.csv")
write.csv(team_2016, file = "hoops_hype_salaryt_2016.csv")
write.csv(team_2017, file = "hoops_hype_salaryt_2017.csv")
write.csv(team_2018, file = "hoops_hype_salaryt_2018.csv")
