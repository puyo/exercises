rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  names(data)[names(data) == "Hospital.Name"] <- "name"
  names(data)[names(data) == "State"] <- "state"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"] <- "heart attack"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"] <- "heart failure"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"] <- "pneumonia"

  data <- subset(data, select = c("state", "name", "heart attack", "heart failure", "pneumonia"))
  statedata <- data[data$state == state & data[,outcome] != "Not Available",]
  
  ## Check that state and outcome are valid
  
  if (nrow(statedata) == 0) {
    stop("invalid state")
  }
  if (! outcome %in% c("heart attack", "heart failure", "pneumonia")) {
    stop("invalid outcome")
  }

  ## Return hospital name in that state with the given rank (num argument)
  ## 30-day death rate

  outcomes <- as.numeric(statedata[,outcome])
  means <- aggregate(outcomes, list(name = statedata$name), mean)
  ordered_means <- means[order(means$x, means$name),]

  if (num == "best") {
    head(ordered_means, n = 1)$name
  } else if (num == "worst") {
    tail(ordered_means, n = 1)$name
  } else {
    ordered_means[num,]$name
  }
}
