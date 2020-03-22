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
#' @return An html will be written
#' @importFrom rmarkdown render
#' @export

generate_report <- function(unique_id = NULL,
                            credentials_file = NULL,
                           date = NULL,
                           output_dir = NULL,
                           output_file = NULL){
  
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

  # Combine parameters into a list, so as to pass to Rmd
  parameters <- list(unique_id = unique_id,
                     credentials_file = credentials_file,
                     date = date)

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
