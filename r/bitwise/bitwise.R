# Converts a string with Y and N standing in for 1 and 0 into a 2's complement integer.
#
# Example:
#   stringYNtoInt("NNNY") # =>  1 (00001)
#   stringYNtoInt("NNYN") # =>  2 (00010)
#   ...
#   stringYNtoInt("YYNN") # => 12 (01100)
#
stringYNtoInt <- function(valueYN) {
  value1N <- gsub("Y", "1", valueYN)
  value10 <- gsub("N", "0", value1N)
  strtoi(value10, 2)
}

# Takes a list of numbers and computes the bitwise-or of all of them.
#
# Example:
#   bitwiseOrList(c(1, 2)) # => 1 | 2
#                          # => 001 | 010
#                          # => 011
#                          # => 3
#
bitwiseOrList <- function(listOfIntegers) {
  Reduce("bitwOr", listOfIntegers)
}

# Sums the bits in a number.
#
# Example:
#   sumBitsInInt(3)  # => sumBitsInInt(011)
#                    # => 2
#   sumBitsInInt(13) # => sumBitsInInt(1101)
#                    # => 3
#
sumBitsInInt <- function(num) {
  result <- 0
  for (i in 0:11) {
    x <- bitwAnd(bitwShiftR(num, i), 1)
    result <- result + x
  }
  result
}

# ----

data <- data.frame(
  species = c("a", "a", "b", "b"),
  monthsYN = c("YYYYYYNNNNNN", "YYYNNNNNNNNN", "NNNYYYNNNNNN", "YNNYNNNNNNNN")
)

print(data)

results <- aggregate(stringYNtoInt(data$monthsYN), by = list(data$species), FUN = bitwiseOrList)
colnames(results) <- c("species", "monthsInt")
results$monthsBinary <- R.utils::as.character.binmode(results$monthsInt)
results$monthsCount <- sumBitsInInt(results$monthsInt)
results
