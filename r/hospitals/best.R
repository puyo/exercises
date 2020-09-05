colnames <- list(
  "heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
  "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
  "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
)

best <- function(state, outcome) {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  statedata <- data[data$State == state,]
  
  ## Check that state and outcome are valid
  colname <- colnames[[outcome]]
  if (nrow(statedata) == 0) {
    stop("invalid state")
  }
  if (is.null(colname)) {
    stop("invalid outcome")
  }
  by_hospital <- split(statedata, statedata$Hospital.Name)
  calc_mean <- function(x) {
    mean(as.numeric(x[,colname]), na.rm = TRUE)
  }
  means <- lapply(by_hospital, calc_mean)
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  names(which.min(means))
}