# Cyverse Instructions
Created: 2022-05-26 13:54

```dataview  
TABLE WITHOUT ID file.mtime AS "Last Modified"  
WHERE file.path = this.file.path  
```

## Go to the Apps page
1. Go to the Cyverse Discovery Environment https://de.cyverse.org

2. Click this button -> ![[Pasted image 20220527074738.png]] to go to the Apps page.

3. Click on "Rocker RStudio Verse Latest" from the "Featured Apps" dropdown menu.
![[Pasted image 20220526093411.png]]

***

## Configuring the App
4. On the first page "Step 1: Analysis Info" of the Rocker RStudio Verse Latest app, click Next.
![[Pasted image 20220527075135.png]]
**Note:  By default, Cyverse will put output in your "Analysis" folder, i.e. `~/iplant/home/aantaya/analysis` (except `aantaya` will be replaced with your Cyverse username). In our case, we will be specifying a different path to our analysis, and we can safely ignore the "Output Folder".**

5. On the next page "Step 2: Analysis Parameters", click the "Browse" button.
![[Pasted image 20220527080002.png]]

6. Then select the folder containing the data that we want to analyze, in this case the folder is "grazing_data". This will copy the folder contents to the App. *Note- this isn't strictly necessary, but does improve performance as the container doesn't have to get data from other servers on Cyverse*.
![[Pasted image 20220527080137.png]]
(*Note to Self: I'm not sure exactly what this does in terms of Docker, it could put that copied data as a Docker volume, or as a bind mount*).

7. On the third page "Step 3: Advanced Settings (optional)" go to the "Select Maximums" drop-down menu, and then select "1 Maximum CPU Cores" (*Unless you need more cores, but it will eat into your CPU-hours*) and then click "Next". 
![[Pasted image 20220527080859.png]]

8. On the last page "Step 4: Launch or Save" click "Launch Analysis". 
![[Pasted image 20220527080835.png]]

***

## Launching the App
9. The App may take a couple of minutes to launch. Click the "Go To Analysis" button at the top to launch the app in your browser.
![[Pasted image 20220527081402.png]]

It may take a few minutes to launch the app.

![[Pasted image 20220606112334.png]]

10. The app launches an interactive R Studio session (In your browser using server hardware!).
![[Pasted image 20220527081511.png]]

***

## Cloning Analysis Code
11. Go to your GitHub repo that contains the analysis code. Mine is https://github.com/amantaya/grazing-interaction. You will need to replace the URL with the URL from your GitHub page.
![[Pasted image 20220527081824.png]]
*Note: Because you "forked" (i.e. copied) my repo, you will have your own copy of the code that you are free to use. Any changes made to your repo will not be reflected in my repo until you submit a "Pull Request" to merge your changes back into my repo.*

12. Click on the "Terminal" tab within R Studio and type (or copy and paste) this Git command into the R Studio Terminal. Instead of `Ctrl` + `V` for copying and pasting, you may need to use `Shift` + `Insert` to paste the command into the Terminal and then hit `Enter`.

```
git clone https://github.com/amantaya/grazing-interaction.git
```

![[Pasted image 20220527082233.png]]

13. The code from **_your_** GitHub repo is now inside of the Cyverse app. 
![[Pasted image 20220527082345.png]]
**Important: Because you "forked" my repo, you are "downstream" of the changes. That means that anytime I make changes to my repo, you will need to "fetch" the upstream changes so that the changes are synced to your repo. **

14. Type the following commands into the Terminal in R Studio to fetch and merge any changes I made to my repo to your repo.

First, change the working directory to the folder with the analysis code. Type or copy and paste this command into the Terminal.
```
cd ./grazing-interaction
```

Then type or copy and paste this command to sync changes from my repo to your repo.
```
git pull
```

*Tip: It's good practice to check run `git pull` frequently (at minimum every time your start a Cyverse app) to keep your repo up-to-date with mine.

***

## Setting up the R Environment
### Open the R Project File
15. In the "File" pane at the lower-right side of R Studio, click on the newly cloned "grazing-interaction" folder.
![[Pasted image 20220527082345.png]]

16. Click on `grazing-interaction.Rproj` to open the R Project and then click "Yes" to open the project (this will restart the R session and will initialize the Git tab for the top-right pane and setup user-specific settings).
![[Pasted image 20220606121740.png]]

### Setting Up GitHub Credentials
17. From within the "grazing-interaction" folder, click on `environment.R` to open it inside of R Studio.

![[Pasted image 20220527082852.png]]

18. On line 5, change the `repo_url` to the URL from your GitHub page.

19. On line 6, change the `github_username` to your GitHub username.

20. On line 7, change the `github_email` to the email address associated with your GitHub account.

21. On line 8, change the `cyverse_username` to your Cyverse username.

22. Then click the "Source" button ![[Pasted image 20220527083115.png]]

23. A prompt will open asking for your GitHub username. Enter in your GitHub username and click "OK".
![[Pasted image 20220527083324.png]]

24. Another prompt will open asking for your GitHub password. Enter in your GitHub password and click "OK". (_Note: if you have 2-Factor security setup on your GitHub account, enter in your Personal Access Token instead of your password._)
![[Pasted image 20220606124602.png]]

**Important: The `environment.R` script sets up paths to the "cameratraps", "cameratraps2", "input", and "user" folders on Cyverse.  You might need to change these paths if they are different for your Cyverse account.**

### Installing R Packages
25. Next, click on `packages.R` to install and attach the packages needed for this analysis.

![[Pasted image 20220527082852.png]]

*Note: It may take up to 15 minutes to install all of the packages.*

***

## Running Analysis Code
26. Click on the "Scripts" folder from the File pane at the lower-right side of R Studio.

27. Click on the "Analysis" folder from within the "Scripts" folder.
![[Pasted image 20220527083800.png]]

28. Then click on the file that you want to open from within the "Analysis" folder, e.g., `2021-heber-landscape-appearance.Rmd`
![[Pasted image 20220606114200.png]]

*Tip: You can make an R Markdown script take up the full left-side by clicking the ![[Pasted image 20220606114238.png]] button from within the editor pane. In the above screenshot, the editor pane is already full size but you can make it smaller by clicking the ![[Pasted image 20220606115208.png]] button at the top right.*

29. The Cyverse app should now be configured for your analysis. 
