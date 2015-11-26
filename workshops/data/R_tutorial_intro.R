# R Workshop syllabus (Erin/Dan) Code

#load libraries
library("rms")
library("ggplot2")
library("car")

# read in data
data1 <- read.csv("~/Downloads/Rtutorial_data1.csv")
data2 <- read.csv("~/Downloads/Rtutorial_data2.csv")

### The "help document" for the read.csv function is shown in the "Help" tab
?read.csv

## type head(data1): this shows you the first 6 rows
head(data1)
## type tail(data1): this shows you the last 6 rows
tail(data2)
## Using the function "names" tells us what all the variables in our dataframe are called
names(data1)
ls(data1)
## That was all nice, but we want to find out more about this data we can use "summary"
summary(data1)
summary(data2)
## Another very useful function is describe  - (from the rms package)
describe(data1)
describe(data2)

## Clean data1
data1[data1==""] <- NA
data1[data1=="missing"] <- NA
data1[data1=="9999"] <- NA

##set variable types for data1
data1$age <- as.numeric(as.character(data1$age))
data1$ethnicity <- factor(data1$ethnicity,levels=c("Cauc","AA","As","In","Other"))
data1$sex <- factor(data1$sex, levels=c(0,1), labels=c("Male","Female"))
data1$dx <- factor(data1$dx, levels=c(0,1), labels=c("Control","Case"))

## clean data2
data2[data2==""] <- NA
data2[data2=="missing"] <- NA
data2[data2=="9999"] <- NA

## set variable types for data2
data2$genotype <- factor(data2$genotype, levels=c(0,1,2), labels=c("AA","AG","GG"))
data2$cog1 <- as.numeric(as.character(data2$cog1))
data2$cog2 <- as.numeric(as.character(data2$cog2))
data2$cog3 <- as.numeric(as.character(data2$cog3))

## get subject ID names to match
data2$subID <- gsub(data2$subID,pattern="subject",replacement="SUB_")

## merge the datasets
alldata <- merge(data1,data2,by.x="subject_ID",by.y="subID")
