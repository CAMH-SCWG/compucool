---
layout: default
---

Before we get started
---------------------

* Start RStudio. 
* Under the `File` menu, click on `New project`, choose `New directory`, then
  `Empty project`
* Enter a name for this new folder, and choose a convenient location for
  it. This will be your **working directory** for the rest of the day
  (e.g., `~/workshop`)
* Click on "Create project"
* Under the `Files` tab on the right of the screen, click on `New Folder` and
  create a folder named `data` within your newly created working directory.
  (e.g., `~/workshop/data`)
* Create a new R script (File > New File > R script) and save it in your working
  directory (e.g. `data-party.R`)

Your working directory should now look something like this:

![How it should look like at the beginning of this lesson](https://raw.githubusercontent.com/pipitone/camh-computing-skills-august-2015/gh-pages/img/r_starting_how_it_should_like.png)


Interacting with R
------------------

**Console**

This is pretty similar to the interactive terminal in BASH. You can tell R what to do, 
and it will show the results. In RStudio, this is the bottom left panel. This is what 
you would see if you ran `R` in your terminal.

The R console shows a `>` prompt if it is ready to accept commands. Commands are sent by
by typing, copy-pasting, or from the script editor using `Ctrl-Enter`). R execute it and 
show the results.

The R console shows a `+` prompt if the command isn't complete. Typically this is because
you are missing a bracket or quotation. You can split long commands over multiple lines without any problem.

Please do this! It makes your scripts **so** much easier to read.

If Rstudio seems stuck, click inside the console window and press `Esc`.

**Script Editor**

It's a good idea to enter your commands in the script editor. Think of it as your lab notebook. 
This way, you have a complete record of what you did, and can later turn it into a script for 
a friend (or your best friend -- future you) to use. It also really helps at the review stage because
it is no work at all for you to show others how you obtained your groundbreaking results. 

R Basics
--------

+ Open Source :D
+ Over 7,000 user contributed packages at this time (you can do, like, anything). 
+ Used both in academia and industry (i.e., jawbs + $$$).
+ Available for any platform.

**Comments**

Use `#` signs to comment. Comment liberally in your R scripts. Anything to the
right of a `#` is ignored by R.

**Assignment**

`<-` is the assignment operator. It assigns values on the right to objects on
the left. So, after executing `x <- 3`, the value of `x` is `3`. The arrow can
be read as 3 **goes into** `x`.

**Functions**

Functions are "canned scripts" that automate something. A function usually gets 
one or more inputs called *arguments*. Functions often (but not always) return a 
*value*. 

For example, `sqrt()` takes an input argument (number), and returns the square root 
of that number. Executing a function ('running it') is called *calling* the function. 
An example of a function call is:

```
b <- sqrt(a)
```

You might notice that this is silly, because in every other language you would use a `=`. 
You can also use `=` for assignments, but not in all contexts, so it is good practice 
to use `<-`. 

`=` should only be used to specify the values of arguments in functions:

```
surveys <- read.csv(file="data/surveys.csv")
```

Here, we've loaded an entire dataset into the variable `surveys`. 
Arguments can be about pretty much anything, many are optional and/or have defaults. 
To see what arguments are available, you can use `args(read.csv)`, `help(read.csv)`, and 
`example(read.csv)`.

Organizing Your Working Directory
---------------------------------

Typically, an analysis will involve some (valuable) raw data, maybe some intermediate files, and some outputs.

Consider the following:

    project/
        raw/       -- raw data
        tmp/       -- intermediate files (won't always need this)
        outputs/   -- outputs
        bin/       -- scripts that turn raw into outputs

There are a few reasons this is a good way to work:

+ Your raw data will not be cluttered with intermediate & output files. In most cases, your scripts will
  generate a lot of undesirable outputs before they will [do the right thing](https://www.youtube.com/watch?v=EUv3iZ4PafM),
  so it is better to put these files in other folders where they can be easily (and safely) deleted.
+ Your intermediate files, depending on your data and analysis, might be very large. This makes it easy
  to delete them after you've ensured that your analysis is working properly.
+ Your code is your method. Your supervisior, reviewers, and your future self will all appreciate
  you storing your code in a place that will regenerate your outputs *on demand* with no/minimal effort.

Getting Help
------------

+ [Google](http://lmgtfy.com/?q=google)
+ [StackOverflow](http://stackoverflow.com/questions/tagged/r)
+ [Introduction to R](http://cran.r-project.org/doc/manuals/R-intro.pdf)
+ [R-help](https://stat.ethz.ch/mailman/listinfo/r-help)
+ Show us/your friends your code.

More Syntax
-----------

* Let's play find the things:
  - a function
  - the assignment operator `<-`
  - the `=` for arguments
  - the comments `#` and how they are used to document function and its content
  - the `$` operator
* Point to indentation and consistency in spacing to improve clarity

![Example of a simple R script](https://github.com/pipitone/camh-computing-skills-august-2015/blob/gh-pages/img/r_starting_example_script.png)

Let's assign a value to a variable, and manipulate it:

    weight_kg <- 55
    2.2 * weight_kg
    weight_kg

That didn't quite work, because we didn't assign this new number back to `weight_kg`.

```
weight_lb <- 2.2 * weight_kg
```

A vector is a list of similar things. For example, it can be a bunch of numbers, or words (strings), but not both.

```
weights <- c(50, 60, 65, 54, 23)
weights

animals <- c("mouse", "rat", "dog", "ghost")
animals

ivemadeahugemistake <- c("but", 1, "why???")
ivemadeahugemistake
```

R tuned our `1` (number) into a `"1"` (string). `:(`

We can also have a look at the number of items inside of a vector:

```
length(weights)
length(animals)
```

And we can find things within them:

```
# return 'logical' array
("ghost" == animals) 

# return 'index'
which("ghost" == animals)

# works for numbers too
which(65 == weights)

# find all the things smaller than 65
which(weights < 65)
```

Data Frames
-----------

Most of the time we aren't going to want to work with a single vector. We're going to want 
to work with a whole bunch of them, which is all a spreadsheet is.

In `R`, this is called a 'data.frame'. Each column is a vector, and has a name.

[Download the data here.](https://raw.githubusercontent.com/pipitone/camh-computing-skills-august-2015/gh-pages/assets/surveys.csv)

```
surveys <- read.csv('raw/surveys.csv')
```

We are studying the species and weight of animals caught in plots in our study
area. The dataset is stored as a `csv` file: each row holds information for a
single animal, and the columns represent:

| Column           | Description                        |
|------------------|------------------------------------|
| record\_id       | Unique id for the observation      |
| month            | month of observation               |
| day              | day of observation                 |
| year             | year of observation                |
| plot\_id         | ID of a particular plot            |
| species\_id      | 2-letter code                      |
| sex              | sex of animal ("M", "F")           |
| hindfoot\_length | length of the hindfoot in mm       |
| weight           | weight of the animal in grams      |
| genus            | genus of animal                    |
| specie s         | species of animal                  |
| taxa             | e.g. Rodent, Reptile, Bird, Rabbit |
| plot\_type       | type of plot                       |


```
# Getting an overview of your data
head(surveys)
str(surveys)

# getting the size of your data frame
nrow(surveys) # the number of samples we've collected
ncol(surveys) # the number of vectors we've stored

colnames(surveys) # the names of each column
```

This is super handy, because R lets you call any column by name using the `$` symbol.

```
surveys$month
```

Let's have a look at whether the weights recorded follow a normal distribution:


```
hist(surveys$weight)
```

Nope.

Factors
-------

Factors are used to represent categorical data. Factors can be ordered or
unordered.

Factors are stored as integers, and have labels associated with these unique
integers.

Once created, factors can only contain a pre-defined set values, known as
*levels*. By default, R always sorts *levels* in alphabetical order. For
instance, if you have a factor with 2 levels:

```
sex <- factor(c("male", "female", "female", "male"))
```

R will assign `1` to the level `"female"` and `2` to the level `"male"` (because
`f` comes before `m`, even though the first element in this vector is
`"male"`). You can check this by using the function `levels()`, and check the
number of levels using `nlevels()`:

```
levels(sex)

nlevels(sex)
```

In the case of ordinal variables, you need to specify this with the `ordered` argument:

```
food <- factor(c("low", "high", "medium", "high", "low", "medium", "high"))

levels(food)

food <- factor(food, levels=c("low", "medium", "high"))

levels(food)

min(food) ## doesn't work

food <- factor(food, levels=c("low", "medium", "high"), ordered=TRUE)

levels(food)

min(food) ## works!
```

Inspecting Data Frames
----------------------
We already saw how the functions `head()` and `str()` can be useful to check the
content and the structure of a `data.frame`. Here is a non-exhaustive list of
functions to get a sense of the content/structure of the data.

* Size:
    * `dim()` - returns a vector with the number of rows in the first element, and
    the number of columns as the second element (the __dim__ensions of the object)
    * `nrow()` - returns the number of rows
    * `ncol()` - returns the number of columns
* Content:
    * `head()` - shows the first 6 rows
    * `tail()` - shows the last 6 rows
* Names:
    * `names()` - returns the column names (synonym of `colnames()` for `data.frame`
  objects)
   * `rownames()` - returns the row names
* Summary:
   * `str()` - structure of the object and information about the class, length and
  content of  each column
   * `summary()` - summary statistics for each column

Note: most of these functions can be used on other types of objects besides `data.frame`.

Indexing and sequences
----------------------
If we want to extract one or several values from a vector, we must provide one
or several indices in square brackets. 

```
animals <- c("mouse", "rat", "dog", "cat")

animals[2]

animals[c(3, 2)]

animals[2:4]

more_animals <- animals[c(1:3, 2:4)]

more_animals
```

`:` creates numeric vectors of integer in increasing or decreasing order.
Test `1:10` and `10:1` for instance. The function `seq()` (for `seq`uence) 
can be used to create more complex patterns:

```
seq(1, 10, by=2)

seq(5, 10, length.out=3)

seq(50, by=5, length.out=10)

seq(1, 8, by=3) # sequence stops to stay below upper limit
```

Our survey data frame has rows and columns (it has 2 dimensions), if we want to
extract some specific data from it, we need to specify the "coordinates" we want
from it. Row numbers come first, followed by column numbers.

```
surveys[1, 1]   # first element in the first column of the data frame
surveys[1, 6]   # first element in the 6th column
surveys[1:3, 7] # first three elements in the 7th column
surveys[3, ]    # the 3rd element for all columns
surveys[, 8]    # the entire 8th column
head_surveys <- surveys[1:6, ] # surveys[1:6, ] is equivalent to head(surveys)
```

Where do we go from here?
-------------------------
`R` is totally vast. If you can think of a statistic, it lives somewhere in R's massive library system. The question of where to go from here depends more on the kind of science you do.

What we know so far:

+ How to organize our data.
+ How to find help.
+ R syntax.
+ Vectors and data frames.
+ Numbers (continuous) vs Factors (categorical/ordinal) variables.
+ Indexing (finding the things you want).
+ Basic plotting.

Next steps on [Software Carpentry](https://software-carpentry.org/v5/novice/r/):

+ Analyzing patient data (similar to what we covered).
+ Creating functions (save repeating yourself).
+ Analyzing multiple data sets (use loops to apply this function over lots of data).

Or, we could talk about some statistics:

+ But I need you to tell me what to talk about!






