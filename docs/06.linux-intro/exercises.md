# Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later. 

Useful files for these examples are found in `exercises/06.linux-intro/patterns` from the tarball.
 
## The Linux File System - Wildcards

1. Using wildcards, match all file names that begin with `thisfile`, followed by one or more numbers, and end with `.txt` 
2. Using wildcards, match all file names with a number in them. 
3. Using wildcards, match all file names that has a `0` in them. 

## Modifying the file tree - cp, mv, rm 
 
1. Create a directory named `bio`. Change to the directory. Create two subdirectories. Enter one of them. Create three files (using either `touch` or an editor). 
2. Create another directory, at the same level as the directory named `bio`. Copy the files and directories form `bio` into your new directory. 
3. Enter your new directory. Create four files. Create a subdirectory. Move the files to the new subdirectory.
4. Enter the directory `bio`. Rename one of the subdirectories. Create another subdirectory. Remove a file. Remove one of the subdirectories. Try removing one with files in it and one without. What extra option do you need to remove a directory, a directory with files in, and a regular file? 

## Modifying the file tree - symbolic links 

1. Create a symbolic link in your home directory to the `patterns` subdirectory inside the extracted tarball. 

## Data handling - archiving and compressing 

1. Create a tarball containing the `exercises/06.linux-intro` files and directories, but not the exercises from the other sections. 
2. Use `rsync` to transfer files between two of your directories. 

## Pipes and filters 

1. Using `cat` and redirect, create a new file named `myfancyfile.txt` with several lines of text (at least 10 lines). Save it as in the exercise on https://hpc2n.github.io/bioinformatics-hpc/06.linux-intro/pipesfilters/#exercises 
2. Use `head` and `tail` to see the first and last few lines of text. 
3. Use `wc` to count the number of lines, the number of characters, and the number of words in your file. 
4. Use `sort` to sort the lines. 

## Finding patterns 

1. Use pipes to first do `wc` on a file and then `sort` the output. 
2. In the directory `exercises/06.linux-intro/patterns`, use `grep` to search for the word `string` and the word `text`. Do the same while adding `-i` to ignore case. 
3. Standing in the top level directory of exercise directories for the "Introduction to Linux" section (`exercises/06.linux-intro`), use find to find all files with the suffix `.txt`. 
4. Use regular expressions to find all lines in the file `myfile3.txt` in the `exercises/06.linux-intro/patterns` directory that has a word starting with `A` at the beginning of the line. 

## Linux tools: awk 

The directory `exercises/06.linux-intro/awk-qol` has a file `file.dat` which is useful for these exercises. 

1. Print column 4 and 6 from file `file.dat`, but only those rows that contain the letter ‘v’. 






