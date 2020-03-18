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

# Write a table
df <- tibble(nombre = 'Joe',
             apellido = 'Brew',
             tel = '+34 666 66 80 86',
             email = 'joe@databrew.cc', 
             lugar = 'Casa, Santa Coloma de Queralt',
             id = 1)

RMySQL::dbWriteTable(conn = con,
                     name = 'users',
                     value = df)

RMySQL::dbDisconnect(conn = con)
