#' Get device id from unique id
#'
#' Retrieve device id from api/devices using unique id
#' @param user The username for your traccar api
#' @param pass The password for your traccar api
#' @param url The url of your traccar api
#' @param path API path
#' @param unique_id The unique id for a regestered HCW on the traccar api
#' @return A dataframe
#' @export
#' @import dplyr
#' @import httr
#' @import tidyverse
#' @import yaml
get_device_id_from_unique_id <- function(url, 
                                         user, 
                                         pass, 
                                         unique_id,
                                         path = 'api/devices'){
  path <- paste0(path, '?', 'uniqueId=', unique_id)
  r <- GET(url = url, 
           path = path, 
           authenticate(user, pass))
  out <- as.character(content(r)[[1]]$id)
  return(out)
}

#' Get reports from device id
#'
#' Retrieve reports from api/positions using device_id
#' @param user The username for your traccar api
#' @param pass The password for your traccar api
#' @param url The url of your traccar api
#' @param path API path
#' @param report_type The type of report: trips, summary, stops, route, events
#' @param device_id The id for a registered HCW on the traccar api
#' @return A dataframe
#' @export
#' @import dplyr
#' @import httr
#' @import tidyverse
#' @import yaml
get_reports_from_device_id <- function(url, 
                                         user, 
                                         pass, 
                                         device_id, 
                                         report_type,
                                         path = 'api/reports/'){
  # add id to path
  dates <- 'from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'
  path <- paste0(path,report_type , '?','deviceId=',device_id,'&',  dates)
  r <- GET(url = url, 
           path = path, 
           authenticate(user, pass))#, 
           #accept('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))
  # once we figure out how to convert the above directly into a dataframe, use below code. 
  output <- content(r)
  values <- unlist(output)
  keys <- names(values)
  out <- tibble(key = keys, value = values)
  # routes ad events return a unique id column, so can use loop from other functons
  # other reports don't return a unique id, so there is an extra loop to generate one in order to 
  # do spread
  if(report_type %in% c('route', 'events')){
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
  } else {
    for(i in 1:nrow(out)){
      this_row <- out[i,]
      row_names <- rownames(out)
      key <- this_row$key
      if(key == 'deviceId'){
        new_id <- i
        this_row$value <- new_id
      }
      out$value[i]<- this_row$value
    }
    group_id <- NA
    for(i in 1:nrow(out)){
      counter <- i
      this_row <- out[counter,]
      key <- this_row$key
      while(key != 'deviceId'){
        counter <- counter - 1
        this_row <- out[counter,]
        key <- this_row$key
      }
      out$group_id[i] <- this_row$value
    }
    final <- out %>% spread(key = key, value = value) %>%
      mutate(device_id = as.numeric(device_id)) %>% dplyr::select(-c(group_id, deviceId)) %>%
      arrange(device_id) 
  }
 

  return(final)
}

#' Get positions from unique id
#'
#' Retrieve positions using a unique id
#' @param user The username for your traccar api
#' @param pass The password for your traccar api
#' @param url The url of your traccar api
#' @param report_type The type of report: trips, summary, stops, route, events
#' @param unique_id The unique id for a regestered HCW on the traccar api
#' @return A dataframe
#' @export
#' @import dplyr
#' @import httr
#' @import tidyverse
#' @import yaml
#' @import readr
get_reports_from_unique_id <- function(url, 
                                         user, 
                                         pass, 
                                         report_type,
                                         unique_id){
  if(!report_type %in% c('trips', 'summary', 'stops', 'route', 'events')){
    message('---- not a valid report type')
    message("---- use either 'trips','summary', 'stops', 'route', or 'events'")
  }
  # first fetch device_id 
  device_id <- get_device_id_from_unique_id(url = url,
                                            user = user,
                                            pass = pass,
                                            unique_id = unique_id)
  # fetch positions
  out <- get_reports_from_device_id(url = url,
                                      user = user,
                                      pass = pass,
                                      report_type = report_type,
                                      device_id =device_id)
  return(out)
  
}
