library(shiny)
library(shinyMobile)
library(dplyr)
library(RMySQL)
library(DBI)

# Connect to database
con <- DBI::dbConnect(drv = RMySQL::MySQL(),
                         dbname = creds$dbname,
                         host = creds$host,
                         user = creds$user,
                         pass = creds$pass,
                         port = 3306)


# Define function for registering workers
register <- function(nombre,
                     apellido,
                     tel,
                     email, 
                     lugar){
  df <- tibble(nombre,
               apellido,
               tel,
               email, 
               lugar)
  # Get new number
  old <- dbGetQuery(conn = con,
                             "select MAX(id) FROM users;")
  new <- as.numeric(old) +1
  df$id <- new
  
  try_add <- 
    dbWriteTable(conn = con,
                 name = 'users',
                 value = df,
                 append = TRUE)
   if(try_add){
     return(new)
   }
}

ui <- f7Page(
  init = f7Init(
    skin = 'ios', #  c("ios", "md", "auto", "aurora"),
    theme = 'light', #c("dark", "light"),
    filled = TRUE
  ),
  title = "BCV: Inscripción",
  f7SingleLayout(
    navbar = f7Navbar(
      title = "BCV: Inscripción",
      hairline = TRUE,
      shadow = TRUE
    ),
    toolbar = f7Toolbar(
      position = "bottom",
      f7Link(label = "Databrew", src = "https://databrew.cc", external = TRUE),
      f7Link(label = "BCV", src = "https://github.com/databrew/bcv", external = TRUE)
    ),
    # main content
    f7Shadow(
      intensity = 10,
      hover = TRUE,
      f7Card(
        shinyMobile::f7Text('nombre', 'Nombre'),
        shinyMobile::f7Text('apellido', 'Apellido'),
        shinyMobile::f7Text('tel', 'Teléfono'),
        shinyMobile::f7Text('email', 'E-mail'),
        shinyMobile::f7Text('lugar', 'Lugar de trabajo'),
        br(),
        column(12,
               align = 'center',
               actionButton('register', 'HAZ CLICK AQUÍ PARA DAR DE ALTA'),
               h1(textOutput('number_text')),
               uiOutput('done_text'))
        
      )
    )
  )
)

server <- function(input, output, session) {
  
  done <- reactiveVal(value = FALSE)
  the_text <- reactiveVal(value = '')
  the_number <- reactiveVal(value = NA)
  observeEvent(input$register, {
    
    # Check status
    ok <- FALSE
    nombre <- input$nombre
    apellido <- input$apellido
    tel <- input$tel
    email <- input$email
    lugar <- input$lugar
    is_empty <- function(x){nchar(x) < 2}
    if(!is_empty(nombre)){
      if(!is_empty(apellido)){
        if(!is_empty(tel)){
          if(!is_empty(email)){
            if(!is_empty(lugar)){
              ok <- TRUE
            }
          }
        }
      }
    }
    
    if(ok){
      done(TRUE)
    }
    
    # Update done text
    is_done <- done()
    if(is_done){
      the_text('Ahora haz clic aquí para instrucciones para descargar la aplicación en tu móvil')
    } else {
      the_text('Hay que llenar todos los campos para poder registrar.')
    }
    
    # Assign number
    if(is_done){
      x <- register(nombre,
                    apellido,
                    tel,
                    email, 
                    lugar)
      the_number(x)
    }
    
    
  })
  
  output$done_text <- renderUI({
    out <- the_text()
    # h1(span('', style="color:red")
# ,)
    h1(a(out, href = paste0('https://github.com/databrew/bcv/blob/master/guias/phone_documentation.md#installation')))
  })

  output$number_text <- renderText({
    tn <- the_number()
    if(is.na(tn)){
      return(NULL)
    } else {
      return(paste0('Tu número de identificación es: ',
                    tn))
    }
  })
  
  
}

onStop(function() {
  dbDisconnect(con)
})

shinyApp(ui = ui, server = server)
