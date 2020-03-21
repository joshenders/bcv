#' Get registered workers
#'
#' Retrieve registered workers from the database associated wtih the shiny app
#' This is NOT part of the traccar suite of tools
#' @param dbname The name of your database
#' @param host The host ip address of your database
#' @param user The username for your database
#' @param pass The password for your database
#' @param port The port number for yourdatabse
#' @return A dataframe
#' @export
#' @import dplyr
#' @import DBI
#' @import RMySQL

get_registered_workers <- function(dbname, 
                                 host, 
                                 user, 
                                 pass, 
                                 port = 3306){
  # Example to connect to database:
  creds <- list(dbname = dbname,
                host = host,
                user = user,
                pass = pass)

  # Connect to database
  con <- DBI::dbConnect(drv = RMySQL::MySQL(),
                        dbname = creds$dbname,
                        host = creds$host,
                        user = creds$user,
                        pass = creds$pass,
                        port = port)

  out = dbGetQuery(conn = con,
                   "select * FROM users;")

  return(out)
}
