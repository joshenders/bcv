# This script updates the traccar server with people
# who have registered in the shiny server
# Before running it, create a file in credentials/credentials.yaml with the followint parameters:
# dbname
# host
# user
# pass
# port
# traccar_url
# traccar_user
# traccar_pass

library(rtraccar) # devtools::install_github('databrew/rtraccar')
library(yaml)
library(dplyr)

# Read in credentials
credentials <- yaml::yaml.load_file('../credentials/credentials.yaml')

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

# Define a subset of those that are already regiestered in the shiny
# app, but not yet registered on the traccar server
need_to_register <- in_shiny %>%
  filter(!as.numeric(as.character(id)) %in% as.numeric(as.character(in_traccar$uniqueId)))

# Loop through each person and register on traccar
if(nrow(need_to_register)){
  go <- TRUE
} else {
  go <- FALSE
}
if(go){
  for(i in 1:nrow(need_to_register)){
    this_row <- need_to_register[i,]
    this_name <- paste0(this_row$nombre, ' ', this_row$apellido)
    this_id <- this_row$id
    message('Trying to add worker ', i, ':')
    print(need_to_register)
    post_traccar_data(user = credentials$traccar_user,
                      pass = credentials$traccar_pass,
                      name = this_name,
                      unique_id = this_id,
                      url = credentials$traccar_url)
  }
  
}
