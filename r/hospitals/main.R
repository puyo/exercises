source("rankhospital.R")
rankhospital("TX", "heart failure", 4)
# [1] "DETAR HOSPITAL NAVARRO"
rankhospital("MD", "heart attack", "worst")
# [1] "HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000)
# [1] NA

source("rankall.R")
head(rankall("heart attack", 20), 10)
#                           hospital state
#                               <NA>    AK
#     D W MCMILLAN MEMORIAL HOSPITAL    AL
#  ARKANSAS METHODIST MEDICAL CENTER    AR
# JOHN C LINCOLN DEER VALLEY HOSPITAL   AZ
#               SHERMAN OAKS HOSPITAL   CA <-- assignment expects, doesn't account for hospitals being listed twice in the data
#     VA SAN DIEGO HEALTHCARE SYSTEM    CA <-- I take the mean of values, which leads to this answer
#           SKY RIDGE MEDICAL CENTER    CO
#            MIDSTATE MEDICAL CENTER    CT
#                               <NA>    DC
#                               <NA>    DE
#     SOUTH FLORIDA BAPTIST HOSPITAL    FL

tail(rankall("pneumonia", "worst"), 3)
#                                   hospital state
# MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC    WI
#                     PLATEAU MEDICAL CENTER    WV
#           NORTH BIG HORN HOSPITAL DISTRICT    WY

tail(rankall("heart failure"), 10)
#                                                             hospital state
# 45                         WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL    TN
# 46                                        FORT DUNCAN MEDICAL CENTER    TX
# 47 VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER    UT
# 48                                          SENTARA POTOMAC HOSPITAL    VA
# 49                            GOV JUAN F LUIS HOSPITAL & MEDICAL CTR    VI
# 50                                              SPRINGFIELD HOSPITAL    VT
# 51                                         HARBORVIEW MEDICAL CENTER    WA
# 52                                    AURORA ST LUKES MEDICAL CENTER    WI
# 53                                         FAIRMONT GENERAL HOSPITAL    WV
# 54                                        CHEYENNE VA MEDICAL CENTER    WY