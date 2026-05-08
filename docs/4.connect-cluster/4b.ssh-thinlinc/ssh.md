# SSH

## Connecting from Windows

If you are connecting to HPC2N from a Windows system, you need to install an ssh client to connect. The recommended way is by using [ThinLinc](#thinlinc), but in some cases using just a terminal window is preferred, and this section looks at SSH clients for that. Several exists, both commercial and free. Here are some of the more common ones:

- <a href="https://www.chiark.greenend.org.uk/~sgtatham/putty/" target="_blank">PuTTY</a> (free)
- <a href="https://www.cygwin.com/" target="_blank">Cygwin</a> (free)
- <a href="http://mobaxterm.mobatek.net/" target="_blank">MobaXterm</a> (Commercial, but basic feature version is free)

If you want to be able to open graphical displays (say for opening the Matlab graphical interface), you need an X11 server. These are commonly used:

- <a href="https://sourceforge.net/projects/xming/" target="_blank">Xming</a> (free)
- <a href="https://www.cygwin.com/" target="_blank">Cygwin</a> (free)
- <a href="http://mobaxterm.mobatek.net/" target="_blank">MobaXterm</a> (Commercial, but basic feature version is free)

You also need to transfer files between your own home computer and HPC2N's systems. You need to use a secure protocol, so either sftp or scp will work, but not standard ftp.

- <a href="https://winscp.net/eng/index.php" target="_blank">WinSCP</a> (Commercial)
- <a href="https://filezilla-project.org/" target="_blank">FileZilla</a> (only sftp) (free)
- <a href="http://www.nber.org/pscp.html" target="_blank">PSCP</a><a href="http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html" target="_blank">/PSFTP</a> (free)
- <a href="https://cyberduck.io/?l=en" target="_blank">Cyberduck</a> (free)
- <a href="http://mobaxterm.mobatek.net/" target="_blank">MobaXterm</a> (Commercial. The free version has limits to the file transfers)

In this section we will give brief examples for Cyberduck, WinSCP, MobaXterm, PuTTy, Cygwin, and Xming.

In all cases, we strongly advice <strong>against</strong> saving passwords.

The simplest way to connect to HPC2N is to use either PuTTy together with Xming, or to use MobaXterm, unless you need a Linux-like environment on your Windows machine (CygWin).

!!! NOTE

    Remember that the accounts at HPC2N and SUPR are separate.

    In the welcome mail you got when your HPC2N account was created, there was a link to create <a href="https://www.hpc2n.umu.se/forms/user/suprauth?action=pwreset" target="_blank">a first, temporary password</a>. When you have logged in using that, [please change the password](../../documentation/access/#first__time__login__password__change).

### SSH clients and X11 servers

#### PuTTY

- Download PuTTY from <a href="http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html" target="_blank">here</a>.
![putty-login](../images/putty-login.png){: style="width: 350px;float: right"}
- Get the Zip file which contains all of PuTTY, PSCP, and PSFTP.
- Unzip the downloaded zip-file, then run "putty.exe".
- In the window that opens, under 'Session' enter the host name.
    - In the picture, it is entered for Kebnekaise (kebnekaise.hpc2n.umu.se).
- When you click 'Open' you will be prompted for your HPC2N username and password.
    - In the picture below, you can see how it can look when logged in.

![putty-loggedin](../images/putty-loggedin.png){: style="width: 600px; float: left"}

<br><br style="clear: both;">


##### PuTTy and X11 forwarding

If you need to open graphical interfaces from the remote system on your home computer then you need to enable X11 forwarding.

**Example for Xming**

- Download and install an X server (for instance [Xming](#xming__x__server))
    - Start PuTTy
    - On the left side, scroll down to 'Connection' and click to open the tree if it is not opened already
    - Click to open the 'SSH' subcategory, and then click on 'X11'.
    - Make sure 'Enable X11 forwarding' is checked. Note that this needs to be done for each saved session.
    - Some older versions of PuTTY does not work correctly with X11 forwarding from our systems. Try upgrading to <a href="http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html" target="_blank">version 0.69</a> (known to work) or newer.

![putty_x11](../images/putty_x11.png){: style="width: 456px;"}

<br><br style="clear:both;">


#### Xming X server

In order to use X11 forwarding in PuTTy (or similar), you need to run Xming before starting PuTTy.

- Download from <a href="http://www.straightrunning.com/XmingNotes" target="_blank">the Xming page</a> or <a href="https://sourceforge.net/projects/xming/" target="_blank">directly from Sourceforge</a>
    - Install (default options should work)
    - Launch Xming

You can now launch (for instance) PuTTY SSH client and enable X11 forwarding [as shown earlier](#putty__and__x11__forwarding) on this page.

#### MobaXterm

This program has both a freeware and a paid version. The freeware version works well for most users. It combines SSH client, X11 server, and SFTP file browser. <strong>NOTE</strong> that the free version has a number of limits, such as a time-limit on the filebrowser. You may therefore wish to use either FileZilla or WinScp for file transfers instead because of that.

It exists both as an installable version and as a single executable that can be run from an USB stick.

- Download from <a href="http://mobaxterm.mobatek.net/" target="_blank">here</a>.
    - Get the Free / Home edition
    - Extract it

There is a demo on their homepage, but here are the basic steps to connect to HPC2N's systems.

- Start the MobaXterm program <br>
![mobaxterm-start](../images/mobaxterm-start.png){: style="width: 350px;float: left"}
<br><br style="clear: both;">
- Click 'Session' and then click 'SSH' in the new window that opens. Fill in the name of the remote host (kebnekaise.hpc2n.umu.se). Check 'Specify username' and fill in your own username (otherwise it will ask for your username when you connect to the system). Click 'OK'. (Your settings will be saved and you can login again by clicking on the host name under 'Saved sessions' on the start up window).<br>
![mobaxterm-ssh](../images/mobaxterm-ssh.png){: style="width: 600px;float: left"}
<br><br style="clear: both;">
- A new window will open, asking for your HPC2N password.<br />
![mobaxterm-password](../images/mobaxterm-password.png){: style="width: 600px; float: left"}
<br><br style="clear: both;">
- When you have entered that, you will be logged on to the system (Kebnekaise). Note that there is a file browser on the left with your files on the HPC2N system.<br>
![mobaxterm-login](../images/mobaxterm-login.png){: style="width: 600px; float: left"}
<br><br style="clear: both;">
- Since an X11 server is running and the display is sat automatically, you can now open new windows/displays/graphical interfaces from the host you are logged in to, on your own local screen. - You can also transfer files between your local system and the remote system (HPC2N) by using the file browser. Choosing download/upload or just drag-drop works. You can also do things like editing files on the remote system by double-clicking on a file in the file browser or right-clicking and choosing what to do. <strong>NOTE </strong>that there is a time-limit on the file browser in the free version, and you can not expect to do anything but minor edits through it this way.<br />
![mobaxterm-openfile](../images/mobaxterm-openfile.png){: style="width: 600px; float: left"}
<br><br style="clear: both;">

#### Cygwin - installation

This is somewhat more involved, and mostly only worth it if you intend to use Cygwin locally on your Windows computer, in order to run a Linux-like environment. A longer description of the installation process can be found on <a href="http://x.cygwin.com/docs/ug/setup-cygwin-x-installing.html" target="_blank">Cygwin's pages</a>.

- Download "setup.exe" from the <a href="http://www.cygwin.com" target="_blank">Cygwin page</a>
- After the initial file downloads, you will get the option to ’Select Package’. Go through and check any you think you would like, as long as you make sure the ones below are selected from "X11" category
    - <code>xorg-server</code> (required, the Cygwin/X X Server)
    - <code>xinit</code> (required, scripts for starting the X server: <code><b>xinit</b></code>, <code><b>startx</b></code>, <code><b>startwin</b></code> (and a shortcut on the Start Menu to run it), <code><b>startxdmcp.bat</b></code>)
    - <code>xorg-docs</code> (optional, <b>man</b> pages)
    - <code>X-start-menu-icons</code> (optional, adds icons for "X Clients" to the Start menu)
    - You may also select any X client programs you want to use, and any fonts you would like to have available.
    - You may also want to ensure that the <code>inetutils</code> or <code>openssh</code> packages are selected if you wish to use <code><b>telnet</b></code> (not at HPC2N) or <code><b>ssh</b></code> connections to run remote X clients.
    - You may also select any X client programs you want to use, and any fonts you would like to have available.
    - You may also want to ensure that the <code>inetutils</code> or <code>openssh</code> packages are selected if you wish to use <code><b>telnet</b></code> (not at HPC2N) or <code><b>ssh</b></code> connections to run remote X clients.
- Under "Graphics", it is recommended to select <code>opengl</code> packages.
- Install

#### Cygwin - connecting

The custom XWin startup utility <code><b>startxwin</b></code> starts the X server in multiwindow mode. <code><b>startxwin</b></code> is included in the <code>xinit</code> package, which you should have installed if you followed the description above.

Run <code><b>startxwin</b></code> by doing one of:

- Using the "XWin Server" shortcut under "Cygwin-X" on the Start Menu
- Starting <code>/usr/bin/startxwin</code> in a Cygwin shell, by typing<br>
    - <code>startxwin</code>

You can get more documentation for <code>startxwin</code> by typing <code>man startxwin</code> in the Cygwin shell.

### File transfers

There are many options, some free, some commercial. Some of the more common ones are:

- [WinSCP](#winscp)
- [Cyberduck](#cyberduck)
- [FileZilla](#filezilla)

#### WinSCP

- Download from <a href="https://winscp.net/eng/download.php" target="_blank">here</a>. Pick 'Installation package'.
- Install. During the setup you will be asked to choose between 'Commander' and 'Explorer'. 'Commander' is probably the best for most people, but it is your choice.<br>
![winscp-setup](../images/winscp-setup.png){: style="width: 400px; float: left;"}
<br><br style="clear: both;">
- When the program has installed, start it. Click 'New Session'. Enter the name of the remote host (kebnekaise.hpc2n.umu.se or abisko.hpc2n.umu.se). Put in your username and password. You can save the session settings so you do not have to enter it next time, but can just click it in the list that will be on the left, but we strongly recommend that you in that case do <strong>not<em> </em></strong>save the password.<br>
![winscp-kebnekaise](../images/winscp-kebnekaise.png){: style="width: 600px; float: left"}
<br><br style="clear: both;">
- When you log on to a remote host for the first time you will be asked if you want to continue connecting to an unknown server and add its host key to a cache. Say 'Yes'. You will now be logged in to HPC2N, to your home directory. You can change directories by clicking, and you can upload/download files with drag-drop.<br />
![winscp-loggedin](../images/winscp-loggedin.png){: style="width: 600px; float: left"}

#### Cyberduck

- Download from <a href="https://cyberduck.io/?l=en" target="_blank">here</a>. Pick the "Cyberduck for Windows" even if you have Windows 10
- Install
- Start the program<br />
![cyberduck-start](../images/cyberduck-start.png){: style="width: 600px; float: left;"}
<br><br style="clear: both;">
- Click 'Open Connection' and enter the name of the remote host (kebnekaise.hpc2n.umu.se), Change the drop-down from 'FTP' to 'SFTP'. Enter your username and password for HPC2N. We strongly recommend that you do NOT save the password.<br />
![cyberduck-login](../images/cyberduck-login.png){: style="width: 600px; float: left;"}
<br><br style="clear: both;">
- When you connect the first time to a remote host, you will be asked if you want to "Allow" or "Deny" an unknown fingerprint. Allow it.
- You are now logged in. You will end up in your home directory. You can change directories and you can upload/download files with drag-drop.<br />
![cyberduck-filebrowser](../images/cyberduck-filebrowser.png){: style="width: 600px; float: left;"}
<br><br style="clear: both;">

#### FileZilla

<a href="https://filezilla-project.org/" target="_blank">The FileZilla Client</a> is free and supports FTP, FTP over TLS (FTPS) and SFTP. It is open source software distributed free of charge under the terms of the GNU General Public License. To connect to HPC2N, you need to use SFTP.

- Go to <a href="https://filezilla-project.org/" target="_blank">the FileZilla homepage</a> and pick "Download FileZilla Client".
- You will get to a page where you can pick "Download FileZilla Client" for your OS.
- Download and install.

## Connecting from macOS 

If you are connecting to HPC2N from a Mac, you have a number of options, aside from the built in SSH client "Terminal". Several exists, both commercial and free. Here are some of the more common ones:

- <code>ssh</code> (built-in in "Terminal")
- <a href="http://www.iterm2.com/" target="_blank"><code>iTerm2</code></a> (free)

If you want to be able to open graphical displays (say for opening the Matlab graphical interface), you need an X11 server. It may or may not be installed as standard on Mac, depending on your version, but you can get it by installing <a href="https://www.xquartz.org/" target="_blank">XQuartz</a>.

Another option would be to use [ThinLinc](#thinlinc) which exists for all OS and gives you a desktop on Kebnekaise.

You also need to transfer files between your own home computer and HPC2N's systems. You need to use a secure protocol, so either <code>sftp</code> or <code>scp</code> will work, but not standard <code>ftp</code>. These are some of the options:

- <code>scp</code>, <code>sftp</code> (built-in in "Terminal")
- <code><a href="https://cyberduck.io/?l=en" target="_blank">Cyberduck</a></code> (free)
- <code><a href="https://filezilla-project.org/" target="_blank">FileZilla</a></code> (free)

On this page we will give brief examples for ssh, Cyberduck and iTerm2, and also tell you how to get FileZilla.

In all cases, we strongly advice <strong>against</strong> saving passwords.

The simplest way to connect to HPC2N is to use the built-in <code>ssh</code> from "Terminal".

!!! NOTE

    Remember that the accounts at HPC2N and SUPR are separate. In the welcome mail you got when your HPC2N account was created was a link to create <a href="https://www.hpc2n.umu.se/forms/user/suprauth?action=pwreset" target="_blank">a first, temporary password</a>. When you have logged in using that, [please change the password](../../documentation/access/#first__time__login__password__change).

### SSH clients

#### ssh

- Launch "Terminal"
- Connect to Kebnekaise by doing: <br>
<code>ssh -l username kebnekaise.hpc2n.umu.se </code> <br>
where username is your username at HPC2N.
- If you need to open displays from the remote host on your local machine (say, for graphical interfaces to some software), you need to make sure <a href="https://www.xquartz.org/" target="_blank">XQuartz</a> is installed and running. It should be set up automatically during install.

#### iTerm2

- Download <a href="http://www.iterm2.com/index.html" target="_blank">iTerm2 </a>
- Install and launch
- Connect to Kebnekaise by doing: <br>
<code>ssh -l username kebnekaise.hpc2n.umu.se </code> <br>
where username is your username at HPC2N.
- You now have access to a number of nice features, like split panes, search, paste history, etc. Read more about that <a href="http://www.iterm2.com/features.html" target="_blank">here</a>.

### File transfers

#### Cyberduck

- Download from <a href="https://cyberduck.io/?l=en" target="_blank">here</a> or from the Mac App Store
- Install
- Launch the program
- In the <b>Open Connection</b> dialog:
    - Select <b>SFTP </b>as protocol
    - Enter Server: <b>kebnekaise.hpc2n.umu.se</b>
    - Leave Port at default: <b>22</b>
    - Enter your <strong>Username</strong> and <strong>Password </strong>at HPC2N
    - Click <b>Connect </b><br />
![cyberduck-login-mac](../images/cyberduck-login-mac.png){: style="width: 600px; float: left;"}
<br><br style="clear: both;">
- When you connect the first time to a remote host, you will be asked if you want to "Allow" or "Deny" an unknown fingerprint. Allow it.
- You are now logged in. You will end up in your home directory. You can change directories and you can upload/download files with drag-drop. If you want, you can pick <strong>Bookmark -&gt; New Bookmark</strong> from the top menu to save the connection settings for next time.<br />
![cyberduck-filebrowser-mac](../images/cyberduck-filebrowser-mac.png){: style="width: 600px; float: left;"}
<br><br style="clear: both;">

#### FileZilla

<a href="https://filezilla-project.org/" target="_blank">The FileZilla Client</a> is free and supports FTP, FTP over TLS (FTPS) and SFTP. It is open source software distributed free of charge under the terms of the GNU General Public License. To connect to HPC2N, you need to use SFTP.

- Go to <a href="https://filezilla-project.org/" target="_blank">the FileZilla homepage</a> and
pick "Download FileZilla Client".
- You will get to a page where you can pick "Download FileZilla Client" for your OS.
- Download and install.

## Connecting from Linux/Unix

If you are connecting to HPC2N from a computer running Linux or Unix, you have a number of options. The most obvious and commonly used one is probably the built-in SSH client SSH. Several others exist, here are some of the more common ones:

- <code>ssh</code> (built-in in Linux terminal)
- <code><a href="https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html" target="_blank">PuTTY</a></code> (free)

If you want to be able to open graphical displays (say for opening the Matlab graphical interface), you need an X11 server. It is installed per default on Linux/Unix systems.

Another option would be to use [ThinLinc](#thinlinc) which exists for all OS and gives you a desktop on Kebnekaise.

You also need to transfer files between your own home computer and HPC2N's systems. You need to use a secure protocol, so either sftp or scp will work, but not standard ftp. These are some of the options:

- <code>scp</code>, <code>sftp</code> (built-in in Linux terminal)
- <a href="https://curl.haxx.se/" target="_blank"><code>cURL</code></a> (free)
- <a href="https://filezilla-project.org/" target="_blank"><code>FileZilla</code></a> (free)
- <a href="https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html" target="_blank"><code>PSFTP</code></a> (Part of PuTTY. Free)

On this page we will give brief examples for <code>ssh</code>, <code>scp</code>/<code>sftp</code>, <code>PuTTY</code>, and <code>FileZilla</code>.</p>

!!! NOTE 

    You can find more examples for file transfers in the [File transfer section](../../documentation/filesystems/#file__transfer)

In all cases, we strongly advice <strong>against</strong> saving passwords.

The simplest way to connect to HPC2N is to use the built-in ssh from the terminal.

!!! NOTE

    Remember that the accounts at HPC2N and SUPR are separate. In the welcome mail you got when your HPC2N account was created was a link to create <a href="https://www.hpc2n.umu.se/forms/user/suprauth?action=pwreset">a first, temporary password</a>. When you have logged in using that, [please change the password](../../documentation/access/#first__time__login__password__change).

### SSH clients

#### ssh

- Launch a terminal
- Connect to Kebnekaise by doing:<br>
<code>ssh username@kebnekaise.hpc2n.umu.se </code> <br>
where username is your username at HPC2N.
- If you need to open displays from the remote host on your local machine (say, for graphical interfaces to some software), you must use the flag <code>-X</code> (or <code>-Y</code> in some cases, if you need to type something in the display, like in MATLAB): <br>
<code>ssh -X username@kebnekaise.hpc2n.umu.se</code>

#### PuTTY

- Download <a href="https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html" target="_blank">PuTTY</a>
- Unpack the tarball (For version 0.81 - adjust to fit: <code>tar zxvf putty-0.81.tar.gz</code>)
    - <code>cd</code> into the directory created by the above command (adjust to fit the version: 
    ```bash
    cd unix/putty-0.81
    ./configure
    make
    ```
- It should build without problems. If you need the graphical utilities instead of just using it from the command line, you need Gtk+-1.2, Gtk+-2.0, or Gtk+-3.0 installed. More information can be found in the file README in the top putty directory.
    - Launch the graphical interface with
      <code>./putty</code>
      from the unix directory under the PuTTY directory. 
    - Enter kebnekaise.hpc2n.umu.se as the host: <br>
![putty-linux-kebnekaise](../images/putty-linux-kebnekaise.png){: style="width: 566px; float: left;"} 
<br><br style="clear: both;">
    - The first time you connect you will be asked to accept the host key. Do so. Then login with your HPC2N username and password.
    - In order to use remote graphical interfaces, you need to enable X11 forwarding: 
        - Scroll down in the left side of the PuTTY window to SSH. 
        - Click the small arrow to get to the sub-options. 
        - Click X11. 
        - Check "Enable X11 forwarding": <br> 
![putty-linux.x11](../images/putty-linux.x11.png){: style="width: 566px; float: left;"} 
<br><br style="clear: both;">

### File transfers

#### scp/sftp

- <code>scp</code> and <code>sftp</code> should already be installed on your Linux installation

##### scp

<code>scp</code> - secure copy - copies files between hosts on a network. It uses <code>ssh</code> for data transfer.

!!! Example "scp examples"

    - <strong>Copy file from remote host to local host</strong>
      ```bash
      scp username@remotehost:file local-directory
      ```
    - <strong>Copy file from local host to remote host </strong>
      ```bash
      scp file username@remotehost:remote-directory
      ```
    - <strong>Copy directory from local host to remote host (and renaming directory to new-directory) </strong>
      ```bash
      scp -r local-directory username@remotehost:remote-directory/new-directory
      ```
    - <strong>Copy multiple files from local host to your home directory on remote host </strong>
      ```bash
      scp file1 file2 username@remotehost:~
      ```
    - <strong>Copy multiple files from remote host to current directory on local host </strong>
      ```bash
      scp username@remotehost:/remote-directory/\{file1,file2,file3\} .
      ```

For more info about <code>scp</code>, type: <code>man scp</code> on the command line. 

##### sftp 

<code>sftp</code> - secure file transfer program. Similar to FTP, but with many of the features of SSH included.

!!! Example "sftp examples"

    <strong>Interactive</strong>
    ```bash
    sftp username@remotehost
    ```

    <strong>Retrieve files without interaction </strong>
    ```bash
    sftp username@remotehost:file ...
    ```

For more info about <code>sftp</code>, type: <code>man sftp</code> on the command line. 

#### FileZilla

- Ubuntu: download and install with package manager (<code>apt-get install filezilla</code>)
- You can also download from <a href="https://filezilla-project.org/" target="_blank">FileZilla homepage</a> if you are not using Ubuntu. Pick the one for "All platforms". There is one for Debian (the executable is in the bin subdiretory and is called filezilla). If you are not using Debian or Ubuntu, you will probably have to compile from source.
- When building from source (You also need to download and install <a href="https://lib.filezilla-project.org/download.php" target="_blank">libfilezilla</a> in much the same way):
    - uncompress the tarball (<code>tar zxvf FILENAME</code>), enter the directory created
    - <code>mkdir compile</code>
    - <code>cd compile</code>
    - <code>../configure</code>
    - <code>make</code>
    - <code>make install</code>
- This is how it looks when FileZilla has started up: <br> 
![filezilla-linux](../images/filezilla-linux.png){: style="width: 900px; float: left;"} 
<br><br style="clear: both;">
- Connect by entering <code>kebnekaise.hpc2n.umu.se</code> in the "Host" field, then put in your HPC2N username under "Username". We strongly recommend **not** saving your password.

