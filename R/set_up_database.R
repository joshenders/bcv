#' Set up the database
#'
#' Set up the databse. Only needs to be run one
#' @param credentials The path to a credentials file
#' @return Database tables will be set up
#' @export
#' @import dplyr
#' @import DBI
#' @import RMySQL
#' @import yaml

set_up_database <- function(credentials){
  
  # Read in credentials
  credentials <- yaml::yaml.load_file(credentials)

  # Open Connection
  con <- DBI::dbConnect(drv = RMySQL::MySQL(),
                        dbname = credentials$dbname,
                        host = credentials$host,
                        user = credentials$user,
                        pass = credentials$pass,
                        port = credentials$port)
  
  # Write a table for users
  df <- tibble(nombre = 'Joe',
               apellido = 'Brew',
               tel = '+34 666 66 80 86',
               email = 'joe@databrew.cc', 
               lugar = 'Casa, Santa Coloma de Queralt',
               id = 1)
  RMySQL::dbWriteTable(conn = con,
                       name = 'users',
                       value = df)
  
  # Write a table for cases
  cases <- tibble(case_id = 0,
                  case_name = 'Joe Brew',
                  case_date_symptoms = as.Date('2020-03-15'),
                  case_date_dx = as.Date('2020-03-16'),
                  time_stamp = Sys.time())
  RMySQL::dbWriteTable(conn = con,
                       name = 'cases',
                       value = cases)
  
  
  RMySQL::dbDisconnect(conn = con)
}
