---
layout: default
---

Before we get started
---------------------

* Start RStudio (presentation of RStudio -below- should happen here)
* Under the `File` menu, click on `New project`, choose `New directory`, then
  `Empty project`
* Enter a name for this new folder, and choose a convenient location for
  it. This will be your **working directory** for the rest of the day
  (e.g., `~/data-carpentry`)
* Click on "Create project"
* Under the `Files` tab on the right of the screen, click on `New Folder` and
  create a folder named `data` within your newly created working directory.
  (e.g., `~/data-carpentry/data`)
* Create a new R script (File > New File > R script) and save it in your working
  directory (e.g. `data-carpentry-script.R`)

Your working directory should now look like this:

![How it should look like at the beginning of this lesson](img/r_starting_how_it_should_like.png)


Interacting with R
------------------

**Console**

This is where you can tell R what to do, and where it will show results. 
In RStudio, this is the bottom left panel. This is what you would use if you ran `R` in
your linux terminal.

If R is ready to accept commands, the R console shows a `>` prompt. If it
receives a command (by typing, copy-pasting or sent from the script editor using
`Ctrl-Enter`), R will try to execute it, and when ready, show the results and
come back with a new `>`-prompt to wait for new commands.

If R is still waiting for you to enter more data because it isn't complete yet,
the console will show a `+` prompt. It means that you haven't finished entering
a complete command. This is because you have not 'closed' a parenthesis or
quotation. If you're in Rstudio and this happens, click inside the console
window and press `Esc`; this should help you out of trouble.

**Script Editor**

You can type commands directly into the console, but they will be
forgotten when you close the session. It is better to enter the commands in the
script editor, and save the script. This way, you have a complete record of what
you did, you can easily show others how you did it and you can do it again later
on if needed. 

You can copy-paste into the R console, but the Rstudio script editor allows you to 
'send' the current line or the currently selected text to the R console using 
the `Ctrl-Enter` shortcut.

R Basics
--------

+ Open Source :D
+ Over 7,000 user contributed packages at this time (you can do, like, anything). 
+ Used both in academia and industry.
+ Available for any platform.

**Comments**

Use `#` signs to comment. Comment liberally in your R scripts. Anything to the
right of a `#` is ignored by R.

**Assignment**

`<-` is the assignment operator. It assigns values on the right to objects on
the left. So, after executing `x <- 3`, the value of `x` is `3`. The arrow can
be read as 3 **goes into** `x`.

Functions are "canned scripts" that automate something. A function usually gets 
one or more inputs called *arguments*. Functions often (but not always) return a 
*value*. 

For example, `sqrt()` takes an input argument (number), and returns the square root 
of that number. Executing a function ('running it') is called *calling* the function. 
An example of a function call is:

```R
b <- sqrt(a)
```

You might notice that this is silly, because in every other language you would use a `=`. 
You can also use `=` for assignments, but not in all contexts, so it is good practice 
to use `<-`. 

`=` should only be used to specify the values of arguments in functions:

```R
surveys <- read.csv(file="data/surveys.csv")
```

Here, we've loaded an entire dataset into the variable 'surveys'. 
Arguments can be about pretty much anything, and many are optional, and/or have defaults. 
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

* Point to the different parts:
  - a function
  - the assignment operator `<-`
  - the `=` for arguments
  - the comments `#` and how they are used to document function and its content
  - the `$` operator
* Point to indentation and consistency in spacing to improve clarity

![Example of a simple R script](img/r_starting_example_script.png)

Let's assign a value to a variable, and manipulate it:

```{r, purl=FALSE}
weight_kg <- 55
2.2 * weight_kg
weight_kg
```

That didn't quite work, because we didn't assign this new number back to `weight_kg`.

```{r, purl=FALSE}
weight_lb <- 2.2 * weight_kg
```

A vector is a list of similar things. For example, it can be a bunch of numbers, or words (strings), but not both.

```{r, purl=FALSE}
weights <- c(50, 60, 65, 54, 23)
weights

animals <- c("mouse", "rat", "dog", "ghost")
animals

notkewl <- c("but", 1, "why???")
notkewl
```

R tuned our `1` (number) into a `"1"` (string). `:(`

We can also have a look at the number of items inside of a vector:

```{r, purl=FALSE}
length(weights)
length(animals)
```

And we can find things within them:

```{r, purl=FALSE}
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

In `R`, this is called a 'data frame'. Each column is a vector, and has a name.

```{r, echo=FALSE, purl=FALSE, message = FALSE}
surveys <- read.csv('surveys.csv')
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


```{r, results='show', purl=FALSE}
# Getting an overview of your data
head(surveys)
str(surveys)

# getting the size of your data frame
nrow(surveys) # the number of samples we've collected
ncol(surveys) # the number of vectors we've stored

colnames(surveys) # the names of each column
```

This is super handy, because R lets you call any column by name using the `$` symbol.

```{r, results='show', purl=FALSE}
surveys$month
```

Let's have a look at whether the weights recorded follow a normal distribution:


```{r, results='show', purl=FALSE}
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

```{r, purl=TRUE}
sex <- factor(c("male", "female", "female", "male"))
```

R will assign `1` to the level `"female"` and `2` to the level `"male"` (because
`f` comes before `m`, even though the first element in this vector is
`"male"`). You can check this by using the function `levels()`, and check the
number of levels using `nlevels()`:

```{r, purl=FALSE}
levels(sex)
nlevels(sex)
```

In the case of ordinal variables, you need to specify this with the `ordered` argument:

```{r, purl=TRUE, error=TRUE}
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

Note: most of these functions are "generic", they can be used on other types of
objects besides `data.frame`.

Indexing and sequences
----------------------
If we want to extract one or several values from a vector, we must provide one
or several indices in square brackets. 

```{r, results='show', purl=FALSE}
animals <- c("mouse", "rat", "dog", "cat")
animals[2]
animals[c(3, 2)]
animals[2:4]
more_animals <- animals[c(1:3, 2:4)]
more_animals
```

`:` creates numeric vectors of integer in increasing or decreasing order.
Test `1:10` and `10:1` for instance. The function `seq()` (for __seq__uence) 
can be used to create more complex patterns:

```{r, results='show', purl=FALSE}
seq(1, 10, by=2)
seq(5, 10, length.out=3)
seq(50, by=5, length.out=10)
seq(1, 8, by=3) # sequence stops to stay below upper limit
```

Our survey data frame has rows and columns (it has 2 dimensions), if we want to
extract some specific data from it, we need to specify the "coordinates" we want
from it. Row numbers come first, followed by column numbers.

```{r, purl=FALSE}
surveys[1, 1]   # first element in the first column of the data frame
surveys[1, 6]   # first element in the 6th column
surveys[1:3, 7] # first three elements in the 7th column
surveys[3, ]    # the 3rd element for all columns
surveys[, 8]    # the entire 8th column
head_surveys <- surveys[1:6, ] # surveys[1:6, ] is equivalent to head(surveys)
```
