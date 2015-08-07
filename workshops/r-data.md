---
layout: default
---

# Data wrangling and Statistics in R
http://bit.ly/camh-r-data

## Data

- [demograhics.csv](http://pipitone.github.io/camh-computing-skills-august-2015/workshops/demographics.csv)
- [volumes.csv](http://pipitone.github.io/camh-computing-skills-august-2015/workshops/volumes.csv)
- [wm.csv](http://pipitone.github.io/camh-computing-skills-august-2015/workshops/wm.csv)


Load the data: 

    demographics = read.csv('demographics.csv')
    volumes = read.csv('volumes.csv')
    wm = read.csv('vm.csv')
    

## Filter (subset)

    females = subset(demographics, sex = "F")
    # ooooops
    females = subset(demographics, sex == "F")    # use ==
    
    # merging row-wise
    eth1 = subset(demographics, ethnicity == 1)
    eth2 = subset(demographics, ethnicity == 2)
    eth1_2 = rbind(eth1,eth2)
    
    # more complex subsets
    females_eth1 = subset(females, ethnicity == 1) 
    females_eth1 = subset(demographics, sex == "F" & ethnicity == 1) 

## merging data.frames

    data = merge(demographics, volumes)

    # missing subjects in 'volumes'
    data = merge(demographics, volumes, all.x = T)

### Plotting

    plot(cerebral_vol_l ~ Age, data = data)
    abline(fit)
    
    # Now, using ggplot2
    install.packages(ggplot2)
    library(ggplot2)
    ggplot(data = data, aes(x=Age, y=cerebral_vol_l)) + geom_point()
    ggplot(data = data, aes(x=Age, y=cerebral_vol_l)) + geom_point() + geom_smooth(method='lm')
    
    # histogram 
    hist(data$cerebral_vol_l)
    ggplot(data, aes(x=cerebral_vol_l)) + geom_histogram()
    
    # PDF (can also manually use export in RStudio)
    pdf("histogram.pdf")
    hist(data$cerebral_vol_l)
    dev.off()
    
    ?barplot
    ?boxplot
    ?plot.default
