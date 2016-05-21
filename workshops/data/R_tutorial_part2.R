### SESSION 2
# we need 'rms', 'ggplot2', and 'car' packages
# if you haven't already installed these:

# load the packages

library(rms)
library(ggplot2)
library(car)
library(dplyr)

# data should be merged and ready to go from day 1. If not, here's the code for it:

data1 <- read.csv("~/Downloads/Rtutorial_data1.csv")  # put in the location of the downloaded data file 1
data2 <- read.csv("~/Downloads/Rtutorial_data2.csv")  # put in the location of the downloaded data file 2

data1[data1==""] <- NA
data1[data1=="missing"] <- NA
data1[data1=="9999"] <- NA

data1$age <- as.numeric(as.character(data1$age))
data1$ethnicity <- factor(data1$ethnicity,levels=c("Cauc","AA","As","In","Other"))
data1$sex <- factor(data1$sex, levels=c(0,1), labels=c("Male","Female"))
data1$dx <- factor(data1$dx, levels=c(0,1), labels=c("Control","Case"))

data2[data2==""] <- NA
data2[data2=="missing"] <- NA
data2[data2=="9999"] <- NA

data2$genotype <- factor(data2$genotype, levels=c(0,1,2), labels=c("AA","AG","GG"))
data2$cog1 <- as.numeric(as.character(data2$cog1))
data2$cog2 <- as.numeric(as.character(data2$cog2))
data2$cog3 <- as.numeric(as.character(data2$cog3))

data2$subID <- gsub(data2$subID,pattern="subject",replacement="SUB_")
alldata <- merge(data1,data2,by.x="subject_ID",by.y="subID")

###### HERE WE GO WITH R PART 2 ######

## RESEARCH QUESTION 3: cog1 ~ dx (t-test)
# 13. Write merged dataframe as new .csv

t.test(data=alldata, cog1 ~ dx)

## Wow we have a result!!
## But one of my favorite things output R is that the statistical output can be saved as an object!! 
my.t.result <- t.test(data=alldata, cog1 ~ dx) # saves to output to my.t.result

print(my.t.result)       ## prints to output to the console
my.t.result$statistic    ## gets us the t statistic!
my.t.result$parameter    ## the degrees of freedom
my.t.result$p.value      ## gets us the p-value

round(my.t.result$statistic,2) ## we can these numbers using the "round" function

## let's put these three together into something we might want to report in our paper
my.t.results.txt = paste0('t(',
                        round(my.t.result$parameter,1),
                        ') = ',
                        round(my.t.result$statistic,2), ', p = ',
                        round(my.t.result$p.value, 7))

# view this as basic boxplots (two ways: base package and ggplot2)

ggplot(data=alldata, aes(y=cog1,x=dx)) + 
	geom_boxplot()

# make it fancier:
## first - let's deal with the NA's we don't want to plot - 
## let's remove them from the plotting dataset
data.toplot <-filter(alldata, !is.na(cog1), !is.na(dx))

ggplot(toplot, aes(y=cog1,x=dx)) + 
	geom_boxplot(outlier.shape=NA) + 
	geom_jitter(alpha=0.5) 

## even fancier - let's add a title, and annotation and label the axes
ggplot(toplot, aes(y=cog1,x=dx)) + 
  geom_boxplot(outlier.shape=NA) + 
  geom_jitter(alpha=0.5) +
  labs(title="Effect of Diagnosis on Cog Score #1",
       y = "Cognitive Test 1",
       x = "Diagnosis") +
  annotate("text", label = my.t.results.txt, x = 1, y = 21) +
  theme_bw()


## NOW LET's save our plot!!!
## Note: we can start by using the "Export" button in the plots tab..
ggsave('figure1_ttestresults.pdf', width = 5, height = 5)

## Let's make a diagnosis by cognition table
my.stats.table <- summarise(alldata,
                            "Mean" = mean(cog1, na.rm = T),
                            "St Dev" = sd(cog1, na.rm = T))

my.stats.table <- alldata %>% 
                  group_by(dx) %>%
                  summarise("Mean" = mean(cog1, na.rm = T),
                            "St Dev" = sd(cog1, na.rm = T))

## RESEARCH AIM 4: total_behaviour_score ~ age (linear regression)
# calculate a composite variable by combining multiple variables
# note new variables can be made easily

# this is the base package way
alldata$totalcog1 <- (alldata$cog1 + alldata$cog3)/alldata$cog2

# using dplyr's mutate verb
alldata <- mutate(alldata, 
                  totalcog = cog1 + cog3 / cog2)

# simple linear regression (two ways: base package and rms)

lm.base <- lm(data=alldata, totalcog ~ age)
lm.rms <- ols(data=alldata, totalcog ~ age)

# compare outputs

lm.base
summary(lm.base)
anova(lm.base)

# to make the most out of rms package functionality, we need to store summary
# stats using the datadist() function. That way, when we call summary() on an
# ols() object (we just made one called "lm.rms") it will give us useful info. 

dd.alldata <- datadist(alldata)
options(datadist="dd.alldata")

lm.rms
summary(lm.rms)
anova(lm.rms)

# visualize results using ggplot2

ggplot(data=alldata, aes(y=totalcog, x=age)) + 
	geom_point() + 
	geom_smooth(method=lm)
	
# Challenge 1: add a title and change the axis labels

# visualize predicted results using rms

plot(Predict(lm.rms))

# check regression assumption of normal residuals

hist(resid(lm.rms))

# they are not normal! We can look at this formally also:

shapiro.test(resid(lm.rms)) 

# let's look at and normalize our outcome...
# two ways of looking at it (base and ggplot2):

hist(alldata$totalcog, breaks=20, col="black")
ggplot(data=alldata, aes(x=totalcog)) + geom_histogram() 

# let's try transforming our variable using log and sqrt transformations
# to see if it helps:

alldata$totalcog_log <- log(alldata$totalcog)
alldata$totalcog_sqrt <- sqrt(alldata$totalcog)

## Challenge - how would you do this with dplyr's mutate function??


# here's a super neat way to optimize power transformations:
# the powerTransform function will calculate the best transform for your data
# it saves the best exponent as the value "lambda"

# calculate the best exponent using powerTransform:
pT <- powerTransform(alldata$totalcog)
# apply the power transform and save the result to a new variable
alldata$totalcog_pT <- alldata$totalcog^pT$lambda ## note ^ is exponent in r

# let's try our regression again with the transformed outcome (using rms):

# Note: if we want to use summary() on our ols() object we will have to redefine datadist
#       since we created new variables that were not in the original datadist object

dd.alldata <- datadist(alldata)
options(datadist="dd.alldata")

## Challenge 2: run a new regression (using ols) with the your new transformed cognitive score as the dependant variable
## get the stats summary

## Challenge 3: use ggplot to make a new plot of this effect

## RESEARCH AIM 5: total_behaviour_score ~ age + sex + genotype (multiple linear regression)
# this is were we start to add covariates and do multiple regression

lm3 <- ols(data=alldata, totalcog_pT ~ age + genotype + sex)
lm3
anova(lm3)
summary(lm3)

# we can easily visualise the effects of each variable on the outcome using rms, but
# this feature does not give us plot points and is not very flexible:

plot(Predict(lm3))

# now let's say we want to recode out genotype variable so that we have only 2 groups:
# those who "carry" the G allele, and those who do not carry it:

alldata$riskcarrier1[alldata$genotype=="AG" | alldata$genotype=="GG"] <- "carrier"
alldata$riskcarrier1[alldata$genotype=="AA"] <- "non-carrier"
alldata$riskcarrier1 <- as.factor(alldata$riskcarrier)

## same thing using dplyr's mutate and plyr's revalue
library(plyr)
alldata <- mutate(alldata, 
                   riskcarrier = factor(revalue(genotype,
                                                  c("AG" = "carrier",
                                                    "GG" = "carrier",
                                                    "AA" = "non-carrier"))))

# re-run the model:

lm3 <- ols(data=alldata, totalcog_pT ~ age + sex + riskcarrier)
lm3
anova(lm3)
summary(lm3)

## RESEARCH AIM 5: total_behaviour_score ~ age*riskcarrier + sex (interaction!)
# the concept of statistical interaction goes by many names and has many definitions.
# Simply this is the concept that the effect of one variable changes depending on
# the value of another variable. Interaction is indicated in R formula syntax with
# a ":" or "*", depending on if you want to automatically include the main effects
# of your interacting variables or not. As a general rule, always use "*".

lm4 <- lm(totalcog_pT ~ sex + riskcarrier*age, data=alldata)
summary(lm4)
anova(lm4)


################################################################# 
## reshaping data to look at all three cognitive scores 


library('reshape2')

### but let's look at all three subscales....
alldata_melted <- melt(alldata, id.vars=c("subject_ID","age","sex", "ethnicity","dx","genotype", "riskcarrier"),
                       measure.vars = c("cog1","cog2","cog3"), 
                       variable.name = "cog_var",
                       value.name = "cognitive.score")

toplot <- filter(alldata_melted, !is.na(cognitive.score), 
                                 !is.na(dx), 
                                 !is.na(riskcarrier))

ggplot(toplot, aes(y=cognitive.score,x=age,color=riskcarrier)) + 
  geom_point() + 
  geom_smooth(method=lm) + 
  facet_wrap(~cog_var, scales = "free")

## LAST CHALLENGE: can you use dplyr to present these statistics in a table??
## LAST BUT NOT LEAST, running a loop to screen for significance at multiple tests (manhattan plot)

outcomes <- names(alldata)[7:13]

p.vals <- numeric(length(outcomes))
for (index in 1:length(outcomes)) {
  outcome <- outcomes[index]
  form <- formula(paste(outcome,"~ sex + age + dx"))
  model <- ols(data=alldata, form)
  p.vals[index] <- anova(model)[3,5]
}

## p.adjust is an awesome way to FDR correct your p-value
p.FDR <- p.adjust(p.vals, method = "fdr")

############ BONUS SECTION - the "right" way to plot....###############
##### How to visualize a significant effect from our regression
##### ...Controlling for the other variables in the model....
# to visualize a given effect more informatively, we want to caculate the residuals 
# of the model lacking our co-varitate of interest and plot those residuals as our outcome:

# for genotype we want a boxplot of model residuals:

lm3.plot <- ols(data=alldata, totalcog_pT ~ genotype + age)

ggplot(data=alldata, aes(y=resid(lm3.plot), x=sex)) + 
  geom_boxplot()

# see it thinks NA is a value! That is because the ols() object stores NA input values
# as NA residuals, and ggplot2 sees these as another level to plot. Fix by re-running
# the model to exclude missing observations and plotting the data subset where NAs are
# excluded:

lm3.plot <- ols(data=subset(alldata,sex!="NA"), totalcog_pT ~ age + genotype)
ggplot(data=subset(alldata,sex!="NA"), aes(y=resid(lm3.plot), x=sex)) + 
  geom_boxplot()

# for age we want a scatterplot of residuals. same subsetting principle applies:

lm3.plot <- ols(data=subset(alldata,age!="NA"), totalcog_pT ~ genotype + sex)
ggplot(data=subset(alldata,age!="NA"), aes(y=resid(lm3.plot), x=age)) + 
  geom_point() + 
  geom_smooth(method=lm)

# CONCEPT: notice that if we include age in our model and plot age on the x-axis in our
# residual plot, the effect is lost - we have modeled it out:

lm3.plot <- ols(data=alldata, totalcog_pT ~ genotype + sex + age)
ggplot(data=alldata, aes(y=resid(lm3.plot), x=age)) + 
  geom_point() + 
  geom_smooth(method=lm)

# To plot the interaction we just tell ggplo2 to plot the regression lines for ou

lm4.plot <- ols(data=subset(alldata,age!="NA" & riskcarrier!="NA"), totalcog_pT ~ sex)
ggplot(data=subset(alldata,age!="NA" & riskcarrier!="NA"), aes(y=resid(lm4.plot), x=age, col=riskcarrier)) + 
  geom_point() + 
  geom_smooth(method=lm)
