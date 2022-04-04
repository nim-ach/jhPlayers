## code to prepare `players` dataset goes here

library(data.table)

players = fread("data-raw/raw-data.csv")

players[, sex := as.factor(sex)]

usethis::use_data(players, overwrite = TRUE)
