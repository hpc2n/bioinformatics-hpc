# Git workflow 

While the workflow will wary depending on your exact requirements, this is a reasonable starting point. 

## Workflow - your Git repo 

This example uses GitHub, but the differences are small between the remote Git repositories and most will be the same if you are using GitLab, Gitea, etc. 

### Preparations - once 

1. Install Git if it is not already installed (https://hpc2n.github.io/bioinformatics-hpc/6.Git/setup/)
2. Configure Git (https://hpc2n.github.io/bioinformatics-hpc/6.Git/setup/#configure__git__all__os) 
3. Test Git (https://hpc2n.github.io/bioinformatics-hpc/6.Git/setup/#test__your__git__installation) 

### GitHub (or similar) accounts and SSH keys - once 

1. Create an account at your chosen Git repository platform, in this example GitHub.
2. Create SSH keys at upload/add them (https://hpc2n.github.io/bioinformatics-hpc/6.Git/setup/#create__a__new__ssh__key__for__github) 

### Create a repository locally (or on GitHub) and prepare it - once per repository 

Here we create it locally. 

1. Create a project folder or navigate to an existing one: 
```bash
mkdir myproject
cd myproject
```
2. Initialize Git (create a .git folder and starts tracking everything within your project folder): 
```bash
git init
```
3. Add once or more files. One of them should preferrably be ``README.md`` with info about the repository. 
4. Stage and commit the file(s):
```bash
git add README.md
git commit -m "A great commit message"
```
If you want to add all modified and new files in the current directory and below it, you can use (careful): 
```bash
git add .
```
Check with ``git log`` that all was added and committed. 
5. Create a repository on GitHub 
    a. Click the ``+`` and select ``New repository``. 
    b. Name it the same as your local project folder. (Here, ``myproject``). 
    c. Do not choose to initialize it with a readme - you are using the file in your local project! 
    d. Click "Create repository"
6. You now want to push the local project to GitHub for the first time for the repo. Do this locally (change to your own username): 
```bash
git branch -M main
git remote add origin git@github.com:<your-username>/myproject.git
git push -u origin main
```
7. It is now setup. You should also add a ``.gitignore`` with file types and directories you do not want Git to track. Add, commit, and push. 
8. Create reasonable directories: ``mkdir scripts results data``
9. Add some initial text to a file in each directory. Add, commit, push. 

### Work with your project - regularly/each time you added something

1. Are you collaborating with someone who may add to the repository? Do you, yourself, work on it on more than one computer? If yes, ALWAYS start with ``git pull --rebase`` before you start working for the day. 
2. Work on your project. Add/modify files. 
3. 
    a. Check with ``git status`` if you have something that is not added/committed.
    b. If so, ``git add FILE(S)``, ``git commit -m "Write a good commit message so you can later recognize what is in this change"``
    c. Do ``git pull --rebase`` in case others have updated something while you worked. 
    d. Then do ``git push``


