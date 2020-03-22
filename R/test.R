library(httr)
library(tidyverse)
library(yaml)

######################
# reports/events
#####################3
credentials <- yaml::read_yaml('credentials/credentials.yaml')
url <- credentials$traccar_url
user = credentials$traccar_user
pass = credentials$traccar_pass
path <- 'api/reports/events?deviceId=2&from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'

r <- GET(url = url, path = path, authenticate(user, pass))
output <- content(r)
values <- unlist(output)
keys <- names(values)
out <- tibble(key = keys, value = values)
out$group_id <- NA
for(i in 1:nrow(out)){
  counter <- i
  this_row <- out[counter,]
  key <- this_row$key
  while(key != 'id'){
    counter <- counter - 1
    this_row <- out[counter,]
    key <- this_row$key
  }
  out$group_id[i] <- this_row$value
}

final <- out %>% spread(key = key, value = value) %>%
  mutate(id = as.numeric(id)) %>% dplyr::select(-group_id) %>%
  arrange(id)


######################
# reports/routes
#####################3
credentials <- yaml::read_yaml('credentials/credentials.yaml')
url <- credentials$traccar_url
user = credentials$traccar_user
pass = credentials$traccar_pass
path <- 'api/reports/route?deviceId=3&from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'

r <- GET(url = url, path = path, authenticate(user, pass), accept('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
output <- content(r)
values <- unlist(output)
keys <- names(values)
out <- tibble(key = keys, value = values)
out$group_id <- NA
for(i in 1:nrow(out)){
  counter <- i
  this_row <- out[counter,]
  key <- this_row$key
  while(key != 'id'){
    counter <- counter - 1
    this_row <- out[counter,]
    key <- this_row$key
  }
  out$group_id[i] <- this_row$value
}

final <- out %>% spread(key = key, value = value) %>%
  mutate(id = as.numeric(id)) %>% dplyr::select(-group_id) %>%
  arrange(id)

######################
# reports/events
#####################3
credentials <- yaml::read_yaml('credentials/credentials.yaml')
url <- credentials$traccar_url
user = credentials$traccar_user
pass = credentials$traccar_pass
path <- 'api/reports/stops?deviceId=3&from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'

r <- GET(url = url, path = path, authenticate(user, pass), accept('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
readxl::read_vn(r)
output <- content(r)
values <- unlist(output)
keys <- names(values)
out <- tibble(key = keys, value = values)
out$group_id <- NA
for(i in 1:nrow(out)){
  counter <- i
  this_row <- out[counter,]
  key <- this_row$key
  while(key != 'id'){
    counter <- counter - 1
    this_row <- out[counter,]
    key <- this_row$key
  }
  out$group_id[i] <- this_row$value
}

final <- out %>% spread(key = key, value = value) %>%
  mutate(id = as.numeric(id)) %>% dplyr::select(-group_id) %>%
  arrange(id)


######################
# reports/summary
#####################3
credentials <- yaml::read_yaml('credentials/credentials.yaml')
url <- credentials$traccar_url
user = credentials$traccar_user
pass = credentials$traccar_pass
path <- 'api/reports/summary?deviceId=3&from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'

r <- GET(url = url, path = path, authenticate(user, pass), accept('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
output <- content(r)
values <- unlist(output)
keys <- names(values)
out <- tibble(key = keys, value = values)
out$group_id <- NA
for(i in 1:nrow(out)){
  counter <- i
  this_row <- out[counter,]
  key <- this_row$key
  while(key != 'id'){
    counter <- counter - 1
    this_row <- out[counter,]
    key <- this_row$key
  }
  out$group_id[i] <- this_row$value
}

final <- out %>% spread(key = key, value = value) %>%
  mutate(id = as.numeric(id)) %>% dplyr::select(-group_id) %>%
  arrange(id)


######################
# reports/trips
#####################3
credentials <- yaml::read_yaml('credentials/credentials.yaml')
url <- credentials$traccar_url
user = credentials$traccar_user
pass = credentials$traccar_pass
path <- 'api/reports/trips?deviceId=3&from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'

r <- GET(url = url, path = path, authenticate(user, pass), accept('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
output <- cat(content(r, type = 'text'), '\n' )
values <- unlist(output)
keys <- names(values)
out <- tibble(key = keys, value = values)
out$group_id <- NA
for(i in 1:nrow(out)){
  counter <- i
  this_row <- out[counter,]
  key <- this_row$key
  while(key != 'id'){
    counter <- counter - 1
    this_row <- out[counter,]
    key <- this_row$key
  }
  out$group_id[i] <- this_row$value
}

final <- out %>% spread(key = key, value = value) %>%
  mutate(id = as.numeric(id)) %>% dplyr::select(-group_id) %>%
  arrange(id)

