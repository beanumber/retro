library(tidyverse)

url <- "http://www.retrosheet.org/parkcode.txt"
ballparks <- read_csv(url) %>%
  mutate(START = lubridate::mdy(START),
         END = lubridate::mdy(END))

names(ballparks) <- tolower(names(ballparks))

save(ballparks, file = "data/ballparks.rda", compress = "xz")
