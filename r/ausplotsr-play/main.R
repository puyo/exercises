source("cache.R")

# get ausplots data
library(ausplotsR)
ausplots_vegpi <- cache_csv("ausplots_vegpi.csv", function() { ausplotsR::get_ausplots(veg.PI = TRUE, veg.vouchers = FALSE)$veg.PI })
names <- unique(ausplots_vegpi$herbarium_determination[!is.na(ausplots_vegpi$herbarium_determination)])

# get apc data
source("apc.R")
apc <- apc_fetch()

# matching
library(stringdist)

name <- names[1:20]
idx <- stringdist::amatch(names, apc$canonicalName)
m <- apc[idx,]
stringsim(name, apc$canonicalName[idx])

