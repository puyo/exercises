pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files

  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".

  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used

  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)

  result <- data.frame()
  for (i in id) {
    filename <- file.path(directory, sprintf("%03d.csv", i))
    idata <- read.csv(filename)
    result <- rbind(result, idata)
  }
  mean(result[,pollutant], na.rm = TRUE)
}

print(pollutantmean("specdata", "sulfate", 1:10))


library(tidyverse)

pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  
  paths = map(id, function(i) { file.path(directory, sprintf("%03d.csv", i)) })
  data = map_df(paths, function(path) { read.csv(path) })
  mean(data[, pollutant], na.rm = TRUE)
}

print(pollutantmean("specdata", "sulfate", 1:10))