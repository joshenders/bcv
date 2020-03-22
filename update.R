library(yaml)
library(bcv)


# Read in credentials
credentials <- yaml::yaml.load_file('credentials/credentials.yaml')

# Syncronize between the worker registrationd data (collected via the shiny app)
# and the traccar server app
sync_workers(credentials = credentials)

# Get list of registered workers on the server which syncs with the
# shiny registration app
workers <- bcv::get_registered_workers(dbname = credentials$dbname,
                                       host = credentials$host,
                                       user = credentials$user,
                                       pass = credentials$pass)

# Or, get data for just one specified worker
worker1 <- get_registered_workers(unique_id = 1,
                                  dbname = credentials$dbname,
                                  host = credentials$host,
                                  user = credentials$user,
                                  pass = credentials$pass)

# Get list of workers whose info has been passed to the traccar server
traccar <- bcv::get_traccar_data(url = credentials$traccar_url,
                                 user = credentials$traccar_user,
                                 pass = credentials$traccar_pass)

# Get list of registered cases
cases <- get_cases(dbname = credentials$dbname,
                   host = credentials$host,
                   user = credentials$user,
                   pass = credentials$pass)

# Get case details of just 1 id
case1 <- get_cases(unique_id = 1,
                   dbname = credentials$dbname,
                   host = credentials$host,
                   user = credentials$user,
                   pass = credentials$pass)

message('CASES ARE:')
print(cases)

