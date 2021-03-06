
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bcv

<!-- badges: start -->

<!-- badges: end -->

## Install

Install the `bcv` package from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("databrew/bcv")
```

## Example

Here is how to use it.

### Populate a credentials file

Create a `credentials.yaml` file with the following parameters:

    dbname: 
    host: 
    user: 
    pass:
    port: 
    traccar_url: 
    traccar_user: 
    traccar_pass: 

### Run code

``` r
library(bcv)
library(yaml)

# Read in credentials
credentials <- yaml::yaml.load_file('../credentials/credentials.yaml')

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

# Get locations for one person based on their worker ID
location_history <- get_positions_from_unique_id(url = credentials$traccar_url,
                             user = credentials$traccar_user,
                             pass = credentials$traccar_pass,
                             unique_id = 1)
```

``` r
# Generate a report for a worker who tests positive
# Note: for this function, supply path to credentials, rather than a credentials list
generate_report(unique_id = 1,
                credentials_file = '../credentials/credentials.yaml',
                output_dir = '~/Desktop',
                output_file = 'example_report.html')
```

# How to update the shiny app

    sudo su - -c "R -e \"remove.packages('bcv')\"" ; sudo su - -c "R -e \"devtools::install_github('databrew/bcv', dependencies = TRUE, force = TRUE)\""; sudo systemctl restart shiny-server
