#' Sync workers
#'
#' Syncronize between (a) the workers who have registered via the shiny app and (b) the workers whose information has been registered on the Traccar server app
#' @param credentials A list with the following named elements: dbname, host, user, pass, port (all referring to the MySQL database which communicates with the shiny app) and traccar_url, traccar_user, traccar_pass (these last 3 referring to the Traccar server). If \code{NULL} these arguments can be specified individually
#' @param delete_from_traccar Whether to delete from Traccar those workers who don't show up in the shiny database. Be careful with this!
#' @param dbname Name of the MySQL database which communicates with the Shiny server. Example: bcvdb
#' @param host The host (IP) of the MySQL database which communicates with the Shiny server
#' @param user The username of the MySQL database which communicates wih the Shiny server
#' @param pass The password for accessing the MySQL database which communicates wih the Shiny server
#' @param port The port of the MySQL database which communicates with the Shiny Server
#' @param traccar_url The URL where the Traccar server application is being run
#' @param traccar_user The administrator's username for the Traccar server application
#' @param traccar_pass The administrator's password for the Traccar server application
#' @return The function will send updates from the Shiny-generated MySQL database to the Traccar server via an HTTP post request
#' @export
#' @import dplyr
#' @import httr
#' @import yaml
#' @examples 
#' \dontrun{
#' # Read in credentials
#' credentials <- yaml::yaml.load_file('../credentials/credentials.yaml')
#'sync_workers(credentials = credentials)
#'}

sync_workers <- function(credentials = NULL,
                         delete_from_traccar = FALSE,
                         dbname,
                         host,
                         user,
                         pass,
                         port,
                         traccar_url,
                         traccar_user,
                         traccar_pass){
  # Check to see if there is a credentials file supplied
  # If not, use explicit arguments
  if(is.null(credentials)){
    credentials <- list(dbname = dbname,
                        host = host,
                        user = user,
                        pass = pass,
                        port = port,
                        traccar_url = traccar_url,
                        traccar_user = traccar_user,
                        traccar_pass = traccar_pass)
  } 
  
  # Get users data already registered on the traccar server
  in_shiny <- get_registered_workers(dbname = credentials$dbname, 
                                     host = credentials$host, 
                                     user = credentials$user, 
                                     pass = credentials$pass, 
                                     port = credentials$port)
  
  # Get users who have registered on the shiny app
  in_traccar <- get_traccar_data(url = credentials$traccar_url,
                                 user = credentials$traccar_user,
                                 pass = credentials$traccar_pass)
  
  # Message
  message('Workers enrolled:')
  message('---Via Shiny: ', nrow(in_shiny))
  message('---In Traccar: ', nrow(in_traccar))
  
  # Define a subset of those that are already regiestered in the shiny
  # app, but not yet registered on the traccar server
  need_to_register <- in_shiny %>%
    filter(!as.numeric(as.character(id)) %in% as.numeric(as.character(in_traccar$uniqueId)))
  
  # Loop through each person and register on traccar
  if(nrow(need_to_register) > 0){
    go <- TRUE
    message('Porting data from the Shiny registration app to the Traccar server:')
  } else {
    go <- FALSE
  }
  if(go){
    for(i in 1:nrow(need_to_register)){
      this_row <- need_to_register[i,]
      this_name <- paste0(this_row$nombre, ' ', this_row$apellido)
      this_id <- this_row$id
      message('---Adding worker ', i, ': ', 
              need_to_register$nombre, ' ',
              need_to_register$apellido, ' ',
              '(id: ', need_to_register$id, '\n)')
      post_traccar_data(user = credentials$traccar_user,
                        pass = credentials$traccar_pass,
                        name = this_name,
                        unique_id = this_id,
                        url = credentials$traccar_url)
    }
  }
  
  # Carry out deletions if necessary
  if(delete_from_traccar){
    message('Delete functionality not yet implemented')
    delete_these <- in_traccar %>%
      filter(!as.numeric(as.character(uniqueId)) %in% as.numeric(as.character(in_shiny$id)))
    if(nrow(delete_these) > 0){
      message('For now, you can manually delete the following users from the web interface at ',
              credentials$traccar_url)
    } else {
      message('But don\'t worry, there are no users to delete anyway')
    }
  }
  out <- list(added = need_to_register)
  if(delete_from_traccar){
    out$deleted <- tibble()
  }
}


