#' Run the Shiny Application
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(credentials, ...) {
  golem::with_golem_options(
    app = app(credentials = credentials),
    golem_opts = list(...)
  )
}

