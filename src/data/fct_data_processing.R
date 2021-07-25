#
get_longest_distance_data <- function(data){
  
  returndata <- data %>%
    group_by(SHIP_ID) %>% # then grouping to make sure other ship data doesnt interfere
    mutate(DATETIME = as.POSIXct(DATETIME, format = "%Y-%m-%dT%H:%M:%S")) %>%
    arrange(DATETIME)  %>% # first sorting to make sure lag would give correct result
    mutate(lat_prev = lag(LAT), lon_prev = lag(LON)) %>%  # getting lag to treat as prevoius occurance
    mutate(distance = distHaversine(cbind(LON, LAT), cbind(lon_prev, lat_prev))) %>%
    mutate(distance = replace_na(distance, 0)) %>%
    filter(distance == max(distance)) %>%
    filter(DATETIME == max(DATETIME)) %>%
    mutate(vessel_name = paste("( " , SHIP_ID , " )", SHIPNAME))
  
  return(as.data.frame(returndata))
}


get_most_recent_data <- function(data){

  return_data <- data %>%
    mutate(DATETIME = as.POSIXct(DATETIME, format = "%Y-%m-%dT%H:%M:%S")) %>%
    group_by(SHIP_ID) %>%
    filter(DATETIME == max(DATETIME))
  
  return(as.data.frame(return_data))
}


