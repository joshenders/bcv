#' Get locations
#'
#' Retrieve location data from the traccar api for a given HCW ID
#' @param user The username for your traccar api
#' @param pass The password for your traccar api
#' @param url The url of your traccar api
#' @param path API path
#' @param hcw_id The id for a registered HCW on the traccar api
#' @return A dataframe
#' @export
#' @import dplyr
#' @import httr
#' @import tidyverse
#' @import yaml

get_locations <- function(url, 
                          user, 
                          pass, 
                          hcw_id, 
                          path = 'api/positions?from=2010-01-01T22%3A00%3A00Z&to=2020-12-31T22%3A00%3A00Z'){
  # add id to path
  path <- paste0(path, '&', 'deviceId=', hcw_id)
  r <- GET(url = url, 
           path = path, 
           authenticate(user, pass), 
           accept('text/csv'))
  
  out = read_delim(r$content, delim =';')
  
  return(out)
}
