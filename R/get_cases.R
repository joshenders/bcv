#' Get cases
#'
#' Retrieve the table of reported cases
#' This is NOT part of the traccar suite of tools
#' @param dbname The name of your database
#' @param host The host ip address of your database
#' @param user The username for your database
#' @param pass The password for your database
#' @param port The port number for yourdatabse
#' @param unique_id Optional, restrict to only one unique_id
#' @return A dataframe
#' @export
#' @import dplyr
#' @import DBI
#' @import RMySQL

get_cases <- function(dbname, 
                      host, 
                      user, 
                      pass, 
                      port = 3306,
                      unique_id = NULL){
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
  
  if(is.null(unique_id)){
    out = dbGetQuery(conn = con,
                     "select * FROM cases;")
  } else {
    out = dbGetQuery(conn = con,
                     paste0("select * FROM cases WHERE case_id=",
                            unique_id,
                            ";"))
  }
  return(out)
}
