library(RSelenium)
library(testthat)

context("Test shiny app")


remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444L,
  browserName = "chrome"
)

remDr$open(silent = T)
remDr$navigate("https://shining-thiloshon.shinyapps.io/MaritimeExplorer/")
Sys.sleep(5)
vesselDropdown <- remDr$findElement(using = "xpath", value = "//div[@id='leafletPanel-vessel']//*[@class='item']")


test_that("Changing Ship Type Changes Vessel", {
  
  # Act
  queryButton <- remDr$findElement(using = "id", value = "navbutton-fishing")
  queryButton$clickElement()
  Sys.sleep(2)
  
  #Assert
  vesselDropdown <- remDr$findElement(using = "xpath", value = "//div[@id='leafletPanel-vessel']//*[@class='text']")
  testthat::expect_equal(vesselDropdown$getElementText(), "( 151919 ) KRISTIN")
  
})


test_that("Changing Vessel Changes Stats", {
  
  # Act
  
  dropdownelement <- remDr$findElement(using = "id", value = "leafletPanel-vessel")
  dropdownelement$clickElement()
  Sys.sleep(2)
  
  dropdownelement2 <- remDr$findElement(using = "xpath", value = "//*[@data-value='156348']")
  dropdownelement2$clickElement()
  
  totalCard <- remDr$findElement(using = "id", value = "totalVessel")
  
  testthat::expect_equal(totalCard$getElementText(), "179")
  
})


remDr$close()

