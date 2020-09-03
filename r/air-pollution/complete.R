complete <- function(directory, id = 1:332) {
  result <- data.frame()
  for (i in id) {
    filename <- file.path(directory, sprintf("%03d.csv", i))
    data <- read.csv(filename)
    complete <- data[complete.cases(data),]
    value <- nrow(complete)
    result <- rbind(result, data.frame(id = i, nobs = value))
  }
  result
}
complete("specdata", c(2, 4, 8, 10, 12))
complete("specdata", 30:25)
complete("specdata", c(6, 10, 20, 34, 100, 200, 310))