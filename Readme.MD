# 2017 R Presentations

This repository is designed to be an introduction to various aspects of R.  As I grow this presentation, I may add more tutorials and guides to the project.

# Repository Structure
*conf/* lists the configuration files that are used in my Docker repositories.  These are mostly meant as a reference, if you wanted to create your own Docker repositories or set this up on OSX/Linux.  These are largely unnecessary on Windows.

*data/* are data sources for this presentation.  There are two main files of interest.  The WideWorldImporters-Full.bak is a backup of the FULL database for WideWorldImporters.  This is a test database, that replaced AdventureWorks, that's given by Microsoft as a database to learn from.  citylocs.csv is a CSV of one of the views in that backup file.  Many of the presentations rely on citylocs's data, so that is the minimum.
* Please note that the WideWorldImporters is using git-lfs, as the file is too large to go on normal git (112Mb or so).  You should have git-lfs installed, by going here: https://git-lfs.github.com/

*prep/* is where the slides are located at (pptx files).  Since I use this for my own personal prep, other items such as my notes also will be in this directory.

*Shiny/SimpleCharts* is a Shiny project that uses some of the data from WideWorldImporters to display graphs.  You can load the project in RStudio, and view the Shiny portion through there, or use my Docker images.

*src/* is where all the source code is stored.  Currently, I have everything rolled into *1-RIntro*, but this will likely change.

# Getting Started with this Project
You do not need to have git installed to check out this project.  You can click on the "Clone or Download" button and download as a zip.  Please do note that if you go this route, the WideWorldImporters won't be downloaded.  You can go to that directory and download the file, through the interface.  I do strongly recommend using Git if at all possible, though.

## What to Install
1) Git or Github Desktop
2) Git lfs (https://git-lfs.github.com/)
3) Docker CE (https://www.docker.com/community-edition)

```bash
git clone git@github.com:TheDarkTrumpet/2017RPresentations.git
docker pull thedarktrumpet/shiny
docker pull thedarktrumpet/rstudio
cd 2017RPresentations
# Edit the pointers to where the source is at (-v option)
./launchdocker.sh
```

## What will be changed soon
1) The launchdocker.sh only works on linux/mac currently. I'll write one that works on Windows in the near future.
2) The launchdocker has hard coded links to my current directory.  This should get the current cwd and use that in the map, so it can be stored anywhere.

# How to report issues and contribute to this
I greatly appreciate any changes people would like to see.  This could be as simple as misspellings or as complex as changes to the code.  I've enabled the 'Issues' portion in github.  Please feel free to add a new issue, with the change you'd like to see.
