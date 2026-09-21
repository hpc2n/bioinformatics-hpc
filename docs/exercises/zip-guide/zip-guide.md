# Making a zip file and getting it to your own computer: step-by-step guide

**Course:** 5BI00A Computing for Data-Driven Biology · Umeå University

At the end of the exam you upload your README and output files to Canvas as one **zip file**. Canvas accepts only `.zip` files for the exam: a `.tar.gz` file is refused with the message "filetype not allowed". This page shows how to make the zip on Kebnekaise (or in the practice container), how to move it to your own computer, and how to upload it.

The zip has to be made where your files are, and uploaded from your own computer. That is why the file has to travel: Kebnekaise (or the container) to your own computer to Canvas.

!!! note "Practise before the exam"
    There is a practice assignment in Canvas, "Practice: make a zip file and upload it (no marks)", due Monday 28 September at 17:00. It lets you do this whole page with a tiny file, so that nothing is new on the day of the exam.

## How the commands on this page are shown

The blocks look the same as on the [pushing to GitHub guide](../git-ssh-setup/git-ssh-setup.md).

A plain grey block is a command to paste as it is. Nothing in it needs changing:

```
echo "This is a command to paste exactly as it is"
```

!!! warning "Edit before you paste"
    A command that contains something only you know is in an orange box like this one. The words in CAPITAL LETTERS are placeholders. Replace each one with your own text, and keep everything else. The box tells you what each placeholder means.

    ```
    echo "Hello, MY NAME"
    ```

    - `MY NAME`: your own name, for example `Maria Svensson`.

!!! tip "What you should see (do not paste this)"
    Output that the computer prints back is in a green box like this one. It is there for you to compare with your screen. It is not a command, so do not paste it.

    ```
    Hello, Maria Svensson
    ```

Paste one block at a time, press Enter, and wait for the prompt to come back before you paste the next block.

!!! warning "Use straight quotation marks"
    Commands use straight quotation marks, `"` and `'`. If you copy a command from a Word document, an email or a chat window, they can turn into curly ones, `“ ”` and `‘ ’`, and the command then fails with errors that seem unrelated. Copy commands from the boxes on the course pages instead of retyping them, and check any quotation marks that you type yourself. Do not swap one kind for the other: `$` and `\` mean something different inside double quotes than inside single quotes.

!!! warning "Where you type matters"
    Each step says where to type: on Kebnekaise, on your own computer, or in the practice container. Steps 1 to 3 are done where your files are. Step 4 has three routes; use the one that matches where your files are. In the practice container the prompt starts with `[practice container]`.

## Step 1: Go to the folder with your files (on Kebnekaise or in the container)

For the exam this is your cloned exam repository. Do the rest of Steps 1 to 3 inside that folder, not in the folder above it. The next command contains your GitHub username, so change the capital letters before you paste. It assumes that you cloned the repository into the folder you are in now. In the practice container you can check where you are from the end of your prompt, which should be `exam-` followed by your GitHub username.

!!! warning "Edit before you paste"
    ```
    cd exam-YOUR_GITHUB_USERNAME
    ```

    - `YOUR_GITHUB_USERNAME`: your GitHub username, for example `msvensson`. Keep `exam-` in front of it.

Look at what is there:

```
ls
```

You should see your `README.md` and your output files or folders.

## Step 2: Make the zip file (on Kebnekaise or in the container)

The exam asks for your README and your output files. Make sure you are inside your exam repository folder (Step 1). The next command needs no changes. It puts everything in the folder into `exam.zip`, except the hidden `.git` folder, which holds your Git history (that is on GitHub already). The dot means "this folder", `-r` includes folders and what is inside them, and `-x ".git/*"` leaves `.git` out.

```
zip -r exam.zip . -x ".git/*"
```

!!! tip "What you should see (do not paste this)"
    One line for each file or folder that was added, in any order. Your file names and the percentages will differ.

    ```
      adding: README.md (stored 0%)
      adding: results/ (stored 0%)
      adding: results/hits.txt (deflated 43%)
      adding: blast_job.sh (stored 0%)
    ```

Only if you want some of the files, and not everything, use this command instead of the one above. Name the files after `exam.zip`, separated by spaces.

!!! warning "Edit before you paste"
    ```
    zip -r exam.zip README.md NAME_OF_AN_OUTPUT_FILE_OR_FOLDER
    ```

    - `NAME_OF_AN_OUTPUT_FILE_OR_FOLDER`: the name of a file or folder to include, for example `results`. To include more, add their names after it, separated by spaces.

Now check what is inside the zip file:

```
unzip -l exam.zip
```

!!! tip "What you should see (do not paste this)"
    The names of your files, with their sizes. Check that your README and your output files are listed.

    ```
    Archive:  exam.zip
      Length      Date    Time    Name
    ---------  ---------- -----   ----
           17  09-21-2026 07:08   README.md
            0  09-21-2026 07:08   results/
          111  09-21-2026 07:08   results/hits.txt
           20  09-21-2026 07:08   blast_job.sh
    ---------                     -------
          148                     4 files
    ```

## Step 3: Find the full path of the zip file (on Kebnekaise or in the container)

You need the full path to move the file in Step 4.

```
pwd
```

!!! tip "What you should see (do not paste this)"
    The full path of the folder that you are in. Yours will be different. Add `/exam.zip` to the end to get the full path of the zip file.

    ```
    /proj/nobackup/cddb_course/students/msvensson/exam-msvensson
    ```

## Step 4: Move the zip file to your own computer

Use the route that matches where your files are.

### Route A: from Kebnekaise with `scp` (in a terminal on your own computer)

Open a terminal window on your own computer. This is not the Kebnekaise window: do not log in to Kebnekaise for this step. Go to the folder where you want the file, and paste the command below. The dot at the end means "here", the folder that your terminal is in.

!!! warning "Edit before you paste"
    ```
    scp YOUR_HPC2N_USERNAME@kebnekaise.hpc2n.umu.se:FULL_PATH/exam.zip .
    ```

    - `YOUR_HPC2N_USERNAME`: your HPC2N username, the one you use to log in to Kebnekaise.
    - `FULL_PATH`: the path that `pwd` printed in Step 3, for example `/proj/nobackup/cddb_course/students/msvensson/exam-msvensson`. Keep `/exam.zip` after it.

`scp` asks for the same login details as `ssh` does. When it has finished, `exam.zip` is in the folder that your terminal is in.

### Route B: from Kebnekaise with the Open OnDemand file browser (in a web browser)

1. Go to [portal.hpc2n.umu.se](https://portal.hpc2n.umu.se) and log in.
2. Open the *Files* app and go to the folder that holds `exam.zip`.
3. Select `exam.zip` and choose *Download*. Your browser saves it in its download folder.

### Route C: from the practice container with `docker cp` (in a second terminal window)

Leave the container running, in its own terminal window. Do not type `exit` yet. Open a second terminal window on your own computer (not the Docker Desktop app), and go to the folder where you want the file. Then paste the command below. It assumes that the container was started with the name `practice`, as in the [practice image guide](https://github.com/hpc2n/bioinformatics-hpc/tree/main/exam-practice), and that you cloned your exam repository in the container's default folder, `~/work`, and made the zip in it (Steps 1 and 2). The dot at the end means the folder that this second terminal is in.

!!! warning "Edit before you paste"
    ```
    docker cp practice:/home/student/work/exam-YOUR_GITHUB_USERNAME/exam.zip .
    ```

    - `YOUR_GITHUB_USERNAME`: your GitHub username, for example `msvensson`. Write out the whole path: `~/work` does not work in this command.

`docker cp` copies a single file or a whole folder, but Canvas accepts only a zip file, so make the zip first (Step 2).

If the container was not started with the name `practice` (older versions of the guide did not use it), replace `practice` in the command with the container's ID. The ID is the letters and numbers after `student@` in the prompt of the container window, for example `1a2b3c4d5e6f`. You can also find the name or the ID by typing `docker ps` in the second terminal window.

## Step 5: Upload the zip file to Canvas (in your web browser)

1. Open the exam assignment in Canvas and choose *Submit Assignment*.
2. Choose `exam.zip` from the folder where you saved it in Step 4.
3. Submit, and check that the file name is shown on the submission page.

## Troubleshooting

| What you see | What it means and what to do |
|---|---|
| Canvas says "filetype not allowed" | The file is not a `.zip` file, for example a `.tar.gz` file. Make the zip with `zip -r` (Step 2). |
| `scp` says `No such file or directory` | The path is wrong. Run `pwd` in the folder with the zip on Kebnekaise (Step 3), check that `exam.zip` is there with `ls`, and use that path. |
| `scp` says `Permission denied` | The username or the password is wrong, or you are not able to log in to Kebnekaise. Try logging in with `ssh` first. |
| `docker cp` says `No such container: practice` | The container has ended, or it was started without `--name practice`. Start it again as in the practice image guide, and copy the file while it is running. |
| The zip file looks too small, or is empty | Check its contents with `unzip -l exam.zip`. Files that are not named on the `zip` command are not included. Make the zip again, and name your README and output files. |
