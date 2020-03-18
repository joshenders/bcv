library(RMySQL)
library(dplyr)
library(DBI)
creds <- list(dbname = 'bcvdb',
              host = '3.130.255.155',
              user = 'bcvuser',
              pass = 'bcvpass')
# mysql -h 3.130.255.155 -u bcvuser -p
# <bcvpass>

# Open Connection
con <- DBI::dbConnect(drv = RMySQL::MySQL(),
                         dbname = creds$dbname,
                         host = creds$host,
                         user = creds$user,
                         pass = creds$pass,
                         port = 3306)

# Write a table for users
df <- tibble(nombre = 'Joe',
             apellido = 'Brew',
             tel = '+34 666 66 80 86',
             email = 'joe@databrew.cc', 
             lugar = 'Casa, Santa Coloma de Queralt',
             id = 1)
RMySQL::dbWriteTable(conn = con,
                     name = 'users',
                     value = df)

# Write a table for cases
cases <- tibble(case_id = 0,
                case_name = 'Joe Brew',
                case_date_symptoms = as.Date('2020-03-15'),
                case_date_dx = as.Date('2020-03-16'))
RMySQL::dbWriteTable(conn = con,
                     name = 'cases',
                     value = cases)


RMySQL::dbDisconnect(conn = con)
