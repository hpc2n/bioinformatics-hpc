# Extra exercises 

These exercises are meant as extra (optional) training and can be done either during classes if there is time, or later.

## On your own 

These exercises can be done on your own. 

1. Create a repository from the command line: 
    - Initialize a repository from the command line. 
    - Create a file or two. 
    - Add the file(s) and commit them. 
    - Use `git log` and `git status` to see what has happened. 
2. Create a new, empty repository on GitHub with the same name (do not add README or .gitignore). Instead, on the new page of creation, connect to the local repo (... or push an existing repository from the command lines). Just copy the commands from there to your command line. 
**NOTE** You need to have setup SSH keys on GitHub first. If not, do so as described here: https://hpc2n.github.io/bioinformatics-hpc/07.Git/teamwork/#2__creating__and__using__ssh-keys 
3. See on GitHub that your repository now contains what you had in your local repository. Do `git status` on the command line and compare what it says now. 
4. Create a minor conflict and resolve it with `git pull --rebase`
    - Create a new file on GitHub. Save/commit. 
    - On the command line, create a new file. Stage, commit, and push. Git complains! 
    - Solve the problem with `git pull --rebase` and `git push`
5. Create a conflict and try to resolve it: 
    - Either make changes to the same file in the same place on both GitHub and your repo on the command line or clone the repo somewhere else and make the changes in both local copies of the repo (this imitates the situation where you work on the files from home/your laptop and from your office desktop/laptop. Do not pull the new changes in either place before making new changes (bad idea!) 
    - Now try and push in both places. Git will complain when you try to push in the second location. Git will say there are diverging branches. 
    - Can it be resolved with `git pull --rebase`? Probably not. Try it anyway. There is now a conflict. Find the conflict markers in the file you changed in both locations, decide how it should look and edit to suit. Remove conflict markers. Save. Add, commit, push. 
    - Did Git allow you to push? Did it say you are not currently on a branch? (Detached head). You must then do `git push origin HEAD:main` 

## Teamwork 

Together in a team. 

1. Setup: 
    - One of you create a repository. Either as in the section "On your own" or directly on GitHub. 
    - That person also adds some files. 
    - In "Settings" along the top in the repository on GitHub, the owner of the repository goes to "Collaborators" and there add the team members as maintainers or developers. What is the difference? Do they need the right to create branches? 
    - The members accept the invite. 
2. Each of the other team members now clone this repository. (Green code button -> under SSH, copy the url, do `git clone repo-url`) 
3. All members (including the owner) now make some changes. To begin with, make sure to do `git pull --rebase` first to get any changes the orhers have made. Regularly see the changes that happens locally and in the GitHub remote repository. Check with `git status` and `git log`.
4. Some/all create their own branch. Make some directories and files. Add some content to the files. Stage/commit/push. Check how it looks. 
5. Fetch each others branches.
6. Try and merge some branches to main. Try and merge after having created a file and not having added/committed it. What happens? How do you resolve it? 
7. Create more branches. Make sure you have some files that are named the same and in the same location in the branches. Two should then make changes to the same file in the same location in it. Try and merge the branches. Will Git complain?
8. If you got a conflict, try and resolve it and then continue the merge. 

