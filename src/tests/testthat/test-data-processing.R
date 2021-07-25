context("test preprocessing")

set.seed(1)
source("../../data/fct_data_processing.R")

test_that("Longest-Distance Calculation Works", {
  # Assign
  mock_data <- data.frame(
    SHIPNAME = c("A", "A", "A"),
    SHIP_ID = c("A", "A", "A"),
    LAT = sample(
      seq(from = -90, to = 90, by = .01),
      size = 3,
      replace = TRUE
    ),
    LON = sample(
      seq(from = -180, to = 180, by = .01),
      size = 3,
      replace = TRUE
    ),
    DATETIME = c(
      '2016-01-01T14:00:00Z',
      '2017-01-01T14:00:00Z',
      '2018-01-01T14:00:00Z'
    )
  )
  
  # Act
  uut <- get_longest_distance_data(mock_data)
  
  #Assert
  testthat::expect_equal(uut$distance, 14967598, tolerance = 1e-3)
  testthat::expect_equal(uut$lat_prev, 84)
})


test_that("Longest-Distance for Conflicting Date Works", {
  # Assign
  mock_data <- data.frame(
    SHIPNAME = c("A", "A", "A"),
    SHIP_ID = c(1, 1, 1),
    LAT = c(8, 8, 8),
    LON = c(10, 10, 10),
    DATETIME = c(
      '2016-01-01T14:00:00Z',
      '2017-01-01T14:00:00Z',
      '2018-01-01T14:00:00Z'
    )
  )
  # Act
  uut <- get_longest_distance_data(mock_data)
  
  #Assert
  testthat::expect_equal(as.character(uut$DATETIME), "2018-01-01 14:00:00")
})


test_that("Longest-Distance for Multiple Ships Works", {
  # Assign
  mock_data <- data.frame(
    SHIPNAME = c("A", "B", "C"),
    SHIP_ID = c(1, 2, 3),
    LAT = sample(
      seq(from = -90, to = 90, by = .01),
      size = 3,
      replace = TRUE
    ),
    LON = sample(
      seq(from = -180, to = 180, by = .01),
      size = 3,
      replace = TRUE
    ),
    DATETIME = c(
      '2016-01-01T14:00:00Z',
      '2017-01-01T14:00:00Z',
      '2018-01-01T14:00:00Z'
    )
  )
  # Act
  uut <- get_longest_distance_data(mock_data)
  
  #Assert
  testthat::expect_equal(nrow(uut), 3)
})

# Assuming if the ship was observed only once, the distance is 0
test_that("Longest-Distance for NA values Works", {
  # Assign
  mock_data <- data.frame(
    SHIPNAME = c("A", "B", "B", "C", NA),
    SHIP_ID = c(1, 2, 3, NA, 5),
    LAT = c(9, 8, 5, 7, NA),
    LON = c(NA, 5,-6, 8, 10),
    DATETIME = c(
      '2016-01-01T14:00:00Z',
      '2017-01-01T14:00:00Z',
      '2018-01-01T14:00:00Z',
      NA,
      NA
    )
  )
  
  # Act
  uut <- get_longest_distance_data(mock_data)
  
  #Assert
  testthat::expect_equal(nrow(uut), 3)
  testthat::expect_equal(uut$SHIP_ID, c(1, 2, 3))
})
