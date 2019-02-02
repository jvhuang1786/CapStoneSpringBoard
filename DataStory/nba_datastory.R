

# Your Capstone project milestone report is an early draft of your final Capstone report. 
# We encourage you and your mentor to plan multiple milestones if possible, 
# since your story will evolve with exploration and analysis. 
# This is a slightly longer (3-5 page) draft that should have the following:
  
An introduction to the problem (based on your earlier Capstone submissions).

A deeper dive into the data set:
  
  What important fields and information does the data set have?
  
  What are its limitations i.e. what are some questions that you cannot answer with this data set?
  
  What kind of cleaning and wrangling did you need to do?
  
  Any preliminary exploration you’ve performed and your initial findings.

Based on these findings, what approach are you going to take? 
  How has your approach changed from what you initially proposed, if applicable?
  Submission

# Add your code and milestone report to the github repository.
# Submit the link to your milestone report.
# Revise your milestone report based on your mentor's feedback and update your repository.
# Once your mentor has approved your milestone document, 
# share the github repository URL in the community and ask for feedback.

#Loading in the library
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(data.table)
library(ggrepel)
library(directlabels)
library(gridExtra)
options(max.print = 999999999)
options(scipen=12)

#loading the data 
#set directory 
getwd()
setwd("/users/justinvhuang/desktop/nba_stat_salaries")
getwd()

#loading in the data
data<-read.csv("2018_2000_nba.csv")
data <- data[,-1]

# looking at the data
glimpse(data)
head(data)
names(data)

#Graphical Analysis
#scatterplot
#####wins and salary
summary(data)
str(data)