corr <- function(directory, threshold = 0) {
  paths <- list.files(directory, full.names = TRUE)
  result <- c()
  for (path in paths) {
    data <- read.csv(path)
    complete <- data[complete.cases(data),]
    ncomplete <- nrow(complete)
    if (ncomplete < threshold) {
      next
    }
    value <- cor(complete$sulfate, complete$nitrate)
    result <- c(result, value)
  }
  result
}

head(corr("specdata", 150))