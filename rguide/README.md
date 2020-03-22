
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
#> ---Via Shiny: 117
#> ---In Traccar: 108
#> Porting data from the Shiny registration app to the Traccar server:
#> ---Adding worker 1: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 2: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 3: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 4: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 5: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 6: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 7: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 8: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful
#> ---Adding worker 9: María de la eñaMargaritaMargaritaDanielMartaPaulaIrenePedro JuanMarta Barranqueo morenoGonzálezGonzálezFernandezPomboGuardia MartínezGuerrero LópezReyes MolinaPombo (id: 112113114115116117118119120)
#> Status code is 200, successful

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
#> Warning: 170 parsing failures.
#> row col   expected     actual         file
#>   1  -- 19 columns 18 columns <raw vector>
#>   2  -- 19 columns 18 columns <raw vector>
#>   3  -- 19 columns 18 columns <raw vector>
#>   4  -- 19 columns 18 columns <raw vector>
#>   5  -- 19 columns 18 columns <raw vector>
#> ... ... .......... .......... ............
#> See problems(...) for more details.

# Generate a report for a worker who tests positive
# Note: for this function, supply path to credentials, rather than a credentials list
generate_report(unique_id = 1,
                credentials_file = '../credentials/credentials.yaml',
                output_dir = '~/Desktop',
                output_file = 'example_report.html')
#> 
#> 
#> processing file: report.Rmd
#>   |                                                                              |                                                                      |   0%  |                                                                              |.........                                                             |  12%
#>   ordinary text without R code
#> 
#>   |                                                                              |..................                                                    |  25%
#> label: setup (with options) 
#> List of 1
#>  $ include: logi FALSE
#> 
#>   |                                                                              |..........................                                            |  38%
#>   ordinary text without R code
#> 
#>   |                                                                              |...................................                                   |  50%
#> label: unnamed-chunk-3
#> No credentials file found at ../credentials/credentials.yaml
#> Using the following credentials:
#>   |                                                                              |............................................                          |  62%
#>   ordinary text without R code
#> 
#>   |                                                                              |....................................................                  |  75%
#> label: unnamed-chunk-4
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
#> Warning: 170 parsing failures.
#> row col   expected     actual         file
#>   1  -- 19 columns 18 columns <raw vector>
#>   2  -- 19 columns 18 columns <raw vector>
#>   3  -- 19 columns 18 columns <raw vector>
#>   4  -- 19 columns 18 columns <raw vector>
#>   5  -- 19 columns 18 columns <raw vector>
#> ... ... .......... .......... ............
#> See problems(...) for more details.
#>   |                                                                              |.............................................................         |  88%
#>   ordinary text without R code
#> 
#>   |                                                                              |......................................................................| 100%
#> label: unnamed-chunk-5
#> Assuming "longitude" and "latitude" are longitude and latitude, respectively
#> output file: report.knit.md
#> /usr/lib/rstudio/bin/pandoc/pandoc +RTS -K512m -RTS report.utf8.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash+smart --output /home/joebrew/Desktop/example_report.html --email-obfuscation none --self-contained --standalone --section-divs --template /home/joebrew/R/x86_64-pc-linux-gnu-library/3.6/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --variable 'theme:bootstrap' --include-in-header /tmp/Rtmp0NoMM2/rmarkdown-str1c7d6ec55594.html --mathjax --variable 'mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --lua-filter /home/joebrew/R/x86_64-pc-linux-gnu-library/3.6/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /home/joebrew/R/x86_64-pc-linux-gnu-library/3.6/rmarkdown/rmd/lua/latex-div.lua
#> 
#> Output created: /home/joebrew/Desktop/example_report.html
```
