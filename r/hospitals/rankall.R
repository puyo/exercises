rankall <- function(outcome, num = "best") {
  ## Read outcome data
  
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  names(data)[names(data) == "Hospital.Name"] <- "hospital"
  names(data)[names(data) == "State"] <- "state"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"] <- "heart attack"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"] <- "heart failure"
  names(data)[names(data) == "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"] <- "pneumonia"
  data <- subset(data, select = c("state", "hospital", "heart attack", "heart failure", "pneumonia"))
  data <- data[data[,outcome] != "Not Available",]
  
  ## Check the arguments are valid
  
  if (!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
    stop("invalid outcome")
  }
  if (!(num %in% c("best", "worst") || is.numeric(num))) {
    stop("invalid num")
  }
  
  ## For each state, find the hospital of the given rank
  
  pick_hospital <- function(statedata) {
    if (num == "best") {
      num = 1
    } else if (num == "worst") {
      num = nrow(statedata)
    }
    statedata[num,]$hospital
  }
  
  outcomes <- as.numeric(data[,outcome])
  means <- aggregate(outcomes, list(hospital = data$hospital, state = data$state), mean)
  ordered_means <- means[order(means$x, means$hospital),]
  
  result <- data.frame()
  for (state in sort(unique(data$state))) {
    statedata <- ordered_means[ordered_means$state == state,]
    record <- data.frame(hospital = pick_hospital(statedata), state = state)
    result <- rbind(result, record)
  }
  result
}
