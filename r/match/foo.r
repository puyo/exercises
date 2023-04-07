suppressPackageStartupMessages(library("tidyverse"))
options(warn = 1)
library(tidyverse)

extract_buds <- function(input) {
  # just the sentence starting with Inflorescence and ending with a full top AND a space after
  desc <- str_extract(input, "Inflorescence.*?\\. ")

  # get rid of question all marks e.g. buds ?11
  input <- gsub("\\?", "", desc)

  # get rid of all contents of brackets ( ... ) e.g. (rarely 3)
  input <- gsub("\\(.*?\\)", "", input)

  is_match <- function(m) { return(!is.na(m[[1]])) }
  reg_match <- stringr::str_match

  if (is_match(m <- reg_match(input, "buds? solitary"))) {
    m_type <- "solitary"
    m0 <- 1
    m1 <- 1
  } else if (is_match(m <- reg_match(input, "(\\d+) buds per umbel"))) {
    m_type <- "X buds per umbel"
    m0 <- as.numeric(m[2])
    m1 <- as.numeric(m[2])
  } else if (is_match(m <- reg_match(input, "buds? (?:usually |in umbels of |more than)?([\\d, ]+?(?:or|and|to) \\d+)"))) {
    nums <- stringr::str_extract_all(m[2], "\\d+")[[1]]
    if (length(nums) == 0) {
      m_type <- NA
      m0 <- NA
      m1 <- NA
    } else {
      m_type <- "X, Y or Z"
      nums <- as.numeric(nums)
      m0 <- min(nums)
      m1 <- max(nums)
    }
  } else if (is_match(m <- reg_match(input, "bud(.*),"))) {
    print(m)
    nums <- stringr::str_extract_all(m[2], "\\d+")[[1]]
    if (length(nums) == 0) {
      m_type <- NA
      m0 <- NA
      m1 <- NA
    } else {
      m_type <- "bud ... ,"
      nums <- as.numeric(nums)
      m0 <- min(nums)
      m1 <- max(nums)
    }
  } else {
    m_type <- NA
    m0 <- NA
    m1 <- NA
  }

  return(list(buds_desc=desc, buds_input_type=m_type, buds_min=m0, buds_max=m1))
}

add_buds_column <- function(df) {
  buds <- data.frame()
  for (i in 1:nrow(df)) {
    desc <- df[[i, "description"]]
    buds_row <- extract_buds(desc)
    buds <- rbind(buds_row, buds)
  }
  euclid <- cbind(euclid, buds)
  return(euclid)
}

# ------

test_extract_buds <- function() {
  tests <- list(
    list(min=7,  max=7,  input="Inflorescence blah, buds 7 per umbel, blah. "),
    list(min=7,  max=13, input="Inflorescence blah, buds 7, 9, 11 or 13 per umbel, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, 7 buds per umbel, rarely 3, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds 7(–11) per umbel, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds per umbel 7, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds usually 7 (rarely 3) per umbel, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds more than 7 per umbel, blah. "),
    list(min=7,  max=9,  input="Inflorescence blah, buds 7 or more commonly 9 per umbel, blah. "),
    list(min=9,  max=9,  input="Inflorescence blah, buds 9 (rarely 11) per umbel, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds per umbel 7, blah. "),
    list(min=9,  max=15, input="Inflorescence blah, buds 9 to15 per umbel, blah. "),
    list(min=7,  max=9,  input="Inflorescence blah, buds 7–9 per umbel, blah. "),
    list(min=3,  max=3,  input="Inflorescence blah, buds 3 (rarely 7) per umbel, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds 7 or sometimes irregular due to internode elongation within an umbel, blah. "),
    list(min=11, max=15, input="Inflorescence blah, buds 11 to more than 15 per umbel, blah. "),
    list(min=7,  max=19, input="Inflorescence blah, buds 7–19 per umbel, blah. "),
    list(min=9,  max=27, input="Inflorescence blah, buds 9–27 per umbel, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds 7, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds per umbel 7, blah. "),
    list(min=11, max=11, input="Inflorescence blah, buds 11 to many per umbel, blah. "),
    list(min=11, max=19, input="Inflorescence blah, buds 11 to 19 per umbel, blah. "),
    list(min=3,  max=7,  input="Inflorescence blah, buds 3 or 7 per umbel, blah. "),
    list(min=1,  max=1,  input="Inflorescence blah, bud solitary, blah. "),
    list(min=7,  max=7,  input="Inflorescence blah, buds usually 7 per umbel (rarely up to 11), pedicels 0.1–0.3 cm long. "),
    list(min=11, max=15, input="Inflorescence blah, buds in umbels of 11 to 15(21), sessile or with pedicels to 0.3 cm long. "),
    list(min=7,  max=15, input="Inflorescence blah, buds 7 to ?15, pedicellate (pedicels (0.3–0.6 cm long). "),
    list(min=3,  max=3,  input="Inflorescence blah, buds 3, or 8 or 5, and something 6. ")
  )

  failed <- FALSE
  for (test in tests) {
    result <- extract_buds(test$input)
    if (
      is.na(result$buds_input_type) ||
      test$min != result$buds_min ||
      test$max != result$buds_max
    ) {
      print(sprintf(
        "'%s': expected %d..%d, got %d..%d (%s)",
        test$input,
        test$min,
        test$max,
        result$buds_min,
        result$buds_max,
        result$buds_input_type
      ))
      failed <- TRUE
    }
  }
  if (failed) {
    cat("Tests FAILED\n")
  } else {
    cat("All tests OK\n")
  }

}

# -------

test_extract_buds()

# -------

euclid <- readr::read_csv("Euclid_downloaded.csv", show_col_types = FALSE)
# cat("Euclid\n----------------------------\n")
# print(summary(euclid))
euclid_with_buds <- add_buds_column(euclid)
# cat("Euclid, with buds\n-------------------------------\n")
# print(summary(euclid_with_buds))
# problems <- euclid_with_buds[is.na(euclid_with_buds$buds_input_type),]
# print(problems$buds_desc)
