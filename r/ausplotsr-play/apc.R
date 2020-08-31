library(curl)
library(tidyverse)

source("cache.R")

read_apc_csv <- function(path) {
  readr::read_csv(
    path,
    col_types = 
      cols(
        .default = readr::col_character(),
        proParte = readr::col_logical(),
        taxonRankSortOrder = readr::col_double(),
        created = readr::col_datetime(format = ""),
        modified = readr::col_datetime(format = "")
      )
  )
}

apc_fetch <- function() {
  cache_csv("apc.csv", function() {
    download.file("https://biodiversity.org.au/nsl/services/export/taxonCsv", "apc.csv", mode = 'wb')
    read_apc_csv("apc.csv")
  }, read_apc_csv)
}
