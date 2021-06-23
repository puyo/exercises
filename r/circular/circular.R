library(circular)  #to install: install.packages("circular")

#generate example data, from Nov (i.e. 11) to March (i.e. 3)
df <- data.frame(X = c(rep(paste("species", 2), 5)),
                 Y = c(1:3, 11:12))

df$r <- c(0, pi/4, pi/4, -pi/4, -pi/4) # mean = 0

df$r <- circular::circular(df$r, units = "radians")


df$Y <- circular::circular(df$Y, units = "hours", template = "clock12") #convert to circular variable


# should be 0, is 0
circular::mean.circular(circular::circular(c(0, pi/4, pi/4, -pi/4, -pi/4), units = "radians"))

# should be 1
df$Yrad <- ((df$Y-1)*(2*pi/12))
circular::mean.circular(circular::circular(c(2, 12), units = "hours", template = "clock12"))

circular::mean.circular(df$Y) #calculate circular mean

#should return mean of 1 (January) but instead returns:

#Circular Data: 
#Type = angles 
#Units = hours 
#Template = clock12 
#Modulo = asis 
#Zero = 1.570796 
#Rotation = clock 
#[1] 4.774558


library(tidyverse) #to install: install.packages("tidyverse")
library(circular)  #to install: install.packages("circular")

#generate example data
df2 <- data.frame(X = c(rep(paste("species", 1), 5), rep(paste("species", 2), 5), 
                        rep(paste("species", 3), 4), rep(paste("species", 4), 6)),
                  Y = c(5:9, 1:3, 11:12, 1:2, 11:12, 3, 5, 8, 9, 10, 12))

df2$X <- as.factor(df2$X)
df2$Yrad <- ((df2$Y-1)*(2*pi/12)) #convert months to radians with 0 radians = January
df2$Yrad <- circular::circular(df2$Yrad, units = "radians") #convert Yrad to circular variable

#calculate circular mean for each species in column X
circmean <- df2 %>%
  dplyr::group_by(X) %>%
  dplyr::summarise(circ_mean = mean(Yrad), n = n())

#convert mean from radians back to months
circmean$circmeanmonth <- ((round( circmean$circ_mean * 12 / (2*pi), digits = 3) %% 12)) + 1

#returns below - circular mean looks correct for species 2 and maybe species 3?
#>X           circ_mean       circmeanmonth
#>species 1   3.141593e+00    4.141593
#>species 2   -2.379867e-16   1.000000
#>species 3   -2.617994e-01   12.738201
#>species 4   -1.986080e+00   11.013920