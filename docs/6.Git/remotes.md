# Working with remotes

Remote repositories allow online backup and team collaboration.

![Git folders](../../images/git-folders2.png)

## General Workflow

```text
Edit → git add → git commit → git push
                          ↑
                      git pull
```

## Adding a Remote Repository

```bash
git remote add origin https://github.com/you/your-project.git
```

List configured remotes:

```bash
git remote -v
```

## Uploading Changes

Send commits to the remote repository:

```bash
git push origin main
```

After initial setup:

```bash
git push
```

## Downloading Updates

Retrieve and merge remote changes:

```bash
git pull
```

Cleaner history using rebase:

```bash
git pull --rebase
```

> A good habit is to pull changes before beginning work and before pushing commits.


## Publishing a New Branch remotely

```bash
git switch -c my-new-branch

# Make changes and commit them

git push -u origin my-new-branch
```

Afterward, standard `git push` and `git pull` commands work automatically for that branch.

## Working with remotes
One can push or fetch/pull to or from remotes:

```shell
$ git push  remote_name branch_name
$ git fetch remote_name branch_name
$ git pull  remote_name branch_name 
```


In case you obtained the repository by cloning an existing one you will have the **origin** remote. You can do push/fetch/pull for this remote with

```shell
$ git push  origin master      
$ git fetch origin master
$ git pull  origin master
```


or 

```shell
$ git push
$ git fetch
$ git pull
```

because the remote *origin* and the *master* branch are configured for pushing and pulling by default upon cloning.


The command: 
```shell
$ git pull
```
brings all the changes (branches) that are in the remote and tries to merge them with the current branch of the local repo. 

In fact, *git pull* is a combination of two commands:
```shell
$ git fetch remote_name branch_name
$ git merge remote_name/branch_name
```

If you want to fetch all branches and merge the current one:

```shell
$ git fetch 
$ git merge
```


The command
```shell
$ git push 
```
will send the changes in the current branch to the remote by default.


## Displaying remote information

```console
$ git remote show origin
* remote origin
  Fetch URL: git@bitbucket.org:arm2011/gitcourse.git
  Push  URL: git@bitbucket.org:arm2011/gitcourse.git
  HEAD branch: master
  Remote branches:
    experiment     tracked
    feature        tracked
    less-salt      tracked
    master         tracked
    nested-feature tracked
  Local branches configured for 'git pull':
    feature        merges with remote feature
    master         merges with remote master
    nested-feature merges with remote nested-feature
  Local refs configured for 'git push':
    feature        pushes to feature        (fast-forwardable)
    master         pushes to master         (up to date)
    nested-feature pushes to nested-feature (up to date)
```


### Renaming remotes

```shell
$ git remote rename initial_name new_name
```

### Deleting remotes

```shell
$ git remote remove remote_name 
```



## Best practices

- Communicate with your colleagues.
- Some commands such as **git rebase** change the history. It wouldn't be a good idea to use them on public branches. 
- Don't accept pull requests right away.

<span style="color:red">

NOTE ! I JUST ADDED THE EXERCISES THAT WE HAD IN THE GIT COURSE - EITHER WE NEED DIFFERENT EXERCISES OR SOME MATERIAL ON FORKING AND GITHUB HERE INSTEAD OF UNDER TEAMWORK. MAYBE IT FITS BETTER UNDER TEAMWORK? 

</span>

## Exercises 

In order to do these exercises, you need to download the exercises zip file (if you already did so for the previous exercise, you do not need to do so again, of course).

1. `wget `https://github.com/hpc2n/bioinformatics-hpc/raw/refs/heads/main/exercises/6.Git/git_materials.zip`
        2. `unzip git_materials.zip`
        3. `cd git_materials`
        4. `cd 6.remotes`

You are now in a directory with 2 subdirectories, one for each exercise.

### Adding remotes

Make sure you are in the subdirectory `git_materials/6.remotes/1.adding-remotes`. 

1. Fork the following repository `https://github.com/pojeda/pull-request-course.git`<br>
2. Clone the forked repository and check the available remotes<br>
3. Add the upstream repository with the name "upstream"<br>
4. Using your cloned version of the forked repository, make some modification to the "README.md" file and commit them locally. Then, push the changes to the remote.<br>
Finally, make a "pull request" from your GitHub account.


### Merge conflicts and rebasing 

Make sure you are in the subdirectory `git_materials/6.remotes/2.merge-rebase`. 

!!! note 

    This exercise demonstrates how to solve a merge conflict using rebasing.

    **Note:** for the present example you don't need to add a remote. It has been added for this example already.

Tasks:

1. Enter the `repository` directory and check the current status.
<br>
2. Check that the file `file.txt` has been modified since the last commit
using the *diff* command
<br>
3. Try commiting the changes and push them to the remote
<br>
4. Why do the push was unsuccesful?
<br>
**hint:** the remote contains changes that are missing from your local
remote. 
<br>
5. Pull the changes from the remote
<br>
6. When the text editor opens save the commit message. This means that
Git is able to merge the remote and your local changes.
<br>
7. Take a look at the commits' tree graph:
<br>
```
git log --all --decorate --oneline --graph
```
and save it into a text file for further investigations.
<br>
8. You could simply continue to work normally from here but the merge commit you just created is not actually necessary in this situation. Try falling back to the previous commit:
<br>
```
$ git reset --hard HEAD~
```
<br>
9. Now, pull again but tell Git to rebase your branch:
<br>
```
$ git pull --rebase
```
<br>
10. Take a look at the graph once again with:
<br>
```
git log --all --decorate --oneline --graph
```
<br>
and compare it with the one you saved into a text file. 
You can now see that the merge commit was not necessary.
<br>
11. Finally, you can now push the changes to the remote.
<br>


