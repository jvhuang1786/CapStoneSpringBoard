#webscraping with rvest
library(rvest)
library(dplyr)
library(beepr)

team_2018 <- read_html("https://hoopshype.com/salaries/2017-2018/") %>%
  html_nodes("table") %>%  html_table

options(max.print=1000000) 

# salary_2000_2018 <- lapply(paste0("https://hoopshype.com/salaries/players/", 2000-2001:2017-2018),
#                            function(url){
#                              url %>% read_html() %>%
#                                html_nodes("table") %>%  html_table
#                            })

salary_2018 <- read_html("https://hoopshype.com/salaries/players/2017-2018/") %>%
  html_nodes("table") %>%  html_table

salary_2017 <- read_html("https://hoopshype.com/salaries/players/2016-2017/") %>%
  html_nodes("table") %>%  html_table

salary_2016 <- read_html("https://hoopshype.com/salaries/players/2015-2016/") %>%
  html_nodes("table") %>%  html_table

salary_2015 <- read_html("https://hoopshype.com/salaries/players/2014-2015/") %>%
  html_nodes("table") %>%  html_table

salary_2014 <- read_html("https://hoopshype.com/salaries/players/2013-2014/") %>%
  html_nodes("table") %>%  html_table

salary_2013 <- read_html("https://hoopshype.com/salaries/players/2012-2013/") %>%
  html_nodes("table") %>%  html_table

salary_2012 <- read_html("https://hoopshype.com/salaries/players/2011-2012/") %>%
  html_nodes("table") %>%  html_table

salary_2011 <- read_html("https://hoopshype.com/salaries/players/2010-2011/") %>%
  html_nodes("table") %>%  html_table

salary_2010 <- read_html("https://hoopshype.com/salaries/players/2009-2010/") %>%
  html_nodes("table") %>%  html_table

salary_2009 <- read_html("https://hoopshype.com/salaries/players/2008-2009/") %>%
  html_nodes("table") %>%  html_table

salary_2008 <- read_html("https://hoopshype.com/salaries/players/2007-2008/") %>%
  html_nodes("table") %>%  html_table


salary_2007 <- read_html("https://hoopshype.com/salaries/players/2006-2007/") %>%
  html_nodes("table") %>%  html_table


salary_2006 <- read_html("https://hoopshype.com/salaries/players/2005-2006/") %>%
  html_nodes("table") %>%  html_table


salary_2005 <- read_html("https://hoopshype.com/salaries/players/2004-2005/") %>%
  html_nodes("table") %>%  html_table


salary_2004 <- read_html("https://hoopshype.com/salaries/players/2003-2004/") %>%
  html_nodes("table") %>%  html_table


salary_2003 <- read_html("https://hoopshype.com/salaries/players/2002-2003/") %>%
  html_nodes("table") %>%  html_table


salary_2002 <- read_html("https://hoopshype.com/salaries/players/2001-2002/") %>%
  html_nodes("table") %>%  html_table


salary_2001 <- read_html("https://hoopshype.com/salaries/players/2000-2001/") %>%
  html_nodes("table") %>%  html_table


salary_2000 <- read_html("https://hoopshype.com/salaries/players/1999-2000/") %>%
  html_nodes("table") %>%  html_table

beep("mario")


write.csv(salary_2000, file = "hoops_hype_salary_2000.csv")
write.csv(salary_2001, file = "hoops_hype_salary_2001.csv")
write.csv(salary_2002, file = "hoops_hype_salary_2002.csv")
write.csv(salary_2003, file = "hoops_hype_salary_2003.csv")
write.csv(salary_2004, file = "hoops_hype_salary_2004.csv")
write.csv(salary_2005, file = "hoops_hype_salary_2005.csv")
write.csv(salary_2006, file = "hoops_hype_salary_2006.csv")
write.csv(salary_2007, file = "hoops_hype_salary_2007.csv")
write.csv(salary_2008, file = "hoops_hype_salary_2008.csv")
write.csv(salary_2009, file = "hoops_hype_salary_2009.csv")
write.csv(salary_2010, file = "hoops_hype_salary_2010.csv")
write.csv(salary_2011, file = "hoops_hype_salary_2011.csv")
write.csv(salary_2012, file = "hoops_hype_salary_2012.csv")
write.csv(salary_2013, file = "hoops_hype_salary_2013.csv")
write.csv(salary_2014, file = "hoops_hype_salary_2014.csv")
write.csv(salary_2015, file = "hoops_hype_salary_2015.csv")
write.csv(salary_2016, file = "hoops_hype_salary_2016.csv")
write.csv(salary_2017, file = "hoops_hype_salary_2017.csv")
write.csv(salary_2018, file = "hoops_hype_salary_2018.csv")
write.csv(salary_2019, file = "hoops_hype_salary_2019.csv")