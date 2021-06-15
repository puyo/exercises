rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  names(data)[names(data) == "Hospital.Name"] <- "hospital"
  names(data)[names(data) == "State"] <- "state"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"] <- "heart attack"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"] <- "heart failure"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"] <- "pneumonia"

  data <- subset(data, select = c("state", "hospital", "heart attack", "heart failure", "pneumonia"))
  statedata <- data[data$state == state & data[,outcome] != "Not Available",]
  
  ## Check the arguments are valid
  
  if (nrow(statedata) == 0) {
    stop("invalid state")
  }
  if (! outcome %in% c("heart attack", "heart failure", "pneumonia")) {
    stop("invalid outcome")
  }
  if (!(num %in% c("best", "worst") || is.numeric(num))) {
    stop("invalid num")
  }

  ## Return hospital name in that state with the given rank (num argument)
  ## 30-day death rate

  pick_hospital <- function(statedata) {
    if (num == "best") {
      num = 1
    } else if (num == "worst") {
      num = nrow(statedata)
    }
    statedata[num,]$hospital
  }
  outcomes <- as.numeric(statedata[,outcome])
  means <- aggregate(outcomes, list(hospital = statedata$hospital), mean)
  ordered_means <- means[order(means$x, means$hospital),]
  statedata = ordered_means
  pick_hospital(ordered_means)
}
