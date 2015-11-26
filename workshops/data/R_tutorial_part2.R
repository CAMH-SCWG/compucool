### SESSION 2
# we need 'rms', 'ggplot2', and 'car' packages
# if you haven't already installed these:

# load the packages

library(rms)
library(ggplot2)
library(car)

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

## STUDY QUESTION 3: cog1 ~ dx (t-test)

t.test(data=alldata, cog1 ~ dx)

# view this as basic boxplots (two ways: base package and ggplot2)

boxplot(data=alldata, cog1 ~ dx)

ggplot(data=alldata, aes(y=cog1,x=dx)) + 
	geom_boxplot()

# make it fancier:

boxplot(data=alldata, cog1 ~ dx,outline=F, main="Effect of Diagnosis on Cog Score #1")
stripchart(data=alldata, cog1 ~ dx, metho="jitter",jitter=0.2,vertical=T,add=T,pch=19)

ggplot(data=alldata, aes(y=cog1,x=dx)) + 
	geom_boxplot(outlier.shape=NA) + 
	geom_jitter(alpha=0.5) +
	labs(title="Effect of Diagnosis on Cog Score #1") 

## STUDY QUESTION 4: total_behaviour_score ~ age (linear regression)
# calculate a composite variable by combining multiple variables

alldata$totalcog <- (alldata$cog1 + alldata$cog3)/alldata$cog2

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

# here's a neat way to optimize power transformations:

pT <- powerTransform(alldata$totalcog)
alldata$totalcog_pT <- alldata$totalcog^pT$lambda

# let's try our regression again with the transformed outcome (using rms):

lm2 <- ols(totalcog_pT ~ age , data=alldata)
lm2
anova(lm2)

# if we want to use summary() on our ols() object we will have to redefine datadist
# since we created new variables that were not in the original datadist object

dd.alldata <- datadist(alldata)
options(datadist="dd.alldata")
summary(lm2)

# Let's look at the scatterplot + line of best fit once more:

ggplot(data=alldata, aes(y=totalcog_pT, x=age)) + geom_point() + geom_smooth(method=lm)

## STUDY QUESTION 5: total_behaviour_score ~ age + sex + genotype (multiple linear regression)
# this is were we start to add covariates and do multiple regression

lm3 <- ols(data=alldata, totalcog_pT ~ age + genotype + sex)
lm3
anova(lm3)
summary(lm3)

# we can easily visualise the effects of each variable on the outcome using rms, but
# this feature does not give us plot points and is not very flexible:

plot(Predict(lm3))

# to visualize a given effect more informatively, we want to caculate the residuals 
# of the model lacking our co-varitate of interest and plot those residuals as our outcome:

# for genotype we want a boxplot of model residuals:

lm3.plot <- ols(data=alldata, totalcog_pT ~ age + sex)
ggplot(data=alldata, aes(y=resid(lm3.plot), x=genotype)) + 
	geom_boxplot()

# see it thinks NA is a value! That is because the ols() object stores NA input values
# as NA residuals, and ggplot2 sees these as another level to plot. Fix by re-running
# the model to exclude missing observations and plotting the data subset where NAs are
# excluded:

lm3.plot <- ols(data=subset(alldata,genotype!="NA"), totalcog_pT ~ age + sex)
ggplot(data=subset(alldata,genotype!="NA"), aes(y=resid(lm3.plot), x=genotype)) + 
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

# now let's say we want to recode out genotype variable so that we have only 2 groups:
# those who "carry" the G allele, and those who do not carry it:

alldata$riskcarrier[alldata$genotype=="AG" | alldata$genotype=="GG"] <- "carrier"
alldata$riskcarrier[alldata$genotype=="AA"] <- "non-carrier"
alldata$riskcarrier <- as.factor(alldata$riskcarrier)

# re-run the model:

lm3 <- ols(data=alldata, totalcog_pT ~ age + sex + riskcarrier)
lm3
anova(lm3)
summary(lm3)

## STUDY QUESTION 5: total_behaviour_score ~ age*riskcarrier + sex (interaction!)
# the concept of statistical interaction goes by many names and has many definitions.
# Simply this is the concept that the effect of one variable changes depending on
# the value of another variable. Interaction is indicated in R formula syntax with
# a ":" or "*", depending on if you want to automatically include the main effects
# of your interacting variables or not. As a general rule, always use "*".

lm4 <- lm(totalcog_pT ~ sex + riskcarrier*age, data=alldata)
summary(lm4)
anova(lm4)

# To plot the interaction we just tell ggplo2 to plot the regression lines for ou

lm4.plot <- ols(data=subset(alldata,age!="NA" & riskcarrier!="NA"), totalcog_pT ~ sex)
ggplot(data=subset(alldata,age!="NA" & riskcarrier!="NA"), aes(y=resid(lm4.plot), x=age, col=riskcarrier)) + 
	geom_point() + 
	geom_smooth(method=lm)

	
## MORE FUN
# Extracting/indexing statistics and function output values (returns)
# just like we can get variable values out of a data frame by using the dollar sign
# we can use "$" to get returns out of objects. Returns are values that are stored
# in function outputs. For example, from STUDY QUESTION 4:

lm.rms$fitted.values
lm.rms$stats

# Using indexed items to enhance your plots:

################################################################# ERIN

# b. Plot interaction (ggplot)
## remove NAs from plot
### cog1 show the interaction effect
toplot <- alldata[!is.na(alldata$genotype),]
toplot <- toplot[!is.na(toplot$sex),]
ggplot(toplot, aes(y=totalcog_sqrt, x=age, colour=genotype)) + 
	geom_point() + 
	geom_smooth(method=lm) + 
	facet_wrap(~sex)

ggplot(toplot, aes(y=cog1, x=age, colour=genotype)) + 
	geom_point() + 
	geom_smooth(method=lm) 

ggplot(toplot, aes(y=cog2, x=age, colour=genotype)) + 
	geom_point() + 
	geom_smooth(method=lm) + 
	facet_wrap(~genotype)

ggplot(toplot, aes(y=cog3, x=age, colour=genotype)) + 
	geom_point() + 
	geom_smooth(method=lm) 

toplot <- alldata[!is.na(alldata$riskcarrier),]
toplot <- toplot[!is.na(toplot$sex),]

ggplot(alldata, aes(y=cog1, x=age)) + 
	geom_point() + 
	facet_wrap(~ riskcarrier)
	

# 12. Save workspace (save.image() )
# 
# 13. Write merged dataframe as new .csv


cogvar <- c("cog1","cog2","cog3")
library('reshape2')

### but let's look at all three subscales....
alldata_melted <- melt(alldata, id.vars=c("subject_ID","age","sex", "ethnicity","dx","genotype", "riskcarrier"),
                       measure.vars = c("cog1","cog2","cog3"), 
                       variable.name = "cog_var",
                       value.name = "cognitive.score")

toplot<-subset(alldata_melted, !is.na(cognitive.score))
toplot<-subset(toplot, !is.na(dx))
toplot<-subset(toplot, !is.na(riskcarrier))

ggplot(toplot, aes(y=cognitive.score,x=age,color=riskcarrier)) + 
  geom_point() + 
  geom_smooth(method=lm) + 
  facet_wrap(~cog_var, scales = "free")


## LAST BUT NOT LEAST, running a loop to screen for significance at multiple tests (manhattan plot)

alldata.sub <- subset(alldata, ethnicity=="Cauc")

outcomes <- names(alldata)[7:13]

p.vals <- NULL
index <- 1
for (outcome in outcomes) {
form <- formula(paste(outcome,"~ sex + age + dx"))
model <- ols(data=alldata.sub, form)
p.vals[index] <- anova(model)[3,5]
index <- index + 1
}

# make a plot to visualize the group of results
# multiple comparisons

p.vals.adjusted <- p.adjust(p.vals,method="fdr")
sig <- ifelse(p.vals.adjusted<0.05,19,5)

plot(-log(p.vals,base=10),pch=sig, xaxt="n",
	ylab="-log(raw p-value) for dx", 
	xlab="", 
	main="Effect of Diagnosis on Different Cognitive Scores")
axis(1, at=1:length(outcomes), labels=outcomes, las=2)
par(xpd=T)
text(-log(p.vals,base=10), labels=outcomes, pos=3)
par(xpd=F)
abline(h=-log(0.05),col="red",lty=3)

