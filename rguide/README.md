
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
#> Workers enrolled:
#> ---Via Shiny: 94
#> ---In Traccar: 94

# Get list of registered workers on the server which syncs with the
# shiny registration app
workers <- bcv::get_registered_workers(dbname = credentials$dbname,
                                       host = credentials$host,
                                       user = credentials$user,
                                       pass = credentials$pass)

# Get list of workers whose info has been passed to the traccar server
traccar <- bcv::get_traccar_data(url = credentials$traccar_url,
                                 user = credentials$traccar_user,
                                 pass = credentials$traccar_pass)

# Get locations for one person based on their worker ID
location_history <- get_positions_from_unique_id(url = credentials$traccar_url,
                             user = credentials$traccar_user,
                             pass = credentials$traccar_pass,
                             unique_id = 1)
#> Warning: Missing column names filled in: 'X19' [19]
#> Parsed with column specification:
#> cols(
#>   accuracy = col_double(),
#>   address = col_character(),
#>   altitude = col_double(),
#>   course = col_double(),
#>   deviceId = col_double(),
#>   deviceTime = col_datetime(format = ""),
#>   fixTime = col_datetime(format = ""),
#>   id = col_double(),
#>   latitude = col_double(),
#>   longitude = col_double(),
#>   network = col_logical(),
#>   outdated = col_character(),
#>   protocol = col_datetime(format = ""),
#>   serverTime = col_double(),
#>   speed = col_character(),
#>   type = col_logical(),
#>   valid = col_character(),
#>   attributes = col_logical(),
#>   X19 = col_character()
#> )
#> Warning: 146 parsing failures.
#> row col   expected     actual         file
#>   1  -- 19 columns 18 columns <raw vector>
#>   2  -- 19 columns 18 columns <raw vector>
#>   3  -- 19 columns 18 columns <raw vector>
#>   4  -- 19 columns 18 columns <raw vector>
#>   5  -- 19 columns 18 columns <raw vector>
#> ... ... .......... .......... ............
#> See problems(...) for more details.
```
