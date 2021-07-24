source("../../data/fct_data_processing.R")
set.seed(1)

test_that("Longest-Distance Calculation Works", {
  
  # Assign
  mock_data <- data.frame(SHIPNAME = c("A","A","A"),
                          SHIP_ID = c("A","A","A"),
                      LAT = sample(seq(from=-90, to=90, by=.01), size=3, replace=TRUE),
                      LON = sample(seq(from=-180, to=180, by=.01), size=3, replace=TRUE),
                      DATETIME = as.POSIXct(c('2016-01-01 14:00:00','2017-01-01 14:00:00','2018-01-01 14:00:00')))
  
  # Act
  uut <- get_longest_distance_data(mock_data)
                     
  #Assert
  testthat::expect_equal(uut$distance, 14967598, tolerance=1e-3)
  testthat::expect_equal(uut$lat_prev, 84)
})


test_that("Longest-Distance for Conflicting Date Works", {
  
  # Assign
  mock_data <- data.frame(SHIPNAME = c("A","A","A"),
                          SHIP_ID = c(1, 1, 1),
                          LAT = c(8, 8, 8),
                          LON = c(10, 10, 10),
                          DATETIME = as.POSIXct(c('2016-01-01 14:00:00','2017-01-01 14:00:00','2018-01-01 14:00:00'), format = "%Y-%m-%d %H:%M:%S"))
  # Act
  uut <- get_longest_distance_data(mock_data)

  #Assert
  testthat::expect_equal(as.character(uut$DATETIME), "2018-01-01 14:00:00")
})


test_that("Longest-Distance for Multiple Ships Works", {
  
  # Assign
  mock_data <- data.frame(SHIPNAME = c("A","B","B"),
                          SHIP_ID = c(1, 2, 3),
                          LAT = sample(seq(from=-90, to=90, by=.01), size=3, replace=TRUE),
                          LON = sample(seq(from=-180, to=180, by=.01), size=3, replace=TRUE),
                          DATETIME = as.POSIXct(c('2016-01-01 14:00:00','2017-01-01 14:00:00','2018-01-01 14:00:00')))
  # Act
  uut <- get_longest_distance_data(mock_data)
  
  #Assert
  testthat::expect_equal(nrow(uut), 3)
})