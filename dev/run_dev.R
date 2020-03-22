  # Set options here
  options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode
  
  # Detach all loaded packages and clean your environment
  golem::detach_all_attached()
  # rm(list=ls(all.names = TRUE))
  
  # Document and reload your package
  # remove.packages('bcv')
  # devtools::install() # if underlying changes to system files
  golem::document_and_reload()
  
  # Run the application
  app(credentials = yaml::yaml.load_file('credentials/credentials.yaml'))
  
