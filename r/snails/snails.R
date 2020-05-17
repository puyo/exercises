Snail_feeding <- read.csv("Snail_feeding.csv", header = T, strip.white = T, na.strings = "")

# Only keep columns 1:7
Snail_feeding <- Snail_feeding[,1:7]

# Selects rows that are not entirely NA
# Snail_feeding <- Snail_feeding[, colSums(is.na(Snail_feeding)) != nrow(Snail_feeding)]
# Select columns that are not entirely NA
# Snail_feeding <- Snail_feeding[rowSums(is.na(Snail_feeding)) != ncol(Snail_feeding), ]  

# install (if not already installed) and load dplyr package
if (!require(dplyr)) { install.packages('dplyr') }

# Rename Snail.ID to Snail using dplyr
Snail_feeding <-
  Snail_feeding %>%
  rename("Snail" = "Snail.ID")

# Rename Snail.ID using built in R
# names(Snail_feeding$Snail.ID) <- "Snail"

Snail_feeding$Snail <- as.factor(Snail_feeding$Snail)

Snail_feeding$Size <- as.factor(Snail_feeding$Size)

# which(is.na(as.numeric(Snail_feeding$Distance))) # 682 755
Snail_feeding$Distance[682] <- 0.356452  # comma instead of dec point
Snail_feeding$Distance[755] <- 0.58      # trailing single quote
Snail_feeding$Distance <- as.numeric(Snail_feeding$Distance)

# unique(Snail_feeding$Sex) # [1] "male"     "males"    "Male"     "female"   "female s"
Snail_feeding$Sex[which(Snail_feeding$Sex == "males" | Snail_feeding$Sex == "Male")] <- "male"
Snail_feeding$Sex[which(Snail_feeding$Sex == "female s")] <- "female"
Snail_feeding$Sex <- factor(Snail_feeding$Sex)

# Snail_feeding[which(Snail_feeding$Depth > 2), ] # row 8, depth 162
Snail_feeding$Depth[8] <- 1.62 # missing decimal point

summary(Snail_feeding)
