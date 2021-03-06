#' Generate report
#'
#' Generate report following a positive case
#' @param unique_id The unique ID of the case
#' @param date A date to be printed on the report. If \code{NULL} (the
#' default), the current date will be used
#' @param credentials_file Path to credentials file
#' @param output_dir The directory to which the file should be written. If
#' \code{NULL} (the default), the current working directory will be used.
#' @param output_file The name of the file to be written.
#' @param which_day A date of a vector of dates to view on the report
#' @param num_previous_days A single integer to specify how many previous days to view including which_day variable
#' @return An html will be written
#' @importFrom rmarkdown render
#' @export

generate_report <- function(unique_id = NULL,
                            credentials_file = NULL,
                           date = NULL,
                           output_dir = NULL,
                           output_file = NULL,
                           which_day = NULL,
                           num_previous_days= NULL){
  
  # Credentials handling
  if(is.null(credentials_file)){
    stop('"credentials_file" must be supplied. This should be a path to a credentials.yaml file')
  }
  
  # Unique ID handling
  if(is.null(unique_id)){
    stop('A unique_id is required.')
  }

  # If no output directory, make current wd
  if(is.null(output_dir)){
    output_dir <- getwd()
  }

  # If no output file, just concat report and id
  if(is.null(output_file)){
    output_file <- paste0('report_', unique_id, '.html')
  }
  
  # If not date, use today's
  if(is.null(date)){
    date <- Sys.Date()
  }
  
  # If not which_day, use today's
  if(is.null(which_day)){
    which_day <- Sys.Date()
  }
  
  # If not num_previous_days, use 7 (one week)
  if(is.null(num_previous_days)){
     num_previous_days = 7
  }

  # Combine parameters into a list, so as to pass to Rmd
  parameters <- list(unique_id = unique_id,
                     credentials_file = paste0(getwd(), '/', credentials_file),
                     date = date,
                     which_day = which_day,
                     num_previous_days = num_previous_days)

  # Find location the rmd to knit
  file_to_knit <-
    system.file('rmd/report.Rmd',
                package='bcv')

  # Knit file
  rmarkdown::render(file_to_knit,
                    output_dir = output_dir,
                    output_file = output_file,
                    params = parameters)
}
