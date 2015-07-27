---
layout: default
---

# Introduction to the Linux Shell

**Motivation:** The shell is one of the most basic ways you can interact with a
computer and it allows you to automate your analysis. It is often the *only*
way to interact with scientific computing environments (e.g. SCC, SciNet), so
you'll have to learn it eventually. 

**Prerequisites:** Minimal familiarity with the shell (e.g. you should know
what the commands `cd`, `ls`, `mv`, `cp`, `rm` and `man` do).


**What you will learn:** Running commands on many files (globbing, looping, if
statements), reading and writing to files, sorting/filtering data in files

Things to read: 

- [SWC: Novice Shell Workshop](http://swcarpentry.github.io/shell-novice)
- [SWC: Bash Reference](http://swcarpentry.github.io/shell-novice/reference.html)
- [Bash Cheat Sheet](http://pipitone.github.io/computing-skills/bash-cheat-sheet)
- [Slides: Intro to Shell](https://docs.google.com/presentation/d/1HawszQmhH4c2YCoOmFWgOlWpxw0-O8LVO6mPtneG7cI/edit?usp=sharing)

--------

### Getting started

```sh
# connect to the SCC
ssh test_user@login.scc.camh.net

# make a folder for yourself, and cd into it
mkdir given-name_family-name          # e.g. jon_pipitone
cd jon_pipitone

# Run a script to generate the data for this workshop
bash ~jpipitone/make-data.sh
```

The `make-data.sh` script can be found here: 
https://raw.githubusercontent.com/pipitone/computing-skills/7128668508a8495d302bed5f396c7bb0b732961c/bin/make-data.sh

### Exploring the data
The script you ran generates a phoney dataset of imaging and genetics data for
a number of subjects in a folder called `data`. Have a look around.

```sh
# for example: 
ls data
cd data
ls S000
cd ..
```

Q: How do you see what is in the demographics file? 
> ```sh
> $ cat data/S000/demographics.csv
> $ less data/S000/demographics.csv     # alternatively
>
> ```

Q: How do you find out the size of the files in a subject folder? 
> ```sh
> $ ls -l data/S000
> total 16
> -rw-rw-r-- 1 jp jp   35 Mar  9 16:05 demographics.csv
> -rw-rw-r-- 1 jp jp 5050 Mar  9 16:05 genome.dat
> -rw-rw-r-- 1 jp jp 2471 Mar  9 16:05 T1.nii
> ```

Q: How many lines are there in the `genome.dat` file? 

For this you are going to need to know a new command, `wc`, which stands for
"word count". If you run `wc file` it will print three things: the number of
characters in the file, the number of words, and number of lines. Try it. 

> ```sh
> $ wc data/S000/genome.dat
>  50   50 5050 data/S000/genome.dat
> ```

You can also use the `-l` option to only show the number of lines: 
> ```sh
> $ wc -l data/S000/genome.dat
>  50 data/S000/genome.dat
> ```

Q: How many subjects are there? 

First, make a list of the subject folders using `ls`: 

> ```sh
> $ ls data
> ```

Then, *pipe* that list into the `wc` command: 
> ```sh
> $ ls data | wc -l
> 101
> ```

Anything you pipe into `wc` gets counted. Try it with the `history` command,
for instance. 

Q: How many subjects have a `T1.nii` image? 

You can use `ls` with a wildcard to match all of the subject folders: 
> ```sh
> $ ls data/*/TI.nii      # lists all of the T1.nii files in subfolders of data
> ```

And then you can pipe into `wc -l` to count that list. 

Q: How many subjects have a `T1.nii.gz` image? 
> ```sh
> # your turn
> ```

Q: How many subjects have either a`T1.nii` or a `T1.nii.gz` image? 
> ```sh
> # your turn
> ```

Q: Which subjects don't have a T1.nii file? 
> ```sh
> # This is trickier. We'll cover this one next time. :-)
> ```

### Merging and filtering text
Since each subject had a `demographics.csv` file, it would be nice to collect
all of it into a single CSV so that we could analyse it.

- Use the `cat` command to concatenate all of the demographic data (hint: use
   a wildcard). 

     > ```sh
     > $ cat data/*/demographics.csv
     > ```

We can use the program `grep` to filter lines that match a certain pattern.
For instance, to show only the males ('`M`'), we could pipe the output to
`grep` like so: 

```sh
$ cat data/*/demographics.csv | grep M
```

- Q: How do you search for only the female subjects? 

- Q: How many male subjects are there? (hint: use `wc`)
     > ```sh
     > $ cat data/*/demographics.csv | grep M | wc -l
     > ```

- Q: How many female subjects and total # of subjects are there? (hint: use
  `wc`)


Hmm.. looks like there are some subjects we don't know the sex of. We can use
the `sort` to order text by line. Since sex is the first column, it will sort
the lines by sex. 

- Q: Sort the demographic data by piping it into the `sort` command. 
     > ```sh
     > $ cat data/*/demographics.csv | sort
     > ```

- Q: Pipe the results into `head` to show the top part of the sorted list. 

- BONUS: `sort` can sort on a specific column only, but you have to tell it how
  to find the columns in your data. If you're feeling bold, check the `man`
  page or google. 
     > ```sh
     > # to sort the second column of CSV data
     > $ cat data/*/demographics.csv | sort --field-separator=, --key=2,2
     > 
     > # By default, sort sorts everything as text. To tell it to sort
     > # numerically, pass the -n option.
     > $ cat data/*/demographics.csv | sort --field-separator=, --key=2,2 -n
     > ```

Next, we'll save the concatenated data into a file by *redirecting* the output
of the command into a file using the `>` operator. 

```sh
cat *files* > master.csv
```

The `>` operator takes anything the command before it prints out and prints
it to the named file instead of displaying it on the terminal.

- Q: How would you save just the male demographic data to a file? 

- Q: How would you use `grep` to filter your data in a file? 
     > ```sh
     > # You can pipe to grep
     > $ cat master.csv | grep M
     > 
     > # Or, more simply, you can tell grep to search through the file
     > $ grep M master.csv
     > ```

### Organizing your data

In order to do some analysis you now want to collect all of your data types
into separate folders by type (i.e. put all of your genome data together in one
folder, all of your imaging data together in another, etc). 

- Make a folder for your imaging data called `genomes`
    > ```sh
    > $ mkdir genomes
    > ```

- Copy a few subject's `genome.dat` files to the `genomes` folder. 
    > ```sh
    > $ cp data/S000/genome.dat genomes/
    > $ cp data/S001/genome.dat genomes/    # oops, name conflict.. 
    > 
    > # okay, we can use copy to rename as we go
    > $ cp data/S000/genome.dat genomes/S000_genome.dat
    > $ cp data/S001/genome.dat genomes/S001_genome.dat
    > ...
    > ```

We need a way to rename our files automatically, one by one. And this is where
a loop comes in handy. 

For example, here is a list that prints numbers 1-5: 

```sh
$ for i in 1 2 3 4 5 
  do
    echo ${i}        # gets run for each number
  done
```

A few new things here: 

- `i` is called the "loop variable", each time through the loop, `i` takes on
  a different value from the list. 

- The list of things `i` takes turns getting set to is everything after the
  `in`.

- All lines between `do` and `done` get run once for each value of `i`

- `${i}` is shell-speak for "the value of `i`". Get it? `$` equals "value"... :-) 

- Q: How would you print out the letters `a` through `e`. 
      > ```sh
      > $ for j in a b c d e f 
      >   do
      >     echo ${j}
      >   done
      > ```

The list in a for-loop can also be made up of a wildcard that matches files.
So, for instance you can loop through all of the files and folders in your
current working directory like so: 

```sh
$ for path in * 
  do
    echo Found: ${path}
    ls -l ${path}
  done
```

- Q: Using a for-loop, print out all of the folders in the `data/` directory.
      > ```sh
      > $ for folder in data/*
      >   do
      >     print ${folder}
      >   done
      > ```

- Q: Using a for-loop, print out the number of lines for each of the genome.dat
files. 
      > ```sh
      > $ for i in data/*/genome.dat
      >   do
      >     wc -l ${i}
      >   done
      > ```

    You could have also done this like so: 
      > ```sh
      > $ for i in data/*
      >   do
      >     wc -l ${i}/genome.dat
      >   done
      > ```

Okay, we're ready to move and rename some files. We'll first do it in a bit of
a cumbersome way, and then show you how to do it more easily. 

1. First `cd` into your `data/` folder. 
2. From your `data/` folder, how would you copy subject S045's `genome.dat`
   file into the `genomes` folder?

     > ```sh
     > $ cp S045/genome.dat ../genomes
     > ```
3. Write a for-loop that prints the names of all of your subject folders.
   (hint: you just did this a few moments ago :-)

     > ```sh
     > $ for i in *; do 
     >     echo ${i}
     >   done
     > ```
4. Edit the for-loop to `echo` a command to `cp` the `genome.dat` file from
   each subject folder to the `genomes` folder. 

     > ```sh
     > $ for i in *; do 
     >     echo cp ${i}/genome.dat ../genomes
     >   done
     > ```
5. The last thing we need to do is give our file a new name once it is in
   `../genomes`. Since`${i}` is the name of our subject, we can use that in our
   name. Edit the for loop to copy each subject's `genome.dat` file to
   `S045_genome.dat`, etc. 

     > ```sh
     > $ for i in *; do 
     >     echo cp ${i}/genome.dat ../genomes/${i}_genome.dat
     >   done
     > ```
6. Okay, remove the `echo` and run your for-loop for real!

### Scripts

If you put shell commands in a text file (a so-called "shell script"), you can
easily re-run those commands: 

```sh
$ bash commands.sh    # this runs everything in commands.sh
```

The convention is to name our shell scripts with a `.sh` ending. 

- Q: Using nano, make a script file called `organise_genomes.sh` in your
  project folder that does two things: a) makes the `genomes` folder, and b)
  copies your genome data into that folder. 

     > ```sh
     > $ cat organize_genomes.sh
     > mkdir -p genomes     # -p tells mkdir to be quietly if the folder exists
     > cd data/
     > for i in *; do 
     >     cp ${i}/genome.dat ../genomes/${i}_genome.dat
     > done
     > ```

- Q: Remove your `genomes` folder, and run the `organize_genomes.sh` script. 

    > ```sh
    > $ rm -rf genomes/
    > $ bash organize_genomes.sh
    > ```

#### Bonus section
The last thing we'll do is a bit more advanced, but will make your script
friendlier since it won't need to `cd` into your `data/` folder in order to
work. 

There is another command called `basename` which, given a path, returns the
last part of the path, either a filename or deepest folder in the path. For
example, 

```sh
$ basename data/S000/genome.dat
genome.dat
$ basename data/S000
S000
```

One other trick. At any point in a shell script you can call another command
and get its value by putting that command inside parentheses,`$(...)`. For example, 

```sh
$ echo The time is $(date) right now
The time is Tue Mar 10 08:34:38 EDT 2015 right now

$ echo The basename is $(basename data/S000/genome.dat)
The basename is genome.dat

$ echo cp data/S000/genome.dat $(basename data/S000)
cp data/S000/genome.dat S000
```

We can re-write our loop to use `basename` to give the proper names out our
files. When you're doing this exercise, rather than type things out on the
command line you can edit your commands.sh script and run it. That way you have
a record of what you've done. 


1. Start with a for-loop that loops over all the subject folders in your
   `data/` folder.
     > ```sh
     > $ for i in data/*; do 
     >     echo $i
     >   done
     > ```

2. Each time through the loop, echo a `cp` command that copies the `genome.dat`
   file to `genomes/`. Don't worry about giving it a name yet. 
     > ```sh
     > $ for i in data/*; do 
     >     cp $i/genome.dat genomes/
     >   done
     > ```

3. Now use `basename` to get the subject folder name (i.e. turn
   `data/S015` into `S015`) using the `$(...) notation so that we can use that
   in the name of the target file we're copying to.  
     > ```sh
     > $ for i in data/*; do 
     >     cp $i/genome.dat genomes/$(i)_genome.dat
     >   done
     > ```
