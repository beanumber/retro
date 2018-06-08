library(tidyverse)

url <- "http://www.retrosheet.org/parkcode.txt"
ballparks <- read_csv(url) %>%
  mutate(START = lubridate::mdy(START),
         END = lubridate::mdy(END))

names(ballparks) <- tolower(names(ballparks))

save(ballparks, file = "data/ballparks.rda", compress = "xz")


event_codes <- read_csv("data-raw/event_codes.csv") %>%
  rename(EVENT_CD = Code,
         EVENT = `Primary event`)

save(event_codes, file = "data/event_codes.rda", compress = "xz")
