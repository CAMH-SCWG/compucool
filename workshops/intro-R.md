---
title: Intro to R
layout: workshop
---

# Introduction to R - with Dan and Erin

--------

**Wifi SSID**: `workshop`


---------

Please download the following files


1. [Rtutorial_data1.csv](/lrn2compute/workshops/data/Rtutorial_data1.csv)
2. [Rtutorial_data2.csv](/lrn2compute/workshops/data/Rtutorial_data2.csv)



***1. RStudio environment***
---


Welcome to R studio! You should see 4 spaces:

1. Source
  + Your script! everything you do to your data should be typed here!! It saves what you are
  doing in a file ending in '.R'
2. Console
  + The place where the good stuff happens. When you run a command, you see the output here.
3. Enviroment/History
  + Enviroment: a list of everything in your "Workspace"
  + History: a list of every command you have run
4. Files/Plots/Packages/Help
  + Files: a file browser (like windows Explorer)
  + Plots: your plots will show up here
  + Packages: a list of all the packages you have installed with checkboxes showing if it is loaded
  + Help: your help documentation with be shown here.


***2. Loading libraries / installing packages / basic scripting practice (comments/why?)***
---

for this tutorial, we are going to use the packages ggplot, rms and car.
+ Look at the Packages Tab
+ Click on the check box to the left of "ggplot2"
+ Notice that a bunch of lines start running in "Console" window to show you that the package is
loading
+ Go to the History Tab (top right corner)
+ Notice that you should see lines starting in library("rms"..) and library("ggplot2"...) have just
run
+ Click on these lines to highlight them, then click on "To Source" at the top of the panel
+ This moves the lines we just ran into our script so we can rerun this step tomorrow!

~~~{.r}
library(rms)
library(ggplot2)
librar(car)
~~~

***3. Read in data***
---

The two datasets provided are as follows:

**Rtutorial_data1.csv:**
+ 5 variables: age, diagnosis (dx), ethnicity, sex, and subject identifier (subject_ID)

**Rtutorial_data2.csv:**
+ 4 variables: three cognitive scores (cog1, cog2, cog3), genotype, and subject identifier (subID)

In order to view and manipulate this data in R, we need to *import* the data into our R workspace
(the same as you would open a file in excel to edit it).

*Rstudio trick:*
+ Click on the "Environment" Tab, then click on "Import Dataset" --> From text File
+ Navigate the browser window to the location of data2.csv and click Open
+ This opens a text reader window: You see the raw text on the top and what R will read in (the data
frame) at the bottom
+ In my view, it looks like the R is not going to read in the first line as a header..to change this
+ switch the "Heading" option on the right to "yes"
+ Click "Import"
+ Now, if you look at the "Environment" tab you should see that "data1" has been loaded into R, It
has 350 rows (or observations) and 5 variables
+ So that you do not have to type this again tomorrow - go to History, click on the line
"data1 <- read.csv(...)" and then click on "To Source"
+ Repeat this whole process for data2.csv

~~~{.r}
data1 <- read.csv("~/Downloads/Rtutorial_data1.csv")
data2 <- read.csv("~/Downloads/Rtutorial_data2.csv")
~~~

+ What you actually did was use the read.csv function... to find out more about this option you can
type "?read.csv" in the Console
+ This is the basic syntax of R functions: some.function("stuff inside to do the function on")
+ The "help document" for the read.csv function is shown in the "Help" tab

Now we have two **"data frames"** loaded into our workspace. They are called data1 and data2.


***4. Basic data summaries and visualization ( head, tail, describe() )***
---
+ Now that we have the data loaded, how do we just look at it? The simplest way is with the "View"
function within rstudio.
+ In Enviroment tab. Click on the little spreadsheet to teh far right of the data1.csv row... this
shows you your data in what looks like a spreadsheet - but you cannot edit it!

To look at the top six rows of your data:

~~~{.r}
head(data1)
~~~

To look at the bottom six rows:

~~~{.r}
tail(data2)
~~~

Using the function names() tells us what all the variables in our dataframe are called.
the ls() function does the same thing, except it returns the variables in alphabetical order

~~~{.r}
names(data1)
ls(data1)
~~~

That was all nice, but we want to find out more about this data we can use "summary"

~~~{.r}
summary(data1)
summary(data2)
~~~

Another very useful function is describe()  - (from the rms package)

~~~{.r}
describe(data1)
describe(data2)
~~~


***5. Data cleaning***
---

+ Now that you have looked at your data - you might have noticed that there are a couple probems
The RA that you have been working with have coded missing values in three different ways ("9999",
"missing",and "NA")
+ We first need to set these all to NA - which R recognizes as missing value:

The following will take all values in data1 that are equal to "", "missing", or "9999", and code
them as missing in a way that R understands:

~~~{.r}
data1[data1==""] <- NA
data1[data1=="missing"] <- NA
data1[data1=="9999"] <- NA
~~~

Because R is "smart", it categorizes data types automatically when data are loaded. Before working
with new data, especailly if it is real (i.e. messy), it is important to tell R what kind of data
you are dealing with. This will be especially important when we discuss our statistical analyses...
after all, R is statistical software.

The following will correctly format our variables for analyses:
+ age is a numeric variable
+ ethicity is a discrete factor
+ sex is a discrete factor
+ diagnosis is a discrete factor

~~~{.r}
data1$age <- as.numeric(as.character(data1$age))
data1$ethnicity <- factor(data1$ethnicity,levels=c("Cauc","AA","As","In","Other"))
data1$sex <- factor(data1$sex, levels=c(0,1), labels=c("Male","Female"))
data1$dx <- factor(data1$dx, levels=c(0,1), labels=c("Control","Case"))
~~~

By indicating the levels of our factors, we have erased from R the memory that we once had values of
"", "9999", and "missing" (which up until now R had no reason to assume were not observations).

Let us now apply the same cleanup steps to our second data frame:

Remove missing:

~~~{.r}
data2[data2==""] <- NA
data2[data2=="missing"] <- NA
data2[data2=="9999"] <- NA
~~~

Correctly format variables for analyses:

~~~{.r}
data2$genotype <- factor(data2$genotype, levels=c(0,1,2), labels=c("AA","AG","GG"))
data2$cog1 <- as.numeric(as.character(data2$cog1))
data2$cog2 <- as.numeric(as.character(data2$cog2))
data2$cog3 <- as.numeric(as.character(data2$cog3))
~~~

***6. Merging data frames***
---

In order to analyze the effect of sex on diagnosis, or perform any other comparison across our data
frames, we should merge them. If you remember only this and nothing else today, it will still have
been worth your time.

Conceptually, merging two data frames assumes that the rows in one correspond to rows in the other,
even if they are not in the same order. In order to match up the correct rows between data frames
we need to make sure that one column in each spreadsheet can act as a "key" (i.e. each row has a
unique value in this key that is the same in both spreadsheets). In our case, we have one subject
identifier column in each of our spreadsheets.

First we need to make sure that the values in these columns are the same:

~~~{.r}
data2$subID <- gsub(data2$subID,pattern="subject",replacement="SUB_")
~~~

We can then merge the two datasets by specifying their names (in order x,y) and then specifying
which columns are to be used as the key to merging the two data frames (by.x and by.y):

~~~{.r}
alldata <- merge(data1,data2,by.x="subject_ID",by.y="subID")
~~~

Skipping ahead a little - now we can look at histograms of our numeric variables, just to see what
we are dealing with:

~~~{.r}
hist(data2$cog1)
hist(data2$cog2)
hist(data2$cog3)
hist(data1$age)
~~~


Now that our data are loaded, cleaned, and merged, it is time to do some basic statistics!

***STUDY QUESTION 1: What is the relationship between sex and diagnosis?***
---

**For this question, our null hypothesis is that there is no difference in the number of males and
females between our case and control diagnosis groups**

The ftable() function will give us a 2 x 2 contingency table of the frequency of observations in
each category. the formula syntax "y ~ x" is common in R!

~~~{.r}
ftable(data=alldata,dx~sex)
~~~

We now want to save that table as an *object* called "dxXsex_table":

~~~{.r}
dxXsex_table <- ftable(data=alldata,dx~sex)
~~~

Now, in order to test our null hypothesis using a chi-squared test, we simply apply the chisq.test()
function to that table:

~~~{.r}
chisq.test(dxXsex_table)
~~~

Similarly, we can use the nonparametric Fisher test to get a more exact test statistic:

~~~{.r}
fisher.test(dxXsex_table)
~~~

*A bit more advanced!*
This will accoplish the same thing as ftable(), except that here we are *indexing* our alldata data
frame with the R syntax [<row>,<column>]. the blank value for <row> tells R that we want all rows.
The c("dx","sex") value for <columns> means we want to use the columns named "dx" and "sex". the
table() function knows to arrange these as a 2 x 2 contingency table.

~~~{.r}
table(alldata[ ,c("dx","sex")])
~~~


***STUDY QUESTION 2: What is the relationship between genotype and diagnosis?***
---

**for this question, our null hypothesis is that there is no difference in the number of males and
females between our case and control diagnosis groups**

~~~{.r}
ftable(data=alldata,dx~genotype)
dxXgene_table <- ftable(data=alldata,dx~genotype)
chisq.test(dxXgene_table)
fisher.test(dxXgene_table)
~~~
