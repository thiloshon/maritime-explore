# maritime-explore
Shiny dashboard to explore maritime data

Access this app live at https://shining-thiloshon.shinyapps.io/MaritimeExplorer/

Note: Instead of a dropdown to select ship type, I have added a vertical button nav. I understand this adds additional observe events but since it's a simple app, I preferred aestheticness.

# Preprocessing

1. Download raw dataset and run script in src/data/data_preprocess.R
2. This creates summarized datasets in RDS formats thats used in shiny app effciently.
3. In production we can automate this process with scheduled tasks and data purging to improve performance.

# Testing

Basic Unit testing, module testing and RSelenium testing capabilities have been added in scr/tests folder. Preferred to have Selenium server running on port 4444 for the test. Run entire test suite by running testthat.R script. 

Result of last test:

![alt text](https://github.com/thiloshon/maritime-explore/blob/main/img/test.png?raw=true)

# Running 

To run the app, run command:

```
runApp('src')
```
Demo of the app:

![alt text](https://github.com/thiloshon/maritime-explore/blob/main/img/demo.gif?raw=true)