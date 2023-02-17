# Binge_Tavern
This an flutter app that displays shows annd there related info by using __TV Shows API__.It has the following features:- 
  ## HomePage ##
  * On this screen we have displayed Posters of movies which on clicking lead to the details of the page page.
  * A separate slider below this which displays the shows who were released in th past week and clicking on them lead to their details(and also without repetition in case of multiple episode are released
  in the week)
  ## ShowDetails ##
  * On this page we have displayed your selected show i.e. imdb rating,start date,is the show currently ongoing or not, the average run time and synopsis
  * We additionally on a separate slider display the crew and cast of the show __if present__
  * We also show the episode details such as name and season on it in ascending order
## Installation  
  ### Preinstalled Components required
  * Kotlin version=1.7.10
  * Jdk = 15.0.1
  * Flutter version = 3.7.1
  * Vscode version = 1.75.1  |  * Android studio Version =2021.2
  * Android sdk version = 33.1.1
  ## Installation guide 
  1. Copy the link of the repository
  2. #### If you are using Android Studio :- 
  * Click on get from version control and paste the link in the url section
     #### If you are using vscode :- 
  * open terminal in the location you want to install the project ,right click and select open terminal the type git clone <your_copied_url>
  3. Run _flutter pub get_
  ## [NOTE]Some Shortcomings in our app
  1. The API used isnt updated for all shows i.e. Shows dont have updated posters(so we had to refill those with our stock image of image missing)
  2. Additionally we also have missing summary,cast,crew,cast and crew photos and episode details in many entries of the api as which you would see in many shows
    so we would suggest to look at some well known shows to experience our full functionalities.
  

## ScreenShots ##
<img src="https://github.com/Ravi-Maurya74/Binge_Tavern/blob/main/gifs/gif%20(1).gif" width="200" height="400"/>
<img src="https://github.com/Ravi-Maurya74/Binge_Tavern/blob/main/gifs/gif%20(2).gif" width="200" height="400"/>
<img src="https://github.com/Ravi-Maurya74/Binge_Tavern/blob/main/gifs/gif%20(3).gif" width="200" height="400"/>
<img src="https://github.com/Ravi-Maurya74/Binge_Tavern/blob/main/gifs/gif%20(4).gif" width="200" height="400"/>
<img src="https://github.com/Ravi-Maurya74/Binge_Tavern/blob/main/gifs/gif%20(5).gif" width="200" height="400"/>
<img src="https://github.com/Ravi-Maurya74/Binge_Tavern/blob/main/gifs/gif%20(6).gif" width="200" height="400"/>
