# script to create the data for shiny app
library(dplyr)
library(geosphere)
library(tidyr)

source("fct_data_processing.R")

# PRIMARY USE CASE
maritime_data <- read.csv("src/data/ships.csv")
saveRDS(get_longest_distance_data(maritime_data), "src/data/shiny_data.rds")

# ADDITIONAL USE CASE
most_recent_data <- get_most_recent_data(maritime_data)
port_usage <- count_(most_recent_data, vars = c('ship_type','port', 'FLAG'))
saveRDS(list(most_recent = most_recent_data, port_usage = port_usage), file = "src/data/additional_vis.rds")