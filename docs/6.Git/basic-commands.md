# Basic commands

This section will focus on some of the basic commands of Git and how to use them. 

## Getting help

```console
$ git help <command> 
$ man git-<command>

$ git help commit 
GIT-COMMIT(1)                                     Git Manual                      GIT-COMMIT(1)

NAME
       git-commit - Record changes to the repository

SYNOPSIS
       git commit [-a | --interactive | --patch] [-s] [-v] [-u<mode>] [--amend]
                  [--dry-run] [(-c | -C | --fixup | --squash) <commit>]
                  [-F <file> | -m <msg>] [--reset-author] [--allow-empty]
                  [--allow-empty-message] [--no-verify] [-e] [--author=<author>]
                  [--date=<date>] [--cleanup=<mode>] [--[no-]status]
                  [-i | -o] [-S[<keyid>]] [--] [<file>...]

DESCRIPTION
```

## How Git Organizes Your Project

Git views your files through four main areas:

<figure>
  <img src="../../images/git-folders2.png" style="width: 500px;" alt="Git workflow structure">
  <figcaption>Overview of the main areas Git uses to manage project files.</figcaption>
</figure>

* **Working Directory**: the files currently visible and editable on your computer.
* **Staging Area**: a temporary space where selected changes are prepared before saving.
* **Local Repository**: the project history stored in the hidden `.git` directory on your machine.
* **Remote Repository**: an online copy of the project hosted on services such as GitHub or GitLab.

## Common Git Vocabulary

| Term                  | Description                                     |
| --------------------- | ----------------------------------------------- |
| **commit**            | A recorded snapshot of your project             |
| **repository (repo)** | A project managed by Git, including its history |
| **branch**            | A separate line of development                  |
| **merge**             | Combining work from different branches          |
| **HEAD**              | A reference to your current commit              |
| **remote**            | A repository stored elsewhere online            |
| **clone**             | A local copy of a remote repository             |

## Creating a repository from scratch

In case you want to start a project from scratch called **myproject**:

```bash
$ mkdir myproject
$ cd myproject
$ git init

Initialized empty Git repository in ../myproject/.git/
```

this will create a folder called *.git* in the current folder which contains the Git-related files. 

We can now ask about the status of the repository:

```bash
$ git status 

On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

## Creating a repository by cloning an existing repository

Use the command:

```console
$ git clone repository_location path_where_it_will_be

```

<span style="color:red">*repository_location* </span> is the path of the Git repository (if it is in your local machine) or a URL if it is on the internet. <span style="color:red">*path_where_it_will_be* </span> is the path for the cloned repository.

## Downloading an Existing Repository

To copy an existing project from a hosting platform:

```bash
git clone https://github.com/username/my-project.git ./my-project

cd my-project
```

This downloads the project and its entire history to your machine. Note that since you used ``https://...`` you cannot push to the remote repository. Github only allows that with SSH. 


```console
$ git clone https://github.com/aliceuser2020/my-first-project.git  ./my-project  
Cloning into 'GitCourse/Alice/my-project'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
Checking connectivity... done.

$ cd ./my-project
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
```

## Checking Repository Status

The `git status` command displays:

* modified files
* staged files
* current branch information

```bash
git status
```

Example:

```bash
# On branch master
# No commits yet
# nothing to commit
```

## Creating Your First Commit

The standard Git workflow follows three steps:

1. Modify files
2. Stage changes
3. Commit changes

### Create a file

```bash
echo "Hello, Git!" > README.md
```

### Stage the file

```bash
git add README.md
```

### Save the snapshot

```bash
git commit -m "Add README file"
```

Commit messages should explain the purpose of the change clearly and concisel.

## Staging Multiple Files

```bash
# Add one file
git add file.txt

# Add files matching a pattern
git add *.txt

# Stage everything
git add -A

# Commit tracked files directly
git commit -a -m "Update project files"
```

> `git commit -a` only affects files already tracked by Git.

## Tracking and Saving Changes

### Inspecting Changes

Use `git diff` to compare file versions.

```bash
# Unstaged changes
git diff

# Staged changes
git diff --staged

# Compare against latest commit
git diff HEAD
```

* `+` indicates added lines
* `-` indicates removed lines

### Viewing Commit History

Browse previous commits with `git log`.

```bash
git log
```

Compact format:

```bash
git log --oneline
```

Graphical history:

```bash
git log --all --graph --decorate --oneline
```

Example:

```bash
3a7625b (HEAD -> master) Add README file
1f2cdcc Initial commit
```

## Renaming and Moving Files

Use Git’s built-in move command so history remains intact:

```bash
git mv old-name.txt new-name.txt
```

Move a file into another folder:

```bash
git mv myfile.txt src/myfile.txt
```

These actions are automatically staged.

## Deleting Files

```bash
git rm myfile.txt
```

This removes the file and stages the deltion simultaneously.


## Ignoring Unwanted Files

Some files should never be committed, such as:

* temporary files
* logs
* build outputs
* environment secrets

Create a `.gitignore` file:

```text
*.log
*.tmp
build/
.env
node_modules/
```

Commit it like any other file:

```bash
git add .gitignore
git commit -m "Add ignore rules"
```

## Reverting Changes

### Remove a file from staging

```bash
git restore --staged filename.txt
```

### Discard local edits

```bash
git restore filename.txt
```

> This permanently removes uncommitted modifications.

### Undo the most recent commit safely

```bash
git revert HEAD
```

Git creates a new commit that reverses the previous one.

## Creating Command Aliases

Frequently used commands can be shortened:

```bash
git config --global alias.graph "log --all --graph --decorate --oneline"
```

Now you can simply run:

```bash
git graph
```

## Exercises 



